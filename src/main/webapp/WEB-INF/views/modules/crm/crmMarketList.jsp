<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>市场活动列表</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
	</script>
</head>
<body class="">
	<div class="">
		<div class="">
			<div class="ibox-header">
				<h5>市场活动</h5>
				<div class="pull-right">
					<div class="form-inline" style="padding-bottom: 0px;">					
						<div class="form-group">
                          	<form id="searchForm2" action="${ctx}/crm/crmMarket/" method="post">
	                    	<div class="input-group">	
	                        	<input type="text" id="keywords" name="keywords" value="${crmMarket.keywords}"  class=" form-control input-sm" placeholder="搜索活动名称"/>
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
                        	<shiro:hasPermission name="crm:crmMarket:add">
								<table:addRow url="${ctx}/crm/crmMarket/form" title="市场活动" label="新建市场活动"></table:addRow><!-- 增加按钮 -->
							</shiro:hasPermission>
							<%--
							<shiro:hasPermission name="crm:crmMarket:edit">
							    <table:editRow url="${ctx}/crm/crmMarket/form" title="市场活动" id="contentTable" ></table:editRow><!-- 编辑按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="crm:crmMarket:del">
								<table:delRow url="${ctx}/crm/crmMarket/deleteAll" id="contentTable"></table:delRow><!-- 删除按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="crm:crmMarket:import">
								<table:importExcel url="${ctx}/crm/crmMarket/import"></table:importExcel><!-- 导入按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="crm:crmMarket:export">
					       		<table:exportExcel url="${ctx}/crm/crmMarket/export"></table:exportExcel><!-- 导出按钮 -->
					       	</shiro:hasPermission>
					       	 --%>
		                    
                        </div>
                    </div>
				</div>
			</div>
			<div class="ibox-content">
			<sys:message content="${message}"/>				
				<!-- 查询栏 -->
				<div class="row">
					<div class="col-sm-12">
						<form:form id="searchForm" modelAttribute="crmMarket" action="${ctx}/crm/crmMarket/" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
							<table:searchRow></table:searchRow>
								<div class="form-group"><span>活动名称：</span>
									<form:input path="name" htmlEscape="false" maxlength="50" class="form-control input-medium"/>
								</div>
								
								<div class="form-group"><span>活动状态：</span>
									<form:select path="status" class="form-control input-medium">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('market_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>活动类型：</span>
									<form:select path="marketType" cssClass="form-control input-medium">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('market_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>负责人：</span>
									<sys:treeselect id="ownBy" name="ownBy.id" value="${crmMarket.ownBy.id}" labelName="ownBy.name" labelValue="${crmMarket.ownBy.name}"
										title="用户" url="/sys/office/treeData?type=3" cssClass="form-control input-small" allowClear="true" notAllowSelectParent="true"/>
								</div>
								<div class="form-group"><span>创建者：</span>
									<sys:treeselect id="createBy" name="createBy.id" value="${crmMarket.createBy.id}" labelName="createBy.name" labelValue="${crmMarket.createBy.name}"
										title="用户" url="/sys/office/treeData?type=3" cssClass="form-control input-small" allowClear="true" notAllowSelectParent="true"/>
								</div>
								<div class="form-group"><span>创建时间：</span>
									<div class="input-group date datepicker">
				                     	<input name="beginCreateDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${crmMarket.beginCreateDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
				                     	<span class="input-group-addon">
				                             <span class="fa fa-calendar"></span>
				                     	</span>
							        </div>
							         - 
							        <div class="input-group date datepicker">
				                     	<input name="endCreateDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${crmMarket.endCreateDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
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
							<th style="min-width: 250px" class="sort-column a.name">活动名称</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.start_date">开始日期</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.end_date">截止日期</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.market_type">活动类型</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.invite_num">邀请人数</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.actual_num">实际人数</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.status">活动状态</th>
							<th style="min-width:100px;width:100px;"class="sort-column a.own_by">负责人</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.create_by">创建者</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.create_date">创建时间</th>
							<th style="min-width:100px;width:100px;">操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="crmMarket">
						<tr>
							<td><input type="checkbox" id="${crmMarket.id}" class="i-checks"></td>
							<td>
								<a href="${ctx}/crm/crmMarket/index?id=${crmMarket.id}">
								${crmMarket.name}
							</a></td>
							<td>
								<fmt:formatDate value="${crmMarket.startDate}" pattern="yyyy-MM-dd"/>
							</td>
							<td>
								<fmt:formatDate value="${crmMarket.endDate}" pattern="yyyy-MM-dd"/>
							</td>
							<td>
								${fns:getDictLabel(crmMarket.marketType, 'market_type', '')}
							</td>
							<td>
								${crmMarket.inviteNum}
							</td>
							<td>
								${crmMarket.actualNum}
							</td>
							<td>
								<span class="<c:if test='${crmMarket.status == 0}'>text-warning</c:if> <c:if test='${crmMarket.status == 1}'>text-success</c:if> <c:if test='${crmMarket.status == 2}'>text-muted</c:if> ">
									${fns:getDictLabel(crmMarket.status, 'market_status', '')}
								</span>
							</td>
							<td>
								${crmMarket.ownBy.name}
							</td>
							<td>
								${crmMarket.createBy.name}
							</td>
							<td>
								<fmt:formatDate value="${crmMarket.createDate}" pattern="yyyy-MM-dd"/>
							</td>
							<td>
								
								<shiro:hasPermission name="crm:crmMarket:edit">
			    					<a href="#" onclick="openDialog('修改市场活动', '${ctx}/crm/crmMarket/form?id=${crmMarket.id}','1000px', '600px')" class="" title="修改"> 修改</a>
								</shiro:hasPermission>
								
								<shiro:hasPermission name="crm:crmMarket:del">
									<a href="${ctx}/crm/crmMarket/delete?id=${crmMarket.id}" onclick="return confirmx('确认要删除该市场活动吗？', this.href)" class="" title="删除"> 删除</a> 
								</shiro:hasPermission>
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