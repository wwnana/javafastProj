<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>我的通知</title>
   	<meta name="decorator" content="default"/>
</head>
<body class="">
	<div class="">
		<div class="">
			<div class="row dashboard-header gray-bg">
				<div class="pull-left">	
					<h5>通知列表 (总计${page.count}，未读${count })</h5>
				</div>
				<div class="pull-right">
					<form:form id="searchForm" modelAttribute="oaNotify" action="${ctx}/oa/oaNotify/${oaNotify.self?'self':''}" method="post" class="pull-right mail-search">
                    		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn  id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"></table:sortColumn><!-- 支持排序 -->
                        <div class="input-group">
                        	<form:input path="title" htmlEscape="false" maxlength="128"  class=" form-control input-sm" placeholder="搜索通知标题"/>
                            <div class="input-group-btn">
                                <button id="btnSubmit" type="submit" class="btn btn-sm btn-info">
                                    	搜索
                                </button>
                            </div>
                        </div>
                    </form:form>
				</div>
			</div>
			<div class="ibox-content">
			<sys:message content="${message}"/>	
			
				<!-- 查询条件 -->
				<div class="row m-b-md">
					<div class="col-sm-12">
						<div class="pull-left">
                       	<a href="${ctx}/oa/oaNotify/${oaNotify.self?'self':''}" class="btn btn-white btn-sm"  title="全部通知"> 全部</a>
                       	<c:forEach items="${fns:getDictList('oa_notify_type')}" var="notifyType">
	                    	<a href="${ctx}/oa/oaNotify/${oaNotify.self?'self':''}?type=${notifyType.value }"  class="btn btn-white btn-sm"> ${notifyType.label }</a>
                        </c:forEach>
                        
                        <a href="${ctx}/oa/oaNotify/${oaNotify.self?'self':''}?readFlag=0" class="btn btn-white btn-sm"> <i class="fa fa-circle text-danger"></i> 未读</a>
                        <a href="${ctx}/oa/oaNotify/${oaNotify.self?'self':''}?readFlag=1" class="btn btn-white btn-sm"> <i class="fa fa-circle text-warning"></i> 已读</a>
                        </div>     
						<div class="pull-right">
							<shiro:hasPermission name="oa:oaNotify:edit">
								<a class="btn btn-success btn-sm" href="${ctx}/oa/oaNotify/form" ><i class="fa fa-plus"></i> 发布通知</a>
								<a class="btn btn-white btn-sm" href="${ctx}/oa/oaNotify/list?status=0" ><i class="fa fa-search"></i> 查看草稿</a>
							</shiro:hasPermission>
                        	<button class="btn btn-white btn-sm" data-toggle="tooltip" data-placement="left" onclick="sortOrRefresh()" title="刷新列表"><i class="fa fa-refresh"></i> 刷新</button>
                        </div>
					</div>
				</div>
				
				<div class="table-responsive">
					
                    <table id="contentTable" class="table table-bordered table-striped table-hover">
                    	<thead> 
                    		<tr>
                    			
                    			<th>标题</th>
								<th width="120px">类型</th>
								<th width="100px">状态</th>
								<th width="100px">查阅状态</th>
								<th width="180px">发布时间</th>
                    		</tr>
                    	</thead>
                        <tbody>
                        
                        	<c:forEach items="${page.list}" var="oaNotify">
								<tr <c:if test='${oaNotify.readFlag ==0}'>class="unread"</c:if> <c:if test='${oaNotify.readFlag ==1}'>class="read"</c:if> >
									
									
	                                <td><a  href="${ctx}/oa/oaNotify/view?id=${oaNotify.id}">
	                                	<c:if test="${oaNotify.readFlag == 0}"><b></c:if>
										${fns:abbr(oaNotify.title,50)}
										<c:if test="${oaNotify.readFlag == 0}"></b></c:if>
									</a>
									</td>
									<td>
										${fns:getDictLabel(oaNotify.type, 'oa_notify_type', '')}
									</td>
									<td>
										${fns:getDictLabel(oaNotify.status, 'oa_notify_status', '')}
									</td>
									<td>
										<c:if test="${requestScope.oaNotify.self}">
											${fns:getDictLabel(oaNotify.readFlag, 'oa_notify_read', '')}
										</c:if>
										<c:if test="${!requestScope.oaNotify.self}">
											${oaNotify.readNum} / ${oaNotify.readNum + oaNotify.unReadNum}
										</c:if>
									</td>
									<td>
										<fmt:formatDate value="${oaNotify.updateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
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
	
	
    <div class="wrapper-content hide">
        <div class="row">
            <div class="col-sm-12 animated fadeInRight">
                <div class="mail-box-header">
				<sys:message content="${message}"/>	
                    <form:form id="searchForm" modelAttribute="oaNotify" action="${ctx}/oa/oaNotify/${oaNotify.self?'self':''}" method="post" class="pull-right mail-search">
                    		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn  id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"></table:sortColumn><!-- 支持排序 -->
                        <div class="input-group">
                        	<form:input path="title" htmlEscape="false" maxlength="128"  class=" form-control input-sm" placeholder="搜索通知标题"/>
                            <div class="input-group-btn">
                                <button id="btnSubmit" type="submit" class="btn btn-sm btn-success">
                                    搜索
                                </button>
                            </div>
                        </div>
                    </form:form>
                    <h2>
                    	通知列表 (总计${page.count}，未读${count })
                </h2>
                <div class="row">
                    <div class="mail-tools tooltip-demo m-t-md">
                        
                        <div class="pull-left">
                       	<a href="${ctx}/oa/oaNotify/${oaNotify.self?'self':''}" class="btn btn-white btn-sm"  title="全部通知"> 全部</a>
                       	<c:forEach items="${fns:getDictList('oa_notify_type')}" var="notifyType">
	                    	<a href="${ctx}/oa/oaNotify/${oaNotify.self?'self':''}?type=${notifyType.value }"  class="btn btn-white btn-sm"> ${notifyType.label }</a>
                        </c:forEach>
                        
                        <a href="${ctx}/oa/oaNotify/${oaNotify.self?'self':''}?readFlag=0" class="btn btn-white btn-sm"> <i class="fa fa-circle text-danger"></i> 未读</a>
                        <a href="${ctx}/oa/oaNotify/${oaNotify.self?'self':''}?readFlag=1" class="btn btn-white btn-sm"> <i class="fa fa-circle text-warning"></i> 已读</a>
                        </div>     
						<div class="pull-right">
							<shiro:hasPermission name="oa:oaNotify:edit">
								<a class="btn btn-white btn-sm" href="${ctx}/oa/oaNotify/form" ><i class="fa fa-plus"></i> 发布通知</a>
								<a class="btn btn-white btn-sm" href="${ctx}/oa/oaNotify/list?status=0" ><i class="fa fa-search"></i> 查看草稿</a>
							</shiro:hasPermission>
                        	<button class="btn btn-white btn-sm" data-toggle="tooltip" data-placement="left" onclick="sortOrRefresh()" title="刷新列表"><i class="fa fa-refresh"></i> 刷新</button>
                        </div>
                    </div>
                </div>
                </div>
                
                <div class="ibox-content">
                <div class="table-responsive">
					
                    <table id="contentTable" class="table table-bordered table-striped table-hover">
                    	<thead> 
                    		<tr>
                    			
                    			<th>标题</th>
								<th width="100px">类型</th>
								<th width="100px">状态</th>
								<th width="100px">查阅状态</th>
								<th width="150px">发布时间</th>
								<th width="150px">操作</th>
                    		</tr>
                    	</thead>
                        <tbody>
                        
                        	<c:forEach items="${page.list}" var="oaNotify">
								<tr <c:if test='${oaNotify.readFlag ==0}'>class="unread"</c:if> <c:if test='${oaNotify.readFlag ==1}'>class="read"</c:if> >
									
									
	                                <td><a  href="${ctx}/oa/oaNotify/view?id=${oaNotify.id}">
	                                	<c:if test="${oaNotify.readFlag == 0}"><b></c:if>
										${fns:abbr(oaNotify.title,50)}
										<c:if test="${oaNotify.readFlag == 0}"></b></c:if>
									</a>
									</td>
									<td>
										${fns:getDictLabel(oaNotify.type, 'oa_notify_type', '')}
									</td>
									<td>
										${fns:getDictLabel(oaNotify.status, 'oa_notify_status', '')}
									</td>
									<td>
										<c:if test="${requestScope.oaNotify.self}">
											${fns:getDictLabel(oaNotify.readFlag, 'oa_notify_read', '')}
										</c:if>
										<c:if test="${!requestScope.oaNotify.self}">
											${oaNotify.readNum} / ${oaNotify.readNum + oaNotify.unReadNum}
										</c:if>
									</td>
									<td>
										<fmt:formatDate value="${oaNotify.updateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
									</td>
									<td>
									
										
										<c:if test="${fns:getUser().id == oaNotify.createBy.id}">
										<shiro:hasPermission name="oa:oaNotify:edit">
					    					<a href="${ctx}/oa/oaNotify/form?id=${oaNotify.id}" class="btn btn-success btn-xs" ><i class="fa fa-edit"></i> 修改</a>
					    				</shiro:hasPermission>
					    				
					    				<shiro:hasPermission name="oa:oaNotify:del">
											<a href="${ctx}/oa/oaNotify/delete?id=${oaNotify.id}" onclick="return confirmx('确认要删除该通知吗？', this.href)"   class="btn btn-danger btn-xs"><i class="fa fa-trash"></i> 删除</a>
										</shiro:hasPermission>
										</c:if>
									
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
    </div>
    
</body>
</html>