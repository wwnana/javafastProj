package com.javafast.modules.hr.web;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.ConstraintViolationException;

import org.apache.shiro.authz.annotation.Logical;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.javafast.modules.hr.entity.HrResume;
import com.javafast.modules.hr.entity.HrTemplate;

import org.hibernate.validator.constraints.Length;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import java.math.BigDecimal;

import com.google.common.collect.Lists;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.JavaMailUtil;
import com.javafast.common.utils.MyBeanUtils;
import com.javafast.api.sms.utils.SmsUtils;
import com.javafast.common.config.Global;
import com.javafast.common.persistence.Page;
import com.javafast.common.web.BaseController;
import com.javafast.common.utils.StringUtils;
import com.javafast.common.utils.excel.ExportExcel;
import com.javafast.common.utils.excel.ImportExcel;
import com.javafast.modules.hr.entity.HrInterview;
import com.javafast.modules.hr.entity.HrOffer;
import com.javafast.modules.hr.service.HrOfferService;
import com.javafast.modules.hr.service.HrResumeService;
import com.javafast.modules.hr.service.HrTemplateService;
import com.javafast.modules.hr.utils.HrMailConfig;
import com.javafast.modules.hr.utils.ResumeLogUtils;
import com.javafast.modules.sys.utils.UserUtils;

/**
 * OFFERController
 * 
 * @author javafast
 * @version 2018-06-30
 */
@Controller
@RequestMapping(value = "${adminPath}/hr/hrOffer")
public class HrOfferController extends BaseController {

	@Autowired
	private HrOfferService hrOfferService;

	@Autowired
	private HrResumeService hrResumeService;
	
	@Autowired
	private HrTemplateService hrTemplateService;

	@ModelAttribute
	public HrOffer get(@RequestParam(required = false) String id) {
		HrOffer entity = null;
		if (StringUtils.isNotBlank(id)) {
			entity = hrOfferService.get(id);
		}
		if (entity == null) {
			entity = new HrOffer();
		}
		return entity;
	}

	/**
	 * OFFER列表页面
	 */
	@RequiresPermissions("hr:hrOffer:list")
	@RequestMapping(value = { "list", "" })
	public String list(HrOffer hrOffer, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<HrOffer> page = hrOfferService.findPage(new Page<HrOffer>(request, response), hrOffer);
		model.addAttribute("page", page);
		return "modules/hr/hrOfferList";
	}

	/**
	 * 查看OFFER页面
	 */
	@RequiresPermissions(value = { "hr:hrOffer:add", "hr:hrOffer:edit" }, logical = Logical.OR)
	@RequestMapping(value = "view")
	public String view(HrOffer hrOffer, Model model) {
		model.addAttribute("hrOffer", hrOffer);
		return "modules/hr/hrOfferView";
	}
	
	/**
	 * 编辑OFFER表单页面
	 */
	@RequiresPermissions(value = { "hr:hrOffer:view", "hr:hrOffer:add", "hr:hrOffer:edit" }, logical = Logical.OR)
	@RequestMapping(value = "form")
	public String form(HrOffer hrOffer, Model model) {

		//查询是否下发过offer
		List<HrOffer> hrOfferList = hrOfferService.findList(hrOffer);
		if(hrOfferList !=null && hrOfferList.size()>0){
			
			hrOffer = hrOfferList.get(0);
			model.addAttribute("hrOffer", hrOffer);
			return "modules/hr/hrOfferForm";
		}
		
		if (hrOffer.getHrResume() != null) {
			HrResume hrResume = hrResumeService.get(hrOffer.getHrResume().getId());
			hrOffer.setHrResume(hrResume);
			hrOffer.setPosition(hrResume.getPosition());
			hrOffer.setLinkMan(UserUtils.getUser().getName());
			hrOffer.setLinkPhone(UserUtils.getUser().getMobile());
		}
		
		if(hrOffer.getHrResume().getMail() == null){
			model.addAttribute("简历邮箱不能为空！");
			return "redirect:" + Global.getAdminPath() + "/hr/hrResume/index?id=" + hrOffer.getHrResume().getId();
		}
		
		model.addAttribute("hrOffer", hrOffer);
		return "modules/hr/hrOfferForm";
	}
	
    /**
     * 预览
     * @param hrOffer
     * @param templateId
     * @param request
     * @param model
     * @param redirectAttributes
     * @return
     */
    @RequestMapping(value = "preview")
    public String save(HrOffer hrOffer, String templateId, HttpServletRequest request, Model model, RedirectAttributes redirectAttributes) {
        if (!beanValidator(model, hrOffer)) {
            return form(hrOffer, model);
        }
    	
    	try {
    		
    		HrTemplate hrTemplate = null;
    		if (hrOffer.getHrResume() != null) {
                HrResume hrResume = hrResumeService.get(hrOffer.getHrResume().getId());
                hrOffer.setHrResume(hrResume);
            }
    			
    		//如果指定了模板
    		if(StringUtils.isNotBlank(templateId)){
    			hrTemplate = hrTemplateService.get(templateId);
    		}else{
    			//查询最匹配的模板
        		HrTemplate conHrTemplate = new HrTemplate();
        		conHrTemplate.setType("1");
            	List<HrTemplate> hrTemplateList = hrTemplateService.findList(conHrTemplate);
            	if(hrTemplateList != null){
            		hrTemplate = hrTemplateList.get(0);
            	}
    		}
    			
        	if(hrTemplate != null){
        		
        		String content = hrTemplate.getContent().replace("#姓名#", hrOffer.getHrResume().getName())
        				.replace("#入职部门#", hrOffer.getDepartment()).replace("#入职岗位#", hrOffer.getPosition())
        				.replace("#入职时间#", DateUtils.formatDate(hrOffer.getReportDate(), "yyyy-MM-dd HH:mm"))
        				.replace("#入职联系人#", hrOffer.getLinkMan())
        				.replace("#联系人电话#", hrOffer.getLinkPhone())
        				.replace("#公司地址#", hrOffer.getAddress())
        				.replace("#试用期#", hrOffer.getProbationPeriod()+"")
        				.replace("#试用期工资#", hrOffer.getProbationSalaryBase()+"")
        				.replace("#转正工资#", hrOffer.getFormalSalaryBase()+"")
        				.replace("#薪酬备注#", hrOffer.getSalaryRemarks())
        				.replace("#offer有效期#", hrOffer.getValidityPeriod()+"")
        				+"<a style=\"color:#ffffff;background-color: #27c24c;padding: 8px 20px;border-radius: 3px;margin-right: 15px;\" href=\""+Global.getConfig("webSite")+Global.getConfig("adminPath")+"/hr/hrOffer/receive?id="+hrOffer.getId()+"&status=2\">接受</a>"
        				+"<a style=\"color:#ffffff;background-color: #f05050;padding: 8px 20px;border-radius: 3px;margin-right: 15px;\" href=\""+Global.getConfig("webSite")+Global.getConfig("adminPath")+"/hr/hrOffer/receive?id="+hrOffer.getId()+"&status=3\">拒绝</a>";
            	
        		if(StringUtils.isNotBlank(hrOffer.getOfferFile())){
        			String fileName = hrOffer.getOfferFile().substring(hrOffer.getOfferFile().lastIndexOf("/")+1);
        			content = content.replace("#附件#", "<br><a href=\""+ Global.getConfig("webSite") + hrOffer.getOfferFile()+"\" download=\""+fileName+"\" target=\"_blank\">"+fileName+"</a>");
        			System.out.println("<a href=\""+ Global.getConfig("webSite") + hrOffer.getOfferFile()+"\">"+fileName+"</a>");
        		}else{
        			content = content.replace("#附件#", "<br>无");
        		}
        		hrOffer.setContent(content);
            	model.addAttribute("hrOffer", hrOffer);
            	return "modules/hr/hrOfferPreviewForm";
        	}
    	} catch (Exception e) {
    		e.printStackTrace();
        }
    	return "modules/hr/hrOfferForm";
	}

	/**
	 * 保存OFFER
	 */
	@RequiresPermissions(value = { "hr:hrOffer:add", "hr:hrOffer:edit" }, logical = Logical.OR)
	@RequestMapping(value = "save")
	public String save(HrOffer hrOffer, HttpServletRequest request, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, hrOffer)) {
			return form(hrOffer, model);
		}

		if(Global.isDemoMode()){
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:" + Global.getAdminPath() + "/hr/hrResume/index?id=" + hrOffer.getHrResume().getId();
		}
		
		try {
			
			// 状态(0未发送， 1：已发送，2：已接受, 3：已拒绝)
			hrOffer.setStatus("0");

			if (!hrOffer.getIsNewRecord()) {// 编辑表单保存
				HrOffer t = hrOfferService.get(hrOffer.getId());// 从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(hrOffer, t);// 将编辑表单中的非NULL值覆盖数据库记录中的值
				hrOfferService.save(t);// 保存
			} else {// 新增表单保存
				hrOfferService.save(hrOffer);// 保存
			}
			
			HrResume hrResume = hrResumeService.get(hrOffer.getHrResume().getId());
            // 更新当前环节：0：简历，1：面试，2：录用：3：入职：4： 简历库
            hrResume.setCurrentNode("2");
            hrResumeService.save(hrResume);
            
            //发送邮件
            String isEmailMsg = request.getParameter("isEmailMsg");
            if ("1".equals(isEmailMsg)) {
            	
            	//邮件接收人
            	String toMail = hrResume.getMail();
            	//邮件内容
            	String content = request.getParameter("content");
            	System.out.println("邮件内容:"+content);
            	
            	//发送邮件的方法
                JavaMailSenderImpl mailSender = JavaMailUtil.getSimpleMailSend(HrMailConfig.EMAIL_NAME, HrMailConfig.EMAIL_PASSWORD, HrMailConfig.SMTP, HrMailConfig.PORT);
                JavaMailUtil.sendHtmlMail(mailSender, HrMailConfig.FROM_EMAIL, toMail, "欢迎加入" + hrOffer.getCompany(), content);
                logger.info("发送OFFER邮件");
            }
			
            //发送短信
            String isSmsMsg = request.getParameter("isSmsMsg");
            if ("1".equals(isSmsMsg)) {
            	SmsUtils.sendOfferSms(hrResume.getMobile(), hrResume.getName(), hrOffer.getCompany(), hrResume.getMail());
            }
			
			// 状态(0未发送， 1：已发送，2：已接受, 3：已拒绝)
			hrOffer.setStatus("1");
			hrOfferService.save(hrOffer);// 保存

			// 记录日志
			String logNote = "聘用职位：" + hrOffer.getPosition()+"<br>报到时间："+DateUtils.formatDate(hrOffer.getReportDate(), "yyyy-MM-dd HH:mm");
			ResumeLogUtils.addResumeLog(hrOffer.getHrResume().getId(), ResumeLogUtils.RESUME_ACTION_TYPE_OFFER, logNote);

			addMessage(redirectAttributes, "发送OFFER成功");
		} catch (Exception e) {
			e.printStackTrace();
			addMessage(redirectAttributes, "发送OFFER失败");
		} finally {
			return "redirect:" + Global.getAdminPath() + "/hr/hrResume/index?id=" + hrOffer.getHrResume().getId();
		}
	}

	/**
	 * 删除OFFER
	 */
	@RequiresPermissions("hr:hrOffer:add")
	@RequestMapping(value = "delete")
	public String delete(HrOffer hrOffer, RedirectAttributes redirectAttributes) {
		hrOfferService.delete(hrOffer);
		addMessage(redirectAttributes, "删除OFFER成功");
		return "redirect:" + Global.getAdminPath() + "/hr/hrResume/index?id=" + hrOffer.getHrResume().getId();
	}

	/**
	 * 批量删除OFFER
	 */
	@RequiresPermissions("hr:hrOffer:add")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] = ids.split(",");
		for (String id : idArray) {
			hrOfferService.delete(hrOfferService.get(id));
		}
		addMessage(redirectAttributes, "删除OFFER成功");
		return "redirect:" + Global.getAdminPath() + "/hr/hrOffer/?repage";
	}

	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("hr:hrOffer:export")
	@RequestMapping(value = "export", method = RequestMethod.POST)
	public String exportFile(HrOffer hrOffer, HttpServletRequest request, HttpServletResponse response,
			RedirectAttributes redirectAttributes) {
		try {
			String fileName = "OFFER" + DateUtils.getDate("yyyyMMddHHmmss") + ".xlsx";
			Page<HrOffer> page = hrOfferService.findPage(new Page<HrOffer>(request, response, -1), hrOffer);
			new ExportExcel("OFFER", HrOffer.class).setDataList(page.getList()).write(response, fileName).dispose();
			return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出OFFER记录失败！失败信息：" + e.getMessage());
		}
		return "redirect:" + Global.getAdminPath() + "/hr/hrOffer/?repage";
	}

	/**
	 * 导入Excel数据
	 * 
	 */
	@RequiresPermissions("hr:hrOffer:import")
	@RequestMapping(value = "import", method = RequestMethod.POST)
	public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<HrOffer> list = ei.getDataList(HrOffer.class);
			for (HrOffer hrOffer : list) {
				try {
					hrOfferService.save(hrOffer);
					successNum++;
				} catch (ConstraintViolationException ex) {
					failureNum++;
				} catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum > 0) {
				failureMsg.insert(0, "，失败 " + failureNum + " 条OFFER记录。");
			}
			addMessage(redirectAttributes, "已成功导入 " + successNum + " 条OFFER记录" + failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入OFFER失败！失败信息：" + e.getMessage());
		}
		return "redirect:" + Global.getAdminPath() + "/hr/hrOffer/?repage";
	}

	/**
	 * 下载导入OFFER数据模板
	 */
	@RequiresPermissions("hr:hrOffer:import")
	@RequestMapping(value = "import/template")
	public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
			String fileName = "OFFER数据导入模板.xlsx";
			List<HrOffer> list = Lists.newArrayList();
			new ExportExcel("OFFER数据", HrOffer.class, 2).setDataList(list).write(response, fileName).dispose();
			return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息：" + e.getMessage());
		}
		return "redirect:" + Global.getAdminPath() + "/hr/hrOffer/?repage";
	}

	/**
	 * OFFER列表选择器
	 */
	@RequestMapping(value = "selectList")
	public String selectList(HrOffer hrOffer, HttpServletRequest request, HttpServletResponse response, Model model) {
		list(hrOffer, request, response, model);
		return "modules/hr/hrOfferSelectList";
	}

	/**
	 * 接收OFFER反馈
	 * @param id OFFER ID
	 * @param status
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping(value = "receive")
	public String receive(String id, String status, RedirectAttributes redirectAttributes, Model model) {

		try {

			if (StringUtils.isNotBlank(id) && StringUtils.isNotBlank(status)) {
				if("2".equals(status) || "3".equals(status)){
					HrOffer hrOffer = hrOfferService.get(id);
					if (hrOffer != null) {
						hrOffer.setStatus(status);// 状态( 1：已发送，2：已确认, 3：已拒绝)
						hrOfferService.save(hrOffer);
						
						model.addAttribute("status", status);
						return "modules/hr/hrOfferReceive";
					}
				}				
			}
		} catch (Exception e) {
			addMessage(redirectAttributes, "失败信息：");
		}

		addMessage(redirectAttributes, "链接出错啦");
		return "modules/hr/hrOfferReceive";
	}
	
	
}