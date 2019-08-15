<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>常见问题分类列表</title>
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
			
			window.location="${ctx}/scm/scmProblemType/";
		}
	</script>
</head>
<body class="">
	<div class="">
	<div class="">
	<div class="ibox-title">
			<h5>常见问题分类列表 </h5>
	</div>
    
    <div class="ibox-content">
	<sys:message content="${message}"/>

	<!--查询条件-->
	<div class="row">
	<div class="col-sm-12">
		<form:form id="searchForm" modelAttribute="scmProblemType" action="${ctx}/scm/scmProblemType/" method="post" class="breadcrumb form-search">
			
		</form:form>
	</div>
	</div>
	<!-- 工具栏 -->
	<div class="row m-b-sm">
	<div class="col-sm-12">
		<div class="pull-left">
			<shiro:hasPermission name="scm:scmProblem:add">
				<table:addRow url="${ctx}/scm/scmProblemType/form" title="常见问题分类"></table:addRow><!-- 增加按钮 -->
			</shiro:hasPermission>
	       <button class="btn btn-white btn-sm " data-toggle="tooltip" data-placement="left" onclick="refresh()" title="刷新"><i class="glyphicon glyphicon-repeat"></i> 刷新</button>
	       <a href="${ctx}/scm/scmProblem/index" class="btn btn-white btn-sm">返回常见问题列表</a>
		</div>
		<div class="pull-right">
			
		</div>
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
			<td><a href="#" onclick="openDialogView('查看常见问题分类', '${ctx}/scm/scmProblemType/form?id={{row.id}}','800px', '500px')">
				{{row.name}}
			</a></td>
			<td>
				{{row.sort}}
			</td>
			<td>
   				
			<shiro:hasPermission name="scm:scmProblem:edit">
   				<a href="#" onclick="openDialog('修改常见问题分类', '${ctx}/scm/scmProblemType/form?id={{row.id}}','800px', '500px')" class="btn btn-success btn-xs" ><i class="fa fa-edit"></i> 修改</a>
   			</shiro:hasPermission>
   			<shiro:hasPermission name="scm:scmProblem:del">
				<a href="${ctx}/scm/scmProblemType/delete?id={{row.id}}" onclick="return confirmx('确认要删除该常见问题分类及所有子常见问题分类吗？', this.href)" class="btn btn-danger btn-xs" ><i class="fa fa-trash"></i> 删除</a>
			</shiro:hasPermission>
   			<shiro:hasPermission name="scm:scmProblem:add">
				<a href="#" onclick="openDialog('添加下级分类', '${ctx}/scm/scmProblemType/form?parent.id={{row.id}}','800px', '500px')" class="btn btn-success btn-xs" ><i class="fa fa-plus"></i> 添加下级</a>
			</shiro:hasPermission>
			</td>
		</tr>
	</script>
</body>
</html>