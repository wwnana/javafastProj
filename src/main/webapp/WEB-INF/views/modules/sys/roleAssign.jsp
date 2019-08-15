<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>分配角色</title>
	<meta name="decorator" content="default"/>
</head>
<body>
	<div class="wrapper-content">
	<div class="container-fluid breadcrumb">
		<div class="row-fluid span12">
			<span class="span4">角色名称: <b>${role.name}</b></span>
			<%-- <span class="span4">归属机构: ${role.office.name}</span>
			<span class="span4">角色编码: ${role.enname}</span>
		
			<c:if test="${fns:getSysAccount().id == '0'}">
				<span class="span4">角色类型: <c:if test="${role.roleType == 'assignment'}">任务分配</c:if>
									<c:if test="${role.roleType == 'security-role'}">管理角色</c:if>
									<c:if test="${role.roleType == 'user'}">普通角色</c:if></span>
			</c:if>
			 --%>
			<c:set var="dictvalue" value="${role.dataScope}" scope="page" />
			<span class="span4">数据范围: <b>${fns:getDictLabel(dictvalue, 'sys_data_scope', '')}</b></span>
		</div>
	</div>
	<br>
	<sys:message content="${message}"/>
	<div class="breadcrumb">
		<form id="assignRoleForm" action="${ctx}/sys/role/assignrole" method="post" class="hide">
			<input type="hidden" name="id" value="${role.id}"/>
			<input id="idsArr" type="hidden" name="idsArr" value=""/>
		</form>
		<button id="assignButton" type="submit"  class="btn btn-success btn-sm" title="添加人员"><i class="fa fa-plus"></i> 添加人员</button>
		<script type="text/javascript">
			$("#assignButton").click(function(){
				
				top.layer.open({
				    type: 2, 
				    area: ['800px', '600px'],
				    title:"选择用户",
			        maxmin: true, //开启最大化最小化按钮
				    content: "${ctx}/sys/role/usertorole?id=${role.id}",
				    btn: ['确定', '关闭'],
				    yes: function(index, layero){
		    	       var pre_ids = layero.find("iframe")[0].contentWindow.pre_ids;
						var ids = layero.find("iframe")[0].contentWindow.ids;
						if(ids[0]==''){
								ids.shift();
								pre_ids.shift();
							}
							if(pre_ids.sort().toString() == ids.sort().toString()){
								top.$.jBox.tip("未给角色【${role.name}】分配新成员！", 'info');
								return false;
							};
					    	// 执行保存
					    	loading('正在提交，请稍等...');
					    	var idsArr = "";
					    	for (var i = 0; i<ids.length; i++) {
					    		idsArr = (idsArr + ids[i]) + (((i + 1)== ids.length) ? '':',');
					    	}
					    	$('#idsArr').val(idsArr);
					    	$('#assignRoleForm').submit();
						    top.layer.close(index);
					  },
					  cancel: function(index){ 
		    	       }
				}); 
			});
		</script>
	</div>
	<br>
	<table id="contentTable" class="table table-bordered table-hover">
		<thead>
			<tr>
				<th>姓名</th>
				<th>归属公司</th>
				<th>归属部门</th>
				<shiro:hasPermission name="sys:user:edit"><th>操作</th></shiro:hasPermission>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${userList}" var="user">
			<tr>
				<td><a href="${ctx}/sys/user/view?id=${user.id}">${user.name}</a></td>
				<td>${user.company.name}</td>
				<td>${user.office.name}</td>
				<shiro:hasPermission name="sys:role:edit"><td>
					<a href="${ctx}/sys/role/outrole?userId=${user.id}&roleId=${role.id}" 
						onclick="return confirmx('确认要将用户<b>[${user.name}]</b>从<b>[${role.name}]</b>角色中移除吗？', this.href)">移除</a>
				</td></shiro:hasPermission>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	</div>
</body>
</html>
