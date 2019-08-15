<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>项目列表</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
	</script>
</head>
<body class="">
	<div class="">
		<div class="">
			<div class="row dashboard-header gray-bg">
				<div class="pull-left">					
					<a class="btn btn-link" href="${ctx}/oa/oaProject/list">我参与的</a>
					<a class="btn btn-link" href="${ctx}/oa/oaProject/list?createBy.id=${fns:getUser().id}">我创建的</a>
					<a class="btn btn-link" href="${ctx}/oa/oaProject/list?ownBy.id=${fns:getUser().id}">我负责的</a>
					<a class="btn btn-link" href="${ctx}/oa/oaProject/list?ownBy.id=${fns:getUser().id}&status=2">我完成的</a>
					<a class="btn btn-link" href="${ctx}/oa/oaProject/list?beginEndDate=${fns:getDate('yyyy-MM-dd')}&endEndDate=${fns:getDayAfter(1)}">今日到期的</a>
					<a class="btn btn-link" href="${ctx}/oa/oaProject/list?beginEndDate=${fns:getDate('yyyy-MM-dd')}&endEndDate=${fns:getDayAfter(7)}">7天内到期的</a>
					<a class="btn btn-link" href="${ctx}/oa/oaProject/list?beginEndDate=${fns:getDate('yyyy-MM-dd')}&endEndDate=${fns:getDayAfter(30)}">30天内到期的</a>
				</div>
				<div class="pull-right">
					<a href="${ctx}/oa/oaProject/list" class="btn btn-white btn-sm active" title="列块展示"><i class="fa fa-th-large"></i></a>
					<a href="${ctx}/oa/oaProject/list2" class="btn btn-white btn-sm" title="列表展示"><i class="fa fa-list-ul"></i></a>
					<button id="searchBtn" class="btn btn-white btn-sm" title="搜索"><i class="fa fa-search"></i> 搜索</button>
					<shiro:hasPermission name="oa:oaProject:export">
					       		<table:exportExcel url="${ctx}/oa/oaProject/export"></table:exportExcel><!-- 导出按钮 -->
					</shiro:hasPermission>
					<shiro:hasPermission name="oa:oaProject:add">
						<a class="btn btn-success btn-sm" href="${ctx}/oa/oaProject/form" title="创建项目"><i class="fa fa-plus"></i> 创建项目</a>
					</shiro:hasPermission>
					
				</div>			
			</div>
			<div class="ibox-content">
			<sys:message content="${message}"/>	
				<!-- 查询栏 -->
				<div class="row text-center">
					<div class="col-sm-12">
						<form:form id="searchForm" modelAttribute="oaProject" action="${ctx}/oa/oaProject/" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
							<table:searchRow></table:searchRow><!-- 查询栏隐藏 -->
								<div class="form-group"><span>项目名称：</span>
									<form:input path="name" htmlEscape="false" maxlength="50" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>负责人：</span>
									<sys:treeselect id="ownBy" name="ownBy.id" value="${oaProject.ownBy.id}" labelName="ownBy.name" labelValue="${oaProject.ownBy.name}"
										title="用户" url="/sys/office/treeData?type=3" cssClass="form-control input-small" allowClear="true" notAllowSelectParent="true"/>
								</div>
								<div class="form-group"><span>项目状态：</span>
									<form:select path="status" class="form-control input-small">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('task_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group">
									<button class="btn btn-white btn-sm " onclick="search()"><i class="fa fa-search"></i> 查询</button>
									<button class="btn btn-white btn-sm " onclick="resetSearch()"><i class="fa fa-refresh"></i> 重置</button>
								</div>
						</form:form>
					</div>
				</div>
				
				<div class=" animated fadeInRight">
			        <div class="row">
			        	<c:forEach items="${page.list}" var="oaProject">
			            <div class="col-sm-4">            
			            	<div class="ibox">
			                    <div class="ibox-title">
			                        <span class="label <c:if test='${oaProject.status == 1}'>label-info</c:if><c:if test='${oaProject.status == 2}'>label-success</c:if><c:if test='${oaProject.status == 3}'>label-warning</c:if> pull-right">${fns:getDictLabel(oaProject.status, 'task_status', '')}</span>
			                        <h5><strong>${oaProject.name }</strong></h5>
			                    </div>
			                    <div class="ibox-content">
			                        <div style="height: 40px;overflow: hidden;">
			                            ${fns:abbr(oaProject.content,200)}
			                        </div>
			                        <div style="padding-top: 10px;">
			                            <span>当前进度：</span>
			                            <div class="stat-percent">${oaProject.schedule}%</div>
			                            <div class="progress progress-mini">
			                                <div style="width: ${oaProject.schedule}%;" class="progress-bar"></div>
			                            </div>
			                        </div>
			                        <div class="row  m-t-sm hide">
			                            <div class="col-sm-4">
			                                <div class="font-bold">任务</div>
			                                12
			                            </div>
			                            <div class="col-sm-4">
			                                <div class="font-bold">周期</div>
			                                4个月
			                            </div>
			                            <div class="col-sm-4 text-right">
			                                <div class="font-bold">预算</div>
			                                ¥200,913 <i class="fa fa-level-up text-navy"></i>
			                            </div>
			                        </div>
									 <div class="row m-t-sm ">
										<shiro:hasPermission name="oa:oaProject:view">
											<div class="pull-right">
												&nbsp;&nbsp;&nbsp;<a href="${ctx}/oa/oaProject/view?id=${oaProject.id}" class="btn btn-info btn-sm pull-right" title="查看">进入</a>
											</div>
											<div class="pull-right" style="line-height: 35px">
												<i class="fa fa-user"></i> ${oaProject.ownBy.name}
												&nbsp;&nbsp;<i class="fa fa-clock-o"></i> <fmt:formatDate value="${oaProject.startDate}" pattern="yyyy-MM-dd"/> ~ <fmt:formatDate value="${oaProject.endDate}" pattern="yyyy-MM-dd"/>
											</div>
																					
										</shiro:hasPermission>
									</div>
			                    </div>
			                </div>
			            </div>
			            </c:forEach>    
			        </div>
			    </div>
    			<div class="row">
    				<c:if test="${fn:length(page.list)==0}">
    					<p class="text-muted text-center">对不起，没有任何数据噢！<a class="" href="${ctx}/oa/oaProject/form">创建项目</a></p>
    				</c:if>
    				<c:if test="${fn:length(page.list)>10}">
    					<table:page page="${page}"></table:page>
    				</c:if>
    				
    			</div>
			</div>
		</div>
	</div>
	

</body>
</html>