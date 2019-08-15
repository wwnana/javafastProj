<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>出库单管理</title>
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
			<h5>出库单出库</h5>
		</div>
		<div class="ibox-content">
		<sys:message content="${message}"/>	
		<form:form id="inputForm" modelAttribute="wmsOutstock" action="${ctx}/wms/wmsOutstock/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
	
	 <table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
		<tbody>
			<tr>
				</tr>
				<tr> 
					
					<td class="width-15 active"><label class="pull-right">出库单号：</label></td>
					<td class="width-35">
						<form:hidden path="no"/>
						${wmsOutstock.no }
					</td>
					<td class="width-15 active"><label class="pull-right"><font color="red">*</font> 出库仓库：</label></td>
					<td class="width-35">
						<div class="input-xlarge">
							<sys:spinnerselect id="warehouse" name="warehouse.id" value="${wmsOutstock.warehouse.id}" labelName="warehouse.name" labelValue="${wmsOutstock.warehouse.name}" 
								title="仓库" url="${ctx}/wms/wmsWarehouse/getSelectData" cssClass="form-control required" allowEmpty="false"></sys:spinnerselect>
						</div>
					</td>
				</tr>
				<tr> 
					<td class="width-15 active"><label class="pull-right">出库类型：</label></td>
					<td class="width-35">
							${fns:getDictLabel(wmsOutstock.outstockType, 'outstock_type', '')}
					</td>
					
					<c:if test="${wmsOutstock.outstockType == 0}">
						<td class="width-15 active"><label class="pull-right">关联订单号：</label></td>
						<td class="width-35">
								${wmsOutstock.order.no}
						</td>
					</c:if>
					<c:if test="${wmsOutstock.outstockType == 1}">
						<td class="width-15 active"><label class="pull-right">供应商：</label></td>
						<td class="width-35">
							${wmsOutstock.supplier.name}
						</td>
					</c:if>
					<c:if test="${wmsOutstock.outstockType == 2}">
						<td class="width-15 active"><label class="pull-right"></label></td>
						<td class="width-35">
							
						</td>
					</c:if>
				</tr>

				<tr> 
					<td class="width-15 active"><label class="pull-right"><font color="red">*</font> 经办人：</label></td>
					<td class="width-35">
						<div class="input-xlarge">
							<sys:treeselect id="dealBy" name="dealBy.id" value="${wmsOutstock.dealBy.id}" labelName="dealBy.name" labelValue="${wmsOutstock.dealBy.name}"
								title="用户" url="/sys/office/treeData?type=3" cssClass="form-control required" allowClear="true" notAllowSelectParent="true"/>
						</div>
					</td>
					<td class="width-15 active"><label class="pull-right"><font color="red">*</font> 业务日期：</label></td>
					<td class="width-35">
						<div class="input-xlarge">
							<div class="input-group date datepicker">
								<input name="dealDate" type="text" readonly="readonly" class="form-control required" value="<fmt:formatDate value="${wmsOutstock.dealDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
	                     		<span class="input-group-addon">
	                             	<span class="fa fa-calendar"></span>
	                     		</span>
                     		</div>
						</div>
					</td>
				</tr>
				
				<tr> 
					<td class="width-15 active"><label class="pull-right">备注：</label></td>
					<td class="width-35" colspan="3">
							<form:textarea path="remarks" htmlEscape="false" rows="2" maxlength="50" class="form-control"/>
						</td>
				</tr>
			</tbody>
		</table>
			<div class="tabs-container">
	            <ul class="nav nav-tabs">
					<li class="active"><a data-toggle="tab" href="#tab-1" aria-expanded="true">出库单明细</a>
	                </li>
					
	            </ul>
          	   <div class="tab-content">
          	   	<div class="panel-body">
					<div id="tab-1" class="tab-pane table-responsive active">
					<table id="contentTable" class="table table-striped table-bordered table-hover table-condensed">
						<thead>
							<tr>
								<th class="hide"></th>
								<th>产品编码</th>
								<th>产品名称</th>
								<th>规格</th>
								<th>单位</th>
								<th>数量</th>
								<th>已出库数量</th>
								<th>未出库数量</th>
								<th>备注</th>
								<shiro:hasPermission name="wms:wmsOutstock:edit"><th width="10">&nbsp;</th></shiro:hasPermission>
							</tr>
						</thead>
						<tbody id="wmsOutstockDetailList">
						</tbody>
						<shiro:hasPermission name="wms:wmsOutstock:edit1"><tfoot>
							<tr><td colspan="8"><a href="javascript:" onclick="addRow('#wmsOutstockDetailList', wmsOutstockDetailRowIdx, wmsOutstockDetailTpl);wmsOutstockDetailRowIdx = wmsOutstockDetailRowIdx + 1;" class="btn">新增</a></td></tr>
						</tfoot></shiro:hasPermission>
					</table>
					<script type="text/template" id="wmsOutstockDetailTpl">//<!--
						<tr id="wmsOutstockDetailList{{idx}}">
							<td class="hide">
								<input id="wmsOutstockDetailList{{idx}}_id" name="wmsOutstockDetailList[{{idx}}].id" type="hidden" value="{{row.id}}"/>
								<input id="wmsOutstockDetailList{{idx}}_delFlag" name="wmsOutstockDetailList[{{idx}}].delFlag" type="hidden" value="0"/>
							</td>
							<td>
								{{row.product.no}}
							</td>
							<td>
								<input id="wmsOutstockDetailList{{idx}}_product" name="wmsOutstockDetailList[{{idx}}].product.id" type="hidden" value="{{row.product.id}}" maxlength="30" class="form-control input-small required"/>
								{{row.product.name}}
							</td>
							<td>
								{{row.product.spec}}
							</td>
							<td>
								{{row.unitType}}
							</td>
							<td>
								<input id="wmsOutstockDetailList{{idx}}_num" name="wmsOutstockDetailList[{{idx}}].num" type="hidden" value="{{row.num}}" maxlength="11" class="form-control input-small required digits"/>
								{{row.num}}
							</td>
							<td>
								<input id="wmsOutstockDetailList{{idx}}_outstockNum" name="wmsOutstockDetailList[{{idx}}].outstockNum" type="text" value="{{row.outstockNum}}" maxlength="11" min="0" max="{{row.num}}" class="form-control input-mini required digits" onkeyup="checkInputNum({{idx}})"/>
							</td>
							<td>
								<input id="wmsOutstockDetailList{{idx}}_diffNum" name="wmsOutstockDetailList[{{idx}}].diffNum" type="text" value="{{row.diffNum}}" maxlength="11" class="form-control input-mini digits" readonly="true" style="border:0;"/>
							</td>
							<td>
								<input id="wmsOutstockDetailList{{idx}}_remarks" name="wmsOutstockDetailList[{{idx}}].remarks" type="text" value="{{row.remarks}}" maxlength="50" class="form-control input-xlarge "/>
							</td>
							<shiro:hasPermission name="wms:wmsOutstock:edit"><td class="text-center" width="10">
								{{#delBtn}}<span class="close" onclick="delRow(this, '#wmsOutstockDetailList{{idx}}')" title="删除">&times;</span>{{/delBtn}}
							</td></shiro:hasPermission>
						</tr>//-->
					</script>
					<script type="text/javascript">
						var wmsOutstockDetailRowIdx = 0, wmsOutstockDetailTpl = $("#wmsOutstockDetailTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g,"");
						$(document).ready(function() {
							var data = ${fns:toJson(wmsOutstock.wmsOutstockDetailList)};
							for (var i=0; i<data.length; i++){
								addRow('#wmsOutstockDetailList', wmsOutstockDetailRowIdx, wmsOutstockDetailTpl, data[i]);
								wmsOutstockDetailRowIdx = wmsOutstockDetailRowIdx + 1;
							}
						});
						function checkInputNum(index){
							var num = $("#wmsOutstockDetailList"+index+"_num").val();
							var outstockNum = $("#wmsOutstockDetailList"+index+"_outstockNum").val();
							if(outstockNum != null && outstockNum != '' && !isNaN(outstockNum) && num != null && num != '' && !isNaN(num)){
								
								var diffNum = num - outstockNum;
								if(diffNum >= 0){
									$("#wmsOutstockDetailList"+index+"_diffNum").val(diffNum);
								}								
							}
							comRealNum();
						}
						function comRealNum(){
							var real_num = 0;//已出库总数
							var diff_num = 0;//差异总数
							var mytable = document.getElementById("contentTable");
							for(var i=0; i<mytable.rows.length-1; i++){
								var outstock_num = $("#wmsOutstockDetailList"+i+"_outstockNum").val();
								if(outstock_num != null && outstock_num != '' && !isNaN(outstock_num)){
									real_num += parseInt(outstock_num);
								}
							}
							
							$("#realNum").val(real_num);
							$("#diffNum").val(parseInt($("#num").val())-real_num);
						}
					</script>
					<div class="pull-right">
						总数量：<form:input path="num" htmlEscape="false" maxlength="11" class="form-control input-mini digits" min="1" readonly="true" style="border:0;"/>
						已出库数：<form:input path="realNum" htmlEscape="false" maxlength="11" class="form-control input-mini digits" min="0" readonly="true" style="border:0;"/>
						差异数：<form:input path="diffNum" htmlEscape="false" maxlength="11" class="form-control input-mini digits" min="0" readonly="true" style="border:0;"/>
					</div>
				</div>
				</div>
			</div>
			</div>
	<br>
				<div class="form-actions">
					<c:if test="${wmsOutstock.status == 0}">
						<shiro:hasPermission name="wms:wmsOutstock:edit"><input id="btnSubmit" class="btn btn-success" type="submit" value="出 库"/>&nbsp;</shiro:hasPermission>
						
						<c:if test="${wmsOutstock.num == wmsOutstock.realNum}">
							<shiro:hasPermission name="wms:wmsOutstock:audit">
								<a href="${ctx}/wms/wmsOutstock/audit?id=${wmsOutstock.id}" onclick="return confirmx('确认要审核该出库单吗？', this.href)" class="btn btn-success" title="审核"><i class="fa fa-check"></i>
									<span class="hidden-xs">审核</span></a> 
							</shiro:hasPermission>
						</c:if>
					</c:if>
					<input id="btnCancel" class="btn btn-white" type="button" value="返 回" onclick="history.go(-1)"/>
				</div>
			<br>
	</form:form>
</div></div></div>
</body>
</html>