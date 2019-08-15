<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>报价单选择器</title>
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
			return id+"_item_"+label;
		}
	</script>
</head>
<body class="gray-bg">
<div class="">
		<div class="ibox">
			
			<div class="ibox-content">
			<sys:message content="${message}"/>
				
				<!-- 查询条件 -->
				<c:if test="${empty crmQuote.customer.id}">
				<div class="row">
					<div class="col-sm-12">
						<form:form id="searchForm" modelAttribute="crmQuote" action="${ctx}/crm/crmQuote/selectList" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
								<div class="form-group"><span>单号：</span>
									<form:input path="no" htmlEscape="false" maxlength="30" class="form-control input-small"/>
								</div>
								<div class="form-group"><span>客户：</span>
									<sys:tableselect id="customer" name="customer.id" value="${crmQuote.customer.id}" labelName="customer.name" labelValue="${crmQuote.customer.name}" 
										title="客户" url="${ctx}/crm/crmCustomer/selectList" cssClass="form-control input-small" dataMsgRequired=""  allowClear="true" allowInput="false"/>
								</div>
								
								<%-- 
								
								<div class="form-group"><span>关联商机：</span>
									<form:input path="chance.id" htmlEscape="false" maxlength="30" class="form-control input-small"/>
								</div>
								<div class="form-group"><span>有效期至：</span>
									<input name="beginEnddate" type="text" readonly="readonly" maxlength="20" class="laydate-icon form-control input-small"
										value="<fmt:formatDate value="${crmQuote.beginEnddate}" pattern="yyyy-MM-dd"/>"
										onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/> - 
									<input name="endEnddate" type="text" readonly="readonly" maxlength="20" class="laydate-icon form-control input-small"
										value="<fmt:formatDate value="${crmQuote.endEnddate}" pattern="yyyy-MM-dd"/>"
										onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
								</div>
								
								--%>
								<div class="form-group"><span>状态：</span>
									<form:select path="status" class="form-control input-small">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('audit_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>负责人：</span>
									<sys:treeselect id="ownBy" name="ownBy.id" value="${crmQuote.ownBy.id}" labelName="ownBy.name" labelValue="${crmQuote.ownBy.name}"
										title="用户" url="/sys/office/treeData?type=3" cssClass="form-control input-small" allowClear="true" notAllowSelectParent="true"/>
								</div>
								<div class="form-group"><span>报价日期：</span>
									<div class="input-group date datepicker">
			                            <input name="beginStartdate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${crmQuote.beginStartdate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
			                            <span class="input-group-addon">
			                                    <span class="fa fa-calendar"></span>
			                            </span>
			                        </div>
			                         - 
			                        <div class="input-group" data-autoclose="true">
			                        	 <input name="endStartdate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${crmQuote.endStartdate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
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
				</c:if>
				
				
					
				<!-- 表格 -->
				<div class="table-responsive">
				<table id="contentTable" class="table table-bordered table-striped table-hover">
					<thead>
						<tr>
							<th><input type="checkbox" class="i-checks"></th>
							<th>单号</th>
							<th>客户</th>
							<th>联系人</th>
							<th>关联商机</th>
							
							<th class="sort-column a.amount">总金额</th>
							<th class="sort-column a.startdate">报价日期</th>
							<th class="sort-column a.status">状态</th>
							<th>负责人</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="crmQuote">
						<tr>
							<td><input type="checkbox" id="${crmQuote.id}" class="i-checks"></td>
							<td class="codelabel">${crmQuote.no}</td>
							<td>${crmQuote.customer.name}</td>
							<td>${crmQuote.contacter.name}</td>
							<td>${crmQuote.chance.name}</td>
							
							<td>${crmQuote.amount}</td>
							<td><fmt:formatDate value="${crmQuote.startdate}" pattern="yyyy-MM-dd"/></td>
							<td>${fns:getDictLabel(crmQuote.status, 'audit_status', '')}</td>
							<td>${crmQuote.ownBy.name}</td>
							<td>
								<shiro:hasPermission name="crm:crmQuote:view">
									<a href="#" onclick="openDialogView('查看报价单', '${ctx}/crm/crmQuote/view?id=${crmQuote.id}','800px', '500px')" class="btn btn-info btn-xs" title="查看"><i class="fa fa-search-plus"></i> 查看</a>
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