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
			<div class="col-sm-12">
				<div class="ibox float-e-margins">
					<div class="ibox-title">
						<h5>业务总览（待办）</h5>
					</div>
					<div class="ibox-content">
						<div>
		                    <table class="table table-bordered">
		                        <tbody>
		                            <tr>
		                                <td>
		                                    <button type="button" class="btn btn-success m-r-sm">${fiReceiveAblePage.count }</button>
		                                    	应收款（个）
		                                </td>
		                                <td>
		                                    <button type="button" class="btn btn-info m-r-sm">${fiPaymentAblePage.count }</button>
		                                    	应付款（个）
		                                </td>
		                                <td>
		                                    <button type="button" class="btn btn-danger m-r-sm">${fiReceiveBillPage.count }</button>
		                                    	收款单（个）
		                                </td>
		                                <td>
		                                    <button type="button" class="btn btn-warning m-r-sm">${fiPaymentBillPage.count }</button>
		                                    	付款单（个）
		                                </td>
		                            </tr>
		                        </tbody>
		                    </table>
		                </div>
					</div>
				</div>
			</div>
		</div>
		<div class="row">
        	<div class="col-sm-6">
        		<div class="ibox float-e-margins">
        			<div class="ibox-title">
						<h5>待办应收款</h5>
						<div class="ibox-tools">
	                        <a class="" href="${ctx}/fi/fiReceiveAble/">
	                            <i class="fa fa-chevron-right"></i>
	                        </a>
	                    </div>
					</div>
					<div class="ibox-content no-padding height300">
						<div class="table-responsive">
							<table id="contentTable" class="table table-hover">
								<thead>
									<tr>
										<th style="min-width:100px;width:100px;">单号</th>
										<th style="min-width:200px;">客户</th>
										<th style="min-width:100px;width:100px;">应收时间</th>
										<th style="min-width:100px;width:100px;">应收</th>										
										<th style="min-width:100px;width:100px;">已收</th>
										<th style="min-width:100px;width:100px;">差额</th>
									</tr>
								</thead>
								<tbody>
								<c:forEach items="${fiReceiveAblePage.list }" var="fiReceiveAble"> 
									<tr>
										<td>
											<a href="${ctx}/fi/fiReceiveAble/index?id=${fiReceiveAble.id}">${fiReceiveAble.no}</a>
										</td>
										<td>${fiReceiveAble.customer.name}</td>
										<td><fmt:formatDate value="${fiReceiveAble.ableDate}" pattern="yyyy-MM-dd"/></td>
										<td>${fiReceiveAble.amount}</td>
										<td>${fiReceiveAble.realAmt}</td>
										<td>
											<c:if test="${(fiReceiveAble.amount - fiReceiveAble.realAmt) > 0}">
												<span class="text-danger">${fiReceiveAble.amount - fiReceiveAble.realAmt}</span>
											</c:if>								
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
						<h5>待办收款单</h5>
						<div class="ibox-tools">
	                        <a class="" href="${ctx}/fi/fiReceiveBill/">
	                            <i class="fa fa-chevron-right"></i>
	                        </a>
	                    </div>
					</div>
					<div class="ibox-content no-padding height300">
						<div class="table-responsive">
							<table id="contentTable" class="table table-hover">
								<thead>
									<tr>
										<th style="min-width:100px;width:100px;">单号</th>
										<th style="min-width:200px;">客户</th>
										<th style="min-width:100px;width:100px;">金额</th>
										<th style="min-width:100px;width:100px;">收款日期</th>
										<th style="min-width:100px;width:100px;">状态</th>
										<th style="min-width:100px;width:100px;">操作</th>
									</tr>
								</thead>
								<tbody>
								<c:forEach items="${fiReceiveBillPage.list }" var="fiReceiveBill"> 
									<tr>
										<td>
											<a href="#" onclick="openDialogView('查看收款单', '${ctx}/fi/fiReceiveBill/view?id=${fiReceiveBill.id}','800px', '500px')">${fiReceiveBill.no}</a>
										</td>
										<td>${fiReceiveBill.customer.name}</td>
										<td>${fiReceiveBill.amount}</td>
										<td><fmt:formatDate value="${fiReceiveBill.dealDate}" pattern="yyyy-MM-dd"/></td>
										<td>
											<span class="<c:if test='${fiReceiveBill.status == 0}'>text-danger</c:if>">
												${fns:getDictLabel(fiReceiveBill.status, 'audit_status', '')}
											</span>
										</td>
										<td>
											<c:if test="${fiReceiveBill.status == 0}">
											<div class="btn-group">
						                    	<a data-toggle="dropdown" class="dropdown-toggle" aria-expanded="false">操作 <span class="caret"></span>
						                        </a>
						                        <ul class="dropdown-menu">
													<shiro:hasPermission name="fi:fiReceiveBill:edit">
								    					<li><a href="#" onclick="openDialog('修改收款单', '${ctx}/fi/fiReceiveBill/form?id=${fiReceiveBill.id}','800px', '500px')" class="" title="修改">修改</a></li>
													</shiro:hasPermission>
													<shiro:hasPermission name="fi:fiReceiveBill:del">
														<li><a href="${ctx}/fi/fiReceiveBill/delete?id=${fiReceiveBill.id}" onclick="return confirmx('确认要删除该收款单吗？', this.href)" class="" title="删除">删除</a> </li>
													</shiro:hasPermission>
													<shiro:hasPermission name="fi:fiReceiveBill:audit">
														<li><a href="${ctx}/fi/fiReceiveBill/audit?id=${fiReceiveBill.id}" onclick="return confirmx('确认要审核该收款单吗？', this.href)" class="" title="审核">审核</a> </li>
													</shiro:hasPermission>
						                      	</ul>
						                      </div>
						                      </c:if>
										</td>
									</tr>			
								</c:forEach>
								</tbody>
							</table>
						</div>
					</div>
        		</div>
        	</div>
        	<div class="col-sm-6">
        		<div class="ibox float-e-margins">
        			<div class="ibox-title">
						<h5>待办应付款</h5>
						<div class="ibox-tools">
	                        <a class="" href="${ctx}/fi/fiPaymentAble/">
	                            <i class="fa fa-chevron-right"></i>
	                        </a>
	                    </div>
					</div>
					<div class="ibox-content no-padding height300">
						<div class="table-responsive">
							<table id="contentTable" class="table table-hover">
								<thead>
									<tr>
										<th style="min-width:100px;width:100px;">单号</th>
										<th style="min-width:200px;">往来单位</th>
										<th style="min-width:100px;width:100px;">应付时间</th>
										<th style="min-width:100px;width:100px;">应付</th>
										<th style="min-width:100px;width:100px;">已付</th>
										<th style="min-width:100px;width:100px;">差额</th>
									</tr>
								</thead>
								<tbody>
								<c:forEach items="${fiPaymentAblePage.list }" var="fiPaymentAble"> 
									<tr>
										<td>
											<a href="${ctx}/fi/fiPaymentAble/index?id=${fiPaymentAble.id}">${fiPaymentAble.no}</a>
										</td>
										<td>${fiPaymentAble.customer.name}${fiPaymentAble.supplier.name}</td>
										<td><fmt:formatDate value="${fiPaymentAble.ableDate}" pattern="yyyy-MM-dd"/></td>
										<td>${fiPaymentAble.amount}</td>
										<td>${fiPaymentAble.realAmt}</td>
										<td>
											<c:if test="${(fiPaymentAble.amount - fiPaymentAble.realAmt) > 0}">
												<span class="text-danger">${fiPaymentAble.amount - fiPaymentAble.realAmt}</span>
											</c:if>								
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
						<h5>待办付款单</h5>
						<div class="ibox-tools">
	                        <a class="" href="${ctx}/fi/fiPaymentBill/">
	                            <i class="fa fa-chevron-right"></i>
	                        </a>
	                    </div>
					</div>
					<div class="ibox-content no-padding height300">
						<div class="table-responsive">
							<table id="contentTable" class="table table-hover">
								<thead>
									<tr>
										<th style="min-width:100px;width:100px;">单号</th>
										<th style="min-width:200px;">往来单位</th>
										<th style="min-width:100px;width:100px;">金额</th>
										<th style="min-width:100px;width:100px;">付款日期</th>
										<th style="min-width:100px;width:100px;">状态</th>
										<th style="min-width:100px;width:100px;">操作</th>
									</tr>
								</thead>
								<tbody>
								<c:forEach items="${fiPaymentBillPage.list }" var="fiPaymentBill">   
									<tr>
										<td>
											<a href="#" onclick="openDialogView('查看付款单', '${ctx}/fi/fiPaymentBill/view?id=${fiPaymentBill.id}','800px', '500px')" class="">${fiPaymentBill.no}</a>        
										</td>
										<td>${fiPaymentBill.customer.name}${fiPaymentAble.supplier.name}</td>
										<td>${fiPaymentBill.amount}</td>
										<td><fmt:formatDate value="${fiPaymentBill.dealDate}" pattern="yyyy-MM-dd"/></td>
										<td>
											<span class="<c:if test='${fiPaymentBill.status == 0}'>text-danger</c:if>">
												${fns:getDictLabel(fiPaymentBill.status, 'audit_status', '')}
											</span>
										</td>
										<td>
											<c:if test="${fiPaymentBill.status == 0}">
											<div class="btn-group">
						                    	<a data-toggle="dropdown" class="dropdown-toggle" aria-expanded="false">操作 <span class="caret"></span>
						                        </a>
						                        <ul class="dropdown-menu">
													<shiro:hasPermission name="fi:fiPaymentBill:edit">
								    					<li><a href="#" onclick="openDialog('修改付款单', '${ctx}/fi/fiPaymentBill/form?id=${fiPaymentBill.id}','800px', '500px')" class="" title="修改">修改</a></li>
													</shiro:hasPermission>
													<shiro:hasPermission name="fi:fiPaymentBill:del">
														<li><a href="${ctx}/fi/fiPaymentBill/delete?id=${fiPaymentBill.id}" onclick="return confirmx('确认要删除该付款单吗？', this.href)" class="" title="删除">删除</a></li> 
													</shiro:hasPermission>
													<shiro:hasPermission name="fi:fiPaymentBill:audit">
														<li><a href="${ctx}/fi/fiPaymentBill/audit?id=${fiPaymentBill.id}" onclick="return confirmx('确认要审核该付款单吗？', this.href)" class="" title="审核">审核</a></li>
													</shiro:hasPermission>
						                      	</ul>
						                      </div>
						                      </c:if>
										</td>
									</tr>			
								</c:forEach>
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