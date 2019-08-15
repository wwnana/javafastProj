<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>审批流程编辑</title>
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
			$("#oaCommonAuditRecordList"+idx+"_auditOrder").val(idx+1);
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
			if('${oaCommonAudit.oaCommonFlowId}' == null || '${oaCommonAudit.oaCommonFlowId}' == ''){
				if($("#oaCommonAuditRecordList tr").length == 0){
					layer.alert("必须设置流程执行顺序");
					return false;
				}
			}
			
			return true;
		}
	</script>
</head>
<body class="gray-bg">
<div class="wrapper-content">
	<div class="ibox">
		<div class="ibox-title">
			<h5>新建${oaCommonFlow.title}<c:if test="${empty oaCommonFlow.title}">自定义流程</c:if></h5>
		</div>
		<div class="ibox-content">
			<sys:message content="${message}"/>
			
			<form:form id="inputForm" modelAttribute="oaCommonAudit" action="${ctx}/oa/oaCommonAudit/save" method="post" class="form-horizontal">
			<form:hidden path="id"/>
			<form:hidden path="oaCommonFlowId"/>
			
			<h4 class="page-header">申请信息</h4>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-2 control-label"><font color="red">*</font> 标题</label>
						<div class="col-sm-10">
							<form:input path="title" htmlEscape="false" maxlength="50" class="form-control required"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-2 control-label"><font color="red">*</font> 内容</label>
						<div class="col-sm-10">
							<form:textarea path="content" htmlEscape="false" rows="4" class="form-control required"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-2 control-label"> 附件</label>
						<div class="col-sm-10">
							<form:hidden id="files" path="files" htmlEscape="false" maxlength="1000" class="form-control"/>
							<sys:ckfinder input="files" type="files" uploadPath="/file" selectMultiple="true"/>
						</div>
					</div>
				</div>
			</div>
			<h4 class="page-header">设置流程执行顺序</h4>
	 		<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-2 control-label"> </label>
						<div class="col-sm-10">
							<c:if test="${empty oaCommonAudit.oaCommonFlowId}">
								<table id="contentTable" class="table table-striped table-bordered table-hover table-condensed">
						<thead>
							<tr>
								<th class="hide"></th>
								<th width="30%">执行顺序</th>
								<th width="30%">执行类型</th>
								<th width="30%">执行人</th>
								<shiro:hasPermission name="oa:oaCommonAudit:edit"><th width="10">&nbsp;</th></shiro:hasPermission>
							</tr>
						</thead>
						<tbody id="oaCommonAuditRecordList">
						</tbody>
						<shiro:hasPermission name="oa:oaCommonAudit:edit"><tfoot>
							<tr><td colspan="10"><a href="javascript:" onclick="addRow('#oaCommonAuditRecordList', oaCommonAuditRecordRowIdx, oaCommonAuditRecordTpl);oaCommonAuditRecordRowIdx = oaCommonAuditRecordRowIdx + 1;" class="btn">新增</a></td></tr>
						</tfoot></shiro:hasPermission>
					</table>
					<script type="text/template" id="oaCommonAuditRecordTpl">//<!--
						<tr id="oaCommonAuditRecordList{{idx}}">
							<td class="hide">
								<input id="oaCommonAuditRecordList{{idx}}_id" name="oaCommonAuditRecordList[{{idx}}].id" type="hidden" value="{{row.id}}"/>
								<input id="oaCommonAuditRecordList{{idx}}_delFlag" name="oaCommonAuditRecordList[{{idx}}].delFlag" type="hidden" value="0"/>
							</td>
							<td>
								<input id="oaCommonAuditRecordList{{idx}}_auditOrder" name="oaCommonAuditRecordList[{{idx}}].auditOrder" type="text" value="{{row.auditOrder}}" maxlength="5" class="form-control input-small digits" readonly="true"/>
							</td>
							<td>
								<select id="oaCommonAuditRecordList{{idx}}_dealType" name="oaCommonAuditRecordList[{{idx}}].dealType" data-value="{{row.dealType}}" class="form-control input-small required">
									<c:forEach items="${fns:getDictList('audit_deal_type')}" var="dict">
										<option value="${dict.value}">${dict.label}</option>
									</c:forEach>
								</select>
							</td>
							<td>
								<sys:treeselect id="oaCommonAuditRecordList{{idx}}_user" name="oaCommonAuditRecordList[{{idx}}].user.id" value="{{row.user.id}}" labelName="oaCommonAuditRecordList{{idx}}.user.name" labelValue="{{row.user.name}}"
									title="用户" url="/sys/office/treeData?type=3" cssClass="form-control required" allowClear="true" notAllowSelectParent="true"/>
							</td>
							<shiro:hasPermission name="oa:oaCommonAudit:edit"><td class="text-center" width="10">
								{{#delBtn}}<span class="close" onclick="delRow(this, '#oaCommonAuditRecordList{{idx}}')" title="删除">&times;</span>{{/delBtn}}
							</td></shiro:hasPermission>
						</tr>//-->
					</script>
					<script type="text/javascript">
						var oaCommonAuditRecordRowIdx = 0, oaCommonAuditRecordTpl = $("#oaCommonAuditRecordTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g,"");
						$(document).ready(function() {
							var data = ${fns:toJson(oaCommonAudit.oaCommonAuditRecordList)};
							for (var i=0; i<data.length; i++){
								addRow('#oaCommonAuditRecordList', oaCommonAuditRecordRowIdx, oaCommonAuditRecordTpl, data[i]);
								oaCommonAuditRecordRowIdx = oaCommonAuditRecordRowIdx + 1;
							}
						});
					</script>
							
							</c:if>
						</div>
					</div>
				</div>
			</div>

		
			<div class="hr-line-dashed"></div>
			<div class="form-group">
            	<div class="col-sm-4 col-sm-offset-2">
                	<input id="btnSubmit" class="btn btn-success" type="submit" value="提 交"/>
                    <input id="btnCancel" class="btn btn-white" type="button" value="返 回" onclick="history.go(-1)"/>
                </div>
            </div>
			</form:form>
		</div>
	</div>
</div>
</body>
</html>