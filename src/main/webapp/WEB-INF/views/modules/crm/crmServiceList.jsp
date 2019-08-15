<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>服务工单列表</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
	</script>
</head>
<body class="">
	<div class="">
		<div class="">
			<div class="ibox-header">
				<div class="pull-left">			
					<a class="btn btn-link" href="${ctx}/crm/crmService/list">全部工单</a>
					<a class="btn btn-link" href="${ctx}/crm/crmService/list?createBy.id=${fns:getUser().id}">我创建的</a>
					<a class="btn btn-link" href="${ctx}/crm/crmService/list?ownBy.id=${fns:getUser().id}">我负责的</a>
					<a class="btn btn-link" href="${ctx}/crm/crmService/list?ownBy.id=${fns:getUser().id}&status=2">我完成的</a>
					<a class="btn btn-link" href="${ctx}/crm/crmService/list?beginCreateDate=${fns:getDate('yyyy-MM-dd')}&endCreateDate=${fns:getDayAfter(1)}">今日创建的</a>
					<a class="btn btn-link" href="${ctx}/crm/crmService/list?beginCreateDate=${fns:getDayAfter(-7)}&endCreateDate=${fns:getDayAfter(1)}">7天内创建的</a>
					<a class="btn btn-link" href="${ctx}/crm/crmService/list?beginCreateDate=${fns:getDayAfter(-30)}&endCreateDate=${fns:getDayAfter(1)}">30天内创建的</a>
				</div>
				<div class="pull-right">
					<div class="form-inline" style="padding-bottom: 0px;">					
						<div class="form-group">
                          	<form id="searchForm2" action="${ctx}/crm/crmService/" method="post">
	                    	<div class="input-group">	
	                        	<input type="text" id="keywords" name="keywords" value="${crmService.keywords}"  class=" form-control input-sm" placeholder="搜索客户名称"/>
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
							<shiro:hasPermission name="crm:crmService:add">
								<table:addRow url="${ctx}/crm/crmService/form" title="服务工单" ></table:addRow><!-- 增加按钮 -->
							</shiro:hasPermission>
							
							<shiro:hasPermission name="crm:crmService:edit">
							    <table:editRow url="${ctx}/crm/crmService/form" title="服务工单" id="contentTable" ></table:editRow><!-- 编辑按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="crm:crmService:del">
								<table:delRow url="${ctx}/crm/crmService/deleteAll" id="contentTable"></table:delRow><!-- 删除按钮 -->
							</shiro:hasPermission>
							 --%>
                        	<shiro:hasPermission name="crm:crmService:add">
								<a class="btn btn-success btn-sm" href="${ctx}/crm/crmService/customerList" title="新建工单"><i class="fa fa-plus"></i> 新建工单</a>
							</shiro:hasPermission>
							<div class="btn-group">
		                        <button data-toggle="dropdown" class="btn btn-white btn-sm dropdown-toggle" aria-expanded="false">更多 <span class="caret"></span>
		                        </button>
		                        <ul class="dropdown-menu">
		                            <li>
		                            	<shiro:hasPermission name="crm:crmService:import">
											<table:importExcel url="${ctx}/crm/crmService/import"></table:importExcel><!-- 导入按钮 -->
										</shiro:hasPermission>
									</li>
									<li>
										<shiro:hasPermission name="crm:crmService:export">
								       		<table:exportExcel url="${ctx}/crm/crmService/export"></table:exportExcel><!-- 导出按钮 -->
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
				<!-- 查询栏 -->
				<div class="row">
					<div class="col-sm-12">
						<form:form id="searchForm" modelAttribute="crmService" action="${ctx}/crm/crmService/" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
							<table:searchRow></table:searchRow>
								<div class="form-group"><span>工单编码：</span>
									<form:input path="no" htmlEscape="false" maxlength="50" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>工单主题：</span>
									<form:input path="name" htmlEscape="false" maxlength="50" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>工单类型：</span>
									<form:select path="serviceType" class="form-control input-medium">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('service_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>客户：</span>
									<form:input path="customer.name" htmlEscape="false" maxlength="30" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>负责人：</span>
									<sys:treeselect id="ownBy" name="ownBy.id" value="${crmService.ownBy.id}" labelName="ownBy.name" labelValue="${crmService.ownBy.name}"
										title="用户" url="/sys/office/treeData?type=3" cssClass="form-control input-small" allowClear="true" notAllowSelectParent="true"/>
								</div>
								<div class="form-group"><span>优先级：</span>
									<form:select path="levelType" class="form-control input-medium">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('level_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>截止日期：</span>
									<div class="input-group date datepicker">
				                     	<input name="beginEndDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${crmService.beginEndDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
				                     	<span class="input-group-addon">
				                             <span class="fa fa-calendar"></span>
				                     	</span>
							        </div>
							         - 
							        <div class="input-group date datepicker">
				                     	<input name="endEndDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${crmService.endEndDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
				                     	<span class="input-group-addon">
				                             <span class="fa fa-calendar"></span>
				                     	</span>
							        </div>
								</div>
								<div class="form-group"><span>处理状态：</span>
									<form:select path="status" class="form-control input-medium">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('finish_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<%-- 
								<div class="form-group"><span>处理日期：</span>
									<div class="input-group date datepicker">
				                     	<input name="beginDealDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${crmService.beginDealDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
				                     	<span class="input-group-addon">
				                             <span class="fa fa-calendar"></span>
				                     	</span>
							        </div>
							         - 
							        <div class="input-group date datepicker">
				                     	<input name="endDealDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${crmService.endDealDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
				                     	<span class="input-group-addon">
				                             <span class="fa fa-calendar"></span>
				                     	</span>
							        </div>
								</div>
								--%>
								<div class="form-group"><span>满意度：</span>
									<form:select path="satisfyType" class="form-control input-medium">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('satisfy_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<%-- 
								<div class="form-group"><span>审核日期：</span>
									<div class="input-group date datepicker">
				                     	<input name="beginAuditDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${crmService.beginAuditDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
				                     	<span class="input-group-addon">
				                             <span class="fa fa-calendar"></span>
				                     	</span>
							        </div>
							         - 
							        <div class="input-group date datepicker">
				                     	<input name="endAuditDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${crmService.endAuditDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
				                     	<span class="input-group-addon">
				                             <span class="fa fa-calendar"></span>
				                     	</span>
							        </div>
								</div>
								--%>
								<div class="form-group"><span>创建时间：</span>
									<div class="input-group date datepicker">
				                     	<input name="beginCreateDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${crmService.beginCreateDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
				                     	<span class="input-group-addon">
				                             <span class="fa fa-calendar"></span>
				                     	</span>
							        </div>
							         - 
							        <div class="input-group date datepicker">
				                     	<input name="endCreateDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${crmService.endCreateDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
				                     	<span class="input-group-addon">
				                             <span class="fa fa-calendar"></span>
				                     	</span>
							        </div>
								</div>
								<div class="form-group">
									<button class="btn btn-white btn-sm " onclick="search()"><i class="fa fa-search"></i> 查询</button>
									<button class="btn btn-white btn-sm " onclick="resetSearch()"><i class="fa fa-refresh"></i> 重置</button>
								</div>
						</form:form>
					</div>
				</div>
							
				<!-- 数据表格 -->
				<div class="table-responsive">
				<table id="contentTable" class="table table-bordered table-striped table-hover">
					<thead>
						<tr>
							<th width="30px"><input type="checkbox" class="i-checks"></th>
							<th style="min-width:100px;width:100px;" class="sort-column a.no">工单编码</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.service_type">工单类型</th>
							<th style="min-width:250px;" class="sort-column a.customer_id">客户名称</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.own_by">负责人</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.level_type">优先级</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.end_date">截止日期</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.status">处理状态</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.deal_date">处理日期</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.satisfy_type">满意度</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.audit_status">审核状态</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.create_by">创建人</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.create_date">创建时间</th>
							<%-- <th width="200px">操作</th>--%>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="crmService">
						<tr>
							<td><input type="checkbox" id="${crmService.id}" class="i-checks"></td>
							<td>
								<a href="${ctx}/crm/crmService/index?id=${crmService.id}">
								${crmService.no}
								</a>
							</td>
							<td>
								${fns:getDictLabel(crmService.serviceType, 'service_type', '')}
							</td>
							<td>
								<a href="${ctx}/crm/crmCustomer/index?id=${crmService.customer.id}">${crmService.customer.name}</a>
							</td>
							<td>
								${crmService.ownBy.name}
							</td>
							<td>
								<span class="badge <c:if test='${crmService.levelType == 2}'>badge-danger</c:if> <c:if test='${crmService.levelType == 1}'>badge-warning</c:if> <c:if test='${crmService.levelType == 0}'></c:if> ">
									${fns:getDictLabel(crmService.levelType, 'level_type', '')}
								</span>
							</td>
							<td>
								<fmt:formatDate value="${crmService.endDate}" pattern="yyyy-MM-dd"/>
							</td>
							<td>
								<span class="<c:if test='${crmService.status == 0}'>text-danger</c:if><c:if test='${crmService.status == 1}'>text-info</c:if><c:if test='${crmService.status == 2}'>text-success</c:if>">
                                    		${fns:getDictLabel(crmService.status, 'finish_status', '')}
                                </span>
							</td>
							<td>
								<fmt:formatDate value="${crmService.dealDate}" pattern="yyyy-MM-dd"/>
							</td>
							<td>
								${fns:getDictLabel(crmService.satisfyType, 'satisfy_type', '')}
							</td>
							<td>
								${fns:getDictLabel(crmService.auditStatus, 'audit_status', '')}
							</td>
							<td>
								${crmService.createBy.name}
							</td>
							<td>
								<fmt:formatDate value="${crmService.createDate}" pattern="yyyy-MM-dd"/>
							</td>
							<%-- 
							<td>
								<shiro:hasPermission name="crm:crmService:view">
									<a href="${ctx}/crm/crmService/index?id=${crmService.id}" class="btn btn-info btn-xs" title="查看"><i class="fa fa-search-plus"></i> 查看</a>
								</shiro:hasPermission>
								<shiro:hasPermission name="crm:crmService:edit">
			    					<a href="#" onclick="openDialog('修改服务工单', '${ctx}/crm/crmService/form?id=${crmService.id}','800px', '500px')" class="btn btn-success btn-xs" title="修改"><i class="fa fa-edit"></i> 修改</a>
								</shiro:hasPermission>
								
								<shiro:hasPermission name="crm:crmService:del">
									<a href="${ctx}/crm/crmService/delete?id=${crmService.id}" onclick="return confirmx('确认要删除该服务工单吗？', this.href)" class="btn btn-danger btn-xs" title="删除"><i class="fa fa-trash"></i> 删除</a> 
								</shiro:hasPermission>
							</td>
							--%>
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