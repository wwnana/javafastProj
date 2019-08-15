<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>机构管理</title>
	<meta name="decorator" content="default"/>
	<%@include file="/WEB-INF/views/include/treetable.jsp" %>
	<script type="text/javascript">
		$(document).ready(function() {
			var tpl = $("#treeTableTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g,"");
			var data = ${fns:toJson(list)}, rootId = "${not empty office.id ? office.id : '0'}";
			addRow("#treeTableList", tpl, data, rootId, true);
			$("#treeTable").treeTable({expandLevel : 5});
		});
		function addRow(list, tpl, data, pid, root){
			for (var i=0; i<data.length; i++){
				var row = data[i];
				if ((${fns:jsGetVal('row.parentId')}) == pid){
					$(list).append(Mustache.render(tpl, {
						dict: {
							type: getDictLabel(${fns:toJson(fns:getDictList('sys_office_type'))}, row.type)
						}, pid: (root?0:pid), row: row
					}));
					addRow(list, tpl, data, row.id);
				}
			}
		}
		function refresh(){//刷新或者排序，页码不清零
    		
			window.location="${ctx}/sys/office/list";
    	}
	</script>
</head>

<body class="">
<div class="">
	<sys:message content="${message}"/>
	<div class="">
		<div class="row dashboard-header gray-bg">
			<h5>组织机构 </h5>
			<div class="pull-right">
				<a href="${ctx}/sys/office/list" class="btn btn-white btn-sm active" title="列表展示"><i class="fa fa-list-ul"></i></a>
				<a href="${ctx}/sys/office/map" class="btn btn-white btn-sm" title="列块展示"><i class="fa fa-sitemap"></i></a>	
				<a href="${ctx}/sys/office/list" class="btn btn-white btn-sm" title="刷新"><i class="fa fa-refresh"></i></a>
				<shiro:hasPermission name="sys:office:add">
					<table:addRow url="${ctx}/sys/office/form?parent.id=${office.id}" title="机构" label="添加机构"></table:addRow><!-- 增加按钮 -->
				</shiro:hasPermission>
			</div>		
		</div>
		<div class="ibox-content">
	    	
			
			<div class="table-responsive">
			<table id="treeTable" class="table table-bordered table-striped table-hover">
				<thead>
					<tr>
						<th>机构名称</th>
						<th width="120px">机构类型</th>
						<th width="120px">负责人</th>
						<th width="120px">员工数</th>
						<th width="210px">操作</th>
					</tr>
				</thead>
				<tbody id="treeTableList"></tbody>
			</table>

			<script type="text/template" id="treeTableTpl">
			<tr id="{{row.id}}" pId="{{pid}}">
			<td><a href="#" onclick="openDialog('修改机构', '${ctx}/sys/office/form?id={{row.id}}','800px', '500px')">{{row.name}}</a></td>
			<td>{{dict.type}}</td>
			<td>{{row.primaryPerson.name}}</td>
			<td>{{row.userNum}}</td>
			<td>
				
				<shiro:hasPermission name="sys:office:edit">
					<a href="#" onclick="openDialog('修改机构', '${ctx}/sys/office/form?id={{row.id}}','800px', '500px')" class="" title="修改"> 修改</a>
				</shiro:hasPermission>
				<shiro:hasPermission name="sys:office:del">
					<a href="${ctx}/sys/office/delete?id={{row.id}}" onclick="return confirmx('要删除该机构及所有子机构项吗？', this.href)" class="" title="删除"> 删除</a>
				</shiro:hasPermission>
				<shiro:hasPermission name="sys:office:add">
					<a href="#" onclick="openDialog('添加下级机构', '${ctx}/sys/office/form?parent.id={{row.id}}','800px', '500px')" class="" title="添加下级机构"> 添加下级机构</a>
				</shiro:hasPermission>
			</td>
			</tr>
			</script>
			</div>
		</div>
	</div>
</div>
</body>
</html>