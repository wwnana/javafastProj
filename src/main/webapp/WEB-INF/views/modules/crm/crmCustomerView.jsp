<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>客户管理</title>
	<meta name="decorator" content="default"/>
	<style type="text/css">
		.vertical-timeline-content {
    margin-left: 40px;
    }
		.navy-bg {
		    background-color: #ffffff;
		}
		.vertical-timeline-icon {
		    position: absolute;
		    top: 40%;
		    left: 12px;
		    width: 16px;
		    height: 16px;
		    border-radius: 50%;
		    font-size: 12px;
		    border: 2px solid #23c6c8;
		    text-align: center;
		}
		.vertical-timeline-content::before {
			top: 40%;
		}
		.vertical-timeline-content {
			padding: 5px 10px;
		}
		.vertical-timeline-content p {
		    margin:5px 0 1px 0;
		    line-height: 20px;
		}
	</style>
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
		function toView(objectType, targetId){
	    	//object_type对象类型    10：项目，11：任务，12:日报，13：通知，14：审批，20：客户，21：联系人，22：商机，23：报价，24：合同订单，25:沟通, 26:订单，27：退货单，30：产品：31：采购，32：入库，33：出库，34：移库，39：供应商，36：盘点，37:调拨，   50：应收款，51：应付款， 52：收款单，53：付款单
	    	if(objectType == "11"){//任务
	    		window.location.href = "${ctx}/oa/oaTask/view?id="+targetId;
	    	}
	    	if(objectType == "20"){//客户
	    		window.location.href = "${ctx}/crm/crmCustomer/view?id="+targetId;
	    	}
	    	if(objectType == "21"){
	    		openDialogView("联系人", "${ctx}/crm/crmContacter/view?id="+targetId, '800px', '500px');
	    	}
	    	if(objectType == "22"){//商机
	    		window.location.href = "${ctx}/crm/crmChance/index?id="+targetId;
	    	}
	    	if(objectType == "23"){//报价
	    		window.location.href = "${ctx}/crm/crmQuote/view?id="+targetId;
	    	}
	    	if(objectType == "24"){//合同订单
	    		window.location.href = "${ctx}/om/omContract/index?id="+targetId;
	    	}
	    	if(objectType == "25"){
	    		openDialogView("跟进记录", "${ctx}/crm/crmContactRecord/view?id="+targetId, '800px', '500px');
	    	}
	    	if(objectType == "26"){//订单
	    		window.location.href = "${ctx}/om/omOrder/index?id="+targetId;
	    	}
	    	if(objectType == "27"){//退货单
	    		window.location.href = "${ctx}/om/omReturnorder/view?id="+targetId;
	    	}
	    	if(objectType == "39"){
	    		openDialogView("供应商", "${ctx}/wms/wmsSupplier/view?id="+targetId, '800px', '500px');
	    	}
	    	if(objectType == "31"){//采购单
	    		window.location.href = "${ctx}/wms/wmsPurchase/view?id="+targetId;
	    	}
	    	if(objectType == "32"){//入库单
	    		window.location.href = "${ctx}/wms/wmsInstock/view?id="+targetId;
	    	}
	    	if(objectType == "33"){//出库单
	    		window.location.href = "${ctx}/wms/wmsOutstock/view?id="+targetId;
	    	}
	    	if(objectType == "50"){//应收款
	    		window.location.href = "${ctx}/fi/fiReceiveAble/index?id="+targetId;
	    	}
	    	if(objectType == "51"){//应付款
	    		window.location.href = "${ctx}/fi/fiPaymentAble/index?id="+targetId;
	    	}
	    	if(objectType == "52"){
	    		openDialogView("收款单", "${ctx}/fi/fiReceiveBill/view?id="+targetId, '800px', '500px');
	    	}
	    	if(objectType == "53"){
	    		openDialogView("付款单", "${ctx}/fi/fiPaymentBill/view?id="+targetId, '800px', '500px');
	    	}
	    }
	</script>
</head>
<body class="gray-bg">
 <div class="">
    <div class="col-sm-9">
		<div class="ibox">
			<div class="ibox-title">
				<h5>客户信息 </h5>
				
			</div>
			<div class="ibox-content">
			<form:form id="inputForm" modelAttribute="crmCustomer" action="${ctx}/crm/crmCustomer/save" method="post" class="form-horizontal">
				<form:hidden path="id"/>
				<sys:message content="${message}"/>	
					<h4 class="page-header">基本信息</h4>
					<div class="row">
						<div class="col-sm-6">
							<div class="view-group">
								<label class="col-sm-4 control-label">客户名称：</label>
								<div class="col-sm-8">
									<p class="form-control-static">${crmCustomer.name }</p>
								</div>
							</div>
						</div>
						<div class="col-sm-6">
							<div class="view-group">
								<label class="col-sm-4 control-label">客户分类：</label>
								<div class="col-sm-8">
									<p class="form-control-static">${fns:getDictLabel(crmCustomer.customerType, 'customer_type', '')}</p>
								</div>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-sm-6">
							<div class="view-group">
								<label class="col-sm-4 control-label">客户状态：</label>
								<div class="col-sm-8">
									<p class="form-control-static">${fns:getDictLabel(crmCustomer.customerStatus, 'customer_status', '')}</p>
								</div>
							</div>
						</div>
						<div class="col-sm-6">
							<div class="view-group">
								<label class="col-sm-4 control-label">客户级别：</label>
								<div class="col-sm-8">
									<p class="form-control-static">${fns:getDictLabel(crmCustomer.customerLevel, 'customer_level', '')}</p>
								</div>
							</div>
						</div>
					</div>
					
					<div class="row">
						<div class="col-sm-6">
							<div class="view-group">
								<label class="col-sm-4 control-label">首要联系人：</label>
								<div class="col-sm-8">
									<p class="form-control-static">${crmCustomer.contacterName}</p>
								</div>
							</div>
						</div>
						<div class="col-sm-6">
							<div class="view-group">
								<label class="col-sm-4 control-label">联系方式：</label>
								<div class="col-sm-8">
									<p class="form-control-static">${crmCustomer.mobile}</p>
								</div>
							</div>
						</div>
					</div>
					<h4 class="page-header">详细信息</h4>
					<div class="row">
						<div class="col-sm-6">
							<div class="view-group">
								<label class="col-sm-4 control-label">客户行业：</label>
								<div class="col-sm-8">
									<p class="form-control-static">${fns:getDictLabel(crmCustomer.industryType, 'industry_type', '')}</p>
								</div>
							</div>
						</div>
						<div class="col-sm-6">
							<div class="view-group">
								<label class="col-sm-4 control-label">客户来源：</label>
								<div class="col-sm-8">
									<p class="form-control-static">${fns:getDictLabel(crmCustomer.sourType, 'sour_type', '')}</p>
								</div>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-sm-6">
							<div class="view-group">
								<label class="col-sm-4 control-label">公司性质：</label>
								<div class="col-sm-8">
									<p class="form-control-static">${fns:getDictLabel(crmCustomer.natureType, 'nature_type', '')}</p>
								</div>
							</div>
						</div>
						<div class="col-sm-6">
							<div class="view-group">
								<label class="col-sm-4 control-label">企业规模：</label>
								<div class="col-sm-8">
									<p class="form-control-static">${fns:getDictLabel(crmCustomer.scaleType, 'scale_type', '')}</p>
								</div>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-sm-6">
							<div class="view-group">
								<label class="col-sm-4 control-label">公司电话：</label>
								<div class="col-sm-8">
									<p class="form-control-static">${crmCustomer.phone}</p>
								</div>
							</div>
						</div>
						<div class="col-sm-6">
							<div class="view-group">
								<label class="col-sm-4 control-label">公司传真：</label>
								<div class="col-sm-8">
									<p class="form-control-static">${crmCustomer.fax}</p>
								</div>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-sm-6">
							<div class="view-group">
								<label class="col-sm-4 control-label">公司地址：</label>
								<div class="col-sm-8">
									<p class="form-control-static">${crmCustomer.province}${crmCustomer.city}${crmCustomer.dict}</p>
								</div>
							</div>
						</div>
						<div class="col-sm-6">
							<div class="view-group">
								<label class="col-sm-4 control-label">详细地址：</label>
								<div class="col-sm-8">
									<p class="form-control-static">${crmCustomer.address}</p>
								</div>
							</div>
						</div>
					</div>
					
					<h4 class="page-header">联系提醒</h4>
					<div class="row">
						<div class="col-sm-6">
							<div class="view-group">
								<label class="col-sm-4 control-label">下次联系时间：</label>
								<div class="col-sm-8">
									<p class="form-control-static"><fmt:formatDate value="${crmCustomer.nextcontactDate}" pattern="yyyy-MM-dd"/></p>
								</div>
							</div>
						</div>
						<div class="col-sm-6">
							<div class="view-group">
								<label class="col-sm-4 control-label">下次联系内容：</label>
								<div class="col-sm-8">
									<p class="form-control-static">${crmCustomer.nextcontactNote}</p>
								</div>
							</div>
						</div>
					</div>
					<h4 class="page-header">操作信息</h4>
					<div class="row">
						<div class="col-sm-6">
							<div class="view-group">
								<label class="col-sm-4 control-label">负责人：</label>
								<div class="col-sm-8">
									<p class="form-control-static">${crmCustomer.ownBy.name}</p>
								</div>
							</div>
						</div>
						<div class="col-sm-6">
							<div class="view-group">
								<label class="col-sm-4 control-label">创建者：</label>
								<div class="col-sm-8">
									<p class="form-control-static">${crmCustomer.createBy.name}</p>
								</div>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-sm-6">
							<div class="view-group">
								<label class="col-sm-4 control-label">创建时间：</label>
								<div class="col-sm-8">
									<p class="form-control-static"><fmt:formatDate value="${crmCustomer.createDate}" pattern="yyyy-MM-dd"/></p>
								</div>
							</div>
						</div>
						<div class="col-sm-6">
							<div class="view-group">
								<label class="col-sm-4 control-label">最后更新时间：</label>
								<div class="col-sm-8">
									<p class="form-control-static"><fmt:formatDate value="${crmCustomer.updateDate}" pattern="yyyy-MM-dd"/></p>
								</div>
							</div>
						</div>
					</div>
					<h4 class="page-header">其他信息</h4>
					<div class="row">
						<div class="col-sm-6">
							<div class="view-group">
								<label class="col-sm-4 control-label">客户标签：</label>
								<div class="col-sm-8">
									<p class="form-control-static">${crmCustomer.tags}</p>
								</div>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-sm-6">
							<div class="view-group">
								<label class="col-sm-4 control-label">备注信息：</label>
								<div class="col-sm-8">
									<p class="form-control-static">${crmCustomer.remarks}</p>
								</div>
							</div>
						</div>
					</div>
					
				
				</form:form>
			</div>
		</div>
	 </div>
	 <div class="col-sm-3">
	 	<div class="ibox">
                    <div class="ibox-title">
                        <h5>动态信息</h5>
                    </div>
                    <div class="">
                    	<div id="vertical-timeline" class="vertical-container dark-timeline">
                        	<c:forEach items="${sysDynamicList }" var="sysDynamic">
                            	<div class="vertical-timeline-block">
                            		<div class="vertical-timeline-icon navy-bg">
                            		</div>
                            		<div class="vertical-timeline-content">
                            			<p class="small">
                            				${fns:getTimeDiffer(sysDynamic.createDate)}
                            			</p>
                            			<p class="m-b-xs">
                            				
                            				 ${sysDynamic.createBy.name} <i>${fns:getDictLabel(sysDynamic.actionType, 'action_type', '')}了</i> <strong>${fns:getDictLabel(sysDynamic.objectType, 'object_type', '')} </strong>
                            			</p>
                            			<p class="small">
                            				<a href="#" onclick="toView('${sysDynamic.objectType}','${sysDynamic.targetId}');">${sysDynamic.targetName}</a>
                            			</p>
                            			
                            		</div>
                            	</div>    	
                            </c:forEach>
                        </div>
                    </div>
                            
                </div>
	 </div>
</div>
</body>
</html>