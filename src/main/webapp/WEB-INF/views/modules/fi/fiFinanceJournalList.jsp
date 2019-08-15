<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>资金流水管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">

	</script>
</head>
<body class="">
	<div class="">
		<div class="">
			<div class="row dashboard-header gray-bg">
				<div class="pull-left">		
					<a class="btn btn-link" href="${ctx}/fi/fiFinanceJournal/list">全部</a>
					<a class="btn btn-link" href="${ctx}/fi/fiFinanceJournal/list?beginDealDate=${fns:getDate('yyyy-MM-dd')}&endDealDate=${fns:getDayAfter(1)}">今日的</a>
					<a class="btn btn-link" href="${ctx}/fi/fiFinanceJournal/list?beginDealDate=${fns:getDayAfter(-7)}&endDealDate=${fns:getDayAfter(1)}">7天内的</a>
					<a class="btn btn-link" href="${ctx}/fi/fiFinanceJournal/list?beginDealDate=${fns:getDayAfter(-30)}&endDealDate=${fns:getDayAfter(1)}">30天内的</a>
				</div>
				<div class="pull-right">					
					<button id="searchBtn" class="btn btn-white btn-sm" title="搜索"><i class="fa fa-search"></i></button>
					<a class="btn btn-white btn-sm" href="${ctx}/fi/fiFinanceJournal/list" title="刷新"><i class="fa fa-refresh"></i></a>
					<shiro:hasPermission name="fi:fiFinanceJournal:export">
			       		<table:exportExcel url="${ctx}/fi/fiFinanceJournal/export"></table:exportExcel><!-- 导出按钮 -->
			       	</shiro:hasPermission>
				</div>			
			</div>
			<div class="ibox-content">
			<sys:message content="${message}"/>	
			
				
				<!-- 查询条件 -->
				<div class="row">
					<div class="col-sm-12">
						<form:form id="searchForm" modelAttribute="fiFinanceJournal" action="${ctx}/fi/fiFinanceJournal/" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
							<table:searchRow></table:searchRow><!-- 搜索栏隐藏 -->
								
								<div class="form-group">
									<span>结算账户：</span>
									<sys:spinnerselect id="fiaccount" name="fiaccount.id" value="${fiFinanceJournal.fiaccount.id}" labelName="fiaccount.name" labelValue="${fiFinanceJournal.fiaccount.name}" 
										title="结算账户" url="${ctx}/fi/fiFinanceAccount/getSelectData" cssClass="form-control input-small" allowEmpty="true"></sys:spinnerselect>
								</div>
								<div class="form-group"><span>交易类别：</span>
									<form:select path="dealType" class="form-control input-small">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('deal_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>业务日期：</span>
									<div class="input-group date datepicker">
			                            <input name="beginDealDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${fiFinanceJournal.beginDealDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
			                            <span class="input-group-addon">
			                                    <span class="fa fa-calendar"></span>
			                            </span>
			                        </div>
			                         - 
			                        <div class="input-group" data-autoclose="true">
			                        	 <input name="endDealDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${fiFinanceJournal.endDealDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
			                            <span class="input-group-addon">
			                                    <span class="fa fa-calendar"></span>
			                            </span>
			                        </div>
								</div>
								<div class="form-group"><span>资金类别：</span>
									<form:select path="moneyType" class="form-control input-small">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('money_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>操作人：</span>
									<sys:treeselect id="createBy" name="createBy.id" value="${fiFinanceJournal.createBy.id}" labelName="createBy.name" labelValue="${fiFinanceJournal.createBy.name}"
										title="用户" url="/sys/office/treeData?type=3" cssClass="form-control input-small" allowClear="true" notAllowSelectParent="true"/>
								</div>
								<div class="form-group">
									<button class="btn btn-white btn-sm" onclick="search()"><i class="fa fa-search"></i> 查询</button>
									<button class="btn btn-white btn-sm" onclick="resetSearch()"><i class="fa fa-refresh"></i> 重置</button>
								</div>
						</form:form>
					</div>
				</div>
					
				<!-- 表格 -->
				<div class="table-responsive">
				<table id="contentTable" class="table table-bordered table-striped table-hover">
					<thead>
						<tr>
							<th style="min-width:200px;" class="sort-column f.name">结算账户</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.deal_date">业务日期</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.deal_type">交易类别</th>
							<th style="min-width:150px;width:150px;" class="sort-column a.money_type">资金类别</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.money">交易金额</th>
							<th style="min-width:200px;">摘要</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.balance">当前余额</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.create_by">操作人</th>
							<th style="min-width:160px;width:160px;" class="sort-column a.create_date">操作日期</th>
							
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="fiFinanceJournal">
						<tr>
							<td>
								${fiFinanceJournal.fiaccount.name}
							</td>
							<td>
								<fmt:formatDate value="${fiFinanceJournal.dealDate}" pattern="yyyy-MM-dd"/>
							</td>
							<td>
								${fns:getDictLabel(fiFinanceJournal.dealType, 'deal_type', '')}
							</td>
							
							<td>
								${fns:getDictLabel(fiFinanceJournal.moneyType, 'money_type', '')}
							</td>
							<td>
								${fiFinanceJournal.money}
							</td>
							<td>
								${fiFinanceJournal.notes}
							</td>
							<td>
								${fiFinanceJournal.balance}
							</td>
							<td>
								${fiFinanceJournal.createBy.name}
							</td>
							<td>
								<fmt:formatDate value="${fiFinanceJournal.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</td>
						</tr>
					</c:forEach>
					</tbody>
				</table>
				</div>
				<table:page page="${page}"></table:page>
				
			</div>
		</div>
	</div>
</body>
</html>