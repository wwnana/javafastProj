package com.javafast.modules.hr.entity;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import java.math.BigDecimal;
import org.hibernate.validator.constraints.Length;
import com.javafast.modules.hr.entity.HrEmployee;
import javax.validation.constraints.NotNull;

import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 期权Entity
 * @author javafast
 * @version 2018-07-06
 */
public class HrOption extends DataEntity<HrOption> {
	
	private static final long serialVersionUID = 1L;
	private Date grantDate;		// 授予日期
	private Integer grantNum;		// 授予数量
	private BigDecimal proportion;		// 比例
	private String roundNum;		// 轮次
	private BigDecimal lockPeriod;		// 锁定期
	private Integer matureNum;		// 已成熟数量
	private String optionFile;		// 期权合同
	private String status;		// 状态
	private HrEmployee hrEmployee;		// 员工ID
	
	public HrOption() {
		super();
	}

	public HrOption(String id){
		super(id);
	}

	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	@ExcelField(title="授予日期", align=2, sort=1)
	public Date getGrantDate() {
		return grantDate;
	}

	public void setGrantDate(Date grantDate) {
		this.grantDate = grantDate;
	}
	
	@ExcelField(title="授予数量", align=2, sort=2)
	public Integer getGrantNum() {
		return grantNum;
	}

	public void setGrantNum(Integer grantNum) {
		this.grantNum = grantNum;
	}
	
	@ExcelField(title="比例", align=2, sort=3)
	public BigDecimal getProportion() {
		return proportion;
	}

	public void setProportion(BigDecimal proportion) {
		this.proportion = proportion;
	}
	
	@Length(min=0, max=20, message="轮次长度必须介于 0 和 20 之间")
	@ExcelField(title="轮次", align=2, sort=4)
	public String getRoundNum() {
		return roundNum;
	}

	public void setRoundNum(String roundNum) {
		this.roundNum = roundNum;
	}
	
	@ExcelField(title="锁定期", align=2, sort=5)
	public BigDecimal getLockPeriod() {
		return lockPeriod;
	}

	public void setLockPeriod(BigDecimal lockPeriod) {
		this.lockPeriod = lockPeriod;
	}
	
	@ExcelField(title="已成熟数量", align=2, sort=6)
	public Integer getMatureNum() {
		return matureNum;
	}

	public void setMatureNum(Integer matureNum) {
		this.matureNum = matureNum;
	}
	
	@Length(min=0, max=255, message="期权合同长度必须介于 0 和 255 之间")
	@ExcelField(title="期权合同", align=2, sort=7)
	public String getOptionFile() {
		return optionFile;
	}

	public void setOptionFile(String optionFile) {
		this.optionFile = optionFile;
	}
	
	@Length(min=0, max=1, message="状态长度必须介于 0 和 1 之间")
	@ExcelField(title="状态", align=2, sort=8)
	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}
	
	@NotNull(message="员工ID不能为空")
	@ExcelField(title="员工ID", align=2, sort=15)
	public HrEmployee getHrEmployee() {
		return hrEmployee;
	}

	public void setHrEmployee(HrEmployee hrEmployee) {
		this.hrEmployee = hrEmployee;
	}
	
}