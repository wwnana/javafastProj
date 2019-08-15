<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>付款单管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">

	</script>
</head>
<body class="">
	<div class="">
		<div class="">
			<div class="row dashboard-header gray-bg">
				<div class="pull-left">	
					<a class="btn btn-link" href="${ctx}/fi/fiPaymentBill/list">全部</a>
					<a class="btn btn-link" href="${ctx}/fi/fiPaymentBill/list?createBy.id=${fns:getUser().id}">我创建的</a>
					<a class="btn btn-link" href="${ctx}/fi/fiPaymentBill/list?ownBy.id=${fns:getUser().id}">我负责的</a>
					<a class="btn btn-link" href="${ctx}/fi/fiPaymentBill/list?ownBy.id=${fns:getUser().id}&status=1">我完成的</a>
					<a class="btn btn-link" href="${ctx}/fi/fiPaymentBill/list?beginCreateDate=${fns:getDate('yyyy-MM-dd')}&endCreateDate=${fns:getDayAfter(1)}">今日创建的</a>
					<a class="btn btn-link" href="${ctx}/fi/fiPaymentBill/list?beginCreateDate=${fns:getDayAfter(-7)}&endCreateDate=${fns:getDayAfter(1)}">7天内创建的</a>
					<a class="btn btn-link" href="${ctx}/fi/fiPaymentBill/list?beginCreateDate=${fns:getDayAfter(-30)}&endCreateDate=${fns:getDayAfter(1)}">30天内创建的</a>
				</div>
				<div class="pull-right">
					<button id="searchBtn" class="btn btn-white btn-sm" title="搜索"><i class="fa fa-search"></i></button>
					<shiro:hasPermission name="fi:fiPaymentBill:export">
			       		<table:exportExcel url="${ctx}/fi/fiPaymentBill/export"></table:exportExcel><!-- 导出按钮 -->
			       	</shiro:hasPermission>
					
				</div>			
			</div>
			<div class="ibox-content">
			<sys:message content="${message}"/>
			
				<!-- 查询条件 -->
				<div class="row">
					<div class="col-sm-12">
						<form:form id="searchForm" modelAttribute="fiPaymentBill" action="${ctx}/fi/fiPaymentBill/" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
							<table:searchRow></table:searchRow><!-- 搜索栏隐藏 -->
								<div class="form-group"><span>单号：</span>
									<form:input path="no" htmlEscape="false" maxlength="30" class="form-control input-small"/>
								</div>
								<div class="form-group"><span>应付款：</span>
									<sys:tableselect id="fiPaymentAble" name="fiPaymentAble.id" value="${fiPaymentBill.fiPaymentAble.id}" labelName="fiPaymentAble.name" labelValue="${fiPaymentBill.fiPaymentAble.name}" 
										title="应付款" url="${ctx}/fi/fiPaymentAble/selectList" cssClass="form-control input-small"  allowClear="false" allowInput="false"/>
						
								</div>
								<div class="form-group"><span>供应商：</span>
									<sys:tableselect id="supplier" name="supplier.id" value="${fiPaymentBill.supplier.id}" labelName="supplier.name" labelValue="${fiPaymentBill.supplier.name}" 
										title="供应商" url="${ctx}/wms/wmsSupplier/selectList" cssClass="form-control input-small" dataMsgRequired=""  allowClear="false" allowInput="false"/>
								</div>
								<div class="form-group"><span>付款时间：</span>
									<div class="input-group date datepicker">
			                            <input name="beginDealDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${fiPaymentBill.beginDealDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
			                            <span class="input-group-addon">
			                                    <span class="fa fa-calendar"></span>
			                            </span>
			                        </div>
			                         - 
			                        <div class="input-group" data-autoclose="true">
			                        	 <input name="endDealDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${fiPaymentBill.endDealDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
			                            <span class="input-group-addon">
			                                    <span class="fa fa-calendar"></span>
			                            </span>
			                        </div>
								</div>
								<div class="form-group"><span>付款账户：</span>
									<sys:spinnerselect id="fiAccount" name="fiAccount.id" value="${fiPaymentBill.fiAccount.id}" labelName="fiaccount.name" labelValue="${fiPaymentBill.fiAccount.name}" 
										title="结算账户" url="${ctx}/fi/fiFinanceAccount/getSelectData" cssClass="form-control input-small" allowEmpty="true"></sys:spinnerselect>
							
								</div>
								<div class="form-group"><span>负责人：</span>
									<sys:treeselect id="ownBy" name="ownBy.id" value="${fiPaymentBill.ownBy.id}" labelName="ownBy.name" labelValue="${fiPaymentBill.ownBy.name}"
										title="用户" url="/sys/office/treeData?type=3" cssClass="form-control input-small" allowClear="true" notAllowSelectParent="true"/>
								</div>
								<div class="form-group"><span>状态：</span>
									<form:select path="status" class="form-control input-small">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('audit_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<%--
								<div class="form-group"><span>创建人：</span>
									<sys:treeselect id="createBy" name="createBy.id" value="${fiPaymentBill.createBy.id}" labelName="createBy.name" labelValue="${fiPaymentBill.createBy.name}"
										title="用户" url="/sys/office/treeData?type=3" cssClass="form-control input-medium" allowClear="true" notAllowSelectParent="true"/>
								</div>
								<div class="form-group"><span>创建时间：</span>
									<input name="beginCreateDate" type="text" readonly="readonly" maxlength="20" class="laydate-icon form-control input-medium"
										value="<fmt:formatDate value="${fiPaymentBill.beginCreateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"
										onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/> - 
									<input name="endCreateDate" type="text" readonly="readonly" maxlength="20" class="laydate-icon form-control input-medium"
										value="<fmt:formatDate value="${fiPaymentBill.endCreateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"
										onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/>
								</div>
								 --%>
								 <div class="form-group">
									<button class="btn btn-white btn-sm" onclick="search()"><i class="fa fa-search"></i> 查询</button>
									<button class="btn btn-white btn-sm" onclick="resetSearch()"><i class="fa fa-refresh"></i> 重置</button>
								</div>
						</form:form>
					</div>
				</div>
				<%--
				<!-- 工具栏 -->
				<div class="row">
					<div class="col-sm-12 m-b-sm">
						<div class="pull-left">
							 
							<shiro:hasPermission name="fi:fiPaymentBill:add">
								<table:addRow url="${ctx}/fi/fiPaymentBill/form" title="付款单"></table:addRow><!-- 增加按钮 -->
							</shiro:hasPermission>
							
							<shiro:hasPermission name="fi:fiPaymentBill:edit">
							    <table:editRow url="${ctx}/fi/fiPaymentBill/form" title="付款单" id="contentTable"></table:editRow><!-- 编辑按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="fi:fiPaymentBill:del">
								<table:delRow url="${ctx}/fi/fiPaymentBill/deleteAll" id="contentTable"></table:delRow><!-- 删除按钮 -->
							</shiro:hasPermission>
							
							<shiro:hasPermission name="fi:fiPaymentBill:import">
								<table:importExcel url="${ctx}/fi/fiPaymentBill/import"></table:importExcel><!-- 导入按钮 -->
							</shiro:hasPermission>
							
							<shiro:hasPermission name="fi:fiPaymentBill:export">
					       		<table:exportExcel url="${ctx}/fi/fiPaymentBill/export"></table:exportExcel><!-- 导出按钮 -->
					       	</shiro:hasPermission>
					       <button class="btn btn-white btn-sm " data-toggle="tooltip" data-placement="left" onclick="sortOrRefresh()" title="刷新"><i class="glyphicon glyphicon-repeat"></i> 刷新</button>
						
						</div>
						<div class="pull-right">
							<div class="btn-group">
								<button id="searchBtn" class="btn btn-white btn-sm" title="搜索"><i class="fa fa-search"></i></button>
								<table:refreshRow></table:refreshRow>
							</div>
						</div>
					</div>
				</div>
				--%>	
				<!-- 表格 -->
				<div class="table-responsive">
				<table id="contentTable" class="table table-bordered table-striped table-hover">
					<thead>
						<tr>
							<th width="30px"><input type="checkbox" class="i-checks"></th>
							<th style="min-width:100px;width:100px;" class="sort-column no">单号</th>
							<th style="min-width:100px;width:100px;" class="sort-column no">应付款</th>
							<th style="min-width:250px;">往来单位</th>
							<th style="min-width:100px;width:100px;" class="sort-column amount">付款金额</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.deal_date">付款时间</th>
							<th style="min-width:200px;" class="sort-column f.name">付款账户</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.own_by">负责人</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.status">状态</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.create_by">创建人</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.create_date">创建时间</th>
							<th style="min-width:150px;width:150px;">操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="fiPaymentBill">
						<tr>
							<td><input type="checkbox" id="${fiPaymentBill.id}" class="i-checks"></td>
							<td>
								<a href="#" onclick="openDialogView('查看付款单', '${ctx}/fi/fiPaymentBill/view?id=${fiPaymentBill.id}','800px', '500px')">
								${fiPaymentBill.no}
								</a>
							</td>
							<td>
								<a href="${ctx}/fi/fiPaymentAble/index?id=${fiPaymentBill.fiPaymentAble.id}">
									${fiPaymentBill.fiPaymentAble.no}
								</a>
							</td>
							<td>
								<c:if test="${not empty fiPaymentBill.supplier.id}">
									[供应商] ${fiPaymentBill.supplier.name}
								</c:if>
								<c:if test="${not empty fiPaymentBill.customer.id}">
									[客户] ${fiPaymentBill.customer.name}
								</c:if>
							</td>
							<td>
								${fiPaymentBill.amount}
							</td>
							<td>
								<fmt:formatDate value="${fiPaymentBill.dealDate}" pattern="yyyy-MM-dd"/>
							</td>
							<td>
								${fiPaymentBill.fiAccount.name}
							</td>
							<td>
								${fiPaymentBill.ownBy.name}
							</td>
							<td>
								<span class="<c:if test='${fiPaymentBill.status == 0}'>text-danger</c:if>">
									${fns:getDictLabel(fiPaymentBill.status, 'audit_status', '')}
								</span>
							</td>
							<td>
								${fiPaymentBill.createBy.name}
							</td>
							<td>
								<fmt:formatDate value="${fiPaymentBill.createDate}" pattern="yyyy-MM-dd"/>
							</td>
							<td>
								<a href="#" onclick="openDialogView('查看付款单', '${ctx}/fi/fiPaymentBill/view?id=${fiPaymentBill.id}','800px', '500px')" class="" title="查看">查看</a>
								
								<c:if test="${fiPaymentBill.status == 0}">
								<shiro:hasPermission name="fi:fiPaymentBill:edit">
			    					<a href="#" onclick="openDialog('修改付款单', '${ctx}/fi/fiPaymentBill/form?id=${fiPaymentBill.id}','800px', '500px')" class="" title="修改">修改</a>
								</shiro:hasPermission>
								<shiro:hasPermission name="fi:fiPaymentBill:del">
									<a href="${ctx}/fi/fiPaymentBill/delete?id=${fiPaymentBill.id}" onclick="return confirmx('确认要删除该付款单吗？', this.href)" class="" title="删除">删除</a> 
								</shiro:hasPermission>
								<shiro:hasPermission name="fi:fiPaymentBill:audit">
									<a href="${ctx}/fi/fiPaymentBill/audit?id=${fiPaymentBill.id}" onclick="return confirmx('确认要审核该付款单吗？', this.href)" class="" title="审核">审核</a> 
								</shiro:hasPermission>
								</c:if>
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