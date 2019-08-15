<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>应付款编辑</title>
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
<body class="hideScroll">
	<form:form id="inputForm" modelAttribute="fiPaymentAble" action="${ctx}/fi/fiPaymentAble/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>	
	 <table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
		<tbody>
			<tr>
					<td class="width-15 active"><label class="pull-right"><font color="red">*</font> 单号：</label></td>
					<td class="width-35">
						<form:input path="no" htmlEscape="false" maxlength="50" class="form-control input-xlarge required" readonly="true"/>
					</td>
					<td class="width-15 active"><label class="pull-right"><font color="red">*</font> 采购单：</label></td>
					<td class="width-35">
						<sys:tableselect id="purchase" name="purchase.id" value="${fiPaymentAble.purchase.id}" labelName="purchase.name" labelValue="${fiPaymentAble.purchase.name}" 
							title="采购单" url="${ctx}/wms/wmsPurchase/selectList" cssClass="form-control input-xlarge required" dataMsgRequired="必选"  allowClear="false" allowInput="false" disabled="disabled"/>
							
					</td>
				</tr>
				<tr> 
					<td class="width-15 active"><label class="pull-right">供应商：</label></td>
					<td class="width-35">
						<sys:tableselect id="supplier" name="supplier.id" value="${fiPaymentAble.supplier.id}" labelName="supplier.name" labelValue="${fiPaymentAble.supplier.name}" 
										title="供应商" url="${ctx}/wms/wmsSupplier/selectList" cssClass="form-control input-xlarge required" dataMsgRequired="必选"  allowClear="false" allowInput="false" disabled="disabled"/>
					</td>
					<td class="width-15 active"><label class="pull-right"><font color="red">*</font> 应付金额：</label></td>
					<td class="width-35">
						<form:input path="amount" htmlEscape="false" class="form-control input-xlarge required" readonly="true"/>
					</td>
				</tr>
				<tr> 
					<td class="width-15 active"><label class="pull-right">实际已付：</label></td>
					<td class="width-35">
						<form:input path="realAmt" htmlEscape="false" class="form-control input-xlarge" readonly="true"/>
					</td>
					<td class="width-15 active"><label class="pull-right">应付时间：</label></td>
					<td class="width-35">
						<input name="ableDate" type="text" readonly="readonly" maxlength="20" class="laydate-icon form-control layer-date input-xlarge "
							value="<fmt:formatDate value="${fiPaymentAble.ableDate}" pattern="yyyy-MM-dd"/>"
							onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
					</td>
				</tr>
				<tr> 
					<td class="width-15 active"><label class="pull-right"><font color="red">*</font> 负责人：</label></td>
					<td class="width-35">
						<sys:treeselect id="ownBy" name="ownBy.id" value="${fiPaymentAble.ownBy.id}" labelName="ownBy.name" labelValue="${fiPaymentAble.ownBy.name}"
							title="用户" url="/sys/office/treeData?type=3" cssClass="form-control required" allowClear="false" notAllowSelectParent="true"/>
					</td>
					<td class="width-15 active"><label class="pull-right">状态：</label></td>
					<td class="width-35">
						<form:select path="status" class="form-control input-xlarge" disabled="true">
							<form:option value="" label=""/>
							<form:options items="${fns:getDictList('finish_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
						</form:select>
					</td>
				</tr>
				<tr> 
					<td class="width-15 active"><label class="pull-right">备注信息：</label></td>
					<td class="width-35" colspan="3">
						<form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="50" class="form-control input-xxlarge"/>
					</td>
				</tr>
			</tbody>
		</table>
		
	</form:form>
</body>
</html>