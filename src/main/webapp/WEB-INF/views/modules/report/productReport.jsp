<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>产品销售统计</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
			
		});
	</script>
</head>
<body class="gray-bg">
	<div class="wrapper-content">
		<div class="ibox">
			<div class="ibox-title">
				<h5>产品统计 </h5>
			</div>
			<div class="ibox-content">
			<sys:message content="${message}"/>
				
				<!-- 查询条件 -->
				<div class="row">
					<div class="col-sm-12">
					<form:form id="searchForm" modelAttribute="crmReport" action="${ctx}/report/productReport/list" method="post" class="form-inline">
							<div class="form-group"><label>时间：</label>
								<input name="startDate" type="text" readonly="readonly" maxlength="20" class="laydate-icon form-control input-medium"
									value="<fmt:formatDate value="${crmReport.startDate}" pattern="yyyy-MM-dd"/>"
									onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
									-
								<input name="endDate" type="text" readonly="readonly" maxlength="20" class="laydate-icon form-control input-medium"
									value="<fmt:formatDate value="${crmReport.endDate}" pattern="yyyy-MM-dd"/>"
									onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
							</div>
							
							<div class="form-group">
								<input id="btnSubmit" class="btn btn-success" type="submit" value="查询"/> 
								<a class="btn btn-white" href="${ctx}/report/productReport/list"/>重置</a>
							</div>
						
					</form:form>
				<!-- 表格 -->
				<div class="table-responsive">
				<table id="contentTable" class="table table-bordered table-striped table-hover">
				<thead>
					<tr>
						<th>产品</th>
						<th>销售数量</th>
						<th>销售总额</th>
					</tr>
				</thead>
				<tbody>
				<c:forEach items="${crmReportList}" var="crmReport">
					<tr>
						<td>
							${crmReport.proName}
						</td>
						<td>
							${crmReport.productSaleNum}
						</td>
						<td>
							${crmReport.productSaleAmt}
						</td>
					</tr>
				</c:forEach>
				</tbody>
			</table>
			</div></div>
	</div></div></div></div>
</body>
</html>