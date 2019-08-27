<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>项目统计</title>
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
				<h5>项目统计 </h5>
			</div>
			<div class="ibox-content">
			<sys:message content="${message}"/>
				
				<!-- 查询条件 -->
				<div class="row">
					<div class="col-sm-12">
				<!-- 表格 -->
				<div class="table-responsive">
				<table id="contentTable" class="table table-bordered table-striped table-hover">
				<thead>
					<tr>
						<th>已完成</th>
						<th>正在进行</th>
						<th>未开始</th>
						<th>已关闭</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>
							${projReport.finishNum}
						</td>
						<td>
							${projReport.startNum}
						</td>
						<td>
							${projReport.waitNum}
						</td>
						<td>
							${projReport.closedNum}
						</td>
					</tr>
				</tbody>
			</table>
			</div></div>
	</div></div></div></div>
</body>
</html>