package com.javafast.modules.report.entity;

import com.javafast.common.persistence.DataEntity;

public class ProjReport extends DataEntity<ProjReport>{
	private String finishNum;//2 已完成
	private String startNum;//1 启动
	private String waitNum;//0 未开始
	private String closedNum;//3 关闭
	public String getFinishNum() {
		return finishNum;
	}
	public void setFinishNum(String finishNum) {
		this.finishNum = finishNum;
	}
	public String getWaitNum() {
		return waitNum;
	}
	public void setWaitNum(String waitNum) {
		this.waitNum = waitNum;
	}
	public String getStartNum() {
		return startNum;
	}
	public void setStartNum(String startNum) {
		this.startNum = startNum;
	}
	public String getClosedNum() {
		return closedNum;
	}
	public void setClosedNum(String closedNum) {
		this.closedNum = closedNum;
	}
	

}
