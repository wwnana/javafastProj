<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>订单信息编辑</title>
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
		
		var pList = ",";
		//自定义检查表身方法
		function checkChildren(){
			if($("#testDataChildList tr").length == 0){
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
		
		//数据添加
		function setParamsByItems(item){
			
			//产品信息
			var myGo = {};
			myGo['id'] = item.children("td").eq(0).find("input").attr("id");
			myGo['name'] = item.children("td").eq(3).html();
			myGo['unitType'] = item.children("td").eq(5).html();
			myGo['spec'] = item.children("td").eq(6).html();
			myGo['price'] = item.children("td").eq(9).html();
			
			var singleP = {};
			singleP["product"] = myGo;
			singleP["unitType"] = myGo['unitType'];
			singleP["spec"] = myGo['spec'];
			singleP["price"] = myGo['price'];			
			singleP["num"] = '1';
			
			if(checkRepeat(myGo['id'], myGo['name']) == 0){
				var chsub = $("#contentTable tbody tr").length;
				addRow('#testDataChildList', testDataChildRowIdx, testDataChildTpl, singleP);
				testDataChildRowIdx = testDataChildRowIdx + 1;
			}
		}
		//校验是否重复
		function checkRepeat(id, name){
			var repeatNum = 0;
			var mytable = document.getElementById("contentTable");
			for(var i=0; i<mytable.rows.length; i++){
				
				//判断元素是否存在
				if($("#testDataChildList"+i+"_product").length > 0) {
					
					var pid = $("#testDataChildList"+i+"_product").val();
					if(pid == id){
						alert("商品：" + name + " 重复选择");
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

			//删除一行
			$(prefix).remove();
			
			//重点 更新新增的rowid值
			var tSortNum = $("#contentTable tbody tr");
			if(! (tSortNum.length > 0)){
				testDataChildRowIdx = 0;
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
		<h5>订单信息(一对多)${not empty omContract.id?'修改':'添加'}</h5>
	</div>
	<div class="ibox-content">
		<sys:message content="${message}"/>
		<form:form id="inputForm" modelAttribute="testDataMain" action="${ctx}/test/onetomany/testDataMain/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<form:hidden path="status"/>
			<h4 class="page-header">基本信息</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 单号：</label>
						<div class="col-sm-8">
							<form:input path="no" htmlEscape="false" maxlength="30" class="form-control required"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 销售类型：</label>
						<div class="col-sm-8">
							<form:select path="saleType" class="form-control required">
								<form:options items="${fns:getDictList('sale_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label">开票金额(元)：</label>
						<div class="col-sm-8">
							<form:input path="invoiceAmt" htmlEscape="false" class="form-control isDecimal" max="10000.00" min="0.01"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 经办人：</label>
						<div class="col-sm-8">
							<sys:treeselect id="dealBy" name="dealBy.id" value="${testDataMain.dealBy.id}" labelName="dealBy.name" labelValue="${testDataMain.dealBy.name}"
							title="用户" url="/sys/office/treeData?type=3" cssClass="form-control required" allowClear="true" notAllowSelectParent="true"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 业务日期：</label>
						<div class="col-sm-8">
							<div class="input-group date datepicker">
				                 <input name="leaveStartTime" type="text" readonly="readonly" class="form-control" 
				                 value="<fmt:formatDate value="${testDataMain.dealDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
				                 <span class="input-group-addon">
				                      <span class="fa fa-calendar"></span>
				                 </span>
							</div>
						</div>
					</div>
				</div>
			</div>
			<h4 class="page-header">备注信息</h4>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-2 control-label"> 备注：</label>
						<div class="col-sm-10">
							<form:textarea path="remarks" htmlEscape="false" rows="3" maxlength="50" class="form-control "/>
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
					<table id="contentTable" class="table table-bordered table-striped table-hover">
						<thead>
							<tr>
								<th class="hide"></th>
								<th>商品</th>
								<th>规格</th>
								<th>单位</th>
								<th>单价(元)</th>
								<th>数量</th>
								<th>金额(元)</th>
								<th>备注</th>
								<shiro:hasPermission name="test:onetomany:testDataMain:edit"><th width="10">&nbsp;</th></shiro:hasPermission>
							</tr>
						</thead>
						<tbody id="testDataChildList">
						</tbody>
						<shiro:hasPermission name="test:onetomany:testDataMain:edit"><tfoot>
							<tr><td colspan="8">
							<%-- 
							<a href="javascript:" onclick="addRow('#testDataChildList', testDataChildRowIdx, testDataChildTpl);testDataChildRowIdx = testDataChildRowIdx + 1;" class="btn">新增</a>
							--%>
							<wms:manyselect id="testDataChildTag" name="testDataChildTag" value="选择"
										title="商品" url="${ctx}/test/one/testOne/selectList" 
										cssClass="btn"  allowClear="false" 
										allowInput="false" checkRepeat="true"/>
									<input name="delSelectIds" type="hidden" />
							</td></tr>
						</tfoot></shiro:hasPermission>
					</table>
					<script type="text/template" id="testDataChildTpl">//<!--
						<tr id="testDataChildList{{idx}}">
							<td class="hide">
								<input id="testDataChildList{{idx}}_id" name="testDataChildList[{{idx}}].id" type="hidden" value="{{row.id}}"/>
								<input id="testDataChildList{{idx}}_delFlag" name="testDataChildList[{{idx}}].delFlag" type="hidden" value="0"/>
							</td>
							<td>							
								<input id="testDataChildList{{idx}}_product" name="testDataChildList[{{idx}}].product.id" type="hidden" value="{{row.product.id}}"/>
								<input id="testDataChildList{{idx}}_name" name="testDataChildList[{{idx}}].product.name" type="text" value="{{row.product.name}}"  class="input required" readonly="true"/>
								<span class="help-inline"><font color="red">*</font> </span>
								<%--
								<wms:productselect id="testDataChildList{{idx}}_product" name="testDataChildList[{{idx}}].product.id" value="{{row.product.id}}" labelName="testDataChildList[{{idx}}].product.name" labelValue="{{row.product.name}}" 
										title="商品" url="${ctx}/test/one/testOne/selectList" cssClass="form-control input-xlarge required" dataMsgRequired="必选"  allowClear="false" allowInput="false"/>
								--%>
							</td>
							<td>
								<input id="testDataChildList{{idx}}_spec" name="testDataChildList[{{idx}}].product.spec" type="text" value="{{row.product.spec}}" maxlength="50" class="form-control input-mini "/>
							</td>
							<td>
								<input id="testDataChildList{{idx}}_unitType" name="testDataChildList[{{idx}}].unitType" type="text" value="{{row.unitType}}" maxlength="30" class="form-control input-mini "/>
							</td>
							<td>
								<input id="testDataChildList{{idx}}_price" name="testDataChildList[{{idx}}].price" type="text" value="{{row.price}}" min="0.01" onkeyup="comInput()" class="form-control input-mini required number"/>
							</td>
							<td>
								<input id="testDataChildList{{idx}}_num" name="testDataChildList[{{idx}}].num" type="text" value="{{row.num}}" maxlength="11" min="1" onkeyup="comInput()" class="form-control input-mini required digits"/>
							</td>
							<td>
								<input id="testDataChildList{{idx}}_amount" name="testDataChildList[{{idx}}].amount" type="text" value="{{row.amount}}" class="form-control input-mini required" readonly="true"/>
							</td>
							<td>
								<input id="testDataChildList{{idx}}_remarks" name="testDataChildList[{{idx}}].remarks" type="text" value="{{row.remarks}}" maxlength="50" class="form-control input-small "/>
							</td>
							<shiro:hasPermission name="test:onetomany:testDataMain:edit"><td class="text-center" width="10">
								{{#delBtn}}<span class="close" onclick="delRow(this, '#testDataChildList{{idx}}')" title="删除">&times;</span>{{/delBtn}}
							</td></shiro:hasPermission>
						</tr>//-->
					</script>
					<script type="text/javascript">
						var testDataChildRowIdx = 0, testDataChildTpl = $("#testDataChildTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g,"");
						$(document).ready(function() {
							var data = ${fns:toJson(testDataMain.testDataChildList)};
							for (var i=0; i<data.length; i++){
								addRow('#testDataChildList', testDataChildRowIdx, testDataChildTpl, data[i]);
								testDataChildRowIdx = testDataChildRowIdx + 1;
							}
						});

						//计算
						function comInput(){
							var total_amt = 0;//金额总计
							
							var mytable = document.getElementById("contentTable");
							for(var i=0; i<mytable.rows.length-2; i++){
								
								//判断元素是否存在
								if($("#testDataChildList"+i+"_num").length > 0) {
									
									var price = $("#testDataChildList"+i+"_price").val();
									var num = $("#testDataChildList"+i+"_num").val();
									
									if(price != null && price != '' && !isNaN(price) && num != null && num != '' && !isNaN(num)){								
										$("#testDataChildList"+i+"_amount").val(price * num);
									}
									
									var amount = $("#testDataChildList"+i+"_amount").val();
									if(amount != null && amount != '' && !isNaN(amount)){
										total_amt += parseFloat(amount);
									}
								}
							}
							
							$("#amount").val(total_amt);
						}
					</script>
					<div class="pull-right">
						总金额：<form:input path="amount" htmlEscape="false" class="form-control input-mini" readonly="true" style="border:0;"/>
					
					</div>
					</div>
				</div>
			</div>
		</div>
			<div class="hr-line-dashed"></div>
			<div class="form-actions">
				<shiro:hasPermission name="test:onetomany:testDataMain:edit">
					<button id="btnSubmit" class="btn btn-success" type="submit">保存</button>&nbsp;
				</shiro:hasPermission>
				<button id="btnCancel" class="btn btn-white" type="button" onclick="history.go(-1)">返回</button>
			</div>
		
		</form:form>
	</div>
</div>
</div>
</body>
</html>