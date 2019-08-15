package com.javafast.modules.crm.entity;

import javax.validation.constraints.NotNull;
import org.hibernate.validator.constraints.Length;
import java.math.BigDecimal;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.javafast.modules.om.entity.OmOrder;
import com.javafast.modules.sys.entity.User;
import java.util.List;
import com.google.common.collect.Lists;

import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 报价单Entity
 */
public class CrmQuote extends DataEntity<CrmQuote> {
	
	private static final long serialVersionUID = 1L;
	private CrmCustomer customer;		// 客户
	private CrmContacter contacter;		// 联系人
	private CrmChance chance;		// 关联商机
	private String no;		// 单号
	private BigDecimal amount;		// 总金额
	private Integer num;        //数量
	private Date startdate;		// 报价日期
	private Date enddate;		// 有效期至
	private String status;		// 状态
	private User ownBy;		// 负责人
	private String notes;		// 正文
	private String files;		// 附件
	
	private User auditBy;		// 审核人
	private Date auditDate;		// 审核时间

	private Date beginStartdate;		// 开始 报价日期
	private Date endStartdate;		// 结束 报价日期
	private Date beginEnddate;		// 开始 有效期至
	private Date endEnddate;		// 结束 有效期至
	private Date beginCreateDate;		// 开始 创建时间
	private Date endCreateDate;		// 结束 创建时间
	private List<CrmQuoteDetail> crmQuoteDetailList = Lists.newArrayList();		// 子表列表
	private String delSelectIds;//被删除的子表id 
	
	private String name;		// 单号
	
	public CrmQuote() {
		super();
	}

	public CrmQuote(String id){
		super(id);
	}

	@NotNull(message="客户不能为空")
	@ExcelField(title="客户", fieldType=CrmCustomer.class, value="customer.name", align=2, sort=1)
	public CrmCustomer getCustomer() {
		return customer;
	}

	public void setCustomer(CrmCustomer customer) {
		this.customer = customer;
	}
	
	@ExcelField(title="联系人", fieldType=CrmContacter.class, value="contacter.name", align=2, sort=2)
	public CrmContacter getContacter() {
		return contacter;
	}

	public void setContacter(CrmContacter contacter) {
		this.contacter = contacter;
	}
	
	@ExcelField(title="关联商机", fieldType=CrmChance.class, value="chance.name", align=2, sort=3)
	public CrmChance getChance() {
		return chance;
	}

	public void setChance(CrmChance chance) {
		this.chance = chance;
	}
	
	@Length(min=1, max=30, message="单号长度必须介于 1 和 30 之间")
	@ExcelField(title="单号", align=2, sort=4)
	public String getNo() {
		return no;
	}

	public void setNo(String no) {
		this.no = no;
	}
	
	@NotNull(message="总金额不能为空")
	@ExcelField(title="总金额", align=2, sort=5)
	public BigDecimal getAmount() {
		return amount;
	}

	public void setAmount(BigDecimal amount) {
		this.amount = amount;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	@NotNull(message="报价日期不能为空")
	@ExcelField(title="报价日期", align=2, sort=6)
	public Date getStartdate() {
		return startdate;
	}

	public void setStartdate(Date startdate) {
		this.startdate = startdate;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	@ExcelField(title="有效期至", align=2, sort=7)
	public Date getEnddate() {
		return enddate;
	}

	public void setEnddate(Date enddate) {
		this.enddate = enddate;
	}
	
	@Length(min=1, max=2, message="状态长度必须介于 1 和 2 之间")
	@ExcelField(title="状态", dictType="audit_status", align=2, sort=8)
	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}
	
	@ExcelField(title="负责人", fieldType=User.class, value="ownBy.name", align=2, sort=9)
	public User getOwnBy() {
		return ownBy;
	}

	public void setOwnBy(User ownBy) {
		this.ownBy = ownBy;
	}
	
	@Length(min=0, max=100000, message="正文长度必须介于 0 和 100000 之间")
	public String getNotes() {
		return notes;
	}

	public void setNotes(String notes) {
		this.notes = notes;
	}
	
	@Length(min=0, max=1000, message="附件长度必须介于 0 和 1000 之间")
	public String getFiles() {
		return files;
	}

	public void setFiles(String files) {
		this.files = files;
	}
	
	public Date getBeginStartdate() {
		return beginStartdate;
	}

	public void setBeginStartdate(Date beginStartdate) {
		this.beginStartdate = beginStartdate;
	}
	
	public Date getEndStartdate() {
		return endStartdate;
	}

	public void setEndStartdate(Date endStartdate) {
		this.endStartdate = endStartdate;
	}
		
	public Date getBeginEnddate() {
		return beginEnddate;
	}

	public void setBeginEnddate(Date beginEnddate) {
		this.beginEnddate = beginEnddate;
	}
	
	public Date getEndEnddate() {
		return endEnddate;
	}

	public void setEndEnddate(Date endEnddate) {
		this.endEnddate = endEnddate;
	}
		
	public Date getBeginCreateDate() {
		return beginCreateDate;
	}

	public void setBeginCreateDate(Date beginCreateDate) {
		this.beginCreateDate = beginCreateDate;
	}
	
	public Date getEndCreateDate() {
		return endCreateDate;
	}

	public void setEndCreateDate(Date endCreateDate) {
		this.endCreateDate = endCreateDate;
	}
		
	public List<CrmQuoteDetail> getCrmQuoteDetailList() {
		return crmQuoteDetailList;
	}

	public void setCrmQuoteDetailList(List<CrmQuoteDetail> crmQuoteDetailList) {
		this.crmQuoteDetailList = crmQuoteDetailList;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public User getAuditBy() {
		return auditBy;
	}

	public void setAuditBy(User auditBy) {
		this.auditBy = auditBy;
	}

	public Date getAuditDate() {
		return auditDate;
	}

	public void setAuditDate(Date auditDate) {
		this.auditDate = auditDate;
	}

	public Integer getNum() {
		return num;
	}

	public void setNum(Integer num) {
		this.num = num;
	}
	
	public String getDelSelectIds() {
		return delSelectIds;
	}

	public void setDelSelectIds(String delSelectIds) {
		this.delSelectIds = delSelectIds;
	}
}