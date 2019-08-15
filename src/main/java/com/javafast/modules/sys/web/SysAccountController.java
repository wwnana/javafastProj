package com.javafast.modules.sys.web;

import java.math.BigDecimal;
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
import org.hibernate.validator.constraints.Length;

import com.google.common.collect.Lists;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.MyBeanUtils;
import com.javafast.common.config.Global;
import com.javafast.common.persistence.Page;
import com.javafast.common.web.BaseController;
import com.javafast.common.utils.StringUtils;
import com.javafast.common.utils.excel.ExportExcel;
import com.javafast.common.utils.excel.ImportExcel;
import com.javafast.modules.pay.entity.PayBankbookBalance;
import com.javafast.modules.pay.service.PayBankbookBalanceService;
import com.javafast.modules.qws.utils.SuiteUtils;
import com.javafast.modules.sys.entity.SysAccount;
import com.javafast.modules.sys.service.SysAccountService;
import com.javafast.modules.sys.service.SystemService;
import com.javafast.modules.sys.service.UserService;
import com.javafast.modules.sys.utils.UserUtils;

/**
 * 企业帐户Controller
 */
@Controller
@RequestMapping(value = "${adminPath}/sys/sysAccount")
public class SysAccountController extends BaseController {

	@Autowired
	private SysAccountService sysAccountService;
	
	@Autowired
	PayBankbookBalanceService payBankbookBalanceService;
	
	@ModelAttribute
	public SysAccount get(@RequestParam(required=false) String id) {
		SysAccount entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = sysAccountService.get(id);
		}
		if (entity == null){
			entity = new SysAccount();
		}
		return entity;
	}
	
	/**
	 * 企业帐户列表页面
	 */
	@RequiresPermissions("sys:sysAccount:list")
	@RequestMapping(value = {"list", ""})
	public String list(SysAccount sysAccount, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<SysAccount> page = sysAccountService.findPage(new Page<SysAccount>(request, response), sysAccount); 
		model.addAttribute("page", page);
		return "modules/sys/sysAccountList";
	}

	/**
	 * 查看，增加，编辑企业帐户表单页面
	 */
	@RequiresPermissions(value={"sys:sysAccount:view","sys:sysAccount:add","sys:sysAccount:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(SysAccount sysAccount, Model model) {
		model.addAttribute("sysAccount", sysAccount);
		return "modules/sys/sysAccountForm";
	}

	/**
	 * 保存企业帐户
	 */
	@RequiresPermissions(value={"sys:sysAccount:add","sys:sysAccount:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(SysAccount sysAccount, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, sysAccount)){
			return form(sysAccount, model);
		}
		
		try{
		
			if(!sysAccount.getIsNewRecord()){//编辑表单保存				
				SysAccount t = sysAccountService.get(sysAccount.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(sysAccount, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				sysAccountService.save(t);//保存
			}else{//新增表单保存
				sysAccountService.save(sysAccount);//保存
			}
			addMessage(redirectAttributes, "保存企业帐户成功");
			return "redirect:"+Global.getAdminPath()+"/sys/sysAccount/?repage";
		}catch(Exception e){
			e.printStackTrace();
			addMessage(redirectAttributes, "保存企业帐户失败");
			return "redirect:"+Global.getAdminPath()+"/sys/sysAccount/?repage";
		}
	}
	
	/**
	 * 删除企业帐户
	 */
	@RequiresPermissions("sys:sysAccount:del")
	@RequestMapping(value = "delete")
	public String delete(SysAccount sysAccount, RedirectAttributes redirectAttributes) {
		sysAccountService.delete(sysAccount);
		addMessage(redirectAttributes, "删除企业帐户成功");
		return "redirect:"+Global.getAdminPath()+"/sys/sysAccount/?repage";
	}
	
	/**
	 * 批量删除企业帐户
	 */
	@RequiresPermissions("sys:sysAccount:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			sysAccountService.delete(sysAccountService.get(id));
		}
		addMessage(redirectAttributes, "删除企业帐户成功");
		return "redirect:"+Global.getAdminPath()+"/sys/sysAccount/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("sys:sysAccount:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(SysAccount sysAccount, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "企业帐户"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<SysAccount> page = sysAccountService.findPage(new Page<SysAccount>(request, response, -1), sysAccount);
    		new ExportExcel("企业帐户", SysAccount.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出企业帐户记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/sys/sysAccount/?repage";
    }

	/**
	 * 导入Excel数据

	 */
	@RequiresPermissions("sys:sysAccount:import")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<SysAccount> list = ei.getDataList(SysAccount.class);
			for (SysAccount sysAccount : list){
				try{
					sysAccountService.save(sysAccount);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条企业帐户记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条企业帐户记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入企业帐户失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/sys/sysAccount/?repage";
    }
	
	/**
	 * 下载导入企业帐户数据模板
	 */
	@RequiresPermissions("sys:sysAccount:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "企业帐户数据导入模板.xlsx";
    		List<SysAccount> list = Lists.newArrayList(); 
    		new ExportExcel("企业帐户数据", SysAccount.class, 2).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/sys/sysAccount/?repage";
    }
	
	/**
	 * 列表选择器
	 */
	@RequestMapping(value = "selectList")
	public String selectList(SysAccount sysAccount, HttpServletRequest request, HttpServletResponse response, Model model) {		
        list(sysAccount, request, response, model);
        return "modules/sys/sysAccount/sysAccountSelectList";
	}
	
	/**
	 * 批量启用
	 * @param ids
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions(value={"sys:sysAccount:add","sys:sysAccount:edit"},logical=Logical.OR)
	@RequestMapping(value = "useAll")
	public String useAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			
			SysAccount sysAccount = sysAccountService.get(id);
			sysAccount.setStatus("0");
			sysAccountService.updateStatus(sysAccount);
		}
		addMessage(redirectAttributes, "企业帐户启用成功");
		return "redirect:"+Global.getAdminPath()+"/sys/sysAccount/?repage";
	}
	
	/**
	 * 批量禁用
	 * @param ids
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions(value={"sys:sysAccount:add","sys:sysAccount:edit"},logical=Logical.OR)
	@RequestMapping(value = "unUseAll")
	public String unUseAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			
			SysAccount sysAccount = sysAccountService.get(id);
			sysAccount.setStatus("1");
			sysAccountService.updateStatus(sysAccount);
		}
		addMessage(redirectAttributes, "企业帐户禁用成功");
		return "redirect:"+Global.getAdminPath()+"/sys/sysAccount/?repage";
	}
	
	/**
	 * 批量停用短信
	 * @param ids
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions(value={"sys:sysAccount:add","sys:sysAccount:edit"},logical=Logical.OR)
	@RequestMapping(value = "unSmsAll")
	public String unSmsAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			
			SysAccount sysAccount = sysAccountService.get(id);
			sysAccount.setSmsStatus("0");
			sysAccountService.updateStatus(sysAccount);
		}
		addMessage(redirectAttributes, "停用短信成功");
		return "redirect:"+Global.getAdminPath()+"/sys/sysAccount/?repage";
	}
	
	/**
	 * 更新所有企业信息
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions(value={"sys:sysAccount:add","sys:sysAccount:edit"},logical=Logical.OR)
	@RequestMapping(value = "updateAllAccount")
	public String updateAllAccount(RedirectAttributes redirectAttributes) {
		
		try {
			
			List<SysAccount> accountList = sysAccountService.findList(new SysAccount());
			for(SysAccount sysAccount : accountList){
				
				sysAccountService.updateAccount(sysAccount);
			}
			
		addMessage(redirectAttributes, "更新所有企业信息成功");
		} catch (Exception e) {
			addMessage(redirectAttributes, "更新所有企业信息失败！失败信息："+e.getMessage());
		}
		
		return "redirect:"+Global.getAdminPath()+"/sys/sysAccount/?repage";
	}
	
	/**
	 * 授权API接口
	 * @param sysAccount
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("sys:sysAccount:edit")
	@RequestMapping(value = "createKeySecret")
	public String createKeySecret(SysAccount sysAccount, RedirectAttributes redirectAttributes) {
		
		try {
			
			SysAccount t = sysAccountService.get(sysAccount.getId());//从数据库取出记录的值
			
			String apiSecret = UserService.entryptPassword(String.valueOf((int) (Math.random() * 9000 + 100000))).substring(0,20);
			t.setApiSecret(apiSecret);
			sysAccountService.save(t);
			
			addMessage(redirectAttributes, "授权API接口成功");
		} catch (Exception e) {
			addMessage(redirectAttributes, "授权API接口成功失败信息："+e.getMessage());
		}
		
		return "redirect:"+Global.getAdminPath()+"/sys/sysAccount/?repage";
	}

	/**
	 * 基本设置
	 */
	@RequestMapping(value = "set")
	public String set(Model model) {
		
		//当前企业账号
		String accountId = UserUtils.getUser().getAccountId();
		
		//更新用户数
		sysAccountService.updateUserNum(new SysAccount(accountId));
		
		//查询
		SysAccount sysAccount = sysAccountService.get(accountId);
				
		model.addAttribute("sysAccount", sysAccount);
		return "modules/sys/sysAccountSet";
	}
	
	/**
	 * 保存设置
	 */
	@RequestMapping(value = "saveSet")
	public String saveSet(SysAccount sysAccount, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, sysAccount)){
			return form(sysAccount, model);
		}
		
		if (Global.isDemoMode()) {
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:"+Global.getAdminPath()+"/sys/sysAccount/set?repage";
		}
		
		try{
			
			SysAccount t = sysAccountService.get(UserUtils.getUser().getAccountId());		
			MyBeanUtils.copyBeanNotNull2Bean(sysAccount, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
			
			//开通短信提醒
			if("1".equals(t.getSmsStatus())){
				
				t.setSmsStatus("0");//默认不开通
				
				//开通条件：不欠费、首次开通余额大于299
				if(!"2".equals(t.getPayStatus())){//不欠费,状态2为欠费状态
					PayBankbookBalance payBankbookBalance = payBankbookBalanceService.get(t.getId());
					//余额大于299
					if(payBankbookBalance != null && payBankbookBalance.getBalance().compareTo(new BigDecimal(299)) == 1){
						t.setSmsStatus("1");
					}
				}
			}
			
			sysAccountService.save(t);//保存
			addMessage(redirectAttributes, "保存成功");
			return "redirect:"+Global.getAdminPath()+"/sys/sysAccount/set?repage";
		}catch(Exception e){
			e.printStackTrace();
			addMessage(redirectAttributes, "保存失败");
			return "redirect:"+Global.getAdminPath()+"/sys/sysAccount/set?repage";
		}
	}
	
	/**
	 * 获取企业微信的授权信息
	 * @param ids
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions(value={"sys:sysAccount:add","sys:sysAccount:edit"},logical=Logical.OR)
	@RequestMapping(value = "getPermanentInfoAll")
	public String getPermanentInfoAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			
			SuiteUtils.getPermanentInfo(id);
		}
		addMessage(redirectAttributes, "执行成功");
		return "redirect:"+Global.getAdminPath()+"/sys/sysAccount/?repage";
	}
}