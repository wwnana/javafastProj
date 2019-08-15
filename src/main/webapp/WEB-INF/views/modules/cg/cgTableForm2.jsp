<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>表单设计编辑</title>
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
		<h5>表单设计${not empty cgTable.id?'修改':'添加'}</h5>
	</div>
	<div class="ibox-content">
	<sys:message content="${message}"/>
	<div class="row">
		<div class="col-sm-12">
			<div class="text-center p-lg">
            	<h2>表单设计</h2>
            </div>
		</div>
	</div>
	<form:form id="inputForm" modelAttribute="cgTable" action="${ctx}/cg/cgTable/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
	 <table class="table table-bordered table-condensed dataTables-example dataTable no-footer">
		<tbody>
			<tr>
					<td class="width-15 active"><label class="pull-right">表名称：</label></td>
					<td class="width-35">
						<form:input path="name" htmlEscape="false" maxlength="50" class="form-control input-xlarge required"/>
						<span class="help-inline"><font color="red">*</font> </span>
					</td>
					<td class="width-15 active"><label class="pull-right">表描述：</label></td>
					<td class="width-35">
						<form:input path="comments" htmlEscape="false" maxlength="50" class="form-control input-xlarge required"/>
						<span class="help-inline"><font color="red">*</font> </span>
					</td>
				</tr>
				<tr> 
					<td class="width-15 active"><label class="pull-right">实体类名称：</label></td>
					<td class="width-35">
						<form:input path="className" htmlEscape="false" maxlength="50" class="form-control input-xlarge required"/>
						<span class="help-inline"><font color="red">*</font> </span>
					</td>
					<td class="width-15 active"><label class="pull-right">关联父表：</label></td>
					<td class="width-35">
						<form:input path="parentTable" htmlEscape="false" maxlength="50" class="form-control input-xlarge"/>
					</td>
				</tr>
				<tr> 
					<td class="width-15 active"><label class="pull-right">关联父表外键：</label></td>
					<td class="width-35">
						<form:input path="parentTableFk" htmlEscape="false" maxlength="50" class="form-control input-xlarge"/>
					</td>
					<td class="width-15 active"><label class="pull-right">生成模板分类：</label></td>
					<td class="width-35">
						<form:input path="cgCategory" htmlEscape="false" maxlength="50" class="form-control input-xlarge"/>
					</td>
				</tr>
				<tr> 
					<td class="width-15 active"><label class="pull-right">生成包路径：</label></td>
					<td class="width-35">
						<form:input path="packageName" htmlEscape="false" maxlength="50" class="form-control input-xlarge required"/>
						<span class="help-inline"><font color="red">*</font> </span>
					</td>
					<td class="width-15 active"><label class="pull-right">生成模块名：</label></td>
					<td class="width-35">
						<form:input path="moduleName" htmlEscape="false" maxlength="50" class="form-control input-xlarge required"/>
						<span class="help-inline"><font color="red">*</font> </span>
					</td>
				</tr>
				<tr> 
					<td class="width-15 active"><label class="pull-right">生成子模块名：</label></td>
					<td class="width-35">
						<form:input path="subModuleName" htmlEscape="false" maxlength="50" class="form-control input-xlarge"/>
					</td>
					<td class="width-15 active"><label class="pull-right">生成功能名：</label></td>
					<td class="width-35">
						<form:input path="functionName" htmlEscape="false" maxlength="50" class="form-control input-xlarge required"/>
						<span class="help-inline"><font color="red">*</font> </span>
					</td>
				</tr>
				<tr> 
					<td class="width-15 active"><label class="pull-right">生成功能名（简写）：</label></td>
					<td class="width-35">
						<form:input path="functionNameSimple" htmlEscape="false" maxlength="50" class="form-control input-xlarge"/>
					</td>
					<td class="width-15 active"><label class="pull-right">生成功能作者：</label></td>
					<td class="width-35">
						<form:input path="functionAuthor" htmlEscape="false" maxlength="50" class="form-control input-xlarge required"/>
						<span class="help-inline"><font color="red">*</font> </span>
					</td>
				</tr>
				<tr> 
					<td class="width-15 active"><label class="pull-right">编辑页面模型:0:弹窗，1:跳转：</label></td>
					<td class="width-35">
						<form:select path="pageModel" class="form-control input-xlarge required">
							<form:option value="" label=""/>
							<form:options items="${fns:getDictList('page_model')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
						</form:select>
						<span class="help-inline"><font color="red">*</font> </span>
					</td>
					<td class="width-15 active"><label class="pull-right">树形列表数据：</label></td>
					<td class="width-35">
						<form:input path="treeData" htmlEscape="false" maxlength="50" class="form-control input-xlarge"/>
					</td>
				</tr>
				<tr> 
					<td class="width-15 active"><label class="pull-right">是否支持列表多选：</label></td>
					<td class="width-35">
						<form:radiobuttons path="isListCheckbox" items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false" class="form-control "/>
					</td>
					<td class="width-15 active"><label class="pull-right">是否生成列表选择器：</label></td>
					<td class="width-35">
						<form:radiobuttons path="isTableSelect" items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false" class="form-control "/>
					</td>
				</tr>
				<tr> 
					<td class="width-15 active"><label class="pull-right">是否支持导入导出：</label></td>
					<td class="width-35">
						<form:radiobuttons path="isExcel" items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false" class="form-control "/>
					</td>
					<td class="width-15 active"><label class="pull-right">同步数据库：</label></td>
					<td class="width-35">
						<form:select path="isSynch" class="form-control input-xlarge">
							<form:option value="" label=""/>
							<form:options items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
						</form:select>
					</td>
				</tr>
				<tr> 
					<td class="width-15 active"><label class="pull-right">备注信息：</label></td>
					<td class="width-35">
						<form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="255" class="form-control input-xlarge"/>
					</td>
				</tr>
			</tbody>
		</table>
		<!-- 明细 -->
		<div class="tabs-container">
	    	<ul class="nav nav-tabs">
				<li class="active"><a data-toggle="tab" href="#tab-1" aria-expanded="true">表单字段</a></li>
	    	</ul>
          	<div class="tab-content">
          	   	<div class="panel-body">
					<div id="tab-1" class="tab-pane table-responsive active">
					<table id="contentTable" class="table table-striped table-bordered table-hover table-condensed">
						<thead>
							<tr>
								<th class="hide"></th>
								<th>列名</th>
								<th>说明</th>
								<th>字段类型</th>
								<th>JAVA类型</th>
								<th>JAVA字段名</th>
								<th>主键</th>
								<th>插入</th>
								<th>更新</th>
								<th>列表</th>
								<th>排序</th>
								<th>查询</th>
								<th>查询方式</th>
								<th>表单控件</th>
								<th>字典类型</th>
								<th>非空</th>
								<th>校验类型</th>
								<th>其它设置（扩展字段JSON）</th>
								<th>排序（升序）</th>
								<shiro:hasPermission name="cg:cgTable:edit"><th width="10">&nbsp;</th></shiro:hasPermission>
							</tr>
						</thead>
						<tbody id="columnList">
						</tbody>
						<shiro:hasPermission name="cg:cgTable:edit"><tfoot>
							<tr><td colspan="20"><a href="javascript:" onclick="addRow('#columnList', cgTableColumnRowIdx, cgTableColumnTpl);cgTableColumnRowIdx = cgTableColumnRowIdx + 1;" class="btn">新增</a></td></tr>
						</tfoot></shiro:hasPermission>
					</table>
					<script type="text/template" id="cgTableColumnTpl">//<!--
						<tr id="columnList{{idx}}">
							<td class="hide">
								<input id="columnList{{idx}}_id" name="columnList[{{idx}}].id" type="hidden" value="{{row.id}}"/>
								<input id="columnList{{idx}}_delFlag" name="columnList[{{idx}}].delFlag" type="hidden" value="0"/>
							</td>
							<td>
								<input id="columnList{{idx}}_name" name="columnList[{{idx}}].name" type="text" value="{{row.name}}" maxlength="50" class="form-control input-small required"/>
							</td>
							<td>
								<input id="columnList{{idx}}_comments" name="columnList[{{idx}}].comments" type="text" value="{{row.comments}}" maxlength="50" class="form-control input-small required"/>
							</td>
							<td>
								<select id="columnList{{idx}}_jdbcType" name="columnList[{{idx}}].jdbcType" data-value="{{row.jdbcType}}" class="form-control input-small required">
									<option value=""></option>
									<c:forEach items="${fns:getDictList('')}" var="dict">
										<option value="${dict.value}">${dict.label}</option>
									</c:forEach>
								</select>
							</td>
							<td>
								<select id="columnList{{idx}}_javaType" name="columnList[{{idx}}].javaType" data-value="{{row.javaType}}" class="form-control input-small required">
									<option value=""></option>
									<c:forEach items="${fns:getDictList('')}" var="dict">
										<option value="${dict.value}">${dict.label}</option>
									</c:forEach>
								</select>
							</td>
							<td>
								<input id="columnList{{idx}}_javaField" name="columnList[{{idx}}].javaField" type="text" value="{{row.javaField}}" maxlength="50" class="form-control input-small required"/>
							</td>
							<td>
								<c:forEach items="${fns:getDictList('')}" var="dict" varStatus="dictStatus">
									<span><input id="columnList{{idx}}_isPk${dictStatus.index}" name="columnList[{{idx}}].isPk" type="checkbox" value="${dict.value}" data-value="{{row.isPk}}"><label for="columnList{{idx}}_isPk${dictStatus.index}">${dict.label}</label></span>
								</c:forEach>
							</td>
							<td>
								<c:forEach items="${fns:getDictList('')}" var="dict" varStatus="dictStatus">
									<span><input id="columnList{{idx}}_isInsert${dictStatus.index}" name="columnList[{{idx}}].isInsert" type="checkbox" value="${dict.value}" data-value="{{row.isInsert}}"><label for="columnList{{idx}}_isInsert${dictStatus.index}">${dict.label}</label></span>
								</c:forEach>
							</td>
							<td>
								<c:forEach items="${fns:getDictList('')}" var="dict" varStatus="dictStatus">
									<span><input id="columnList{{idx}}_isEdit${dictStatus.index}" name="columnList[{{idx}}].isEdit" type="checkbox" value="${dict.value}" data-value="{{row.isEdit}}"><label for="columnList{{idx}}_isEdit${dictStatus.index}">${dict.label}</label></span>
								</c:forEach>
							</td>
							<td>
								<c:forEach items="${fns:getDictList('')}" var="dict" varStatus="dictStatus">
									<span><input id="columnList{{idx}}_isList${dictStatus.index}" name="columnList[{{idx}}].isList" type="checkbox" value="${dict.value}" data-value="{{row.isList}}"><label for="columnList{{idx}}_isList${dictStatus.index}">${dict.label}</label></span>
								</c:forEach>
							</td>
							<td>
								<c:forEach items="${fns:getDictList('')}" var="dict" varStatus="dictStatus">
									<span><input id="columnList{{idx}}_isSort${dictStatus.index}" name="columnList[{{idx}}].isSort" type="radio" value="${dict.value}" data-value="{{row.isSort}}"><label for="columnList{{idx}}_isSort${dictStatus.index}">${dict.label}</label></span>
								</c:forEach>
							</td>
							<td>
								<c:forEach items="${fns:getDictList('')}" var="dict" varStatus="dictStatus">
									<span><input id="columnList{{idx}}_isQuery${dictStatus.index}" name="columnList[{{idx}}].isQuery" type="checkbox" value="${dict.value}" data-value="{{row.isQuery}}"><label for="columnList{{idx}}_isQuery${dictStatus.index}">${dict.label}</label></span>
								</c:forEach>
							</td>
							<td>
								<select id="columnList{{idx}}_queryType" name="columnList[{{idx}}].queryType" data-value="{{row.queryType}}" class="form-control input-small required">
									<option value=""></option>
									<c:forEach items="${fns:getDictList('')}" var="dict">
										<option value="${dict.value}">${dict.label}</option>
									</c:forEach>
								</select>
							</td>
							<td>
								<select id="columnList{{idx}}_showType" name="columnList[{{idx}}].showType" data-value="{{row.showType}}" class="form-control input-small required">
									<option value=""></option>
									<c:forEach items="${fns:getDictList('')}" var="dict">
										<option value="${dict.value}">${dict.label}</option>
									</c:forEach>
								</select>
							</td>
							<td>
								<input id="columnList{{idx}}_dictType" name="columnList[{{idx}}].dictType" type="text" value="{{row.dictType}}" maxlength="50" class="form-control input-small "/>
							</td>
							<td>
								<c:forEach items="${fns:getDictList('')}" var="dict" varStatus="dictStatus">
									<span><input id="columnList{{idx}}_isNotNull${dictStatus.index}" name="columnList[{{idx}}].isNotNull" type="checkbox" value="${dict.value}" data-value="{{row.isNotNull}}"><label for="columnList{{idx}}_isNotNull${dictStatus.index}">${dict.label}</label></span>
								</c:forEach>
							</td>
							<td>
								<select id="columnList{{idx}}_validateType" name="columnList[{{idx}}].validateType" data-value="{{row.validateType}}" class="form-control input-small">
									<option value=""></option>
									<c:forEach items="${fns:getDictList('')}" var="dict">
										<option value="${dict.value}">${dict.label}</option>
									</c:forEach>
								</select>
							</td>
							<td>
								<input id="columnList{{idx}}_settings" name="columnList[{{idx}}].settings" type="text" value="{{row.settings}}" maxlength="2000" class="form-control input-small "/>
							</td>
							<td>
								<input id="columnList{{idx}}_sort" name="columnList[{{idx}}].sort" type="text" value="{{row.sort}}" class="form-control input-small "/>
							</td>
							<shiro:hasPermission name="cg:cgTable:edit"><td class="text-center" width="10">
								{{#delBtn}}<span class="close" onclick="delRow(this, '#columnList{{idx}}')" title="删除">&times;</span>{{/delBtn}}
							</td></shiro:hasPermission>
						</tr>//-->
					</script>
					<script type="text/javascript">
						var cgTableColumnRowIdx = 0, cgTableColumnTpl = $("#cgTableColumnTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g,"");
						$(document).ready(function() {
							var data = ${fns:toJson(cgTable.columnList)};
							for (var i=0; i<data.length; i++){
								addRow('#columnList', cgTableColumnRowIdx, cgTableColumnTpl, data[i]);
								cgTableColumnRowIdx = cgTableColumnRowIdx + 1;
							}
						});
					</script>
					</div>
				</div>
			</div>
		</div>
		
		<br>
			<div class="form-actions">
				<shiro:hasPermission name="cg:cgTable:edit"><input id="btnSubmit" class="btn btn-success" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
				<input id="btnCancel" class="btn btn-white" type="button" value="返 回" onclick="history.go(-1)"/>
			</div>
		<br>
	</form:form>
	</div>
</div>
</div>
</body>
</html>