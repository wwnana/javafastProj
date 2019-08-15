<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>联系人管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
	</script>
</head>
<body class="">
<div class="">
		<div class="">
			<div class="row dashboard-header gray-bg">
				<div class="pull-left">					
					<a class="btn btn-link" href="${ctx}/crm/crmContacter/list">全部</a>
					<a class="btn btn-link" href="${ctx}/crm/crmContacter/list?createBy.id=${fns:getUser().id}">我创建的</a>
					<a class="btn btn-link" href="${ctx}/crm/crmContacter/list?beginCreateDate=${fns:getDate('yyyy-MM-dd')}&endCreateDate=${fns:getDayAfter(1)}">今日创建的</a>
					<a class="btn btn-link" href="${ctx}/crm/crmContacter/list?beginCreateDate=${fns:getDayAfter(-7)}&endCreateDate=${fns:getDayAfter(1)}">7天内创建的</a>
					<a class="btn btn-link" href="${ctx}/crm/crmContacter/list?beginCreateDate=${fns:getDayAfter(-30)}&endCreateDate=${fns:getDayAfter(1)}">30天内创建的</a>
				</div>
				<div class="pull-right">					
					<div class="form-inline" style="padding-bottom: 0px;">
                        <div class="form-group">
                          	<form id="searchForm2" action="${ctx}/crm/crmContacter/" method="post">
	                    	<div class="input-group">	
	                        	<input type="text" id="keywords" name="keywords" value="${crmContacter.keywords}"  class=" form-control input-sm" placeholder="搜索姓名、客户名称"/>
	                            <div class="input-group-btn">
	                                <button id="btnSubmit" type="submit" class="btn btn-sm btn-white">
	                                    	<i class="fa fa-search"></i>
	                                </button>
	                                <button id="searchBtn" type="button" class="btn btn-white btn-sm" title="筛选"><i class="fa fa-angle-double-down"></i> 筛选</button>
	                            </div>
	                        </div>
	                        </form>
                        </div>
                        
                        <div class="form-group">
                        	<%-- 
							<a class="btn btn-white btn-sm" href="${ctx}/crm/crmContacter/list" title="刷新"><i class="fa fa-refresh"></i></a>
							<shiro:hasPermission name="crm:crmContacter:edit">
							    <table:editRow url="${ctx}/crm/crmContacter/form" title="联系人" id="contentTable" pageModel="page"></table:editRow><!-- 编辑按钮 -->
							</shiro:hasPermission>
							
							<shiro:hasPermission name="crm:crmContacter:del">
								<table:delRow url="${ctx}/crm/crmContacter/deleteAll" id="contentTable"></table:delRow><!-- 删除按钮 -->
							</shiro:hasPermission>
							
							<shiro:hasPermission name="crm:crmContacter:import">
								<table:importExcel url="${ctx}/crm/crmContacter/import"></table:importExcel><!-- 导入按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="crm:crmContacter:export">
					       		<table:exportExcel url="${ctx}/crm/crmContacter/export"></table:exportExcel><!-- 导出按钮 -->
					       	</shiro:hasPermission>
					       	--%>
							<shiro:hasPermission name="crm:crmContacter:add">
								<a class="btn btn-success btn-sm" href="#" onclick="openDialog('新建联系人', '${ctx}/crm/crmContacter/form','800px', '500px')" title="创建联系人"><i class="fa fa-plus"></i> 创建联系人</a>
							</shiro:hasPermission>
                    	</div>	
					</div>			
				</div>
			</div>

			<div class="ibox-content">
			<sys:message content="${message}"/>
				
				
				<!-- 查询条件 -->
				<div class="row">
					<div class="col-sm-12">
						<form:form id="searchForm" modelAttribute="crmContacter" action="${ctx}/crm/crmContacter/" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
							<table:searchRow></table:searchRow><!-- 查询栏 -->
								
								<div class="form-group"><span>姓名：</span>
									<form:input path="name" htmlEscape="false" maxlength="30" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>客户名称：</span>
									<form:input path="customer.name" htmlEscape="false" maxlength="50" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>手机：</span>
									<form:input path="mobile" htmlEscape="false" maxlength="30" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>QQ：</span>
									<form:input path="qq" htmlEscape="false" maxlength="30" class="form-control input-medium"/>
								</div>
								<%-- 
								<div class="form-group"><span>创建人：</span>
									<sys:treeselect id="createBy" name="createBy.id" value="${crmContacter.createBy.id}" labelName="createBy.name" labelValue="${crmContacter.createBy.name}"
										title="用户" url="/sys/office/treeData?type=3" cssClass="form-control input-small" allowClear="true" notAllowSelectParent="true"/>
								</div>
								<div class="form-group"><span>创建时间：</span>
									<div class="input-group date datepicker">
			                            <input name="beginCreateDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${crmContacter.beginCreateDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
			                            <span class="input-group-addon">
			                                    <span class="fa fa-calendar"></span>
			                            </span>
			                        </div>
			                         - 
			                        <div class="input-group" data-autoclose="true">
			                        	 <input name="endCreateDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${crmContacter.endCreateDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
			                            <span class="input-group-addon">
			                                    <span class="fa fa-calendar"></span>
			                            </span>
			                        </div>
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
							<th width="30px"><input type="checkbox" class="i-checks"></th>
							<th style="min-width:100px;width:100px;" class="sort-column name">姓名</th>
							<th style="min-width:250px;" class="sort-column c.name">所属客户</th>
							<th style="min-width:100px;width:100px;" class="sort-column role_type">角色</th>
							<th style="min-width:100px;width:100px;" class="sort-column job_type">职务</th>
							<th style="min-width:100px;width:100px;" class="sort-column mobile">手机</th>
							<th style="min-width:100px;width:100px;" class="sort-column tel">电话</th>
							<th style="min-width:100px;width:100px;" class="sort-column email">邮箱</th>
							
							<th style="min-width:100px;width:100px;" class="sort-column qq">QQ</th>
							
							<th style="min-width:150px;width:150px;">操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="crmContacter">
						<tr>
							<td><input type="checkbox" id="${crmContacter.id}" class="i-checks"></td>
							<td>
								<a href="${ctx}/crm/crmContacter/index?id=${crmContacter.id}">
								${crmContacter.name}
								</a>
							</td>
							<td>
								<a href="${ctx}/crm/crmCustomer/index?id=${crmContacter.customer.id}" title="跟进">
									${crmContacter.customer.name}
								</a>
							</td>							
							<td>
								${fns:getDictLabel(crmContacter.roleType, 'role_type', '')}
							</td>
							<td>
								${crmContacter.jobType}
							</td>
							<td>
								${crmContacter.mobile}
							</td>
							<td>
								${crmContacter.tel}
							</td>
							<td>
								${crmContacter.email}
							</td>
							
							<td>
								${crmContacter.qq}
							</td>
							
							<td>
								<shiro:hasPermission name="crm:crmContacter:view">
									<a href="${ctx}/crm/crmContacter/index?id=${crmContacter.id}" title="查看">查看</a>
								</shiro:hasPermission>
								<shiro:hasPermission name="crm:crmContacter:edit">
			    					<a href="#" onclick="openDialog('修改联系人', '${ctx}/crm/crmContacter/form?id=${crmContacter.id}','800px', '500px')" class="" title="修改">修改</a>
								</shiro:hasPermission>
								<shiro:hasPermission name="crm:crmContacter:del">
									<a href="${ctx}/crm/crmContacter/delete?id=${crmContacter.id}" onclick="return confirmx('确认要删除该联系人吗？', this.href)" class="" title="删除">删除</a> 
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