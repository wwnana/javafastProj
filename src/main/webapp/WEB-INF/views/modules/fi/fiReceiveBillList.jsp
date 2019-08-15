<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>收款单管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">

	</script>
</head>
<body class="">
	<div class="">
		<div class="">
			<div class="row dashboard-header gray-bg">
				<div class="pull-left">			
					<a class="btn btn-link" href="${ctx}/fi/fiReceiveBill/list">全部</a>
					<a class="btn btn-link" href="${ctx}/fi/fiReceiveBill/list?createBy.id=${fns:getUser().id}">我创建的</a>
					<a class="btn btn-link" href="${ctx}/fi/fiReceiveBill/list?ownBy.id=${fns:getUser().id}">我负责的</a>
					<a class="btn btn-link" href="${ctx}/fi/fiReceiveBill/list?ownBy.id=${fns:getUser().id}&status=1">我完成的</a>
					<a class="btn btn-link" href="${ctx}/fi/fiReceiveBill/list?beginCreateDate=${fns:getDate('yyyy-MM-dd')}&endCreateDate=${fns:getDayAfter(1)}">今日创建的</a>
					<a class="btn btn-link" href="${ctx}/fi/fiReceiveBill/list?beginCreateDate=${fns:getDayAfter(-7)}&endCreateDate=${fns:getDayAfter(1)}">7天内创建的</a>
					<a class="btn btn-link" href="${ctx}/fi/fiReceiveBill/list?beginCreateDate=${fns:getDayAfter(-30)}&endCreateDate=${fns:getDayAfter(1)}">30天内创建的</a>
				</div>
				<div class="pull-right">
					<div class="form-inline" style="padding-bottom: 0px;">					
						<div class="form-group">
                          	<form id="searchForm2" action="${ctx}/fi/fiReceiveBill/" method="post">
	                    	<div class="input-group">	
	                        	<input type="text" id="keywords" name="keywords" value="${fiReceiveBill.keywords}"  class=" form-control input-sm" placeholder="搜索客户名称"/>
	                            <div class="input-group-btn">
	                                <button id="btnSubmit" type="submit" class="btn btn-sm btn-white">
	                                    	<i class="fa fa-search"></i>
	                                </button>
	                                <button id="searchBtn" type="button" class="btn btn-white btn-sm" title="筛选 "><i class="fa fa-angle-double-down"></i> 筛选</button>      
	                            </div>
	                        </div>
	                        </form>
                        </div>
                        <div class="form-group">
                        	
                        	<shiro:hasPermission name="fi:fiReceiveBill:add">
								<a class="btn btn-success btn-sm" href="#" onclick="openDialog('新建收款单', '${ctx}/fi/fiReceiveBill/form','800px', '500px')" title="新建收款单"><i class="fa fa-plus"></i> 新建收款单</a>
							</shiro:hasPermission>
							<div class="btn-group">
		                        <button data-toggle="dropdown" class="btn btn-white btn-sm dropdown-toggle" aria-expanded="false">更多 <span class="caret"></span>
		                        </button>
		                        <ul class="dropdown-menu">
		                            <li>
		                            	<shiro:hasPermission name="fi:fiReceiveBill:export">
								       		<table:exportExcel url="${ctx}/fi/fiReceiveBill/export"></table:exportExcel><!-- 导出按钮 -->
								       	</shiro:hasPermission>
		                            </li>
		                            
		                        </ul>
		                    </div>
		                    
                        </div>
                    </div>
				</div>
				
			</div>
			<div class="ibox-content">
			<sys:message content="${message}"/>
				
				<!-- 查询条件 -->
				<div class="row">
					<div class="col-sm-12">
						<form:form id="searchForm" modelAttribute="fiReceiveBill" action="${ctx}/fi/fiReceiveBill/" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
							<table:searchRow></table:searchRow><!-- 搜索栏隐藏 -->
								<div class="form-group"><span>单号：</span>
									<form:input path="no" htmlEscape="false" maxlength="30" class="form-control input-small"/>
								</div>
								
								<div class="form-group"><span>客户：</span>
									<sys:tableselect id="customer" name="customer.id" value="${fiReceiveBill.customer.id}" labelName="customer.name" labelValue="${fiReceiveBill.customer.name}" 
										title="客户" url="${ctx}/crm/crmCustomer/selectList" cssClass="form-control input-small" dataMsgRequired=""  allowClear="true" allowInput="false"/>
								</div>
								<div class="form-group"><span>应收款：</span>
									<sys:tableselect id="fiReceiveAble" name="fiReceiveAble.id" value="${fiReceiveBill.fiReceiveAble.id}" labelName="fiReceiveAble.name" labelValue="${fiReceiveBill.fiReceiveAble.name}" 
										title="应收款" url="${ctx}/fi/fiReceiveAble/selectList" cssClass="form-control input-small" dataMsgRequired=""  allowClear="false" allowInput="false"/>
								</div>
								<div class="form-group"><span>收款账户：</span>
									<sys:spinnerselect id="fiAccount" name="fiAccount.id" value="${fiReceiveBill.fiAccount.id}" labelName="fiaccount.name" labelValue="${fiReceiveBill.fiAccount.name}" 
										title="结算账户" url="${ctx}/fi/fiFinanceAccount/getSelectData" cssClass="form-control input-small" allowEmpty="true"></sys:spinnerselect>
							
								</div>
								<div class="form-group"><span>收款时间：</span>
									<div class="input-group date datepicker">
			                            <input name="beginDealDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${fiReceiveBill.beginDealDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
			                            <span class="input-group-addon">
			                                    <span class="fa fa-calendar"></span>
			                            </span>
			                        </div>
			                         - 
			                        <div class="input-group" data-autoclose="true">
			                        	 <input name="endDealDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${fiReceiveBill.endDealDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
			                            <span class="input-group-addon">
			                                    <span class="fa fa-calendar"></span>
			                            </span>
			                        </div>
								</div>
								<div class="form-group"><span>收款人：</span>
									<sys:treeselect id="ownBy" name="ownBy.id" value="${fiReceiveBill.ownBy.id}" labelName="ownBy.name" labelValue="${fiReceiveBill.ownBy.name}"
										title="用户" url="/sys/office/treeData?type=3" cssClass="form-control input-small" allowClear="true" notAllowSelectParent="true"/>
								</div>
								<div class="form-group"><span>开票：</span>
									<form:select path="isInvoice" class="form-control input-small">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>状态：</span>
									<form:select path="status" class="form-control input-small">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('audit_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<%-- 
								<div class="form-group"><span>创建人：</span>
									<form:input path="createBy.id" htmlEscape="false" maxlength="30" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>创建时间：</span>
									<input name="beginCreateDate" type="text" readonly="readonly" maxlength="20" class="laydate-icon form-control input-medium"
										value="<fmt:formatDate value="${fiReceiveBill.beginCreateDate}" pattern="yyyy-MM-dd"/>"
										onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/> - 
									<input name="endCreateDate" type="text" readonly="readonly" maxlength="20" class="laydate-icon form-control input-medium"
										value="<fmt:formatDate value="${fiReceiveBill.endCreateDate}" pattern="yyyy-MM-dd"/>"
										onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
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
							
							<shiro:hasPermission name="fi:fiReceiveBill:add">
								<table:addRow url="${ctx}/fi/fiReceiveBill/form" title="收款单"></table:addRow><!-- 增加按钮 -->
							</shiro:hasPermission>
							
							<shiro:hasPermission name="fi:fiReceiveBill:edit">
							    <table:editRow url="${ctx}/fi/fiReceiveBill/form" title="收款单" id="contentTable"></table:editRow><!-- 编辑按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="fi:fiReceiveBill:del">
								<table:delRow url="${ctx}/fi/fiReceiveBill/deleteAll" id="contentTable"></table:delRow><!-- 删除按钮 -->
							</shiro:hasPermission>
							 
							<shiro:hasPermission name="fi:fiReceiveBill:import">
								<table:importExcel url="${ctx}/fi/fiReceiveBill/import"></table:importExcel><!-- 导入按钮 -->
							</shiro:hasPermission>
							
							<shiro:hasPermission name="fi:fiReceiveBill:export">
					       		<table:exportExcel url="${ctx}/fi/fiReceiveBill/export"></table:exportExcel><!-- 导出按钮 -->
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
							<th style="min-width:100px;width:100px;">应收款</th>
							<th style="min-width:250px;">客户</th>
							<th style="min-width:100px;width:100px;" class="sort-column amount">收款金额</th>
							<th style="min-width:100px;width:100px;" class="sort-column deal_date">收款时间</th>
							<th style="min-width:100px;">收款账户</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.own_by">收款人</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.is_invoice">是否开票</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.invoice_amt">开票金额</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.status">状态</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.create_by">创建人</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.create_date">创建时间</th>
							<th style="min-width:150px;width:150px;">操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="fiReceiveBill">
						<tr>
							<td><input type="checkbox" id="${fiReceiveBill.id}" class="i-checks"></td>
							<td>
								<a href="#" onclick="openDialogView('查看收款单', '${ctx}/fi/fiReceiveBill/view?id=${fiReceiveBill.id}','800px', '500px')">
									${fiReceiveBill.no}
								</a>
							</td>
							<td>
								<a href="${ctx}/fi/fiReceiveAble/index?id=${fiReceiveBill.fiReceiveAble.id}">
									${fiReceiveBill.fiReceiveAble.no}
								</a>
							</td>
							<td>
								${fiReceiveBill.customer.name}
							</td>
							<td>
								${fiReceiveBill.amount}
							</td>
							<td>
								<fmt:formatDate value="${fiReceiveBill.dealDate}" pattern="yyyy-MM-dd"/>
							</td>
							<td>
								${fiReceiveBill.fiAccount.name}
							</td>
							<td>
								${fiReceiveBill.ownBy.name}
							</td>
							<td>
								${fns:getDictLabel(fiReceiveBill.isInvoice, 'yes_no', '')}
							</td>
							<td>
								${fiReceiveBill.invoiceAmt}
							</td>
							<td>
								<span class="<c:if test='${fiReceiveBill.status == 0}'>text-danger</c:if>">
									${fns:getDictLabel(fiReceiveBill.status, 'audit_status', '')}
								</span>
							</td>
							<td>
								${fiReceiveBill.createBy.name}
							</td>
							<td>
								<fmt:formatDate value="${fiReceiveBill.createDate}" pattern="yyyy-MM-dd"/>
							</td>
							<td>
								
								<a href="#" onclick="openDialogView('查看收款单', '${ctx}/fi/fiReceiveBill/view?id=${fiReceiveBill.id}','800px', '500px')" class="" title="查看">查看</a>
								
								<c:if test="${fiReceiveBill.status == 0}">
								<shiro:hasPermission name="fi:fiReceiveBill:edit">
			    					<a href="#" onclick="openDialog('修改收款单', '${ctx}/fi/fiReceiveBill/form?id=${fiReceiveBill.id}','800px', '500px')" class="" title="修改">修改</a>
								</shiro:hasPermission>
								<shiro:hasPermission name="fi:fiReceiveBill:del">
									<a href="${ctx}/fi/fiReceiveBill/delete?id=${fiReceiveBill.id}" onclick="return confirmx('确认要删除该收款单吗？', this.href)" class="" title="删除">删除</a> 
								</shiro:hasPermission>
								<shiro:hasPermission name="fi:fiReceiveBill:audit">
									<a href="${ctx}/fi/fiReceiveBill/audit?id=${fiReceiveBill.id}" onclick="return confirmx('确认要审核该收款单吗？', this.href)" class="" title="审核">审核</a> 
								</shiro:hasPermission>
								</c:if>
							</td>
						</tr>
					</c:forEach>
					</tbody>
				</table>
				</div>
				<table:page page="${page}"></table:page>
				<br>
			</div>
		</div>
	</div>
</body>
</html>