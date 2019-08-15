<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>商机查看</title>
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
			<h5>商机查看</h5>
		</div>
		<div class="ibox-content">
		<sys:message content="${message}"/>	
		
		<form:form id="inputForm" modelAttribute="crmChance" action="${ctx}/crm/crmChance/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
			<h4 class="page-header">基本信息</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">商机名称</label>
						<div class="col-sm-8">
							<p class="form-control-static">
								${crmChance.name}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">客户</label>
						<div class="col-sm-8">
							<p class="form-control-static">
								<a href="${ctx}/crm/crmCustomer/index?id=${crmChance.customer.id}">${crmChance.customer.name}</a>
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">预计销售金额</label>
						<div class="col-sm-8">
							<p class="form-control-static">
								${crmChance.saleAmount}元
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">预计赢单率</label>
						<div class="col-sm-8">
							<p class="form-control-static">
								${fns:getDictLabel(crmChance.probability, 'probability_type', '')}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">商机类型</label>
						<div class="col-sm-8">
							<p class="form-control-static">
								${fns:getDictLabel(crmChance.changeType, 'change_type', '')}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">商机来源</label>
						<div class="col-sm-8">
							<p class="form-control-static">
								${fns:getDictLabel(crmChance.sourType, 'sour_type', '')}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">销售阶段</label>
						<div class="col-sm-8">
							<p class="form-control-static">
								${fns:getDictLabel(crmChance.periodType, 'period_type', '')}
							</p>
						</div>
					</div>
				</div>
				
			</div>
			<h4 class="page-header">操作信息</h4>
			<div class="row">
				
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">负责人</label>
						<div class="col-sm-8">
							<p class="form-control-static">
								${crmChance.ownBy.name}
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
								${crmChance.createBy.name}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">创建时间</label>
						<div class="col-sm-8">
							<p class="form-control-static">
								<fmt:formatDate value="${crmChance.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">更新人</label>
						<div class="col-sm-8">
							<p class="form-control-static">
								${crmChance.updateBy.name}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">更新时间</label>
						<div class="col-sm-8">
							<p class="form-control-static">
								<fmt:formatDate value="${crmChance.updateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</p>
						</div>
					</div>
				</div>
			</div>
			<h4 class="page-header">下次联系提醒</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">下次联系时间</label>
						<div class="col-sm-8">
							<p class="form-control-static">
								<fmt:formatDate value="${crmChance.nextcontactDate}" pattern="yyyy-MM-dd"/>
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">联系内容</label>
						<div class="col-sm-8">
							<p class="form-control-static">
								${crmChance.nextcontactNote}
							</p>
						</div>
					</div>
				</div>
			</div>
			<h4 class="page-header">其他信息</h4>
			<div class="row">
				<div class="col-sm-12">
					<div class="view-group">
						<label class="col-sm-2 control-label">商机描述</label>
						<div class="col-sm-10">
							<p class="form-control-static">${crmChance.remarks}</p>
						</div>
					</div>
				</div>
			</div>
			<div class="hr-line-dashed"></div>
				<div class="form-actions">
					<shiro:hasPermission name="crm:crmChance:edit">
	   					<a href="${ctx}/crm/crmChance/form?id=${crmChance.id}" class="btn btn-success" title="修改"><i class="fa fa-edit"></i>
							<span class="hidden-xs">修改</span></a>
					</shiro:hasPermission>
					<shiro:hasPermission name="crm:crmChance:del">
						<a href="${ctx}/crm/crmChance/delete?id=${crmChance.id}" onclick="return confirmx('确认要删除该商机吗？', this.href)" class="btn  btn-danger" title="删除"><i class="fa fa-trash"></i>
							<span class="hidden-xs">删除</span></a> 
					</shiro:hasPermission>
					
					<shiro:hasPermission name="crm:crmQuote:edit">
	   					<a href="${ctx}/crm/crmQuote/form?chance.id=${crmChance.id}&chance.name=${crmChance.name}&customer.id=${crmChance.customer.id}&customer.name=${crmChance.customer.name}" class="btn btn-success" title="创建报价单"><i class="fa fa-plus"></i>
							<span class="hidden-xs">创建报价单</span></a>
					</shiro:hasPermission>
					
					<shiro:hasPermission name="om:omContract:add">
	   					<a href="${ctx}/om/omContract/form?chance.id=${crmChance.id}&chance.name=${crmChance.name}&customer.id=${crmChance.customer.id}&customer.name=${crmChance.customer.name}" class="btn btn-success" title="创建合同订单"><i class="fa fa-plus"></i>
							<span class="hidden-xs">创建合同订单</span></a>
					</shiro:hasPermission>
					<input id="btnCancel" class="btn btn-white" type="button" value="返 回" onclick="history.go(-1)"/>
				</div>
			<br>
		</form:form>
		
		
		
	</div>
	</div>

	<div class="tabs-container">
		<ul class="nav nav-tabs">
             <li class="active"><a data-toggle="tab" href="#tab-1" aria-expanded="true"> 报价单</a>
             </li>
             <li class=""><a data-toggle="tab" href="#tab-2" aria-expanded="false">合同订单</a>
             </li>
         </ul>
         <div class="tab-content">
             <div id="tab-1" class="tab-pane active">
                 <div class="panel-body">
                    <table id="contentTable" class="table table-striped table-bordered table-hover table-condensed">
					<thead>
						<tr>
							<th><input type="checkbox" class="i-checks"></th>
							<th>单号</th>
							<th>客户</th>
							<th>联系人</th>
							<th>总金额</th>
							<th>报价日期</th>
							<th>有效期至</th>
							<th>状态</th>
							<th>负责人</th>
							<th>创建人</th>
							<th>创建时间</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${quoteList}" var="crmQuote">
						<tr>
							<td><input type="checkbox" id="${crmQuote.id}" class="i-checks"></td>
							<td>
								<a href="${ctx}/crm/crmQuote/view?id=${crmQuote.id}">
									${crmQuote.no}
								</a>
							</td>
							<td>
								<a href="${ctx}/crm/crmCustomer/index?id=${crmQuote.customer.id}" title="跟进">
									${crmQuote.customer.name}
								</a>
							</td>
							<td>
								${crmQuote.contacter.name}
							</td>
							<td>
								${crmQuote.amount}
							</td>
							<td>
								<fmt:formatDate value="${crmQuote.startdate}" pattern="yyyy-MM-dd"/>
							</td>
							<td>
								<fmt:formatDate value="${crmQuote.enddate}" pattern="yyyy-MM-dd"/>
							</td>
							<td>
								${fns:getDictLabel(crmQuote.status, 'audit_status', '')}
							</td>
							<td>
								${crmQuote.ownBy.name}
							</td>
							<td>
								${crmQuote.createBy.name}
							</td>
							<td>
								<fmt:formatDate value="${crmQuote.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</td>
							<td>
								<shiro:hasPermission name="crm:crmQuote:view">
									<a href="${ctx}/crm/crmQuote/view?id=${crmQuote.id}" class="btn btn-info btn-xs" title="查看"><i class="fa fa-search-plus"></i> </a>
								</shiro:hasPermission>
								<c:if test="${crmQuote.status == 0}">
								<shiro:hasPermission name="crm:crmQuote:edit">
			    					<a href="${ctx}/crm/crmQuote/form?id=${crmQuote.id}" class="btn btn-success btn-xs" title="修改"><i class="fa fa-edit"></i>
										<span class="hidden-xs"></span></a>
								</shiro:hasPermission>
								<shiro:hasPermission name="crm:crmQuote:del">
									<a href="${ctx}/crm/crmQuote/delete?id=${crmQuote.id}" onclick="return confirmx('确认要删除该报价单吗？', this.href)" class="btn  btn-danger btn-xs" title="删除"><i class="fa fa-trash"></i>
										<span class="hidden-xs"></span></a> 
								</shiro:hasPermission>
								<shiro:hasPermission name="crm:crmQuote:audit">
									<a href="${ctx}/crm/crmQuote/audit?id=${crmQuote.id}" onclick="return confirmx('确认要审核该报价单吗？', this.href)" class="btn  btn-success btn-xs" title="审核"><i class="fa fa-check"></i>
										<span class="hidden-xs"></span></a> 
								</shiro:hasPermission>
								</c:if>
								<c:if test="${crmQuote.status == 1}">
								<shiro:hasPermission name="om:omContract:edit">
			    					<a href="${ctx}/om/omContract/quoteToForm?quote.id=${crmQuote.id}" class="btn btn-success btn-xs" title="生成订单"><i class="fa fa-file-text-o"></i>
										<span class="hidden-xs"></span></a>
								</shiro:hasPermission>
								</c:if>
							</td>
						</tr>
					</c:forEach>
					</tbody>
				</table>
                 </div>
             </div>
             <div id="tab-2" class="tab-pane">
                 <div class="panel-body">
                 	<table id="contentTable2" class="table table-striped table-bordered table-hover table-condensed">
					<thead>
						<tr>
							<th><input type="checkbox" class="i-checks"></th>
							<th class="sort-column no">合同编号</th>
							<th class="sort-column name">主题</th>
							<%-- 
							<th class="sort-column order_id">销售订单</th>
							<th class="sort-column quote_id">报价单</th>
							<th class="sort-column chance_id">商机</th>
							--%>
							<th class="sort-column a.customer_id">客户</th>
							<th class="sort-column a.amount">总金额</th>
							<th class="sort-column a.deal_date">签约日期</th>
							<th class="sort-column a.deliver_date">交付时间</th>
							<th class="sort-column a.start_date">生效时间</th>
							<th class="sort-column a.end_date">到期时间</th>
							<th class="sort-column a.own_by">销售负责人</th>
							<th class="sort-column a.status">状态</th>
							<th class="sort-column a.create_by">创建人</th>
							<th class="sort-column a.create_date">创建时间</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${omContractList}" var="omContract">
						<tr>
							<td><input type="checkbox" id="${omContract.id}" class="i-checks"></td>
							<td><a href="${ctx}/om/omContract/index?id=${omContract.id}">
								${omContract.no}
							</a></td>
							<td>
								${omContract.name}
							</td>
							<td>
								<a href="${ctx}/crm/crmCustomer/index?id=${omContract.customer.id}" title="跟进">
									${omContract.customer.name}
								</a>
							</td>
							<%-- 
							<td>
								${omContract.order.id}
							</td>
							<td>
								${omContract.quote.id}
							</td>
							<td>
								${omContract.chance.id}
							</td>
							--%>
							<td>
								${omContract.amount}
							</td>
							<td>
								<fmt:formatDate value="${omContract.dealDate}" pattern="yyyy-MM-dd"/>
							</td>
							<td>
								<fmt:formatDate value="${omContract.deliverDate}" pattern="yyyy-MM-dd"/>
							</td>
							<td>
								<fmt:formatDate value="${omContract.startDate}" pattern="yyyy-MM-dd"/>
							</td>
							<td>
								<fmt:formatDate value="${omContract.endDate}" pattern="yyyy-MM-dd"/>
							</td>
							<td>
								${omContract.ownBy.name}
							</td>
							<td>
								${fns:getDictLabel(omContract.status, 'audit_status', '')}
							</td>
							<td>
								${omContract.createBy.name}
							</td>
							<td>
								<fmt:formatDate value="${omContract.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</td>
							<td>
								<shiro:hasPermission name="om:omContract:view">
									<a href="${ctx}/om/omContract/index?id=${omContract.id}" class="btn btn-info btn-xs" title="查看"><i class="fa fa-search-plus"></i> 查看</a>
								</shiro:hasPermission>
								<c:if test="${omContract.status == 0}">
									<shiro:hasPermission name="om:omContract:edit">
				    					<a href="${ctx}/om/omContract/form?id=${omContract.id}" class="btn btn-success btn-xs" title="修改"><i class="fa fa-edit"></i>
											<span class="hidden-xs">修改</span></a>
									</shiro:hasPermission>
									<%-- 
									<shiro:hasPermission name="om:omContract:del">
										<a href="${ctx}/om/omContract/delete?id=${omContract.id}" onclick="return confirmx('确认要删除该合同吗？', this.href)" class="btn  btn-danger btn-xs" title="删除"><i class="fa fa-trash"></i>
											<span class="hidden-xs">删除</span></a> 
									</shiro:hasPermission>
									--%>
									<shiro:hasPermission name="om:omContract:audit">
										<a href="${ctx}/om/omContract/audit?id=${omContract.id}" onclick="return confirmx('确认要审核该合同吗？', this.href)" class="btn  btn-success btn-xs" title="审核"><i class="fa fa-check"></i>
											<span class="hidden-xs">审核</span></a> 
									</shiro:hasPermission>
								</c:if>
								<c:if test="${omContract.status == 1}">
								
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
</body>
</html>