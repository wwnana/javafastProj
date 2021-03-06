<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>分类列表</title>
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
							inMenu: getDictLabel(${fns:toJson(fns:getDictList('yes_no'))}, row.inMenu),
						blank123:0}, pid: (root?0:pid), row: row
					}));
					addRow(list, tpl, data, row.id);
				}
			}
		}
		function refresh(){//刷新
			
			window.location="${ctx}/kms/kmsCategory/";
		}
	</script>
</head>
<body class="gray-bg">
	<div class="">
	<div class="">
	<div class="ibox-title">
			<h5>知识分类 </h5>
	</div>
    
    <div class="ibox-content">
	<sys:message content="${message}"/>

	<!--查询条件-->
	<div class="row">
	<div class="col-sm-12">
		<form:form id="searchForm" modelAttribute="kmsCategory" action="${ctx}/kms/kmsCategory/" method="post" class="breadcrumb form-search">
			
		</form:form>
	</div>
	</div>
	<!-- 工具栏 -->
	<div class="row">
	<div class="col-sm-12 m-b-sm">
		<div class="pull-left">
			<shiro:hasPermission name="kms:kmsArticle:add">
				<table:addRow url="${ctx}/kms/kmsCategory/form" title="分类"></table:addRow><!-- 增加按钮 -->
			</shiro:hasPermission>
	       <button class="btn btn-white btn-sm " data-toggle="tooltip" data-placement="left" onclick="refresh()" title="刷新"><i class="glyphicon glyphicon-repeat"></i> 刷新</button>
	       <a href="${ctx}/kms/kmsArticle/index" class="btn btn-white btn-sm">返回知识列表</a>
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
				<th width="100px">是否显示</th>
				<th width="200px">操作</th>
			</tr>
		</thead>
		<tbody id="treeTableList"></tbody>
	</table>
	</div>
	<script type="text/template" id="treeTableTpl">
		<tr id="{{row.id}}" pId="{{pid}}">
			<td><a href="#" onclick="openDialogView('查看分类', '${ctx}/kms/kmsCategory/form?id={{row.id}}','800px', '500px')">
				{{row.name}}
			</a></td>
			<td>
				{{row.sort}}
			</td>
			<td>
				{{dict.inMenu}}
			</td>
			<td>
   				
			<shiro:hasPermission name="kms:kmsArticle:edit">
   				<a href="#" onclick="openDialog('修改分类', '${ctx}/kms/kmsCategory/form?id={{row.id}}','800px', '500px')" class="btn btn-success btn-xs" ><i class="fa fa-edit"></i> 修改</a>
   			</shiro:hasPermission>
   			<shiro:hasPermission name="kms:kmsArticle:del">
				<a href="${ctx}/kms/kmsCategory/delete?id={{row.id}}" onclick="return confirmx('确认要删除该分类及所有子分类吗？', this.href)" class="btn btn-danger btn-xs" ><i class="fa fa-trash"></i> 删除</a>
			</shiro:hasPermission>
   			<shiro:hasPermission name="kms:kmsArticle:add">
				<a href="#" onclick="openDialog('添加下级分类', '${ctx}/kms/kmsCategory/form?parent.id={{row.id}}','800px', '500px')" class="btn btn-success btn-xs" ><i class="fa fa-plus"></i> 添加下级</a>
			</shiro:hasPermission>
			</td>
		</tr>
	</script>
	</div></div></div>
</body>
</html>