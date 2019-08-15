<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>产品管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">

	</script>
</head>
<body class="">
	<div class="">
		<div class="">
			<div class="row dashboard-header gray-bg">
				<h5>产品列表</h5>
				<div class="pull-right">	
					<div class="form-inline" style="padding-bottom: 0px;">					
						
						<div class="form-group">
                          	<form id="searchForm2" action="${ctx}/wms/wmsProduct/" method="post">
	                    	<div class="input-group">	
	                        	<input type="text" id="keywords" name="keywords" value="${wmsProduct.keywords}"  class=" form-control input-sm" placeholder="搜索产品名称"/>
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
							<shiro:hasPermission name="wms:wmsProduct:add">
								<a class="btn btn-success btn-sm" href="#" onclick="openDialog('创建产品', '${ctx}/wms/wmsProduct/form','800px', '80%')" title="创建产品"><i class="fa fa-plus"></i> 创建产品</a>
							</shiro:hasPermission>
							<div class="btn-group">
		                        <button data-toggle="dropdown" class="btn btn-white btn-sm dropdown-toggle" aria-expanded="false">更多 <span class="caret"></span>
		                        </button>
		                        <ul class="dropdown-menu">
		                            <li>
		                            	<shiro:hasPermission name="wms:wmsProduct:export">
								       		<table:exportExcel url="${ctx}/wms/wmsProduct/export"></table:exportExcel><!-- 导出按钮 -->
								       	</shiro:hasPermission>
		                            </li>
		                            <li>
		                            	<a href="${ctx}/wms/wmsProductType/">分类维护</a>
		                            </li>
		                        </ul>
		                    </div>
		                    
                        </div>
                    </div>
                    
                    
                    				
					
					
				</div>			
			</div>
			<div class="ibox-content" id="ibox-content">
			<sys:message content="${message}"/>
			
			
				
				<!-- 查询条件 -->
				<div class="row">
					<div class="col-sm-12">
						<form:form id="searchForm" modelAttribute="wmsProduct" action="${ctx}/wms/wmsProduct/" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
							<table:searchRow></table:searchRow><!-- 搜索栏隐藏 -->
								<%-- 
								<div class="form-group"><span>产品分类：</span>
									<sys:treeselect id="productType" name="productType.id" value="${wmsProduct.productType.id}" labelName="productType.name" labelValue="${wmsProduct.productType.name}"
									title="产品分类" url="/wms/wmsProductType/treeData" cssClass="form-control input-small" allowClear="true"/>
								</div>
								--%>
								<div class="form-group"><span>产品编号：</span>
									<form:input path="no" htmlEscape="false" maxlength="30" class="form-control input-small"/>
								</div>
								<div class="form-group"><span>产品名称：</span>
									<form:input path="name" htmlEscape="false" maxlength="50" class="form-control input-small"/>
								</div>
								<%-- 
								<div class="form-group"><span>产品条码：</span>
									<form:input path="code" htmlEscape="false" maxlength="50" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>产品规格：</span>
									<form:input path="spec" htmlEscape="false" maxlength="50" class="form-control input-medium"/>
								</div>
								--%>
								<div class="form-group"><span>状态：</span>
									<form:select path="status" class="input-small">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('use_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<%--
								<div class="form-group"><span>基本单位：</span>
									<form:select path="unitType" class="input-medium">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('unit_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>创建人：</span>
									<sys:treeselect id="createBy" name="createBy.id" value="${wmsProduct.createBy.id}" labelName="createBy.name" labelValue="${wmsProduct.createBy.name}"
										title="用户" url="/sys/office/treeData?type=3" cssClass="form-control input-small" allowClear="true" notAllowSelectParent="true"/>
								</div>
								<div class="form-group"><span>创建时间：</span>
									<input name="beginCreateDate" type="text" readonly="readonly" maxlength="20" class="laydate-icon form-control input-medium"
										value="<fmt:formatDate value="${wmsProduct.beginCreateDate}" pattern="yyyy-MM-dd"/>"
										onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/> - 
									<input name="endCreateDate" type="text" readonly="readonly" maxlength="20" class="laydate-icon form-control input-medium"
										value="<fmt:formatDate value="${wmsProduct.endCreateDate}" pattern="yyyy-MM-dd"/>"
										onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
								</div>
								 --%>
								 <div class="form-group">
									<button class="btn btn-white btn-sm" onclick="search()"><i class="fa fa-search"></i> 查询</button>
									<button class="btn btn-white btn-sm" onclick="resetSearch()"><i class="fa fa-refresh"></i> 重置</button>
								</div>
						</form:form>
					</div>
				</div>
				<%-- 
				<!-- 工具栏 -->
				<div class="row">
					<div class="col-sm-12 m-b-sm">
						<div class="pull-left">
							<shiro:hasPermission name="wms:wmsProduct:add">
								<table:addRow url="${ctx}/wms/wmsProduct/form?productType.id=${wmsProduct.productType.id}&productType.name=${wmsProduct.productType.name}" title="产品" pageModel="page"></table:addRow><!-- 增加按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="wms:wmsProduct:edit">
							    <table:editRow url="${ctx}/wms/wmsProduct/form" title="产品" id="contentTable" pageModel="page"></table:editRow><!-- 编辑按钮 -->
							</shiro:hasPermission>
							
							<shiro:hasPermission name="wms:wmsProduct:del">
								<table:delRow url="${ctx}/wms/wmsProduct/deleteAll" id="contentTable"></table:delRow><!-- 删除按钮 -->
							</shiro:hasPermission>
							
							<shiro:hasPermission name="wms:wmsProduct:import">
								<table:importExcel url="${ctx}/wms/wmsProduct/import"></table:importExcel><!-- 导入按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="wms:wmsProduct:export">
					       		<table:exportExcel url="${ctx}/wms/wmsProduct/export"></table:exportExcel><!-- 导出按钮 -->
					       	</shiro:hasPermission>
						</div>
						<div class="pull-right">
							<div class="btn-group">
								<button id="searchBtn" class="btn btn-white btn-sm" title="搜索"><i class="fa fa-search"></i></button>
								<table:refreshRow></table:refreshRow>
							</div>
						</div>
					</div>
				</div>
				--%>	
				<!-- 表格 -->
				<div class="table-responsive">
				<table id="contentTable" class="table table-bordered table-striped table-hover">
					<thead>
						<tr>
							<th>产品名称</th>
							<th style="min-width:100px;width:100px;" class="sort-column t.name">产品分类</th>
							<th width="100px" class="sort-column no">产品编号</th>
							<th width="100px">基本单位</th>
							<th width="100px">规格</th>
							<%-- <th>颜色</th>
							<th>尺寸</th>
							--%>
							<th width="100px" class="sort-column sale_price">标准价格</th>
							<th width="100px" class="sort-column status">状态</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.create_by">创建人</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.create_date">创建时间</th>
							<th width="100px">操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="wmsProduct">
						<tr>
							
							<td>
								<a href="${ctx}/wms/wmsProduct/view?id=${wmsProduct.id}" class="" title="查看">${wmsProduct.name}</a>
							</td>
							
							<td>
								${wmsProduct.productType.name}
							</td>
							<td>
								${wmsProduct.no}
							</td>
							<td>
								${fns:getDictLabel(wmsProduct.unitType, 'unit_type', '')}
							</td>
							<td>
								${wmsProduct.spec}
							</td>
							<%-- 
							<td>
								${wmsProduct.color}
							</td>
							<td>
								${wmsProduct.size}
							</td>
							--%>
							<td>
								${wmsProduct.salePrice}
							</td>
							<td>
								${fns:getDictLabel(wmsProduct.status, 'use_status', '')}
							</td>
							<td>
								${wmsProduct.createBy.name}
							</td>
							<td>
								<fmt:formatDate value="${wmsProduct.createDate}" pattern="yyyy-MM-dd"/>
							</td>
							<td>
								<a href="${ctx}/wms/wmsProduct/view?id=${wmsProduct.id}" class="" title="查看">查看</a>
								
								<shiro:hasPermission name="wms:wmsProduct:edit">
			    					<a href="#" onclick="openDialog('修改产品', '${ctx}/wms/wmsProduct/form?id=${wmsProduct.id}','800px', '80%')" title="修改">编辑</a>
									<%--
									<a href="${ctx}/wms/wmsProduct/delete?id=${wmsProduct.id}" onclick="return confirmx('确认要删除该产品吗？', this.href)" class="btn  btn-danger btn-xs" title="删除"><i class="fa fa-trash"></i>
										<span class="hidden-xs">删除</span></a> 
									 --%>
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