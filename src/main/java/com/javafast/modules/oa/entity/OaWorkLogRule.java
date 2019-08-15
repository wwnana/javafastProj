package com.javafast.modules.oa.entity;

import com.javafast.modules.sys.entity.User;

import java.util.List;

import com.google.common.collect.Lists;
import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.Collections3;
import com.javafast.common.utils.IdGen;
import com.javafast.common.utils.StringUtils;
import com.javafast.common.utils.excel.annotation.ExcelField;

/**
 * 汇报规则Entity
 * @author javafast
 * @version 2018-07-17
 */
public class OaWorkLogRule extends DataEntity<OaWorkLogRule> {
	
	private static final long serialVersionUID = 1L;
	private User user;		// 查阅人
	private Integer sort;		// 排序
	
	private List<OaWorkLogRule> oaWorkLogRuleList = Lists.newArrayList();
	
	public OaWorkLogRule() {
		super();
	}

	public OaWorkLogRule(String id){
		super(id);
	}

	@ExcelField(title="查阅人", fieldType=User.class, value="user.name", align=2, sort=1)
	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}
	
	@ExcelField(title="排序", align=2, sort=2)
	public Integer getSort() {
		return sort;
	}

	public void setSort(Integer sort) {
		this.sort = sort;
	}
	
	/**
	 * 获取通知发送记录用户ID
	 * @return
	 */
	public String getOaWorkLogRuleIds() {
		return Collections3.extractToString(oaWorkLogRuleList, "user.id", ",") ;
	}
	
	/**
	 * 设置通知发送记录用户ID
	 * @return
	 */
	public void setOaWorkLogRuleIds(String oaWorkLogRule) {
		this.oaWorkLogRuleList = Lists.newArrayList();
		for (String id : StringUtils.split(oaWorkLogRule, ",")){
			OaWorkLogRule entity = new OaWorkLogRule();
			entity.setId(IdGen.uuid());
			entity.setUser(new User(id));
			this.oaWorkLogRuleList.add(entity);
		}
	}

	/**
	 * 获取通知发送记录用户Name
	 * @return
	 */
	public String getOaWorkLogRuleNames() {
		return Collections3.extractToString(oaWorkLogRuleList, "user.name", ",") ;
	}
	
	/**
	 * 设置通知发送记录用户Name
	 * @return
	 */
	public void setOaWorkLogRuleNames(String oaWorkLogRule) {
		// 什么也不做
	}

	public List<OaWorkLogRule> getOaWorkLogRuleList() {
		return oaWorkLogRuleList;
	}

	public void setOaWorkLogRuleList(List<OaWorkLogRule> oaWorkLogRuleList) {
		this.oaWorkLogRuleList = oaWorkLogRuleList;
	}
	
	
}