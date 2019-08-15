<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>出库单管理</title>
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

				return id+"_item_"+label+"_item_"+unitType;
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
						<form:form id="searchForm" modelAttribute="wmsOutstock" action="${ctx}/wms/wmsOutstock/selectList" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
								<div class="form-group"><span>出库单类型：</span>
									<form:select path="outstockType" class="form-control input-small">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('outstock_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>单号：</span>
									<form:input path="no" htmlEscape="false" maxlength="30" class="form-control input-small"/>
								</div>
								<div class="form-group"><span>关联订单号：</span>
									<sys:tableselect id="order" name="order.id" value="${wmsOutstock.order.id}" labelName="order.name" labelValue="${wmsOutstock.order.name}" 
								title="订单" url="${ctx}/om/omOrder/selectList" cssClass="form-control input-small" dataMsgRequired=""  allowClear="false" allowInput="false"/>
								
								</div>
								<div class="form-group"><span>供应商：</span>
									<sys:tableselect id="supplier" name="supplier.id" value="${wmsOutstock.supplier.id}" labelName="supplier.name" labelValue="${wmsOutstock.supplier.name}" 
										title="供应商" url="${ctx}/wms/wmsSupplier/selectList" cssClass="form-control input-small" dataMsgRequired=""  allowClear="false" allowInput="false"/>
								</div>
								<div class="form-group"><span>出库仓库：</span>
									<sys:tableselect id="warehouse" name="warehouse.id" value="${wmsOutstock.warehouse.id}" labelName="warehouse.name" labelValue="${wmsOutstock.warehouse.name}" 
									title="出库仓库" url="${ctx}/wms/wmsWarehouse/selectList" cssClass="form-control input-small" dataMsgRequired=""  allowClear="false" allowInput="false"/>
								</div>
								<div class="form-group"><span>审核状态：</span>
									<form:select path="status" class="form-control input-small">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('audit_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>经办人：</span>
									<sys:treeselect id="dealBy" name="dealBy.id" value="${wmsOutstock.dealBy.id}" labelName="dealBy.name" labelValue="${wmsOutstock.dealBy.name}"
										title="用户" url="/sys/office/treeData?type=3" cssClass="form-control input-small" allowClear="true" notAllowSelectParent="true"/>
								</div>
								<div class="form-group"><span>业务日期：</span>
									<div class="input-group date datepicker">
			                            <input name="beginDealDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${wmsOutstock.beginDealDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
			                            <span class="input-group-addon">
			                                    <span class="fa fa-calendar"></span>
			                            </span>
			                        </div>
			                         - 
			                        <div class="input-group" data-autoclose="true">
			                        	 <input name="endDealDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${wmsOutstock.endDealDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
			                            <span class="input-group-addon">
			                                    <span class="fa fa-calendar"></span>
			                            </span>
			                        </div>
								</div>
						</form:form>
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
							<th class="sort-column outstock_type">出库单类型</th>
							<th>单号</th>
							<th>关联订单号</th>
							<th>供应商</th>
							<th>内容</th>
							<th>数量</th>
							<th class="sort-column w.name">出库仓库</th>
							<th class="sort-column status">审核状态</th>
							<th class="sort-column a.deal_by">经办人</th>
							<th class="sort-column a.deal_date">业务日期</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="wmsOutstock">
						<tr>
							<td>
								<input type="checkbox" id="${wmsOutstock.id}" class="i-checks">
							</td>
							<td>
								${fns:getDictLabel(wmsOutstock.outstockType, 'outstock_type', '')}
							</td>
							<td class="codelabel">${wmsOutstock.no}</td>
							
							<td>
								${wmsOutstock.order.no}
							</td>
							<td>
								${wmsOutstock.supplier.name}
							</td>
							<td>
								${fns:abbr(wmsOutstock.content,30)}
							</td>
							<td>
								${wmsOutstock.num}
							</td>
							<td>
								${wmsOutstock.warehouse.name}
							</td>
							<td>
								${fns:getDictLabel(wmsOutstock.status, 'audit_status', '')}
							</td>
							<td>
								${wmsOutstock.dealBy.name}
							</td>
							<td>
								<fmt:formatDate value="${wmsOutstock.dealDate}" pattern="yyyy-MM-dd"/>
							</td>

							<td>
								<shiro:hasPermission name="wms:wmsOutstock:view">
									<a href="#" onclick="openDialogView('查看出库单', '${ctx}/wms/wmsOutstock/view?id=${wmsOutstock.id}','800px', '500px')" class="btn btn-info btn-xs" title="查看"><i class="fa fa-search-plus"></i> 查看</a>
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