<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<c:forEach items="${list}" var="menu">
	<tr id="${menu.id}" pId="${menu.parent.id ne '1'?menu.parent.id:'0'}" haschild="true">
		<td><input type="checkbox" id="${menu.id}" class="i-checks"></td>
		<td nowrap><i class="fa ${not empty menu.icon?menu.icon:' hide'}"></i> <a href="#"
			onclick="${ctx}/sys/menu/form?id=${menu.id}">${menu.name}</a></td>
		<td title="${menu.href}">${fns:abbr(menu.href,30)}</td>
		<td style="text-align:center;padding-top: 0px;padding-bottom: 0px;">
			<shiro:hasPermission
				name="sys:menu:updateSort">
				<input type="hidden" name="ids" value="${menu.id}" />
				<input name="sorts" type="text" value="${menu.sort}"
					class="form-control"
					style="width: 100px;text-align: center;">
			</shiro:hasPermission> 
			<shiro:lacksPermission name="sys:menu:updateSort">
					${menu.sort}
			</shiro:lacksPermission>
		</td>
		<td>${menu.isShow eq '1'?'显示':'隐藏'}</td>
		<td title="${menu.permission}">${fns:abbr(menu.permission,30)}</td>
		<td nowrap>	
						
						<shiro:hasPermission name="sys:menu:edit">
	    					<a href="${ctx}/sys/menu/form?id=${menu.id}" class="btn btn-success btn-xs" title="修改"><i class="fa fa-pencil"></i> 修改</a>
	    				</shiro:hasPermission>
	    				<shiro:hasPermission name="sys:menu:del">
							<a href="${ctx}/sys/menu/delete?id=${menu.id}" onclick="return confirmx('要删除该菜单及所有子菜单项吗？', this.href)" class="btn btn-danger btn-xs" title="删除"><i class="fa fa-trash"></i> 删除</a>
						</shiro:hasPermission>
						<shiro:hasPermission name="sys:menu:add">
							<a href="${ctx}/sys/menu/form?parent.id=${menu.id}" class="btn btn-success btn-xs" title="添加下级菜单"><i class="fa fa-plus"></i> 添加下级菜单</a>
						</shiro:hasPermission>
		</td>
	</tr>
</c:forEach>
<script type="text/javascript">
<!--
	$('input:checkbox.i-checks').iCheck({
        checkboxClass: 'icheckbox_minimal-blue',
        increaseArea: '20%'
    });
//-->
</script>
