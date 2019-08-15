<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>销售线索查看</title>
	<meta name="decorator" content="default"/>
</head>
<body class="gray-bg">
<div class="wrapper-content">
<div class="ibox">
	<div class="ibox-title">
		<h5>销售线索查看</h5>
	</div>
	<div class="ibox-content">
		<sys:message content="${message}"/>
		<form:form id="inputForm" modelAttribute="crmClue" action="${ctx}/crm/crmClue/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
			<h4 class="page-header">基本信息</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">公司：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${crmClue.name}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">所有者：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${crmClue.ownBy.name}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">联系人姓名：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${crmClue.contacterName}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">性别：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${fns:getDictLabel(crmClue.sex, 'sex', '')}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">职务：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${crmClue.jobType}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">联系手机：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${crmClue.mobile}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">邮箱：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${crmClue.email}
							</p>
						</div>
					</div>
				</div>
				
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">线索来源：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${fns:getDictLabel(crmClue.sourType, 'sour_type', '')}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">所属行业：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${fns:getDictLabel(crmClue.industryType, 'industry_type', '')}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">企业性质：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${fns:getDictLabel(crmClue.natureType, 'nature_type', '')}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">企业规模：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${fns:getDictLabel(crmClue.scaleType, 'scale_type', '')}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">省：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${fns:getDictLabel(crmClue.province, '', '')}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">市：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${fns:getDictLabel(crmClue.city, '', '')}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">区：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${fns:getDictLabel(crmClue.dict, '', '')}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">详细地址：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${crmClue.address}
							</p>
						</div>
					</div>
				</div>
			</div>
			
			
			<h4 class="page-header">下次联系</h4>
			<div class="row">
				
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">下次联系时间：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							<fmt:formatDate value="${crmClue.nextcontactDate}" pattern="yyyy-MM-dd"/>
							</p>
						</div>
					</div>
				</div>
			
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">下次联系内容：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${crmClue.nextcontactNote}
							</p>
						</div>
					</div>
				</div>
			</div>
			<h4 class="page-header">备注信息</h4>
			<div class="row">
				<div class="col-sm-12">
					<div class="view-group">
						<label class="col-sm-2 control-label">备注：</label>
						<div class="col-sm-10">
							<p class="form-control-static">
							${crmClue.remarks}
							</p>
						</div>
					</div>
				</div>
			</div>
			<h4 class="page-header">操作信息</h4>
			
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">创建者：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${crmClue.createBy.name}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">创建时间：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							<fmt:formatDate value="${crmClue.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">更新者：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${crmClue.updateBy.name}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">更新时间：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							<fmt:formatDate value="${crmClue.updateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</p>
						</div>
					</div>
				</div>
			</div>
			
			<div class="hr-line-dashed"></div>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<div class="col-sm-offset-2 col-sm-10">
							
							
							<shiro:hasPermission name="crm:crmClue:edit">
						    	<a href="${ctx}/crm/crmClue/form?id=${crmClue.id}" class="btn btn-success" title="修改">修改</a>
							</shiro:hasPermission>
							<shiro:hasPermission name="crm:crmClue:del">
								<a href="${ctx}/crm/crmClue/delete?id=${crmClue.id}" onclick="return confirmx('确认要删除该销售线索吗？', this.href)" class="btn btn-danger" title="删除">删除</a> 
							</shiro:hasPermission>
							
							
							<c:if test="${empty crmClue.crmCustomer.id}">
								<shiro:hasPermission name="crm:crmClue:edit">
			    					<a href="${ctx}/crm/crmClue/toCustomerform?id=${crmClue.id}" class="btn btn-success" title="转为客户">转为客户</a>
								</shiro:hasPermission>
							</c:if>
							
							
								
							<a id="btnCancel" class="btn btn-white" onclick="history.go(-1)">返回</a>
						</div>
					</div>
				</div>
			</div>
		</form:form>
	</div>
</div>
</div>
</body>
</html>