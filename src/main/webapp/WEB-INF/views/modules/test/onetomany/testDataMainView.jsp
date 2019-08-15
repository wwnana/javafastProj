<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>订单信息查看</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">		
	</script>
</head>
<body class="gray-bg">
<div class="wrapper-content">
<div class="ibox">
	<div class="ibox-title">
		<h5>订单信息(一对多)${not empty omContract.id?'修改':'添加'}</h5>
	</div>
	<div class="ibox-content">
		<sys:message content="${message}"/>
		<form:form id="inputForm" modelAttribute="testDataMain" action="${ctx}/test/onetomany/testDataMain/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<form:hidden path="status"/>
			<h4 class="page-header">基本信息</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">单号：</label>
						<div class="col-sm-8">
							<p class="form-control-static">${testDataMain.no}</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">销售类型：</label>
						<div class="col-sm-8">
							<p class="form-control-static">${fns:getDictLabel(testDataMain.saleType, 'sale_type', '')}</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">订单金额(元)：</label>
						<div class="col-sm-8">
							<p class="form-control-static">${testDataMain.amount}</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">开票金额(元)：</label>
						<div class="col-sm-8">
							<p class="form-control-static">${testDataMain.invoiceAmt}</p>
						</div>
					</div>
				</div>
			</div>
			<h4 class="page-header">操作信息</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">经办人：</label>
						<div class="col-sm-8">
							<p class="form-control-static">${testDataMain.dealBy.name}</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">业务日期：</label>
						<div class="col-sm-8">
							<p class="form-control-static"><fmt:formatDate value="${testDataMain.dealDate}" pattern="yyyy-MM-dd"/></p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">制单人：</label>
						<div class="col-sm-8">
							<p class="form-control-static">${testDataMain.createBy.name}</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">制单时间：</label>
						<div class="col-sm-8">
							<p class="form-control-static"><fmt:formatDate value="${testDataMain.createDate}" pattern="yyyy-MM-dd"/></p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">审核人：</label>
						<div class="col-sm-8">
							<p class="form-control-static">${testDataMain.auditBy.name}</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">审核时间：</label>
						<div class="col-sm-8">
							<p class="form-control-static"><fmt:formatDate value="${testDataMain.auditDate}" pattern="yyyy-MM-dd"/></p>
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
							<p class="form-control-static">${testDataMain.remarks}</p>
						</div>
					</div>
				</div>
			</div>
			
		<!-- 明细 -->
		<div class="tabs-container">
	    	<ul class="nav nav-tabs">
				<li class="active"><a data-toggle="tab" href="#tab-1" aria-expanded="true">订单明细</a></li>
	    	</ul>
          	<div class="tab-content">
          	   	<div class="panel-body">
					<div id="tab-1" class="tab-pane table-responsive active">
					<table id="contentTable" class="table table-bordered table-striped table-hover">
						<thead>
							<tr>
								<th>商品</th>
								<th>规格</th>
								<th>单位</th>
								<th>单价(元)</th>
								<th>数量</th>
								<th>金额(元)</th>
								<th>备注</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach items="${testDataMain.testDataChildList}" var="testDataChild">
								<tr>
											<td>
												${testDataChild.product.name}
											</td>
											<td>
												${testDataChild.product.spec}
											</td>
											<td>
												${testDataChild.unitType}
											</td>
											<td>
												${testDataChild.price}
											</td>
											<td>
												${testDataChild.num}
											</td>
											<td>
												${testDataChild.amount}
											</td>
											<td>
												${testDataChild.remarks}
											</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
					<div class="pull-right">
						总金额：${testDataMain.amount }
					
					</div>					
					</div>
				</div>
			</div>
		</div>
			<div class="hr-line-dashed"></div>
			<div class="form-actions">
				<shiro:hasPermission name="test:onetomany:testDataMain:edit">
   					<a href="${ctx}/test/onetomany/testDataMain/form?id=${testDataMain.id}" class="btn btn-success" title="修改">修改</a>
				</shiro:hasPermission>
				<shiro:hasPermission name="test:onetomany:testDataMain:del">
					<a href="${ctx}/test/onetomany/testDataMain/delete?id=${testDataMain.id}" onclick="return confirmx('确认要删除该订单信息吗？', this.href)" class="btn  btn-danger" title="删除">删除</a> 
				</shiro:hasPermission>
				<input id="btnCancel" class="btn btn-white" type="button" value="返回" onclick="history.go(-1)"/>
			</div>
		</form:form>
	</div>
</div>
</div>
</body>
</html>