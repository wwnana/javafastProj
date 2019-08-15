<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>采购单管理</title>
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
			<h5>采购单${not empty wmsPurchase.id?'修改':'添加'}</h5>
		</div>
		<div class="ibox-content">
		<sys:message content="${message}"/>	
	<form:form id="inputForm" modelAttribute="wmsPurchase" action="${ctx}/wms/wmsPurchase/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		
	<div class="row">
			<div class="col-sm-12">
				<div class="text-center p-lg">
	            	<h2>采购单</h2>
	            </div>
			</div>
		</div>
	 <table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
		<tbody>
			<tr>
				</tr>
				<tr> 
					<td class="width-15 active"><label class="pull-right">单号：</label></td>
					<td class="width-35">
							<form:input path="no" htmlEscape="false" maxlength="30" class="form-control input-xlarge required"/>
							<span class="help-inline"><font color="red">*</font> </span>
						</td>
					<td class="width-15 active"><label class="pull-right">供应商：</label></td>
					<td class="width-35">
						
						<sys:tableselect id="supplier" name="supplier.id" value="${wmsPurchase.supplier.id}" labelName="supplier.name" labelValue="${wmsPurchase.supplier.name}" 
						title="供应商" url="${ctx}/wms/wmsSupplier/selectList" cssClass="form-control input-xlarge required" dataMsgRequired="必选"  allowClear="false" allowInput="false"/>
							<span class="help-inline"><font color="red">*</font> </span>
						
					</td>
				</tr>
				
				<tr> 
					<td class="width-15 active"><label class="pull-right">经办人：</label></td>
					<td class="width-35">
							<sys:treeselect id="dealBy" name="dealBy.id" value="${wmsPurchase.dealBy.id}" labelName="dealBy.name" labelValue="${wmsPurchase.dealBy.name}"
								title="用户" url="/sys/office/treeData?type=3" cssClass="form-control input-xlarge required" allowClear="true" notAllowSelectParent="true"/>
								<span class="help-inline"><font color="red">*</font> </span>
						</td>
					<td class="width-15 active"><label class="pull-right">业务日期：</label></td>
					<td class="width-35">
							<input name="dealDate" type="text" readonly="readonly" maxlength="20" class="laydate-icon form-control layer-date"
								value="<fmt:formatDate value="${wmsPurchase.dealDate}" pattern="yyyy-MM-dd"/>"
								onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
						</td>
				</tr>
				
				
				<c:if test="${wmsPurchase.status == 1}">
				<tr> 
					<td class="width-15 active"><label class="pull-right">制单人：</label></td>
					<td class="width-35">
							${wmsPurchase.createBy.name}
						</td>
					<td class="width-15 active"><label class="pull-right">制单时间：</label></td>
					<td class="width-35">
							<fmt:formatDate value="${wmsPurchase.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
					</td>
				</tr>
				<tr> 
					
					<td class="width-15 active"><label class="pull-right">审核状态：</label></td>
					<td class="width-35">
							${fns:getDictLabel(wmsPurchase.status, 'audit_status', '')}
					</td>
					<td class="width-15 active"><label class="pull-right"></label></td>
					<td class="width-35">
							
					</td>
				</tr>
				
				
				<tr> 
					<td class="width-15 active"><label class="pull-right">审核人：</label></td>
					<td class="width-35">
							${wmsPurchase.auditBy.name}
						</td>
					<td class="width-15 active"><label class="pull-right">审核时间：</label></td>
					<td class="width-35">
							<fmt:formatDate value="${wmsPurchase.auditDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
						</td>
				</tr>
				</c:if>
				<tr> 
					<td class="width-15 active"><label class="pull-right">备注：</label></td>
					<td class="width-35" colspan="3">
							<form:textarea path="remarks" htmlEscape="false" rows="2" maxlength="50" class="form-control input-xxlarge"/>
						</td>
				</tr>
			</tbody>
		</table>
			<div class="tabs-container">
	            <ul class="nav nav-tabs">
					<li class="active"><a data-toggle="tab" href="#tab-1" aria-expanded="true">采购单明细</a>
	                </li>
					
	            </ul>
          	   <div class="tab-content">
          	   	<div class="panel-body">
					<div id="tab-1" class="tab-pane table-responsive active">
					<table id="contentTable" class="table table-striped table-bordered table-hover table-condensed">
						<thead>
							<tr>
								<th class="hide"></th>
								<th>产品</th>
								<th>单位</th>							
								<th>单价(元)</th>
								<th>数量</th>
								<th>金额(元)</th>
								<th>税率(%)</th>
								<th>税额(元)</th>
								<th>备注</th>
								<shiro:hasPermission name="wms:wmsPurchase:edit"><th width="10">&nbsp;</th></shiro:hasPermission>
							</tr>
						</thead>
						<tbody id="wmsPurchaseDetailList">
						</tbody>
						<shiro:hasPermission name="wms:wmsPurchase:edit"><tfoot>
							<tr><td colspan="8"><a href="javascript:" onclick="addRow('#wmsPurchaseDetailList', wmsPurchaseDetailRowIdx, wmsPurchaseDetailTpl);wmsPurchaseDetailRowIdx = wmsPurchaseDetailRowIdx + 1;" class="btn">新增</a></td></tr>
						</tfoot></shiro:hasPermission>
					</table>
					
					<%--			
					<input id="wmsPurchaseDetailList{{idx}}_product" name="wmsPurchaseDetailList[{{idx}}].product.id" type="text" value="{{row.product.id}}" maxlength="30" class="form-control input-small required"/>
						--%>	
						
					<script type="text/template" id="wmsPurchaseDetailTpl">//<!--
						<tr id="wmsPurchaseDetailList{{idx}}">
							<td class="hide">
								<input id="wmsPurchaseDetailList{{idx}}_id" name="wmsPurchaseDetailList[{{idx}}].id" type="hidden" value="{{row.id}}"/>
								<input id="wmsPurchaseDetailList{{idx}}_delFlag" name="wmsPurchaseDetailList[{{idx}}].delFlag" type="hidden" value="0"/>
							</td>
							<td>
					
								<wms:productselect id="wmsPurchaseDetailList{{idx}}_product" name="wmsPurchaseDetailList[{{idx}}].product.id" value="{{row.product.id}}" labelName="wmsPurchaseDetailList[{{idx}}].product.name" labelValue="{{row.product.name}}" 
										title="产品" url="${ctx}/wms/wmsProduct/selectListForPur" cssClass="form-control input-xlarge required search-icon" dataMsgRequired="必选"  allowClear="false" allowInput="false"/>

							</td>
							<td>								
								<input id="wmsPurchaseDetailList{{idx}}_unitType" name="wmsPurchaseDetailList[{{idx}}].unitType" type="text" value="{{row.unitType}}" maxlength="11" class="form-control input-mini" style="border:0;"/>
							</td>
							<td>
								<input id="wmsPurchaseDetailList{{idx}}_price" name="wmsPurchaseDetailList[{{idx}}].price" type="text" value="{{row.price}}" min="0.01" maxlength="11" class="form-control input-mini required number" onkeyup="checkInputPrice({{idx}})"/>
							</td>
							<td>
								<input id="wmsPurchaseDetailList{{idx}}_num" name="wmsPurchaseDetailList[{{idx}}].num" type="text" value="{{row.num}}" min="1" maxlength="11" class="form-control input-mini required digits" onkeyup="checkInputNum({{idx}})"/>
							</td>
							<td>
								<input id="wmsPurchaseDetailList{{idx}}_amount" name="wmsPurchaseDetailList[{{idx}}].amount" type="text" value="{{row.amount}}" class="form-control input-mini required" readonly="true"/>
							</td>
							<td>
								<input id="wmsPurchaseDetailList{{idx}}_taxRate" name="wmsPurchaseDetailList[{{idx}}].taxRate" type="text" value="{{row.taxRate}}" min="0" max="100" maxlength="5" class="form-control input-mini number required" onkeyup="checkInputTaxRate({{idx}})"/>
							</td>
							<td>
								<input id="wmsPurchaseDetailList{{idx}}_taxAmt" name="wmsPurchaseDetailList[{{idx}}].taxAmt" type="text" value="{{row.taxAmt}}" class="form-control input-mini required" readonly="true"/>
							</td>
							<td>
								<input id="wmsPurchaseDetailList{{idx}}_remarks" name="wmsPurchaseDetailList[{{idx}}].remarks" type="text" value="{{row.remarks}}" maxlength="50" class="form-control input-small "/>
							</td>



							<shiro:hasPermission name="wms:wmsPurchase:edit"><td class="text-center" width="10">
								{{#delBtn}}<span class="close" onclick="delRow(this, '#wmsPurchaseDetailList{{idx}}')" title="删除">&times;</span>{{/delBtn}}
							</td></shiro:hasPermission>
						</tr>//-->
					</script>
					<script type="text/javascript">
						var wmsPurchaseDetailRowIdx = 0, wmsPurchaseDetailTpl = $("#wmsPurchaseDetailTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g,"");
						$(document).ready(function() {
							var data = ${fns:toJson(wmsPurchase.wmsPurchaseDetailList)};
							for (var i=0; i<data.length; i++){
								addRow('#wmsPurchaseDetailList', wmsPurchaseDetailRowIdx, wmsPurchaseDetailTpl, data[i]);
								wmsPurchaseDetailRowIdx = wmsPurchaseDetailRowIdx + 1;
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
							
						//税率输入事件
						function checkInputTaxRate(index){
							comAmt(index);
						}
						
						//其他费用输入事件
						function checkInputOtherAmt(){
							comTotalAmount();
						}
						
						//计算金额和合计金额
						function comAmt(index){
							
							var price = $("#wmsPurchaseDetailList"+index+"_price").val();
							var num = $("#wmsPurchaseDetailList"+index+"_num").val();
							
							if(price != null && price != '' && !isNaN(price) && num != null && num != '' && !isNaN(num)){								
								$("#wmsPurchaseDetailList"+index+"_amount").val(price * num);
							}
							
							var taxRate = $("#wmsPurchaseDetailList"+index+"_taxRate").val();
							var amount = $("#wmsPurchaseDetailList"+index+"_amount").val();
							if(taxRate != null && taxRate != '' && !isNaN(taxRate) && amount != null && amount != '' && !isNaN(amount)){								
								var taxAmt = taxRate * amount /100;
								$("#wmsPurchaseDetailList"+index+"_taxAmt").val(taxAmt.toFixed(2));
							}
							
							comTotalAmount();
						}
						
						//计算总计金额
						function comTotalAmount(){
							var total_amt = 0;//金额总计
							var tax_amt = 0;//税额合计
							var other_amt = 0;//其他费用
							var order_amt = 0;//订单总金额
							var order_num = 0;//总数量
							
							var mytable = document.getElementById("contentTable");
							for(var i=0; i<mytable.rows.length-2; i++){
								
								var amount = $("#wmsPurchaseDetailList"+i+"_amount").val();
								if(amount != null && amount != '' && !isNaN(amount)){
									total_amt += parseFloat(amount);
								}
								
								var taxAmt = $("#wmsPurchaseDetailList"+i+"_taxAmt").val();
								if(taxAmt != null && taxAmt != '' && !isNaN(taxAmt)){
									tax_amt += parseFloat(taxAmt);
								}
								
								var num = $("#wmsPurchaseDetailList"+i+"_num").val();
								if(num != null && num != '' && !isNaN(num)){
									order_num += parseInt(num);
								}
							}
							
							$("#totalAmt").val(total_amt);
							$("#taxAmt").val(tax_amt);
							var otherAmt = $("#otherAmt").val();
							if(otherAmt != null && otherAmt != '' && !isNaN(otherAmt)){
								other_amt = parseFloat(otherAmt);
							}
							$("#amount").val(total_amt + tax_amt + other_amt);
							$("#num").val(order_num);
						}
					</script>
					<div class="pull-right">
						总数量：<form:input path="num" htmlEscape="false" maxlength="11" class="form-control input-mini digits required" readonly="true" style="border:0;"/>
						金额总计：<form:input path="totalAmt" value="${wmsPurchase.totalAmt}" htmlEscape="false" class="form-control input-mini required" readonly="true" style="border:0;"/>
						税额：<form:input path="taxAmt" value="${wmsPurchase.taxAmt}" htmlEscape="false" class="form-control input-mini" readonly="true" style="border:0;"/>
						其他费用：<form:input path="otherAmt" value="${wmsPurchase.otherAmt}" htmlEscape="false" min="0" maxlength="10" class="form-control input-mini number" onkeyup="checkInputOtherAmt()"  style="border-top:0;border-left:0;border-right:0;"/>
						总金额：<form:input path="amount" value="${wmsPurchase.amount}" htmlEscape="false" class="form-control input-mini required" readonly="true" style="border:0;"/>
						
					</div>
				
				</div>
				</div>
			</div>
			</div>
	<br>
				<div class="form-actions">
					<shiro:hasPermission name="wms:wmsPurchase:edit"><input id="btnSubmit" class="btn btn-success" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
					<input id="btnCancel" class="btn btn-white" type="button" value="返 回" onclick="history.go(-1)"/>
				</div>
			<br>
	</form:form>
</div></div></div>
</body>
</html>