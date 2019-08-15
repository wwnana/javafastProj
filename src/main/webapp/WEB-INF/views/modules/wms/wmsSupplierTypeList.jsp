<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>供应商分类管理</title>
	<meta name="decorator" content="default"/>
	<%@include file="/WEB-INF/views/include/treetable.jsp" %>
	<script type="text/javascript">
		$(document).ready(function() {
			var tpl = $("#treeTableTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g,"");
			var data = ${fns:toJson(list)}, ids = [], rootIds = [];
			for (var i=0; i<data.length; i++){
				ids.push(data[i].id);
			}
			ids = ',' + ids.join(',') + ',';
			for (var i=0; i<data.length; i++){
				if (ids.indexOf(','+data[i].parentId+',') == -1){
					if ((','+rootIds.join(',')+',').indexOf(','+data[i].parentId+',') == -1){
						rootIds.push(data[i].parentId);
					}
				}
			}
			for (var i=0; i<rootIds.length; i++){
				addRow("#treeTableList", tpl, data, rootIds[i], true);
			}
			$("#treeTable").treeTable({expandLevel : 5});
		});
		function addRow(list, tpl, data, pid, root){
			for (var i=0; i<data.length; i++){
				var row = data[i];
				if ((${fns:jsGetVal('row.parentId')}) == pid){
					$(list).append(Mustache.render(tpl, {
						dict: {
						blank123:0}, pid: (root?0:pid), row: row
					}));
					addRow(list, tpl, data, row.id);
				}
			}
		}
		function refresh(){//刷新
			
			window.location="${ctx}/wms/wmsSupplierType/";
		}
	</script>
</head>
<body class="gray-bg">
	<div class="">
		<div class="">
			<div class="row dashboard-header gray-bg">
				<h5>供应商分类列表</h5>
				<div class="pull-right">					
					
					<a class="btn btn-white btn-sm" href="${ctx}/wms/wmsSupplierType/" title="刷新"><i class="fa fa-refresh"></i></a>
					<shiro:hasPermission name="wms:wmsSupplier:add">
						<a class="btn btn-success btn-sm" onclick="openDialog('新建供应商分类', '${ctx}/wms/wmsSupplierType/form','800px', '500px')" title="新建分类"><i class="fa fa-plus"></i> 新建分类</a>
					</shiro:hasPermission>
					
				</div>			
			</div>
			
    <div class="ibox-content">
	<sys:message content="${message}"/>

	<!--查询条件-->
	<div class="row">
	<div class="col-sm-12">
		<form:form id="searchForm" modelAttribute="wmsSupplierType" action="${ctx}/wms/wmsSupplierType/" method="post" class="breadcrumb form-search">
			
		</form:form>
	</div>
	</div>
	

	<div class="table-responsive">
	<table id="treeTable" class="table table-bordered table-striped table-hover">
		<thead>
			<tr>
				<th>分类名称</th>
				<th width="100px">排序</th>
				<th width="200px">操作</th>
			</tr>
		</thead>
		<tbody id="treeTableList"></tbody>
	</table>
	</div>
	<script type="text/template" id="treeTableTpl">
		<tr id="{{row.id}}" pId="{{pid}}">
			<td><a href="#" onclick="openDialogView('查看供应商分类', '${ctx}/wms/wmsSupplierType/form?id={{row.id}}','800px', '500px')">
				{{row.name}}
			</a></td>
			<td>
				{{row.sort}}
			</td>
			<td>
   				
			<shiro:hasPermission name="wms:wmsSupplier:edit">
   				<a href="#" onclick="openDialog('修改供应商分类', '${ctx}/wms/wmsSupplierType/form?id={{row.id}}','800px', '500px')" class="" >修改</a>
   			</shiro:hasPermission>
   			<shiro:hasPermission name="wms:wmsSupplier:del">
				<a href="${ctx}/wms/wmsSupplierType/delete?id={{row.id}}" onclick="return confirmx('确认要删除该供应商分类及所有子供应商分类吗？', this.href)" class="" >删除</a>
			</shiro:hasPermission>
   			<shiro:hasPermission name="wms:wmsSupplier:add">
				<a href="#" onclick="openDialog('添加下级供应商分类', '${ctx}/wms/wmsSupplierType/form?parent.id={{row.id}}','800px', '500px')" class="" >添加下级分类</a>
			</shiro:hasPermission>
			</td>
		</tr>
	</script>
</body>
</html>