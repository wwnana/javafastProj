<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>系统短信管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
		});
		//0:隐藏tip, 1隐藏box,不设置显示全部
		top.$.jBox.closeTip();
	</script>
</head>
<body class="gray-bg">
<div class="wrapper-content">
		<div class="ibox">
			<div class="ibox-title">
				<h5>系统短信列表 </h5>
			</div>
			<div class="ibox-content">
			<sys:message content="${message}"/>
				
				<!-- 查询条件 -->
				<div class="row">
					<div class="col-sm-12">
						<form:form id="searchForm" modelAttribute="sysSms" action="${ctx}/sys/sysSms/" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
								<div class="form-group"><span>短信类型：</span>
									<form:select path="smsType" class="form-control input-medium">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('sms_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>手机号码：</span>
									<form:input path="mobile" htmlEscape="false" maxlength="11" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>成功状态：</span>
									<form:select path="status" class="form-control input-medium">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>创建时间：</span>
									<input name="beginCreateDate" type="text" readonly="readonly" maxlength="20" class="laydate-icon form-control input-medium"
										value="<fmt:formatDate value="${sysSms.beginCreateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"
										onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/> - 
									<input name="endCreateDate" type="text" readonly="readonly" maxlength="20" class="laydate-icon form-control input-medium"
										value="<fmt:formatDate value="${sysSms.endCreateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"
										onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/>
								</div>
						</form:form>
					</div>
				</div>
				<!-- 工具栏 -->
				<div class="row">
					<div class="col-sm-12 m-b-sm">
						<div class="pull-left">
							<shiro:hasPermission name="sys:sysSms:add">
								<table:addRow url="${ctx}/sys/sysSms/form" title="系统短信"></table:addRow><!-- 增加按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="sys:sysSms:edit">
							    <table:editRow url="${ctx}/sys/sysSms/form" title="系统短信" id="contentTable"></table:editRow><!-- 编辑按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="sys:sysSms:del">
								<table:delRow url="${ctx}/sys/sysSms/deleteAll" id="contentTable"></table:delRow><!-- 删除按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="sys:sysSms:import">
								<table:importExcel url="${ctx}/sys/sysSms/import"></table:importExcel><!-- 导入按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="sys:sysSms:export">
					       		<table:exportExcel url="${ctx}/sys/sysSms/export"></table:exportExcel><!-- 导出按钮 -->
					       	</shiro:hasPermission>
					       <button class="btn btn-white btn-sm " data-toggle="tooltip" data-placement="left" onclick="sortOrRefresh()" title="刷新"><i class="glyphicon glyphicon-repeat"></i> 刷新</button>
						
						</div>
						<div class="pull-right">
							<button  class="btn btn-success btn-rounded btn-outline btn-sm " onclick="search()" ><i class="fa fa-search"></i> 查询</button>
							<button  class="btn btn-success btn-rounded btn-outline btn-sm " onclick="resetSearch()" ><i class="fa fa-refresh"></i> 重置</button>
						</div>
					</div>
				</div>
					
				<!-- 表格 -->
				<table id="contentTable" class="table table-striped table-bordered table-hover table-condensed dataTables-example dataTable">
					<thead>
						<tr>
							<th><input type="checkbox" class="i-checks"></th>
							<th class="sort-column sms_type">短信类型</th>
							<th class="sort-column content">短信内容</th>
							<th class="sort-column mobile">手机号码</th>
							<th class="sort-column ip">客户端IP</th>
							<th class="sort-column status">成功状态</th>
							<th class="sort-column create_date">创建时间</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="sysSms">
						<tr>
							<td><input type="checkbox" id="${sysSms.id}" class="i-checks"></td>
							<td><a href="#" onclick="openDialogView('查看系统短信', '${ctx}/sys/sysSms/form?id=${sysSms.id}','800px', '500px')">
								${fns:getDictLabel(sysSms.smsType, 'sms_type', '')}
							</a></td>
							<td>
								${sysSms.content}
							</td>
							<td>
								${sysSms.mobile}
							</td>
							<td>
								${sysSms.ip}
							</td>
							<td>
								${fns:getDictLabel(sysSms.status, 'yes_no', '')}
							</td>
							<td>
								<fmt:formatDate value="${sysSms.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</td>
							<td>
								<shiro:hasPermission name="sys:sysSms:view">
									<a href="#" onclick="openDialogView('查看系统短信', '${ctx}/sys/sysSms/form?id=${sysSms.id}','800px', '500px')" class="btn btn-info btn-xs" title="查看"><i class="fa fa-search-plus"></i> 查看</a>
								</shiro:hasPermission>
								<shiro:hasPermission name="sys:sysSms:edit">
			    					<a href="#" onclick="openDialog('修改系统短信', '${ctx}/sys/sysSms/form?id=${sysSms.id}','800px', '500px')" class="btn btn-success btn-xs" title="修改"><i class="fa fa-edit"></i>
										<span class="hidden-xs">修改</span></a>
								</shiro:hasPermission>
								<shiro:hasPermission name="sys:sysSms:del">
									<a href="${ctx}/sys/sysSms/delete?id=${sysSms.id}" onclick="return confirmx('确认要删除该系统短信吗？', this.href)" class="btn  btn-danger btn-xs" title="删除"><i class="fa fa-trash"></i>
										<span class="hidden-xs">删除</span></a> 
								</shiro:hasPermission>
							</td>
						</tr>
					</c:forEach>
					</tbody>
				</table>
				<table:page page="${page}"></table:page>
				<br/>
			</div>
		</div>
	</div>
</body>
</html>