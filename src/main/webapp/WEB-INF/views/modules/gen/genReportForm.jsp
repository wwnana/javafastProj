<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>图表配置编辑</title>
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
		
		function getSqlFields(){//解析SQL
			  if(validateForm.form()){
				  $("#inputForm").attr("action","${ctx}/gen/genReport/analyze");
				  $("#inputForm").submit();
				  return true;
			  }
			  return false;
		}
	</script>
</head>
<body>
<div class="ibox-content">
	<form:form id="inputForm" modelAttribute="genReport" action="${ctx}/gen/genReport/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}" hideType="1"/>	
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 名称：</label>
						<div class="col-sm-8">
							<form:input path="name" htmlEscape="false" maxlength="50" class="form-control required"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 描述：</label>
						<div class="col-sm-8">
							<form:input path="comments" htmlEscape="false" maxlength="50" class="form-control "/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 分类：</label>
						<div class="col-sm-8">
							<form:select path="countType" class="form-control required">
								<form:options items="${fns:getDictList('count_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 排序：</label>
						<div class="col-sm-8">
							<form:input path="sort" htmlEscape="false" maxlength="10" class="form-control digits"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 表名：</label>
						<div class="col-sm-8">
							<form:input path="tableName" htmlEscape="false" maxlength="50" class="form-control required"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 图表类型：</label>
						<div class="col-sm-8">
							<form:select path="reportType" class="form-control required">
								<form:options items="${fns:getDictList('report_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> X轴字段：</label>
						<div class="col-sm-8">
							<form:input path="xAxis" htmlEscape="false" maxlength="255" class="form-control required"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> Y轴字段：</label>
						<div class="col-sm-8">
							<form:input path="yAxis" htmlEscape="false" maxlength="255" class="form-control required"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-2 control-label"><font color="red">*</font> SQL：</label>
						<div class="col-sm-10">
							<form:textarea path="querySql" htmlEscape="false" rows="4" maxlength="1000" class="form-control"/>
							<input id="btnCodeRar" class="btn btn-info hide" type="button" value="解析" onclick="getSqlFields()"/>
							<br>
							<span class="help-inline"><font color="red">*</font></span>
							<span class="help-inline">
							 SQL语句查询参数必须为小写，
							    查询语句主表后面必须跟随字符'a'，如：select * from test_data a</span>
						</div>
					</div>
				</div>
			</div>
			
		
		<!-- 明细 -->
		<div class="tabs-container">
	    	<ul class="nav nav-tabs">
				<li class="active"><a data-toggle="tab" href="#tab-1" aria-expanded="true">图表配置明细</a></li>
	    	</ul>
          	<div class="tab-content">
          	   	<div class="panel-body">
					<div id="tab-1" class="tab-pane table-responsive active">
					<table id="contentTable" class="table table-striped table-bordered table-hover table-condensed">
						<thead>
							<tr>
								<th class="hide"></th>
								<th>字段名</th>
								<th>字段描述</th>
								<th>字段类型</th>
								<th>是否显示</th>
								<th>是否查询</th>
								<%--<th>查询方式</th>
								<th>显示类型</th> --%>
								<th>字典类型</th>
								<th>排序（升序）</th>
								
								<shiro:hasPermission name="gen:genReport:edit"><th width="10">&nbsp;</th></shiro:hasPermission>
							</tr>
						</thead>
						<tbody id="genReportColumnList">
						</tbody>
						<shiro:hasPermission name="gen:genReport:edit"><tfoot>
							<tr><td colspan="12"><a href="javascript:" onclick="addRow('#genReportColumnList', genReportColumnRowIdx, genReportColumnTpl);genReportColumnRowIdx = genReportColumnRowIdx + 1;" class="btn">新增</a></td></tr>
						</tfoot></shiro:hasPermission>
					</table>
					<script type="text/template" id="genReportColumnTpl">//<!--
						<tr id="genReportColumnList{{idx}}">
							<td class="hide">
								<input id="genReportColumnList{{idx}}_id" name="genReportColumnList[{{idx}}].id" type="hidden" value="{{row.id}}"/>
								<input id="genReportColumnList{{idx}}_delFlag" name="genReportColumnList[{{idx}}].delFlag" type="hidden" value="0"/>
							</td>
							<td>
								<input id="genReportColumnList{{idx}}_javaField" name="genReportColumnList[{{idx}}].javaField" type="text" value="{{row.javaField}}" maxlength="200" class="form-control input-small required"/>
							</td>
							<td>
								<input id="genReportColumnList{{idx}}_name" name="genReportColumnList[{{idx}}].name" type="text" value="{{row.name}}" maxlength="50" class="form-control input-small required"/>
							</td>
							<td>
								<select id="genReportColumnList{{idx}}_javaType" name="genReportColumnList[{{idx}}].javaType" data-value="{{row.javaType}}" class="form-control input-small required">
									<c:forEach items="${fns:getDictList('java_type')}" var="dict">
										<option value="${dict.value}">${dict.label}</option>
									</c:forEach>
								</select>
							</td>
							<td>
								<select id="genReportColumnList{{idx}}_isList" name="genReportColumnList[{{idx}}].isList" data-value="{{row.isList}}" class="form-control input-small required">
									<c:forEach items="${fns:getDictList('yes_no')}" var="dict">
										<option value="${dict.value}">${dict.label}</option>
									</c:forEach>
								</select>
							</td>
							<td>
								<select id="genReportColumnList{{idx}}_isQuery" name="genReportColumnList[{{idx}}].isQuery" data-value="{{row.isQuery}}" class="form-control input-small required">
									<c:forEach items="${fns:getDictList('yes_no')}" var="dict">
										<option value="${dict.value}">${dict.label}</option>
									</c:forEach>
								</select>
							</td>
							<%--
							<td>
								<select id="genReportColumnList{{idx}}_queryType" name="genReportColumnList[{{idx}}].queryType" data-value="{{row.queryType}}" class="form-control input-small">
									<c:forEach items="${fns:getDictList('query_type')}" var="dict">
										<option value="${dict.value}">${dict.label}</option>
									</c:forEach>
								</select>
							</td>
							
							<td>
								<select id="genReportColumnList{{idx}}_showType" name="genReportColumnList[{{idx}}].showType" data-value="{{row.showType}}" class="form-control input-small">
									<c:forEach items="${fns:getDictList('show_type')}" var="dict">
										<option value="${dict.value}">${dict.label}</option>
									</c:forEach>
								</select>
							</td>
							--%>
							<td>
								<input id="genReportColumnList{{idx}}_dictType" name="genReportColumnList[{{idx}}].dictType" type="text" value="{{row.dictType}}" maxlength="200" class="form-control input-small "/>
							</td>
							<td>
								<input id="genReportColumnList{{idx}}_sort" name="genReportColumnList[{{idx}}].sort" type="text" value="{{row.sort}}" class="form-control input-small digits required"/>
							</td>
							
							<shiro:hasPermission name="gen:genReport:edit"><td class="text-center" width="10">
								{{#delBtn}}<span class="close" onclick="delRow(this, '#genReportColumnList{{idx}}')" title="删除">&times;</span>{{/delBtn}}
							</td></shiro:hasPermission>
						</tr>//-->
					</script>
					<script type="text/javascript">
						var genReportColumnRowIdx = 0, genReportColumnTpl = $("#genReportColumnTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g,"");
						$(document).ready(function() {
							var data = ${fns:toJson(genReport.genReportColumnList)};
							for (var i=0; i<data.length; i++){
								addRow('#genReportColumnList', genReportColumnRowIdx, genReportColumnTpl, data[i]);
								genReportColumnRowIdx = genReportColumnRowIdx + 1;
							}
						});
					</script>
					</div>
				</div>
			</div>
		</div>
	</form:form>
</div>
</body>
</html>