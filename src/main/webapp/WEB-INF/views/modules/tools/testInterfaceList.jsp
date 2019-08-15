<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>接口管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
		});
		
		function test(id){
            if(!id){

            	var size = $("#contentTable tbody tr td input.i-checks:checked").size();
      		  	 if(size == 0 ){
      				top.layer.alert('请至少选择一条数据!', {icon: 0, title:'警告'});
      				return;
      			  }
      		  	if(size > 1 ){
      				top.layer.alert('只能选择一条数据!', {icon: 0, title:'警告'});
      				return;
      			  }
      		    id =  $("#contentTable tbody tr td input.i-checks:checkbox:checked").attr("id");

            }
        	top.openTab("${ctx}/tools/testInterface/test?id="+id,"接口测试", false);
        }
	</script>
	<style type="text/css"> 
	.AutoNewline 
	{ 
	  Word-break: break-all;/*必须*/ 
	} 
	</style>
</head>
<body class="gray-bg">
	<div class="wrapper-content">
	<div class="ibox">
	<div class="ibox-title">
		<h5>接口列表 </h5>
		<div class="ibox-tools">
			<a class="collapse-link">
				<i class="fa fa-chevron-up"></i>
			</a>
			<a class="dropdown-toggle" data-toggle="dropdown" href="#">
				<i class="fa fa-wrench"></i>
			</a>
			<ul class="dropdown-menu dropdown-user">
				<li><a href="#">选项1</a>
				</li>
				<li><a href="#">选项2</a>
				</li>
			</ul>
			<a class="close-link">
				<i class="fa fa-times"></i>
			</a>
		</div>
	</div>
    
    <div class="ibox-content">
   		<c:if test="${empty params}">
    			<div class="alert alert-success alert-dismissable">
                    <button aria-hidden="true" data-dismiss="alert" class="close" type="button">×</button>
                   	您还未获得API接口授权，请联系平台方进行授权
                </div>
        </c:if>
	<sys:message content="${message}"/>
	
	<!--查询条件-->
	<div class="row">
	<div class="col-sm-12">
	<form:form id="searchForm" modelAttribute="testInterface" action="${ctx}/tools/testInterface/" method="post" class="form-inline">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
		<div class="form-group">
			<span>接口名称：</span>
				<form:input path="name" htmlEscape="false" maxlength="1024"  class=" form-control input-sm"/>
			<span>接口类型：</span>
				<form:select path="type"  class="form-control m-b">
					<form:option value="" label=""/>
					<form:options items="${fns:getDictList('interface_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
		 </div>	
	</form:form>
	</div>
	</div>
	
	<!-- 工具栏 -->
	<div class="row">
	<div class="col-sm-12 m-b-sm">
		<div class="pull-left">
			<shiro:hasPermission name="tools:testInterface:add">
				<table:addRow url="${ctx}/tools/testInterface/form" title="接口" width="1000px" height="80%"></table:addRow><!-- 增加按钮 -->
			</shiro:hasPermission>
			<shiro:hasPermission name="tools:testInterface:edit">
			    <table:editRow url="${ctx}/tools/testInterface/form" title="接口" id="contentTable"></table:editRow><!-- 编辑按钮 -->
			</shiro:hasPermission>
			<shiro:hasPermission name="tools:testInterface:del">
				<table:delRow url="${ctx}/tools/testInterface/deleteAll" id="contentTable"></table:delRow><!-- 删除按钮 -->
			</shiro:hasPermission>
			<shiro:hasPermission name="tools:testInterface:import">
				<table:importExcel url="${ctx}/tools/testInterface/import"></table:importExcel><!-- 导入按钮 -->
			</shiro:hasPermission>
			<shiro:hasPermission name="tools:testInterface:export">
	       		<table:exportExcel url="${ctx}/tools/testInterface/export"></table:exportExcel><!-- 导出按钮 -->
	       	</shiro:hasPermission>
	       
	       <button class="btn btn-white btn-sm " data-toggle="tooltip" data-placement="left" onclick="sortOrRefresh()" title="刷新"><i class="glyphicon glyphicon-repeat"></i> 刷新</button>
		
			</div>
		<div class="pull-right">
			<button  class="btn btn-success btn-rounded btn-outline btn-sm " onclick="search()" ><i class="fa fa-search"></i> 查询</button>
			<button  class="btn btn-success btn-rounded btn-outline btn-sm " onclick="resetSearch()" ><i class="fa fa-refresh"></i> 重置</button>
		</div>
	</div>
	</div>
	
	<!-- 表格 -->
				<div class="table-responsive">
				<table id="contentTable" class="table table-bordered table-striped table-hover">
		<thead>
			<tr>
				<th> <input type="checkbox" class="i-checks"></th>
				<th  width="80px"  class="nowrap sort-column name">接口名称</th>
				<th  width="80px"  class="nowrap sort-column type">接口类型</th>
				<th  class="nowrap sort-column url">请求URL</th>
				<th  class="nowrap sort-column body">请求body</th>
				<th  width="110px" class="nowrap sort-column successmsg">成功时返回消息</th>
				<th  width="110px" class="nowrap sort-column errormsg">失败时返回消息</th>
				
				<th  width="210px">操作</th>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="testInterface">
			<tr>
				<td> <input type="checkbox" id="${testInterface.id}" class="i-checks"></td>
				<td  class="AutoNewline"><a  href="#" onclick="openDialogView('查看接口', '${ctx}/tools/testInterface/view?id=${testInterface.id}','1000px', '80%')">
					${testInterface.name}
				</a></td>
				<td  class="AutoNewline">
					${fns:getDictLabel(testInterface.type, 'interface_type', '')}
				</td>
				<td  class="AutoNewline">
					${testInterface.url}
				</td>
				<td class="AutoNewline">
					${testInterface.body}
				</td>
				<td  class="AutoNewline">
					${testInterface.successmsg}
				</td>
				<td  class="AutoNewline">
					${testInterface.errormsg}
				</td>
				
				<td>
					
					<shiro:hasPermission name="tools:testInterface:view">
						<a href="#" onclick="openDialogView('查看接口', '${ctx}/tools/testInterface/view?id=${testInterface.id}','1000px', '80%')" class="btn btn-info btn-xs" ><i class="fa fa-search-plus"></i> 查看</a>
					</shiro:hasPermission>
					<shiro:hasPermission name="tools:testInterface:edit">
    					<a href="#" onclick="openDialog('修改接口', '${ctx}/tools/testInterface/form?id=${testInterface.id}','1000px', '80%')" class="btn btn-success btn-xs" ><i class="fa fa-edit"></i> 修改</a>
    				</shiro:hasPermission>
    				<shiro:hasPermission name="tools:testInterface:del">
						<a href="${ctx}/tools/testInterface/delete?id=${testInterface.id}" onclick="return confirmx('确认要删除该接口吗？', this.href)"   class="btn btn-danger btn-xs"><i class="fa fa-trash"></i> 删除</a>
					</shiro:hasPermission>
					
					<shiro:hasPermission name="tools:testInterface:test">
						<a href="${ctx}/tools/testInterface/test?id=${testInterface.id}" class="btn btn-info btn-xs" ><i class="fa fa-check"></i> 测试</a>
					</shiro:hasPermission>
				</td>
			</tr>
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