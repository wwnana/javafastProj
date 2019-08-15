<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>订单信息管理</title>
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
				<h5>订单信息列表 (一对多)</h5>
				<div class="pull-right">
					<button id="searchBtn" class="btn btn-default btn-sm" title="搜索"><i class="fa fa-search"></i> 搜索</button>
					<shiro:hasPermission name="test:onetomany:testDataMain:add">
						<table:addRow url="${ctx}/test/onetomany/testDataMain/form" title="订单信息" width="1000px" height="80%" pageModel="page"></table:addRow><!-- 增加按钮 -->
					</shiro:hasPermission>
					<shiro:hasPermission name="test:onetomany:testDataMain:edit">
					    <table:editRow url="${ctx}/test/onetomany/testDataMain/form" title="订单信息" id="contentTable" width="1000px" height="80%" pageModel="page"></table:editRow><!-- 编辑按钮 -->
					</shiro:hasPermission>
					<shiro:hasPermission name="test:onetomany:testDataMain:del">
						<table:delRow url="${ctx}/test/onetomany/testDataMain/deleteAll" id="contentTable"></table:delRow><!-- 删除按钮 -->
					</shiro:hasPermission>
					<shiro:hasPermission name="test:onetomany:testDataMain:import">
						<table:importExcel url="${ctx}/test/onetomany/testDataMain/import"></table:importExcel><!-- 导入按钮 -->
					</shiro:hasPermission>
					<shiro:hasPermission name="test:onetomany:testDataMain:export">
			       		<table:exportExcel url="${ctx}/test/onetomany/testDataMain/export"></table:exportExcel><!-- 导出按钮 -->
			       	</shiro:hasPermission>
			       <button class="btn btn-white btn-sm " data-toggle="tooltip" data-placement="left" onclick="sortOrRefresh()" title="刷新"><i class="fa fa-repeat"></i> 刷新</button>
						
				</div>
			</div>
			<div class="ibox-content">
			<sys:message content="${message}"/>
				
				<!-- 查询条件 -->
				<div class="row">
					<div class="col-sm-12">
						<form:form id="searchForm" modelAttribute="testDataMain" action="${ctx}/test/onetomany/testDataMain/" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
							<table:searchRow></table:searchRow>
								<div class="form-group"><span>单号：</span>
									<form:input path="no" htmlEscape="false" maxlength="30" class="form-control input-small"/>
								</div>
								<div class="form-group"><span>销售类型：</span>
									<form:select path="saleType" class="form-control input-small">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('sale_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>经办人：</span>
									<sys:treeselect id="dealBy" name="dealBy.id" value="${testDataMain.dealBy.id}" labelName="dealBy.name" labelValue="${testDataMain.dealBy.name}"
										title="用户" url="/sys/office/treeData?type=3" cssClass="form-control input-small" allowClear="true" notAllowSelectParent="true"/>
								</div>
								<div class="form-group"><span>业务日期：</span>
									<div class="input-group date datepicker">
			                            <input name="beginDealDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${testDataMain.beginDealDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
			                            <span class="input-group-addon">
			                                    <span class="fa fa-calendar"></span>
			                            </span>
			                        </div>
			                         - 
			                        <div class="input-group" data-autoclose="true">
			                        	 <input name="endDealDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${testDataMain.endDealDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
			                            <span class="input-group-addon">
			                                    <span class="fa fa-calendar"></span>
			                            </span>
			                        </div>
								</div>
								<div class="form-group"><span>审核状态：</span>
									<form:select path="status" class="form-control input-small">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('audit_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group">
									<button class="btn btn-white btn-sm" onclick="search()"><i class="fa fa-search"></i> 查询</button>
									<button class="btn btn-white btn-sm" onclick="resetSearch()"><i class="fa fa-refresh"></i> 重置</button>
								</div>
						</form:form>
					</div>
				</div>
				
					
				<!-- 表格 -->
				<table id="contentTable" class="table table-striped table-bordered table-hover table-condensed">
					<thead>
						<tr>
							<th width="30px"><input type="checkbox" class="i-checks"></th>
							<th class="sort-column no">单号</th>
							<th width="100px" class="sort-column sale_type">销售类型</th>
							<th width="120px" class="sort-column amount">订单总额(元)</th>
							<th width="120px" class="sort-column invoice_amt">开票金额(元)</th>
							<th width="100px" class="sort-column deal_by">经办人</th>
							<th width="100px" class="sort-column deal_date">业务日期</th>
							<th width="100px" class="sort-column audit_by">审核人</th>
							<th width="100px" class="sort-column audit_date">审核时间</th>
							<th width="100px" class="sort-column status">审核状态</th>
							<th width="200px">操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="testDataMain">
						<tr>
							<td><input type="checkbox" id="${testDataMain.id}" class="i-checks"></td>
							<td><a href="${ctx}/test/onetomany/testDataMain/view?id=${testDataMain.id}">
								${testDataMain.no}
							</a></td>
							<td>
								${fns:getDictLabel(testDataMain.saleType, 'sale_type', '')}
							</td>
							<td>
								${testDataMain.amount}
							</td>
							<td>
								${testDataMain.invoiceAmt}
							</td>
							<td>
								${testDataMain.dealBy.name}
							</td>
							<td>
								<fmt:formatDate value="${testDataMain.dealDate}" pattern="yyyy-MM-dd"/>
							</td>
							<td>
								${testDataMain.auditBy.id}
							</td>
							<td>
								<fmt:formatDate value="${testDataMain.auditDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</td>
							<td>
								${fns:getDictLabel(testDataMain.status, 'audit_status', '')}
							</td>
							<td>
								<shiro:hasPermission name="test:onetomany:testDataMain:view">
									<a href="${ctx}/test/onetomany/testDataMain/view?id=${testDataMain.id}" class="btn btn-info btn-xs" title="查看"><i class="fa fa-search-plus"></i> 查看</a>
								</shiro:hasPermission>
								<shiro:hasPermission name="test:onetomany:testDataMain:edit">
			    					<a href="${ctx}/test/onetomany/testDataMain/form?id=${testDataMain.id}" class="btn btn-success btn-xs" title="修改"><i class="fa fa-edit"> 修改</i>
										</a>
								</shiro:hasPermission>
								<shiro:hasPermission name="test:onetomany:testDataMain:del">
									<a href="${ctx}/test/onetomany/testDataMain/delete?id=${testDataMain.id}" onclick="return confirmx('确认要删除该订单信息吗？', this.href)" class="btn  btn-danger btn-xs" title="删除"><i class="fa fa-trash"> 删除</i>
										
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