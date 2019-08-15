<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>图表配置查看</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">		
	</script>
</head>
<body class="hideScroll">
	<form:form id="inputForm" modelAttribute="genReport" action="${ctx}/gen/genReport/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>	
	 <table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
		<tbody>
			<tr>
					<td class="width-15 active"><label class="pull-right">名称：</label></td>
					<td class="width-35">
						${genReport.name}
					</td>
					<td class="width-15 active"><label class="pull-right">描述：</label></td>
					<td class="width-35">
						${genReport.comments}
					</td>
				</tr>
				<tr> 
					<td class="width-15 active"><label class="pull-right">表名：</label></td>
					<td class="width-35">
						${genReport.tableName}
					</td>
					<td class="width-15 active"><label class="pull-right">图表类型：</label></td>
					<td class="width-35">
						${fns:getDictLabel(genReport.reportType, 'report_type', '')}
					</td>
				</tr>
				<tr> 
					<td class="width-15 active"><label class="pull-right">X轴字段：</label></td>
					<td class="width-35">
						${genReport.xAxis}
					</td>
					<td class="width-15 active"><label class="pull-right">Y轴字段：</label></td>
					<td class="width-35">
						${genReport.yAxis}
					</td>
				</tr>
				<tr> 
					<td class="width-15 active"><label class="pull-right">查询数据SQL：</label></td>
					<td class="width-35">
						${genReport.querySql}
					</td>
					<td class="width-15 active"><label class="pull-right">备注信息：</label></td>
					<td class="width-35">
						${genReport.remarks}
					</td>
				</tr>
				<tr> 
				</tr>
			</tbody>
		</table>
		<!-- 明细 -->
		<div class="tabs-container">
	    	<ul class="nav nav-tabs">
				<li class="active"><a data-toggle="tab" href="#tab-1" aria-expanded="true">图表配置明细</a></li>
	    	</ul>
          	<div class="tab-content">
          	   	<div class="panel-body">
					<div id="tab-1" class="tab-pane table-responsive active">
					<table id="contentTable" class="table table-striped table-bordered table-hover table-condensed">
						<thead>
							<tr>
								<th>字段名</th>
								<th>字段描述</th>
								<th>字段类型</th>
								<th>是否显示</th>
								<th>是否查询</th>
								<th>查询方式</th>
								<th>显示类型</th>
								<th>字典类型</th>
								<th>排序（升序）</th>
								<th>备注信息</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach items="${genReport.genReportColumnList}" var="genReportColumn">
								<tr>
											<td>
												${genReportColumn.javaField}
											</td>
											<td>
												${genReportColumn.name}
											</td>
											<td>
												${fns:getDictLabel(genReportColumn.javaType, 'java_type', '')}
											</td>
											<td>
												${fns:getDictLabel(genReportColumn.isList, 'yes_no', '')}
											</td>
											<td>
												${fns:getDictLabel(genReportColumn.isQuery, 'yes_no', '')}
											</td>
											<td>
												${fns:getDictLabel(genReportColumn.queryType, 'query_type', '')}
											</td>
											<td>
												${fns:getDictLabel(genReportColumn.showType, 'show_type', '')}
											</td>
											<td>
												${genReportColumn.dictType}
											</td>
											<td>
												${genReportColumn.sort}
											</td>
											<td>
												${genReportColumn.remarks}
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