<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<jsp:useBean id="now" class="java.util.Date" />     
<fmt:formatDate value="${now}" type="both" dateStyle="long" pattern="yyyy-MM-dd" var="nowDate"/>
<html>
<head>
	<title>商机管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">

	</script>
</head>
<body class="">
<div class="">
		<div class="">
			<div class="row dashboard-header gray-bg">
				<div class="pull-left">			
					<a class="btn btn-link" href="${ctx}/crm/crmChance/list2">全部</a>
					<a class="btn btn-link" href="${ctx}/crm/crmChance/list2?createBy.id=${fns:getUser().id}">我创建的</a>
					<a class="btn btn-link" href="${ctx}/crm/crmChance/list2?ownBy.id=${fns:getUser().id}">我负责的</a>
				</div>
				<div class="pull-right">
					<div class="form-inline" style="padding-bottom: 0px;">					
						<div class="form-group">
							<a href="${ctx}/crm/crmChance/list" class="btn btn-white btn-sm" title="列表"><i class="fa fa-list-ul"></i> 列表模式</a>
							<a href="${ctx}/crm/crmChance/list2" class="btn btn-white btn-sm active" title="看板"><i class="fa fa-th-large"></i> 看板模式</a>
						</div>
						<div class="form-group">
                          	<form id="searchForm2" action="${ctx}/crm/crmChance/list2" method="post">
	                    	<div class="input-group">	
	                        	<input type="text" id="keywords" name="keywords" value="${crmChance.keywords}"  class=" form-control input-sm" placeholder="搜索商机名称、客户名称"/>
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
							<a class="btn btn-white btn-sm" href="${ctx}/crm/crmChance/list" title="刷新"><i class="fa fa-refresh"></i></a>
							<shiro:hasPermission name="crm:crmChance:edit">
							    <table:editRow url="${ctx}/crm/crmChance/form" title="商机" id="contentTable" pageModel="page"></table:editRow><!-- 编辑按钮 -->
							</shiro:hasPermission>
							
							<shiro:hasPermission name="crm:crmChance:del">
								<table:delRow url="${ctx}/crm/crmChance/deleteAll" id="contentTable"></table:delRow><!-- 删除按钮 -->
							</shiro:hasPermission>
							--%>
							
							<shiro:hasPermission name="crm:crmChance:add">
								<a class="btn btn-success btn-sm" href="#" onclick="openDialog('创建商机', '${ctx}/crm/crmChance/form','1000px', '600px')" title="创建商机"><i class="fa fa-plus"></i> 创建商机</a>
							</shiro:hasPermission>
							<div class="btn-group">
		                        <button data-toggle="dropdown" class="btn btn-white btn-sm dropdown-toggle" aria-expanded="false">更多 <span class="caret"></span>
		                        </button>
		                        <ul class="dropdown-menu">
		                            <li>
		                            	<shiro:hasPermission name="crm:crmChance:export">
								       		<table:exportExcel url="${ctx}/crm/crmChance/export"></table:exportExcel><!-- 导出按钮 -->
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
						<form:form id="searchForm" modelAttribute="crmChance" action="${ctx}/crm/crmChance/list2" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
							<table:searchRow></table:searchRow><!-- 搜索栏隐藏 -->
								<div class="form-group"><span>商机名称：</span>
									<form:input path="name" htmlEscape="false" maxlength="50" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>客户名称：</span>
									<form:input path="customer.name" htmlEscape="false" maxlength="50" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>销售阶段：</span>
									<form:select path="periodType" class="form-control input-medium" cssClass="input-small">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('period_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<%--
								<div class="form-group"><span>商机类型：</span>
									<form:select path="changeType" class="form-control input-medium" cssClass="input-small">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('change_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>商机来源：</span>
									<form:select path="sourType" class="form-control input-medium" cssClass="input-small">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('sour_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								 --%>
								<div class="form-group"><span>负责人：</span>
									<sys:treeselect id="ownBy" name="ownBy.id" value="${crmChance.ownBy.id}" labelName="ownBy.name" labelValue="${crmChance.ownBy.name}"
										title="用户" url="/sys/office/treeData?type=3" cssClass="form-control input-small" allowClear="true" notAllowSelectParent="true"/>
								</div>
								<div class="form-group"><span>创建时间：</span>
									<div class="input-group date datepicker">
			                            <input name="beginCreateDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${crmChance.beginCreateDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
			                            <span class="input-group-addon">
			                                    <span class="fa fa-calendar"></span>
			                            </span>
			                        </div>
			                         - 
			                        <div class="input-group" data-autoclose="true">
			                        	 <input name="endCreateDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${crmChance.endCreateDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
			                            <span class="input-group-addon">
			                                    <span class="fa fa-calendar"></span>
			                            </span>
			                        </div>
								</div>
								<%-- 
								<div class="form-group"><span>下次联系：</span>
									<div class="input-group date datepicker">
			                            <input name="beginNextcontactDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${crmChance.beginNextcontactDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
			                            <span class="input-group-addon">
			                                    <span class="fa fa-calendar"></span>
			                            </span>
			                        </div>
			                         - 
			                        <div class="input-group" data-autoclose="true">
			                        	 <input name="endNextcontactDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${crmChance.endNextcontactDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
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
				<div class="row">
					<c:forEach items="${fns:getDictList('period_type')}" var="dict">
					<div class="col-sm-2">
						<div class="ibox">
							<div class="ibox-content">
								<h3>${dict.label }</h3>
                       			<%-- <p class="small"><i class="fa fa-hand-o-up"></i> 在列表之间拖动任务面板</p>--%>
                        		<ul class="sortable-list connectList agile-list ui-sortable">
		                            <c:forEach items="${crmChanceList}" var="crmChance">
		                            <c:if test="${crmChance.periodType == dict.value}">
		                            <li class="warning-element" onclick="window.location.href='${ctx}/crm/crmChance/index?id=${crmChance.id}'">
		                              	  ${fns:abbr(crmChance.name,50)}
		                                <div class="agile-detail">
		                                    <i class="fa fa-building"></i> ${fns:abbr(crmChance.customer.name,50)}
		                                </div>
		                                <div class="agile-detail">
		                                    <i class="fa fa-cny"></i> 预计成交：${crmChance.saleAmount}
		                                </div>
		                                <div class="agile-detail">
		                                    <i class="fa fa-clock-o"></i> <fmt:formatDate value="${crmChance.createDate}" pattern="yyyy-MM-dd"/>
		                                </div>
		                            </li>
		                            </c:if>
		                            </c:forEach>
                            	</ul>
							</div>
						</div>
					</div>
					</c:forEach>
					
				</div>
				
				
			</div>
		</div>
	</div>
</body>
</html>