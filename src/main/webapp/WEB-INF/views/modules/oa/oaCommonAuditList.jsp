<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>审批流程列表</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		function searchE(){
			var type = $("#auditType").val();
			$("#type").val(type);
			search();
		}
	</script>
</head>
<body class="">
	<div class="">
		<div class="">
			<div class="row dashboard-header gray-bg">
				<div class="pull-left">		
					<a class="btn btn-success btn-sm" href="${ctx}/oa/oaCommonAudit/add" title="新建审批"><i class="fa fa-plus"></i> 新建审批</a>
				</div>
				<div class="pull-right">		
					<form id="searchForm2" action="${ctx}/oa/oaCommonAudit/" method="post" class="pull-right form-inline" style="padding-bottom: 0;">
	                     <div class="form-group">
	                        <div class="input-group">
	                        	<input id="keywords" name="keywords" value="${oaCommonAudit.keywords }" class="form-control input-xlarge" placeholder="搜索标题、申请人姓名"/>
	                            <div class="input-group-btn">
	                                <button id="btnSubmit" type="submit" class="btn btn-sm btn-info">
	                                    	搜索
	                                </button>
	                            </div>
	                        </div>
	                    </div>
                        <div class="form-group">
                        	<button id="searchBtn" type="button" class="btn btn-white btn-sm" title="搜索"><i class="fa fa-search"></i> 高级搜索</button>
                        </div>
                    </form>
					
				</div>			
			</div>
			<div class="ibox-content">
			<sys:message content="${message}"/>	
				
				
				<!-- 查询条件 -->
				<div class="row">
					<div class="col-sm-12">
						<form:form id="searchForm" modelAttribute="oaCommonAudit" action="${ctx}/oa/oaCommonAudit/" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
							<table:searchRow></table:searchRow><!-- 查询栏 -->
							<form:hidden path="type"/>
								<%--
								<div class="form-group"><span>审批类型：</span>
									<form:select path="type" class="form-control input-small">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('common_audit_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								 --%>
								<div class="form-group"><span>标题：</span>
									<form:input path="title" htmlEscape="false" maxlength="50" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>部门：</span>
									<sys:treeselect id="office" name="office.id" value="${oaCommonAudit.office.id}" labelName="office.name" labelValue="${oaCommonAudit.office.name}"
										title="部门" url="/sys/office/treeData?type=2" cssClass="form-control input-small" allowClear="true" notAllowSelectParent="true"/>
								</div>
								<div class="form-group"><span>申请人：</span>
									<sys:treeselect id="createBy" name="createBy.id" value="${oaCommonAudit.createBy.id}" labelName="createBy.name" labelValue="${oaCommonAudit.createBy.name}"
										title="用户" url="/sys/office/treeData?type=3" cssClass="form-control input-small" allowClear="true" notAllowSelectParent="true"/>
								</div>
								<div class="form-group"><span>申请时间：</span>
									<div class="input-group date datepicker">
				                     	<input name="beginCreateDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${oaCommonAudit.beginCreateDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
				                     	<span class="input-group-addon">
				                             <span class="fa fa-calendar"></span>
				                     	</span>
							        </div>
							         - 
							        <div class="input-group date datepicker">
				                     	<input name="endCreateDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${oaCommonAudit.endCreateDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
				                     	<span class="input-group-addon">
				                             <span class="fa fa-calendar"></span>
				                     	</span>
							        </div>
								</div>
								<div class="form-group"><span>状态：</span>
									<form:select path="status" class="form-control input-small">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('common_audit_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group">
									<button class="btn btn-white btn-sm " onclick="search()"><i class="fa fa-search"></i> 查询</button>
									<button class="btn btn-white btn-sm " onclick="resetSearch()"><i class="fa fa-refresh"></i> 重置</button>
								</div>
						</form:form>
					</div>
				</div>
				
				<div class="row m-b-sm">
					<div class="col-sm-12">
						<div class="pull-left">	
							<select id="auditType" name="auditType" class="form-control input-mini" onchange="searchE()">
								<option value="">全部</option>
								<c:forEach items="${fns:getDictList('common_audit_type')}" var="dict">
									<option value="${dict.value }" <c:if test='${dict.value == oaCommonAudit.type}'>selected="selected"</c:if> >${dict.label }</option>
								</c:forEach>
							</select>		
							<a class="btn btn-white btn-sm" href="${ctx}/oa/oaCommonAudit/list?createBy.id=${fns:getUser().id}">我申请的</a>
							<a class="btn btn-white btn-sm" href="${ctx}/oa/oaCommonAudit/list?currentBy.id=${fns:getUser().id}&status=1">待我审批的</a>
							<a class="btn btn-white btn-sm" href="${ctx}/oa/oaCommonAudit/list?isSelfRead=1">抄送给我的</a>
							<a class="btn btn-white btn-sm" href="${ctx}/oa/oaCommonAudit/list?status=1">审批中的</a>
							<a class="btn btn-white btn-sm" href="${ctx}/oa/oaCommonAudit/list?status=2">已归档的</a>
							<a class="btn btn-white btn-sm" href="${ctx}/oa/oaCommonAudit/list?status=3">已驳回的</a>
						</div>
						<div class="pull-right">
							<shiro:hasPermission name="oa:oaCommonFlow:list">
								<a class="btn btn-white btn-sm" href="${ctx}/oa/oaCommonFlow/" title="流程设置"><i class="fa fa-cog"></i> 流程设置</a>
							</shiro:hasPermission>
							<shiro:hasPermission name="oa:oaCommonAudit:export">
								<table:exportExcel url="${ctx}/oa/oaCommonAudit/export"></table:exportExcel><!-- 导出按钮 -->
							</shiro:hasPermission>
							<button class="btn btn-white btn-sm" data-toggle="tooltip" data-placement="left" onclick="sortOrRefresh()" title="刷新列表"><i class="fa fa-refresh"></i> 刷新</button>
						</div>
					</div>
				</div>
				
				<!-- 表格 -->
				<div class="table-responsive">
				<table id="contentTable" class="table table-bordered table-striped table-hover">
					<thead>
						<tr>
							<%-- <th><input type="checkbox" class="i-checks"></th>--%>
							<th width="100px" class="sort-column a.type">审批类型</th>
							<th>标题</th>
							
							<c:if test="${oaCommonAudit.type == 1}">
								<th>请假类型</th>
								<th>请假时长(天)</th>
								<th>请假开始时间</th>
							</c:if>
							<c:if test="${oaCommonAudit.type == 2}">
								<th>报销总额</th>
							</c:if>
							<c:if test="${oaCommonAudit.type == 3}">
								<th>出发地</th>
								<th>出差城市</th>
								<th>开始时间</th>
								<th>结束时间</th>
								<th>预算金额</th>
								<th>预支金额</th>
							</c:if>
							<c:if test="${oaCommonAudit.type == 4}">
								<th>借款总额</th>
								<th>借款时间</th>
							</c:if>
							<c:if test="${oaCommonAudit.type == 5}">
								<th>加班类型</th>
								<th>开始时间</th>
								<th>结束时间</th>							
								<th>加班时长(天)</th>
							</c:if>
							
							<th width="100px">下一审批人</th>
							<th width="100px" class="sort-column a.status">状态</th>
							<th>部门</th>
							<th width="100px">申请人</th>
							<th class="sort-column a.create_date" width="160px">申请时间</th>
							<th width="130px">操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="oaAudit">
						<tr>
							<%--<td><input type="checkbox" id="${oaAudit.id}" class="i-checks"></td>--%>
							<td>
								
								${fns:getDictLabel(oaAudit.type, 'common_audit_type', '')}
							</td>
							<td>
								
								<a href="${ctx}/oa/oaCommonAudit/view?id=${oaAudit.id}&type=${oaAudit.type}"  <c:if test='${oaAudit.readFlag == 0}'>style="font-weight: 700;"</c:if>>${oaAudit.title}</a>
							</td>
							
							<c:if test="${oaCommonAudit.type == 1}">
								<td>${fns:getDictLabel(oaAudit.oaCommonLeave.leaveType, 'leave_type', '')}</td>
								<td>${oaAudit.oaCommonLeave.daysNum}</td>
								<td><fmt:formatDate value="${oaAudit.oaCommonLeave.startTime}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
							</c:if>
							<c:if test="${oaCommonAudit.type == 2}">
								<td>${oaAudit.oaCommonExpense.amount}</td>
							</c:if>
							<c:if test="${oaCommonAudit.type == 3}">
								<td>${oaAudit.oaCommonTravel.startAddress}</td>
								<td>${oaAudit.oaCommonTravel.destAddress}</td>
								<td><fmt:formatDate value="${oaAudit.oaCommonTravel.startTime}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
								<td><fmt:formatDate value="${oaAudit.oaCommonTravel.endTime}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
								<td>${oaAudit.oaCommonTravel.budgetAmt}</td>
								<td>${oaAudit.oaCommonTravel.advanceAmt}</td>
							</c:if>
							<c:if test="${oaCommonAudit.type == 4}">
								<td>${oaAudit.oaCommonBorrow.oaCommonAudit.createBy.name}</td>
								<td>${oaAudit.oaCommonBorrow.amount}</td>
							</c:if>
							<c:if test="${oaCommonAudit.type == 5}">
								<td>${fns:getDictLabel(oaCommonExtra.extraType, 'extra_type', '')}</td>
								<td><fmt:formatDate value="${oaCommonExtra.startTime}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
								<td><fmt:formatDate value="${oaCommonExtra.endTime}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
								<td>${oaCommonExtra.daysNum}</td>
							</c:if>
							
							<td>
								${oaAudit.currentBy.name}
							</td>
							<td>
								<c:if test="${oaAudit.status == 0}"><span class="">${fns:getDictLabel(oaAudit.status, 'common_audit_status', '')}</span></c:if>
								<c:if test="${oaAudit.status == 1}"><span class="text-danger">${fns:getDictLabel(oaAudit.status, 'common_audit_status', '')}</span></c:if>
								<c:if test="${oaAudit.status == 2}"><span class="text-success">${fns:getDictLabel(oaAudit.status, 'common_audit_status', '')}</span></c:if>
								<c:if test="${oaAudit.status == 3}"><span class="text-warning">${fns:getDictLabel(oaAudit.status, 'common_audit_status', '')}</span></c:if>
							</td>
							<td>
								${oaAudit.office.name}
							</td>
							<td>
								${oaAudit.createBy.name}
							</td>
							<td>
								<fmt:formatDate value="${oaAudit.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</td>
							<td>
								<a href="${ctx}/oa/oaCommonAudit/view?id=${oaAudit.id}" class="" title="查看" >查看</a>
								
								
								<c:if test="${fns:getUser().id == oaAudit.createBy.id && oaAudit.status == 0}">
			    					<a href="${ctx}/oa/oaCommonAudit/form?id=${oaAudit.id}" class="" title="修改" >修改</a>
								</c:if>
								<c:if test="${fns:getUser().id == oaAudit.createBy.id && oaAudit.status == 1}">
									<a href="${ctx}/oa/oaCommonAudit/delete?id=${oaAudit.id}" onclick="return confirmx('确认要撤销该审批流程吗？', this.href)" class="" title="删除">撤销</a> 
								</c:if>
								<c:if test="${fns:getUser().id == oaAudit.currentBy.id && oaAudit.status == 1}">
									<a href="${ctx}/oa/oaCommonAudit/view?id=${oaAudit.id}" class="" title="审批" >审批</a>
								</c:if>
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