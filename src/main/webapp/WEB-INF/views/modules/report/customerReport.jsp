<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>客户统计</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {

			$("#btnExport").click(function(){
				top.layer.confirm('确认要导出Excel吗?', {icon: 3, title:'系统提示'}, function(index){
				    //do something
				    	//导出之前备份
				    	var url =  $("#searchForm").attr("action");

				    	//导出excel
				        $("#searchForm").attr("action","${ctx}/report/crmReport/export");
						$("#searchForm").submit();

						//导出excel之后还原
						$("#searchForm").attr("action",url);
				    top.layer.close(index);
				});
			});
		    
		});
	</script>
</head>
<body class="gray-bg">
	<div class="wrapper-content">
		<div class="ibox">
			<div class="ibox-title">
				<h5>客户统计 </h5>
			</div>
			<div class="ibox-content">
			<sys:message content="${message}"/>
				
				<!-- 查询条件 -->
				<div class="row">
					<div class="col-sm-12">
					<form:form id="searchForm" modelAttribute="crmReport" action="${ctx}/report/crmReport/list" method="post" class="form-inline">
						
						<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
							<div class="form-group"><label>用户名：</label>
								<sys:treeselect id="user" name="user.id" value="${crmReport.user.id}" labelName="user.name" labelValue="${crmReport.user.name}"
									title="用户" url="/sys/office/treeData?type=3" cssClass="form-control input-medium" allowClear="true" notAllowSelectParent="true"/>
							</div>
							<div class="form-group"><label>归属部门：</label>
								<sys:treeselect id="office" name="office.id" value="${crmReport.office.id}" labelName="office.name" labelValue="${crmReport.office.name}" 
								title="部门" url="/sys/office/treeData?type=2" cssClass="form-control input-medium" allowClear="true" notAllowSelectParent="true"/>
							</div>
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
								<input id="btnSubmit" class="btn btn-info" type="submit" value="查询"/> 
								<a class="btn btn-white" href="${ctx}/report/crmReport/list"/>重 置</a>
								<button id="btnExport" class="btn btn-white btn-sm " data-toggle="tooltip" data-placement="left" title="导出"><i class="fa fa-file-excel-o"></i> 导出</button>
								
							</div>
					</form:form>
	
				<!-- 表格 -->
				<div class="table-responsive">
				<table id="contentTable" class="table table-bordered table-striped table-hover">
					<thead>
						<tr>
							<th>员工</th>
							<th>添加客户数</th>
							<th>负责客户数</th>
							<th>创建商机数</th>
							<th>负责商机数</th>
							<th>签单数</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${crmReportList}" var="crmReport">
						<tr>
							<td>
								${crmReport.userName}
							</td>
							<td>
								${crmReport.createNum}
							</td>
							<td>
								${crmReport.ownNum}
							</td>
							<td>
								${crmReport.createChangeNum}
							</td>
							<td>
								${crmReport.ownChangeNum}
							</td>
							<td>
								${crmReport.createOrderNum}
							</td>
						</tr>
					</c:forEach>
					</tbody>
			</table>
			</div>
		</div>
	</div></div></div></div>
</body>
</html>