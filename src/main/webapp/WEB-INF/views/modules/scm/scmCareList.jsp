<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>客户关怀列表</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		
	</script>
</head>
<body class="">
	<div class="">
		<div class="">
			<div class="row dashboard-header gray-bg">
				<div class="pull-left">	
					<h5>客户关怀 </h5>
				</div>
				<div class="pull-right">
					<form id="searchForm2" action="${ctx}/scm/scmCare" method="post" class="pull-right form-inline" style="padding-bottom: 0;">
                    	<div class="form-group">
	                    	<div class="input-group">	
	                        	<input type="text" id="keywords" name="keywords" value="${scmCare.keywords}"  class=" form-control input-sm" placeholder="搜索主题或客户"/>
	                            <div class="input-group-btn">
	                                <button id="btnSubmit" type="submit" class="btn btn-sm btn-info">
	                                    	搜索
	                                </button>
	                            </div>
	                        </div>
                        </div>
                        <div class="form-group">
                        	<button id="searchBtn" type="button" class="btn btn-white btn-sm" title="搜索"><i class="fa fa-search"></i> 高级搜索</button>
                        </div>
                    </form>		
				</div>
				
			</div>	
			<div class="ibox-content">
			<sys:message content="${message}"/>
				
				<!-- 查询条件 -->
				<div class="row">
					<div class="col-sm-12">
						<form:form id="searchForm" modelAttribute="scmCare" action="${ctx}/scm/scmCare/" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
							<table:searchRow></table:searchRow><!-- 查询栏 -->
								<div class="form-group"><span>主题：</span>
									<form:input path="name" htmlEscape="false" maxlength="50" class="form-control input-small"/>
								</div>
								<div class="form-group"><span>客户名称：</span>
									<form:input path="customer.name" htmlEscape="false" maxlength="50" class="form-control input-small"/>
								</div>
								<div class="form-group"><span>关怀类型：</span>
									<form:select path="careType" class="form-control input-medium" cssClass="input-small">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('care_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>关怀日期：</span>
									<div class="input-group date datepicker">
			                            <input name="beginCareDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${scmCare.beginCareDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
			                            <span class="input-group-addon">
			                                    <span class="fa fa-calendar"></span>
			                            </span>
			                        </div>
			                         - 
			                        <div class="input-group" data-autoclose="true">
			                        	 <input name="endCareDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${scmCare.endCareDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
			                            <span class="input-group-addon">
			                                    <span class="fa fa-calendar"></span>
			                            </span>
			                        </div>
								</div>
								<div class="form-group"><span>负责人：</span>
									<sys:treeselect id="ownBy" name="ownBy.id" value="${scmCare.ownBy.id}" labelName="ownBy.name" labelValue="${scmCare.ownBy.name}"
										title="用户" url="/sys/office/treeData?type=3" cssClass="form-control input-small" allowClear="true" notAllowSelectParent="true"/>
								</div>
								
								<div class="form-group">
									<button class="btn btn-white btn-sm " onclick="search()"><i class="fa fa-search"></i> 查询</button>
									<button class="btn btn-white btn-sm " onclick="resetSearch()"><i class="fa fa-refresh"></i> 重置</button>
								</div>
						</form:form>
					</div>
				</div>
				
				<!-- 快速查询 -->
				<div class="row m-b-sm">
					<div class="col-sm-12">
						<div class="pull-left">	
							<div class="btn-group">
								<a class="btn btn-white btn-sm" href="${ctx}/scm/scmCare/list">全部</a>
								<a class="btn btn-white btn-sm" href="${ctx}/scm/scmCare/list?createBy.id=${fns:getUser().id}">我创建的</a>
								<a class="btn btn-white btn-sm" href="${ctx}/scm/scmCare/list?ownBy.id=${fns:getUser().id}">我负责的</a>
								<a class="btn btn-white btn-sm" href="${ctx}/scm/scmCare/list?beginCareDate=${fns:getDate('yyyy-MM-dd')}&endCareDate=${fns:getDayAfter(1)}">今日关怀的</a>
								<a class="btn btn-white btn-sm" href="${ctx}/scm/scmCare/list?beginCareDate=${fns:getDayAfter(-7)}&endCareDate=${fns:getDayAfter(1)}">7天内关怀的</a>
								<a class="btn btn-white btn-sm" href="${ctx}/scm/scmCare/list?beginCareDate=${fns:getDayAfter(-30)}&endCareDate=${fns:getDayAfter(1)}">30天内关怀的</a>
							
							</div>
						</div>
						<div class="pull-right">
							
							<shiro:hasPermission name="scm:scmCare:add">
								<table:addRow url="${ctx}/scm/scmCare/form" title="客户关怀" ></table:addRow><!-- 增加按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="scm:scmCare:edit">
							    <table:editRow url="${ctx}/scm/scmCare/form" title="客户关怀" id="contentTable" ></table:editRow><!-- 编辑按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="scm:scmCare:del">
								<table:delRow url="${ctx}/scm/scmCare/deleteAll" id="contentTable"></table:delRow><!-- 删除按钮 -->
							</shiro:hasPermission>
							<%-- 
							<shiro:hasPermission name="scm:scmCare:import">
								<table:importExcel url="${ctx}/scm/scmCare/import"></table:importExcel><!-- 导入按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="scm:scmCare:export">
					       		<table:exportExcel url="${ctx}/scm/scmCare/export"></table:exportExcel><!-- 导出按钮 -->
					       	</shiro:hasPermission>
					       <button class="btn btn-white btn-sm " data-toggle="tooltip" data-placement="left" onclick="sortOrRefresh()" title="刷新"><i class="glyphicon glyphicon-repeat"></i> 刷新</button>
					       --%>
						
						</div>
					</div>
				</div>
					
				<!-- 表格 -->
				<div class="table-responsive">
				<table id="contentTable" class="table table-bordered table-striped table-hover">
					<thead>
						<tr>
							<th width="30px"><input type="checkbox" class="i-checks"></th>
							<th>主题</th>
							<th>客户</th>
							<th width="100px">联系人</th>
							<th width="100px" class="sort-column a.care_type">关怀类型</th>
							<th width="100px" class="sort-column a.care_date">关怀日期</th>
							<th width="100px" class="sort-column a.own_by">负责人</th>
							<th width="100px">操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="scmCare">
						<tr>
							<td><input type="checkbox" id="${scmCare.id}" class="i-checks"></td>
							<td>
								<a href="#" onclick="openDialogView('查看客户关怀', '${ctx}/scm/scmCare/view?id=${scmCare.id}','800px', '500px')">
								${scmCare.name}
							</a></td>
							<td>
								${scmCare.customer.name}
							</td>
							<td>
								${scmCare.contacterName}
							</td>
							<td>
								${fns:getDictLabel(scmCare.careType, 'care_type', '')}
							</td>
							<td>
								<fmt:formatDate value="${scmCare.careDate}" pattern="yyyy-MM-dd"/>
							</td>
							<td>
								${scmCare.ownBy.name}
							</td>
							<td>
								
								<shiro:hasPermission name="scm:scmCare:edit">
			    					<a href="#" onclick="openDialog('修改客户关怀', '${ctx}/scm/scmCare/form?id=${scmCare.id}','800px', '500px')" class="" title="修改">修改</a>
								</shiro:hasPermission>
								
								<shiro:hasPermission name="scm:scmCare:del">
									<a href="${ctx}/scm/scmCare/delete?id=${scmCare.id}" onclick="return confirmx('确认要删除该客户关怀吗？', this.href)" class=" " title="删除">删除</a> 
								</shiro:hasPermission>
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