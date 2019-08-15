<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>销售线索列表选择器</title>
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
<body class="">
	<div class="">
		<div class="">
			<div class="ibox-content">
			<sys:message content="${message}"/>
				<!-- 查询栏 -->
				<div class="row">
					<div class="col-sm-12">
						<form:form id="searchForm" modelAttribute="crmClue" action="${ctx}/crm/crmClue/selectList" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
								<div class="form-group"><span>公司：</span>
									<form:input path="name" htmlEscape="false" maxlength="50" class="form-control input-small"/>
								</div>
								<div class="form-group"><span>联系人姓名：</span>
									<form:input path="contacterName" htmlEscape="false" maxlength="30" class="form-control input-small"/>
								</div>
								<div class="form-group"><span>联系手机：</span>
									<form:input path="mobile" htmlEscape="false" maxlength="20" class="form-control input-small"/>
								</div>
								<div class="form-group"><span>线索来源：</span>
									<form:select path="sourType" class="form-control input-small">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('sour_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>省：</span>
									<form:select path="province" class="form-control input-small">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>下次联系时间：</span>
									<div class="input-group date datepicker">
				                     	<input name="beginNextcontactDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${crmClue.beginNextcontactDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
				                     	<span class="input-group-addon">
				                             <span class="fa fa-calendar"></span>
				                     	</span>
							        </div>
							         - 
							        <div class="input-group date datepicker">
				                     	<input name="endNextcontactDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${crmClue.endNextcontactDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
				                     	<span class="input-group-addon">
				                             <span class="fa fa-calendar"></span>
				                     	</span>
							        </div>
								</div>
								<div class="form-group"><span>是否为公海：</span>
									<form:select path="isPool" class="form-control input-small">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>所有者：</span>
									<sys:treeselect id="ownBy" name="ownBy.id" value="${crmClue.ownBy.id}" labelName="ownBy.name" labelValue="${crmClue.ownBy.name}"
										title="用户" url="/sys/office/treeData?type=3" cssClass="form-control input-small" allowClear="true" notAllowSelectParent="true"/>
								</div>
								<div class="form-group"><span>创建者：</span>
									<sys:treeselect id="createBy" name="createBy.id" value="${crmClue.createBy.id}" labelName="createBy.name" labelValue="${crmClue.createBy.name}"
										title="用户" url="/sys/office/treeData?type=3" cssClass="form-control input-small" allowClear="true" notAllowSelectParent="true"/>
								</div>
								<div class="form-group"><span>创建时间：</span>
									<div class="input-group date datepicker">
				                     	<input name="beginCreateDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${crmClue.beginCreateDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
				                     	<span class="input-group-addon">
				                             <span class="fa fa-calendar"></span>
				                     	</span>
							        </div>
							         - 
							        <div class="input-group date datepicker">
				                     	<input name="endCreateDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${crmClue.endCreateDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
				                     	<span class="input-group-addon">
				                             <span class="fa fa-calendar"></span>
				                     	</span>
							        </div>
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
				<table id="contentTable" class="table table-bordered table-striped table-hover">
					<thead>
						<tr>
							<th><input type="checkbox" class="i-checks"></th>
							<th class="sort-column a.name">公司</th>
							<th class="sort-column a.contacter_name">联系人姓名</th>
							<th class="sort-column a.sex">性别</th>
							<th class="sort-column a.mobile">联系手机</th>
							<th class="sort-column a.job_type">职务</th>
							<th class="sort-column a.sour_type">线索来源</th>
							<th class="sort-column a.industry_type">所属行业</th>
							<th class="sort-column a.nature_type">企业性质</th>
							<th class="sort-column a.scale_type">企业规模</th>
							<th class="sort-column a.province">省</th>
							<th class="sort-column a.nextcontact_date">下次联系时间</th>
							<th class="sort-column a.own_by">所有者</th>
							<th class="sort-column a.create_by">创建者</th>
							<th class="sort-column a.create_date">创建时间</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="crmClue">
						<tr>
							<td><input type="checkbox" id="${crmClue.id}" class="i-checks"></td>
							<td class="codelabel">${crmClue.name}</td>
							<td>${crmClue.contacterName}</td>
							<td>${fns:getDictLabel(crmClue.sex, 'sex', '')}</td>
							<td>${crmClue.mobile}</td>
							<td>${crmClue.jobType}</td>
							<td>${fns:getDictLabel(crmClue.sourType, 'sour_type', '')}</td>
							<td>${fns:getDictLabel(crmClue.industryType, 'industry_type', '')}</td>
							<td>${fns:getDictLabel(crmClue.natureType, 'nature_type', '')}</td>
							<td>${fns:getDictLabel(crmClue.scaleType, 'scale_type', '')}</td>
							<td>${fns:getDictLabel(crmClue.province, '', '')}</td>
							<td><fmt:formatDate value="${crmClue.nextcontactDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
							<td>${crmClue.ownBy.name}</td>
							<td>${crmClue.createBy.name}</td>
							<td><fmt:formatDate value="${crmClue.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
							<td>
								<shiro:hasPermission name="crm:crmClue:view">
									<a href="#" onclick="openDialogView('查看销售线索', '${ctx}/crm/crmClue/index?id=${crmClue.id}','800px', '500px')" class="btn btn-info btn-xs" title="查看"><i class="fa fa-search-plus"></i> 查看</a>
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