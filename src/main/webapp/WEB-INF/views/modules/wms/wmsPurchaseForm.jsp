<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>采购单管理</title>
	<meta name="decorator" content="default"/>
	<script src="${ctxStatic}/jquery-validation/jQueryValidateExtend.js" type="text/javascript"></script>
	<script type="text/javascript">
		var validateForm;
		var pList = ",";
		//自定义检查表身方法
		function checkChildren(){
			if($("#wmsPurchaseDetailList tr").length == 0){
				$("#tablerror").remove();
				if($("#tablerror").length == 0){
					var errorHtml = "<tr id='tablerror'><td  colspan='6'><label  " 
						+ "class='error'>必须添加明细</label><span class='help-inline'>"
						+ "<font color='red'>*</font> </span></td></tr>";
					$("#contentTable tfoot").find("tr:eq(0)").before(errorHtml);
				}
			}else{
				if($("#tablerror").length > 0){
					$("#tablerror").remove();
				}
			}
			if($("#tablerror").length > 0){
				return false;
			}else{
				return true;
			}
		}
		
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
					if(checkChildren()){
						//重新计算总数量 防止有时候没触发到事件
						comInput();						
						loading('正在提交，请稍等...');
						form.submit();
					}
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
		function addRow2(list, idx, tpl, row){
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
		function delRow2(obj, prefix){
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
		
		//数据添加
		function setParamsByItems(item){
			
			//产品信息
			var myGo = {};
			myGo['id'] = item.children("td").eq(0).find("input").attr("id");
			myGo['name'] = item.children("td").eq(2).html();		
			myGo['spec'] = item.children("td").eq(3).html();
			myGo['unitType'] = item.children("td").eq(4).html();
			myGo['price'] = item.children("td").eq(5).html();
			
			var singleP = {};
			singleP["product"] = myGo;
			singleP["unitType"] = myGo['unitType'];
			singleP["spec"] = myGo['spec'];
			singleP["price"] = myGo['price'];			
			singleP["num"] = '1';
			
			if(checkRepeat(myGo['id'], myGo['name']) == 0){
				var chsub = $("#contentTable tbody tr").length;
				addRow('#wmsPurchaseDetailList', wmsPurchaseDetailRowIdx, wmsPurchaseDetailTpl, singleP);
				wmsPurchaseDetailRowIdx = wmsPurchaseDetailRowIdx + 1;
			}
		}
		
		//校验是否重复
		function checkRepeat(id, name){
			var repeatNum = 0;
			var mytable = document.getElementById("contentTable");
			for(var i=0; i<mytable.rows.length; i++){
				
				//判断元素是否存在
				if($("#wmsPurchaseDetailList"+i+"_product").length > 0) {
					
					var pid = $("#wmsPurchaseDetailList"+i+"_product").val();
					if(pid == id){
						alert("产品：" + name + " 重复选择");
						repeatNum ++;
					}
				}								
			}
			return repeatNum;
		}
		
		function addRow(list, idx, tpl, row){
			$(list).append(Mustache.render(tpl, {
				idx: idx, delBtn: true, row: row
			}));
			
			//直接以tr的长度来添加
			$(list+idx).find("[id='sortInd"+ idx +"']").html($("#contentTable tbody tr").length);
			
			
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

			//重新计算
			comInput();
		}
		
		
		function delRow(obj, prefix){
			var id = $(prefix+"_id");
			
			//删除的id记录
			if(pList.length > 0){
				var tid = $(id).val();
				if(tid.length > 0){
					pList = pList + tid + ",";
				}
			}
			$("input[name='delSelectIds']").val(pList);
			
			//修复后面的序号
			var sortnum = $(prefix).find("[id^='sortInd']").text();
			$(prefix).parent().find("[id^='sortInd']").each(function(){
				if(parseInt($(this).text()) > sortnum){
					$(this).text(parseInt($(this).text()) - 1);
				} 
			});
			//删除
			$(prefix).remove();
			//重点 更新新增的rowid值
			var tSortNum = $("#contentTable tbody tr");
			if(! (tSortNum.length > 0)){
				wmsPurchaseDetailRowIdx = 0;
			}

			//重新计算
			comInput();			
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
			<h4 class="page-header">基本信息</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 单号</label>
						<div class="col-sm-7">
							<form:input path="no" htmlEscape="false" maxlength="30" class="form-control required"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 供应商</label>
						<div class="col-sm-7">
							<sys:tableselect id="supplier" name="supplier.id" value="${wmsPurchase.supplier.id}" labelName="supplier.name" labelValue="${wmsPurchase.supplier.name}" 
							title="供应商" url="${ctx}/wms/wmsSupplier/selectList" cssClass="form-control required" dataMsgRequired="必选"  allowClear="false" allowInput="false"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 经办人</label>
						<div class="col-sm-7">
							<sys:treeselect id="dealBy" name="dealBy.id" value="${wmsPurchase.dealBy.id}" labelName="dealBy.name" labelValue="${wmsPurchase.dealBy.name}"
								title="用户" url="/sys/office/treeData?type=3" cssClass="form-control required" allowClear="true" notAllowSelectParent="true"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 业务日期</label>
						<div class="col-sm-7">
								<div class="input-group date datepicker">
									<input name="dealDate" type="text" readonly="readonly" class="form-control required" value="<fmt:formatDate value="${wmsPurchase.dealDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
		                     		<span class="input-group-addon">
		                             	<span class="fa fa-calendar"></span>
		                     		</span>
	                     		</div>
						</div>
					</div>
				</div>
			</div>
			<c:if test="${wmsPurchase.status == 1}">
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label">制单人</label>
						<div class="col-sm-7">
							${wmsPurchase.createBy.name}
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label">制单时间</label>
						<div class="col-sm-7">
							<fmt:formatDate value="${wmsPurchase.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label">审核状态</label>
						<div class="col-sm-7">
							${fns:getDictLabel(wmsPurchase.status, 'audit_status', '')}
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"></label>
						<div class="col-sm-7">
							
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label">审核人</label>
						<div class="col-sm-7">
							${wmsPurchase.auditBy.name}
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label">审核时间</label>
						<div class="col-sm-7">
							<fmt:formatDate value="${wmsPurchase.auditDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
						</div>
					</div>
				</div>
			</div>
			</c:if>
			<h4 class="page-header">采购单明细</h4>
			
					<table id="contentTable" class="table table-striped table-bordered table-hover table-condensed">
						<thead>
							<tr>
								<th class="hide"></th>
								<th>产品</th>
								<th>规格</th>
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
							<tr>
								<td colspan="10">
									<%-- 
									<a href="javascript:" onclick="addRow('#wmsPurchaseDetailList', wmsPurchaseDetailRowIdx, wmsPurchaseDetailTpl);wmsPurchaseDetailRowIdx = wmsPurchaseDetailRowIdx + 1;" class="btn">新增</a>
									--%>
									<wms:manyselect id="wmsPurchaseDetailTag" name="wmsPurchaseDetailTag" value="选择"
										title="产品列表（可多选）" url="${ctx}/wms/wmsProduct/selectListForPur" 
										cssClass="btn"  allowClear="false" 
										allowInput="false" checkRepeat="true"/>
									<input name="delSelectIds" type="hidden" />
								</td>
							</tr>
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
								<input id="wmsPurchaseDetailList{{idx}}_sort" name="wmsPurchaseDetailList[{{idx}}].sort" type="hidden" value="{{idx}}"/>
							</td>
							<td>
								
								<input id="wmsPurchaseDetailList{{idx}}_product" name="wmsPurchaseDetailList[{{idx}}].product.id" type="hidden" value="{{row.product.id}}"/>
								<input id="wmsPurchaseDetailList{{idx}}_name" name="wmsPurchaseDetailList[{{idx}}].product.name" type="text" value="{{row.product.name}}"  class="input required" readonly="true"/>
								<span class="help-inline"><font color="red">*</font> </span>

								<%--
								<wms:productselect id="wmsPurchaseDetailList{{idx}}_product" name="wmsPurchaseDetailList[{{idx}}].product.id" value="{{row.product.id}}" labelName="wmsPurchaseDetailList[{{idx}}].product.name" labelValue="{{row.product.name}}" 
										title="产品" url="${ctx}/wms/wmsProduct/selectListForPur" cssClass="form-control input-xlarge required search-icon" dataMsgRequired="必选"  allowClear="false" allowInput="false"/>
								--%>
							</td>
							<td>								
								<input id="wmsPurchaseDetailList{{idx}}_spec" name="wmsPurchaseDetailList[{{idx}}].product.spec" type="text" value="{{row.product.spec}}" maxlength="11" class="form-control input-mini" style="border:0;"/>
							</td>
							<td>								
								<input id="wmsPurchaseDetailList{{idx}}_unitType" name="wmsPurchaseDetailList[{{idx}}].unitType" type="text" value="{{row.unitType}}" maxlength="11" class="form-control input-mini" style="border:0;"/>
							</td>
							<td>
								<input id="wmsPurchaseDetailList{{idx}}_price" name="wmsPurchaseDetailList[{{idx}}].price" type="text" value="{{row.price}}" min="0.01" maxlength="11" class="form-control input-mini required number" onkeyup="comInput()"/>
							</td>
							<td>
								<input id="wmsPurchaseDetailList{{idx}}_num" name="wmsPurchaseDetailList[{{idx}}].num" type="text" value="{{row.num}}" min="1" maxlength="11" class="form-control input-mini required digits" onkeyup="comInput()"/>
							</td>
							<td>
								<input id="wmsPurchaseDetailList{{idx}}_amount" name="wmsPurchaseDetailList[{{idx}}].amount" type="text" value="{{row.amount}}" class="form-control input-mini required" readonly="true"/>
							</td>
							<td>
								<input id="wmsPurchaseDetailList{{idx}}_taxRate" name="wmsPurchaseDetailList[{{idx}}].taxRate" type="text" value="{{row.taxRate}}" min="0" max="100" maxlength="5" class="form-control input-mini number required" onkeyup="comInput()"/>
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
						
						//计算总计金额
						function comInput(){
							
							var total_amt = 0;//金额总计
							var tax_amt = 0;//税额合计
							var other_amt = 0;//其他费用
							var order_amt = 0;//订单总金额
							var total_num = 0;//总数量
							
							var mytable = document.getElementById("contentTable");
							for(var i=0; i<mytable.rows.length; i++){
								
								//判断元素是否存在
								if($("#wmsPurchaseDetailList"+i+"_name").length > 0) {
									
									//数量		
									var num = $("#wmsPurchaseDetailList"+i+"_num").val();
									//单价
									var price = $("#wmsPurchaseDetailList"+i+"_price").val();									
									//金额
									var amount = 0;
									
									//计算总数量	
									if(num != null && num != '' && !isNaN(num)){
										total_num += parseInt(num);
									}
									
									//计算金额																
									if(price != null && price != '' && !isNaN(price) && num != null && num != '' && !isNaN(num)){	
										amount = price * num;
										$("#wmsPurchaseDetailList"+i+"_amount").val(amount);
									}
									
									//计算总金额
									if(amount != null && amount != '' && !isNaN(amount)){
										total_amt += parseFloat(amount);
									}
									
									//计算税额
									var taxRate = $("#wmsPurchaseDetailList"+i+"_taxRate").val();
									if(taxRate != null && taxRate != '' && !isNaN(taxRate) && amount != null && amount != '' && !isNaN(amount)){								
										var taxAmt = taxRate * amount /100;
									}else{
										$("#wmsPurchaseDetailList"+i+"_taxRate").val(0);
										var taxAmt = 0;
									}
									$("#wmsPurchaseDetailList"+i+"_taxAmt").val(taxAmt.toFixed(2));
									
									//计算总税额
									var taxAmt = $("#wmsPurchaseDetailList"+i+"_taxAmt").val();
									if(taxAmt != null && taxAmt != '' && !isNaN(taxAmt)){
										tax_amt += parseFloat(taxAmt);
									}
								}								
							}
							
							$("#totalAmt").val(total_amt);
							$("#taxAmt").val(tax_amt);
							var otherAmt = $("#otherAmt").val();
							if(otherAmt != null && otherAmt != '' && !isNaN(otherAmt)){
								other_amt = parseFloat(otherAmt);
							}
							$("#amount").val(total_amt + tax_amt + other_amt);
							$("#num").val(total_num);
						}
					</script>
					<div class="pull-right">
						总数量：<form:input path="num" htmlEscape="false" maxlength="11" class="form-control input-mini digits" readonly="true" style="border:0;"/>
						合计金额：<form:input path="totalAmt" value="${wmsPurchase.totalAmt}" htmlEscape="false" class="form-control input-mini" readonly="true" style="border:0;"/>
						税额：<form:input path="taxAmt" value="${wmsPurchase.taxAmt}" htmlEscape="false" class="form-control input-mini" readonly="true" style="border:0;"/>
						其他费用：<form:input path="otherAmt" value="${wmsPurchase.otherAmt}" htmlEscape="false" min="0" maxlength="10" class="form-control input-mini number" onkeyup="comInput()"  style="border-top:0;border-left:0;border-right:0;"/>
						总计金额：<form:input path="amount" value="${wmsPurchase.amount}" htmlEscape="false" class="form-control input-mini" readonly="true" style="border:0;"/>
						
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