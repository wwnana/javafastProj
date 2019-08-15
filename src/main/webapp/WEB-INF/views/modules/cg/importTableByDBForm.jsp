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
	
	<c:if test="${empty genTable.name}">
	<div class="ibox-title">
		<h5>从数据库导入表</h5>
	</div>
	<div class="ibox-content">
		<sys:message content="${message}"/>
		<form:form id="inputForm" modelAttribute="cgTable" action="${ctx}/cg/cgTable/form" method="post" class="form-horizontal">
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
			           	<label class="col-sm-3 control-label"><font color="red">*</font>表名</label>
			           	 <div class="col-sm-8">
			             	<form:select path="name" class="form-control input-xxlarge">
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
	</c:if>
	
	<c:if test="${not empty genTable.name}">
	<div class="ibox-title">
		<h5>表单设计</h5>
	</div>
	<div class="ibox-content">
	<sys:message content="${message}"/>
	<form:form id="inputForm" modelAttribute="cgTable" action="${ctx}/cg/cgTable/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<div class="row">
            <div class="col-sm-12">
                <div class="tabs-container">
                    <ul class="nav nav-tabs">
                        <li class="active"><a data-toggle="tab" href="#tab-1" aria-expanded="true"> 业务表信息</a>
                        </li>
                        <li class=""><a data-toggle="tab" href="#tab-2" aria-expanded="false">字段信息</a>
                        </li>
                        <li class=""><a data-toggle="tab" href="#tab-3" aria-expanded="false">生成代码</a>
                        </li>
                    </ul>
                    <div class="tab-content">
                        <div id="tab-1" class="tab-pane active">
                            <div class="panel-body">
                            	<h4 class="page-header">基本信息</h4>
                                <div class="row">
									<div class="col-sm-6">
										<div class="form-group">
							            	<label class="col-sm-3 control-label"><font color="red">*</font>表名称</label>
							            	 <div class="col-sm-8">
							                       <form:input path="name" htmlEscape="false" maxlength="50" class="form-control required"/>
							                 </div>
							            </div>
						            </div>
						            <div class="col-sm-6">
										<div class="form-group">
							            	<label class="col-sm-3 control-label"><font color="red">*</font>表描述</label>
							            	 <div class="col-sm-8">
							                      <form:input path="comments" htmlEscape="false" maxlength="50" class="form-control required"/>
							                 </div>
							            </div>
						            </div>
						        </div>
						        <div class="row">
									<div class="col-sm-6">
										<div class="form-group">
							            	<label class="col-sm-3 control-label"><font color="red">*</font>实体类名称</label>
							            	 <div class="col-sm-8">
							                       <form:input path="className" htmlEscape="false" maxlength="50" class="form-control required"/>
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
						        <div class="row">
									<div class="col-sm-6">
										<div class="form-group">
							            	<label class="col-sm-3 control-label">关联父表</label>
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
							            	<label class="col-sm-3 control-label">关联父表外键</label>
							            	 <div class="col-sm-8">
							            	 	<form:select path="parentTableFk" cssClass="form-control">
													<form:option value="">无</form:option>
													<form:options items="${genTable.columnList}" itemLabel="nameAndComments" itemValue="name" htmlEscape="false"/>
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
						        
                            </div>
                        </div>
                        <div id="tab-2" class="tab-pane">
                            <div class="panel-body">
                            	
                            </div>
                        </div>
                        <div id="tab-3" class="tab-pane">
                            <div class="panel-body">
                            	
                            </div>
                        </div>
                    </div>


                </div>
            </div>
        </div>
		</form:form>
	</div>
	</c:if>
</div>
</div>
</body>
</html>