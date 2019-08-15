package com.javafast.modules.hr.web;

import java.util.List;

import javax.mail.MessagingException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.ConstraintViolationException;

import com.javafast.modules.hr.utils.HrMailConfig;
import org.apache.shiro.authz.annotation.Logical;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import org.hibernate.validator.constraints.Length;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;

import com.google.common.collect.Lists;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.JavaMailUtil;
import com.javafast.common.utils.MyBeanUtils;
import com.javafast.api.sms.utils.SmsUtils;
import com.javafast.common.config.Global;
import com.javafast.common.mapper.JsonMapper;
import com.javafast.common.persistence.Page;
import com.javafast.common.web.BaseController;
import com.javafast.common.utils.StringUtils;
import com.javafast.common.utils.excel.ExportExcel;
import com.javafast.common.utils.excel.ImportExcel;
import com.javafast.modules.hr.entity.HrInterview;
import com.javafast.modules.hr.entity.HrRecruit;
import com.javafast.modules.hr.entity.HrResume;
import com.javafast.modules.hr.entity.HrResumeRecord;
import com.javafast.modules.hr.entity.HrTemplate;
import com.javafast.modules.hr.service.HrInterviewService;
import com.javafast.modules.hr.service.HrResumeService;
import com.javafast.modules.hr.service.HrTemplateService;
import com.javafast.modules.hr.utils.ResumeLogUtils;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.service.UserService;
import com.javafast.modules.sys.utils.UserUtils;

/**
 * 面试Controller
 *
 * @author javafast
 * @version 2018-06-29
 */
@Controller
@RequestMapping(value = "${adminPath}/hr/hrInterview")
public class HrInterviewController extends BaseController {

    @Autowired
    private HrInterviewService hrInterviewService;

    @Autowired
    private HrResumeService hrResumeService;
    
    @Autowired
	private HrTemplateService hrTemplateService;
    
    @Autowired
	private UserService userService;

    @ModelAttribute
    public HrInterview get(@RequestParam(required = false) String id) {
        HrInterview entity = null;
        if (StringUtils.isNotBlank(id)) {
            entity = hrInterviewService.get(id);
        }
        if (entity == null) {
            entity = new HrInterview();
        }
        return entity;
    }

    /**
     * 面试列表页面
     */
    @RequiresPermissions("hr:hrInterview:list")
    @RequestMapping(value = {"list", ""})
    public String list(HrInterview hrInterview, HttpServletRequest request, HttpServletResponse response, Model model) {
        Page<HrInterview> page = hrInterviewService.findPage(new Page<HrInterview>(request, response), hrInterview);
        model.addAttribute("page", page);
        return "modules/hr/hrInterviewList";
    }

    /**
     * 查看面试页面
     */
    @RequiresPermissions(value = {"hr:hrInterview:add", "hr:hrInterview:edit"}, logical = Logical.OR)
    @RequestMapping(value = "view")
    public String view(HrInterview hrInterview, Model model) {
        model.addAttribute("hrInterview", hrInterview);
        return "modules/hr/hrInterviewView";
    }
    
    /**
     * 编辑面试表单页面
     */
    @RequiresPermissions(value = {"hr:hrInterview:view", "hr:hrInterview:add", "hr:hrInterview:edit"}, logical = Logical.OR)
    @RequestMapping(value = "form")
    public String form(HrInterview hrInterview, Model model) {

        if (hrInterview.getHrResume() != null) {
            HrResume hrResume = hrResumeService.get(hrInterview.getHrResume().getId());
            hrInterview.setHrResume(hrResume);
            hrInterview.setPosition(hrResume.getPosition());
            hrInterview.setLinkMan(UserUtils.getUser().getName());
            hrInterview.setLinkPhone(UserUtils.getUser().getMobile());
            hrInterview.setAddress(UserUtils.getSysAccount().getAddress());
            hrInterview.setCompany(UserUtils.getSysAccount().getName());
        }
        
        if(hrInterview.getHrResume().getMail() == null){
			model.addAttribute("简历邮箱不能为空！");
			return "redirect:" + Global.getAdminPath() + "/hr/hrInterview/index?id=" + hrInterview.getHrResume().getId();
		}
        
        model.addAttribute("hrInterview", hrInterview);
        return "modules/hr/hrInterviewForm";
    }
    
    /**
     * 提交面试安排
     */
    @RequiresPermissions(value = {"hr:hrInterview:add", "hr:hrInterview:edit"}, logical = Logical.OR)
    @RequestMapping(value = "save")
    public String save(HrInterview hrInterview, HttpServletRequest request, Model model, RedirectAttributes redirectAttributes) {
        if (!beanValidator(model, hrInterview)) {
            return form(hrInterview, model);
        }

        if(Global.isDemoMode()){
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:" + Global.getAdminPath() + "/hr/hrResume/index?id=" + hrInterview.getHrResume().getId();
		}
        
        try {

        	hrInterview.setInviteStatus("0");//邀约状态 0 未邀约，1 已邀约
            hrInterview.setStatus("0");//反馈状态0 未反馈，1已反馈

            if (!hrInterview.getIsNewRecord()) {//编辑表单保存
                HrInterview t = hrInterviewService.get(hrInterview.getId());//从数据库取出记录的值
                MyBeanUtils.copyBeanNotNull2Bean(hrInterview, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
                hrInterviewService.save(t);//保存
            } else {//新增表单保存
                hrInterviewService.save(hrInterview);//保存
            }

            HrResume hrResume = hrResumeService.get(hrInterview.getHrResume().getId());
            // 更新当前环节：0：简历，1：面试，2：录用：3：入职：4： 简历库
            hrResume.setCurrentNode("1");
            hrResumeService.save(hrResume);
            
            //简历授权给面试官
            String interviewByname = "";
            if(hrInterview.getInterviewBy() != null){
            	User interviewBy = userService.get(hrInterview.getInterviewBy().getId());
                HrResumeRecord hrResumeRecord = new HrResumeRecord();
                hrResumeRecord.setHrResume(hrResume);
                hrResumeRecord.setUser(interviewBy);
                hrResumeService.saveHrResumeRecord(hrResumeRecord);                
                interviewByname = interviewBy.getName();
            }
            
            //记录日志
            String logNote = "应聘职位："+hrInterview.getPosition()+"<br>面试时间："+
                    DateUtils.formatDate(hrInterview.getInterviewDate(), "yyyy-MM-dd HH:mm")+
                    "<br>面试官："+interviewByname;
            ResumeLogUtils.addResumeLog(hrInterview.getHrResume().getId(), ResumeLogUtils.RESUME_ACTION_TYPE_INTERVIEW, logNote);

            addMessage(redirectAttributes, "发送面试成功");
        } catch (MessagingException e) {
        	e.printStackTrace();
            addMessage(redirectAttributes, "发送面试失败");
        } catch (Exception e) {
            e.printStackTrace();
            addMessage(redirectAttributes, "发送面试失败");
        } finally {
            return "redirect:" + Global.getAdminPath() + "/hr/hrResume/index?id=" + hrInterview.getHrResume().getId();
        }
    }
    
    /**
     * 预览
     * @param hrInterview
     * @param templateId
     * @param request
     * @param model
     * @param redirectAttributes
     * @return
     */
    @RequestMapping(value = "preview")
    public String preview(HrInterview hrInterview, String templateId, HttpServletRequest request, Model model, RedirectAttributes redirectAttributes) {
        if (!beanValidator(model, hrInterview)) {
            return form(hrInterview, model);
        }
    	
    	try {
    		
    		HrTemplate hrTemplate = null;
    		if (hrInterview.getHrResume() != null) {
                HrResume hrResume = hrResumeService.get(hrInterview.getHrResume().getId());
                hrInterview.setHrResume(hrResume);
            }
    			
    		//如果指定了模板
    		if(StringUtils.isNotBlank(templateId)){
    			hrTemplate = hrTemplateService.get(templateId);
    		}else{
    			//查询最匹配的模板
        		HrTemplate conHrTemplate = new HrTemplate();
        		conHrTemplate.setType("0");
            	List<HrTemplate> hrTemplateList = hrTemplateService.findList(conHrTemplate);
            	if(hrTemplateList != null){
            		hrTemplate = hrTemplateList.get(0);
            	}
    		}
    			
        	if(hrTemplate != null){
        		
        		String content = hrTemplate.getContent().replace("#姓名#", hrInterview.getHrResume().getName())
        				.replace("#面试职位#", hrInterview.getPosition())
        				.replace("#面试时间#", DateUtils.formatDate(hrInterview.getInterviewDate(), "yyyy-MM-dd HH:mm"))
        				.replace("#公司联系人#", hrInterview.getLinkMan())
        				.replace("#联系人电话#", hrInterview.getLinkPhone())
        				.replace("#面试地点#", hrInterview.getAddress())
        				+"<a style=\"color:#ffffff;background-color: #27c24c;padding: 8px 20px;border-radius: 3px;margin-right: 15px;\" href=\""+Global.getConfig("webSite")+Global.getConfig("adminPath")+"/hr/hrInterview/receive?id="+hrInterview.getId()+"&status=2\">接受</a>"
        				+"<a style=\"color:#ffffff;background-color: #f05050;padding: 8px 20px;border-radius: 3px;margin-right: 15px;\" href=\""+Global.getConfig("webSite")+Global.getConfig("adminPath")+"/hr/hrInterview/receive?id="+hrInterview.getId()+"&status=3\">拒绝</a>";
            	
        		System.out.println(content);
            	hrInterview.setContent(content);
            	model.addAttribute("hrInterview", hrInterview);
            	return "modules/hr/hrInterviewPreviewForm";
        	}
    	} catch (Exception e) {
    		e.printStackTrace();
        }
    	return "modules/hr/hrInterviewForm";
	}

    /**
     * 发送面试邀请(面试邮件)
     */
    @RequiresPermissions(value = {"hr:hrInterview:add", "hr:hrInterview:edit"}, logical = Logical.OR)
    @RequestMapping(value = "savePreview")
    public String savePreview(HrInterview hrInterview, HttpServletRequest request, Model model, RedirectAttributes redirectAttributes) {
        if (!beanValidator(model, hrInterview)) {
            return form(hrInterview, model);
        }

        if(Global.isDemoMode()){
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:" + Global.getAdminPath() + "/hr/hrResume/index?id=" + hrInterview.getHrResume().getId();
		}
        
        try {

        	hrInterview.setInviteStatus("0");//邀约状态 0 未邀约，1 已邀约
            hrInterview.setStatus("0");//反馈状态0 未反馈，1已反馈

            if (!hrInterview.getIsNewRecord()) {//编辑表单保存
                HrInterview t = hrInterviewService.get(hrInterview.getId());//从数据库取出记录的值
                MyBeanUtils.copyBeanNotNull2Bean(hrInterview, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
                hrInterviewService.save(t);//保存
            } else {//新增表单保存
                hrInterviewService.save(hrInterview);//保存
            }

            HrResume hrResume = hrResumeService.get(hrInterview.getHrResume().getId());
            // 更新当前环节：0：简历，1：面试，2：录用：3：入职：4： 简历库
            hrResume.setCurrentNode("1");
            hrResumeService.save(hrResume);

            //发送短信
            String isSmsMsg = request.getParameter("isSmsMsg");
            if ("1".equals(isSmsMsg)) {
                SmsUtils.sendInterviewSms(hrResume.getMobile(), hrResume.getName(), hrInterview.getCompany(), hrResume.getMail());
            }
            
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
                JavaMailUtil.sendHtmlMail(mailSender, HrMailConfig.FROM_EMAIL, toMail, "面试邀请函-" + hrInterview.getCompany(), content);
                logger.info("发送面试邮件");
            }
            
            hrInterview.setInviteStatus("1");//邀约状态 0 未邀约，1 已邀约
            hrInterviewService.save(hrInterview);//保存
            
            //简历授权给面试官
            String interviewByname = "";
            if(hrInterview.getInterviewBy() != null){
            	User interviewBy = userService.get(hrInterview.getInterviewBy().getId());
                HrResumeRecord hrResumeRecord = new HrResumeRecord();
                hrResumeRecord.setHrResume(hrResume);
                hrResumeRecord.setUser(interviewBy);
                hrResumeService.saveHrResumeRecord(hrResumeRecord);                
                interviewByname = interviewBy.getName();
            }
            
            //记录日志
            String logNote = "应聘职位："+hrInterview.getPosition()+"<br>面试时间："+
                    DateUtils.formatDate(hrInterview.getInterviewDate(), "yyyy-MM-dd HH:mm")+
                    "<br>面试官："+interviewByname;
            ResumeLogUtils.addResumeLog(hrInterview.getHrResume().getId(), ResumeLogUtils.RESUME_ACTION_TYPE_INTERVIEW, logNote);

            addMessage(redirectAttributes, "发送面试成功");
        } catch (MessagingException e) {
        	e.printStackTrace();
            addMessage(redirectAttributes, "发送面试失败");
        } catch (Exception e) {
            e.printStackTrace();
            addMessage(redirectAttributes, "发送面试失败");
        } finally {
            return "redirect:" + Global.getAdminPath() + "/hr/hrResume/index?id=" + hrInterview.getHrResume().getId();
        }
    }

    /**
     * 删除面试
     */
    @RequiresPermissions("hr:hrInterview:add")
    @RequestMapping(value = "delete")
    public String delete(HrInterview hrInterview, RedirectAttributes redirectAttributes) {
        hrInterviewService.delete(hrInterview);
        addMessage(redirectAttributes, "删除面试成功");
        return "redirect:" + Global.getAdminPath() + "/hr/hrResume/index?id=" + hrInterview.getHrResume().getId();
    }

    /**
     * 批量删除面试
     */
    @RequiresPermissions("hr:hrInterview:del")
    @RequestMapping(value = "deleteAll")
    public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
        String idArray[] = ids.split(",");
        for (String id : idArray) {
            hrInterviewService.delete(hrInterviewService.get(id));
        }
        addMessage(redirectAttributes, "删除面试成功");
        return "redirect:" + Global.getAdminPath() + "/hr/hrInterview/?repage";
    }

    /**
     * 导出excel文件
     */
    @RequiresPermissions("hr:hrInterview:export")
    @RequestMapping(value = "export", method = RequestMethod.POST)
    public String exportFile(HrInterview hrInterview, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
        try {
            String fileName = "面试" + DateUtils.getDate("yyyyMMddHHmmss") + ".xlsx";
            Page<HrInterview> page = hrInterviewService.findPage(new Page<HrInterview>(request, response, -1), hrInterview);
            new ExportExcel("面试", HrInterview.class).setDataList(page.getList()).write(response, fileName).dispose();
            return null;
        } catch (Exception e) {
            addMessage(redirectAttributes, "导出面试记录失败！失败信息：" + e.getMessage());
        }
        return "redirect:" + Global.getAdminPath() + "/hr/hrInterview/?repage";
    }

    /**
     * 导入Excel数据
     */
    @RequiresPermissions("hr:hrInterview:import")
    @RequestMapping(value = "import", method = RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
        try {
            int successNum = 0;
            int failureNum = 0;
            StringBuilder failureMsg = new StringBuilder();
            ImportExcel ei = new ImportExcel(file, 1, 0);
            List<HrInterview> list = ei.getDataList(HrInterview.class);
            for (HrInterview hrInterview : list) {
                try {
                    hrInterviewService.save(hrInterview);
                    successNum++;
                } catch (ConstraintViolationException ex) {
                    failureNum++;
                } catch (Exception ex) {
                    failureNum++;
                }
            }
            if (failureNum > 0) {
                failureMsg.insert(0, "，失败 " + failureNum + " 条面试记录。");
            }
            addMessage(redirectAttributes, "已成功导入 " + successNum + " 条面试记录" + failureMsg);
        } catch (Exception e) {
            addMessage(redirectAttributes, "导入面试失败！失败信息：" + e.getMessage());
        }
        return "redirect:" + Global.getAdminPath() + "/hr/hrInterview/?repage";
    }

    /**
     * 下载导入面试数据模板
     */
    @RequiresPermissions("hr:hrInterview:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
        try {
            String fileName = "面试数据导入模板.xlsx";
            List<HrInterview> list = Lists.newArrayList();
            new ExportExcel("面试数据", HrInterview.class, 2).setDataList(list).write(response, fileName).dispose();
            return null;
        } catch (Exception e) {
            addMessage(redirectAttributes, "导入模板下载失败！失败信息：" + e.getMessage());
        }
        return "redirect:" + Global.getAdminPath() + "/hr/hrInterview/?repage";
    }

    /**
     * 面试列表选择器
     */
    @RequestMapping(value = "selectList")
    public String selectList(HrInterview hrInterview, HttpServletRequest request, HttpServletResponse response, Model model) {
        list(hrInterview, request, response, model);
        return "modules/hr/hrInterviewSelectList";
    }

    /**
     * 接收面试邀约反馈
     * @param id 面试ID
     * @param status 状态码
     * @param redirectAttributes
     * @return
     */
    @RequestMapping(value = "receive")
    public String receive(String id, String status, RedirectAttributes redirectAttributes, Model model) {
    	
    	try {
    		
    		if(StringUtils.isNotBlank(id) && StringUtils.isNotBlank(status)){
    			if("2".equals(status) || "3".equals(status)){
    				HrInterview hrInterview =  hrInterviewService.get(id);
                	if(hrInterview != null){
                		hrInterview.setInviteStatus(status);//邀约状态 1 已邀约, 2: 已接受, 3已拒绝
                		hrInterview.setInterviewTime(new Date());
                    	hrInterviewService.save(hrInterview);
                    	
                    	model.addAttribute("status", status);
    					return "modules/hr/hrInterviewReceive";
                	}
    			}
        	}
    	} catch (Exception e) {
            addMessage(redirectAttributes, "导入模板下载失败！失败信息：" + e.getMessage());
        }
    	
    	addMessage(redirectAttributes, "链接出错啦");
    	return "modules/hr/hrInterviewReceive";
    }
    
   
}