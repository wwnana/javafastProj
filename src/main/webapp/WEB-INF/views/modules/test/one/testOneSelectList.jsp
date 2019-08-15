<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>商品信息选择器</title>
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
	</script>
</head>
<body class="">
<div class=" ">
		<div class="">
			
			<div class="ibox-content">
			<sys:message content="${message}"/>
				
				<!-- 查询条件 -->
				<div class="row">
					<div class="col-sm-12">
						<form:form id="searchForm" modelAttribute="testOne" action="${ctx}/test/one/testOne/selectList" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
								<div class="form-group"><span>商品分类：</span>
									<sys:treeselect id="testTree" name="testTree.id" value="${testOne.testTree.id}" labelName="testTree.name" labelValue="${testOne.testTree.name}"
										title="商品分类" url="/test/tree/testTree/treeData" extId="${testTree.id}" cssClass="form-control input-small" allowClear="true"/>
								</div>
								<div class="form-group"><span>商品编码：</span>
									<form:input path="no" htmlEscape="false" maxlength="30" class="form-control input-small"/>
								</div>
								<div class="form-group"><span>商品名称：</span>
									<form:input path="name" htmlEscape="false" maxlength="50" class="form-control input-small"/>
								</div>
								<div class="form-group">
									<button class="btn btn-white btn-sm " onclick="search()"><i class="fa fa-search"></i> 查询</button>
									<button class="btn btn-white btn-sm " onclick="resetSearch()"><i class="fa fa-refresh"></i> 重置</button>
								</div>
						</form:form>
					</div>
				</div>
				
					
				<!-- 表格 -->
				<div class="table-responsive"> 
				<table id="contentTable" class="table table-striped table-bordered table-hover table-condensed">
					<thead>
						<tr>
							<th><input type="checkbox" class="i-checks"></th>
							<th>缩略图</th>
							<th class="sort-column a.no">商品编码</th>
							<th class="sort-column a.name">商品名称</th>
							<th class="sort-column r.name">商品分类</th>
							<th class="sort-column a.unit_type">基本单位</th>
							<th class="sort-column a.spec">规格</th>
							<th class="sort-column a.color">颜色</th>
							<th class="sort-column a.size">尺寸</th>							
							<th class="sort-column a.sale_price">零售价</th>
							<th class="sort-column a.batch_price">批发价</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="testOne">
						<tr>
							<td><input type="checkbox" id="${testOne.id}" class="i-checks"></td>
							<td>
								<img alt="" src="${testOne.productImg}" style="height: 30px;width: 30px;">
							</td>
							<td>${testOne.no}</td>
							<td class="codelabel">${testOne.name}</td>
							<td>${testOne.testTree.name}</td>
							<td class="unitlabel">${fns:getDictLabel(testOne.unitType, 'unit_type', '')}</td>
							<td>${testOne.spec}</td>
							<td>${testOne.color}</td>
							<td>${testOne.size}</td>
							<td class="pricelabel">${testOne.salePrice}</td>
							<td>${testOne.batchPrice}</td>
							<td>
								<shiro:hasPermission name="test:one:testOne:view">
									<a href="#" onclick="openDialogView('查看商品信息', '${ctx}/test/one/testOne/view?id=${testOne.id}','800px', '500px')" class="btn btn-info btn-xs" title="查看"><i class="fa fa-search-plus"></i> 查看</a>
								</shiro:hasPermission>
							</td>
						</tr>
					</c:forEach>
					</tbody>
				</table>
				<table:page page="${page}"></table:page>
				<br/>
				</div>
			</div>
		</div>
	</div>
</body>
</html>