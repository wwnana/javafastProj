package com.javafast.modules.gen.service;

import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.javafast.common.persistence.Page;
import com.javafast.common.service.CrudService;
import com.javafast.common.utils.StringUtils;
import com.javafast.modules.gen.entity.GenReport;
import com.javafast.modules.gen.dao.GenReportDao;
import com.javafast.modules.gen.entity.GenReportColumn;
import com.javafast.modules.gen.dao.GenReportColumnDao;

/**
 * 图表配置Service
 */
@Service
@Transactional(readOnly = true)
public class GenReportService extends CrudService<GenReportDao, GenReport> {

	@Autowired
	private GenReportColumnDao genReportColumnDao;
	
	public GenReport get(String id) {
		GenReport genReport = super.get(id);
		genReport.setGenReportColumnList(genReportColumnDao.findList(new GenReportColumn(genReport)));
		return genReport;
	}
	
	public List<GenReport> findList(GenReport genReport) {
		return super.findList(genReport);
	}
	
	public Page<GenReport> findPage(Page<GenReport> page, GenReport genReport) {
		return super.findPage(page, genReport);
	}
	
	@Transactional(readOnly = false)
	public void save(GenReport genReport) {
		super.save(genReport);
		for (GenReportColumn genReportColumn : genReport.getGenReportColumnList()){
			if (genReportColumn.getId() == null){
				continue;
			}
			if (GenReportColumn.DEL_FLAG_NORMAL.equals(genReportColumn.getDelFlag())){
				if (StringUtils.isBlank(genReportColumn.getId())){
					genReportColumn.setGenReport(genReport);
					genReportColumn.preInsert();
					genReportColumnDao.insert(genReportColumn);
				}else{
					genReportColumn.preUpdate();
					genReportColumnDao.update(genReportColumn);
				}
			}else{
				genReportColumnDao.delete(genReportColumn);
			}
		}
	}
	
	@Transactional(readOnly = false)
	public void delete(GenReport genReport) {
		super.delete(genReport);
		genReportColumnDao.delete(new GenReportColumn(genReport));
	}
	
	@Transactional(readOnly = false)
	public List<Map<String, Object>> findBySql(GenReport genReport){
		genReport.getSqlMap().put("dsf", genReport.getQuerySql());
		return dao.findBySql(genReport);
	}
}