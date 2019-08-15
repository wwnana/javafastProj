<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>产品管理</title>
	<meta name="decorator" content="default"/>
	<style type="text/css">
		.ztree {overflow:auto;margin:0;_margin-top:10px;padding:10px 0 0 10px;}
	</style>
	<%@include file="/WEB-INF/views/include/treeview.jsp" %>
	
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
		
		//单选
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
		
		//多选
		function getSelectedItemMany(){
			var size = $("#contentTable tbody tr td input.i-checks:checked").size();
			if(size == 0 ){
				top.layer.alert('请至少选择一条数据!', {icon: 0, title:'警告'});
				return "-1";
			}
			var ids = new Array();
			$("#contentTable tbody tr td div.checked input").each(function(){ 
				ids.push($(this).parent().parent().parent());
			}); 
			return ids;
		}
		
		var setting = {data:{simpleData:{enable:true,idKey:"id",pIdKey:"pId",rootPId:'0'}},
				callback:{onClick:function(event, treeId, treeNode){
						var id = treeNode.id == '0' ? '' :treeNode.id;
						$("#productTypeId").val(id);
						$("#searchForm").submit();
						//$('#productContent').attr("src","${ctx}/wms/wmsProduct/list?productType.id="+id+"&productType.name="+treeNode.name);
					}
				}
			};
			
			function refreshTree(){
				$.getJSON("${ctx}/wms/wmsProductType/treeData",function(data){
					$.fn.zTree.init($("#ztree"), setting, data).expandAll(true);
				});
			}
			refreshTree();
			
			function refresh(){//刷新
				
				window.location="${ctx}/wms/wmsProduct/selectList";
			}
	</script>
</head>
<body class="hideScroll">
<div class="col-sm-2">
	<div class="">	
	<div id="ztree" class="ztree leftBox-content"></div>
	</div>
</div>
<div class="col-sm-10">
		<div class="ibox">
			
			<div class="ibox-content">
			<sys:message content="${message}"/>
				
				<!-- 查询条件 -->
				<div class="row">
					<div class="col-sm-12">
						<form:form id="searchForm" modelAttribute="wmsProduct" action="${ctx}/wms/wmsProduct/selectListForPur" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<form:hidden path="productType.id" id="productTypeId"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
								<div class="form-group"><span>产品编号：</span>
									<form:input path="no" htmlEscape="false" maxlength="30" class="form-control input-small"/>
								</div>
								<div class="form-group"><span>产品名称：</span>
									<form:input path="name" htmlEscape="false" maxlength="50" class="form-control input-small"/>
								</div>
								<%-- <div class="form-group"><span>产品条码：</span>
									<form:input path="code" htmlEscape="false" maxlength="50" class="form-control input-small"/>
								</div>
								--%>
								<div class="form-group"><span>规格：</span>
									<form:input path="spec" htmlEscape="false" maxlength="50" class="form-control input-small"/>
								</div>
								<div class="form-group">
									<button class="btn btn-white btn-sm" onclick="search()"><i class="fa fa-search"></i> 查询</button>
									<button class="btn btn-white btn-sm" onclick="resetSearch()"><i class="fa fa-refresh"></i> 重置</button>
								</div>
						</form:form>
					</div>
				</div>
				
					
				<!-- 表格 -->
				<div class="table-responsive">
				<table id="contentTable" class="table table-bordered table-striped table-hover">
					<thead>
						<tr>
							<th><input type="checkbox" class="i-checks"></th>
							<th>产品编号</th>
							<th>产品名称</th>							
							<th>规格</th>
							<th>单位</th>
							<th>成本价</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="wmsProduct">
						<tr>
							<td>
								<input type="checkbox" id="${wmsProduct.id}" class="i-checks">
							</td>
							<td>${wmsProduct.no}</td>
							<td class="codelabel">${wmsProduct.name}</td>
							<td>${wmsProduct.spec}</td>
							<td class="unitlabel">${fns:getDictLabel(wmsProduct.unitType, 'unit_type', '')}</td>
							<td class="pricelabel">${wmsProduct.costPrice}</td>
							<td>
								<shiro:hasPermission name="wms:wmsProduct:view">
									<a href="#" onclick="openDialogView('查看产品', '${ctx}/wms/wmsProduct/view?id=${wmsProduct.id}','800px', '500px')" class="btn btn-info btn-xs" title="查看"><i class="fa fa-search-plus"></i> 查看</a>
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