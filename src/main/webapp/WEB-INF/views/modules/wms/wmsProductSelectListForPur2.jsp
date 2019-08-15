<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>商品管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {

	    	$('#contentTable thead tr th input.i-checks').on('ifChecked', function(event){ //ifCreated 事件应该在插件初始化之前绑定 
	    		$('#contentTable tbody tr td input.i-checks').iCheck('check');
	    	});

	    	$('#contentTable thead tr th input.i-checks').on('ifUnchecked', function(event){ //ifCreated 事件应该在插件初始化之前绑定 
	    		$('#contentTable tbody tr td input.i-checks').iCheck('uncheck');
	    	});
		});
		
		function page(n,s){
			$("#pageNo").val(n);
			$("#pageSize").val(s);
			$("#searchForm").submit();
        	return false;
        }
		
		function getSelectedItem(){
			var size = $("#contentTable tbody tr td input.i-checks:checked").size();
			  if(size == 0 ){
					top.layer.alert('请至少选择一条数据!', {icon: 0, title:'警告'});
					return "-1";
				  }

			  if(size > 1 ){
					top.layer.alert('只能选择一条数据!', {icon: 0, title:'警告'});
					return "-1";
				  }
			    var id =  $("#contentTable tbody tr td input.i-checks:checkbox:checked").attr("id");
			    
				var label = $("#contentTable tbody tr td input.i-checks:checkbox:checked").parent().parent().parent().find(".codelabel").html();
				
				var unitType = $("#contentTable tbody tr td input.i-checks:checkbox:checked").parent().parent().parent().find(".unitlabel").html();
				
				var price = $("#contentTable tbody tr td input.i-checks:checkbox:checked").parent().parent().parent().find(".pricelabel").html();

				return id+"_item_"+label+"_item_"+unitType +"_item_"+price;
		}
	</script>
</head>
<body class="gray-bg">
<div class="">
		<div class="ibox">
			
			<div class="ibox-content">
			<sys:message content="${message}"/>
				
				<!-- 查询条件 -->
				<div class="row">
					<div class="col-sm-12">
						<form:form id="searchForm" modelAttribute="wmsProduct" action="${ctx}/wms/wmsProduct/selectListForPur" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
								<div class="form-group"><span>商品编号：</span>
									<form:input path="no" htmlEscape="false" maxlength="30" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>商品名称：</span>
									<form:input path="name" htmlEscape="false" maxlength="50" class="form-control input-medium"/>
								</div>
						</form:form>
						<br>
					</div>
				</div>
				<!-- 工具栏 -->
				<div class="row">
						
						<div class="col-sm-12">
						<div class="pull-left">
							
							
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
							<th><input type="checkbox" class="i-checks"></th>
							<th class="sort-column no">商品编号</th>
							<th class="sort-column name">商品名称</th>
							<th class="sort-column code">商品条码</th>
							<th class="sort-column t.name">商品分类</th>
							<th class="sort-column unit_type">基本单位</th>
							<th class="sort-column spec">规格</th>
							<th class="sort-column color">颜色</th>
							<th class="sort-column size">尺寸</th>
							<th class="sort-column batch_price">批发价</th>
							<th class="sort-column sale_price">标准价格</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="wmsProduct">
						<tr>
							<td>
								<input type="checkbox" id="${wmsProduct.id}" class="i-checks">
							</td>
							<td><a href="#" onclick="openDialogView('查看商品', '${ctx}/wms/wmsProduct/view?id=${wmsProduct.id}','800px', '500px')">
								${wmsProduct.no}
							</a></td>
							<td class="codelabel">${wmsProduct.name}</td>
							<td>
								${wmsProduct.code}
							</td>
							<td>
								${wmsProduct.productType.name}
							</td>
							<td class="unitlabel">${fns:getDictLabel(wmsProduct.unitType, 'unit_type', '')}</td>
							<td>
								${wmsProduct.spec}
							</td>
							<td>
								${wmsProduct.color}
							</td>
							<td>
								${wmsProduct.size}
							</td>
							<td class="pricelabel">${wmsProduct.batchPrice}</td>
							<td>${wmsProduct.salePrice}</td>
							<td>
								<shiro:hasPermission name="wms:wmsProduct:view">
									<a href="#" onclick="openDialogView('查看商品', '${ctx}/wms/wmsProduct/view?id=${wmsProduct.id}','800px', '500px')" class="btn btn-info btn-xs" title="查看"><i class="fa fa-search-plus"></i> 查看</a>
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