<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>入库单管理</title>
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
						<form:form id="searchForm" modelAttribute="wmsInstock" action="${ctx}/wms/wmsInstock/selectList" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
								<div class="form-group"><span>入库单号：</span>
									<form:input path="no" htmlEscape="false" maxlength="30" class="form-control input-small"/>
								</div>
								<div class="form-group"><span>关联采购单号：</span>
									<sys:tableselect id="purchase" name="purchase.id" value="${wmsInstock.purchase.id}" labelName="purchase.name" labelValue="${wmsInstock.purchase.name}" 
										title="采购单" url="${ctx}/wms/wmsPurchase/selectList" cssClass="form-control input-small" dataMsgRequired=""  allowClear="false" allowInput="false"/>
								</div>
								<div class="form-group"><span>入库仓库：</span>
									<sys:tableselect id="warehouse" name="warehouse.id" value="${wmsInstock.warehouse.id}" labelName="warehouse.name" labelValue="${wmsInstock.warehouse.name}" 
										title="供应商" url="${ctx}/wms/wmsWarehouse/selectList" cssClass="form-control input-small" dataMsgRequired=""  allowClear="false" allowInput="false"/>
								</div>
								<div class="form-group"><span>审核状态：</span>
									<form:select path="status" class="form-control input-small">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('audit_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>经办人：</span>
									<sys:treeselect id="dealBy" name="dealBy.id" value="${wmsInstock.dealBy.id}" labelName="dealBy.name" labelValue="${wmsInstock.dealBy.name}"
										title="用户" url="/sys/office/treeData?type=3" cssClass="form-control input-small" allowClear="true" notAllowSelectParent="true"/>
								</div>
								<div class="form-group"><span>业务日期：</span>
									<div class="input-group date datepicker">
			                            <input name="beginDealDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${wmsInstock.beginDealDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
			                            <span class="input-group-addon">
			                                    <span class="fa fa-calendar"></span>
			                            </span>
			                        </div>
			                         - 
			                        <div class="input-group" data-autoclose="true">
			                        	 <input name="endDealDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${wmsInstock.endDealDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
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
							<th>单号</th>
							<th>关联采购单号</th>
							<th>供应商</th>
							<th>内容</th>
							<th>总数量</th>
							
							<th class="sort-column w.name">入库仓库</th>
							<th class="sort-column status">审核状态</th>
							<th class="sort-column a.deal_by">经办人</th>
							<th class="sort-column a.deal_date">业务日期</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="wmsInstock">
						<tr>
							<td>
								<input type="checkbox" id="${wmsInstock.id}" class="i-checks">
							</td>
							<td class="codelabel">${wmsInstock.no}</td>
							<td>
								${wmsInstock.purchase.no}
							</td>
							<td>
								${wmsInstock.supplier.name}
							</td>
							<td>
								${fns:abbr(wmsInstock.content,30)}
							</td>
							<td>
								${wmsInstock.num}
							</td>
							
							<td>
								${wmsInstock.warehouse.name}
							</td>
							<td>
								${fns:getDictLabel(wmsInstock.status, 'audit_status', '')}
							</td>
							<td>
								${wmsInstock.dealBy.name}
							</td>
							<td>
								<fmt:formatDate value="${wmsInstock.dealDate}" pattern="yyyy-MM-dd"/>
							</td>
							

							<td>
								<shiro:hasPermission name="wms:wmsInstock:view">
									<a href="#" onclick="openDialogView('查看入库单', '${ctx}/wms/wmsInstock/view?id=${wmsInstock.id}','800px', '500px')" class="btn btn-info btn-xs" title="查看"><i class="fa fa-search-plus"></i> 查看</a>
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