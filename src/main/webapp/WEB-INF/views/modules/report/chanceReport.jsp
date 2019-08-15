<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>销售漏斗</title>
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
				<h5>销售漏斗分析</h5>
			</div>
			<div class="ibox-content">
			<sys:message content="${message}"/>
				
				<!-- 查询条件 -->
				<div class="row">
					<div class="col-sm-12">
					<form:form id="searchForm" modelAttribute="crmChanceReport" action="${ctx}/report/crmChanceReport/list" method="post" class="form-inline">
						
							<div class="form-group"><label>用户名：</label>
								<sys:treeselect id="user" name="user.id" value="${crmChanceReport.user.id}" labelName="user.name" labelValue="${crmChanceReport.user.name}"
									title="用户" url="/sys/office/treeData?type=3" cssClass="form-control input-medium" allowClear="true" notAllowSelectParent="true"/>
							</div>
							<div class="form-group"><label>归属部门：</label>
								<sys:treeselect id="office" name="office.id" value="${crmChanceReport.office.id}" labelName="office.name" labelValue="${crmChanceReport.office.name}" 
								title="部门" url="/sys/office/treeData?type=2" cssClass="form-control input-medium" allowClear="true" notAllowSelectParent="true"/>
							</div>
							<div class="form-group"><label>时间：</label>
								<input name="startDate" type="text" readonly="readonly" maxlength="20" class="laydate-icon form-control input-medium"
									value="<fmt:formatDate value="${crmChanceReport.startDate}" pattern="yyyy-MM-dd"/>"
									onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
									-
								<input name="endDate" type="text" readonly="readonly" maxlength="20" class="laydate-icon form-control input-medium"
									value="<fmt:formatDate value="${crmChanceReport.endDate}" pattern="yyyy-MM-dd"/>"
									onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
							</div>
							
							<div class="form-group">
								<input id="btnSubmit" class="btn btn-info" type="submit" value="查询"/> 
								<a class="btn btn-white" href="${ctx}/report/crmChanceReport/list"/>重 置</a>
								
							</div>
					</form:form>
				
				
			</div>
		</div>
	</div>
	</div>	
	</div>
	<%@ include file="/WEB-INF/views/include/echarts.jsp"%>
	<div class="wrapper-content">
		<div id="funnel"  class="main000"></div>
		<echarts:funnel
	    id="funnel"
		title="销售漏斗" 
		subtitle="纯属虚构"
		orientData="${orientData}"/>
		</div>
	
</body>
</html>