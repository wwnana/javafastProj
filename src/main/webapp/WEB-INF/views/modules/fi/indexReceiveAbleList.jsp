<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>应收款管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
		});
		//0:隐藏tip, 1隐藏box,不设置显示全部
		top.$.jBox.closeTip();
	</script>
</head>
<body class="gray-bg">
<div class="">
		<div class="ibox">
			<div class="ibox-title">
				<h5>应收款列表 </h5>
			</div>
			<div class="ibox-content">
			<sys:message content="${message}"/>
				
				
				<!-- 工具栏 -->
				<div class="row">
					<div class="col-sm-12">
						<div class="pull-left">
							<%-- 
							<shiro:hasPermission name="fi:fiReceiveAble:add">
								<table:addRow url="${ctx}/fi/fiReceiveAble/form" title="应收款"></table:addRow><!-- 增加按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="fi:fiReceiveAble:edit">
							    <table:editRow url="${ctx}/fi/fiReceiveAble/form" title="应收款" id="contentTable"></table:editRow><!-- 编辑按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="fi:fiReceiveAble:del">
								<table:delRow url="${ctx}/fi/fiReceiveAble/deleteAll" id="contentTable"></table:delRow><!-- 删除按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="fi:fiReceiveAble:import">
								<table:importExcel url="${ctx}/fi/fiReceiveAble/import"></table:importExcel><!-- 导入按钮 -->
							</shiro:hasPermission>
							
							<shiro:hasPermission name="fi:fiReceiveAble:export">
					       		<table:exportExcel url="${ctx}/fi/fiReceiveAble/export"></table:exportExcel><!-- 导出按钮 -->
					       	</shiro:hasPermission>
					       <button class="btn btn-white btn-sm " data-toggle="tooltip" data-placement="left" onclick="sortOrRefresh()" title="刷新"><i class="glyphicon glyphicon-repeat"></i> 刷新</button>
						--%>
						</div><%-- 
						<div class="pull-right">
							<button  class="btn btn-success btn-rounded btn-outline btn-sm " onclick="search()" ><i class="fa fa-search"></i> 查询</button>
							<button  class="btn btn-success btn-rounded btn-outline btn-sm " onclick="resetSearch()" ><i class="fa fa-refresh"></i> 重置</button>
						</div>--%>
					</div>
				</div>
					
				<!-- 表格 -->
				<div class="table-responsive">
				<table id="contentTable" class="table table-bordered table-striped table-hover">
					<thead>
						<tr>
							<%-- <th><input type="checkbox" class="i-checks"></th>--%>
							<th>单号</th>
							<th>合同订单</th>
							
							<th>应收金额</th>
							<th>实际已收</th>
							<th>差额</th>
							<th>应收时间</th>
							<th>负责人</th>
							<th>状态</th>
							<th>创建人</th>
							<th>创建时间</th>
							<th width="200px">操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${list}" var="fiReceiveAble">
						<tr>
							<%-- <td><input type="checkbox" id="${fiReceiveAble.id}" class="i-checks"></td>--%>
							<td><a href="${ctx}/fi/fiReceiveAble/index?id=${fiReceiveAble.id}">
								${fiReceiveAble.no}
							</a></td>
							<td>
								<a href="${ctx}/om/omOrder/index?id=${fiReceiveAble.order.id}">${fiReceiveAble.order.no}</a>
							</td>
							
							<td>
								${fiReceiveAble.amount}
							</td>
							<td>
								${fiReceiveAble.realAmt}
							</td>
							<td>
								<c:if test="${(fiReceiveAble.amount - fiReceiveAble.realAmt) > 0}">
									<span class="label label-warning">${fiReceiveAble.amount - fiReceiveAble.realAmt}</span>
								</c:if>								
							</td>
							<td>
								<fmt:formatDate value="${fiReceiveAble.ableDate}" pattern="yyyy-MM-dd"/>
							</td>
							<td>
								${fiReceiveAble.ownBy.name}
							</td>
							<td>
								${fns:getDictLabel(fiReceiveAble.status, 'finish_status', '')}
							</td>
							<td>
								${fiReceiveAble.createBy.name}
							</td>
							<td>
								<fmt:formatDate value="${fiReceiveAble.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</td>
							<td>
								<shiro:hasPermission name="fi:fiReceiveAble:view">
									<a href="${ctx}/fi/fiReceiveAble/index?id=${fiReceiveAble.id}" class="btn btn-info btn-xs" title="查看"><i class="fa fa-search-plus"></i> </a>
								</shiro:hasPermission>
								
								<c:if test="${fiReceiveAble.status != 2}">
								<shiro:hasPermission name="fi:fiReceiveAble:edit">
			    					<a href="#" onclick="openDialog('修改应收款', '${ctx}/fi/fiReceiveAble/editForm?id=${fiReceiveAble.id}','800px', '500px')" class="btn btn-success btn-xs" title="修改"><i class="fa fa-edit"></i> </a>
								</shiro:hasPermission>
								<%-- 
								<shiro:hasPermission name="fi:fiReceiveAble:del">
									<a href="${ctx}/fi/fiReceiveAble/delete?id=${fiReceiveAble.id}" onclick="return confirmx('确认要删除该应收款吗？', this.href)" class="btn  btn-danger btn-xs" title="删除"><i class="fa fa-trash"></i> 删除</a> 
								</shiro:hasPermission>
								--%>
								
								<shiro:hasPermission name="fi:fiReceiveBill:add">
			    					<a href="#" onclick="openDialog('添加收款单', '${ctx}/fi/fiReceiveBill/form?fiReceiveAble.id=${fiReceiveAble.id}&fiReceiveAble.name=${fiReceiveAble.no}&customer.id=${fiReceiveAble.customer.id}&customer.name=${fiReceiveAble.customer.name}','800px', '500px')" class="btn btn-success btn-xs" title="添加收款单"><i class="fa fa-plus"></i> 添加收款单</a>
								</shiro:hasPermission>
								
								</c:if>
							</td>
						</tr>
					</c:forEach>
					</tbody>
				</table>
				</div>
			</div>
		</div>
	</div>
</body>
</html>