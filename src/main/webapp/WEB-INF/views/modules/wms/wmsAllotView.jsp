<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>调拨单查看</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">		
	</script>
</head>
<body class="gray-bg">
<div class="wrapper-content">
<div class="ibox">
	<div class="ibox-title">
		<h5>调拨单查看</h5>
	</div>
	<div class="ibox-content">
	<sys:message content="${message}"/>
	<div class="row">
		<div class="col-sm-12">
			<div class="text-center p-lg">
            	<h2>调拨单</h2>
            </div>
		</div>
	</div>
	<form:form id="inputForm" modelAttribute="wmsAllot" action="${ctx}/wms/wmsAllot/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
	 <table class="table table-bordered table-condensed dataTables-example dataTable no-footer">
		<tbody>
			<tr>
					<td class="width-15 active"><label class="pull-right">单号：</label></td>
					<td class="width-35">
						${wmsAllot.no}
					</td>
					<td class="width-15 active"><label class="pull-right">总数量：</label></td>
					<td class="width-35">
						${wmsAllot.num}
					</td>
				</tr>
				<tr> 
					<td class="width-15 active"><label class="pull-right">调出仓库：</label></td>
					<td class="width-35">
						${wmsAllot.outWarehouse.name}
					</td>
					<td class="width-15 active"><label class="pull-right">调入出库：</label></td>
					<td class="width-35">
						${wmsAllot.inWarehouse.name}
					</td>
				</tr>
				<tr> 
					<td class="width-15 active"><label class="pull-right">物流公司：</label></td>
					<td class="width-35">
						${wmsAllot.logisticsCompany}
					</td>
					<td class="width-15 active"><label class="pull-right">物流单号：</label></td>
					<td class="width-35">
						${wmsAllot.logisticsNo}
					</td>
				</tr>
				<tr> 
					<td class="width-15 active"><label class="pull-right">运费：</label></td>
					<td class="width-35">
						${wmsAllot.logisticsAmount}
					</td>
					<td class="width-15 active"><label class="pull-right">支付账户：</label></td>
					<td class="width-35">
						${wmsAllot.fiAccount.name}
					</td>
				</tr>
				<tr> 
					<td class="width-15 active"><label class="pull-right">经办人：</label></td>
					<td class="width-35">
						${wmsAllot.dealBy.name}
					</td>
					<td class="width-15 active"><label class="pull-right">业务日期：</label></td>
					<td class="width-35">
						<fmt:formatDate value="${wmsAllot.dealDate}" pattern="yyyy-MM-dd"/>
					</td>
				</tr>
				<tr> 
					<td class="width-15 active"><label class="pull-right">审核状态：</label></td>
					<td class="width-35" colspan="3">
						${fns:getDictLabel(wmsAllot.status, 'audit_status', '')}
					</td>
				</tr>
				<tr> 
					<td class="width-15 active"><label class="pull-right">审核人：</label></td>
					<td class="width-35">
						${wmsAllot.auditBy.name}
					</td>
					<td class="width-15 active"><label class="pull-right">审核时间：</label></td>
					<td class="width-35">
						<fmt:formatDate value="${wmsAllot.auditDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
					</td>
				</tr>
				<tr> 
					<td class="width-15 active"><label class="pull-right">制单人：</label></td>
					<td class="width-35">
						${wmsAllot.createBy.name}
					</td>
					<td class="width-15 active"><label class="pull-right">制单时间：</label></td>
					<td class="width-35">
						<fmt:formatDate value="${wmsAllot.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
					</td>
				</tr>
				<tr> 
					<td class="width-15 active"><label class="pull-right">备注信息：</label></td>
					<td class="width-35" colspan="3">
						${wmsAllot.remarks}
					</td>
				</tr>
			</tbody>
		</table>
		<!-- 明细 -->
		<div class="tabs-container">
	    	<ul class="nav nav-tabs">
				<li class="active"><a data-toggle="tab" href="#tab-1" aria-expanded="true">调拨单明细</a></li>
	    	</ul>
          	<div class="tab-content">
          	   	<div class="panel-body">
					<div id="tab-1" class="tab-pane table-responsive active">
					<table id="contentTable" class="table table-striped table-bordered table-hover table-condensed">
						<thead>
							<tr>
								<th>产品编码</th>
								<th>产品名称</th>
								<th>规格</th>
								<th>单位</th>
								<th>数量</th>
								<th>备注</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach items="${wmsAllot.wmsAllotDetailList}" var="wmsAllotDetail">
								<tr>
											<td>
												${wmsAllotDetail.product.no}
											</td>
											<td>
												${wmsAllotDetail.product.name}
											</td>
											<td>
												${wmsAllotDetail.product.spec}
											</td>
											<td>
												${wmsAllotDetail.unitType}
											</td>
											<td>
												${wmsAllotDetail.num}
											</td>
											<td>
												${wmsAllotDetail.remarks}
											</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>					
					</div>
				</div>
			</div>
		</div>
		
		<br>
			<div class="form-actions">
				<c:if test="${wmsAllot.status == 0}">
				<shiro:hasPermission name="wms:wmsAllot:edit">
			    	<a href="${ctx}/wms/wmsAllot/form?id=${wmsAllot.id}" class="btn btn-success" title="修改"><i class="fa fa-edit"></i><span class="hidden-xs">修改</span></a>
				</shiro:hasPermission>
				<shiro:hasPermission name="wms:wmsAllot:audit">
					<a href="${ctx}/wms/wmsAllot/audit?id=${wmsAllot.id}" onclick="return confirmx('确认要审核该调拨单吗？', this.href)" class="btn btn-success" title="审核"><i class="fa fa-check"></i><span class="hidden-xs">审核</span></a> 
				</shiro:hasPermission>
				<shiro:hasPermission name="wms:wmsAllot:del">
					<a href="${ctx}/wms/wmsAllot/delete?id=${wmsAllot.id}" onclick="return confirmx('确认要删除该调拨单吗？', this.href)" class="btn  btn-danger" title="删除"><i class="fa fa-trash"></i><span class="hidden-xs">删除</span></a> 
				</shiro:hasPermission>
				</c:if>
				<input id="btnCancel" class="btn btn-white" type="button" value="返 回" onclick="history.go(-1)"/>
			</div>
		<br>
	</form:form>
	</div>
</div>
</div>
</body>
</html>