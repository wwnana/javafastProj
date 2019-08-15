<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>主页</title>
	<meta name="decorator" content="default"/>    
    <script type="text/javascript">
    </script>
</head>

<body class="gray-bg">
	<div class="wrapper-content">
		<sys:message content="${message}"/>
        <div class="row">
        	<div class="col-sm-5">
        		<div class="ibox float-e-margins">
        			<div class="ibox-title">
        				<h5>待核采购单</h5>
        				<div class="ibox-tools">
	                        <a class="" href="${ctx}/wms/wmsPurchase/list?status=0">
	                            <i class="fa fa-chevron-right"></i>
	                        </a>
	                    </div>
        			</div>
        			<div class="ibox-content no-padding height300">
        				<div class="table-responsive">
        					<table id="contentTable" class="table table-hover">
        						<thead>
									<tr>
										<th>单号</th>
										<th width="100px">负责人</th>
										<th width="100px">业务日期</th>
										<th width="100px">状态</th>
									</tr>
								</thead>
								<tbody>
								<c:forEach items="${wmsPurchasePage.list }" var="wmsPurchase">
									<tr>
										<td>
											<a href="${ctx}/wms/wmsPurchase/view?id=${wmsPurchase.id}">${wmsPurchase.no}</a>
										</td>
										<td>
											${wmsPurchase.dealBy.name}
										</td>
										<td>
											<fmt:formatDate value="${wmsPurchase.dealDate}" pattern="yyyy-MM-dd"/>
										</td>
										<td>
											<span class="<c:if test='${wmsPurchase.status == 0}'>text-danger</c:if>">
												${fns:getDictLabel(wmsPurchase.status, 'audit_status', '')}
											</span>
										</td>
									</tr>
								</c:forEach>
								</tbody>
        					</table>
        				</div>
        			</div>
        		</div>
        		<div class="ibox float-e-margins">
        			<div class="ibox-title">
        				<h5>待入库单</h5>
        				<div class="ibox-tools">
	                        <a class="" href="${ctx}/wms/wmsInstock">
	                            <i class="fa fa-chevron-right"></i>
	                        </a>
	                    </div>
        			</div>
        			<div class="ibox-content no-padding height300">
        				<div class="table-responsive">
        					<table id="contentTable" class="table table-hover">
        						<thead>
									<tr>
										<th>单号</th>
										<th width="100px">负责人</th>
										<th width="100px">业务日期</th>
										<th width="100px">状态</th>
									</tr>
								</thead>
								<tbody>
								<c:forEach items="${wmsInstockPage.list }" var="wmsInstock"> 
									<tr>
										<td>
											<a href="${ctx}/wms/wmsInstock/view?id=${wmsInstock.id}">${wmsInstock.no}</a>
										</td>
										<td>
											${wmsInstock.dealBy.name}
										</td>
										<td>
											<fmt:formatDate value="${wmsInstock.dealDate}" pattern="yyyy-MM-dd"/>
										</td>
										<td>
											<span class="<c:if test='${wmsInstock.status == 0}'>text-danger</c:if>">
												${fns:getDictLabel(wmsInstock.status, 'audit_status', '')}
											</span>
										</td>
									</tr>
								</c:forEach>
								</tbody>
        					</table>
        				</div>
        			</div>
        		</div>
        	</div>
        	<div class="col-sm-5">
        		<div class="ibox float-e-margins">
        			<div class="ibox-title">
        				<h5>库存预警</h5>
        				<div class="ibox-tools">
	                        <a class="" href="${ctx}/wms/wmsStock/">
	                            <i class="fa fa-chevron-right"></i>
	                        </a>
	                    </div>
        			</div>
        			<div class="ibox-content no-padding height300">
        				<div class="table-responsive">
        					<table id="contentTable" class="table table-hover">
        						<thead>
									<tr>
										<th>产品名称</th>
										<th width="100px">仓库</th>
										<th width="100px">库存数</th>
										<th width="100px">预警数</th>
									</tr>
								</thead>
								<tbody>
								<c:forEach items="${wmsStockPage.list }" var="wmsStock">
									<tr>
										<td>
											<a href="#" onclick="openDialogView('查看产品库存', '${ctx}/wms/wmsStock/view?id=${wmsStock.id}','800px', '500px')">${wmsStock.product.name}</a>
										</td>
										<td>
											${wmsStock.warehouse.name}
										</td>
										<td>
											${wmsStock.stockNum}
										</td>
										<td>
											${wmsStock.warnNum}
										</td>
									</tr>
								</c:forEach>
								</tbody>
        					</table>
        				</div>
        			</div>
        		</div>
        		<div class="ibox float-e-margins">
        			<div class="ibox-title">
        				<h5>待出库单</h5>
        				<div class="ibox-tools">
	                        <a class="" href="${ctx}/wms/wmsOutstock">
	                            <i class="fa fa-chevron-right"></i>
	                        </a>
	                    </div>
        			</div>
        			<div class="ibox-content no-padding height300">
        				<div class="table-responsive">
        					<table id="contentTable" class="table table-hover">
        						<thead>
									<tr>
										<th>单号</th>
										<th width="100px">负责人</th>
										<th width="100px">业务日期</th>
										<th width="100px">状态</th>
									</tr>
								</thead>
								<tbody>
								<c:forEach items="${wmsOutstockPage.list }" var="wmsOutstock"> 
									<tr>
										<td>
											<a href="${ctx}/wms/wmsOutstock/view?id=${wmsOutstock.id}">${wmsOutstock.no}</a>
										</td>
										<td>
											${wmsOutstock.dealBy.name}
										</td>
										<td>
											<fmt:formatDate value="${wmsOutstock.dealDate}" pattern="yyyy-MM-dd"/>
										</td>
										<td>
											<span class="<c:if test='${wmsOutstock.status == 0}'>text-danger</c:if>">
												${fns:getDictLabel(wmsOutstock.status, 'audit_status', '')}
											</span>
										</td>
									</tr>
								</c:forEach>
								</tbody>
        					</table>
        				</div>
        			</div>
        		</div>
        	</div>
        	<div class="col-sm-2">
        		<div class="ibox float-e-margins">
					<div class="ibox-title">
						<h5>待办总览</h5>
					</div>
					<div class="ibox-content">
						<div>
		                    <table class="table table-bordered">
		                        <tbody>
		                            <tr>
		                                <td>
		                                    <button type="button" class="btn btn-info m-r-sm">${wmsPurchasePage.count }</button>
		                                    	采购单
		                                </td>
		                            </tr>
		                            <tr>
		                                <td>
		                                    <button type="button" class="btn btn-success m-r-sm">${wmsInstockPage.count } </button>
		                                    	入库单
		                                </td>
		                            </tr>
		                            <tr>
		                                <td>
		                                    <button type="button" class="btn btn-success m-r-sm">${wmsOutstockPage.count }</button>
		                                    	出库单
		                                </td>
		                            </tr>
		                            <tr>
		                                <td>
		                                    <button type="button" class="btn btn-danger m-r-sm">${wmsStockPage.count }</button>
		                                    	库存预警
		                                </td>
		                            </tr>
		                        </tbody>
		                    </table>
		                </div>
					</div>
				</div>
        	</div>
       	</div>
	</div>
</body>
</html>