<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>面试邀请编辑</title>
	<meta name="decorator" content="default"/>
	<link rel="stylesheet" href="${ctxStatic}/common/timeline.css" />
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
			$("#timeline2").hide();
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
		function smallChange(obj){
			if(obj.checked){
				$("#timeline2").show();
				$("#outside2as").html("3");
				$("#btnRead").text("预览");
				$("#searchForm").attr("action", "${ctx}/hr/hrInterview/preview");
			}else{
				$("#timeline2").hide();
				$("#outside2as").html("2");
				$("#btnRead").text("确定");
				$("#searchForm").attr("action", "${ctx}/hr/hrInterview/save");
			}
		}
	</script>
</head>
<body class="gray-bg">
<form:form id="inputForm" modelAttribute="hrInterview" action="${ctx}/hr/hrInterview/preview" method="post">
		<form:hidden path="id"/>
		<form:hidden path="hrResume.id"/>
		
<div class="pb60">
<div class="wrapper-content">
<div class="ibox">
	<div class="ibox-title">
		<h5>发送面试通知</h5>
	</div>
	<div class="ibox-content">
		<sys:message content="${message}"/>
		
		<div class="row">
		<div class="col-sm-12">
			<div class="box-timeline">
				<ul class="text-center" style="width: 800px;" >
					<li>
						填写信息
						<div class="box-num1">
							1
						</div>
					</li>
					<li class="ml45" id="timeline2">
						预览邮件
						<div class="box-outside1 outside1ab">
							<div class="box-num2 num2ab" id="outside1abs">
							  2
						    </div>
						</div>
					</li>
					<li class="ml45">
						完成
						<div class="box-outside2 outside2a">
							<div class="box-num3 num3a" id="outside2as">
							 2
						   </div>
						</div>
					</li>
				</ul>
			</div>
		</div>
		</div>
		<br>
		<div class="form-horizontal">
			
             <div class="row">
	            <div class="col-sm-6">
					<div class="col-sm-4 text-center">
						<button class="btn btn-success btn-circle btn-lg pull-right" style="width: 100px;height: 100px;border-radius: 50px;font-size: 50px;" type="button">
							${fn:substring(hrInterview.hrResume.name, 0, 1)}
	                          </button>
	                  	</div>
					<div class="col-sm-8">
						<div class="form-horizontal">
							<div class="row">
								<div class="col-sm-12">
									<div class="view-group">
										<p class="form-control-static">姓名：${hrInterview.hrResume.name}</p>
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-sm-12">
									<div class="view-group">
										<p class="form-control-static">手机：${hrInterview.hrResume.mobile}</p>
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-sm-12">
									<div class="view-group">
										<p class="form-control-static">邮箱：${hrInterview.hrResume.mail}</p>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
            </div>
                
			
			
			<h4 class="page-header"></h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 面试职位：</label>
						<div class="col-sm-8">
							<form:input path="position" htmlEscape="false" maxlength="50" class="form-control required"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 面试日期：</label>
						<div class="col-sm-8">
							<div class="input-group date datepicker">
				                 <input id="interviewDate" name="interviewDate" type="text" readonly="readonly" class="form-control required" 
				                 value="<fmt:formatDate value="${hrInterview.interviewDate}" pattern="yyyy-MM-dd HH:mm"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm',isShowClear:true});" >
				                 <span class="input-group-addon">
				                      <span class="fa fa-calendar"></span>
				                 </span>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 面试官：</label>
						<div class="col-sm-8">
							<sys:treeselect id="interviewBy" name="interviewBy.id" value="${hrInterview.interviewBy.id}" labelName="interviewBy.name" labelValue="${hrInterview.interviewBy.name}"
								title="用户" url="/sys/office/treeData?type=3" cssClass="form-control required" allowClear="true" notAllowSelectParent="true"/>
						</div>
					</div>
				</div>
			</div>
			<div class="hr-line-dashed"></div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 联系人：</label>
						<div class="col-sm-8">
							<form:input path="linkMan" htmlEscape="false" maxlength="50" class="form-control required"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 联系电话：</label>
						<div class="col-sm-8">
							<form:input path="linkPhone" htmlEscape="false" maxlength="20" class="form-control required"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 面试地点：</label>
						<div class="col-sm-8">
							<form:input path="address" htmlEscape="false" maxlength="50" class="form-control required"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 公司名称：</label>
						<div class="col-sm-8">
							<form:input path="company" htmlEscape="false" maxlength="50" class="form-control required"/>
						</div>
					</div>
				</div>
			</div>
			
			
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 备注信息：</label>
						<div class="col-sm-8">
							<form:textarea path="remarks" htmlEscape="false" rows="2" maxlength="50" class="form-control "/>
						</div>
					</div>
				</div>
				
			</div>
			<div class="hr-line-dashed"></div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"></label>
						<div class="col-sm-8">
							<%--<input type="checkbox" id="isSmsMsg" name="isSmsMsg" value="1" class="i-checks" checked="checked"> 向候选人发送短信通知 		 --%>			
							<input type="checkbox" id="isEmailMsg" value="1" onclick="smallChange(this)" class=""/> 向候选人发送邮件通知
						</div>
					</div>
				</div>
			</div>
	</div>
</div>
</div>
</div>
<div class="row dashboard-footer white-bg">
	         <div class="col-sm-12">
	        	<div class="text-center">
	        		<button id="btnRead" class="btn btn-success" type="submit">确定</button>
					<button id="btnCancel" class="btn btn-white" type="button" onclick="history.go(-1)">返回</button>
	        	</div>
	        </div>
</div>

</form:form>	
</body>
</html>