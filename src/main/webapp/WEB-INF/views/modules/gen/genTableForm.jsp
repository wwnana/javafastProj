<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>业务表管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
			//$("#comments").focus();
			
			$("#inputForm").validate({
				submitHandler: function(form){
					loading('正在提交，请稍等...');
					$("input[type=checkbox]").each(function(){
						$(this).after("<input type=\"hidden\" name=\""+$(this).attr("name")+"\" value=\""
								+($(this).attr("checked")?"1":"0")+"\"/>");
						$(this).attr("name", "_"+$(this).attr("name"));
					});
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
			
			$("#btnSave").click(function(){
				$("#inputForm").submit();
			});
			$("#btnGenCode").click(function(){
				$('#flag').val('1');
				$("#inputForm").attr("action", "${ctx}/gen/genTable/genCode");
				$("#inputForm").submit();
			});
			
		});
		function getSelectVal(rowIndex){
			
			var b = $("#javaType_"+rowIndex).val();
			
			if('Custom' == $("#javaType_"+rowIndex).val()){
				
				var width = '500px';
				var height = '500px';
				
				top.layer.open({
				    type: 2,  
				    area: [width, height],
				    title:"自定义类型",
				    name:'friend',
				    content: "${ctx}/gen/genTable/javaTypeForm" ,
				    btn: ['确定', '关闭'],
				    yes: function(index, layero){
				    	 var iframeWin = layero.find('iframe')[0].contentWindow; //得到iframe页的窗口对象，执行iframe页的方法：iframeWin.method();
				    	 var item = iframeWin.getInputItem();

				    	 if(item == "-1"){
					    	 return;
				    	 }
				    	 var javaType = item.split('_item_')[0];
				    	 var javaName = item.split('_item_')[1];
				    	 var showName = item.split('_item_')[2];
				    	 
				    	 $("#javaType_"+rowIndex).append("<option value='"+javaType+"'>"+javaType+"</option>");
				    	 $("#javaType_"+rowIndex).val(javaType);
				    	 $("#javaField_"+rowIndex).val(javaName+".id|"+showName);
				    	 $("#settings_"+rowIndex).val("1");
						 top.layer.close(index);//关闭对话框。
					  },
					  cancel: function(index){ 
				      }
				}); 
			}else{
				$("#settings_"+rowIndex).val("");
			}
		}
		//左树右表
		function showTreeData(){
			var category = $('#category option:selected').val();
			if(category == "treeTableAndList"){
				$("#select_div").show();
			}else{
				$("#select_div").hide();
			}
		}
	</script>
</head>
<body class="gray-bg">
<div class="wrapper-content pb80">
	<c:if test="${empty genTable.name}">
	<div class="ibox">
		<div class="ibox-title">
			<h5>从数据库导入表</h5>
		</div>
		<div class="ibox-content">
			<sys:message content="${message}" hideType="1"/>
			<form:form id="inputForm" modelAttribute="genTable" action="${ctx}/gen/genTable/form" method="post" class="form-horizontal">
			<form:hidden path="id"/>
				<h4 class="page-header">选择一个表进行导入</h4>
				<div class="row">
					<div class="col-sm-6">
						<div class="form-group">
			            	<label class="col-sm-3 control-label"><font color="red">*</font>表名</label>
			            	 <div class="col-sm-8">
			                 	<form:select path="name" class="form-control">
									<form:options items="${tableList}" itemLabel="nameAndComments" itemValue="name" htmlEscape="false"/>
								</form:select>
			                 </div>
			            </div>
		            </div>
		        </div>
		        <div class="hr-line-dashed"></div>
				<div class="form-actions">
					<input id="btnSubmit" class="btn btn-success" type="submit" value="下一步"/>&nbsp;
					<input id="btnCancel" class="btn btn-white" type="button" value="返 回" onclick="history.go(-1)"/>
				</div>
			</form:form>
		</div>
	</div>
	</c:if>
	
	<c:if test="${not empty genTable.name}">
	<c:if test="${fns:getConfig('demoMode') == true}">
		<div class="alert alert-success alert-dismissable">
            <button aria-hidden="true" data-dismiss="alert" class="close" type="button">×</button>
          	当前为演示环境，仅支持“生成并下载代码”
      	</div>
    </c:if>
	<div class="">
		
		<div class="">
			<form:form id="inputForm" modelAttribute="genTable" action="${ctx}/gen/genTable/save" method="post" class="form-horizontal" cssStyle="margin:0;">
			<form:hidden path="id"/>
			<form:hidden path="flag"/>
			<sys:message content="${message}"/>
				<div class="tabs-container">
                    <ul class="nav nav-tabs">
                        <li id="nav-1" class="active"><a data-toggle="tab" href="#tab-1" aria-expanded="true"><span class="">1.</span> 表单信息</a></li>
                        <li id="nav-2" class=""><a data-toggle="tab" href="#tab-2" aria-expanded="false"><span class="">2.</span> 字段设计</a></li>
                        <li id="nav-3" class=""><a data-toggle="tab" href="#tab-3" aria-expanded="false"><span class="">3.</span> 生成代码</a></li>
                    </ul>
                    <div class="tab-content">
                        <div id="tab-1" class="tab-pane active">
                       		<div class="panel-body">
	                        	<br>
	                        	<h4 class="page-header">基本信息</h4>
								<div class="row">
									<div class="col-sm-6">
										<div class="form-group">
							            	<label class="col-sm-3 control-label"><font color="red">*</font>表名</label>
							            	 <div class="col-sm-8">
							                 	<form:input path="name" htmlEscape="false" maxlength="50" class="form-control required" readonly="true"/>
							                 </div>
							            </div>
						            </div>
						            <div class="col-sm-6">
										<div class="form-group">
							            	<label class="col-sm-3 control-label"><font color="red">*</font>说明</label>
							            	 <div class="col-sm-8">
							                 	<form:input path="comments" htmlEscape="false" maxlength="50" class="form-control required"/>
							                 </div>
							            </div>
						            </div>
						        </div>
						        <div class="row">
									<div class="col-sm-6">
										<div class="form-group">
							            	<label class="col-sm-3 control-label"><font color="red">*</font>类名</label>
							            	 <div class="col-sm-8">
							                 	<form:input path="className" htmlEscape="false" maxlength="50" class="form-control required"/>
							                 </div>
							            </div>
						            </div>
						        </div>
						        <h4 class="page-header">父表信息</h4>
						        <div class="row">		         
						            <div class="col-sm-6">
										<div class="form-group">
							            	<label class="col-sm-3 control-label">父表表名</label>
							            	 <div class="col-sm-8">
							                 	<form:select path="parentTable" cssClass="form-control">
													<form:option value="">无</form:option>
													<form:options items="${tableList}" itemLabel="nameAndComments" itemValue="name" htmlEscape="false"/>
												</form:select>
												<span class="help-inline">如果有父表，请指定父表表名和外键</span>
							                 </div>
							            </div>
						            </div>
						            <div class="col-sm-6">
										<div class="form-group">
							            	<label class="col-sm-3 control-label">关联当前表外键</label>
							            	 <div class="col-sm-8">
												<form:select path="parentTableFk" cssClass="form-control">
													<form:option value="">无</form:option>
													<form:options items="${genTable.columnList}" itemLabel="nameAndComments" itemValue="name" htmlEscape="false"/>
												</form:select>
							                 </div>
							            </div>
						            </div>
						        </div>
					        </div>
                        </div>
                        <div id="tab-2" class="tab-pane">
                       		<div class="panel-body">
	                        	<table id="contentTable" class="table table-striped table-bordered  table-hover table-condensed  dataTables-example dataTable no-footer">
									<thead>
										<tr>
											<th style="text-align: center;" colspan="9">字段</th>
											<th style="text-align: center;" colspan="3">列表</th>
											<th style="text-align: center;" colspan="7">表单</th>
										</tr>
										<tr>
											<th title="数据库字段名">列名</th>
											<th title="默认读取数据库字段备注">说明</th>
											<th title="数据库中设置的字段类型及长度">物理类型</th>
											<th title="实体对象的属性字段类型">Java类型</th>
											<th title="实体对象的属性字段（对象名.属性名|属性名2|属性名3，例如：用户user.id|name|loginName，属性名2和属性名3为Join时关联查询的字段）">Java属性名称 <i class="icon-question-sign"></i></th>
											<th title="是否是数据库主键">主键</th>
											<th title="字段是否可为空值，不可为空字段自动进行空值验证">可空</th>
											<th title="选中后该字段被加入到insert语句里">插入</th>
											<th title="选中后该字段被加入到update语句里">编辑</th>
											<th title="选中后该字段被加入到查询列表里">列表</th>
											<th title="选中后该字段被加入到查询条件里">查询</th>
											<th title="该字段为查询字段时的查询匹配放松">匹配方式</th>
											<th title="字段在表单中显示的类型">表单类型</th>
											<th title="显示表单类型设置为“下拉框、复选框、点选框”时，需设置字典的类型">字典类型</th>
											<th>排序</th>
										</tr>
									</thead>
									<tbody>
									<c:forEach items="${genTable.columnList}" var="column" varStatus="vs">
										<tr${column.delFlag eq '1'?' class="error" title="已删除的列，保存之后消失！"':''}>
											<td nowrap>
												<input type="hidden" name="columnList[${vs.index}].id" value="${column.id}"/>
												<input type="hidden" name="columnList[${vs.index}].delFlag" value="${column.delFlag}"/>
												<input type="hidden" name="columnList[${vs.index}].genTable.id" value="${column.genTable.id}"/>
												<input type="hidden" name="columnList[${vs.index}].name" value="${column.name}"/>
												<input type="hidden" name="columnList[${vs.index}].settings" value="${column.settings}" id="settings_${vs.index}"/>
												${column.name}
											</td>
											<td>
												<input type="text" name="columnList[${vs.index}].comments" value="${column.comments}" maxlength="200" class="required" style="width:100px;"/>
											</td>
											<td nowrap>
												<input type="hidden" name="columnList[${vs.index}].jdbcType" value="${column.jdbcType}"/>${column.jdbcType}
											</td>
											<td>
												<select name="columnList[${vs.index}].javaType" class="required input-small" id="javaType_${vs.index}" onchange="getSelectVal(${vs.index})">
													<c:forEach items="${config.javaTypeList}" var="dict">
														<option value="${dict.value}" ${dict.value==column.javaType?'selected':''} title="${dict.description}">${dict.label}</option>
													</c:forEach>
													
													<c:if test="${column.settings == 1}">
													<option value="${column.javaType}" selected title="自定义类型${column.javaType}">${column.javaType}</option>
													</c:if>
												</select>
											</td>
											<td>
												<input type="text" name="columnList[${vs.index}].javaField" value="${column.javaField}" maxlength="200" class="required input-small" id="javaField_${vs.index}"/>
											</td>
											<td>
												<input type="checkbox" name="columnList[${vs.index}].isPk" value="1" ${column.isPk eq '1' ? 'checked' : ''} class="i-checks"/>
											</td>
											<td>
												<input type="checkbox" name="columnList[${vs.index}].isNull" value="1" ${column.isNull eq '1' ? 'checked' : ''} class="i-checks"/>
											</td>
											<td>
												<input type="checkbox" name="columnList[${vs.index}].isInsert" value="1" ${column.isInsert eq '1' ? 'checked' : ''} class="i-checks"/>
											</td>
											<td>
												<input type="checkbox" name="columnList[${vs.index}].isEdit" value="1" ${column.isEdit eq '1' ? 'checked' : ''} class="i-checks"/>
											</td>
											<td>
												<input type="checkbox" name="columnList[${vs.index}].isList" value="1" ${column.isList eq '1' ? 'checked' : ''} class="i-checks"/>
											</td>
											<td>
												<input type="checkbox" name="columnList[${vs.index}].isQuery" value="1" ${column.isQuery eq '1' ? 'checked' : ''} class="i-checks"/>
											</td>
											<td>
												<select name="columnList[${vs.index}].queryType" class="required input-mini">
													<c:forEach items="${config.queryTypeList}" var="dict">
														<option value="${fns:escapeHtml(dict.value)}" ${fns:escapeHtml(dict.value)==column.queryType?'selected':''} title="${dict.description}">${fns:escapeHtml(dict.label)}</option>
													</c:forEach>
												</select>
											</td>
											<td>
												<select name="columnList[${vs.index}].showType" class="required" style="width:100px;">
													<c:forEach items="${config.showTypeList}" var="dict">
														<option value="${dict.value}" ${dict.value==column.showType?'selected':''} title="${dict.description}">${dict.label}</option>
													</c:forEach>
												</select>
											</td>
											<td>
												<input type="text" name="columnList[${vs.index}].dictType" value="${column.dictType}" maxlength="200" class="input-mini"/>
											</td>
											<td>
												<input type="text" name="columnList[${vs.index}].sort" value="${column.sort}" maxlength="200" class="required input-xmin digits"/>
											</td>
										</tr>
									</c:forEach>
									</tbody>
								</table>
							</div>
                        </div>
                        <div id="tab-3" class="tab-pane">
                       		<div class="panel-body">
                       			
                       			<br>
                       			<h4 class="page-header">生成信息</h4>
                       			<div class="row">		        
						            <div class="col-sm-6">
										<div class="form-group">
							            	<label class="col-sm-3 control-label"><font color="red">*</font>生成模板</label>
							            	 <div class="col-sm-8">
							                      <form:select path="category" class="required form-control" onchange="showTreeData()" cssStyle="width:100%;">
													<form:options items="${config.categoryList}" itemLabel="label" itemValue="value" htmlEscape="false"/>
												</form:select>
												<span class="help-inline">
													生成结构：{包名}/{模块名}/{分层(dao,entity,service,web)}/{子模块名}/{java类}
												</span>
												
												<div id="select_div" class="mt10" <c:if test='${genTable.category != "treeTableAndList"}'>style="display: none;"</c:if> >
													
													<form:input path="treeData" htmlEscape="false" maxlength="100" class="form-control required" placeholder="树形列表访问对象"/>
													<span class="help-inline">"左树右表"的情况下，必须指明树形列表访问对象，如：sys/office</span>
												</div>
							                 </div>
							            </div>
						            </div>
						            <div class="col-sm-6">
										<div class="form-group">
							            	<label class="col-sm-3 control-label"><font color="red">*</font>包路径</label>
							            	 <div class="col-sm-8">
							                 	<form:input path="packageName" htmlEscape="false" maxlength="500" class="required form-control"/>
												<span class="help-inline">建议包路径：com.javafast.modules</span>
							                 </div>
							            </div>
						            </div>
						        </div>
						        <div class="row">
						            <div class="col-sm-6">
										<div class="form-group">
							            	<label class="col-sm-3 control-label"><font color="red">*</font>模块名</label>
							            	 <div class="col-sm-8">
							                    <form:input path="moduleName" htmlEscape="false" maxlength="500" class="required form-control"/>
												<span class="help-inline">模块包名，例如 sys</span>
							                 </div>
							            </div>
						            </div>
						            <div class="col-sm-6">
										<div class="form-group">
							            	<label class="col-sm-3 control-label">子模块名</label>
							            	 <div class="col-sm-8">
							                    <form:input path="subModuleName" htmlEscape="false" maxlength="500" class="form-control"/>
												<span class="help-inline">可选，分层下的文件夹 </span>
							                 </div>
							            </div>
						            </div>
						        </div>
						        <div class="row">
						            <div class="col-sm-6">
										<div class="form-group">
							            	<label class="col-sm-3 control-label"><font color="red">*</font>功能描述</label>
							            	 <div class="col-sm-8">
							                 	<form:input path="functionName" htmlEscape="false" maxlength="500" class="required form-control"/>
												<span class="help-inline">将设置到类描述</span>
							                 </div>
							            </div>
						            </div>
						            <div class="col-sm-6">
										<div class="form-group">
							            	<label class="col-sm-3 control-label"><font color="red">*</font>功能名称</label>
							            	 <div class="col-sm-8">
							                     <form:input path="functionNameSimple" htmlEscape="false" maxlength="500" class="required form-control"/>
												<span class="help-inline">用作功能提示，如：保存“某某”成功</span>
							                 </div>
							            </div>
						            </div>
						        </div>
						        <div class="row">
						            <div class="col-sm-6">
										<div class="form-group">
							            	<label class="col-sm-3 control-label"><font color="red">*</font>功能作者</label>
							            	 <div class="col-sm-8">
							                 	<form:input path="functionAuthor" htmlEscape="false" maxlength="500" class="required form-control"/>
												<span class="help-inline">功能开发作者</span>
							                 </div>
							            </div>
						            </div>
						            <div class="col-sm-6">
										<div class="form-group">
							            	<label class="col-sm-3 control-label"><font color="red">*</font>表单模型</label>
							            	 <div class="col-sm-8">
							                     <form:select path="pageModel" class="form-control required" cssStyle="width:100%;">
													<form:options items="${fns:getDictList('page_model')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
												</form:select>
												<span class="help-inline">编辑、查看页面的打开方式</span>
							                 </div>
							            </div>
						            </div>
						        </div>
						        <h4 class="page-header">其他选项</h4>
						        <div class="row">
						            <div class="col-sm-6">
										<div class="form-group">
							            	<label class="col-sm-3 control-label"></label>
							            	 <div class="col-sm-8">
							                 	<form:checkbox path="replaceFile" label="是否替换现有文件" class="i-checks"/>
							                 </div>
							            </div>
						            </div>
						            <div class="col-sm-6">
										<div class="form-group">
							            	<label class="col-sm-3 control-label"></label>
							            	 <div class="col-sm-8">
							                     
							                 </div>
							            </div>
						            </div>
						        </div>
						        
						        
                       		</div>
                       	</div>
                       	
                    </div>
                </div>
                        
                       
				
		       
			</form:form>
		</div>
	</div>
	</c:if>
</div>
	
	<c:if test="${not empty genTable.name}">
	<div class="row dashboard-footer white-bg">
         <div class="col-sm-12">
        	<div class="text-center">
        	
        			<input id="btnSave" class="btn btn-success btn-sm" type="submit" value="保  存"/>
        			<input id="btnGenCode" class="btn btn-danger btn-sm" type="button" value="生成代码到工程" <c:if test="${fns:getConfig('demoMode') == true}">disabled="disabled"</c:if> />
        			<c:if test="${not empty genTable.id}">
					<input id="btnCodeRar" class="btn btn-info btn-sm" type="button" value="生成代码并下载" onclick="window.location.href='${ctx}/gen/genTable/createCodeRar?id=${genTable.id}'"/>
					</c:if>
					
					<a href="#" onclick="openDialog('生成菜单', '${ctx}/gen/genTable/menuForm?genTableId=${genTable.id}','800px', '500px')" class="btn btn-white btn-sm" >生成菜单</a>
					<input id="btnCancel" class="btn btn-white btn-sm" type="button" value="返  回" onclick="history.go(-1)"/>
        	</div>
        </div>
    </div>
    </c:if>
    
</body>
</html>
