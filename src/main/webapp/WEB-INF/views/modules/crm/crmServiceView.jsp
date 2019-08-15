<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>服务工单查看</title>
	<meta name="decorator" content="default"/>
</head>
<body class="hideScroll">
	<div class="ibox-content">
		<sys:message content="${message}"/>
		<form:form id="inputForm" modelAttribute="crmService" action="${ctx}/crm/crmService/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
			<h4 class="page-header">基本信息</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">工单编码：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${crmService.no}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">主题：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${crmService.name}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">类型：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${fns:getDictLabel(crmService.serviceType, 'service_type', '')}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">负责人：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${crmService.ownBy.name}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">订单合同：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${crmService.omContract.id}
							</p>
						</div>
					</div>
				</div>
			
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">客户：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${crmService.customer.id}
							</p>
						</div>
					</div>
				</div>
				
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">优先级：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${fns:getDictLabel(crmService.levelType, 'level_type', '')}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">截止日期：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							<fmt:formatDate value="${crmService.endDate}" pattern="yyyy-MM-dd"/>
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="view-group">
						<label class="col-sm-2 control-label">期望结果：</label>
						<div class="col-sm-10">
							<p class="form-control-static">
							${crmService.expecte}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="view-group">
						<label class="col-sm-2 control-label">内容：</label>
						<div class="col-sm-10">
							<p class="form-control-static">
							${crmService.content}
							</p>
						</div>
					</div>
				</div>
			</div>
			
			<h4 class="page-header">处理信息</h4>
			
			<div class="row">
				
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">处理状态：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${fns:getDictLabel(crmService.status, 'finish_status', '')}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">处理日期：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							<fmt:formatDate value="${crmService.dealDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</p>
						</div>
					</div>
				</div>
			</div>
			
			<h4 class="page-header">完成结果</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">满意度：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${fns:getDictLabel(crmService.satisfyType, 'satisfy_type', '')}
							</p>
						</div>
					</div>
				</div>
				
			</div>
			
			<h4 class="page-header">操作信息</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">审核人：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${crmService.auditBy.name}
							</p>
						</div>
					</div>
				</div>
			
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">审核日期：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							<fmt:formatDate value="${crmService.auditDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">更新人：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${crmService.updateBy.id}
							</p>
						</div>
					</div>
				</div>
			
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">更新时间：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							<fmt:formatDate value="${crmService.updateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">备注：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${crmService.remarks}
							</p>
						</div>
					</div>
				</div>
			</div>
			
		</form:form>
	</div>
</body>
</html>