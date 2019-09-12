<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>任务管理</title>
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
	<script type="text/javascript">
	function toSelect(title, url){
		// 是否限制选择，如果限制，设置为disabled
		if ($("#${id}Button").hasClass("disabled")){
			return true;
		}
		
		top.layer.open({
		    type: 2,  
		    area: ['1000px', '500px'],
		    title:title,
		    name:'friend',
		    content:url,
		    btn: ['确定', '关闭'],
		    yes: function(index, layero){
		    	 var iframeWin = layero.find('iframe')[0].contentWindow; //得到iframe页的窗口对象，执行iframe页的方法：iframeWin.method();
		    	 var item = iframeWin.getSelectedItem();

		    	 if(item == "-1"){
			    	 return;
		    	 }
		    	
		    	 $("#relationId").val(item.split('_item_')[0]);
		    	 $("#relationName").val(item.split('_item_')[1]);
				 top.layer.close(index);//关闭对话框。
			  },
			  cancel: function(index){ 
		       }
		}); 
	}
	
	function showRelation(){
		
		var relationType = $('#relationType option:selected').val();
		//alert(relationType);
		if(relationType == null || relationType == "" || relationType == "99"){
			$("#select_div").hide();
		}else{
			$("#select_div").show();
		}
		if(relationType == "20"){
			toSelect("项目", "${ctx}/oa/oaProject/selectList");
		}
		if(relationType == "0"){
			toSelect("客户", "${ctx}/crm/crmCustomer/selectList");
		}
		if(relationType == "1"){
			toSelect("联系人", "${ctx}/crm/crmContacter/selectList");
		}
		if(relationType == "3"){
			toSelect("商机", "${ctx}/crm/crmChance/selectList");
		}
		if(relationType == "4"){
			toSelect("报价", "${ctx}/crm/crmQuote/selectList");
		}
		if(relationType == "5"){
			toSelect("订单合同", "${ctx}/om/omContract/selectList");
		}		
		if(relationType == "11"){
			toSelect("采购", "${ctx}/wms/wmsPurchase/selectList");
		}		
		if(relationType == "12"){
			toSelect("入库", "${ctx}/wms/wmsInstock/selectList");
		}
		if(relationType == "13"){
			toSelect("出库", "${ctx}/wms/wmsOutstock/selectList");
		}
	}
</script>
</head>
<body class="gray-bg">
<div class="wrapper-content">
	<div class="ibox">
		<div class="ibox-title">
			<h5>任务${not empty oaTask.id?'修改':'添加'}</h5>
		</div>
		<div class="ibox-content">
			<sys:message content="${message}"/>	
			
			<form:form id="inputForm" modelAttribute="oaTask" action="${ctx}/oa/oaTask/save" method="post" class="form-horizontal">
			<form:hidden path="id"/>
			<form:hidden path="no"/>
			<form:hidden path="relationType"/>
			<form:hidden path="relationId"/>
			<form:hidden path="relationName"/>
			<form:hidden path="status"/>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 任务名称</label>
						<div class="col-sm-8">
							<form:input path="name" htmlEscape="false" maxlength="50" class="form-control required"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 任务阶段</label>
						<div class="col-sm-8">
							<form:select path="procDef" class="form-control" onchange="showRelation()">
								<form:options items="${procList}"  htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</div>
			</div>
			
			<%-- 
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 任务类型</label>
						<div class="col-sm-8">
							<form:select path="relationType" class="form-control" onchange="showRelation()">
								<form:options items="${fns:getDictList('relation_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</div>
			</div>
			<div class="row" id="select_div" style="<c:if test='${oaTask.relationType == 99}'>display:none;</c:if>">
				<div class="col-sm-6" >
					<div class="form-group">
						<label class="col-sm-4 control-label">关联对象</label>
						<div class="col-sm-8">
								<input id="relationId" name="relationId" class="${cssClass}" type="hidden" value="${oaTask.relationId}"/>
								<input id="relationName" name="relationName" type="text" value="${oaTask.relationName}" class="form-control"/>
						</div>
					</div>
				</div>
			</div>
			--%>
			
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 截止日期</label>
						<div class="col-sm-8">
							<div class="input-group date datepicker">
		                     	<input name="endDate" type="text" readonly="readonly" class="form-control required" value="<fmt:formatDate value="${oaTask.endDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
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
						<label class="col-sm-4 control-label"><font color="red">*</font> 优先级</label>
						<div class="col-sm-8">
							<form:select path="levelType" class="form-control">
								<form:option value="" label=""/>
								<form:options items="${fns:getDictList('level_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 负责人</label>
						<div class="col-sm-8">
							<sys:treeselect id="ownBy" name="ownBy.id" value="${oaTask.ownBy.id}" labelName="ownBy.name" labelValue="${oaTask.ownBy.name}"
								title="用户" url="/sys/office/treeData?type=3" cssClass="form-control required" allowClear="true" notAllowSelectParent="true"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label">抄送给</label>
						<div class="col-sm-8">
							<sys:treeselect id="oaTaskRecord" name="oaTaskRecordIds" value="${oaTask.oaTaskRecordIds}" labelName="oaTaskRecordNames" labelValue="${oaTask.oaTaskRecordNames}"
							title="用户" url="/sys/office/treeData?type=3" cssClass="form-control" notAllowSelectParent="true" checked="true"/>
						</div>
					</div>
				</div>
			</div>
			
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-2 control-label">任务描述</label>
						<div class="col-sm-8">
							<form:textarea path="content" htmlEscape="false" rows="6" class="form-control"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-2 control-label">相关附件</label>
						<div class="col-sm-10">
							<form:hidden id="files" path="files" htmlEscape="false" maxlength="2000" class="form-control"/>
							<sys:ckfinder input="files" type="files" uploadPath="/file" selectMultiple="true"/>
						</div>
					</div>
				</div>
			</div>
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
	</div></div>
</div>
</body>
</html>