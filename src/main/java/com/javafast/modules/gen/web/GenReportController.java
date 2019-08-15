package com.javafast.modules.gen.web;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
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
import com.google.common.collect.Lists;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.MyBeanUtils;
import com.javafast.common.config.Global;
import com.javafast.common.persistence.Page;
import com.javafast.common.web.BaseController;
import com.javafast.common.utils.StringUtils;
import com.javafast.common.utils.excel.ExportExcel;
import com.javafast.common.utils.excel.ImportExcel;
import com.javafast.modules.gen.entity.GenReport;
import com.javafast.modules.gen.entity.GenReportColumn;
import com.javafast.modules.gen.entity.GenTable;
import com.javafast.modules.gen.entity.GenTableColumn;
import com.javafast.modules.gen.service.GenReportService;
import com.javafast.modules.gen.service.GenTableService;
import com.javafast.modules.sys.entity.Dict;
import com.javafast.modules.sys.utils.DictUtils;
import com.javafast.modules.sys.utils.UserUtils;

/**
 * 图表配置Controller
 */
@Controller
@RequestMapping(value = "${adminPath}/gen/genReport")
public class GenReportController extends BaseController {

	@Autowired
	private GenReportService genReportService;
	
	@Autowired
	GenTableService genTableService;
	
	@ModelAttribute
	public GenReport get(@RequestParam(required=false) String id) {
		GenReport entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = genReportService.get(id);
		}
		if (entity == null){
			entity = new GenReport();
		}
		return entity;
	}
	
	/**
	 * 图表配置列表页面
	 */
	@RequiresPermissions("gen:genReport:list")
	@RequestMapping(value = {"list", ""})
	public String list(GenReport genReport, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<GenReport> page = genReportService.findPage(new Page<GenReport>(request, response), genReport); 
		model.addAttribute("page", page);
		return "modules/gen/genReportList";
	}

	/**
	 * 表单
	 * @param genReport
	 * @param model
	 * @return
	 */
	@RequiresPermissions(value={"gen:genReport:view","gen:genReport:add","gen:genReport:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(GenReport genReport, Model model) {
		
		if(StringUtils.isNotBlank(genReport.getQuerySql())){
			
			
		}
		
		model.addAttribute("genReport", genReport);
		return "modules/gen/genReportForm";
	}
	
	/**
	 * 解析
	 * @param genReport
	 * @param model
	 * @return
	 */
	@RequiresPermissions(value={"gen:genReport:view","gen:genReport:add","gen:genReport:edit"},logical=Logical.OR)
	@RequestMapping(value = "analyze")
	public String analyze(GenReport genReport, Model model) {
		
		if(StringUtils.isNotBlank(genReport.getTableName()) && StringUtils.isNotBlank(genReport.getQuerySql())){
			
			String querySql = genReport.getQuerySql();
			List<GenReportColumn> genReportColumnList = Lists.newArrayList();
			
			BigDecimal count = new BigDecimal(30);
			
			//根据表名称查询字段列表
			GenTable genTable = new GenTable();
			genTable.setName(genReport.getTableName());
			List<GenTableColumn> findTableColumnList = genTableService.findTableColumnList(genTable);
			for (GenTableColumn column : findTableColumnList){
				
				System.out.println(column.getName());
				//解析字段信息
				if(querySql.contains(column.getName())){
					
					GenReportColumn genReportColumn = new GenReportColumn();
					genReportColumn.setJavaField(column.getName());
					genReportColumn.setName(column.getComments());
					genReportColumn.setSort(count);
					genReportColumnList.add(genReportColumn);
					
					count = count.add(new BigDecimal(30));
				}
			}
			
			genReport.setGenReportColumnList(genReportColumnList);
		}
		
		model.addAttribute("genReport", genReport);
		return "modules/gen/genReportForm";
	}
	
	/**
	 * 查看图表配置页面
	 */
	@RequiresPermissions(value="gen:genReport:view")
	@RequestMapping(value = "view")
	public String view(GenReport genReport, Model model) {
		model.addAttribute("genReport", genReport);
		return "modules/gen/genReportView";
	}

	/**
	 * 保存图表配置
	 */
	@RequiresPermissions(value={"gen:genReport:add","gen:genReport:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(GenReport genReport, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, genReport)){
			return form(genReport, model);
		}
		
		if(Global.isDemoMode()){
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:"+Global.getAdminPath()+"/gen/genReport/?repage";
		}
		
		try{
		
			genReport.setStatus("0");
			
			if(!genReport.getIsNewRecord()){//编辑表单保存				
				GenReport t = genReportService.get(genReport.getId());//从数据库取出记录的值
				MyBeanUtils.copyBeanNotNull2Bean(genReport, t);//将编辑表单中的非NULL值覆盖数据库记录中的值
				genReportService.save(t);//保存
			}else{//新增表单保存
				genReportService.save(genReport);//保存
			}
			addMessage(redirectAttributes, "保存图表配置成功");
			return "redirect:"+Global.getAdminPath()+"/gen/genReport/?repage";
		}catch(Exception e){
			e.printStackTrace();
			addMessage(redirectAttributes, "保存图表配置失败");
			return "redirect:"+Global.getAdminPath()+"/gen/genReport/?repage";
		}
	}
	
	/**
	 * 删除图表配置
	 */
	@RequiresPermissions("gen:genReport:del")
	@RequestMapping(value = "delete")
	public String delete(GenReport genReport, RedirectAttributes redirectAttributes) {
		if(Global.isDemoMode()){
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:"+Global.getAdminPath()+"/gen/genReport/?repage";
		}
		genReportService.delete(genReport);
		addMessage(redirectAttributes, "删除图表配置成功");
		return "redirect:"+Global.getAdminPath()+"/gen/genReport/?repage";
	}
	
	/**
	 * 批量删除图表配置
	 */
	@RequiresPermissions("gen:genReport:del")
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		if(Global.isDemoMode()){
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:"+Global.getAdminPath()+"/gen/genReport/?repage";
		}
		String idArray[] =ids.split(",");
		for(String id : idArray){
			genReportService.delete(genReportService.get(id));
		}
		addMessage(redirectAttributes, "删除图表配置成功");
		return "redirect:"+Global.getAdminPath()+"/gen/genReport/?repage";
	}
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("gen:genReport:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(GenReport genReport, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "图表配置"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<GenReport> page = genReportService.findPage(new Page<GenReport>(request, response, -1), genReport);
    		new ExportExcel("图表配置", GenReport.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出图表配置记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/gen/genReport/?repage";
    }

	/**
	 * 导入Excel数据

	 */
	@RequiresPermissions("gen:genReport:import")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<GenReport> list = ei.getDataList(GenReport.class);
			for (GenReport genReport : list){
				try{
					genReportService.save(genReport);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条图表配置记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条图表配置记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入图表配置失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/gen/genReport/?repage";
    }
	
	/**
	 * 下载导入图表配置数据模板
	 */
	@RequiresPermissions("gen:genReport:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "图表配置数据导入模板.xlsx";
    		List<GenReport> list = Lists.newArrayList(); 
    		new ExportExcel("图表配置数据", GenReport.class, 1).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/gen/genReport/?repage";
    }
	
	/**
	 * 图表配置列表选择器
	 */
	@RequestMapping(value = "selectList")
	public String selectList(GenReport genReport, HttpServletRequest request, HttpServletResponse response, Model model) {		
        list(genReport, request, response, model);
        return "modules/gen/genReportSelectList";
	}
	
	/**
	 * 批量发布
	 */
	@RequiresPermissions("gen:genReport:edit")
	@RequestMapping(value = "auditAll")
	public String auditAll(String ids, RedirectAttributes redirectAttributes) {
		if(Global.isDemoMode()){
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:"+Global.getAdminPath()+"/gen/genReport/?repage";
		}
		String idArray[] =ids.split(",");
		for(String id : idArray){
			
			GenReport genReport =	genReportService.get(id);
			genReport.setStatus("1");
			genReportService.save(genReport);
		}
		addMessage(redirectAttributes, "发布图表配置成功");
		return "redirect:"+Global.getAdminPath()+"/gen/genReport/?repage";
	}
	
	/**
	 * 报表展现
	 * @param genReport
	 * @param model
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping(value = "report")
	public String report(GenReport genReport, Model model, RedirectAttributes redirectAttributes, HttpServletRequest request) {
		
		try{
			
			//获取查询条件
			String conditionSql = " where 1=1 ";
			
			GenTable genTable = new GenTable();
			genTable.setName(genReport.getTableName());
			List<GenTableColumn> findTableColumnList = genTableService.findTableColumnList(genTable);
			for (GenTableColumn column : findTableColumnList){
				if("account_id".equals(column.getName())){
					conditionSql += " and a.account_id='"+UserUtils.getUser().getAccountId()+"' ";
					break;
				}
			}
			
			String queryDiv = "";
			String xIsDictType = "";//X轴数据字典类型
			for(GenReportColumn genReportColumn : genReport.getGenReportColumnList()){
				
				if("1".equals(genReportColumn.getIsQuery())){	
					
					String inputParameter = "";
					String inputParameterStart = "";
					String inputParameterEnd = "";
					
					//如果是字符类型的
					if("String".equals(genReportColumn.getJavaType())){
						//获取输入参数
						inputParameter = request.getParameter(genReportColumn.getJavaField());
						if(StringUtils.isNotBlank(inputParameter)){
							conditionSql += " AND "+genReportColumn.getJavaField() + "='" + inputParameter+"'";
						}else{
							inputParameter = "";
						}
						//如果是数据字典的
						if(StringUtils.isNotBlank(genReportColumn.getDictType())){
							
							if(genReportColumn.getJavaField().equals(genReport.getXAxis())){
								xIsDictType = genReportColumn.getDictType();
							}
							
							queryDiv += "<div class=\"form-group\"> <span>"+genReportColumn.getName()+"：</span> <select id=\""+genReportColumn.getJavaField()+"\" name=\""+genReportColumn.getJavaField()+"\" >";
							queryDiv += "<option value=\"\"></option>";
							List<Dict> dictList = DictUtils.getDictList(genReportColumn.getDictType());
							for(Dict dict : dictList){
								
								queryDiv += "<option value=\""+dict.getValue()+"\"";
								if(dict.getValue().equals(inputParameter)){
									queryDiv += " selected=\"selected\" ";
								}
								queryDiv += ">"+dict.getLabel()+"</option>";
							}
							queryDiv += "</select> </div>";
						}else{
							queryDiv += "<div class=\"form-group\"> <span>"+genReportColumn.getName()+"：</span> <input name=\""+genReportColumn.getJavaField()+"\" value=\""+inputParameter+"\" class=\"form-control input-medium\" /> </div>";
						}
					}
					
					//如果是日期类型的，则范围查询模式
					if("Date".equals(genReportColumn.getJavaType())){
						
						//获取输入参数 开始时间
						inputParameterStart = request.getParameter(genReportColumn.getJavaField()+"Start");
						//获取输入参数 结束时间
						inputParameterEnd = request.getParameter(genReportColumn.getJavaField()+"End");
						
						if(StringUtils.isNotBlank(inputParameterStart) && StringUtils.isNotBlank(inputParameterEnd)){
							conditionSql += " AND "+genReportColumn.getJavaField() + " between '" + inputParameterStart+" 00:00:00' and '"+inputParameterEnd+" 23:59:59'";
						}else{
							inputParameterStart = "";
							inputParameterEnd = "";
						}
						
						queryDiv += "<div class=\"form-group\"> <span>"+genReportColumn.getName()+"：</span>";
						queryDiv += "<input name=\""+genReportColumn.getJavaField()+"Start"+"\" type=\"text\" readonly=\"readonly\" class=\"laydate-icon form-control layer-date input-medium\" value=\""+inputParameterStart+"\" onclick=\"WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});\"/>";
						queryDiv += " - ";
						queryDiv += "<input name=\""+genReportColumn.getJavaField()+"End"+"\" type=\"text\" readonly=\"readonly\" class=\"laydate-icon form-control layer-date input-medium\" value=\""+inputParameterEnd+"\" onclick=\"WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});\"/> ";
						queryDiv += "</div>";
					}
					//如果是数值类型
					if("Long".equals(genReportColumn.getJavaType())){
						//获取输入参数
						inputParameter = request.getParameter(genReportColumn.getJavaField());
						if(StringUtils.isNotBlank(inputParameter)){
							conditionSql += " AND "+genReportColumn.getJavaField() + "=" + inputParameter+"";
						}else{
							inputParameter = "";
						}
						
						queryDiv += "<div class=\"form-group\"> <span>"+genReportColumn.getName()+"：</span> <input name=\""+genReportColumn.getJavaField()+"\" value=\""+inputParameter+"\" class=\"form-control input-medium digits\" /> </div>";
					}
								
					
				}
			}
			if(StringUtils.isNotBlank(queryDiv)){
				queryDiv += "<div class=\"form-group\">&nbsp;<input id=\"btnSubmit\" class=\"btn btn-primary\" type=\"submit\" value=\"查询\"/> <input class=\"btn btn-white\" type=\"button\" onclick=\"doRefresh();\" value=\"重置\"/> </div>";
			}
			request.setAttribute("queryDiv", queryDiv);
			
			
			String querySql = genReport.getQuerySql().toLowerCase();
			
			if(StringUtils.isNotBlank(conditionSql)){
				
				if(querySql.contains("where")){
					
					querySql = querySql.split("where")[0] + conditionSql +" and "+ querySql.split("where")[1];
				}else{
					
					if(querySql.contains("group by")){
						
						querySql = querySql.split("group by")[0] + conditionSql + " group by " + querySql.split("group by")[1];
					}else{
						
						if(querySql.contains("order by")){
							
							querySql = querySql.split("order by")[0] + conditionSql + " order by " + querySql.split("order by")[1];
						}
					}
				}
				
				System.out.println("querySql: "+querySql);
				
				genReport.setQuerySql(querySql);
			}
			
			//根据配置的查询SQL语句进行数据查询
			List<Map<String, Object>> list = genReportService.findBySql(genReport);
			model.addAttribute("list", list);
				
			String xAxisName = "横轴";
			String yAxisName = "纵轴";				
			for(GenReportColumn genReportColumn : genReport.getGenReportColumnList()){
				
				//获取横轴和纵轴信息
				if(genReportColumn.getJavaField().equals(genReport.getXAxis())){
					xAxisName = genReportColumn.getName();
				}
				if(genReportColumn.getJavaField().equals(genReport.getYAxis())){
					yAxisName = genReportColumn.getName();
				}
			}
			
			model.addAttribute("xAxisName", xAxisName);
			model.addAttribute("yAxisName", yAxisName);
			
			//饼状图
			if("pie".equals(genReport.getReportType())){
				
				Map<String,Object> pieData = new HashMap<String,Object>();			
				for(Map<String, Object> map : list){
					
					if(StringUtils.isNotBlank(xIsDictType)){
						pieData.put(DictUtils.getDictLabel((String) map.get(genReport.getXAxis()), xIsDictType, "未知类型"),  map.get(genReport.getYAxis()));
					}else{
						pieData.put((String) map.get(genReport.getXAxis()),  map.get(genReport.getYAxis()));
					}
				}			
				model.addAttribute("pieData", pieData);
			}
			
			//柱状图
			if("bar".equals(genReport.getReportType())){
				
				//x轴数据
				List<String> xAxisData = new ArrayList<String>();
				//y轴数据
				Map<String,List<Double>> yAxisData = new HashMap<String,List<Double>>();
				
				//解析数据
				List<Double> data1 = new ArrayList<Double>();
				for(Map<String, Object> map : list){
					
					//添加X轴数据明细
					if(StringUtils.isNotBlank(xIsDictType)){
						xAxisData.add(DictUtils.getDictLabel((String) map.get(genReport.getXAxis()), xIsDictType, "未知类型"));
					}else{
						xAxisData.add(map.get(genReport.getXAxis()).toString());					
					}					
					
					//添加Y轴数据明细
					data1.add(Double.parseDouble(map.get(genReport.getYAxis())+""));
					yAxisData.put(yAxisName, data1);
				}
				
				//x轴数据
				model.addAttribute("xAxisData", xAxisData);
				//y轴数据
				model.addAttribute("yAxisData", yAxisData);
			}
			
			//线状图
			if("line".equals(genReport.getReportType())){
				
				//x轴数据
				List<String> xAxisData = new ArrayList<String>();
				//y轴数据
				Map<String,List<Double>> yAxisData = new HashMap<String,List<Double>>();
				
				//解析数据
				List<Double> data1 = new ArrayList<Double>();
				for(int i=list.size()-1;i>=0;i--){
					
					Map<String, Object> map = list.get(i);
					
					//添加X轴数据明细
					if(StringUtils.isNotBlank(xIsDictType)){
						xAxisData.add(DictUtils.getDictLabel((String) map.get(genReport.getXAxis()), xIsDictType, "未知类型"));
					}else{
						xAxisData.add(map.get(genReport.getXAxis()).toString());					
					}
					
					//添加Y轴数据明细
					data1.add(Double.parseDouble(map.get(genReport.getYAxis())+""));
					yAxisData.put(yAxisName, data1);
				}
				
				//x轴数据
				model.addAttribute("xAxisData", xAxisData);
				//y轴数据
				model.addAttribute("yAxisData", yAxisData);
			}
		
			model.addAttribute("genReport", genReport);			
		}catch(Exception e){
			addMessage(redirectAttributes, "报表查询失败");
			e.printStackTrace();
		}finally{
			return "modules/gen/reportView";
		}
	}
}