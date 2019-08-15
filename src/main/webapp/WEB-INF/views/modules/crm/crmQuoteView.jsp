<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>报价单查看</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		
	</script>
</head>
<body class="gray-bg">
<div class="wrapper-content">
	<div class="ibox">
		<div class="ibox-title">
			<h5>报价单查看</h5>
		</div>
		<div class="ibox-content">
		<sys:message content="${message}"/>	
		<form:form id="inputForm" modelAttribute="crmQuote" action="${ctx}/crm/crmQuote/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
			<h4 class="page-header">基本信息</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">客户</label>
						<div class="col-sm-8">
							<p class="form-control-static">
								<a href="${ctx}/crm/crmCustomer/index?id=${crmQuote.customer.id}">${crmQuote.customer.name}</a>
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">单号</label>
						<div class="col-sm-8">
							<p class="form-control-static">
								${crmQuote.no}
							</p>
						</div>
					</div>
				</div>
				
			</div>
			<div class="row">
				
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">联系人</label>
						<div class="col-sm-8">
							<p class="form-control-static">
								${crmQuote.contacter.name}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">关联商机</label>
						<div class="col-sm-8">
							<p class="form-control-static">
								<a href="${ctx}/crm/crmChance/index?id=${crmQuote.chance.id}">${crmQuote.chance.name}</a>
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">总金额</label>
						<div class="col-sm-8">
							<p class="form-control-static">
								${crmQuote.amount}元
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">状态</label>
						<div class="col-sm-8">
							<p class="form-control-static">
								${fns:getDictLabel(crmQuote.status, 'audit_status', '')}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">报价日期</label>
						<div class="col-sm-8">
							<p class="form-control-static">
								<fmt:formatDate value="${crmQuote.startdate}" pattern="yyyy-MM-dd"/>
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">有效期至</label>
						<div class="col-sm-8">
							<p class="form-control-static">
								<fmt:formatDate value="${crmQuote.enddate}" pattern="yyyy-MM-dd"/>
							</p>
						</div>
					</div>
				</div>
				
			</div>
			
			<h4 class="page-header">正文信息</h4>
			<div class="row">
				<div class="col-sm-12">
					<div class="view-group">
						<label class="col-sm-2 control-label">正文</label>
						<div class="col-sm-10">
							<p class="form-control-static">${crmQuote.notes}</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="view-group">
						<label class="col-sm-2 control-label">附件</label>
						<div class="col-sm-10">
							<form:hidden id="files" path="files" htmlEscape="false" maxlength="2000" class=""/>
							<sys:ckfinder input="files" type="files" uploadPath="/file" selectMultiple="true" readonly="true"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="view-group">
						<label class="col-sm-2 control-label">备注</label>
						<div class="col-sm-10">
							<p class="form-control-static">${crmQuote.remarks}</p>
						</div>
					</div>
				</div>
			</div>
			<h4 class="page-header">操作信息</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">负责人</label>
						<div class="col-sm-8">
							<p class="form-control-static">
								${crmQuote.ownBy.name}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">制单人</label>
						<div class="col-sm-8">
							<p class="form-control-static">
								${crmQuote.createBy.name}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">制单时间</label>
						<div class="col-sm-8">
							<p class="form-control-static">
								<fmt:formatDate value="${crmQuote.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">审核人</label>
						<div class="col-sm-8">
							<p class="form-control-static">
								${crmQuote.auditBy.name}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">审核时间</label>
						<div class="col-sm-8">
							<p class="form-control-static">
								<fmt:formatDate value="${crmQuote.auditDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</p>
						</div>
					</div>
				</div>
			</div>	
				
			
		<!-- 明细 -->
		<div class="tabs-container">
	    	<ul class="nav nav-tabs">
				<li class="active"><a data-toggle="tab" href="#tab-1" aria-expanded="true">报价单明细</a></li>
	    	</ul>
          	<div class="tab-content">
          	   	<div class="panel-body">
					<div id="tab-1" class="tab-pane table-responsive active">
					<table id="contentTable" class="table table-striped table-bordered table-hover table-condensed">
						<thead>
							<tr>
								<th>序号</th>
								<th>产品编号</th>
								<th>产品名称</th>
								<th>规格</th>
								<th>单位</th>
								<th>单价(元)</th>
								<th>数量</th>
								<th>金额(元)</th>
								<th>备注</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach items="${crmQuote.crmQuoteDetailList}" var="crmQuoteDetail" varStatus="sta">
								<tr>
											<td>${sta.index + 1}</td>
											<td>
												${crmQuoteDetail.product.no}
											</td>
											<td>
												${crmQuoteDetail.product.name}
											</td>
											<td>
												${crmQuoteDetail.product.spec}
											</td>
											<td>
												${crmQuoteDetail.unitType}
											</td>
											<td>
												${crmQuoteDetail.price}
											</td>
											<td>
												${crmQuoteDetail.num}
											</td>
											<td>
												${crmQuoteDetail.amt}
											</td>
											<td>
												${crmQuoteDetail.remarks}
											</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
					<div class="pull-right">
						总金额：<form:input path="amount" htmlEscape="false" min="0.01" class="form-control input-small required number" readonly="true" style="border:0"/>
						总数量：<form:input path="num" htmlEscape="false" min="1" class="form-control input-small required" readonly="true" style="border:0"/>
					</div>					
					</div>
				</div>
			</div>
		</div>
	<br>
				<div class="form-actions">
				
					<c:if test="${crmQuote.status == 0}">
						<shiro:hasPermission name="crm:crmQuote:edit">
	    					<a href="${ctx}/crm/crmQuote/form?id=${crmQuote.id}" class="btn btn-success" title="修改"><i class="fa fa-edit"></i>
								<span class="hidden-xs">修改</span></a>
						</shiro:hasPermission>
						<shiro:hasPermission name="crm:crmQuote:del">
							<a href="${ctx}/crm/crmQuote/delete?id=${crmQuote.id}" onclick="return confirmx('确认要删除该报价单吗？', this.href)" class="btn  btn-danger" title="删除"><i class="fa fa-trash"></i>
								<span class="hidden-xs">删除</span></a> 
						</shiro:hasPermission>
						<shiro:hasPermission name="crm:crmQuote:audit">
							<a href="${ctx}/crm/crmQuote/audit?id=${crmQuote.id}" onclick="return confirmx('确认要审核该报价单吗？', this.href)" class="btn  btn-success" title="审核"><i class="fa fa-check"></i>
								<span class="hidden-xs">审核</span></a> 
						</shiro:hasPermission>
						</c:if>
						<c:if test="${crmQuote.status == 1}">
						<shiro:hasPermission name="om:omContract:edit">
	    					<a href="${ctx}/om/omContract/quoteToForm?quote.id=${crmQuote.id}" class="btn btn-success" title="生成订单"><i class="fa fa-edit"></i>
								<span class="hidden-xs">生成订单</span></a>
						</shiro:hasPermission>
					</c:if>
					
					<a href="${ctx}/crm/crmQuote/print?id=${crmQuote.id}" class="btn btn-white" title="打印" target="_blank"><i class="fa fa-print"></i> <span class="hidden-xs">打印</span></a>
								
					<input id="btnCancel" class="btn btn-white" type="button" value="返 回" onclick="history.go(-1)"/>
				</div>
			<br>
	</form:form>
</div></div></div>
</body>
</html>