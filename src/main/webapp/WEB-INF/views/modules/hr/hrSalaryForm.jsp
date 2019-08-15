<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>工资表编辑</title>
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
		<h5>${hrSalary.year}年${hrSalary.month}月工资表</h5>
	</div>
	<div class="ibox-content">
		<sys:message content="${message}"/>
		<form:form id="inputForm" modelAttribute="hrSalary" action="${ctx}/hr/hrSalary/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<form:hidden path="year"/>
		<form:hidden path="month"/>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<div class="col-sm-8">
							&nbsp;&nbsp; 计薪月份：<input type="text" value="${hrSalary.year}年${hrSalary.month}月" readonly="readonly" class="form-control input-small">
							&nbsp;&nbsp; 应出勤天数：<form:input path="workDays" htmlEscape="false" maxlength="10" class="form-control input-small digits"/>
						</div>
					</div>
				</div>
			</div>
			<div class="table-responsive">
					<table id="contentTable" class="table table-striped table-bordered table-hover table-condensed">
						<thead>
							<tr>
								<th class="hide"></th>
								<td rowspan="2">序号</td>
								<th rowspan="2">姓名</th>								
								<th rowspan="2">应出勤天数</th>
								<th rowspan="2">实际出勤天数</th>
								<th rowspan="2">加班天数</th>
								<th colspan="5" class="text-center">应发工资</th>
								<th colspan="3" class="text-center">应扣工资</th>
								<th colspan="3" class="text-center">代扣工资</th>
								<th rowspan="2">实发工资</th>
								<th rowspan="2">操作</th>
							</tr>
							<tr>
								<th class="hide"></th>
								
								<th>基本工资</th>
								<th>岗位工资</th>
								<th>奖金工资</th>
								<th>加班工资</th>
								<th>应发合计</th>
								
								<th>请假天数</th>
								<th>旷工天数</th>
								<th>应扣工资</th>
								
								<th>社保</th>
								<th>公积金</th>
								<th>个税</th>
								
								
							</tr>
						</thead>
						<tbody id="hrSalaryDetailList">
						</tbody>
						<shiro:hasPermission name="hr:hrSalary:edit"><tfoot>
							<tr><td colspan="22"><a href="javascript:" onclick="addRow('#hrSalaryDetailList', hrSalaryDetailRowIdx, hrSalaryDetailTpl);hrSalaryDetailRowIdx = hrSalaryDetailRowIdx + 1;" class="btn">新增</a></td></tr>
						</tfoot></shiro:hasPermission>
					</table>
					<script type="text/template" id="hrSalaryDetailTpl">//<!--
						<tr id="hrSalaryDetailList{{idx}}">
							<td class="hide">
								<input id="hrSalaryDetailList{{idx}}_id" name="hrSalaryDetailList[{{idx}}].id" type="hidden" value="{{row.id}}"/>
								<input id="hrSalaryDetailList{{idx}}_delFlag" name="hrSalaryDetailList[{{idx}}].delFlag" type="hidden" value="0"/>
								<input id="hrSalaryDetailList{{idx}}_hrEmployeeId" name="hrSalaryDetailList[{{idx}}].hrEmployeeId" type="hidden" value="{{row.hrEmployeeId}}"/>
							</td>
							<td>{{idx}}</td>
							<td>
								<input id="hrSalaryDetailList{{idx}}_name" name="hrSalaryDetailList[{{idx}}].name" type="text" value="{{row.name}}" maxlength="50" class="form-control input-mini "/>
							</td>
							<td>
								<input id="hrSalaryDetailList{{idx}}_mustWorkDays" name="hrSalaryDetailList[{{idx}}].mustWorkDays" type="text" value="{{row.mustWorkDays}}" maxlength="10" class="form-control input-mini  digits"/>
							</td>
							<td>
								<input id="hrSalaryDetailList{{idx}}_realWorkDays" name="hrSalaryDetailList[{{idx}}].realWorkDays" type="text" value="{{row.realWorkDays}}" maxlength="10" class="form-control input-mini  digits"/>
							</td>
							<td>
								<input id="hrSalaryDetailList{{idx}}_extraWorkDays" name="hrSalaryDetailList[{{idx}}].extraWorkDays" type="text" value="{{row.extraWorkDays}}" maxlength="10" class="form-control input-mini  digits"/>
							</td>
							
							<td>
								<input id="hrSalaryDetailList{{idx}}_baseSalary" name="hrSalaryDetailList[{{idx}}].baseSalary" type="text" value="{{row.baseSalary}}" class="form-control input-mini "/>
							</td>
							<td>
								<input id="hrSalaryDetailList{{idx}}_postSalary" name="hrSalaryDetailList[{{idx}}].postSalary" type="text" value="{{row.postSalary}}" class="form-control input-mini "/>
							</td>
							<td>
								<input id="hrSalaryDetailList{{idx}}_bonusSalary" name="hrSalaryDetailList[{{idx}}].bonusSalary" type="text" value="{{row.bonusSalary}}" class="form-control input-mini "/>
							</td>
							<td>
								<input id="hrSalaryDetailList{{idx}}_overtimeSalary" name="hrSalaryDetailList[{{idx}}].overtimeSalary" type="text" value="{{row.overtimeSalary}}" class="form-control input-mini "/>
							</td>
							<td>
								<input id="hrSalaryDetailList{{idx}}_shouldAmt" name="hrSalaryDetailList[{{idx}}].shouldAmt" type="text" value="{{row.shouldAmt}}" class="form-control input-mini "/>
							</td>
							<td>
								<input id="hrSalaryDetailList{{idx}}_leaveDays" name="hrSalaryDetailList[{{idx}}].leaveDays" type="text" value="{{row.leaveDays}}" maxlength="10" class="form-control input-mini  digits"/>
							</td>
							<td>
								<input id="hrSalaryDetailList{{idx}}_absentDays" name="hrSalaryDetailList[{{idx}}].absentDays" type="text" value="{{row.absentDays}}" maxlength="10" class="form-control input-mini  digits"/>
							</td>
							<td>
								<input id="hrSalaryDetailList{{idx}}_seductSalary" name="hrSalaryDetailList[{{idx}}].seductSalary" type="text" value="{{row.seductSalary}}" class="form-control input-mini "/>
							</td>
							<td>
								<input id="hrSalaryDetailList{{idx}}_socialAmt" name="hrSalaryDetailList[{{idx}}].socialAmt" type="text" value="{{row.socialAmt}}" class="form-control input-mini "/>
							</td>
							<td>
								<input id="hrSalaryDetailList{{idx}}_fundAmt" name="hrSalaryDetailList[{{idx}}].fundAmt" type="text" value="{{row.fundAmt}}" class="form-control input-mini "/>
							</td>
							<td>
								<input id="hrSalaryDetailList{{idx}}_taxAmt" name="hrSalaryDetailList[{{idx}}].taxAmt" type="text" value="{{row.taxAmt}}" class="form-control input-mini "/>
							</td>
							
							<td>
								<input id="hrSalaryDetailList{{idx}}_realAmt" name="hrSalaryDetailList[{{idx}}].realAmt" type="text" value="{{row.realAmt}}" class="form-control input-mini "/>
							</td>
							
							<shiro:hasPermission name="hr:hrSalary:edit"><td class="text-center" width="10">
								{{#delBtn}}<span class="close" onclick="delRow(this, '#hrSalaryDetailList{{idx}}')" title="删除">&times;</span>{{/delBtn}}
							</td></shiro:hasPermission>
						</tr>//-->
					</script>
					<script type="text/javascript">
						var hrSalaryDetailRowIdx = 0, hrSalaryDetailTpl = $("#hrSalaryDetailTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g,"");
						$(document).ready(function() {
							var data = ${fns:toJson(hrSalary.hrSalaryDetailList)};
							for (var i=0; i<data.length; i++){
								addRow('#hrSalaryDetailList', hrSalaryDetailRowIdx, hrSalaryDetailTpl, data[i]);
								hrSalaryDetailRowIdx = hrSalaryDetailRowIdx + 1;
							}
						});
					</script>
					
			</div>
			<div class="hr-line-dashed"></div>
			<div class="form-actions">
				<shiro:hasPermission name="hr:hrSalary:edit">
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