<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>报价单管理</title>
	<meta name="decorator" content="default"/>
	<script src="${ctxStatic}/jquery-validation/jQueryValidateExtend.js" type="text/javascript"></script>
	<script type="text/javascript">
		var validateForm;
		var pList = ",";
		//自定义检查表身方法
		function checkChildren(){
			if($("#crmQuoteDetailList tr").length == 0){
				$("#tablerror").remove();
				if($("#tablerror").length == 0){
					var errorHtml = "<tr id='tablerror'><td  colspan='9'><label  " 
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
			myGo['unitType'] = item.children("td").eq(3).html();
			myGo['spec'] = item.children("td").eq(4).html();
			myGo['price'] = item.children("td").eq(5).html();
			
			var singleP = {};
			singleP["product"] = myGo;
			singleP["spec"] = myGo['spec'];
			singleP["unitType"] = myGo['unitType'];			
			singleP["price"] = myGo['price'];
			singleP["num"] = '1';
			
			if(checkRepeat(myGo['id'], myGo['name']) == 0){
				var chsub = $("#contentTable tbody tr").length;
				addRow('#crmQuoteDetailList', crmQuoteDetailRowIdx, crmQuoteDetailTpl, singleP);
				crmQuoteDetailRowIdx = crmQuoteDetailRowIdx + 1;
			}
		}
		
		//校验是否重复
		function checkRepeat(id, name){
			var repeatNum = 0;
			var mytable = document.getElementById("contentTable");
			for(var i=0; i<mytable.rows.length; i++){
				
				//判断元素是否存在
				if($("#crmQuoteDetailList"+i+"_product").length > 0) {
					
					var pid = $("#crmQuoteDetailList"+i+"_product").val();
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
				crmQuoteDetailRowIdx = 0;
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
			<h5>报价单${not empty crmQuote.id?'修改':'添加'}</h5>
		</div>
		<div class="ibox-content">
			<sys:message content="${message}"/>	
			<form:form id="inputForm" modelAttribute="crmQuote" action="${ctx}/crm/crmQuote/save" method="post" class="form-horizontal">
			<form:hidden path="id"/>
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
						<label class="col-sm-4 control-label">来源商机</label>
						<div class="col-sm-8">
							<sys:tableselect id="chance" name="chance.id" value="${crmQuote.chance.id}" labelName="chance.name" labelValue="${crmQuote.chance.name}" 
								title="商机" url="${ctx}/crm/crmChance/selectList?customer.id=${crmQuote.customer.id}" cssClass="form-control " dataMsgRequired=""  allowClear="false" allowInput="false"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 客户</label>
						<div class="col-sm-8">
							<sys:tableselect id="customer" name="customer.id" value="${crmQuote.customer.id}" labelName="customer.name" labelValue="${crmQuote.customer.name}" 
								title="客户" url="${ctx}/crm/crmCustomer/selectList" cssClass="form-control required" dataMsgRequired="必选"  allowClear="false" allowInput="false"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label">联系人</label>
						<div class="col-sm-8">
							<sys:tableselect id="contacter" name="contacter.id" value="${crmQuote.contacter.id}" labelName="contacter.name" labelValue="${crmQuote.contacter.name}" 
								title="联系人" url="${ctx}/crm/crmContacter/selectList?customer.id=${crmQuote.customer.id}" cssClass="form-control" dataMsgRequired=""  allowClear="false" allowInput="false"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 报价日期</label>
						<div class="col-sm-8">
							<div class="input-group date datepicker">
		                     	<input name="startdate" type="text" readonly="readonly" class="form-control required" value="<fmt:formatDate value="${crmQuote.startdate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
		                     	<span class="input-group-addon">
		                             <span class="fa fa-calendar"></span>
		                     	</span>
					        </div>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 有效期至</label>
						<div class="col-sm-8">
							<div class="input-group date datepicker">
		                     	<input name="enddate" type="text" readonly="readonly" class="form-control required" value="<fmt:formatDate value="${crmQuote.enddate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
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
						<label class="col-sm-4 control-label"><font color="red">*</font> 状态</label>
						<div class="col-sm-8">
							<form:select path="status" class="form-control required" disabled="true">
								<form:options items="${fns:getDictList('audit_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 负责人</label>
						<div class="col-sm-8">
							<sys:treeselect id="ownBy" name="ownBy.id" value="${crmQuote.ownBy.id}" labelName="ownBy.name" labelValue="${crmQuote.ownBy.name}"
								title="用户" url="/sys/office/treeData?type=3" cssClass="form-control required" allowClear="true" notAllowSelectParent="true"/>
						</div>
					</div>
				</div>
			</div>
			<h4 class="page-header">其他信息</h4>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-2 control-label">正文</label>
						<div class="col-sm-10">
							<form:textarea id="notes" htmlEscape="true" path="notes" rows="4" maxlength="10000" cssClass="form-control" style="height:100px;"/>
							<sys:umeditor replace="notes" uploadPath="/file" height="100px" maxlength="10000"/>
						</div>
					</div>
				</div>
			</div>
			
				
			<div class="tabs-container">
	            <ul class="nav nav-tabs">
					<li class="active"><a data-toggle="tab" href="#tab-1" aria-expanded="true">报价单明细</a>
	                </li>
					
	            </ul>
          	   <div class="tab-content">
          	   	<div class="panel-body">
					<div id="tab-1" class="tab-pane table-responsive active">
					<table id="contentTable" class="table table-striped table-bordered table-hover table-condensed">
						<thead>
							<tr>
								<th class="hide"></th>
								<th>排序</th>
								<th>产品</th>
								<th>规格</th>
								<th>单位</th>	
								<th>单价</th>
								<th>数量</th>
								<th>金额</th>
								<th>备注</th>
								<shiro:hasPermission name="crm:crmQuote:edit"><th width="10">&nbsp;</th></shiro:hasPermission>
							</tr>
						</thead>
						<tbody id="crmQuoteDetailList">
						</tbody>
						<shiro:hasPermission name="crm:crmQuote:edit"><tfoot>
							<tr>
								<td colspan="9">
									<%-- 
									<a href="javascript:" onclick="addRow('#crmQuoteDetailList', crmQuoteDetailRowIdx, crmQuoteDetailTpl);crmQuoteDetailRowIdx = crmQuoteDetailRowIdx + 1;" class="btn">新增</a>
									--%>
									<wms:manyselect id="crmQuoteDetailTag" name="crmQuoteDetailTag" value="选择"
										title="产品列表（可多选）" url="${ctx}/wms/wmsProduct/selectListForMany" 
										cssClass="btn"  allowClear="false" 
										allowInput="false" checkRepeat="true"/>
									<input name="delSelectIds" type="hidden" />
								</td>
							</tr>
						</tfoot></shiro:hasPermission>
					</table>
					<script type="text/template" id="crmQuoteDetailTpl">//<!--
						<tr id="crmQuoteDetailList{{idx}}">
							<td class="hide">
								<input id="crmQuoteDetailList{{idx}}_id" name="crmQuoteDetailList[{{idx}}].id" type="hidden" value="{{row.id}}"/>
								<input id="crmQuoteDetailList{{idx}}_delFlag" name="crmQuoteDetailList[{{idx}}].delFlag" type="hidden" value="0"/>
							</td>
							<td>
								<input id="crmQuoteDetailList{{idx}}_sort" name="crmQuoteDetailList[{{idx}}].sort" type="text" value="{{idx}}" maxlength="10" min="0" class="form-control input-mini required digits"/>
							</td>
							<td>
								<input id="crmQuoteDetailList{{idx}}_product" name="crmQuoteDetailList[{{idx}}].product.id" type="hidden" value="{{row.product.id}}"/>
								<input id="crmQuoteDetailList{{idx}}_name" name="crmQuoteDetailList[{{idx}}].product.name" type="text" value="{{row.product.name}}"  class="input required" readonly="true"/>
								
								<span class="help-inline"><font color="red">*</font> </span>
								<%--
								<wms:productselect id="crmQuoteDetailList{{idx}}_product" name="crmQuoteDetailList[{{idx}}].product.id" value="{{row.product.id}}" labelName="crmQuoteDetailList[{{idx}}].product.name" labelValue="{{row.product.name}}" 
										title="产品" url="${ctx}/wms/wmsProduct/selectList" cssClass="form-control input-xlarge required" dataMsgRequired="必填"  allowClear="false" allowInput="false"/>
								--%>
							</td>
							<td>		
								<input id="crmQuoteDetailList{{idx}}_spec" name="crmQuoteDetailList[{{idx}}].product.spec" type="text" value="{{row.product.spec}}" maxlength="50" class="form-control input-mini "/>
							</td>
							<td>
								<input id="crmQuoteDetailList{{idx}}_unitType" name="crmQuoteDetailList[{{idx}}].unitType" type="text" value="{{row.unitType}}" maxlength="11" class="form-control input-mini" style="border:0;"/>
							</td>
							<td>
								<input id="crmQuoteDetailList{{idx}}_price" name="crmQuoteDetailList[{{idx}}].price" type="text" value="{{row.price}}" min="0.01" class="form-control input-small required number" onkeyup="comInput()"/>
							</td>
							<td>
								<input id="crmQuoteDetailList{{idx}}_num" name="crmQuoteDetailList[{{idx}}].num" type="text" value="{{row.num}}" maxlength="10" min="1" class="form-control input-small required digits" onkeyup="comInput()"/>
							</td>
							<td>
								<input id="crmQuoteDetailList{{idx}}_amt" name="crmQuoteDetailList[{{idx}}].amt" type="text" value="{{row.amt}}" class="form-control input-small required" readonly="true"/>
							</td>
							<td>
								<input id="crmQuoteDetailList{{idx}}_remarks" name="crmQuoteDetailList[{{idx}}].remarks" type="text" value="{{row.remarks}}" maxlength="50" class="form-control input-small "/>
							</td>
							<shiro:hasPermission name="crm:crmQuote:edit"><td class="text-center" width="10">
								{{#delBtn}}<span class="close" onclick="delRow(this, '#crmQuoteDetailList{{idx}}')" title="删除">&times;</span>{{/delBtn}}
							</td></shiro:hasPermission>
						</tr>//-->
					</script>
					<script type="text/javascript">
						var crmQuoteDetailRowIdx = 0, crmQuoteDetailTpl = $("#crmQuoteDetailTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g,"");
						$(document).ready(function() {
							var data = ${fns:toJson(crmQuote.crmQuoteDetailList)};
							for (var i=0; i<data.length; i++){
								addRow('#crmQuoteDetailList', crmQuoteDetailRowIdx, crmQuoteDetailTpl, data[i]);
								crmQuoteDetailRowIdx = crmQuoteDetailRowIdx + 1;
							}
						});
						
						
						//计算总计金额
						function comInput(){
							
							var total_amt = 0;//金额总计
							var total_num = 0;//总数量
							
							var mytable = document.getElementById("contentTable");
							
							for(var i=0; i<mytable.rows.length; i++){
								
								//判断元素是否存在
								if($("#crmQuoteDetailList"+i+"_name").length > 0) {
									
									//数量		
									var num = $("#crmQuoteDetailList"+i+"_num").val();
									//单价
									var price = $("#crmQuoteDetailList"+i+"_price").val();		
									
									//金额
									var amount = 0;
									
									//计算总数量	
									if(num != null && num != '' && !isNaN(num)){
										total_num += parseInt(num);
									}
									
									//计算金额																
									if(price != null && price != '' && !isNaN(price) && num != null && num != '' && !isNaN(num)){	
										amount = price * num;
										$("#crmQuoteDetailList"+i+"_amt").val(amount);
									}
									
									//计算总金额
									if(amount != null && amount != '' && !isNaN(amount)){
										total_amt += parseFloat(amount);
									}									
								}								
							}
							
							$("#amount").val(total_amt);
							$("#num").val(total_num);
						}
					</script>
					<div class="pull-right">
						总金额：<form:input path="amount" htmlEscape="false" min="0.01" class="form-control input-small required number" readonly="true" style="border:0"/>
						总数量：<form:input path="num" htmlEscape="false" min="1" class="form-control input-small required" readonly="true" style="border:0"/>
					</div>
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