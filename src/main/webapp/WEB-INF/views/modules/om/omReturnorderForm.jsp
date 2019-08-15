<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>销售退单管理</title>
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
			<h5>退货单${not empty omOrder.id?'修改':'添加'}</h5>
		</div>
		<div class="ibox-content">
		<sys:message content="${message}"/>	
		<form:form id="inputForm" modelAttribute="omReturnorder" action="${ctx}/om/omReturnorder/save" method="post" class="form-horizontal">
			<form:hidden path="id"/>
			<form:hidden path="status"/>
			
			<h4 class="page-header">基本信息</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 单号</label>
						<div class="col-sm-8">
							<form:input path="no" htmlEscape="false" maxlength="30" class="form-control required"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 销售类型</label>
						<div class="col-sm-8">
							<form:select path="saleType" class="form-control required">
								<form:option value="" label=""/>
								<form:options items="${fns:getDictList('sale_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 客户</label>
						<div class="col-sm-8">
							<sys:tableselect id="customer" name="customer.id" value="${omReturnorder.customer.id}" labelName="customer.name" labelValue="${omReturnorder.customer.name}" 
						title="客户" url="${ctx}/crm/crmCustomer/selectList" cssClass="form-control required" dataMsgRequired=""  allowClear="false" allowInput="false"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 关联销售订单</label>
						<div class="col-sm-8">
							<sys:tableselect id="order" name="order.id" value="${omReturnorder.order.id}" labelName="order.name" labelValue="${omReturnorder.order.name}" 
								title="订单" url="${ctx}/om/omOrder/selectList" cssClass="form-control required" dataMsgRequired=""  allowClear="true" allowInput="false"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 经办人</label>
						<div class="col-sm-8">
							<sys:treeselect id="dealBy" name="dealBy.id" value="${omReturnorder.dealBy.id}" labelName="dealBy.name" labelValue="${omReturnorder.dealBy.name}"
								title="用户" url="/sys/office/treeData?type=3" cssClass="form-control required" allowClear="true" notAllowSelectParent="true"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 业务日期</label>
						<div class="col-sm-8">
							<div class="input-group date datepicker">
								<input name="dealDate" type="text" readonly="readonly" class="form-control required" value="<fmt:formatDate value="${omReturnorder.dealDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
	                     		<span class="input-group-addon">
	                             	<span class="fa fa-calendar"></span>
	                     		</span>
                     		</div>
						</div>
					</div>
				</div>
			</div>
			
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 实退金额</label>
						<div class="col-sm-8">
							<form:input path="actualAmt" htmlEscape="false" class="form-control number required" min="0.01" max="${omReturnorder.amount }"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 结算账户</label>
						<div class="col-sm-8">
							<sys:spinnerselect id="fiAccount" name="fiAccount.id" value="${omReturnorder.fiAccount.id}" labelName="fiAccount.name" labelValue="${omReturnorder.fiAccount.name}" 
							title="结算账户" url="${ctx}/fi/fiFinanceAccount/getSelectData" cssClass="form-control required"></sys:spinnerselect>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 入库仓库</label>
						<div class="col-sm-8">
							<sys:spinnerselect id="warehouse" name="warehouse.id" value="${omReturnorder.warehouse.id}" labelName="warehouse.name" labelValue="${omReturnorder.warehouse.name}" 
							title="入库仓库" url="${ctx}/wms/wmsWarehouse/getSelectData" cssClass="form-control required"></sys:spinnerselect>
						</div>
					</div>
				</div>
				
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-2 control-label">备注</label>
						<div class="col-sm-10">
							<form:textarea path="remarks" htmlEscape="false" rows="2" maxlength="50" class="form-control "/>
						</div>
					</div>
				</div>
			</div>
			
				
		
		
			<h4 class="page-header">销售退单明细</h4>
		
			
					<table id="contentTable" class="table table-striped table-bordered table-hover table-condensed">
						<thead>
							<tr>
								<th class="hide"></th>
								<th>产品</th>
								<th>单位</th>	
								<th>单价(元)</th>
								<th>退货数量</th>
								<th>金额(元)</th>
								
								<th>备注</th>
								<shiro:hasPermission name="om:omReturnorder:edit"><th width="10">&nbsp;</th></shiro:hasPermission>
							</tr>
						</thead>
						<tbody id="omReturnorderDetailList">
						</tbody>
						<shiro:hasPermission name="om:omReturnorder:edit"><tfoot>
							<tr><td colspan="9"><a href="javascript:" onclick="addRow('#omReturnorderDetailList', omReturnorderDetailRowIdx, omReturnorderDetailTpl);omReturnorderDetailRowIdx = omReturnorderDetailRowIdx + 1;" class="btn">新增</a></td></tr>
						</tfoot></shiro:hasPermission>
					</table>
					<script type="text/template" id="omReturnorderDetailTpl">//<!--
						<tr id="omReturnorderDetailList{{idx}}">
							<td class="hide">
								<input id="omReturnorderDetailList{{idx}}_id" name="omReturnorderDetailList[{{idx}}].id" type="hidden" value="{{row.id}}"/>
								<input id="omReturnorderDetailList{{idx}}_delFlag" name="omReturnorderDetailList[{{idx}}].delFlag" type="hidden" value="0"/>
								<input id="omReturnorderDetailList{{idx}}_sort" name="omReturnorderDetailList[{{idx}}].sort" type="hidden" value="{{idx}}"/>
							</td>
							<td>
								<wms:productselect id="omReturnorderDetailList{{idx}}_product" name="omReturnorderDetailList[{{idx}}].product.id" value="{{row.product.id}}" labelName="omReturnorderDetailList[{{idx}}].product.name" labelValue="{{row.product.name}}" 
										title="产品" url="${ctx}/wms/wmsProduct/selectList" cssClass="form-control input-xlarge required" dataMsgRequired="必选"  allowClear="false" allowInput="false"/>
							</td>
							<td>								
								<input id="omReturnorderDetailList{{idx}}_unitType" name="omReturnorderDetailList[{{idx}}].unitType" type="text" value="{{row.unitType}}" maxlength="11" class="form-control input-mini" style="border:0;"/>
							</td>
							<td>
								<input id="omReturnorderDetailList{{idx}}_price" name="omReturnorderDetailList[{{idx}}].price" type="text" value="{{row.price}}" maxlength="11" min="0.01" class="form-control input-mini required number" onkeyup="checkInputPrice({{idx}})"/>
							</td>
							<td>
								<input id="omReturnorderDetailList{{idx}}_num" name="omReturnorderDetailList[{{idx}}].num" type="text" value="{{row.num}}" maxlength="11" min="1" class="form-control input-mini required digits" onkeyup="checkInputNum({{idx}})"/>
							</td>
							<td>
								<input id="omReturnorderDetailList{{idx}}_amount" name="omReturnorderDetailList[{{idx}}].amount" type="text" value="{{row.amount}}" class="form-control input-mini required" readonly="true"/>
							</td>
							
							<td>
								<input id="omReturnorderDetailList{{idx}}_remarks" name="omReturnorderDetailList[{{idx}}].remarks" type="text" value="{{row.remarks}}" maxlength="50" class="form-control input-small "/>
							</td>
							<shiro:hasPermission name="om:omReturnorder:edit"><td class="text-center" width="10">
								{{#delBtn}}<span class="close" onclick="delRow(this, '#omReturnorderDetailList{{idx}}')" title="删除">&times;</span>{{/delBtn}}
							</td></shiro:hasPermission>
						</tr>//-->
					</script>
					<script type="text/javascript">
						var omReturnorderDetailRowIdx = 0, omReturnorderDetailTpl = $("#omReturnorderDetailTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g,"");
						$(document).ready(function() {
							var data = ${fns:toJson(omReturnorder.omReturnorderDetailList)};
							for (var i=0; i<data.length; i++){
								addRow('#omReturnorderDetailList', omReturnorderDetailRowIdx, omReturnorderDetailTpl, data[i]);
								omReturnorderDetailRowIdx = omReturnorderDetailRowIdx + 1;
							}
						});
						//单价输入事件
						function checkInputPrice(index){
							comAmt(index);
						}
						
						//数量输入事件
						function checkInputNum(index){
							comAmt(index);
						}
							
						
						//其他费用输入事件
						function checkInputOtherAmt(){
							comTotalAmount();
						}
						
						//计算金额和合计金额
						function comAmt(index){
							
							var price = $("#omReturnorderDetailList"+index+"_price").val();
							var num = $("#omReturnorderDetailList"+index+"_num").val();
							
							if(price != null && price != '' && !isNaN(price) && num != null && num != '' && !isNaN(num)){								
								$("#omReturnorderDetailList"+index+"_amount").val(price * num);
							}
							
							
							
							comTotalAmount();
						}
						
						
						
						//计算总计金额
						function comTotalAmount(){
							var total_num = 0;//总数量
							var total_amt = 0;//金额总计
							var other_amt = 0;//其他费用
							var order_amt = 0;//订单总金额
							
							var mytable = document.getElementById("contentTable");
							for(var i=0; i<mytable.rows.length-2; i++){
								
								var num = $("#omReturnorderDetailList"+i+"_num").val();
								if(num != null && num != '' && !isNaN(num)){
									total_num += parseInt(num);
								}
								
								var amount = $("#omReturnorderDetailList"+i+"_amount").val();
								if(amount != null && amount != '' && !isNaN(amount)){
									total_amt += parseFloat(amount);
								}
								
								
							}
							$("#num").val(total_num);
							$("#totalAmt").val(total_amt);
							var otherAmt = $("#otherAmt").val();
							if(otherAmt != null && otherAmt != '' && !isNaN(otherAmt)){
								other_amt = parseFloat(otherAmt);
							}
							$("#otherAmt").val(other_amt);
							$("#amount").val(total_amt + other_amt);
						}
					</script>
					<div class="pull-right">
					总退货数量：<form:input path="num" htmlEscape="false" class="form-control input-mini" readonly="true" style="border:0;"/>
					总计：<form:input path="totalAmt" htmlEscape="false" class="form-control input-mini" readonly="true" style="border:0;"/>
					其他费用:<form:input path="otherAmt" htmlEscape="false" maxlength="10" min="0" class="form-control input-mini number" onkeyup="checkInputOtherAmt()"  style="border-top:0;border-left:0;border-right:0;"/>
					总金额：<form:input path="amount" htmlEscape="false" class="form-control input-mini" readonly="true" style="border:0;"/>
					
					</div>
				
				
			
			<br><br>
			<div class="hr-line-dashed"></div>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<div class="col-sm-offset-2 col-sm-10">
							<button id="btnSubmit" class="btn btn-success" type="submit">保存</button>&nbsp;
							<button id="btnCancel" class="btn btn-white" type="button" onclick="history.go(-1)">返回</button>
						</div>
					</div>
				</div>
			</div>
			
		
	</form:form>
	</div></div></div>
</body>
</html>