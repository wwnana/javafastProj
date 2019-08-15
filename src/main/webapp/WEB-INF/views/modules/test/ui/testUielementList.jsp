<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>UI标签列表</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
		});
		//0:隐藏tip, 1隐藏box,不设置显示全部
		top.$.jBox.closeTip();
	</script>
</head>
<body class="">
	<div class="">
		<div class="">
			<div class="row dashboard-header gray-bg">
				<h5>UI标签列表 </h5>
				<div class="pull-right">
					<shiro:hasPermission name="test:ui:testUielement:add">
						<table:addRow url="${ctx}/test/ui/testUielement/form" title="UI标签" pageModel="page"></table:addRow><!-- 增加按钮 -->
					</shiro:hasPermission>
					
				</div>
			</div>
			<div class="ibox-content">
			<sys:message content="${message}"/>
				
				<!-- 查询条件 -->
				<div class="row">
					<div class="col-sm-12">
						<form:form id="searchForm" modelAttribute="testUielement" action="${ctx}/test/ui/testUielement/" method="post" class="">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
						</form:form>
					</div>
				</div>
				
					
				<!-- 表格 -->
				<div class="table-responsive">
				<table id="contentTable" class="table table-bordered table-striped table-hover">
					<thead>
						<tr>
							<th width="30px"><input type="checkbox" class="i-checks"></th>
							<th class="sort-column a.product_id">列表选择器</th>
							<th class="sort-column a.product_type">树形选择器</th>
							<th class="sort-column a.sex">数据字典radio</th>
							<th class="sort-column a.sex2">数据字典select</th>
							<th class="sort-column a.tags">多选下拉标签</th>
							<th class="sort-column a.tags2">数据字典checkbox</th>
							<th class="sort-column a.user_id">人员选择</th>
							<th class="sort-column a.office_id">部门选择</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="testUielement">
						<tr>
							<td><input type="checkbox" id="${testUielement.id}" class="i-checks"></td>
							<td>
								<a href="${ctx}/test/ui/testUielement/form?id=${testUielement.id}">
								${testUielement.product.name}
							</a></td>
							<td>
								${testUielement.productType.name}
							</td>
							<td>
								${fns:getDictLabel(testUielement.sex, 'sex', '')}
							</td>
							<td>
								${fns:getDictLabel(testUielement.sex2, 'sex', '')}
							</td>
							<td>
								${fns:getDictLabels(testUielement.tags, 'color', '')}
							</td>
							<td>
								${fns:getDictLabels(testUielement.tags2, 'color', '')}
							</td>
							<td>
								${testUielement.user.name}
							</td>
							<td>
								${testUielement.office.name}
							</td>
							<td>
								<shiro:hasPermission name="test:ui:testUielement:edit">
			    					<a href="${ctx}/test/ui/testUielement/form?id=${testUielement.id}" class="btn btn-success btn-xs" title="修改"><i class="fa fa-edit"></i><span class="hidden-xs">修改</span></a>
								</shiro:hasPermission>
								
								<shiro:hasPermission name="test:ui:testUielement:del">
									<a href="${ctx}/test/ui/testUielement/delete?id=${testUielement.id}" onclick="return confirmx('确认要删除该UI标签吗？', this.href)" class="btn  btn-danger btn-xs" title="删除"><i class="fa fa-trash"></i><span class="hidden-xs">删除</span></a> 
								</shiro:hasPermission>
							</td>
						</tr>
					</c:forEach>
					</tbody>
				</table>
				<table:page page="${page}"></table:page>
				</div>
			</div>
		</div>
	</div>
</body>
</html>