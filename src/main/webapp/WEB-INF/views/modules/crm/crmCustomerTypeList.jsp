<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>客户分类管理</title>
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
							authType: getDictLabel(${fns:toJson(fns:getDictList('auth_type'))}, row.authType),
						blank123:0}, pid: (root?0:pid), row: row
					}));
					addRow(list, tpl, data, row.id);
				}
			}
		}
		function refresh(){//刷新
			
			window.location="${ctx}/crm/crmCustomerType/";
		}
	</script>
</head>
<body class="gray-bg">
	<div class="wrapper-content">
	<div class="ibox">
	<div class="ibox-title">
			<h5>客户分类列表 </h5>
	</div>
    
    <div class="ibox-content">
	<sys:message content="${message}"/>

	<!--查询条件-->
	<div class="row">
	<div class="col-sm-12">
		<form:form id="searchForm" modelAttribute="crmCustomerType" action="${ctx}/crm/crmCustomerType/" method="post" class="breadcrumb form-search">
			<div class="form-group">
				<span>分类名称：</span>
					<form:input path="name" htmlEscape="false" maxlength="50" class="form-control input-medium"/>
				
				<%-- 
				<span>数据权限：</span>
					<form:select path="authType" class="input-medium">
						<form:option value="" label=""/>
						<form:options items="${fns:getDictList('auth_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
					</form:select>
				<span>创建人：</span>
					<sys:treeselect id="createBy" name="createBy.id" value="${crmCustomerType.createBy.id}" labelName="" labelValue="${crmCustomerType.createBy.name}"
						title="用户" url="/sys/office/treeData?type=3" cssClass="input-small" allowClear="true" notAllowSelectParent="true"/>
				<span>创建时间：</span>
					<input name="beginCreateDate" type="text" readonly="readonly" maxlength="20" class="input-medium form-control  Wdate"
						value="<fmt:formatDate value="${crmCustomerType.beginCreateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"
						onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/> - 
					<input name="endCreateDate" type="text" readonly="readonly" maxlength="20" class="input-medium form-control  Wdate"
						value="<fmt:formatDate value="${crmCustomerType.endCreateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"
						onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/>
					--%>
			</div>
		</form:form>
	</div>
	</div>
	<!-- 工具栏 -->
	<div class="row">
	<div class="col-sm-12">
		<div class="pull-left">
			<shiro:hasPermission name="crm:crmCustomerType:add">
				<table:addRow url="${ctx}/crm/crmCustomerType/form" title="客户分类"></table:addRow><!-- 增加按钮 -->
			</shiro:hasPermission>
	       <button class="btn btn-white btn-sm " data-toggle="tooltip" data-placement="left" onclick="refresh()" title="刷新"><i class="glyphicon glyphicon-repeat"></i> 刷新</button>
		</div>
		<div class="pull-right">
			<button  class="btn btn-success btn-rounded btn-outline btn-sm " onclick="search()" ><i class="fa fa-search"></i> 查询</button>
			<button  class="btn btn-success btn-rounded btn-outline btn-sm " onclick="resetSearch()" ><i class="fa fa-refresh"></i> 重置</button>
		</div>
	</div>
	</div>

	<!-- 表格 -->
	<div class="table-responsive">
	<table id="contentTable" class="table table-bordered table-striped table-hover">
		<thead>
			<tr>
				<th>分类名称</th>
				<th>排序</th>
				<th>操作</th>
			</tr>
		</thead>
		<tbody id="treeTableList"></tbody>
	</table>
	</div>
	<script type="text/template" id="treeTableTpl">
		<tr id="{{row.id}}" pId="{{pid}}">
			<td><a href="#" onclick="openDialogView('查看客户分类', '${ctx}/crm/crmCustomerType/form?id={{row.id}}','800px', '500px')">
				{{row.name}}
			</a></td>
			<td>
				{{row.sort}}
			</td>
			<td>
   				<shiro:hasPermission name="crm:crmCustomerType:view">
				<a href="#" onclick="openDialogView('查看客户分类', '${ctx}/crm/crmCustomerType/form?id={{row.id}}','800px', '500px')" class="btn btn-info btn-xs" ><i class="fa fa-search-plus"></i>  查看</a>
				</shiro:hasPermission>
			<shiro:hasPermission name="crm:crmCustomerType:edit">
   				<a href="#" onclick="openDialog('修改客户分类', '${ctx}/crm/crmCustomerType/form?id={{row.id}}','800px', '500px')" class="btn btn-success btn-xs" ><i class="fa fa-edit"></i> 修改</a>
   			</shiro:hasPermission>
   			<shiro:hasPermission name="crm:crmCustomerType:del">
				<a href="${ctx}/crm/crmCustomerType/delete?id={{row.id}}" onclick="return confirmx('确认要删除该客户分类及所有子客户分类吗？', this.href)" class="btn btn-danger btn-xs" ><i class="fa fa-trash"></i> 删除</a>
			</shiro:hasPermission>
   			<shiro:hasPermission name="crm:crmCustomerType:add">
				<a href="#" onclick="openDialog('添加下级客户分类', '${ctx}/crm/crmCustomerType/form?parent.id={{row.id}}','800px', '500px')" class="btn btn-success btn-xs" ><i class="fa fa-plus"></i> 添加下级客户分类</a>
			</shiro:hasPermission>
			</td>
		</tr>
	</script>
</body>
</html>