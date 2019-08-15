<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>通知管理</title>
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
			validateForm = $("#inputForm").validate({
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
		function sendNotify(){
			$("#status").val("1");
			doSubmit();
		}
		function saveNotify(){
			$("#status").val("0");
			doSubmit();
		}
	</script>
</head>
<body class="gray-bg">
    <div class="wrapper-content">
        <div class="row">
            <div class="col-sm-12 animated fadeInRight">
                <div class="mail-box-header">
                    <div class="pull-right tooltip-demo">
                    	<shiro:hasPermission name="oa:oaNotify:edit">
                    	<button type="button" class="btn btn-success  btn-sm" onclick="sendNotify()"> <i class="fa fa-reply"></i> 发送</button>
                        <button type="button" class="btn btn-white  btn-sm" onclick="saveNotify()"> <i class="fa fa-pencil"></i> 存为草稿</button>
                        </shiro:hasPermission>
                        <button type="button" class="btn btn-white  btn-sm" onclick="history.go(-1)"> 返 回</button>
                    </div>
                    <h2>
                   		 发通知
                	</h2>
                </div>
                
                <div class="mail-box">
                    <div class="mail-body">
                    	<form:form id="inputForm" modelAttribute="oaNotify" action="${ctx}/oa/oaNotify/save" method="post" class="form-horizontal">
						<form:hidden path="id"/>
						<form:hidden path="status"/>
						<sys:message content="${message}"/>	
							
							<div class="form-group">
                                <label class="col-sm-2 control-label"><font color="red">*</font> 类型：</label>
                                <div class="col-sm-8">
                                	<form:select path="type" class="form-control required">
										<form:options items="${fns:getDictList('oa_notify_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label"><font color="red">*</font>标题：</label>
                                <div class="col-sm-8">
                                	<form:input path="title" htmlEscape="false" maxlength="200" class="form-control required"/>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label"><font color="red">*</font>内容：</label>
                                <div class="col-sm-8">
                                	<form:textarea id="content" htmlEscape="true" path="content" rows="4" maxlength="10000" style="width:100%;height:200px;"/>
									<sys:umeditor replace="content" uploadPath="/image" height="100px" maxlength="10000"/>
						
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label">附件：</label>
                                <div class="col-sm-8">
                                	<form:hidden id="files" path="files" htmlEscape="false" maxlength="255" class="form-control"/>
									<sys:ckfinder input="files" type="files" uploadPath="/file" selectMultiple="true"/>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label"><font color="red">*</font>接收人：</label>
                                <div class="col-sm-8">
                                	<sys:treeselect id="oaNotifyRecord" name="oaNotifyRecordIds" value="${oaNotify.oaNotifyRecordIds}" labelName="oaNotifyRecordNames" labelValue="${oaNotify.oaNotifyRecordNames}"
										title="用户" url="/sys/office/treeData?type=3" cssClass="form-control required" notAllowSelectParent="true" checked="true"/>
                                </div>
                            </div>
                         </form:form>
                    </div>
                    <div class="mail-body text-right tooltip-demo">
                    	<shiro:hasPermission name="oa:oaNotify:edit">
                    	<button type="button" class="btn btn-success  btn-sm" onclick="sendNotify()"> <i class="fa fa-reply"></i> 发送</button>
                        <button type="button" class="btn btn-white  btn-sm" onclick="saveNotify()"> <i class="fa fa-pencil"></i> 存为草稿</button>
                        </shiro:hasPermission>
                        <button type="button" class="btn btn-white  btn-sm" onclick="history.go(-1)"> 返 回</button>
                    </div>
                </div>
                
            </div>
          </div>
      </div>
</body>
</html>
            