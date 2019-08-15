<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>合同查看</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		var validateForm;
		function doSubmit(){//回调函数，在编辑和保存动作时，供openDialog调用提交表单。
		  if(validateForm.form()){
			  $("#inputForm").submit();
			  return true;
		  }	
		  return false;
		}
		$(document).ready(function() {
			//$("#name").focus();
			validateForm=$("#inputForm").validate({
				submitHandler: function(form){
					loading('正在提交，请稍等...');
					form.submit();
				},
				errorContainer: "#messageBox",
				errorPlacement: function(error, element) {
					$("#messageBox").text("输入有误，请先更正。");
					if (element.is(":checkbox")||element.is(":radio")||element.parent().is(".input-append")){
						error.appendTo(element.parent().parent());
					} else {
						error.insertAfter(element);
					}
				}
			});
		});
	</script>
</head>
<body class="gray-bg">
<div class="wrapper-content">
	<div class="ibox">
		<div class="ibox-title">
			<h5>合同查看</h5>
		</div>
		<div class="ibox-content">
		<sys:message content="${message}"/>	
		<form:form id="inputForm" modelAttribute="omContract" action="${ctx}/om/omContract/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<form:hidden path="order.id"/>
			<h4 class="page-header">基本信息</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">合同编号</label>
						<div class="col-sm-8">
							<p class="form-control-static">
								${omContract.no}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">合同标题</label>
						<div class="col-sm-8">
							<p class="form-control-static">
								${omContract.name}
							</p>
						</div>
					</div>
				</div>
			</div>
			
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">客户</label>
						<div class="col-sm-8">
							<p class="form-control-static">
								<a href="${ctx}/crm/crmCustomer/index?id=${omContract.customer.id}">${omContract.customer.name}</a>
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">合同总金额</label>
						<div class="col-sm-8">
							<p class="form-control-static">
								${omContract.amount}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">关联报价单</label>
						<div class="col-sm-8">
							<p class="form-control-static">
								${omContract.quote.no}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">关联商机</label>
						<div class="col-sm-8">
							<p class="form-control-static">
								<a href="${ctx}/crm/crmChance/index?id=${omContract.chance.id}">${omContract.chance.name}</a>
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">签约日期</label>
						<div class="col-sm-8">
							<p class="form-control-static">
								<fmt:formatDate value="${omContract.dealDate}" pattern="yyyy-MM-dd"/>
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">交付时间</label>
						<div class="col-sm-8">
							<p class="form-control-static">
								<fmt:formatDate value="${omContract.deliverDate}" pattern="yyyy-MM-dd"/>
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">生效时间</label>
						<div class="col-sm-8">
							<p class="form-control-static">
								<fmt:formatDate value="${omContract.startDate}" pattern="yyyy-MM-dd"/>
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">到期时间</label>
						<div class="col-sm-8">
							<p class="form-control-static">
								<fmt:formatDate value="${omContract.endDate}" pattern="yyyy-MM-dd"/>
							</p>
						</div>
					</div>
				</div>
			</div>
			<h4 class="page-header">操作信息</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">销售负责人</label>
						<div class="col-sm-8">
							<p class="form-control-static">
								${omContract.ownBy.name}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">状态</label>
						<div class="col-sm-8">
							<p class="form-control-static">
								${fns:getDictLabel(omContract.status, 'audit_status', '')}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">创建人</label>
						<div class="col-sm-8">
							<p class="form-control-static">
								${omContract.createBy.name}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">创建时间</label>
						<div class="col-sm-8">
							<p class="form-control-static">
								<fmt:formatDate value="${omContract.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">审核人</label>
						<div class="col-sm-8">
							<p class="form-control-static">
								${omContract.auditBy.name}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">审核时间</label>
						<div class="col-sm-8">
							<p class="form-control-static">
								<fmt:formatDate value="${omContract.auditDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</p>
						</div>
					</div>
				</div>
			</div>
			<h4 class="page-header">正文信息</h4>
			<div class="row">
				<div class="col-sm-12">
					<div class="view-group">
						<label class="col-sm-2 control-label">正文</label>
						<div class="col-sm-10">
							<p class="form-control-static">${omContract.notes}</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="view-group">
						<label class="col-sm-2 control-label">附件</label>
						<div class="col-sm-10">
							<form:hidden id="files" path="files" htmlEscape="false" maxlength="2000" class=""/>
							<sys:ckfinder input="files" type="files" uploadPath="/file" selectMultiple="true" readonly="true"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="view-group">
						<label class="col-sm-2 control-label">备注</label>
						<div class="col-sm-10">
							<p class="form-control-static">${omContract.remarks}</p>
						</div>
					</div>
				</div>
			</div>
			
			
		<!-- 明细 -->
		<div class="tabs-container">
	    	<ul class="nav nav-tabs">
				<li class="active"><a data-toggle="tab" href="#tab-1" aria-expanded="true">订单明细</a></li>
	    	</ul>
          	<div class="tab-content">
          	   	<div class="panel-body">
					<div id="tab-1" class="tab-pane table-responsive active">
					<table id="contentTable" class="table table-striped table-bordered table-hover table-condensed">
						<thead>
							<tr>
								<th>产品编号</th>
								<th>产品名称</th>
								<th>规格</th>
								<th>单位</th>
								<th>单价(元)</th>
								<th>数量</th>
								<th>金额(元)</th>
								<th>备注</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach items="${omContract.omOrderDetailList}" var="omOrderDetail">
								<tr>
											<td>
												${omOrderDetail.product.no}
											</td>
											<td>
												${omOrderDetail.product.name}
											</td>
											<td>
												${omOrderDetail.product.spec}
											</td>
											<td>
												${omOrderDetail.unitType}
											</td>
											<td>
												${omOrderDetail.price}
											</td>
											<td>
												${omOrderDetail.num}
											</td>
											<td>
												${omOrderDetail.amount}
											</td>
											
											<td>
												${omOrderDetail.remarks}
											</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>	
					<div class="pull-right">
						总数量：<input type="text" id="num" name="num" value="${omContract.order.num}" htmlEscape="false" class="form-control input-mini" readonly="true" style="border:0;"/>
						总计：<input type="text" id="totalAmt" name="totalAmt" value="${omContract.order.totalAmt}" htmlEscape="false" class="form-control input-mini" readonly="true" style="border:0;"/>
						其他费用：<input type="text" id="otherAmt" name="otherAmt" value="${omContract.order.otherAmt}" htmlEscape="false" min="0" maxlength="10" class="form-control input-mini number" onkeyup="checkInputOtherAmt()"  style="border:0;"/>
						总金额：<input type="text" id="amount" name="amount" value="${omContract.order.amount}" htmlEscape="false" class="form-control input-mini" readonly="true" style="border:0;"/>
					
					</div>				
					</div>
				</div>
			</div>
		</div>
		
		<br>
		<c:if test="${omContract.status == 1}">
		<!-- 关联的应收款明细 -->
		<div class="tabs-container">
	    	<ul class="nav nav-tabs">
				<li class="active"><a data-toggle="tab" href="#tab-1" aria-expanded="true">应收款</a></li>
	    	</ul>
          	<div class="tab-content">
          	   	<div class="panel-body">
					<div id="tab-1" class="tab-pane table-responsive active">
						<!-- 应收款表格 -->
						<table id="fiReceiveAbleListTable" class="table table-striped table-bordered table-hover table-condensed dataTables-example dataTable">
							<thead>
								<tr>
									<%-- <th><input type="checkbox" class="i-checks"></th>--%>
									<th class="sort-column no">单号</th>
									
									
									<th class="sort-column a.amount">应收金额</th>
									<th class="sort-column a.real_amt">实际已收</th>
									<th>差额</th>
									<th class="sort-column a.able_date">应收时间</th>
									<th class="sort-column a.own_by">负责人</th>
									<th class="sort-column a.status">状态</th>
									<th class="sort-column a.create_by">创建人</th>
									<th class="sort-column a.create_date">创建时间</th>
									<th>操作</th>
								</tr>
							</thead>
							<tbody>
							<c:forEach items="${fiReceiveAbleList}" var="fiReceiveAble">
								<tr>
									<%-- <td><input type="checkbox" id="${fiReceiveAble.id}" class="i-checks"></td>--%>
									<td><a href="${ctx}/fi/fiReceiveAble/index?id=${fiReceiveAble.id}">
										${fiReceiveAble.no}
									</a></td>
									
									<td>
										${fiReceiveAble.amount}
									</td>
									<td>
										${fiReceiveAble.realAmt}
									</td>
									<td>
										<c:if test="${(fiReceiveAble.amount - fiReceiveAble.realAmt) > 0}">
											<span class="label label-warning">${fiReceiveAble.amount - fiReceiveAble.realAmt}</span>
										</c:if>								
									</td>
									<td>
										<fmt:formatDate value="${fiReceiveAble.ableDate}" pattern="yyyy-MM-dd"/>
									</td>
									<td>
										${fiReceiveAble.ownBy.name}
									</td>
									<td>
										${fns:getDictLabel(fiReceiveAble.status, 'finish_status', '')}
									</td>
									<td>
										${fiReceiveAble.createBy.name}
									</td>
									<td>
										<fmt:formatDate value="${fiReceiveAble.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
									</td>
									<td>
										<shiro:hasPermission name="fi:fiReceiveAble:view">
											<a href="${ctx}/fi/fiReceiveAble/index?id=${fiReceiveAble.id}" class="btn btn-info btn-xs" title="查看"><i class="fa fa-search-plus"></i> 查看</a>
										</shiro:hasPermission>
										
										<c:if test="${fiReceiveAble.status != 2}">
										<shiro:hasPermission name="fi:fiReceiveAble:edit">
					    					<a href="#" onclick="openDialog('修改应收款', '${ctx}/fi/fiReceiveAble/editForm?id=${fiReceiveAble.id}','800px', '500px')" class="btn btn-success btn-xs" title="修改"><i class="fa fa-edit"></i>
												<span class="hidden-xs">修改</span></a>
										</shiro:hasPermission>
										<%-- 
										<shiro:hasPermission name="fi:fiReceiveAble:del">
											<a href="${ctx}/fi/fiReceiveAble/delete?id=${fiReceiveAble.id}" onclick="return confirmx('确认要删除该应收款吗？', this.href)" class="btn  btn-danger btn-xs" title="删除"><i class="fa fa-trash"></i>
												<span class="hidden-xs">删除</span></a> 
										</shiro:hasPermission>
										--%>
										
										<shiro:hasPermission name="fi:fiReceiveBill:add">
					    					<a href="#" onclick="openDialog('添加收款单', '${ctx}/fi/fiReceiveBill/form?fiReceiveAble.id=${fiReceiveAble.id}&fiReceiveAble.name=${fiReceiveAble.no}&customer.id=${fiReceiveAble.customer.id}&customer.name=${fiReceiveAble.customer.name}','800px', '500px')" class="btn btn-success btn-xs" title="添加收款单"><i class="fa fa-plus"></i>
												<span class="hidden-xs">添加收款单</span></a>
										</shiro:hasPermission>
										
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
		</c:if>
		<br>
				<div class="form-actions">
				
					<c:if test="${omContract.status == 0}">
						<shiro:hasPermission name="om:omContract:edit">
	    					<a href="${ctx}/om/omContract/form?id=${omContract.id}" class="btn btn-success" title="修改"><i class="fa fa-edit"></i>
								<span class="hidden-xs">修改</span></a>
						</shiro:hasPermission>
						<shiro:hasPermission name="om:omContract:del">
							<a href="${ctx}/om/omContract/delete?id=${omContract.id}" onclick="return confirmx('确认要删除该合同吗？', this.href)" class="btn  btn-danger" title="删除"><i class="fa fa-trash"></i>
								<span class="hidden-xs">删除</span></a> 
						</shiro:hasPermission>
						<shiro:hasPermission name="om:omContract:audit">
							<a href="${ctx}/om/omContract/audit?id=${omContract.id}" onclick="return confirmx('确认要审核该合同吗？', this.href)" class="btn  btn-success" title="审核"><i class="fa fa-check"></i>
								<span class="hidden-xs">审核</span></a> 
						</shiro:hasPermission>
					</c:if>
					
					<a href="${ctx}/om/omContract/print?id=${omContract.id}" class="btn btn-white" title="打印" target="_blank"><i class="fa fa-print"></i> <span class="hidden-xs">打印</span></a>
					<input id="btnCancel" class="btn btn-white" type="button" value="返 回" onclick="history.go(-1)"/>
				</div>
			<br>
		</form:form>
	</div>
</div>
</div>
</body>
</html>