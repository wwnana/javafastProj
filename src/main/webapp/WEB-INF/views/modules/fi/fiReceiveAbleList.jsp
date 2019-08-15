<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>应收款管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">

	</script>
</head>
<body class="">
	<div class="">
		<div class="">
			<div class="row dashboard-header gray-bg">
				<div class="pull-left">					
					<a class="btn btn-link" href="${ctx}/fi/fiReceiveAble/list">全部</a>
					<a class="btn btn-link" href="${ctx}/fi/fiReceiveAble/list?createBy.id=${fns:getUser().id}">我创建的</a>
					<a class="btn btn-link" href="${ctx}/fi/fiReceiveAble/list?ownBy.id=${fns:getUser().id}">我负责的</a>
					<a class="btn btn-link" href="${ctx}/fi/fiReceiveAble/list?ownBy.id=${fns:getUser().id}&status=1">我完成的</a>
					<a class="btn btn-link" href="${ctx}/fi/fiReceiveAble/list?beginCreateDate=${fns:getDate('yyyy-MM-dd')}&endCreateDate=${fns:getDayAfter(1)}">今日创建的</a>
					<a class="btn btn-link" href="${ctx}/fi/fiReceiveAble/list?beginCreateDate=${fns:getDayAfter(-7)}&endCreateDate=${fns:getDayAfter(1)}">7天内创建的</a>
					<a class="btn btn-link" href="${ctx}/fi/fiReceiveAble/list?beginCreateDate=${fns:getDayAfter(-30)}&endCreateDate=${fns:getDayAfter(1)}">30天内创建的</a>
				</div>
				<div class="pull-right">
					<div class="form-inline" style="padding-bottom: 0px;">					
						<div class="form-group">
                          	<form id="searchForm2" action="${ctx}/fi/fiReceiveAble/" method="post">
	                    	<div class="input-group">	
	                        	<input type="text" id="keywords" name="keywords" value="${fiReceiveAble.keywords}"  class=" form-control input-sm" placeholder="搜索客户名称"/>
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
                        	
                        	<shiro:hasPermission name="fi:fiReceiveAble:add">
								<a class="btn btn-success btn-sm" href="#" onclick="openDialog('新建应收款', '${ctx}/fi/fiReceiveAble/form','800px', '500px')" title="新建应收款"><i class="fa fa-plus"></i> 新建应收款</a>
							</shiro:hasPermission>
							<div class="btn-group">
		                        <button data-toggle="dropdown" class="btn btn-white btn-sm dropdown-toggle" aria-expanded="false">更多 <span class="caret"></span>
		                        </button>
		                        <ul class="dropdown-menu">
		                            <li>
		                            	<shiro:hasPermission name="fi:fiReceiveAble:export">
								       		<table:exportExcel url="${ctx}/fi/fiReceiveAble/export"></table:exportExcel><!-- 导出按钮 -->
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
						<form:form id="searchForm" modelAttribute="fiReceiveAble" action="${ctx}/fi/fiReceiveAble/" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
							<table:searchRow></table:searchRow><!-- 搜索栏隐藏 -->
								<div class="form-group"><span>单号：</span>
									<form:input path="no" htmlEscape="false" maxlength="50" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>合同订单：</span>
									<sys:tableselect id="order" name="order.id" value="${fiReceiveAble.order.id}" labelName="order.name" labelValue="${fiReceiveAble.order.name}" 
										title="订单" url="${ctx}/om/omOrder/selectList" cssClass="form-control input-small" dataMsgRequired=""  allowClear="true" allowInput="false"/>
									
								</div>
								<div class="form-group"><span>客户：</span>
									<sys:tableselect id="customer" name="customer.id" value="${fiReceiveAble.customer.id}" labelName="customer.name" labelValue="${fiReceiveAble.customer.name}" 
										title="客户" url="${ctx}/crm/crmCustomer/selectList" cssClass="form-control input-small" dataMsgRequired=""  allowClear="true" allowInput="false"/>
								</div>
								<div class="form-group"><span>应收时间：</span>
									<div class="input-group date datepicker">
			                            <input name="beginAbleDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${fiReceiveAble.beginAbleDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
			                            <span class="input-group-addon">
			                                    <span class="fa fa-calendar"></span>
			                            </span>
			                        </div>
			                         - 
			                        <div class="input-group" data-autoclose="true">
			                        	 <input name="endAbleDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${fiReceiveAble.endAbleDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
			                            <span class="input-group-addon">
			                                    <span class="fa fa-calendar"></span>
			                            </span>
			                        </div>
								</div>
								<div class="form-group"><span>负责人：</span>
									<sys:treeselect id="ownBy" name="ownBy.id" value="${fiReceiveAble.ownBy.id}" labelName="ownBy.name" labelValue="${fiReceiveAble.ownBy.name}"
										title="用户" url="/sys/office/treeData?type=3" cssClass="form-control input-small" allowClear="true" notAllowSelectParent="true"/>
								</div>
								<div class="form-group"><span>状态：</span>
									<form:select path="status" class="form-control input-medium">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('finish_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<%-- 
								<div class="form-group"><span>创建人：</span>
									<sys:treeselect id="createBy" name="createBy.id" value="${fiReceiveAble.createBy.id}" labelName="createBy.name" labelValue="${fiReceiveAble.createBy.name}"
										title="用户" url="/sys/office/treeData?type=3" cssClass="form-control input-medium" allowClear="true" notAllowSelectParent="true"/>
								</div>
								<div class="form-group"><span>创建时间：</span>
									<input name="beginCreateDate" type="text" readonly="readonly" maxlength="20" class="laydate-icon form-control input-medium"
										value="<fmt:formatDate value="${fiReceiveAble.beginCreateDate}" pattern="yyyy-MM-dd"/>"
										onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/> - 
									<input name="endCreateDate" type="text" readonly="readonly" maxlength="20" class="laydate-icon form-control input-medium"
										value="<fmt:formatDate value="${fiReceiveAble.endCreateDate}" pattern="yyyy-MM-dd"/>"
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
					<div class="col-sm-12">
						<div class="pull-left">
							 
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
							<th style="min-width:100px;width:100px;" class="sort-column no">单号</th>
							<th style="min-width:100px;width:100px;">合同订单</th>
							<th style="min-width:250px;">客户</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.amount">应收金额</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.real_amt">实际已收</th>
							<th style="min-width:100px;width:100px;">差额</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.able_date">应收时间</th>
							
							<th style="min-width:100px;width:100px;" class="sort-column a.status">状态</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.own_by">负责人</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.create_date">创建时间</th>
							
							<th style="min-width:160px;width:160px;">操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="fiReceiveAble">
						<tr>
							<td><a href="${ctx}/fi/fiReceiveAble/index?id=${fiReceiveAble.id}">
								${fiReceiveAble.no}
							</a></td>
							<td>
								<a href="${ctx}/om/omContract/index?id=${fiReceiveAble.order.id}">${fiReceiveAble.order.no}</a>
							</td>
							<td>
								${fiReceiveAble.customer.name}
							</td>
							<td>
								${fiReceiveAble.amount}
							</td>
							<td>
								${fiReceiveAble.realAmt}
							</td>
							<td>
								<c:if test="${(fiReceiveAble.amount - fiReceiveAble.realAmt) > 0}">
									<span class="text-warning">${fiReceiveAble.amount - fiReceiveAble.realAmt}</span>
								</c:if>								
							</td>
							<td>
								<fmt:formatDate value="${fiReceiveAble.ableDate}" pattern="yyyy-MM-dd"/>
							</td>
							
							<td>
								<span class="<c:if test='${fiReceiveAble.status == 0}'>text-danger</c:if> <c:if test='${fiReceiveAble.status == 1}'></c:if> ">
									${fns:getDictLabel(fiReceiveAble.status, 'finish_status', '')}
								</span>
							</td>
							<td>
								${fiReceiveAble.ownBy.name}
							</td>
							<td>
								<fmt:formatDate value="${fiReceiveAble.createDate}" pattern="yyyy-MM-dd"/>
							</td>
							
							<td>
								<shiro:hasPermission name="fi:fiReceiveAble:view">
									<a href="${ctx}/fi/fiReceiveAble/index?id=${fiReceiveAble.id}" class="" title="查看"> 查看</a>
								</shiro:hasPermission>
								
								<c:if test="${fiReceiveAble.status != 2}">
								<shiro:hasPermission name="fi:fiReceiveAble:edit">
			    					<a href="#" onclick="openDialog('修改应收款', '${ctx}/fi/fiReceiveAble/editForm?id=${fiReceiveAble.id}','800px', '500px')" class="" title="修改">修改</a>
								</shiro:hasPermission>
								<%-- 
								<shiro:hasPermission name="fi:fiReceiveAble:del">
									<a href="${ctx}/fi/fiReceiveAble/delete?id=${fiReceiveAble.id}" onclick="return confirmx('确认要删除该应收款吗？', this.href)" class="btn  btn-danger btn-xs" title="删除"><i class="fa fa-trash"></i>
										<span class="hidden-xs">删除</span></a> 
								</shiro:hasPermission>
								--%>
								
								<shiro:hasPermission name="fi:fiReceiveBill:add">
			    					<a href="#" onclick="openDialog('添加收款单', '${ctx}/fi/fiReceiveBill/form?fiReceiveAble.id=${fiReceiveAble.id}&fiReceiveAble.name=${fiReceiveAble.no}&customer.id=${fiReceiveAble.customer.id}&customer.name=${fiReceiveAble.customer.name}','800px', '500px')" class="" title="添加收款单">添加收款单</a>
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