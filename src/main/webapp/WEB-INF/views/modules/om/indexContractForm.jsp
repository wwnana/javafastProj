<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>合同管理</title>
	<meta name="decorator" content="default"/>
	<script src="${ctxStatic}/jquery-validation/jQueryValidateExtend.js" type="text/javascript"></script>
	<script type="text/javascript">
		var validateForm;
		var pList = ",";
		//自定义检查表身方法
		function checkChildren(){
			if($("#omOrderDetailList tr").length == 0){
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
			singleP["spec"] = myGo['spec'];
			singleP["unitType"] = myGo['unitType'];
			singleP["price"] = myGo['price'];			
			singleP["num"] = '1';
			
			if(checkRepeat(myGo['id'], myGo['name']) == 0){
				var chsub = $("#contentTable tbody tr").length;
				addRow('#omOrderDetailList', omOrderDetailRowIdx, omOrderDetailTpl, singleP);
				omOrderDetailRowIdx = omOrderDetailRowIdx + 1;
			}
		}
		
		//校验是否重复
		function checkRepeat(id, name){
			var repeatNum = 0;
			var mytable = document.getElementById("contentTable");
			for(var i=0; i<mytable.rows.length; i++){
				
				//判断元素是否存在
				if($("#omOrderDetailList"+i+"_product").length > 0) {
					
					var pid = $("#omOrderDetailList"+i+"_product").val();
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
				omOrderDetailRowIdx = 0;
			}

			//重新计算
			comInput();			
		}
	</script>
</head>
<body class="gray-bg">
<div class="">
	<div class="ibox">
		<div class="ibox-title">
			<h5>合同${not empty omContract.id?'修改':'添加'}</h5>
		</div>
		<div class="ibox-content">
			<sys:message content="${message}"/>	
			
			<form:form id="inputForm" modelAttribute="omContract" action="${ctx}/om/omContract/indexContractSave" method="post" class="form-horizontal">
			<form:hidden path="id"/>
			<form:hidden path="order.id"/>
			<h4 class="page-header">基本信息</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 合同编号</label>
						<div class="col-sm-8">
							<form:input path="no" htmlEscape="false" maxlength="30" class="form-control required"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 合同标题</label>
						<div class="col-sm-8">
							<form:input path="name" htmlEscape="false" maxlength="50" class="form-control required"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 客户</label>
						<div class="col-sm-8">
							<sys:tableselect id="customer" name="customer.id" value="${omContract.customer.id}" labelName="customer.name" labelValue="${omContract.customer.name}" 
								title="客户" url="${ctx}/crm/crmCustomer/selectList" cssClass="form-control required" dataMsgRequired="必选"  allowClear="false" allowInput="false"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label">关联报价单</label>
						<div class="col-sm-8">
							<sys:tableselect id="quote" name="quote.id" value="${omContract.quote.id}" labelName="quote.name" labelValue="${omContract.quote.no}" 
								title="报价单" url="${ctx}/crm/crmQuote/selectList?customer.id=${omContract.customer.id}" cssClass="form-control " dataMsgRequired=""  allowClear="true" allowInput="false"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label">关联商机</label>
						<div class="col-sm-8">
							<sys:tableselect id="chance" name="chance.id" value="${omContract.chance.id}" labelName="chance.name" labelValue="${omContract.chance.name}" 
								title="商机" url="${ctx}/crm/crmChance/selectList?customer.id=${omContract.customer.id}" cssClass="form-control " dataMsgRequired=""  allowClear="true" allowInput="false"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 签约日期</label>
						<div class="col-sm-8">
							<div class="input-group date datepicker">
		                     	<input name="dealDate" type="text" readonly="readonly" class="form-control required" value="<fmt:formatDate value="${omContract.dealDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
		                     	<span class="input-group-addon">
		                             <span class="fa fa-calendar"></span>
		                     	</span>
					        </div>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label">交付时间</label>
						<div class="col-sm-8">
							<div class="input-group date datepicker">
	                     		<input name="deliverDate" type="text" readonly="readonly" class="form-control" value="<fmt:formatDate value="${omContract.deliverDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
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
						<label class="col-sm-4 control-label">生效时间</label>
						<div class="col-sm-8">
							<div class="input-group date datepicker">
		                     	<input name="startDate" type="text" readonly="readonly" class="form-control" value="<fmt:formatDate value="${omContract.startDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
		                     	<span class="input-group-addon">
		                             <span class="fa fa-calendar"></span>
		                     	</span>
					        </div>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label">到期时间</label>
						<div class="col-sm-8">
							<div class="input-group date datepicker">
		                     	<input name="endDate" type="text" readonly="readonly" class="form-control" value="<fmt:formatDate value="${omContract.endDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
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
						<label class="col-sm-4 control-label"><font color="red">*</font> 销售负责人</label>
						<div class="col-sm-8">
							<sys:treeselect id="ownBy" name="ownBy.id" value="${omContract.ownBy.id}" labelName="ownBy.name" labelValue="${omContract.ownBy.name}"
								title="用户" url="/sys/office/treeData?type=3" cssClass="form-control " allowClear="true" notAllowSelectParent="true"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 状态</label>
						<div class="col-sm-8">
							<form:select path="status" cssClass="form-control ">
								<form:options items="${fns:getDictList('audit_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</div>
			</div>
			
			
			<!--  订单明细 -->
			<div class="tabs-container">
	            <ul class="nav nav-tabs">
					<li class="active"><a data-toggle="tab" href="#tab-1" aria-expanded="true">销售订单明细</a>
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
								<th>规格</th>
								<th>单位</th>	
								<th>单价(元)</th>
								<th>数量</th>
								<th>金额(元)</th>
								<th>税率(%)</th>
								<th>税额(元)</th>
								<th>备注</th>
								<shiro:hasPermission name="om:omContract:edit"><th width="10">&nbsp;</th></shiro:hasPermission>
							</tr>
						</thead>
						<tbody id="omOrderDetailList">
						</tbody>
						<shiro:hasPermission name="om:omContract:edit"><tfoot>
							<tr><td colspan="9">
								<%-- 
								<a href="javascript:" onclick="addRow('#omOrderDetailList', omOrderDetailRowIdx, omOrderDetailTpl);omOrderDetailRowIdx = omOrderDetailRowIdx + 1;" class="btn">新增</a>
								--%>
								<wms:manyselect id="omOrderDetailTag" name="omOrderDetailTag" value="选择"
										title="产品列表（可多选）" url="${ctx}/wms/wmsProduct/selectListForMany" 
										cssClass="btn"  allowClear="false" 
										allowInput="false" checkRepeat="true"/>
									<input name="delSelectIds" type="hidden" />
								</td></tr>
						</tfoot></shiro:hasPermission>
					</table>
					<script type="text/template" id="omOrderDetailTpl">//<!--
						<tr id="omOrderDetailList{{idx}}">
							<td class="hide">
								<input id="omOrderDetailList{{idx}}_id" name="omOrderDetailList[{{idx}}].id" type="hidden" value="{{row.id}}"/>
								<input id="omOrderDetailList{{idx}}_delFlag" name="omOrderDetailList[{{idx}}].delFlag" type="hidden" value="0"/>
								<input id="omOrderDetailList{{idx}}_sort" name="omOrderDetailList[{{idx}}].sort" type="hidden" value="{{idx}}"/>
							</td>
							<td>
								<input id="omOrderDetailList{{idx}}_product" name="omOrderDetailList[{{idx}}].product.id" type="hidden" value="{{row.product.id}}"/>
								<input id="omOrderDetailList{{idx}}_name" name="omOrderDetailList[{{idx}}].product.name" type="text" value="{{row.product.name}}"  class="input required" readonly="true"/>
								<span class="help-inline"><font color="red">*</font> </span>
								<%--
								<wms:productselect id="omOrderDetailList{{idx}}_product" name="omOrderDetailList[{{idx}}].product.id" value="{{row.product.id}}" labelName="omOrderDetailList[{{idx}}].product.name" labelValue="{{row.product.name}}" 
										title="产品" url="${ctx}/wms/wmsProduct/selectList" cssClass="form-control required" dataMsgRequired="必选"  allowClear="false" allowInput="false"/>
								--%>
							</td>
							<td>								
								<input id="omOrderDetailList{{idx}}_spec" name="omOrderDetailList[{{idx}}].product.spec" type="text" value="{{row.product.spec}}" maxlength="50" class="form-control input-mini" style="border:0;"/>
							</td>
							<td>								
								<input id="omOrderDetailList{{idx}}_unitType" name="omOrderDetailList[{{idx}}].unitType" type="text" value="{{row.unitType}}" maxlength="11" class="form-control input-mini" style="border:0;"/>
							</td>
							<td>
								<input id="omOrderDetailList{{idx}}_price" name="omOrderDetailList[{{idx}}].price" type="text" value="{{row.price}}" min="0.01" maxlength="11" class="form-control input-mini required number" onkeyup="comInput()"/>
							</td>
							<td>
								<input id="omOrderDetailList{{idx}}_num" name="omOrderDetailList[{{idx}}].num" type="text" value="{{row.num}}" min="1" maxlength="11" class="form-control input-mini required digits" onkeyup="comInput()"/>
							</td>
							<td>
								<input id="omOrderDetailList{{idx}}_amount" name="omOrderDetailList[{{idx}}].amount" type="text" value="{{row.amount}}" class="form-control input-mini required" readonly="true"/>
							</td>
							
							<td>
								<input id="omOrderDetailList{{idx}}_remarks" name="omOrderDetailList[{{idx}}].remarks" type="text" value="{{row.remarks}}" maxlength="50" class="form-control input-small "/>
							</td>
							<shiro:hasPermission name="om:omContract:edit"><td class="text-center" width="10">
								{{#delBtn}}<span class="close" onclick="delRow(this, '#omOrderDetailList{{idx}}')" title="删除">&times;</span>{{/delBtn}}
							</td></shiro:hasPermission>
						</tr>//-->
					</script>
					<script type="text/javascript">
						var omOrderDetailRowIdx = 0, omOrderDetailTpl = $("#omOrderDetailTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g,"");
						$(document).ready(function() {
							var data = ${fns:toJson(omContract.omOrderDetailList)};
							for (var i=0; i<data.length; i++){
								addRow('#omOrderDetailList', omOrderDetailRowIdx, omOrderDetailTpl, data[i]);
								omOrderDetailRowIdx = omOrderDetailRowIdx + 1;
							}
						});
						
						
						//计算总计金额
						function comInput(){
							
							var total_amt = 0;//金额总计
							var other_amt = 0;//其他费用
							var order_amt = 0;//订单总金额
							var total_num = 0;//总数量
							
							var mytable = document.getElementById("contentTable");
							for(var i=0; i<mytable.rows.length; i++){
								
								//判断元素是否存在
								if($("#omOrderDetailList"+i+"_name").length > 0) {
									
									//数量		
									var num = $("#omOrderDetailList"+i+"_num").val();
									//单价
									var price = $("#omOrderDetailList"+i+"_price").val();									
									//金额
									var amount = 0;
									
									//计算总数量	
									if(num != null && num != '' && !isNaN(num)){
										total_num += parseInt(num);
									}
									
									//计算金额																
									if(price != null && price != '' && !isNaN(price) && num != null && num != '' && !isNaN(num)){	
										amount = price * num;
										$("#omOrderDetailList"+i+"_amount").val(amount);
									}
									
									//计算总金额
									if(amount != null && amount != '' && !isNaN(amount)){
										total_amt += parseFloat(amount);
									}
									
								}								
							}
							
							$("#totalAmt").val(total_amt);
							var otherAmt = $("#otherAmt").val();
							if(otherAmt != null && otherAmt != '' && !isNaN(otherAmt)){
								other_amt = parseFloat(otherAmt);
							}else{
								
							}
							$("#otherAmt").val(other_amt);
							$("#amount").val(total_amt + other_amt);
							$("#num").val(total_num);
						}
					</script>
					<div class="pull-right">
					总数量：<input type="text" id="num" name="num" value="${omContract.order.num}" htmlEscape="false" class="form-control input-mini" readonly="true" style="border:0;"/>
					合计金额：<input type="text" id="totalAmt" name="totalAmt" value="${omContract.order.totalAmt}" htmlEscape="false" class="form-control input-mini" readonly="true" style="border:0;"/>
					其他费用：<input type="text" id="otherAmt" name="otherAmt" value="${omContract.order.otherAmt}" htmlEscape="false" min="0" maxlength="10" class="form-control input-mini number" onkeyup="comInput()"  style="border-top:0;border-left:0;border-right:0;"/>
					总金额：<input type="text" id="amount" name="amount" value="${omContract.order.amount}" htmlEscape="false" class="form-control input-mini required" readonly="true" style="border:0;"/>
					
					</div>
				</div>
				</div>
			</div>
			</div>
			
			<h4 class="page-header">其他信息</h4>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-2 control-label">条款正文</label>
						<div class="col-sm-10">
							<form:textarea id="notes" htmlEscape="true" path="notes" rows="4" maxlength="100000" cssClass="form-control" style="width:100%;height:100px;"/>
							<sys:umeditor replace="notes" uploadPath="/image" height="100px" maxlength="100000"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-2 control-label">附件</label>
						<div class="col-sm-10">
							<form:hidden id="files" path="files" htmlEscape="false" maxlength="2000" class=""/>
							<sys:ckfinder input="files" type="files" uploadPath="/file" selectMultiple="true"/>
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
			
			
			<div class="hr-line-dashed"></div>
			<div class="form-group">
            	<div class="col-sm-4 col-sm-offset-2">
                	<input id="btnSubmit" class="btn btn-success" type="submit" value="保 存"/>
                    <input id="btnCancel" class="btn btn-white" type="button" value="返 回" onclick="history.go(-1)"/>
                </div>
            </div>
		</form:form>
	</div>
</div>
</div>
</body>
</html>