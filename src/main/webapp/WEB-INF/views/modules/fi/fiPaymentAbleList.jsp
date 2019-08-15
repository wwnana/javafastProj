<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>应付款管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">

	</script>
</head>
<body class="">
	<div class="">
		<div class="">
			<div class="row dashboard-header gray-bg">
				<div class="pull-left">		
					<a class="btn btn-link" href="${ctx}/fi/fiPaymentAble/list">全部</a>
					<a class="btn btn-link" href="${ctx}/fi/fiPaymentAble/list?createBy.id=${fns:getUser().id}">我创建的</a>
					<a class="btn btn-link" href="${ctx}/fi/fiPaymentAble/list?ownBy.id=${fns:getUser().id}">我负责的</a>
					<a class="btn btn-link" href="${ctx}/fi/fiPaymentAble/list?ownBy.id=${fns:getUser().id}&status=1">我完成的</a>
					<a class="btn btn-link" href="${ctx}/fi/fiPaymentAble/list?beginCreateDate=${fns:getDate('yyyy-MM-dd')}&endCreateDate=${fns:getDayAfter(1)}">今日创建的</a>
					<a class="btn btn-link" href="${ctx}/fi/fiPaymentAble/list?beginCreateDate=${fns:getDayAfter(-7)}&endCreateDate=${fns:getDayAfter(1)}">7天内创建的</a>
					<a class="btn btn-link" href="${ctx}/fi/fiPaymentAble/list?beginCreateDate=${fns:getDayAfter(-30)}&endCreateDate=${fns:getDayAfter(1)}">30天内创建的</a>
				</div>
				<div class="pull-right">
					<button id="searchBtn" class="btn btn-white btn-sm" title="搜索"><i class="fa fa-search"></i></button>
					<shiro:hasPermission name="fi:fiPaymentAble:export">
			       		<table:exportExcel url="${ctx}/fi/fiPaymentAble/export"></table:exportExcel><!-- 导出按钮 -->
			       	</shiro:hasPermission>
					
				</div>			
			</div>
			

			<div class="ibox-content">
			<sys:message content="${message}"/>
				
				
				<!-- 查询条件 -->
				<div class="row">
					<div class="col-sm-12">
						<form:form id="searchForm" modelAttribute="fiPaymentAble" action="${ctx}/fi/fiPaymentAble/" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
							<table:searchRow></table:searchRow><!-- 搜索栏隐藏 -->
								<div class="form-group"><span>单号：</span>
									<form:input path="no" htmlEscape="false" maxlength="50" class="form-control input-small"/>
								</div>
								<div class="form-group"><span>采购单：</span>
									<sys:tableselect id="purchase" name="purchase.id" value="${fiPaymentAble.purchase.id}" labelName="purchase.name" labelValue="${fiPaymentAble.purchase.name}" 
							title="采购单" url="${ctx}/wms/wmsPurchase/selectList" cssClass="form-control input-small" dataMsgRequired=""  allowClear="false" allowInput="false"/>
								</div>
								<div class="form-group"><span>供应商：</span>
									<sys:tableselect id="supplier" name="supplier.id" value="${fiPaymentAble.supplier.id}" labelName="supplier.name" labelValue="${fiPaymentAble.supplier.name}" 
										title="供应商" url="${ctx}/wms/wmsSupplier/selectList" cssClass="form-control input-small" dataMsgRequired=""  allowClear="false" allowInput="false"/>
								</div>
								<div class="form-group"><span>应付时间：</span>
									<div class="input-group date datepicker">
			                            <input name="beginAbleDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${fiPaymentAble.beginAbleDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
			                            <span class="input-group-addon">
			                                    <span class="fa fa-calendar"></span>
			                            </span>
			                        </div>
			                         - 
			                        <div class="input-group" data-autoclose="true">
			                        	 <input name="endAbleDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${fiPaymentAble.endAbleDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
			                            <span class="input-group-addon">
			                                    <span class="fa fa-calendar"></span>
			                            </span>
			                        </div>
								</div>
								<div class="form-group"><span>负责人：</span>
									<sys:treeselect id="ownBy" name="ownBy.id" value="${fiPaymentAble.ownBy.id}" labelName="ownBy.name" labelValue="${fiPaymentAble.ownBy.name}"
										title="用户" url="/sys/office/treeData?type=3" cssClass="form-control input-small" allowClear="true" notAllowSelectParent="true"/>
								</div>
								<div class="form-group"><span>状态：</span>
									<form:select path="status" class="form-control input-small">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('finish_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<%-- 
								<div class="form-group"><span>创建人：</span>
									<sys:treeselect id="createBy" name="createBy.id" value="${fiPaymentAble.createBy.id}" labelName="createBy.name" labelValue="${fiPaymentAble.createBy.name}"
										title="用户" url="/sys/office/treeData?type=3" cssClass="form-control input-medium" allowClear="true" notAllowSelectParent="true"/>
								</div>
								<div class="form-group"><span>创建时间：</span>
									<input name="beginCreateDate" type="text" readonly="readonly" maxlength="20" class="laydate-icon form-control input-medium"
										value="<fmt:formatDate value="${fiPaymentAble.beginCreateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"
										onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/> - 
									<input name="endCreateDate" type="text" readonly="readonly" maxlength="20" class="laydate-icon form-control input-medium"
										value="<fmt:formatDate value="${fiPaymentAble.endCreateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"
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
					<div class="col-sm-12">
						<div class="pull-left">
							
							<shiro:hasPermission name="fi:fiPaymentAble:add">
								<table:addRow url="${ctx}/fi/fiPaymentAble/form" title="应付款"></table:addRow><!-- 增加按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="fi:fiPaymentAble:edit">
							    <table:editRow url="${ctx}/fi/fiPaymentAble/form" title="应付款" id="contentTable"></table:editRow><!-- 编辑按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="fi:fiPaymentAble:del">
								<table:delRow url="${ctx}/fi/fiPaymentAble/deleteAll" id="contentTable"></table:delRow><!-- 删除按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="fi:fiPaymentAble:import">
								<table:importExcel url="${ctx}/fi/fiPaymentAble/import"></table:importExcel><!-- 导入按钮 -->
							</shiro:hasPermission>
							
							<shiro:hasPermission name="fi:fiPaymentAble:export">
					       		<table:exportExcel url="${ctx}/fi/fiPaymentAble/export"></table:exportExcel><!-- 导出按钮 -->
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
							<th style="min-width:200px;width:200px;">来源单据</th>
							<th style="min-width:250px;">往来单位</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.amount">应付金额</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.real_amt">实际已付</th>
							<th style="min-width:100px;width:100px;">差额</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.able_date">应付时间</th>
							
							<th style="min-width:100px;width:100px;" class="sort-column a.status">状态</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.own_by">负责人</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.create_date">创建时间</th>
							
							<th style="min-width:160px;width:160px;">操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="fiPaymentAble">
						<tr>
							<td><input type="checkbox" id="${fiPaymentAble.id}" class="i-checks"></td>
							<td><a href="${ctx}/fi/fiPaymentAble/index?id=${fiPaymentAble.id}">
								${fiPaymentAble.no}
							</a></td>
							<td>
								<c:if test="${not empty fiPaymentAble.purchase.id}">
									<a href="${ctx}/wms/wmsPurchase/view?id=${fiPaymentAble.purchase.id}">[采购单]${fiPaymentAble.purchase.no}</a>
								</c:if>
								<c:if test="${not empty fiPaymentAble.returnorder.id}">
									<a href="${ctx}/om/omReturnorder/view?id=${fiPaymentAble.returnorder.id}" class="" title="查看">[退货单]${fiPaymentAble.returnorder.no}</a>
								</c:if>
							</td>
							<td>
								<c:if test="${not empty fiPaymentAble.supplier.id}">
									[供应商] ${fiPaymentAble.supplier.name}
								</c:if>
								<c:if test="${not empty fiPaymentAble.customer.id}">
									[客户] ${fiPaymentAble.customer.name}
								</c:if>
							</td>
							<td>
								${fiPaymentAble.amount}
							</td>
							<td>
								${fiPaymentAble.realAmt}
							</td>
							<td>
								<c:if test="${(fiPaymentAble.amount - fiPaymentAble.realAmt) > 0}">
									<span class="text-warning">${fiPaymentAble.amount - fiPaymentAble.realAmt}</span>
								</c:if>								
							</td>
							<td>
								<fmt:formatDate value="${fiPaymentAble.ableDate}" pattern="yyyy-MM-dd"/>
							</td>
							
							<td>
								${fns:getDictLabel(fiPaymentAble.status, 'finish_status', '')}
							</td>
							<td>
								${fiPaymentAble.ownBy.name}
							</td>
							<td>
								<fmt:formatDate value="${fiPaymentAble.createDate}" pattern="yyyy-MM-dd"/>
							</td>
							
							<td>
								<shiro:hasPermission name="fi:fiPaymentAble:view">
									<a href="${ctx}/fi/fiPaymentAble/index?id=${fiPaymentAble.id}" class="" title="查看">查看</a>
								</shiro:hasPermission>
								
								<c:if test="${fiPaymentAble.status != 2}">	
								<shiro:hasPermission name="fi:fiPaymentAble:edit">
			    					<a href="#" onclick="openDialog('修改应付款', '${ctx}/fi/fiPaymentAble/editForm?id=${fiPaymentAble.id}','800px', '500px')" class="" title="修改">修改</a>
								</shiro:hasPermission>
								<%-- 
								<shiro:hasPermission name="fi:fiPaymentAble:del">
									<a href="${ctx}/fi/fiPaymentAble/delete?id=${fiPaymentAble.id}" onclick="return confirmx('确认要删除该应付款吗？', this.href)" class="btn  btn-danger btn-xs" title="删除"><i class="fa fa-trash"></i>
										<span class="hidden-xs">删除</span></a> 
								</shiro:hasPermission>
								--%>
								
								<shiro:hasPermission name="fi:fiPaymentBill:add">
			    					<a href="#" onclick="openDialog('添加付款单', '${ctx}/fi/fiPaymentBill/form?fiPaymentAble.id=${fiPaymentAble.id}&fiPaymentAble.name=${fiPaymentAble.no}&supplier.id=${fiPaymentAble.supplier.id}&supplier.name=${fiPaymentAble.supplier.name}','800px', '500px')" class="" title="添加付款单">添加付款单</a>
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