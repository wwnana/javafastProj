<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>报表展现</title>
	<meta name="decorator" content="default"/>
	<%@ include file="/WEB-INF/views/include/echarts.jsp"%>
	<script type="text/javascript">
		$(document).ready(function() {
		});
		//0:隐藏tip, 1隐藏box,不设置显示全部
		top.$.jBox.closeTip();
		function doRefresh(){
			window.location.href = "${ctx}/gen/genReport/report?id=${genReport.id}";
		}
	</script>
</head>
<body class="">
	<div class="wrapper-content">
		
	<c:if test="${genReport.reportType eq 'pie'}">
		<div id="pie"  class="main000"></div>
		<echarts:pie
		    id="pie"
			title="${genReport.name }" 
			subtitle="${genReport.comments }"
			orientData="${pieData}"/>
	</c:if>
	<c:if test="${genReport.reportType eq 'bar'}">
		<div id="bar_normal"  class="main000"></div>
		<echarts:bar 
	  	id="bar_normal"
		title="${genReport.name }" 
		subtitle="${genReport.comments }"
		xAxisData="${xAxisData}" 
		yAxisData="${yAxisData}" 
		xAxisName="${xAxisName}"
		yAxisName="${yAxisName}" 
		/>
	</c:if>
	<c:if test="${genReport.reportType eq 'line'}">
		<div id="line_normal"  class="main000"></div>
		<echarts:line 
        id="line_normal"
		title="${genReport.name }" 
		subtitle="${genReport.comments }"
		xAxisData="${xAxisData}" 
		yAxisData="${yAxisData}" 
		xAxisName="${xAxisName}"
		yAxisName="${yAxisName}" 
		/>
	</c:if>
	<div class="ibox">
	<div class="ibox-title">
		<h5>数据明细 </h5>
		<div class="ibox-tools">
			<a class="collapse-link">
				<i class="fa fa-chevron-up"></i>
			</a>
			
			<a class="close-link">
				<i class="fa fa-times"></i>
			</a>
		</div>
	</div>
    
    <div class="ibox-content">
	<sys:message content="${message}"/>
	
	<!--查询条件-->
	<div class="row">
		<div class="col-sm-12">		
		<form:form id="searchForm" modelAttribute="crmReport" action="${ctx}/gen/genReport/report?id=${genReport.id}" method="post" class="form-inline">
				
				<%-- 
				<c:forEach items="${genReport.genReportColumnList }" var="reportColumn">
					<c:if test="${reportColumn.isQuery == 1}">
						<div class="form-group">
							<label>${reportColumn.name}：</label>
							<input name="${reportColumn.javaField}" value="${reportColumn.javaField}" type="text" maxlength="50" class="form-control"/>
						</div>
					</c:if>
				</c:forEach>
				<div class="form-group">
					<input id="btnSubmit" class="btn btn-success" type="submit" value="查询"/> 
					<input class="btn btn-white" type="button" onclick="resetSearch()" value="重置"/>
					
				</div>
				--%>
				
				${queryDiv }
			
				
			</form:form>		 	
		</div>
	</div>
	
	<!-- 工具栏 
	<div class="row mt10">
		<div class="col-sm-12">
			<div class="pull-left">
				<a class="btn btn-white btn-sm" href="${ctx}/gen/genReport/report?id=${genReport.id}"/><i class="glyphicon glyphicon-repeat"></i> 刷新</a>
			</div>
		</div>
	</div>
	-->
	<!-- 表格 -->
	<table id="contentTable" class="table table-striped table-bordered table-hover table-condensed dataTables-example dataTable">
		<thead>
			<tr>
				<c:forEach items="${genReport.genReportColumnList}" var="genReportColumn">
					<th>${genReportColumn.name}</th>
				</c:forEach>				
			</tr>
		</thead>
		<tbody>
			<c:forEach items="${list}" var="entry">
				<tr>
					<c:forEach items="${genReport.genReportColumnList}" var="genReportColumn">
						<td>
							<c:forEach items="${entry}" var="comment">
								<c:if test="${comment.key eq genReportColumn.javaField}">
									<c:if test="${not empty genReportColumn.dictType}">${fns:getDictLabel(comment.value, genReportColumn.dictType, '')}</c:if>
									<c:if test="${empty genReportColumn.dictType}">${comment.value }</c:if>
								</c:if>
							</c:forEach>
						</td>
					</c:forEach>
				</tr>
			</c:forEach>
		</tbody>
	</table>
	
	<br/>
	<br/>
	</div>
	</div>
</div>
</body>
</html>