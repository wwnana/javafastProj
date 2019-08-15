<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>简历列表</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
	</script>
</head>
<body class="gray-bg">
	<div class="wrapper-content">
		<sys:message content="${message}"/>
		<div class="tabs-container">
		 	<ul class="nav nav-tabs">
		 		<li <c:if test='${hrResume.currentNode == 0}'>class="active"</c:if> ><a href="${ctx}/hr/hrResume/list?currentNode=0">简历管理</a></li>
		 		<li <c:if test='${hrResume.currentNode == 1}'>class="active"</c:if>><a href="${ctx}/hr/hrResume/list?currentNode=1">面试管理</a></li>
		 		<li <c:if test='${hrResume.currentNode == 2}'>class="active"</c:if>><a href="${ctx}/hr/hrResume/list?currentNode=2">录用管理</a></li>
		 		<li <c:if test='${hrResume.currentNode == 4}'>class="active"</c:if>><a href="${ctx}/hr/hrResume/list?currentNode=4">简历库</a></li>
		 		<li class="pull-right">
		 			<div style="margin:5px;">
		 				<a href="${ctx}/hr/hrResume/uploadForm" title="导入" class="btn btn-white btn-bitbucket pull-right"><i class="fa fa-folder-open-o"></i> 导入</a>
		 				<a href="${ctx}/hr/hrTemplate" title="设置" class="btn btn-white btn-bitbucket pull-right"><i class="fa fa-cog"></i> 设置</a>
		 			</div>
		 		</li>
		 	</ul>
		 	<div class="tab-content">
		 		<div id="tab-1" class="tab-pane active">
		 			<div class="panel-body">
		 				<!-- 快速查询 -->
						<div class="row">
							<div class="col-sm-12">
								<div class="btn-toolbar breadcrumb">
									<div class="btn-group">
										<%--简历状态: 0新简历, 1已推荐, 2推荐通过,3未通过 --%>
										<c:if test='${hrResume.currentNode == 0}'>
											<a href="${ctx}/hr/hrResume/list?currentNode=0&resumeStatus=0" class="btn-common">新简历</a>
											<a href="${ctx}/hr/hrResume/list?currentNode=0&resumeStatus=1" class="btn-common">已推荐</a>
											<a href="${ctx}/hr/hrResume/list?currentNode=0&resumeStatus=2" class="btn-common">推荐通过</a>
											<a href="${ctx}/hr/hrResume/list?currentNode=0&resumeStatus=3" class="btn-common">未通过</a>
										</c:if>
										<%--面试状态：已邀约0，1已签到, 2已面试 3: 已取消 --%>
										<c:if test='${hrResume.currentNode == 1}'>
											<a href="${ctx}/hr/hrResume/list?currentNode=1&interviewStatus=0" class="btn-common">已邀约</a>
											<a href="${ctx}/hr/hrResume/list?currentNode=1&interviewStatus=1" class="btn-common">已签到</a>
											<a href="${ctx}/hr/hrResume/list?currentNode=1&interviewStatus=2" class="btn-common">已面试</a>
											<a href="${ctx}/hr/hrResume/list?currentNode=1&interviewStatus=3" class="btn-common">已取消</a>
										</c:if>
										<%--录用状态：0待确认,1已接受, 2已入职,3已拒绝 --%>
										<c:if test='${hrResume.currentNode == 2}'>
											<a href="${ctx}/hr/hrResume/list?currentNode=2&employStatus=0" class="btn-common">待确认</a>
											<a href="${ctx}/hr/hrResume/list?currentNode=2&employStatus=1" class="btn-common">已接受</a>
											<a href="${ctx}/hr/hrResume/list?currentNode=2&employStatus=2" class="btn-common">已入职</a>
											<a href="${ctx}/hr/hrResume/list?currentNode=2&employStatus=3" class="btn-common">已拒绝 </a>
										</c:if>
										<%--人才库状态：0已淘汰，人才储备，2未入职 --%>
										<c:if test='${hrResume.currentNode == 4}'>
											<a href="${ctx}/hr/hrResume/list?currentNode=4&reserveStatus=0" class="btn-common">已淘汰</a>
											<a href="${ctx}/hr/hrResume/list?currentNode=4&reserveStatus=1" class="btn-common">人才储备</a>
											<a href="${ctx}/hr/hrResume/list?currentNode=4&reserveStatus=2" class="btn-common">未入职</a>
										</c:if>
									</div>
								</div>
							</div>
						</div>
						<!-- 查询栏 -->
						<div class="row">
							<div class="col-sm-12">
								<form:form id="searchForm" modelAttribute="hrResume" action="${ctx}/hr/hrResume/" method="post" class="form-inline">
									<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
									<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
									<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
									<table:searchRow></table:searchRow><!-- 查询栏隐藏 -->
									<form:hidden path="currentNode"/>
										<div class="form-group"><span>简历来源：</span>
											<form:select path="resumeSource" class="form-control input-medium">
												<form:option value="" label=""/>
												<form:options items="${fns:getDictList('resume_source')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
											</form:select>
										</div>
										<div class="form-group"><span>应聘岗位：</span>
											<form:input path="position" htmlEscape="false" maxlength="50" class="form-control input-medium"/>
										</div>
										<div class="form-group"><span>姓名：</span>
											<form:input path="name" htmlEscape="false" maxlength="20" class="form-control input-medium"/>
										</div>
										<div class="form-group"><span>手机号：</span>
											<form:input path="mobile" htmlEscape="false" maxlength="11" class="form-control input-medium"/>
										</div>
										<div class="form-group"><span>工作经验：</span>
											<form:select path="experience" class="form-control input-medium">
												<form:option value="" label=""/>
												<form:options items="${fns:getDictList('experience_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
											</form:select>
										</div>
										<div class="form-group"><span>学历：</span>
											<form:select path="education" class="form-control input-medium">
												<form:option value="" label=""/>
												<form:options items="${fns:getDictList('education_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
											</form:select>
										</div>
										<%-- 
										<div class="form-group"><span>当前环节：0：简历，1：面试，2：录用：3：入职：4： 简历库：</span>
											<form:select path="currentNode" class="form-control input-medium">
												<form:option value="" label=""/>
												<form:options items="${fns:getDictList('')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
											</form:select>
										</div>
										<div class="form-group"><span>简历状态: 0新简历, 1已推荐, 2推荐通过,3未通过：</span>
											<form:select path="resumeStatus" class="form-control input-medium">
												<form:option value="" label=""/>
												<form:options items="${fns:getDictList('resume_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
											</form:select>
										</div>
										<div class="form-group"><span>面试状态：已邀约0，1已签到, 2已面试 3: 已取消：</span>
											<form:select path="interviewStatus" class="form-control input-medium">
												<form:option value="" label=""/>
												<form:options items="${fns:getDictList('interview_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
											</form:select>
										</div>
										<div class="form-group"><span>录用状态：0待确认,1已接受, 2已入职,3已拒绝：</span>
											<form:select path="employStatus" class="form-control input-medium">
												<form:option value="" label=""/>
												<form:options items="${fns:getDictList('employ_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
											</form:select>
										</div>
										--%>
										<div class="form-group">
											<button class="btn btn-white btn-sm " onclick="search()"><i class="fa fa-search"></i> 查询</button>
											<button class="btn btn-white btn-sm " onclick="resetSearch()"><i class="fa fa-refresh"></i> 重置</button>
										</div>
								</form:form>
							</div>
						</div>
						<!-- 工具栏 -->
						<div class="row">
							<div class="col-sm-12 m-b-sm">
								<div class="pull-right">
									<div class="btn-group">
										<button id="searchBtn" class="btn btn-white btn-sm" title="搜索"><i class="fa fa-search"></i></button>
										<table:refreshRow></table:refreshRow>
									</div>
								</div>
								<div class="pull-left">
									<shiro:hasPermission name="hr:hrResume:add">
										<table:addRow url="${ctx}/hr/hrResume/form" title="简历" pageModel="page" label="添加简历"></table:addRow><!-- 增加按钮 -->
										<a href="${ctx}/hr/hrResume/uploadForm" class="btn btn-white btn-sm" title="导入简历"><i class="fa fa-folder-open-o"></i> 导入简历</a>
									</shiro:hasPermission>
									<%-- 
									<shiro:hasPermission name="hr:hrResume:export">
										<button id="btnExport" class="btn btn-white btn-sm " data-toggle="tooltip" data-placement="left" title="下载简历"><i class="fa fa-file-excel-o"></i> 下载简历</button>
							       	</shiro:hasPermission>
							       	
							       	<shiro:hasPermission name="hr:hrResume:edit">
									    <table:editRow url="${ctx}/hr/hrResume/form" title="简历" id="contentTable" pageModel="page"></table:editRow><!-- 编辑按钮 -->
									</shiro:hasPermission>
									<shiro:hasPermission name="hr:hrResume:del">
										<table:delRow url="${ctx}/hr/hrResume/deleteAll" id="contentTable"></table:delRow><!-- 删除按钮 -->
									</shiro:hasPermission>
									
									<table:batchRow url="${ctx}/hr/hrResume/reserveAll" id="reserveAll" title="简历" label="放弃" icon="fa-remove"></table:batchRow>
									
									<table:batchRow url="${ctx}/hr/hrResume/shareAll" id="contentTable" title="推荐共享简历" label="推荐共享" icon="fa-share"></table:batchRow>
									--%>
								</div>
							</div>
						</div>					
						<!-- 数据表格 -->
						<div class="table-responsive" style="min-height: 500px">
						<table id="contentTable" class="table table-bordered table-striped table-hover">
							<thead>
								<tr>
									<th width="50px"><input type="checkbox" class="i-checks"></th>
									<th width="100px">姓名</th>
									<th width="100px">手机号</th>
									<th class="sort-column a.experience">工作经验</th>
									<th class="sort-column a.education">学历</th>
									<th>毕业院校</th>
									<th class="sort-column a.specialty">专业</th>
									<th>上家公司</th>
									<th class="sort-column a.position">应聘岗位</th>
									<th width="100px" class="sort-column a.interview_num">面试次数</th>
									<th width="100px" class="sort-column a.resume_source">简历来源</th>
									<th width="100px" class="sort-column a.create_date">创建时间</th>
									<th width="50px">操作</th>
								</tr>
							</thead>
							<tbody>
							<c:forEach items="${page.list}" var="hrResume">
								<tr>
									<td><input type="checkbox" id="${hrResume.id}" class="i-checks"></td>
									<td>
										<a href="${ctx}/hr/hrResume/index?id=${hrResume.id}" title="查看">
											${hrResume.name}
										</a>
									</td>
									<td>
										<a href="${ctx}/hr/hrResume/index?id=${hrResume.id}" title="查看">${hrResume.mobile}</a>
									</td>
									<td>
										${fns:getDictLabel(hrResume.experience, 'experience_type', '')}
									</td>
									<td>
										${fns:getDictLabel(hrResume.education, 'education_type', '')}
									</td>
									<td>
										${fns:abbr(hrResume.university, 30)}
									</td>
									<td>
										${fns:abbr(hrResume.specialty, 30)}
									</td>
									<td>
										${fns:abbr(hrResume.lastCompany, 30)}
									</td>
									<td>
										${hrResume.position}
									</td>
									<td>
										${hrResume.interviewNum}
									</td>
									<td>
										${fns:getDictLabel(hrResume.resumeSource, 'resume_source', '')}
									</td>
									<td>
										<fmt:formatDate value="${hrResume.createDate}" pattern="yyyy-MM-dd"/>
									</td>
									<td>
										<div class="btn-group pull-right">
			                                <button data-toggle="dropdown" class="btn btn-default dropdown-toggle" aria-expanded="false"> <span class="caret"></span>
			                                </button>
			                                <ul class="dropdown-menu">
			                                    <li>
			                                    	<a href="${ctx}/hr/hrInterview/form?hrResume.id=${hrResume.id}">安排面试</a>
			                                    </li>
			                                    <li>
			                                    	<a href="${ctx}/hr/hrOffer/form?hrResume.id=${hrResume.id}">发送OFFER</a>
			                                    </li>
			                                    <li>
			                                    	<a href="#" onclick="openDialog('推荐共享', '${ctx}/hr/hrResume/shareForm?hrResume.id=${hrResume.id}','500px', '300px')">推荐共享</a>
			                                    </li>
			                                    <li>
			                                    	<a href="${hrResume.resumeFile}">下载简历</a>
			                                    </li>
			                                    <li class="divider"></li>
			                                    <li>
													<a href="#" onclick="openDialog('放弃', '${ctx}/hr/hrResume/revokeForm?id=${hrResume.id}','500px', '350px')">放弃</a>
			                                    </li>
			                                </ul>
			                            </div>
                            
        								<%--
										<shiro:hasPermission name="hr:hrResume:view">
											<a href="${ctx}/hr/hrResume/index?id=${hrResume.id}" class="btn btn-info btn-xs" title="查看"><i class="fa fa-search-plus"></i> 查看</a>
										</shiro:hasPermission>
										<shiro:hasPermission name="hr:hrResume:edit">
					    					<a href="${ctx}/hr/hrResume/form?id=${hrResume.id}" class="btn btn-success btn-xs" title="修改"><i class="fa fa-pencil"></i> 修改</a>
										</shiro:hasPermission>
										
										<shiro:hasPermission name="hr:hrResume:del">
											<a href="${ctx}/hr/hrResume/delete?id=${hrResume.id}" onclick="return confirmx('确认要删除该简历吗？', this.href)" class="btn  btn-danger btn-xs" title="删除"><i class="fa fa-trash"></i> 删除</a> 
										</shiro:hasPermission>
										 --%>
									</td>
								</tr>
							</c:forEach>
							</tbody>
						</table>
						<table:page page="${page}"></table:page>
						</div>
						
						
		 			</div>
		 		</div>
		 		<div id="tab-2" class="tab-pane">
		 			
		 		</div>
		 		<div id="tab-3" class="tab-pane">
		 			
		 		</div>
		 		<div id="tab-4" class="tab-pane">
		 			
		 		</div>
		 	</div>
		</div>
		 
		
	</div>
</body>
</html>