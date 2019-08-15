<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>应付款查看</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">		
	</script>
</head>
<body class="gray-bg">
<div class="wrapper-content">
	<div class="ibox">
		<div class="ibox-title">
			<h5>应付款查看</h5>
		</div>
		<div class="ibox-content">
		<sys:message content="${message}"/>	
		
		
	<form:form id="inputForm" modelAttribute="fiPaymentAble" action="${ctx}/fi/fiPaymentAble/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>

	 <table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
		<tbody>
			<tr>
					<td class="width-15 active"><label class="pull-right">单号：</label></td>
					<td class="width-35">
						${fiPaymentAble.no}
					</td>
					<td class="width-15 active"><label class="pull-right">状态：</label></td>
					<td class="width-35">
						${fns:getDictLabel(fiPaymentAble.status, 'finish_status', '')}
					</td>
				</tr>
				<tr>	
					<td class="width-15 active"><label class="pull-right">采购单/退货单：</label></td>
					<td class="width-35">
						${fiPaymentAble.purchase.no}
						${fiPaymentAble.returnorder.no}
					</td>
				 
					<td class="width-15 active"><label class="pull-right">往来单位：</label></td>
					<td class="width-35">
								<c:if test="${not empty fiPaymentAble.supplier.id}">
									[供应商] ${fiPaymentAble.supplier.name}
								</c:if>
								<c:if test="${not empty fiPaymentAble.customer.id}">
									[客户] ${fiPaymentAble.customer.name}
								</c:if>
					</td>
				</tr>
				<tr>
					<td class="width-15 active"><label class="pull-right">应付金额：</label></td>
					<td class="width-35">
						${fiPaymentAble.amount}
					</td>
					<td class="width-15 active"><label class="pull-right">实际已付：</label></td>
					<td class="width-35">
						${fiPaymentAble.realAmt}
					</td>
				</tr>
				<tr>
					<td class="width-15 active"><label class="pull-right">应付时间：</label></td>
					<td class="width-35">
						<fmt:formatDate value="${fiPaymentAble.ableDate}" pattern="yyyy-MM-dd"/>
					</td>
					<td class="width-15 active"><label class="pull-right">负责人：</label></td>
					<td class="width-35">
						${fiPaymentAble.ownBy.name}
					</td>
					
				</tr>
				<tr> 
					<td class="width-15 active"><label class="pull-right">备注：</label></td>
					<td class="width-35" colspan="3">
						${fiPaymentAble.remarks}
					</td>
				</tr>
			</tbody>
		</table>
		<!-- 明细 -->
		<div class="tabs-container">
	    	<ul class="nav nav-tabs">
				<li class="active"><a data-toggle="tab" href="#tab-1" aria-expanded="true">付款单</a></li>
	    	</ul>
          	<div class="tab-content">
          	   	<div class="panel-body">
					<div id="tab-1" class="tab-pane table-responsive active">
					<table id="contentTable" class="table table-striped table-bordered table-hover table-condensed">
						<thead>
							<tr>
								<th>单号</th>
								<th>供应商</th>
								<th>付款金额</th>
								<th>付款时间</th>
								<th>付款账户</th>
								<th>负责人</th>
								<th>状态</th>
								<th>备注</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach items="${fiPaymentAble.fiPaymentBillList}" var="fiPaymentBill">
								<tr>
											<td>
												${fiPaymentBill.no}
											</td>
											<td>
												${fiPaymentBill.supplier.name}
											</td>
											<td>
												${fiPaymentBill.amount}
											</td>
											<td>
												<fmt:formatDate value="${fiPaymentBill.dealDate}" pattern="yyyy-MM-dd"/>
											</td>
											<td>
												${fiPaymentBill.fiAccount.name}
											</td>
											<td>
												${fiPaymentBill.ownBy.name}
											</td>
											<td>
												${fns:getDictLabel(fiPaymentBill.status, 'audit_status', '')}
											</td>
											<td>
												${fiPaymentBill.remarks}
											</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>	
					<c:if test="${fiPaymentAble.status != 2}">	
					<shiro:hasPermission name="fi:fiPaymentBill:add">
    					<a href="#" onclick="openDialog('添加付款单', '${ctx}/fi/fiPaymentBill/form?fiPaymentAble.id=${fiPaymentAble.id}&fiPaymentAble.name=${fiPaymentAble.no}&supplier.id=${fiPaymentAble.supplier.id}&supplier.name=${fiPaymentAble.supplier.name}','800px', '500px')" class="btn btn-info" title="添加付款单"><i class="fa fa-plus"></i>
							<span class="hidden-xs">添加付款单</span></a>
					</shiro:hasPermission>		
					</c:if>		
					</div>
				</div>
			</div>
		</div>
	<br>
				<div class="form-actions">
					
				<c:if test="${fiPaymentAble.status != 2}">	
					<shiro:hasPermission name="fi:fiPaymentAble:edit">
    					<a href="#" onclick="openDialog('修改应付款', '${ctx}/fi/fiPaymentAble/editForm?id=${fiPaymentAble.id}','800px', '500px')" class="btn btn-success" title="修改">修改</a>
					</shiro:hasPermission>
				</c:if>	
					
								
					<input id="btnCancel" class="btn btn-white" type="button" value="返 回" onclick="history.go(-1)"/>
				</div>
			<br>
	</form:form>
</div></div></div>
</body>
</html>