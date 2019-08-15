<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>日志管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
	        //外部js调用
	        laydate({
	            elem: '#beginDate', //目标元素。由于laydate.js封装了一个轻量级的选择器引擎，因此elem还允许你传入class、tag但必须按照这种方式 '#id .class'
	            event: 'focus' //响应事件。如果没有传入event，则按照默认的click
	        });
	        laydate({
	            elem: '#endDate', //目标元素。由于laydate.js封装了一个轻量级的选择器引擎，因此elem还允许你传入class、tag但必须按照这种方式 '#id .class'
	            event: 'focus' //响应事件。如果没有传入event，则按照默认的click
	        });

	       
	    })
	</script>
</head>
<body class="gray-bg">
<div class="">
	<div class="">
		<div class="ibox-title">
				<h5>日志列表 </h5>
			</div>
		    
		    <div class="ibox-content">
			<sys:message content="${message}"/>
			
			<!-- 查询条件 -->
			<div class="row">
			<div class="col-sm-12">
				<form:form id="searchForm"  modelAttribute="crmCustomer"  action="${ctx}/sys/log/" method="post"  class="form-inline">
					<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
					<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
					<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
					<c:if test="${fns:getUser().id == 1}">
					<div class="form-group">
						<span>企业账号：</span>
						<input id="accountId" name="accountId" type="text" maxlength="50" class="form-control input-sm" value="${log.accountId}"/>
					</div>
					<div class="form-group">
						<span>操作菜单：</span>
						<input id="title" name="title" type="text" maxlength="50" class="form-control input-sm" value="${log.title}"/>
					</div>
					</c:if>
					<div class="form-group">
						<span>操作用户：</span>
						<sys:treeselect id="createBy" name="createBy.id" value="${log.createBy.id}" labelName="createBy.name" labelValue="${log.createBy.name}"
								title="用户" url="/sys/office/treeData?type=3" cssClass="form-control input-small" allowClear="true" notAllowSelectParent="true"/>			
					</div>
					<div class="form-group">
						<span>日期范围：&nbsp;</span>
							<div class="input-group date datepicker">
			                    	<input name="beginDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${log.beginDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
			                    	<span class="input-group-addon">
			                            <span class="fa fa-calendar"></span>
			                    	</span>
					        </div>
					         - 
					        <div class="input-group date datepicker">
			                    	<input name="endDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${log.endDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
			                    	<span class="input-group-addon">
			                            <span class="fa fa-calendar"></span>
			                    	</span>
					        </div>
					</div>
					<c:if test="${fns:getUser().id == 1}">
					<div class="form-group">
						&nbsp;<label for="exception"><input id="exception" name="exception" class="i-checks" type="checkbox"${log.exception eq '1'?' checked':''} value="1"/> 异常信息</label>
					</div>
					</c:if>
					<div class="form-group">
							<button class="btn btn-white btn-sm " onclick="search()"><i class="fa fa-search"></i> 查询</button>
							<button class="btn btn-white btn-sm " onclick="resetSearch()"><i class="fa fa-refresh"></i> 重置</button>
					</div>
				</form:form>
			</div>
		</div>
	
		<c:if test="${fns:getUser().id == 1}">	
			<!-- 工具栏 -->
			<div class="row">
			<div class="col-sm-12 m-b-sm">
				<div class="pull-left">
					<c:if test="${fns:getUser().id == 1}">
					<shiro:hasPermission name="sys:log:del">
						<table:delRow url="${ctx}/sys/log/deleteAll" id="contentTable"></table:delRow><!-- 删除按钮 -->
						<button class="btn btn-white btn-sm "  onclick="confirmx('确认要清空日志吗？','${ctx}/sys/log/empty')"  title="清空"><i class="fa fa-trash"></i> 清空</button>
					</shiro:hasPermission>
					</c:if>
			        <button class="btn btn-white btn-sm " data-toggle="tooltip" data-placement="left" onclick="sortOrRefresh()" title="刷新"><i class="glyphicon glyphicon-repeat"></i> 刷新</button>
				
				</div>
			</div>
			</div>
		</c:if>
	
		<!-- 表格 -->
		<div class="table-responsive">
		<table id="contentTable" class="table table-bordered table-striped table-hover">
		<thead>
			<tr>	
				<th width="30px"><input type="checkbox" class="i-checks"></th>
				<c:if test="${fns:getUser().id == 1}">
					<th width="100px">企业账号</th>
				</c:if>
				<th>操作菜单</th>
				<th width="120px">操作用户</th>
				<th>所在公司</th>
				<th>所在部门</th>
				<c:if test="${fns:getUser().id == 1}">
				<th>URI</th>
				<th width="100px">提交方式</th>
				</c:if>
				<th width="100px">操作者IP</th>
				<th width="160px">操作时间</th>
				<th width="100px">操作终端</th>
			</thead>
		<tbody><%request.setAttribute("strEnter", "\n");request.setAttribute("strTab", "\t");%>
		<c:forEach items="${page.list}" var="log">
			<tr>
				<td> <input type="checkbox" id="${log.id}" class="i-checks"></td>
				<c:if test="${fns:getUser().id == 1}">
					<td>${log.accountId}</td>
				</c:if>
				<td>${log.title}</td>
				<td>${log.createBy.name}</td>
				<td>${log.createBy.company.name}</td>
				<td>${log.createBy.office.name}</td>
				<c:if test="${fns:getUser().id == 1}">
				<td><strong>${log.requestUri}</strong></td>
				<td>${log.method}</td>
				</c:if>
				<td>${log.remoteAddr}</td>
				<td><fmt:formatDate value="${log.createDate}" type="both"/></td>
				<td><c:if test="${log.dataType == 0}">PC</c:if><c:if test="${log.dataType == 2}">企业微信</c:if><c:if test="${log.dataType == 4}">Android</c:if></td>
			</tr>
			
			<c:if test="${fns:getUser().id == 1}">
			<c:if test="${not empty log.exception}">
			<tr>
				<td colspan="8" style="word-wrap:break-word;word-break:break-all;">
<%-- 					用户代理: ${log.userAgent}<br/> --%>
<%-- 					提交参数: ${fns:escapeHtml(log.params)} <br/> --%>
					异常信息: <br/>
					${fn:replace(fn:replace(fns:escapeHtml(log.exception), strEnter, '<br/>'), strTab, '&nbsp; &nbsp; ')}</td>
			</tr>
			</c:if>
			</c:if>
		</c:forEach>
		</tbody>
	</table>
	
	<!-- 分页代码 -->
	<table:page page="${page}"></table:page>
	</div>
	</div>
	</div>
</div>
</body>
</html>