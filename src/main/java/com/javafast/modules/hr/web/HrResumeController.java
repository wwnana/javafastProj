package com.javafast.modules.hr.web;

import java.io.*;
import java.nio.charset.Charset;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.ConstraintViolationException;

import com.ckfinder.connector.ServletContextFactory;
import com.hankcs.hanlp.HanLP;
import com.hankcs.hanlp.corpus.occurrence.Occurrence;
import com.hankcs.hanlp.corpus.occurrence.TermFrequency;
import com.hankcs.hanlp.dictionary.stopword.CoreStopWordDictionary;
import com.hankcs.hanlp.dictionary.stopword.Filter;
import com.hankcs.hanlp.seg.Segment;
import com.hankcs.hanlp.seg.common.Term;
import com.javafast.common.utils.FileUtils;
import com.javafast.modules.hr.utils.MicOffWordUtil;
import org.apache.poi.hwpf.HWPFDocument;
import org.apache.poi.hwpf.extractor.WordExtractor;
import org.apache.poi.hwpf.usermodel.Range;
import org.apache.poi.ss.usermodel.Workbook;
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

import com.javafast.modules.hr.entity.HrInterview;
import com.javafast.modules.hr.entity.HrOffer;
import com.javafast.modules.hr.entity.HrRecruit;
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
import com.javafast.modules.hr.entity.HrResume;
import com.javafast.modules.hr.entity.HrResumeLog;
import com.javafast.modules.hr.entity.HrResumeRecord;
import com.javafast.modules.hr.service.HrInterviewService;
import com.javafast.modules.hr.service.HrOfferService;
import com.javafast.modules.hr.service.HrResumeLogService;
import com.javafast.modules.hr.service.HrResumeService;
import com.javafast.modules.hr.utils.ResumeLogUtils;
import com.javafast.modules.sys.utils.DictUtils;

/**
 * 简历Controller
 * @author javafast
 * @version 2018-06-29
 */
@Controller
@RequestMapping(value = "${adminPath}/hr/hrResume")
public class HrResumeController extends BaseController {

	@Autowired
	private HrResumeService hrResumeService;
	
	@Autowired
	private HrResumeLogService hrResumeLogService;
	
	@Autowired
	private HrInterviewService hrInterviewService;
	
	@Autowired
	private HrOfferService hrOfferService;
	
	@ModelAttribute
	public HrResume get(@RequestParam(required=false) String id) {
		HrResume entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = hrResumeService.get(id);
		}
		if (entity == null){
			entity = new HrResume();
		}
		return entity;
	}
	
	/**
	 * 简历列表页面
	 */
	@RequiresPermissions("hr:hrResume:list")
	@RequestMapping(value = {"list", ""})
	public String list(HrResume hrResume, HttpServletRequest request, HttpServletResponse response, Model model) {
		
		//默认当前环节为0：简历
		if(StringUtils.isBlank(hrResume.getCurrentNode())){
			hrResume.setCurrentNode("0");//当前环节：0：简历，1：面试，2：录用：3：入职：4： 简历库
		}
		Page<HrResume> page = hrResumeService.findPage(new Page<HrResume>(request, response), hrResume); 
		model.addAttribute("page", page);
		return "modules/hr/hrResumeList";
	}

	/**
	 * 编辑简历表单页面
	 */
	@RequiresPermissions(value={"hr:hrResume:view","hr:hrResume:add","hr:hrResume:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(HrResume hrResume, Model model) {
		model.addAttribute("hrResume", hrResume);
		return "modules/hr/hrResumeForm";
	}
	
	/**
	 * 上传简历
	 * @param hrResume
	 * @param model
	 * @return
	 */
	@RequiresPermissions(value={"hr:hrResume:view","hr:hrResume:add","hr:hrResume:edit"},logical=Logical.OR)
	@RequestMapping(value = "uploadForm")
	public String uploadForm(HrResume hrResume, Model model) {
		model.addAttribute("hrResume", hrResume);
		return "modules/hr/hrResumeUploadForm";
	}

	/**
	 * 上传简历提交
	 * @param hrResume
	 * @param model
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions(value={"hr:hrResume:add","hr:hrResume:edit"},logical=Logical.OR)
	@RequestMapping(value = "saveUpload")
	public String saveUpload(HrResume hrResume, Model model, RedirectAttributes redirectAttributes,HttpServletRequest request) {
		if (!beanValidator(model, hrResume)){
			return form(hrResume, model);
		}
		
		if(Global.isDemoMode()){
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:"+Global.getAdminPath()+"/hr/hrResume/?repage";
		}
		
		try{
		   String resumeFile= request.getParameter("resumeFile");
			String url = Global.getConfig("webSite");
			String fileurl = url + resumeFile;
			logger.info(fileurl);
			String content = MicOffWordUtil.getContent("/Users/feng/Documents/workspace/javafast2.0/src/main/webapp/userfiles/1/files/file/2018/07/李宏文_七年-2.doc");
			if(StringUtils.isBlank(content)){
			    //没有读取到简历内容
				logger.info("没有读取到简历内容");
				addMessage(redirectAttributes, "上传简历失败");
				return "redirect:"+Global.getAdminPath()+"/hr/hrResume/?repage";
            }
			logger.info(content);
			
			BufferedReader br = new BufferedReader(new InputStreamReader(new ByteArrayInputStream(content.getBytes(Charset.forName("utf8"))), Charset.forName("utf8")));
			String line;
			
			//需要识别出来的字段
			String mobile = ""; //手机号码
			String email = ""; //邮箱
			String name = ""; //姓名
			String lastCompany = "";        //上家公司
			String university = "";		// 毕业院校
			String specialty = "";		// 专业
			
			while ( (line = br.readLine()) != null ) {
				//logger.info(line);
				String mobileCheck=this.checkCellphone(line);
				if(StringUtils.isNotBlank(mobileCheck)){
					mobile=mobileCheck;
				}
				String emailCheck=this.checkEmail(line);
				if(StringUtils.isNotBlank(emailCheck)){
					email=emailCheck;
				}
				String sexCheck = checkSex(line);
				if(StringUtils.isBlank(name)||StringUtils.isBlank(lastCompany)){
					//识别姓名
					Segment segment = HanLP.newSegment().enableNameRecognize(true);
					segment.enableOrganizationRecognize(true);
					List<Term> termList = segment.seg(line);
					for (Term term : termList) {
						String te=term.toString();
						if(te.contains("/nr")){
							name=te.replace("/nr","");
							logger.info("搜索到姓名:"+name);
							continue;
						}
						if(te.contains("/nt")&&te.contains("公司")){
							lastCompany=te.replace("/nr","");
							logger.info("搜索到机构:"+lastCompany);
						}
					}


				}
			}
			hrResume.setName(name);
			hrResume.setMobile(mobile);
			hrResume.setMail(email);
			hrResume.setLastCompany(lastCompany);
			//解析简历
			//hrResume.setCurrentNode("0");//当前环节：0：简历，1：面试，2：录用：3：入职：4： 简历库
			hrResume.setResumeStatus("0");// 简历状态: 0新简历, 1已推荐, 2推荐通过,3未通过
			hrResume.setInterviewNum(0);
			hrResumeService.save(hrResume);//保存
			//输出当前word的一些信息
			// 记录日志
			addMessage(redirectAttributes, "上传简历成功");
			return "redirect:"+Global.getAdminPath()+"/hr/hrResume/index?id="+hrResume.getId();
		}catch(Exception e){			
			e.printStackTrace();
			addMessage(redirectAttributes, "上传简历失败");
			return "redirect:"+Global.getAdminPath()+"/hr/hrResume/?repage";
		}
	}

	/**
	 * 匹配手机号
	 * @param str
	 */
	public  String checkCellphone(String str){
		// 将给定的正则表达式编译到模式中
		Pattern pattern = Pattern.compile("((13[0-9])|(14[5|7])|(15([0-3]|[5-9]))|(18[0,5-9]))\\d{8}");
		// 创建匹配给定输入与此模式的匹配器。
		Matcher matcher = pattern.matcher(str);
		//查找字符串中是否有符合的子字符串
		while(matcher.find()){
			//查找到符合的即输出
			return matcher.group();
		}
		return "";
	}

	/**
	 * 匹配邮箱
	 * @param str
	 */
	public String  checkEmail(String str){
		Pattern pattern = Pattern.compile("[a-zA-Z0-9_.-]+@[a-zA-Z0-9-]+(\\.[a-zA-Z0-9-]+)*\\.[a-zA-Z0-9]{2,6}");
		// 创建匹配给定输入与此模式的匹配器。
		Matcher matcher = pattern.matcher(str);
		//查找字符串中是否有符合的子字符串
		while(matcher.find()){
			//查找到符合的即输出
			logger.info("查询到一个符合邮箱："+matcher.group());
			return matcher.group();
		}
		return "";
	}
	/**
	 * 匹配邮箱
	 * @param str
	 */
	public String  checkSex(String str){
		Pattern pattern = Pattern.compile("[\\u7537\\u5973]+");
		// 创建匹配给定输入与此模式的匹配器。
		Matcher matcher = pattern.matcher(str);
		//查找字符串中是否有符合的子字符串
		while(matcher.find()){
			//查找到符合的即输出
			logger.info("查询到一个符合性别："+matcher.group());
			return matcher.group();
		}
		return "";
	}
	
	/**
	 * 查看简历页面
	 */
	@RequiresPermissions(value="hr:hrResume:view")
	@RequestMapping(value = "index")
	public String index(HrResume hrResume, Model model) {
		model.addAttribute("hrResume", hrResume);
		
		//面试
		List<HrInterview> hrInterviewList = hrInterviewService.findList(new HrInterview(null, hrResume));
		model.addAttribute("hrInterviewList", hrInterviewList);
		
		//OFFER
		List<HrOffer> hrOfferList = hrOfferService.findList(new HrOffer(null, hrResume));
		model.addAttribute("hrOfferList", hrOfferList);
		
		//查询简历共享权限列表
		List<HrResumeRecord> hrResumeRecordList = hrResumeService.findHrResumeRecordList(hrResume);
		model.addAttribute("hrResumeRecordList", hrResumeRecordList);
		
		//查询HR日志
		List<HrResumeLog> hrResumeLogList = hrResumeLogService.findList(new HrResumeLog(null, hrResume.getId()));
		model.addAttribute("hrResumeLogList", hrResumeLogList);
		return "modules/hr/hrResumeIndex";
	}
	
	@RequiresPermissions(value="hr:hrResume:view")
	@RequestMapping(value = "view")
	public String view(HrResume hrResume, Model model) {
		model.addAttribute("hrResume", hrResume);
		return "modules/hr/hrResumeView";
	}

	/**
	 * 保存简历
	 */
	@RequiresPermissions(value={"hr:hrResume:add","hr:hrResume:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(HrResume hrResume, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, hrResume)){
			return form(hrResume, model);
		}
		
		if(Global.isDemoMode()){
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:"+Global.getAdminPath()+"/hr/hrResume/?repage";
		}
		
		try{
		
			if(!hrResume.getIsNewRecord()){//编辑表单保存				
				HrResume t = hrResumeService.get(hrResume.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(hrResume, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				hrResumeService.save(t);//保存
			}else{//新增表单保存
				hrResume.setCurrentNode("0");//当前环节：0：简历，1：面试，2：录用：3：入职：4： 简历库
				hrResume.setResumeStatus("0");// 简历状态: 0新简历, 1已推荐, 2推荐通过,3未通过
				hrResume.setInterviewNum(0);
				hrResumeService.save(hrResume);//保存
				
				//记录日志
				ResumeLogUtils.addResumeLog(hrResume.getId(), ResumeLogUtils.RESUME_ACTION_TYPE_UPLOAD, "");
			}
			addMessage(redirectAttributes, "保存简历成功");
		}catch(Exception e){			
			e.printStackTrace();
			addMessage(redirectAttributes, "保存简历失败");
		}finally{
			return "redirect:"+Global.getAdminPath()+"/hr/hrResume/?repage";
		}
	}
	
	/**
	 * 删除简历
	 */
	@RequiresPermissions("hr:hrResume:del")
	@RequestMapping(value = "delete")
	public String delete(HrResume hrResume, RedirectAttributes redirectAttributes) {
		hrResumeService.delete(hrResume);
		addMessage(redirectAttributes, "删除简历成功");
		return "redirect:"+Global.getAdminPath()+"/hr/hrResume/?repage";
	}
	
	/**
	 * 批量删除简历
	 */
	@RequiresPermissions("hr:hrResume:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			hrResumeService.delete(hrResumeService.get(id));
		}
		addMessage(redirectAttributes, "删除简历成功");
		return "redirect:"+Global.getAdminPath()+"/hr/hrResume/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("hr:hrResume:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(HrResume hrResume, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "简历"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<HrResume> page = hrResumeService.findPage(new Page<HrResume>(request, response, -1), hrResume);
    		new ExportExcel("简历", HrResume.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出简历记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/hr/hrResume/?repage";
    }

	/**
	 * 导入Excel数据

	 */
	@RequiresPermissions("hr:hrResume:import")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<HrResume> list = ei.getDataList(HrResume.class);
			for (HrResume hrResume : list){
				try{
					hrResumeService.save(hrResume);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条简历记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条简历记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入简历失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/hr/hrResume/?repage";
    }
	
	/**
	 * 下载导入简历数据模板
	 */
	@RequiresPermissions("hr:hrResume:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "简历数据导入模板.xlsx";
    		List<HrResume> list = Lists.newArrayList(); 
    		new ExportExcel("简历数据", HrResume.class, 2).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/hr/hrResume/?repage";
    }
	
	/**
	 * 简历列表选择器
	 */
	@RequestMapping(value = "selectList")
	public String selectList(HrResume hrResume, HttpServletRequest request, HttpServletResponse response, Model model) {		
        list(hrResume, request, response, model);
        return "modules/hr/hrResumeSelectList";
	}
	
	/**
	 * 推荐共享页面
	 * @param hrResume
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "shareForm")
	public String shareForm(HrResumeRecord hrResumeRecord, Model model) {
		if (hrResumeRecord.getHrResume() != null) {
            HrResume hrResume = hrResumeService.get(hrResumeRecord.getHrResume().getId());
            hrResumeRecord.setHrResume(hrResume);
		}
		model.addAttribute("hrResumeRecord", hrResumeRecord);
		return "modules/hr/hrResumeShareForm";
	}
	
	/**
	 * 提交推荐共享
	 * @param hrResume
	 * @param model
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping(value = "saveShare")
	public String saveShare(HrResumeRecord hrResumeRecord, HttpServletRequest request, Model model, RedirectAttributes redirectAttributes) {
		
		try{
			
			hrResumeService.saveHrResumeRecord(hrResumeRecord);
			addMessage(redirectAttributes, "推荐共享简历成功");
			
			String isMsg = request.getParameter("isMsg");
			if("1".equals(isMsg)){
				//企业微信通知
				
			}
			String isSmsMsg = request.getParameter("isSmsMsg");
			if("1".equals(isSmsMsg)){
				//手机短信通知
				
			}
		}catch(Exception e){			
			e.printStackTrace();
			addMessage(redirectAttributes, "推荐共享简历失败");
		}finally{
			return "redirect:"+Global.getAdminPath()+"/hr/hrResume/?repage";
		}
	}
	
	/**
	 * 简历放弃页面
	 * @param hrResume
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "revokeForm")
	public String revokeForm(HrResume hrResume, Model model) {
		if(StringUtils.isBlank(hrResume.getReserveStatus())){
			hrResume.setReserveStatus("0");
			hrResume.setReserveCause("0");
		}		
		model.addAttribute("hrResume", hrResume);
		return "modules/hr/hrResumeRevokeForm";
	}
	
	/**
	 * 简历放弃提交
	 * @param hrResume
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping(value = "saveRevoke")
	public String saveRevoke(HrResume hrResume, RedirectAttributes redirectAttributes) {
		
		if(Global.isDemoMode()){
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:"+Global.getAdminPath()+"/hr/hrResume/?repage";
		}
		
		//当前环节：0：简历，1：面试，2：录用：3：入职：4： 简历库
		hrResume.setCurrentNode("4");
		hrResumeService.save(hrResume);
		
		//记录日志
		String note = "放弃原因："+ DictUtils.getDictLabel(hrResume.getReserveCause(), "reserve_cause", "无");
		ResumeLogUtils.addResumeLog(hrResume.getId(), ResumeLogUtils.RESUME_ACTION_TYPE_RESERVE, note);
		
		addMessage(redirectAttributes, "放弃简历成功");
		return "redirect:"+Global.getAdminPath()+"/hr/hrResume/?repage";
	}
}
