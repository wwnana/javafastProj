<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>跟进记录管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
	</script>
</head>
<body class="">
	<div class="">
		<div class="">
			<div class="row dashboard-header gray-bg">
				<div class="pull-left">			
					<a class="btn btn-link" href="${ctx}/crm/crmContactRecord/list">全部</a>
					<a class="btn btn-link" href="${ctx}/crm/crmContactRecord/list?createBy.id=${fns:getUser().id}">我创建的</a>
					<a class="btn btn-link" href="${ctx}/crm/crmContactRecord/list?beginCreateDate=${fns:getDate('yyyy-MM-dd')}&endCreateDate=${fns:getDayAfter(1)}">今日创建的</a>
					<a class="btn btn-link" href="${ctx}/crm/crmContactRecord/list?beginCreateDate=${fns:getDayAfter(-7)}&endCreateDate=${fns:getDayAfter(1)}">7天内创建的</a>
					<a class="btn btn-link" href="${ctx}/crm/crmContactRecord/list?beginCreateDate=${fns:getDayAfter(-30)}&endCreateDate=${fns:getDayAfter(1)}">30天内创建的</a>
					
				</div>
				<div class="pull-right">
					<div class="form-inline" style="padding-bottom: 0px;">					
						<div class="form-group">
                          	<form id="searchForm2" action="${ctx}/crm/crmContactRecord/" method="post">
	                    	<div class="input-group">	
	                        	<input type="text" id="keywords" name="keywords" value="${crmContactRecord.keywords}"  class=" form-control input-sm" placeholder="搜索业务名称"/>
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
							<shiro:hasPermission name="crm:crmCustomer:add">
								<table:addRow url="${ctx}/crm/crmContactRecord/form" title="添加跟进记录"></table:addRow>
							</shiro:hasPermission>
							 --%>
							<div class="btn-group">
		                        <button data-toggle="dropdown" class="btn btn-white btn-sm dropdown-toggle" aria-expanded="false">更多 <span class="caret"></span>
		                        </button>
		                        <ul class="dropdown-menu">
		                            <li>
		                            	<shiro:hasPermission name="crm:crmCustomer:export">
								       		<table:exportExcel url="${ctx}/crm/crmContactRecord/export"></table:exportExcel><!-- 导出按钮 -->
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
						<form:form id="searchForm" modelAttribute="crmContactRecord" action="${ctx}/crm/crmContactRecord/" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
							<table:searchRow></table:searchRow><!-- 查询栏 -->
								
								
								<div class="form-group"><span>跟进主题：</span>
									<form:select path="contactType" class="form-control input-small">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('contact_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>跟进日期：</span>
									<div class="input-group date datepicker">
			                            <input name="beginContactDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${crmContactRecord.beginContactDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
			                            <span class="input-group-addon">
			                                    <span class="fa fa-calendar"></span>
			                            </span>
			                        </div>
			                         - 
			                        <div class="input-group" data-autoclose="true">
			                        	 <input name="endContactDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${crmContactRecord.endContactDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
			                            <span class="input-group-addon">
			                                    <span class="fa fa-calendar"></span>
			                            </span>
			                        </div>
								</div>
								
								<%--
								<div class="form-group"><span>创建者：</span>
									<sys:treeselect id="createBy" name="createBy.id" value="${crmContactRecord.createBy.id}" labelName="" labelValue="${crmContactRecord.createBy.name}"
										title="用户" url="/sys/office/treeData?type=3" cssClass="form-control input-small" allowClear="true" notAllowSelectParent="true"/>
								</div>
								<div class="form-group"><span>创建时间：</span>
									<input name="createDate" type="text" readonly="readonly" maxlength="20" class="laydate-icon form-control "
										value="<fmt:formatDate value="${crmContactRecord.createDate}" pattern="yyyy-MM-dd"/>"
										onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
								</div>
								 --%>
								 <div class="form-group">
									<button class="btn btn-white btn-sm " onclick="search()"><i class="fa fa-search"></i> 查询</button>
									<button class="btn btn-white btn-sm " onclick="resetSearch()"><i class="fa fa-refresh"></i> 重置</button>
								</div>
						</form:form>
					</div>
				</div>
				
					
				<!-- 表格 -->
				<div class="table-responsive">
				<table id="contentTable" class="table table-bordered table-striped table-hover">
					<thead>
						<tr>
							
							<th style="min-width:100px;width:100px;" class="sort-column a.contact_date">跟进日期</th>
							<th style="min-width:100px;">业务板块</th>
							<th style="min-width:200px;">业务名称</th>
							<th style="min-width:100px;width:100px;">跟进主题</th>
							<th style="min-width:300px;">跟进内容</th>
							<th style="min-width:100px;width:100px;">创建人</th>
							<th style="min-width:100px;width:100px;">创建时间</th>
							
							<th style="min-width:100px;width:100px;">操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="crmContactRecord">
						<tr>
							<td>
								<a href="#" onclick="openDialogView('查看跟进记录', '${ctx}/crm/crmContactRecord/view?id=${crmContactRecord.id}','800px', '500px')" title="查看">
									<fmt:formatDate value="${crmContactRecord.contactDate}" pattern="yyyy-MM-dd"/>
								</a>
							</td>
							<td>
								${fns:getDictLabel(crmContactRecord.targetType, 'object_type', '')}
							</td>
							<td>
								${crmContactRecord.targetName}
								
							</td>
							<td>
								${fns:getDictLabel(crmContactRecord.contactType, 'contact_type', '')}
							</td>
							
							<td>
									<a href="#" onclick="openDialogView('查看跟进记录', '${ctx}/crm/crmContactRecord/view?id=${crmContactRecord.id}','800px', '500px')" title="查看">
										${fns:abbr(crmContactRecord.content,200)}
									</a>
							</td>
							
							<td>
								${crmContactRecord.createBy.name}
							</td>
							<td>
								<fmt:formatDate value="${crmContactRecord.createDate}" pattern="yyyy-MM-dd"/>
							</td>
							
							<td>
			    					<a href="${ctx}/crm/crmContactRecord/form?id=${crmContactRecord.id}" class="" title="修改">修改</a>
									<a href="${ctx}/crm/crmContactRecord/delete?id=${crmContactRecord.id}" onclick="return confirmx('确认要删除该跟进记录吗？', this.href)" class="" title="删除">删除</a> 
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