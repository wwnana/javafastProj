<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>业务数据管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
		});
		//0:隐藏tip, 1隐藏box,不设置显示全部
		//top.$.jBox.closeTip();
	</script>
</head>
<body class="gray-bg">
<div class="wrapper-content">
		<div class="ibox">
			<div class="ibox-title">
				<h5>业务数据列表 (查询性能测试)</h5>
			</div>
			<div class="ibox-content">
				<div class="alert alert-success alert-dismissable">
                    <button aria-hidden="true" data-dismiss="alert" class="close" type="button">×</button>
                   ${timeResult}
                </div>
                        
			<sys:message content="${message}"/>
				
				<!-- 查询条件 -->
				<div class="row">
					<div class="col-sm-12">
						<form:form id="searchForm" modelAttribute="testData" action="${ctx}/test/grid/testData/" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
								<div class="form-group"><span>姓名：</span>
									<form:input path="name" htmlEscape="false" maxlength="50" class="form-control input-small"/>
								</div>
								<div class="form-group"><span>性别：</span>
									<form:radiobuttons path="sex" items="${fns:getDictList('sex')}" itemLabel="label" itemValue="value" htmlEscape="false" cssClass="i-checks"/>
								</div>
								<div class="form-group"><span>创建者：</span>
									<sys:treeselect id="createBy" name="createBy.id" value="${testData.createBy.id}" labelName="createBy.name" labelValue="${testData.createBy.name}"
										title="用户" url="/sys/office/treeData?type=3" cssClass="form-control input-small" allowClear="true" notAllowSelectParent="true"/>
								</div>
								<div class="form-group"><span>创建时间：</span>
									<div class="input-group date datepicker">
			                            <input name="beginCreateDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${testData.beginCreateDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
			                            <span class="input-group-addon">
			                                    <span class="fa fa-calendar"></span>
			                            </span>
			                        </div>
			                         - 
			                        <div class="input-group" data-autoclose="true">
			                        	 <input name="endCreateDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${testData.endCreateDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
			                            <span class="input-group-addon">
			                                    <span class="fa fa-calendar"></span>
			                            </span>
			                        </div>
								</div>
								<div class="form-group">
									<button class="btn btn-white btn-sm" onclick="search()"><i class="fa fa-search"></i> 查询</button>
									<button class="btn btn-white btn-sm" onclick="resetSearch()"><i class="fa fa-refresh"></i> 重置</button>
								</div>
						</form:form>
					</div>
				</div>
				<!-- 工具栏 -->
				<div class="row">
					<div class="col-sm-12 m-b-sm">
						<div class="pull-left">
							<shiro:hasPermission name="test:grid:testData:add">
								<table:addRow url="${ctx}/test/grid/testData/form" title="业务数据"></table:addRow><!-- 增加按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="test:grid:testData:edit">
							    <table:editRow url="${ctx}/test/grid/testData/form" title="业务数据" id="contentTable"></table:editRow><!-- 编辑按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="test:grid:testData:del">
								<table:delRow url="${ctx}/test/grid/testData/deleteAll" id="contentTable"></table:delRow><!-- 删除按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="test:grid:testData:import">
								<table:importExcel url="${ctx}/test/grid/testData/import"></table:importExcel><!-- 导入按钮 -->
							</shiro:hasPermission>
							<%--
							<shiro:hasPermission name="test:grid:testData:export">
					       		<table:exportExcel url="${ctx}/test/grid/testData/export"></table:exportExcel><!-- 导出按钮 -->
					       	</shiro:hasPermission>
					       	 --%>
					       <button class="btn btn-white btn-sm " data-toggle="tooltip" data-placement="left" onclick="sortOrRefresh()" title="刷新"><i class="glyphicon glyphicon-repeat"></i> 刷新</button>
						
						</div>
						<div class="pull-right">
						</div>
					</div>
				</div>
					
				<!-- 表格 -->
				<div class="table-responsive">
				<table id="contentTable" class="table table-bordered table-striped table-hover">
					<thead>
						<tr>
							<th><input type="checkbox" class="i-checks"></th>
							<th class="sort-column a.name">姓名</th>
							<th class="sort-column a.sex">性别</th>
							<th class="sort-column a.age">年龄</th>
							<th class="sort-column a.mobile">手机号码</th>
							<th class="sort-column a.email">电子邮箱</th>
							<th class="sort-column a.address">联系地址</th>
							<th class="sort-column a.create_name">创建者</th>
							<th class="sort-column a.create_date">创建时间</th>
							<th class="sort-column a.update_name">更新者</th>
							<th class="sort-column a.update_date">更新时间</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="testData">
						<tr>
							<td><input type="checkbox" id="${testData.id}" class="i-checks"></td>
							<td><a href="#" onclick="openDialogView('查看业务数据', '${ctx}/test/grid/testData/view?id=${testData.id}','800px', '500px')">
								${testData.name}
							</a></td>
							<td>
								${fns:getDictLabel(testData.sex, 'sex', '')}
							</td>
							<td>
								${testData.age}
							</td>
							<td>
								${testData.mobile}
							</td>
							<td>
								${testData.email}
							</td>
							<td>
								${testData.address}
							</td>
							<td>
								${testData.createBy.name}
							</td>
							<td>
								<fmt:formatDate value="${testData.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</td>
							<td>
								${testData.updateBy.name}
							</td>
							<td>
								<fmt:formatDate value="${testData.updateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</td>
							<td>
								<shiro:hasPermission name="test:grid:testData:view">
									<a href="#" onclick="openDialogView('查看业务数据', '${ctx}/test/grid/testData/view?id=${testData.id}','800px', '500px')" class="btn btn-info btn-xs" title="查看"><i class="fa fa-search-plus"></i> 查看</a>
								</shiro:hasPermission>
								<shiro:hasPermission name="test:grid:testData:edit">
			    					<a href="#" onclick="openDialog('修改业务数据', '${ctx}/test/grid/testData/form?id=${testData.id}','800px', '500px')" class="btn btn-success btn-xs" title="修改"><i class="fa fa-edit"></i>
										<span class="hidden-xs">修改</span></a>
								</shiro:hasPermission>
								<shiro:hasPermission name="test:grid:testData:del">
									<a href="${ctx}/test/grid/testData/delete?id=${testData.id}" onclick="return confirmx('确认要删除该业务数据吗？', this.href)" class="btn  btn-danger btn-xs" title="删除"><i class="fa fa-trash"></i>
										<span class="hidden-xs">删除</span></a> 
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