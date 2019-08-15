<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>流程配置编辑</title>
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
			
			$("#oaCommonFlowDetailList"+idx+"_sort").val(idx+1);
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
		//自定义检查表身方法
		function checkChildren(){
			if($("#oaCommonFlowDetailList tr").length == 0){
				layer.alert("必须设置流程执行顺序");
				return false;
			}
			return true;
		}
	</script>
</head>
<body class="gray-bg">
<div class="wrapper-content">
<div class="ibox">
	<div class="ibox-title">
		<h5>流程配置${not empty oaCommonFlow.id?'修改':'添加'}</h5>
	</div>
	<div class="ibox-content">
	<sys:message content="${message}"/>
	
	<form:form id="inputForm" modelAttribute="oaCommonFlow" action="${ctx}/oa/oaCommonFlow/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
			<h4 class="page-header">基本信息</h4>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-2 control-label"><font color="red">*</font> 审批类型</label>
						<div class="col-sm-10">
							<form:select path="type" class="form-control required">
								<form:options items="${fns:getDictList('common_audit_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-2 control-label"><font color="red">*</font> 流程名称</label>
						<div class="col-sm-10">
							<form:input path="title" htmlEscape="false" maxlength="50" class="form-control required"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-2 control-label"><font color="red">*</font> 状态</label>
						<div class="col-sm-10">
							<form:select path="status" class="form-control required">
								<form:options items="${fns:getDictList('use_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-2 control-label"> 备注信息</label>
						<div class="col-sm-10">
							<form:textarea path="remarks" htmlEscape="false" rows="2" maxlength="50" class="form-control"/>
						</div>
					</div>
				</div>
			</div>
			<h4 class="page-header">执行顺序</h4>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-2 control-label"> </label>
						<div class="col-sm-10">
							<table id="contentTable" class="table table-striped table-bordered table-hover table-condensed">
						<thead>
							<tr>
								<th class="hide"></th>
								<th width="30%">执行顺序</th>
								<th width="30%">执行类型</th>
								<th width="30%">执行人</th>
								<shiro:hasPermission name="oa:oaCommonFlow:list"><th>&nbsp;</th></shiro:hasPermission>
							</tr>
						</thead>
						<tbody id="oaCommonFlowDetailList">
						</tbody>
						<shiro:hasPermission name="oa:oaCommonFlow:list"><tfoot>
							<tr><td colspan="5"><a href="javascript:" onclick="addRow('#oaCommonFlowDetailList', oaCommonFlowDetailRowIdx, oaCommonFlowDetailTpl);oaCommonFlowDetailRowIdx = oaCommonFlowDetailRowIdx + 1;" class="btn">新增</a></td></tr>
						</tfoot></shiro:hasPermission>
					</table>
					<script type="text/template" id="oaCommonFlowDetailTpl">//<!--
						<tr id="oaCommonFlowDetailList{{idx}}">
							<td class="hide">
								<input id="oaCommonFlowDetailList{{idx}}_id" name="oaCommonFlowDetailList[{{idx}}].id" type="hidden" value="{{row.id}}"/>
								<input id="oaCommonFlowDetailList{{idx}}_delFlag" name="oaCommonFlowDetailList[{{idx}}].delFlag" type="hidden" value="0"/>
							</td>
							<td>
								<input id="oaCommonFlowDetailList{{idx}}_sort" name="oaCommonFlowDetailList[{{idx}}].sort" type="text" value="{{row.sort}}" maxlength="5" class="form-control input-small digits required" readonly="true"/>
							</td>
							<td>
								<select id="oaCommonFlowDetailList{{idx}}_dealType" name="oaCommonFlowDetailList[{{idx}}].dealType" data-value="{{row.dealType}}" class="form-control input-small required">
									<c:forEach items="${fns:getDictList('audit_deal_type')}" var="dict">
										<option value="${dict.value}">${dict.label}</option>
									</c:forEach>
								</select>
							</td>
							<td>
									<sys:treeselect id="oaCommonFlowDetailList{{idx}}_user" name="oaCommonFlowDetailList[{{idx}}].user.id" value="{{row.user.id}}" labelName="oaCommonFlowDetailList{{idx}}.user.name" labelValue="{{row.user.name}}"
										title="用户" url="/sys/office/treeData?type=3" cssClass="form-control required" allowClear="true" notAllowSelectParent="true"/>
							</td>
							<shiro:hasPermission name="oa:oaCommonFlow:list"><td class="text-center" width="10">
								{{#delBtn}}<span class="close" onclick="delRow(this, '#oaCommonFlowDetailList{{idx}}')" title="删除">&times;</span>{{/delBtn}}
							</td></shiro:hasPermission>
						</tr>//-->
					</script>
					<script type="text/javascript">
						var oaCommonFlowDetailRowIdx = 0, oaCommonFlowDetailTpl = $("#oaCommonFlowDetailTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g,"");
						$(document).ready(function() {
							var data = ${fns:toJson(oaCommonFlow.oaCommonFlowDetailList)};
							for (var i=0; i<data.length; i++){
								addRow('#oaCommonFlowDetailList', oaCommonFlowDetailRowIdx, oaCommonFlowDetailTpl, data[i]);
								oaCommonFlowDetailRowIdx = oaCommonFlowDetailRowIdx + 1;
							}
						});
					</script>
							
						</div>
					</div>
				</div>
			</div>
			
		
			<div class="hr-line-dashed"></div>
			<div class="form-group">
            	<div class="col-sm-4 col-sm-offset-2">
                	<shiro:hasPermission name="oa:oaCommonFlow:list"><input id="btnSubmit" class="btn btn-success" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
                    <input id="btnCancel" class="btn btn-white" type="button" value="返 回" onclick="history.go(-1)"/>
                </div>
            </div>
	</form:form>
	</div>
</div>
</div>
</body>
</html>