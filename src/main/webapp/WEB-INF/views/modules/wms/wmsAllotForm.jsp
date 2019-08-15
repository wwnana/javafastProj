<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>调拨单编辑</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
	var validateForm;
	var pList = ",";
	//自定义检查表身方法
	function checkChildren(){
		if($("#wmsAllotDetailList tr").length == 0){
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
		
		var singleP = {};
		singleP["product"] = myGo;
		singleP["unitType"] = myGo['unitType'];
		singleP["spec"] = myGo['spec'];
		singleP["num"] = '1';
		
		if(checkRepeat(myGo['id'], myGo['name']) == 0){
			var chsub = $("#contentTable tbody tr").length;
			addRow('#wmsAllotDetailList', wmsAllotDetailRowIdx, wmsAllotDetailTpl, singleP);
			wmsAllotDetailRowIdx = wmsAllotDetailRowIdx + 1;
		}
	}
	
	//校验是否重复
	function checkRepeat(id, name){
		var repeatNum = 0;
		var mytable = document.getElementById("contentTable");
		for(var i=0; i<mytable.rows.length; i++){
			
			//判断元素是否存在
			if($("#wmsAllotDetailList"+i+"_product").length > 0) {
				
				var pid = $("#wmsAllotDetailList"+i+"_product").val();
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
			wmsAllotDetailRowIdx = 0;
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
		<h5>调拨单${not empty wmsAllot.id?'修改':'添加'}</h5>
	</div>
	<div class="ibox-content">
	<sys:message content="${message}"/>
	
	<form:form id="inputForm" modelAttribute="wmsAllot" action="${ctx}/wms/wmsAllot/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
	 <table class="table table-bordered table-condensed dataTables-example dataTable no-footer">
		<tbody>
			<tr>
					<td class="width-15 active"><label class="pull-right"><font color="red">*</font> 单号：</label></td>
					<td class="width-35" colspan="3">
						<form:input path="no" htmlEscape="false" maxlength="30" class="form-control input-xlarge required"/>
					</td>
					
				</tr>
				<tr> 
					<td class="width-15 active"><label class="pull-right"><font color="red">*</font> 调出仓库：</label></td>
					<td class="width-35 ">
					<div class="input-xlarge">
						
						<sys:spinnerselect id="outWarehouse" name="outWarehouse.id" value="${wmsAllot.outWarehouse.id}" labelName="outWarehouse.name" labelValue="${wmsAllot.outWarehouse.name}" 
								title="仓库" url="${ctx}/wms/wmsWarehouse/getSelectData" cssClass="form-control required" allowEmpty="false"></sys:spinnerselect>
								
					</div>
					</td>
					<td class="width-15 active"><label class="pull-right"><font color="red">*</font> 调入出库：</label></td>
					<td class="width-35 ">
					<div class="input-xlarge">
					
						<sys:spinnerselect id="inWarehouse" name="inWarehouse.id" value="${wmsAllot.inWarehouse.id}" labelName="inWarehouse.name" labelValue="${wmsAllot.inWarehouse.name}" 
								title="仓库" url="${ctx}/wms/wmsWarehouse/getSelectData" cssClass="form-control required" allowEmpty="false"></sys:spinnerselect>
								
					</div>
					</td>
				</tr>
				<tr> 
					
					<td class="width-15 active"><label class="pull-right">物流公司：</label></td>
					<td class="width-35">
						<form:input path="logisticsCompany" htmlEscape="false" maxlength="50" class="form-control input-xlarge"/>
					</td>
					<td class="width-15 active"><label class="pull-right">物流单号：</label></td>
					<td class="width-35">
						<form:input path="logisticsNo" htmlEscape="false" maxlength="50" class="form-control input-xlarge"/>
					</td>
				</tr>
				<tr> 
					
					<td class="width-15 active"><label class="pull-right">运费：</label></td>
					<td class="width-35">
						<form:input path="logisticsAmount" htmlEscape="false" class="form-control input-xlarge number" min="0.01" maxlength="10"/>
					</td>
					<td class="width-15 active"><label class="pull-right">支付账户：</label></td>
					<td class="width-35 ">
					<div class="input-xlarge">
						<sys:spinnerselect id="fiAccount" name="fiAccount.id" value="${wmsAllot.fiAccount.id}" labelName="fiAccount.name" labelValue="${wmsAllot.fiAccount.name}" 
							title="结算账户" url="${ctx}/fi/fiFinanceAccount/getSelectData" cssClass="form-control" allowEmpty="true"></sys:spinnerselect>
					</div>
					</td>
				</tr>
				
				<tr> 
					<td class="width-15 active"><label class="pull-right"><font color="red">*</font> 经办人：</label></td>
					<td class="width-35">
					<div class="input-xlarge">
						<sys:treeselect id="dealBy" name="dealBy.id" value="${wmsAllot.dealBy.id}" labelName="dealBy.name" labelValue="${wmsAllot.dealBy.name}"
								title="用户" url="/sys/office/treeData?type=3" cssClass="form-control  required" allowClear="true" notAllowSelectParent="true"/>
					</div>			
					</td>
					<td class="width-15 active"><label class="pull-right"><font color="red">*</font> 业务日期：</label></td>
					<td class="width-35">
					<div class="input-xlarge">	
						<div class="input-group date datepicker">
								<input name="dealDate" type="text" readonly="readonly" class="form-control" value="<fmt:formatDate value="${wmsAllot.dealDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
	                     		<span class="input-group-addon">
	                             	<span class="fa fa-calendar"></span>
	                     		</span>
                     	</div>
					</div>
					</td>
				</tr>
				
				<tr> 
					<td class="width-15 active"><label class="pull-right">备注信息：</label></td>
					<td class="width-35" colspan="3">
						<form:textarea path="remarks" htmlEscape="false" rows="2" maxlength="50" class="form-control input-xxlarge"/>
					</td>
				</tr>
					
			</tbody>
		</table>
		<!-- 明细 -->
		<div class="tabs-container">
	    	<ul class="nav nav-tabs">
				<li class="active"><a data-toggle="tab" href="#tab-1" aria-expanded="true">调拨单明细</a></li>
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
								<th>数量</th>
								<th>备注</th>
								<shiro:hasPermission name="wms:wmsAllot:edit"><th width="10">&nbsp;</th></shiro:hasPermission>
							</tr>
						</thead>
						<tbody id="wmsAllotDetailList">
						</tbody>
						<shiro:hasPermission name="wms:wmsAllot:edit"><tfoot>
							<tr>
								<td colspan="5">
									<wms:manyselect id="wmsAllotDetailTag" name="wmsAllotDetailTag" value="选择"
										title="产品列表（可多选）" url="${ctx}/wms/wmsProduct/selectListForCommon" 
										cssClass="btn"  allowClear="false" 
										allowInput="false" checkRepeat="true"/>
									<input name="delSelectIds" type="hidden" />
								</td>
							</tr>
						</tfoot></shiro:hasPermission>
					</table>
					<script type="text/template" id="wmsAllotDetailTpl">//<!--
						<tr id="wmsAllotDetailList{{idx}}">
							<td class="hide">
								<input id="wmsAllotDetailList{{idx}}_id" name="wmsAllotDetailList[{{idx}}].id" type="hidden" value="{{row.id}}"/>
								<input id="wmsAllotDetailList{{idx}}_delFlag" name="wmsAllotDetailList[{{idx}}].delFlag" type="hidden" value="0"/>
								<input id="wmsAllotDetailList{{idx}}_sort" name="wmsAllotDetailList[{{idx}}].sort" type="hidden" value="{{idx}}"/>
							</td>
							<td>
								<input id="wmsAllotDetailList{{idx}}_product" name="wmsAllotDetailList[{{idx}}].product.id" type="hidden" value="{{row.product.id}}"/>
								<input id="wmsAllotDetailList{{idx}}_name" name="wmsAllotDetailList[{{idx}}].product.name" type="text" value="{{row.product.name}}"  class="input required" readonly="true"/>
								<span class="help-inline"><font color="red">*</font> </span>
							</td>
							<td>								
								<input id="wmsAllotDetailList{{idx}}_spec" name="wmsAllotDetailList[{{idx}}].product.spec" type="text" value="{{row.product.spec}}" maxlength="11" class="form-control input-mini" style="border:0;"/>
							</td>
							<td>								
								<input id="wmsAllotDetailList{{idx}}_unitType" name="wmsAllotDetailList[{{idx}}].unitType" type="text" value="{{row.unitType}}" maxlength="11" class="form-control input-mini" style="border:0;"/>
							</td>
							<td>
								<input id="wmsAllotDetailList{{idx}}_num" name="wmsAllotDetailList[{{idx}}].num" type="text" value="{{row.num}}" min="1" maxlength="11" class="form-control input-mini required digits" onkeyup="comInput()"/>
							</td>

							<td>
								<input id="wmsAllotDetailList{{idx}}_remarks" name="wmsAllotDetailList[{{idx}}].remarks" type="text" value="{{row.remarks}}" maxlength="50" class="form-control input-small "/>
							</td>
							
							<shiro:hasPermission name="wms:wmsAllot:edit"><td class="text-center" width="10">
								{{#delBtn}}<span class="close" onclick="delRow(this, '#wmsAllotDetailList{{idx}}')" title="删除">&times;</span>{{/delBtn}}
							</td></shiro:hasPermission>
						</tr>//-->
					</script>
					<script type="text/javascript">
						var wmsAllotDetailRowIdx = 0, wmsAllotDetailTpl = $("#wmsAllotDetailTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g,"");
						$(document).ready(function() {
							var data = ${fns:toJson(wmsAllot.wmsAllotDetailList)};
							for (var i=0; i<data.length; i++){
								addRow('#wmsAllotDetailList', wmsAllotDetailRowIdx, wmsAllotDetailTpl, data[i]);
								wmsAllotDetailRowIdx = wmsAllotDetailRowIdx + 1;
							}
						});
						//计算
						function comInput(){
							var total_num = 0;//总数量
							
							var mytable = document.getElementById("contentTable");
							for(var i=0; i<mytable.rows.length; i++){
								
								//判断元素是否存在
								if($("#wmsAllotDetailList"+i+"_name").length > 0) {
									
									//数量		
									var num = $("#wmsAllotDetailList"+i+"_num").val();
									
									
									//计算总数量	
									if(num != null && num != '' && !isNaN(num)){
										total_num += parseInt(num);
									}									
								}								
							}
							
							$("#num").val(total_num);
						}
					</script>
					<div class="pull-right">
						总数量：<form:input path="num" htmlEscape="false" maxlength="11" class="form-control input-mini digits" readonly="true" style="border:0;"/>
					</div>
					</div>
				</div>
			</div>
		</div>
		
		<br>
			<div class="form-actions">
				<shiro:hasPermission name="wms:wmsAllot:edit"><input id="btnSubmit" class="btn btn-success" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
				<input id="btnCancel" class="btn btn-white" type="button" value="返 回" onclick="history.go(-1)"/>
			</div>
		<br>
	</form:form>
	</div>
</div>
</div>
</body>
</html>