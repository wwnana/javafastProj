<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>借款单列表</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
		});
		//0:隐藏tip, 1隐藏box,不设置显示全部
		top.$.jBox.closeTip();
	</script>
</head>
<body class="gray-bg">
	<div class="wrapper-content">
		<div class="ibox">
			<div class="ibox-title">
				<h5>借款单列表 </h5>
			</div>
			<div class="ibox-content">
			<sys:message content="${message}"/>
				
				<!-- 查询条件 -->
				<div class="row">
					<div class="col-sm-12">
						<form:form id="searchForm" modelAttribute="oaCommonBorrow" action="${ctx}/oa/oaCommonBorrow/" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
								<div class="form-group"><span>借款时间：</span>
									<input name="beginBorrowDate" type="text" readonly="readonly" maxlength="20" class="laydate-icon form-control input-medium"
										value="<fmt:formatDate value="${oaCommonBorrow.beginBorrowDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"
										onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/> - 
									<input name="endBorrowDate" type="text" readonly="readonly" maxlength="20" class="laydate-icon form-control input-medium"
										value="<fmt:formatDate value="${oaCommonBorrow.endBorrowDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"
										onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/>
								</div>
						</form:form>
						<br>
					</div>
				</div>
				<!-- 工具栏 -->
				<div class="row">
					<div class="col-sm-12">
						<div class="pull-left">
							<shiro:hasPermission name="oa:oaCommonBorrow:add">
								<table:addRow url="${ctx}/oa/oaCommonBorrow/form" title="借款单" ></table:addRow><!-- 增加按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="oa:oaCommonBorrow:edit">
							    <table:editRow url="${ctx}/oa/oaCommonBorrow/form" title="借款单" id="contentTable" ></table:editRow><!-- 编辑按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="oa:oaCommonBorrow:del">
								<table:delRow url="${ctx}/oa/oaCommonBorrow/deleteAll" id="contentTable"></table:delRow><!-- 删除按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="oa:oaCommonBorrow:import">
								<table:importExcel url="${ctx}/oa/oaCommonBorrow/import"></table:importExcel><!-- 导入按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="oa:oaCommonBorrow:export">
					       		<table:exportExcel url="${ctx}/oa/oaCommonBorrow/export"></table:exportExcel><!-- 导出按钮 -->
					       	</shiro:hasPermission>
					       <button class="btn btn-white btn-sm " data-toggle="tooltip" data-placement="left" onclick="sortOrRefresh()" title="刷新"><i class="glyphicon glyphicon-repeat"></i> 刷新</button>
						
						</div>
						<div class="pull-right">
							<button  class="btn btn-success btn-rounded btn-outline btn-sm " onclick="search()" ><i class="fa fa-search"></i> 查询</button>
							<button  class="btn btn-success btn-rounded btn-outline btn-sm " onclick="resetSearch()" ><i class="fa fa-refresh"></i> 重置</button>
						</div>
					</div>
				</div>
					
				<!-- 表格 -->
				<table id="contentTable" class="table table-striped table-bordered table-hover table-condensed dataTables-example dataTable">
					<thead>
						<tr>
							<th><input type="checkbox" class="i-checks"></th>
							<th class="sort-column c.title">标题</th>
							<th class="sort-column u8.name">申请人</th>
							<th class="sort-column a.amount">借款总额</th>
							<th class="sort-column a.borrow_date">借款时间</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="oaCommonBorrow">
						<tr>
							<td><input type="checkbox" id="${oaCommonBorrow.id}" class="i-checks"></td>
							<td>
								<a href="${ctx}/oa/oaCommonAudit/view?id=${oaCommonBorrow.oaCommonAudit.id}">${oaCommonBorrow.oaCommonAudit.title}</a>
							</td>
							<td>
								${oaCommonBorrow.oaCommonAudit.createBy.name}
							</td>
							<td>
								${oaCommonBorrow.amount}
							</td>
							<td>
								<fmt:formatDate value="${oaCommonBorrow.borrowDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</td>
							<td>
								<shiro:hasPermission name="oa:oaCommonBorrow:view">
									<a href="#" onclick="openDialogView('查看借款单', '${ctx}/oa/oaCommonBorrow/view?id=${oaCommonBorrow.id}','800px', '500px')" class="btn btn-info btn-xs" title="查看"><i class="fa fa-search-plus"></i> 查看</a>
								</shiro:hasPermission>
								<shiro:hasPermission name="oa:oaCommonBorrow:edit">
			    					<a href="#" onclick="openDialog('修改借款单', '${ctx}/oa/oaCommonBorrow/form?id=${oaCommonBorrow.id}','800px', '500px')" class="btn btn-success btn-xs" title="修改"><i class="fa fa-edit"></i><span class="hidden-xs">修改</span></a>
								</shiro:hasPermission>
								
								<shiro:hasPermission name="oa:oaCommonBorrow:del">
									<a href="${ctx}/oa/oaCommonBorrow/delete?id=${oaCommonBorrow.id}" onclick="return confirmx('确认要删除该借款单吗？', this.href)" class="btn  btn-danger btn-xs" title="删除"><i class="fa fa-trash"></i><span class="hidden-xs">删除</span></a> 
								</shiro:hasPermission>
							</td>
						</tr>
					</c:forEach>
					</tbody>
				</table>
				<table:page page="${page}"></table:page>
				<br/>
			</div>
		</div>
	</div>
</body>
</html>