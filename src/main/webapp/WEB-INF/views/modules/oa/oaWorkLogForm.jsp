<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>工作报告编辑</title>
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
		<h5>工作报告${not empty oaWorkLog.id?'编辑':'新增'}</h5>
	</div>
	<div class="ibox-content">
		<sys:message content="${message}"/>
		<form:form id="inputForm" modelAttribute="oaWorkLog" action="${ctx}/oa/oaWorkLog/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-2 control-label"><font color="red">*</font> 报告类型：</label>
						<div class="col-sm-10">
							<form:radiobuttons path="workLogType" items="${fns:getDictList('work_log_type')}" itemLabel="label" itemValue="value" htmlEscape="false" class="i-checks required"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-2 control-label"><font color="red">*</font> 报告标题：</label>
						<div class="col-sm-10">
							<form:input path="title" htmlEscape="false" maxlength="50" class="form-control required"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-2 control-label"><font color="red">*</font> 报告内容：</label>
						<div class="col-sm-10">
							<form:textarea path="content" htmlEscape="false" rows="8" maxlength="1000" class="form-control required"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-2 control-label"><font color="red">*</font> 汇报给：</label>
						<div class="col-sm-10">
							<sys:treeselect id="oaWorkLogRecord" name="oaWorkLogRecordIds" value="${oaWorkLog.oaWorkLogRecordIds}" labelName="oaWorkLogRecordNames" labelValue="${oaWorkLog.oaWorkLogRecordNames}"
										title="用户" url="/sys/office/treeData?type=3" cssClass="form-control required" notAllowSelectParent="true" checked="true"/>
						</div>
					</div>
				</div>
			</div>
		
		<%-- 
		<div class="tabs-container">
	    	<ul class="nav nav-tabs">
				<li class="active"><a data-toggle="tab" href="#tab-1" aria-expanded="true">工作报告查阅记录</a></li>
	    	</ul>
          	<div class="tab-content">
          	   	<div class="panel-body">
					<div id="tab-1" class="tab-pane table-responsive active">
					<table id="contentTable" class="table table-striped table-bordered table-hover table-condensed">
						<thead>
							<tr>
								<th class="hide"></th>
								<th>查阅人</th>
								<th>阅读标记</th>
								<th>阅读时间</th>
								<th>评论内容</th>
								<shiro:hasPermission name="oa:oaWorkLog:edit"><th width="10">&nbsp;</th></shiro:hasPermission>
							</tr>
						</thead>
						<tbody id="oaWorkLogRecordList">
						</tbody>
						<shiro:hasPermission name="oa:oaWorkLog:edit"><tfoot>
							<tr><td colspan="6"><a href="javascript:" onclick="addRow('#oaWorkLogRecordList', oaWorkLogRecordRowIdx, oaWorkLogRecordTpl);oaWorkLogRecordRowIdx = oaWorkLogRecordRowIdx + 1;" class="btn">新增</a></td></tr>
						</tfoot></shiro:hasPermission>
					</table>
					<script type="text/template" id="oaWorkLogRecordTpl">//<!--
						<tr id="oaWorkLogRecordList{{idx}}">
							<td class="hide">
								<input id="oaWorkLogRecordList{{idx}}_id" name="oaWorkLogRecordList[{{idx}}].id" type="hidden" value="{{row.id}}"/>
								<input id="oaWorkLogRecordList{{idx}}_delFlag" name="oaWorkLogRecordList[{{idx}}].delFlag" type="hidden" value="0"/>
							</td>
							<td>
								<sys:treeselect id="oaWorkLogRecordList{{idx}}_user" name="oaWorkLogRecordList[{{idx}}].user.id" value="{{row.user.id}}" labelName="oaWorkLogRecordList{{idx}}.user.name" labelValue="{{row.user.name}}"
									title="用户" url="/sys/office/treeData?type=3" cssClass="form-control " allowClear="true" notAllowSelectParent="true"/>
							</td>
							<td>
								<select id="oaWorkLogRecordList{{idx}}_readFlag" name="oaWorkLogRecordList[{{idx}}].readFlag" data-value="{{row.readFlag}}" class="form-control input-small">
									<option value=""></option>
									<c:forEach items="${fns:getDictList('read_flag')}" var="dict">
										<option value="${dict.value}">${dict.label}</option>
									</c:forEach>
								</select>
							</td>
							<td>
								<input id="oaWorkLogRecordList{{idx}}_readDate" name="oaWorkLogRecordList[{{idx}}].readDate" type="text" readonly="readonly" maxlength="20" class="form-control laydate-icon form-control input-medium "
									value="{{row.readDate}}" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/>
							</td>
							<td>
								<textarea id="oaWorkLogRecordList{{idx}}_auditNotes" name="oaWorkLogRecordList[{{idx}}].auditNotes" rows="4" maxlength="50" class="form-control input-small ">{{row.auditNotes}}</textarea>
							</td>
							<shiro:hasPermission name="oa:oaWorkLog:edit"><td class="text-center" width="10">
								{{#delBtn}}<span class="close" onclick="delRow(this, '#oaWorkLogRecordList{{idx}}')" title="删除">&times;</span>{{/delBtn}}
							</td></shiro:hasPermission>
						</tr>//-->
					</script>
					<script type="text/javascript">
						var oaWorkLogRecordRowIdx = 0, oaWorkLogRecordTpl = $("#oaWorkLogRecordTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g,"");
						$(document).ready(function() {
							var data = ${fns:toJson(oaWorkLog.oaWorkLogRecordList)};
							for (var i=0; i<data.length; i++){
								addRow('#oaWorkLogRecordList', oaWorkLogRecordRowIdx, oaWorkLogRecordTpl, data[i]);
								oaWorkLogRecordRowIdx = oaWorkLogRecordRowIdx + 1;
							}
						});
					</script>
					</div>
				</div>
			</div>
		</div>
		--%>
			<div class="hr-line-dashed"></div>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<div class="col-sm-offset-2 col-sm-10">
							<button id="btnSubmit" class="btn btn-success" type="submit">提交</button>&nbsp;
							<button id="btnCancel" class="btn btn-white" type="button" onclick="history.go(-1)">返回</button>
						</div>
					</div>
				</div>
			</div>
		</form:form>
	</div>
</div>
</div>
</body>
</html>