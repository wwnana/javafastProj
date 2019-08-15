<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>应收款管理</title>
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
		function addRow(list, idx, tpl, row){
			$(list).append(Mustache.render(tpl, {
				idx: idx, delBtn: true, row: row
			}));
			$(list+idx).find("select").each(function(){
				$(this).val($(this).attr("data-value"));
			});
			$(list+idx).find("input[type='checkbox'], input[type='radio']").each(function(){
				var ss = $(this).attr("data-value").split(',');
				for (var i=0; i<ss.length; i++){
					if($(this).val() == ss[i]){
						$(this).attr("checked","checked");
					}
				}
			});
		}
		function delRow(obj, prefix){
			var id = $(prefix+"_id");
			var delFlag = $(prefix+"_delFlag");
			if (id.val() == ""){
				$(obj).parent().parent().remove();
			}else if(delFlag.val() == "0"){
				delFlag.val("1");
				$(obj).html("&divide;").attr("title", "撤销删除");
				$(obj).parent().parent().addClass("error");
			}else if(delFlag.val() == "1"){
				delFlag.val("0");
				$(obj).html("&times;").attr("title", "删除");
				$(obj).parent().parent().removeClass("error");
			}
		}
	</script>
</head>
<body class="gray-bg">
<div class="wrapper-content">
	<div class="ibox">
		<div class="ibox-title">
			<h5>应收款查看</h5>
		</div>
		<div class="ibox-content">
		<sys:message content="${message}"/>	
		
	<form:form id="inputForm" modelAttribute="fiReceiveAble" action="${ctx}/fi/fiReceiveAble/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		
	 <table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
		<tbody>

				<tr> 
					<td class="width-15 active"><label class="pull-right">单号：</label></td>
					<td class="width-35">
						${fiReceiveAble.no }
					</td>
					<td class="width-15 active"><label class="pull-right">状态：</label></td>
					<td class="width-35">
						${fns:getDictLabel(fiReceiveAble.status, 'finish_status', '')}
					</td>
				</tr>
				<tr>
					<td class="width-15 active"><label class="pull-right">合同订单：</label></td>
					<td class="width-35">
						<a href="${ctx}/om/omContract/index?id=${fiReceiveAble.order.id}">${fiReceiveAble.order.no}</a>
					</td>
					<td class="width-15 active"><label class="pull-right">客户：</label></td>
					<td class="width-35">
							${fiReceiveAble.customer.name } 
					</td>
				</tr>
				<tr>
					<td class="width-15 active"><label class="pull-right">应收金额：</label></td>
					<td class="width-35">
						${fiReceiveAble.amount }	
					</td>
				 
					<td class="width-15 active"><label class="pull-right">实际已收：</label></td>
					<td class="width-35">
						${fiReceiveAble.realAmt }	
					</td>
				</tr>
				<tr>
					<td class="width-15 active"><label class="pull-right">应收时间：</label></td>
					<td class="width-35">
						<fmt:formatDate value="${fiReceiveAble.ableDate}" pattern="yyyy-MM-dd"/>
					</td>
					<td class="width-15 active"><label class="pull-right">负责人：</label></td>
					<td class="width-35">
						${fiReceiveAble.ownBy.name}
					</td>
					
				</tr>
				<tr> 
					<td class="width-15 active"><label class="pull-right">备注：</label></td>
					<td class="width-35" colspan="3">
						${fiReceiveAble.remarks }
					</td>
				</tr>
			</tbody>
		</table>
		<!-- 明细 -->
		<div class="tabs-container">
	    	<ul class="nav nav-tabs">
				<li class="active">
					<a data-toggle="tab" href="#tab-1" aria-expanded="true">收款单</a>
	            </li>					
	        </ul>
        	<div class="tab-content">
          	   	<div class="panel-body">
					<div id="tab-1" class="tab-pane table-responsive active">
					<table id="contentTable" class="table table-striped table-bordered table-hover table-condensed">
						<thead>
							<tr>
								<th class="hide"></th>
								<th>单号</th>
								<th>客户</th>
								<th>收款金额</th>
								<th>收款时间</th>
								<th>收款账户</th>
								<th>收款人</th>
								<th>是否开票</th>
								<th>开票金额</th>
								<th>状态</th>
								<th>备注</th>
								
							</tr>
						</thead>
						<tbody>
							<c:forEach items="${fiReceiveAble.fiReceiveBillList}" var="fiReceiveBill">
								<tr>
									<td>
										${fiReceiveBill.no}
									</td>
									<td>
										${fiReceiveBill.customer.name}
									</td>
									<td>
										${fiReceiveBill.amount}
									</td>
									<td>
										<fmt:formatDate value="${fiReceiveBill.dealDate}" pattern="yyyy-MM-dd"/>
									</td>
									<td>
										${fiReceiveBill.fiAccount.name}
									</td>
									<td>
										${fiReceiveBill.ownBy.name}
									</td>
									<td>
										${fns:getDictLabel(fiReceiveBill.isInvoice, 'yes_no', '')}
									</td>
									<td>
										${fiReceiveBill.invoiceAmt}
									</td>
									
									<td>
										${fns:getDictLabel(fiReceiveBill.status, 'audit_status', '')}
									</td>
									<td>
										${fiReceiveBill.remarks}
									</td>
								</tr>
							</c:forEach>
						</tbody>
						</table>
						<c:if test="${fiReceiveAble.status != 2}">
							<shiro:hasPermission name="fi:fiReceiveBill:add">
		   						<a href="#" onclick="openDialog('添加收款单', '${ctx}/fi/fiReceiveBill/form?fiReceiveAble.id=${fiReceiveAble.id}&fiReceiveAble.name=${fiReceiveAble.no}&customer.id=${fiReceiveAble.customer.id}&customer.name=${fiReceiveAble.customer.name}','800px', '500px')" class="btn btn-success" title="添加收款单"><i class="fa fa-plus"></i>
								<span class="hidden-xs">添加收款单</span></a>
							</shiro:hasPermission>
						</c:if>
					</div>
				</div>
			</div>
		</div>
		<br>
				<div class="form-actions">
					
					<c:if test="${fiReceiveAble.status != 2}">
						<shiro:hasPermission name="fi:fiReceiveAble:edit">
	    					<a href="#" onclick="openDialog('修改应收时间', '${ctx}/fi/fiReceiveAble/editForm?id=${fiReceiveAble.id}','800px', '500px')" class="btn btn-success" title="修改应收时间">修改应收时间</a>
						</shiro:hasPermission>
					</c:if>			
					
					<input id="btnCancel" class="btn btn-white" type="button" value="返 回" onclick="history.go(-1)"/>
				</div>
			<br>
	</form:form>
</div></div></div>
</body>
</html>