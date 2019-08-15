package com.javafast.modules.hr.entity;

import com.javafast.modules.sys.entity.Office;
import org.hibernate.validator.constraints.Length;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.javafast.modules.hr.entity.HrEmployee;
import javax.validation.constraints.NotNull;

import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 调岗Entity
 * @author javafast
 * @version 2018-07-05
 */
public class HrPositionChange extends DataEntity<HrPositionChange> {
	
	private static final long serialVersionUID = 1L;
	private Office oldOffice;		// 调整前部门
	private String oldPosition;		// 调整前岗位
	private String oldPositionLevel;		// 调整前职级
	private Office office;		// 调整后部门
	private String position;		// 调整后岗位
	private String positionLevel;		// 调整后职级
	private Date changeDate;		// 调岗时间
	private String changeCause;		// 调岗原因
	private HrEmployee hrEmployee;		// 员工ID
	private Date beginChangeDate;		// 开始 调岗时间
	private Date endChangeDate;		// 结束 调岗时间
	
	public HrPositionChange() {
		super();
	}

	public HrPositionChange(String id){
		super(id);
	}

	@ExcelField(title="调整前部门", fieldType=Office.class, value="oldOffice.name", align=2, sort=1)
	public Office getOldOffice() {
		return oldOffice;
	}

	public void setOldOffice(Office oldOffice) {
		this.oldOffice = oldOffice;
	}
	
	@Length(min=0, max=50, message="调整前岗位长度必须介于 0 和 50 之间")
	@ExcelField(title="调整前岗位", align=2, sort=2)
	public String getOldPosition() {
		return oldPosition;
	}

	public void setOldPosition(String oldPosition) {
		this.oldPosition = oldPosition;
	}
	
	@Length(min=0, max=50, message="调整前职级长度必须介于 0 和 50 之间")
	@ExcelField(title="调整前职级", align=2, sort=3)
	public String getOldPositionLevel() {
		return oldPositionLevel;
	}

	public void setOldPositionLevel(String oldPositionLevel) {
		this.oldPositionLevel = oldPositionLevel;
	}
	
	@ExcelField(title="调整后部门", fieldType=Office.class, value="office.name", align=2, sort=4)
	public Office getOffice() {
		return office;
	}

	public void setOffice(Office office) {
		this.office = office;
	}
	
	@Length(min=0, max=50, message="调整后岗位长度必须介于 0 和 50 之间")
	@ExcelField(title="调整后岗位", align=2, sort=5)
	public String getPosition() {
		return position;
	}

	public void setPosition(String position) {
		this.position = position;
	}
	
	@Length(min=0, max=50, message="调整后职级长度必须介于 0 和 50 之间")
	@ExcelField(title="调整后职级", align=2, sort=6)
	public String getPositionLevel() {
		return positionLevel;
	}

	public void setPositionLevel(String positionLevel) {
		this.positionLevel = positionLevel;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	@ExcelField(title="调岗时间", align=2, sort=7)
	public Date getChangeDate() {
		return changeDate;
	}

	public void setChangeDate(Date changeDate) {
		this.changeDate = changeDate;
	}
	
	@Length(min=0, max=200, message="调岗原因长度必须介于 0 和 200 之间")
	@ExcelField(title="调岗原因", align=2, sort=8)
	public String getChangeCause() {
		return changeCause;
	}

	public void setChangeCause(String changeCause) {
		this.changeCause = changeCause;
	}
	
	@NotNull(message="员工ID不能为空")
	@ExcelField(title="员工姓名", fieldType=HrEmployee.class, value="hrEmployee.name", align=2, sort=0)
	public HrEmployee getHrEmployee() {
		return hrEmployee;
	}

	public void setHrEmployee(HrEmployee hrEmployee) {
		this.hrEmployee = hrEmployee;
	}
	
	public Date getBeginChangeDate() {
		return beginChangeDate;
	}

	public void setBeginChangeDate(Date beginChangeDate) {
		this.beginChangeDate = beginChangeDate;
	}
	
	public Date getEndChangeDate() {
		return endChangeDate;
	}

	public void setEndChangeDate(Date endChangeDate) {
		this.endChangeDate = endChangeDate;
	}
		
}