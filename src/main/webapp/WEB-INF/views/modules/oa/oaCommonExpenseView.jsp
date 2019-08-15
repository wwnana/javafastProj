<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>报销单查看</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">		
	</script>
</head>
<body class="hideScroll">
	<form:form id="inputForm" modelAttribute="oaCommonExpense" action="${ctx}/oa/oaCommonExpense/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
	 <table class="table table-bordered table-condensed dataTables-example dataTable no-footer">
		<tbody>
			<tr>
					<td class="width-15 active"><label class="pull-right">报销总额：</label></td>
					<td class="width-35">
						${oaCommonExpense.amount}
					</td>
				</tr>
			</tbody>
		</table>
		<!-- 明细 -->
		<div class="tabs-container">
	    	<ul class="nav nav-tabs">
				<li class="active"><a data-toggle="tab" href="#tab-1" aria-expanded="true">报销单明细</a></li>
	    	</ul>
          	<div class="tab-content">
          	   	<div class="panel-body">
					<div id="tab-1" class="tab-pane table-responsive active">
					<table id="contentTable" class="table table-striped table-bordered table-hover table-condensed">
						<thead>
							<tr>
								<th>报销事项</th>
								<th>日期</th>
								<th>报销金额（元）</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach items="${oaCommonExpense.oaCommonExpenseDetailList}" var="oaCommonExpenseDetail">
								<tr>
											<td>
												${oaCommonExpenseDetail.itemName}
											</td>
											<td>
												<fmt:formatDate value="${oaCommonExpenseDetail.date}" pattern="yyyy-MM-dd HH:mm:ss"/>
											</td>
											<td>
												${oaCommonExpenseDetail.amount}
											</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>					
					</div>
				</div>
			</div>
		</div>
		
	</form:form>
</body>
</html>