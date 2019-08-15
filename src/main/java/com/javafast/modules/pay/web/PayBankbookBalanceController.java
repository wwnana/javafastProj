package com.javafast.modules.pay.web;

import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.ConstraintViolationException;

import org.apache.shiro.authz.annotation.Logical;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.math.BigDecimal;

import com.google.common.collect.Lists;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.MyBeanUtils;
import com.javafast.api.pay.util.BankbookConstants;
import com.javafast.common.config.Global;
import com.javafast.common.persistence.Page;
import com.javafast.common.web.BaseController;
import com.javafast.common.utils.StringUtils;
import com.javafast.common.utils.excel.ExportExcel;
import com.javafast.common.utils.excel.ImportExcel;
import com.javafast.modules.pay.entity.PayBankbookBalance;
import com.javafast.modules.pay.entity.PayBankbookJournal;
import com.javafast.modules.pay.service.PayBankbookBalanceService;
import com.javafast.modules.pay.service.PayBankbookJournalService;
import com.javafast.modules.sys.entity.SysAccount;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.service.SysAccountService;
import com.javafast.modules.sys.service.UserService;
import com.javafast.modules.sys.utils.UserUtils;

/**
 * 电子钱包余额Controller
 * @author javafast
 * @version 2018-05-15
 */
@Controller
@RequestMapping(value = "${adminPath}/pay/payBankbookBalance")
public class PayBankbookBalanceController extends BaseController {

	@Autowired
	private PayBankbookBalanceService payBankbookBalanceService;
	
	@Autowired
	private PayBankbookJournalService payBankbookJournalService;
	
	@Autowired
	private SysAccountService sysAccountService;
	
	@Autowired
	private UserService userService;
	
	@ModelAttribute
	public PayBankbookBalance get(@RequestParam(required=false) String id) {
		PayBankbookBalance entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = payBankbookBalanceService.get(id);
		}
		if (entity == null){
			entity = new PayBankbookBalance();
		}
		return entity;
	}
	
	/**
	 * 企业账户资金信息
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "sysAccountBankbokInfo")
	public String account(PayBankbookJournal payBankbookJournal, HttpServletRequest request, HttpServletResponse response, Model model) {
		
		//更新用户数
		sysAccountService.updateUserNum(new SysAccount(UserUtils.getSysAccount().getId()));
		
		SysAccount sysAccount = UserUtils.getSysAccount();
		model.addAttribute("sysAccount", sysAccount);
		
		PayBankbookBalance payBankbookBalance = payBankbookBalanceService.get(UserUtils.getSysAccount().getId());
		model.addAttribute("payBankbookBalance", payBankbookBalance);
		
		payBankbookJournal.setAccountId(UserUtils.getSysAccount().getId());
		Page<PayBankbookJournal> page = payBankbookJournalService.findPage(new Page<PayBankbookJournal>(request, response), payBankbookJournal); 
		model.addAttribute("page", page);
		
		return "modules/pay/sysAccountBankbokInfo";
	}
	
	/**
	 * 月结算
	 * @return
	 */
	@RequestMapping(value = "monthSettleAccounts")
	public String monthSettleAccounts() {
		
		SysAccount conSysAccount = new SysAccount();
		conSysAccount.setBeginCreateDate(DateUtils.getDayAfterN(-3650));//获取10年之前的时间
		conSysAccount.setEndCreateDate(DateUtils.getDayAfterN(-30));//获取30天之前的时间
		conSysAccount.setStatus("0");
		List<SysAccount> SysAccountList = sysAccountService.findList(conSysAccount);
		for(SysAccount sysAccount : SysAccountList){
			
			System.out.println(sysAccount.getName());
			
			//更新用户数
			sysAccountService.updateUserNum(new SysAccount(sysAccount.getId()));
			
			//大于2人的收费
			if(sysAccount.getNowUserNum() > 2){
				
				sysAccount = sysAccountService.get(sysAccount.getId());
				String accountId = sysAccount.getId();
				
				//计算需要扣费金额
				BigDecimal price = new BigDecimal(30);
				BigDecimal money = new BigDecimal(sysAccount.getNowUserNum()).multiply(price);
				
				//周期
				String month = DateUtils.getYear() + DateUtils.getMonth(); //年份+月份，格式：yyyy-MM
				
				String moneyType = BankbookConstants.MONEY_TYPE12;
				String notes = "账单支付";
				String uniqueCode = month +"_"+ sysAccount.getId();
				User createBy = UserUtils.getUser();
				
				try{
					
					String code = payBankbookJournalService.PayBankbookWithdraw(money, moneyType, notes, uniqueCode, createBy, accountId);
					
					//成功
					if(BankbookConstants.SUCCESS_CODE0.equals(code)){
						sysAccount.setPayStatus("1");
					}else{
						//欠费
						sysAccount.setPayStatus("2");
						//停用短信
						sysAccount.setSmsStatus("0");
					}
					
					sysAccountService.save(sysAccount);
				}catch(Exception e){			
					e.printStackTrace();
				}
			}
		}
		
		return "redirect:"+Global.getAdminPath()+"/pay/payBankbookBalance/?repage";
	}
	
	/**
	 * 电子钱包余额列表页面
	 */
	@RequiresPermissions("pay:payBankbookBalance:list")
	@RequestMapping(value = {"list", ""})
	public String list(PayBankbookBalance payBankbookBalance, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<PayBankbookBalance> page = payBankbookBalanceService.findPage(new Page<PayBankbookBalance>(request, response), payBankbookBalance); 
		model.addAttribute("page", page);
		return "modules/pay/payBankbookBalanceList";
	}

	/**
	 * 编辑电子钱包余额表单页面
	 */
	@RequiresPermissions(value={"pay:payBankbookBalance:view","pay:payBankbookBalance:add","pay:payBankbookBalance:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(PayBankbookBalance payBankbookBalance, Model model) {
		model.addAttribute("payBankbookBalance", payBankbookBalance);
		return "modules/pay/payBankbookBalanceForm";
	}
	
	/**
	 * 查看电子钱包余额页面
	 */
	@RequiresPermissions(value="pay:payBankbookBalance:view")
	@RequestMapping(value = "view")
	public String view(PayBankbookBalance payBankbookBalance, Model model) {
		model.addAttribute("payBankbookBalance", payBankbookBalance);
		return "modules/pay/payBankbookBalanceView";
	}

	/**
	 * 保存电子钱包余额
	 */
	@RequiresPermissions(value={"pay:payBankbookBalance:add","pay:payBankbookBalance:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(PayBankbookBalance payBankbookBalance, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, payBankbookBalance)){
			return form(payBankbookBalance, model);
		}
		
		try{
		
			if(!payBankbookBalance.getIsNewRecord()){//编辑表单保存				
				PayBankbookBalance t = payBankbookBalanceService.get(payBankbookBalance.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(payBankbookBalance, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				payBankbookBalanceService.save(t);//保存
			}else{//新增表单保存
				payBankbookBalanceService.save(payBankbookBalance);//保存
			}
			addMessage(redirectAttributes, "保存电子钱包余额成功");
		}catch(Exception e){			
			e.printStackTrace();
			addMessage(redirectAttributes, "保存电子钱包余额失败");
		}finally{
			return "redirect:"+Global.getAdminPath()+"/pay/payBankbookBalance/?repage";
		}
	}
	
	/**
	 * 删除电子钱包余额
	 */
	@RequiresPermissions("pay:payBankbookBalance:del")
	@RequestMapping(value = "delete")
	public String delete(PayBankbookBalance payBankbookBalance, RedirectAttributes redirectAttributes) {
		payBankbookBalanceService.delete(payBankbookBalance);
		addMessage(redirectAttributes, "删除电子钱包余额成功");
		return "redirect:"+Global.getAdminPath()+"/pay/payBankbookBalance/?repage";
	}
	
	/**
	 * 批量删除电子钱包余额
	 */
	@RequiresPermissions("pay:payBankbookBalance:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			payBankbookBalanceService.delete(payBankbookBalanceService.get(id));
		}
		addMessage(redirectAttributes, "删除电子钱包余额成功");
		return "redirect:"+Global.getAdminPath()+"/pay/payBankbookBalance/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("pay:payBankbookBalance:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(PayBankbookBalance payBankbookBalance, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "电子钱包余额"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<PayBankbookBalance> page = payBankbookBalanceService.findPage(new Page<PayBankbookBalance>(request, response, -1), payBankbookBalance);
    		new ExportExcel("电子钱包余额", PayBankbookBalance.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出电子钱包余额记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/pay/payBankbookBalance/?repage";
    }

	/**
	 * 导入Excel数据

	 */
	@RequiresPermissions("pay:payBankbookBalance:import")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<PayBankbookBalance> list = ei.getDataList(PayBankbookBalance.class);
			for (PayBankbookBalance payBankbookBalance : list){
				try{
					payBankbookBalanceService.save(payBankbookBalance);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条电子钱包余额记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条电子钱包余额记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入电子钱包余额失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/pay/payBankbookBalance/?repage";
    }
	
	/**
	 * 下载导入电子钱包余额数据模板
	 */
	@RequiresPermissions("pay:payBankbookBalance:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "电子钱包余额数据导入模板.xlsx";
    		List<PayBankbookBalance> list = Lists.newArrayList(); 
    		new ExportExcel("电子钱包余额数据", PayBankbookBalance.class, 2).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/pay/payBankbookBalance/?repage";
    }
	
	/**
	 * 电子钱包余额列表选择器
	 */
	@RequestMapping(value = "selectList")
	public String selectList(PayBankbookBalance payBankbookBalance, HttpServletRequest request, HttpServletResponse response, Model model) {		
        list(payBankbookBalance, request, response, model);
        return "modules/pay/payBankbookBalanceSelectList";
	}
	
}