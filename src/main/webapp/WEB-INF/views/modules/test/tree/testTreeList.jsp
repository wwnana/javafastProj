<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>树结构(商品分类)列表</title>
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
			
			window.location="${ctx}/test/tree/testTree/";
		}
	</script>
</head>
<body class="">
	<div class="">
	<div class="">
	<div class="row dashboard-header gray-bg">
		<h5>树结构(商品分类)列表 </h5>
		<div class="pull-right">
				
				<shiro:hasPermission name="test:tree:testTree:add">
					<table:addRow url="${ctx}/test/tree/testTree/form" title="树结构(商品分类)" ></table:addRow><!-- 增加按钮 -->
				</shiro:hasPermission>
		</div>
	</div>
    
    <div class="ibox-content">
	<sys:message content="${message}"/>

	<!--查询条件-->
	<div class="row">
	<div class="col-sm-12">
		<form:form id="searchForm" modelAttribute="testTree" action="${ctx}/test/tree/testTree/" method="post" class="form-inline">
				<div class="form-group">
				<span>分类名称：</span>
					<form:input path="name" htmlEscape="false" maxlength="50" class="form-control input-medium"/>
				</div>
				<div class="form-group">
					<button class="btn btn-white btn-sm " onclick="search()"><i class="fa fa-search"></i> 查询</button>
					<button class="btn btn-white btn-sm " onclick="resetSearch()"><i class="fa fa-refresh"></i> 重置</button>
				</div>
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
			<td>
				<a href="#" onclick="openDialogView('查看树结构(商品分类)', '${ctx}/test/tree/testTree/form?id={{row.id}}','800px', '500px')">
				{{row.name}}
			</a></td>
			<td>
				{{row.sort}}
			</td>
			<td>
			<shiro:hasPermission name="test:tree:testTree:edit">
   				<a href="#" onclick="openDialog('修改树结构(商品分类)', '${ctx}/test/tree/testTree/form?id={{row.id}}','800px', '500px')" class="btn btn-success btn-xs" title="修改">修改</a>
   			</shiro:hasPermission>   			
   			<shiro:hasPermission name="test:tree:testTree:add">
				<a href="#" onclick="openDialog('添加下级树结构(商品分类)', '${ctx}/test/tree/testTree/form?parent.id={{row.id}}','800px', '500px')" class="btn btn-success btn-xs" title="添加下级树结构(商品分类)">添加下级分类</a>
			</shiro:hasPermission>
			<shiro:hasPermission name="test:tree:testTree:del">
				<a href="${ctx}/test/tree/testTree/delete?id={{row.id}}" onclick="return confirmx('确认要删除该树结构(商品分类)及所有子树结构(商品分类)吗？', this.href)" class="btn btn-danger btn-xs" title="删除">删除</a>
			</shiro:hasPermission>
			</td>
		</tr>
	</script>
</body>
</html>