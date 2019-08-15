package com.javafast.modules.pay.entity;

import org.hibernate.validator.constraints.Length;
import java.math.BigDecimal;
import javax.validation.constraints.NotNull;
import java.util.Date;

import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 预定订单Entity
 * @author javafast
 * @version 2018-08-03
 */
public class PayBookOrder extends DataEntity<PayBookOrder> {
	
	private static final long serialVersionUID = 1L;
	private String no;		// 订单编号
	private BigDecimal amount;		// 订单金额
	private String productId;		// 产品名称
	private String mobile;		// 手机号码
	private String name;		// 姓名
	private String company;		// 公司名称
	private String scaleType;		// 企业规模
	private String email;		// 电子邮箱
	private String qq;		// QQ
	private String notes;		// 留言
	private String status;		// 支付状态
	private String payType;		// 支付类型
	private Date beginCreateDate;		// 开始 创建时间
	private Date endCreateDate;		// 结束 创建时间
	
	public PayBookOrder() {
		super();
	}

	public PayBookOrder(String id){
		super(id);
	}

	@Length(min=1, max=50, message="订单编号长度必须介于 1 和 50 之间")
	@ExcelField(title="订单编号", align=2, sort=1)
	public String getNo() {
		return no;
	}

	public void setNo(String no) {
		this.no = no;
	}
	
	@NotNull(message="订单金额不能为空")
	@ExcelField(title="订单金额", align=2, sort=2)
	public BigDecimal getAmount() {
		return amount;
	}

	public void setAmount(BigDecimal amount) {
		this.amount = amount;
	}
	
	@Length(min=1, max=30, message="产品名称长度必须介于 1 和 30 之间")
	@ExcelField(title="产品名称", align=2, sort=3)
	public String getProductId() {
		return productId;
	}

	public void setProductId(String productId) {
		this.productId = productId;
	}
	
	@Length(min=1, max=30, message="手机号码长度必须介于 1 和 30 之间")
	@ExcelField(title="手机号码", align=2, sort=4)
	public String getMobile() {
		return mobile;
	}

	public void setMobile(String mobile) {
		this.mobile = mobile;
	}
	
	@Length(min=1, max=30, message="姓名长度必须介于 1 和 30 之间")
	@ExcelField(title="姓名", align=2, sort=5)
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	@Length(min=1, max=50, message="公司名称长度必须介于 1 和 50 之间")
	@ExcelField(title="公司名称", align=2, sort=6)
	public String getCompany() {
		return company;
	}

	public void setCompany(String company) {
		this.company = company;
	}
	
	@Length(min=0, max=1, message="企业规模长度必须介于 0 和 1 之间")
	@ExcelField(title="企业规模", align=2, sort=7)
	public String getScaleType() {
		return scaleType;
	}

	public void setScaleType(String scaleType) {
		this.scaleType = scaleType;
	}
	
	@Length(min=0, max=50, message="电子邮箱长度必须介于 0 和 50 之间")
	@ExcelField(title="电子邮箱", align=2, sort=8)
	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}
	
	@Length(min=0, max=50, message="QQ长度必须介于 0 和 50 之间")
	@ExcelField(title="QQ", align=2, sort=9)
	public String getQq() {
		return qq;
	}

	public void setQq(String qq) {
		this.qq = qq;
	}
	
	@Length(min=0, max=50, message="留言长度必须介于 0 和 50 之间")
	@ExcelField(title="留言", align=2, sort=10)
	public String getNotes() {
		return notes;
	}

	public void setNotes(String notes) {
		this.notes = notes;
	}
	
	@Length(min=0, max=1, message="支付状态长度必须介于 0 和 1 之间")
	@ExcelField(title="支付状态", dictType="pay_status", align=2, sort=11)
	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}
	
	@Length(min=0, max=1, message="支付类型长度必须介于 0 和 1 之间")
	@ExcelField(title="支付类型", dictType="pay_type", align=2, sort=12)
	public String getPayType() {
		return payType;
	}

	public void setPayType(String payType) {
		this.payType = payType;
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
		
}