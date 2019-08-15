<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>报价单管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">

	</script>
</head>
<body class="">
	<div class="">
		<div class="">
			<div class="row dashboard-header gray-bg">
				<div class="pull-left">			
					<a class="btn btn-link" href="${ctx}/crm/crmQuote/list">全部</a>
					<a class="btn btn-link" href="${ctx}/crm/crmQuote/list?createBy.id=${fns:getUser().id}">我创建的</a>
					<a class="btn btn-link" href="${ctx}/crm/crmQuote/list?ownBy.id=${fns:getUser().id}">我负责的</a>
					<a class="btn btn-link" href="${ctx}/crm/crmQuote/list?status=0">待审核的</a>
					<a class="btn btn-link" href="${ctx}/crm/crmQuote/list?startdate=${fns:getDate('yyyy-MM-dd')}">今日报价</a>
					<a class="btn btn-link" href="${ctx}/crm/crmQuote/list?beginStartdate=${fns:getDayAfter(-7)}&endStartdate=${fns:getDate('yyyy-MM-dd')}">7天内报价</a>
					<a class="btn btn-link" href="${ctx}/crm/crmQuote/list?beginStartdate=${fns:getDayAfter(-30)}&endStartdate=${fns:getDate('yyyy-MM-dd')}">30天内报价</a>
					<%-- 
					<a class="btn btn-link" href="${ctx}/crm/crmQuote/list?beginEnddate=${fns:getDate('yyyy-MM-dd')}&endEnddate=${fns:getDayAfter(1)}">今日到期的</a>
					<a class="btn btn-link" href="${ctx}/crm/crmQuote/list?beginEnddate=${fns:getDate('yyyy-MM-dd')}&endEnddate=${fns:getDayAfter(7)}">7天内到期的</a>
					<a class="btn btn-link" href="${ctx}/crm/crmQuote/list?beginEnddate=${fns:getDate('yyyy-MM-dd')}&endEnddate=${fns:getDayAfter(30)}">30天内到期的</a>
					--%>
				</div>
				<div class="pull-right">
					<div class="form-inline" style="padding-bottom: 0px;">					
						<div class="form-group">
                          	<form id="searchForm2" action="${ctx}/crm/crmQuote/" method="post">
	                    	<div class="input-group">	
	                        	<input type="text" id="keywords" name="keywords" value="${crmQuote.keywords}"  class=" form-control input-sm" placeholder="搜索客户名称"/>
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
                        	<%-- 
                        	<shiro:hasPermission name="crm:crmQuote:edit">
							    <table:editRow pageModel="page" url="${ctx}/crm/crmQuote/form" title="报价单" id="contentTable"></table:editRow><!-- 编辑按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="crm:crmQuote:del">
								<table:delRow url="${ctx}/crm/crmQuote/deleteAll" id="contentTable"></table:delRow><!-- 删除按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="crm:crmQuote:import">
								<table:importExcel url="${ctx}/crm/crmQuote/import"></table:importExcel><!-- 导入按钮 -->
							</shiro:hasPermission>
							--%>
                        	 <shiro:hasPermission name="crm:crmQuote:add">
								<a class="btn btn-success btn-sm" href="${ctx}/crm/crmQuote/form" title="新建报价单"><i class="fa fa-plus"></i> 新建报价单</a>
							</shiro:hasPermission>
							<div class="btn-group">
		                        <button data-toggle="dropdown" class="btn btn-white btn-sm dropdown-toggle" aria-expanded="false">更多 <span class="caret"></span>
		                        </button>
		                        <ul class="dropdown-menu">
		                            <li>
		                            	<shiro:hasPermission name="crm:crmQuote:export">
								       		<table:exportExcel url="${ctx}/crm/crmQuote/export"></table:exportExcel><!-- 导出按钮 -->
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
						<form:form id="searchForm" modelAttribute="crmQuote" action="${ctx}/crm/crmQuote/" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
							<table:searchRow></table:searchRow><!-- 搜索栏 -->
								<div class="form-group"><span>单号：</span>
									<form:input path="no" htmlEscape="false" maxlength="30" class="form-control input-small"/>
								</div>
								<div class="form-group"><span>客户名称：</span>
									<form:input path="customer.name" htmlEscape="false" maxlength="50" class="form-control input-small"/>
								</div>
								
								<div class="form-group"><span>报价日期：</span>
									<div class="input-group date datepicker">
			                            <input name="beginStartdate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${crmQuote.beginStartdate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
			                            <span class="input-group-addon">
			                                    <span class="fa fa-calendar"></span>
			                            </span>
			                        </div>
			                         - 
			                        <div class="input-group" data-autoclose="true">
			                        	 <input name="endStartdate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${crmQuote.endStartdate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
			                            <span class="input-group-addon">
			                                    <span class="fa fa-calendar"></span>
			                            </span>
			                        </div>
								</div>
								
								<div class="form-group"><span>负责人：</span>
									<sys:treeselect id="ownBy" name="ownBy.id" value="${crmQuote.ownBy.id}" labelName="ownBy.name" labelValue="${crmQuote.ownBy.name}"
										title="用户" url="/sys/office/treeData?type=3" cssClass="form-control input-small" allowClear="true" notAllowSelectParent="true"/>
								</div>
								<div class="form-group"><span>状态：</span>
									<form:select path="status" class="form-control input-medium" cssClass="input-small">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('audit_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<%-- 
								<div class="form-group"><span>创建者</span>
									<sys:treeselect id="createBy" name="createBy.id" value="${crmQuote.createBy.id}" labelName="createBy.name" labelValue="${crmQuote.createBy.name}"
										title="用户" url="/sys/office/treeData?type=3" cssClass="form-control input-small" allowClear="true" notAllowSelectParent="true"/>
								</div>
								<div class="form-group"><span>创建时间</span>
									<div class="input-group date datepicker">
			                            <input name="beginCreateDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${crmQuote.beginCreateDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
			                            <span class="input-group-addon">
			                                    <span class="fa fa-calendar"></span>
			                            </span>
			                        </div>
			                         - 
			                        <div class="input-group" data-autoclose="true">
			                        	 <input name="endCreateDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${crmQuote.endCreateDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
			                            <span class="input-group-addon">
			                                    <span class="fa fa-calendar"></span>
			                            </span>
			                        </div>
								</div>
								--%>
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
							<th width="30px"><input type="checkbox" class="i-checks"></th>
							<th style="min-width:100px;width:100px;">单号</th>
							<th style="min-width:250px;">客户</th>
							<th style="min-width:100px;width:100px;">联系人</th>
							<%-- <th class="sort-column chance.name">关联商机</th>
							--%>
							<th style="min-width:100px;width:100px;" class="sort-column amount">总金额</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.startdate">报价日期</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.enddate">有效期至</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.status">状态</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.own_by">负责人</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.create_date">创建时间</th>
							<th style="min-width:150px;width:150px;">操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="crmQuote">
						<tr>
							<td><input type="checkbox" id="${crmQuote.id}" class="i-checks"></td>
							<td>
								<a href="${ctx}/crm/crmQuote/view?id=${crmQuote.id}">
									${crmQuote.no}
								</a>
							</td>
							<td>
								<a href="${ctx}/crm/crmCustomer/index?id=${crmQuote.customer.id}" title="跟进">
									${crmQuote.customer.name}
								</a>
							</td>
							<td>
								${crmQuote.contacter.name}
							</td>
							<%-- <td>
								${crmQuote.chance.name}
							</td>
							--%>
							<td>
								${crmQuote.amount}
							</td>
							<td>
								<fmt:formatDate value="${crmQuote.startdate}" pattern="yyyy-MM-dd"/>
							</td>
							<td>
								<fmt:formatDate value="${crmQuote.enddate}" pattern="yyyy-MM-dd"/>
							</td>
							<td>
								<span class="<c:if test='${crmQuote.status == 0}'>text-danger</c:if>">
									${fns:getDictLabel(crmQuote.status, 'audit_status', '')}
								</span>
							</td>
							<td>
								${crmQuote.ownBy.name}
							</td>
							<td>
								<fmt:formatDate value="${crmQuote.createDate}" pattern="yyyy-MM-dd"/>
							</td>
							<td>
								<shiro:hasPermission name="crm:crmQuote:view">
									<a href="${ctx}/crm/crmQuote/view?id=${crmQuote.id}" class="" title="查看">查看</a>
								</shiro:hasPermission>
								<c:if test="${crmQuote.status == 0}">
								<shiro:hasPermission name="crm:crmQuote:edit">
			    					<a href="${ctx}/crm/crmQuote/form?id=${crmQuote.id}" class="" title="修改">修改</a>
								</shiro:hasPermission>
								<shiro:hasPermission name="crm:crmQuote:del">
									<a href="${ctx}/crm/crmQuote/delete?id=${crmQuote.id}" onclick="return confirmx('确认要删除该报价单吗？', this.href)" class="" title="删除">删除</a> 
								</shiro:hasPermission>
								<shiro:hasPermission name="crm:crmQuote:audit">
									<a href="${ctx}/crm/crmQuote/audit?id=${crmQuote.id}" onclick="return confirmx('确认要审核该报价单吗？', this.href)" class="" title="审核">审核</a> 
								</shiro:hasPermission>
								</c:if>
								<c:if test="${crmQuote.status == 1}">
								<shiro:hasPermission name="om:omContract:edit">
			    					<a href="${ctx}/om/omContract/quoteToForm?quote.id=${crmQuote.id}" class="" title="生成订单">生成订单</a>
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