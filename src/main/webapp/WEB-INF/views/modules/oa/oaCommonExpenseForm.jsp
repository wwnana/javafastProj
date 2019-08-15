<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>报销单编辑</title>
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
			<h5>新建报销单</h5>
		</div>
		<div class="ibox-content">
		<sys:message content="${message}"/>
		<form:form id="inputForm" modelAttribute="oaCommonExpense" action="${ctx}/oa/oaCommonExpense/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<form:hidden path="oaCommonAudit.oaCommonFlowId"/>
		<h4 class="page-header">基本信息</h4>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-2 control-label"><font color="red">*</font> 标题</label>
						<div class="col-sm-10">
							<form:input path="oaCommonAudit.title" htmlEscape="false" maxlength="50" class="form-control required"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-2 control-label"><font color="red">*</font> 内容</label>
						<div class="col-sm-10">
							<form:textarea path="oaCommonAudit.content" htmlEscape="false" rows="4" class="form-control required"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-2 control-label"> 附件</label>
						<div class="col-sm-10">
							<form:hidden id="files" path="oaCommonAudit.files" htmlEscape="false" maxlength="1000" class="form-control"/>
							<sys:ckfinder input="files" type="files" uploadPath="/file" selectMultiple="true"/>
						</div>
					</div>
				</div>
			</div>
			<h4 class="page-header">报销信息</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 报销总额</label>
						<div class="col-sm-8">
							<form:input path="amount" htmlEscape="false" min="0.01" maxlength="12" class="form-control number required"/>
						</div>
					</div>
				</div>
			</div>
		
		<!-- 明细 -->
		<div class="tabs-container">
	    	<ul class="nav nav-tabs">
				<li class="active"><a data-toggle="tab" href="#tab-1" aria-expanded="true">报销单明细</a></li>
	    	</ul>
          	<div class="tab-content">
          	   	<div class="panel-body">
					<div id="tab-1" class="tab-pane table-responsive active">
					<table id="contentTable" class="table table-striped table-bordered table-hover table-condensed">
						<thead>
							<tr>
								<th class="hide"></th>
								<th>报销事项</th>
								<th>日期</th>
								<th>报销金额（元）</th>
								<th width="10">&nbsp;</th>
							</tr>
						</thead>
						<tbody id="oaCommonExpenseDetailList">
						</tbody>
						<tfoot>
							<tr><td colspan="5"><a href="javascript:" onclick="addRow('#oaCommonExpenseDetailList', oaCommonExpenseDetailRowIdx, oaCommonExpenseDetailTpl);oaCommonExpenseDetailRowIdx = oaCommonExpenseDetailRowIdx + 1;" class="btn">新增</a></td></tr>
						</tfoot>
					</table>
					<script type="text/template" id="oaCommonExpenseDetailTpl">//<!--
						<tr id="oaCommonExpenseDetailList{{idx}}">
							<td class="hide">
								<input id="oaCommonExpenseDetailList{{idx}}_id" name="oaCommonExpenseDetailList[{{idx}}].id" type="hidden" value="{{row.id}}"/>
								<input id="oaCommonExpenseDetailList{{idx}}_delFlag" name="oaCommonExpenseDetailList[{{idx}}].delFlag" type="hidden" value="0"/>
							</td>
							<td>
								<input id="oaCommonExpenseDetailList{{idx}}_itemName" name="oaCommonExpenseDetailList[{{idx}}].itemName" type="text" value="{{row.itemName}}" maxlength="50" class="form-control input-xlarge required"/>
							</td>
							<td>
								<input id="oaCommonExpenseDetailList{{idx}}_date" name="oaCommonExpenseDetailList[{{idx}}].date" type="text" readonly="readonly" maxlength="20" class="form-control laydate-icon form-control input-medium required"
									value="{{row.date}}" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
							</td>
							<td>
								<input id="oaCommonExpenseDetailList{{idx}}_amount" name="oaCommonExpenseDetailList[{{idx}}].amount" type="text" value="{{row.amount}}" class="form-control input-small required number" min="0.01" maxlength="12"/>
							</td>
							<td class="text-center" width="10">
								{{#delBtn}}<span class="close" onclick="delRow(this, '#oaCommonExpenseDetailList{{idx}}')" title="删除">&times;</span>{{/delBtn}}
							</td>
						</tr>//-->
					</script>
					<script type="text/javascript">
						var oaCommonExpenseDetailRowIdx = 0, oaCommonExpenseDetailTpl = $("#oaCommonExpenseDetailTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g,"");
						$(document).ready(function() {
							var data = ${fns:toJson(oaCommonExpense.oaCommonExpenseDetailList)};
							for (var i=0; i<data.length; i++){
								addRow('#oaCommonExpenseDetailList', oaCommonExpenseDetailRowIdx, oaCommonExpenseDetailTpl, data[i]);
								oaCommonExpenseDetailRowIdx = oaCommonExpenseDetailRowIdx + 1;
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