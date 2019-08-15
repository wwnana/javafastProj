<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>电子钱包交易明细列表</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
		});
	</script>
</head>
<body class="gray-bg">
	<div class="wrapper-content">
		<div class="ibox">
			<div class="ibox-title">
				<h5>电子钱包交易明细列表 </h5>
			</div>
			<div class="ibox-content">
			<sys:message content="${message}"/>
				
				<!-- 查询条件 -->
				<div class="row">
					<div class="col-sm-12">
						<form:form id="searchForm" modelAttribute="payBankbookJournal" action="${ctx}/pay/payBankbookJournal/" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
								<div class="form-group"><span>企业帐号：</span>
									<form:input path="accountId" htmlEscape="false" maxlength="30" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>交易日期：</span>
									<input name="beginDealDate" type="text" readonly="readonly" maxlength="20" class="laydate-icon form-control input-medium"
										value="<fmt:formatDate value="${payBankbookJournal.beginDealDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"
										onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:true});"/> - 
									<input name="endDealDate" type="text" readonly="readonly" maxlength="20" class="laydate-icon form-control input-medium"
										value="<fmt:formatDate value="${payBankbookJournal.endDealDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"
										onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:true});"/>
								</div>
								<div class="form-group"><span>交易类型：</span>
									<form:select path="dealType" class="form-control input-medium">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('deal_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>资金类别：</span>
									<form:select path="moneyType" class="form-control input-medium">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('money_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
						</form:form>
					</div>
				</div>
				<!-- 工具栏 -->
				<div class="row">
					<div class="col-sm-12 m-b-sm">
						<div class="pull-left">
							<%-- 
							<shiro:hasPermission name="pay:payBankbookJournal:add">
								<table:addRow url="${ctx}/pay/payBankbookJournal/form" title="电子钱包交易明细" ></table:addRow><!-- 增加按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="pay:payBankbookJournal:edit">
							    <table:editRow url="${ctx}/pay/payBankbookJournal/form" title="电子钱包交易明细" id="contentTable" ></table:editRow><!-- 编辑按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="pay:payBankbookJournal:del">
								<table:delRow url="${ctx}/pay/payBankbookJournal/deleteAll" id="contentTable"></table:delRow><!-- 删除按钮 -->
							</shiro:hasPermission>
							
							<shiro:hasPermission name="pay:payBankbookJournal:import">
								<table:importExcel url="${ctx}/pay/payBankbookJournal/import"></table:importExcel><!-- 导入按钮 -->
							</shiro:hasPermission>
							--%>
							<shiro:hasPermission name="pay:payBankbookJournal:export">
					       		<table:exportExcel url="${ctx}/pay/payBankbookJournal/export"></table:exportExcel><!-- 导出按钮 -->
					       	</shiro:hasPermission>
					       	<table:refreshRow></table:refreshRow>
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
							<th><input type="checkbox" class="i-checks"></th>
							<th class="sort-column a.account_id">企业帐号</th>
							<th class="sort-column a.deal_date">交易日期</th>
							<th class="sort-column a.deal_type">交易类型</th>
							<th class="sort-column a.money">交易金额</th>
							<th class="sort-column a.money_type">资金类别</th>
							<th class="sort-column a.balance">当前余额</th>
							<th class="sort-column a.remarks">摘要</th>
							<th class="sort-column a.create_by">操作人</th>
							<th class="sort-column a.create_date">操作日期</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="payBankbookJournal">
						<tr>
							<td><input type="checkbox" id="${payBankbookJournal.id}" class="i-checks"></td>
							<td>
								${payBankbookJournal.accountId}
							</td>
							<td>
								<fmt:formatDate value="${payBankbookJournal.dealDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</td>
							<td>
								${fns:getDictLabel(payBankbookJournal.dealType, 'deal_type', '')}
							</td>
							<td>
								${payBankbookJournal.money}
							</td>
							<td>
								${fns:getDictLabel(payBankbookJournal.moneyType, 'money_type', '')}
							</td>
							<td>
								${payBankbookJournal.balance}
							</td>
							<td>
								${payBankbookJournal.remarks}
							</td>
							<td>
								${payBankbookJournal.createBy.id}
							</td>
							<td>
								<fmt:formatDate value="${payBankbookJournal.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</td>
							<td>
								<shiro:hasPermission name="pay:payBankbookJournal:view">
									<a href="#" onclick="openDialogView('查看电子钱包交易明细', '${ctx}/pay/payBankbookJournal/view?id=${payBankbookJournal.id}','800px', '500px')" class="btn btn-info btn-xs" title="查看"><i class="fa fa-search-plus"></i> 查看</a>
								</shiro:hasPermission>
								<%-- 
								<shiro:hasPermission name="pay:payBankbookJournal:edit">
			    					<a href="#" onclick="openDialog('修改电子钱包交易明细', '${ctx}/pay/payBankbookJournal/form?id=${payBankbookJournal.id}','800px', '500px')" class="btn btn-success btn-xs" title="修改"><i class="fa fa-edit"></i><span class="hidden-xs">修改</span></a>
								</shiro:hasPermission>
								
								<shiro:hasPermission name="pay:payBankbookJournal:del">
									<a href="${ctx}/pay/payBankbookJournal/delete?id=${payBankbookJournal.id}" onclick="return confirmx('确认要删除该电子钱包交易明细吗？', this.href)" class="btn  btn-danger btn-xs" title="删除"><i class="fa fa-trash"></i><span class="hidden-xs">删除</span></a> 
								</shiro:hasPermission>
								--%>
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