<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>销售线索列表</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
	</script>
</head>
<body class="">
	<div class="">
		<div class="">
			<div class="ibox-header">
				<div class="pull-left">			
					<a class="btn btn-link" href="${ctx}/crm/crmClue/list">待转化</a>
					<a class="btn btn-link" href="${ctx}/crm/crmClue/list?createBy.id=${fns:getUser().id}">我创建的</a>
					<a class="btn btn-link" href="${ctx}/crm/crmClue/list?ownBy.id=${fns:getUser().id}">我负责的</a>
					<a class="btn btn-link" href="${ctx}/crm/crmClue/list?isChange=1">已转化的</a>
					<%-- 
					<a class="btn btn-link" href="${ctx}/crm/crmClue/list?nextcontactDate=${fns:getDate('yyyy-MM-dd')}">今天联系</a>
					<a class="btn btn-link" href="${ctx}/crm/crmClue/list?nextcontactDate=${fns:getDayAfter(1)}">明天联系</a>
					<a class="btn btn-link" href="${ctx}/crm/crmClue/list?beginNextcontactDate=${fns:getDate('yyyy-MM-dd')}&endNextcontactDate=${fns:getDayAfter(7)}">7天内联系</a>
					--%>
					<a class="btn btn-link" href="${ctx}/crm/crmClue/list?beginCreateDate=${fns:getDate('yyyy-MM-dd')}&endCreateDate=${fns:getDayAfter(1)}">今日创建的</a>
					<a class="btn btn-link" href="${ctx}/crm/crmClue/list?beginCreateDate=${fns:getDayAfter(-7)}&endCreateDate=${fns:getDayAfter(1)}">7天内创建的</a>
					<a class="btn btn-link" href="${ctx}/crm/crmClue/list?beginCreateDate=${fns:getDayAfter(-30)}&endCreateDate=${fns:getDayAfter(1)}">30天内创建的</a>
				</div>
				<div class="pull-right">
					<div class="form-inline" style="padding-bottom: 0px;">					
						<div class="form-group">
                          	<form id="searchForm2" action="${ctx}/crm/crmClue/" method="post">
	                    	<div class="input-group">	
	                        	<input type="text" id="keywords" name="keywords" value="${crmClue.keywords}"  class=" form-control input-sm" placeholder="搜索线索名称"/>
	                            <div class="input-group-btn">
	                                <button id="btnSubmit" type="submit" class="btn btn-sm btn-white">
	                                    	<i class="fa fa-search"></i>
	                                </button>
	                                <button id="searchBtn" type="button" class="btn btn-white btn-sm" title="筛选 "><i class="fa fa-angle-double-down"></i> 筛选</button>      
	                            </div>
	                        </div>
	                        </form>
                        </div>
                        <div class="form-group">
                        	<%-- 
							<shiro:hasPermission name="crm:crmClue:edit">
							    <table:editRow url="${ctx}/crm/crmClue/form" title="销售线索" id="contentTable" pageModel="" width="1000px" height="80%"></table:editRow><!-- 编辑按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="crm:crmClue:del">
								<table:delRow url="${ctx}/crm/crmClue/deleteAll" id="contentTable"></table:delRow><!-- 删除按钮 -->
							</shiro:hasPermission>
							--%>
                        	<shiro:hasPermission name="crm:crmClue:add">
								<table:addRow url="${ctx}/crm/crmClue/form" title="销售线索" pageModel="" label="新建销售线索"></table:addRow><!-- 增加按钮 -->
							</shiro:hasPermission>
							<div class="btn-group">
		                        <button data-toggle="dropdown" class="btn btn-white btn-sm dropdown-toggle" aria-expanded="false">更多 <span class="caret"></span>
		                        </button>
		                        <ul class="dropdown-menu">
		                            <li>
		                            	<shiro:hasPermission name="crm:crmClue:import">
											<table:importExcel url="${ctx}/crm/crmClue/import"></table:importExcel><!-- 导入按钮 -->
										</shiro:hasPermission>
									</li>
									<li>
										<shiro:hasPermission name="crm:crmClue:export">
								       		<table:exportExcel url="${ctx}/crm/crmClue/export"></table:exportExcel><!-- 导出按钮 -->
								       	</shiro:hasPermission>
		                            </li>
		                            
		                        </ul>
		                    </div>
		                    
                        </div>
                    </div>
				</div>
			</div>
			<div class="ibox-content">
			<sys:message content="${message}"/>				
				<!-- 查询栏 -->
				<div class="row">
					<div class="col-sm-12">
						<form:form id="searchForm" modelAttribute="crmClue" action="${ctx}/crm/crmClue/" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<form:hidden path="isChange"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
							<table:searchRow></table:searchRow>
								<div class="form-group"><span>公司：</span>
									<form:input path="name" htmlEscape="false" maxlength="50" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>姓名：</span>
									<form:input path="contacterName" htmlEscape="false" maxlength="30" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>手机：</span>
									<form:input path="mobile" htmlEscape="false" maxlength="20" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>线索来源：</span>
									<form:select path="sourType" class="form-control input-medium">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('sour_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>市场活动：</span>
									<sys:tableselect id="crmMarket" name="crmMarket.id" value="${crmClue.crmMarket.id}" labelName="crmMarket.name" labelValue="${crmClue.crmMarket.name}" 
										title="市场活动" url="${ctx}/crm/crmMarket/selectList" cssClass="form-control input-small"  allowClear="true" allowInput="false"/>
								</div>
								<%-- 
								<div class="form-group"><span>下次联系：</span>
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
								<div class="form-group"><span>公海线索：</span>
									<form:select path="isPool" class="form-control input-medium">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								--%>
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
							
				<!-- 数据表格 -->
				<div class="table-responsive">
				<table id="contentTable" class="table table-bordered table-striped table-hover">
					<thead>
						<tr>
							<th width="30px"><input type="checkbox" class="i-checks"></th>
							<th style="min-width:250px;">公司</th>
							<th style="min-width:100px;width:100px;">姓名</th>
							<th style="min-width:100px;width:100px;">手机</th>
							<th style="min-width:100px;width:100px;">职务</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.sour_type">线索来源</th>
							<%-- 
							<th style="min-width:100px;width:100px;" class="sort-column a.industry_type">所属行业</th>
							<th class="sort-column a.nature_type">企业性质</th>
							<th class="sort-column a.scale_type">企业规模</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.nextcontact_date">下次联系</th>
							--%>
							<th style="min-width:100px;width:100px;" class="sort-column a.own_by">所有者</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.create_by">创建者</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.create_date">创建时间</th>
							
							<th style="min-width:100px;">转化状态</th>
							<th style="min-width:150px;width:150px;">操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="crmClue">
						<tr>
							<td><input type="checkbox" id="${crmClue.id}" class="i-checks"></td>
							<td>
								<a href="${ctx}/crm/crmClue/index?id=${crmClue.id}" title="查看">
								${crmClue.name}
							</a></td>
							<td>
								${crmClue.contacterName}
							</td>
							<td>
								${crmClue.mobile}
							</td>
							<td>
								${crmClue.jobType}
							</td>
							<td>
								${fns:getDictLabel(crmClue.sourType, 'sour_type', '')}
							</td>
							<%-- 
							<td>
								${fns:getDictLabel(crmClue.industryType, 'industry_type', '')}
							</td>
							<td>
								${fns:getDictLabel(crmClue.natureType, 'nature_type', '')}
							</td>
							<td>
								${fns:getDictLabel(crmClue.scaleType, 'scale_type', '')}
							</td>
							<td>
								<fmt:formatDate value="${crmClue.nextcontactDate}" pattern="yyyy-MM-dd"/>
							</td>
							--%>
							<td>
								${crmClue.ownBy.name}
							</td>
							<td>
								${crmClue.createBy.name}
							</td>
							<td>
								<fmt:formatDate value="${crmClue.createDate}" pattern="yyyy-MM-dd"/>
							</td>
							
							
							<td>
								<c:if test="${empty crmClue.crmCustomer.id}">
									<span class="text-danger">未转化</span>
								</c:if>
								<c:if test="${not empty crmClue.crmCustomer.id}">
									<a href="${ctx}/crm/crmCustomer/index?id=${crmClue.crmCustomer.id}" title="${crmClue.crmCustomer.name}">${crmClue.crmCustomer.name}</a>
								</c:if>
							</td>
							
							
							<td>
								
								<shiro:hasPermission name="crm:crmClue:edit">
			    					<a href="#" onclick="openDialog('修改销售线索', '${ctx}/crm/crmClue/form?id=${crmClue.id}','1000px', '80%')" class="" title="修改">修改</a>
								</shiro:hasPermission>
								
								<shiro:hasPermission name="crm:crmClue:del">
									<a href="${ctx}/crm/crmClue/delete?id=${crmClue.id}" onclick="return confirmx('确认要删除该销售线索吗？', this.href)" class="" title="删除">删除</a> 
								</shiro:hasPermission>
								
								<c:if test="${empty crmClue.crmCustomer.id}">
								<shiro:hasPermission name="crm:crmClue:edit">
			    					<a href="#" onclick="openDialog('转为客户', '${ctx}/crm/crmClue/toCustomerform?id=${crmClue.id}','1000px', '80%')" class="" title="转为客户">转为客户</a>
								</shiro:hasPermission>
								</c:if>
								
								
							</td>
						</tr>
					</c:forEach>
					</tbody>
				</table>
				</div>
				<table:page page="${page}"></table:page>
				
			</div>
		</div>
	</div>
</body>
</html>