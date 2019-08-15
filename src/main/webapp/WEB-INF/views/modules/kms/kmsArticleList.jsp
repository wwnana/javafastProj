<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>知识列表</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
		});
		//0:隐藏tip, 1隐藏box,不设置显示全部
		top.$.jBox.closeTip();
	</script>
</head>
<body class="gray-bg">
	<div class="">
		<div class="box">
			<div class="row dashboard-header gray-bg">
				<div class="pull-left">
						<shiro:hasPermission name="kms:kmsArticle:add">
							<a href="${ctx}/kms/kmsArticle/form?kmsCategory.id=${kmsArticle.kmsCategory.id}" class="btn btn-success btn-sm" target="_parent" title="新建知识" ><i class="fa fa-plus"></i> 添加知识</a>
						</shiro:hasPermission>
						<a href="${ctx}/kms/kmsArticle/list?status=0" class="btn btn-white btn-sm ">未发布</a>
						
				</div>
				<div class="pull-right">
					
					<form:form id="searchForm" modelAttribute="kmsArticle" action="${ctx}/kms/kmsArticle/list" method="post" class="mail-search">
						<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
						<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
						<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
							
                        <div class="input-group">
                        	<form:input path="title" htmlEscape="false" maxlength="50" class="form-control input-sm" placeholder="搜索知识标题"/>
                            <div class="input-group-btn">
                                <button type="submit" class="btn btn-sm btn-info">
                                    搜索
                                </button>
                            </div>
                        </div>
                        
						
                    </form:form>
                    
							
				</div>
			</div>
			<div class="ibox-content">
			<sys:message content="${message}"/>	
				
				<div class="table-responsive">
				<table id="contentTable" class="table table-bordered table-striped table-hover">
                    	<thead> 
                    		<tr>
								<th>标题</th>
								<th width="200px">分类</th>
								<%--
								<th>排序</th>
								 --%>
								<th width="100px">点击数</th>
								<th width="100px">状态</th>
								<th width="100px">创建者</th>
								<th width="100px">创建时间</th>
								<%-- <th width="100px">操作</th>--%>
							</tr>
						</thead>
						<tbody>
						<c:forEach items="${page.list}" var="kmsArticle">
							<tr>
								<td>
									<a href="${ctx}/kms/kmsArticle/view?id=${kmsArticle.id}" target="_parent">${kmsArticle.title}</a>
								</td>
								<td>								
									${kmsArticle.kmsCategory.name}
								</td>
								<%-- 
								<td>
									${kmsArticle.sort}
								</td>
								--%>
								<td>
									${kmsArticle.hits}
								</td>
								<td>
									<c:if test="${kmsArticle.status == 1}">已发布</c:if>
									<c:if test="${kmsArticle.status == 0}">未发布</c:if>
								</td>
								<td>
									${kmsArticle.createBy.name}
								</td>
								<td>
									<fmt:formatDate value="${kmsArticle.createDate}" pattern="yyyy-MM-dd"/>
								</td>
								<%-- 
								<td>
									
									<c:if test="${fns:getUser().id == kmsArticle.createBy.id}">
									<c:if test="${kmsArticle.status == 0}">
									<shiro:hasPermission name="kms:kmsArticle:edit">
				    					<a href="${ctx}/kms/kmsArticle/form?id=${kmsArticle.id}" class="btn btn-success btn-xs" title="修改"><i class="fa fa-edit"></i></a>
									</shiro:hasPermission>
									
									<shiro:hasPermission name="kms:kmsArticle:del">
										<a href="${ctx}/kms/kmsArticle/delete?id=${kmsArticle.id}" onclick="return confirmx('确认要删除该知识吗？', this.href)" target="_parent" class="btn  btn-danger btn-xs" title="删除"><i class="fa fa-trash"></i></a> 
									</shiro:hasPermission>
									
									
									<shiro:hasPermission name="kms:kmsArticle:audit">
										<a href="${ctx}/kms/kmsArticle/audit?id=${kmsArticle.id}" onclick="return confirmx('确认要发布该知识吗？', this.href)" target="_parent" class="btn  btn-success btn-xs" title="发布"><i class="fa fa-check"></i></a> 
									</shiro:hasPermission>
									</c:if>
									<c:if test="${kmsArticle.status == 1}">
									<shiro:hasPermission name="kms:kmsArticle:audit">
										<a href="${ctx}/kms/kmsArticle/unAudit?id=${kmsArticle.id}" onclick="return confirmx('确认要撤销该知识吗？', this.href)" target="_parent" class="btn  btn-danger btn-xs" title="撤销"><i class="fa fa-remove"></i></a> 
									</shiro:hasPermission>
									</c:if>
									
									</c:if>
								</td>
								--%>
							</tr>
						</c:forEach>
						</tbody>
					</table>
					<c:if test="${page.count == 0}">
						<p>对不起，没有任何数据噢！<a class="" href="${ctx}/kms/kmsArticle/form">发表知识</a></p>
					</c:if>
					<table:page page="${page}"></table:page>
				</div>
			</div>
		</div>
	</div>


                
	
</body>
</html>