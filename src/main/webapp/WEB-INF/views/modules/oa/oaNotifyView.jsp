<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>通知查看</title>
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
	</script>
</head>
<body class="gray-bg">
<div class="wrapper-content">
	<div class="float-e-margins">
		<sys:message content="${message}"/>	
		<form:form id="inputForm" modelAttribute="oaNotify" action="${ctx}/oa/oaNotify/save" method="post" class="">
		<form:hidden path="id"/>
		
			<div class="animated fadeInRight">
                <div class="mail-box-header">
                    <div class="pull-right tooltip-demo">
                    	
                    	<a href="#" onclick="history.go(-1)" class="btn btn-white btn-sm" data-toggle="tooltip" data-placement="top" title="返回"><i class="fa fa-backward"></i> 返回</a>
                    	
                    	<c:if test="${fns:getUser().id == oaNotify.createBy.id}">
						
	    					<a href="${ctx}/oa/oaNotify/form?id=${oaNotify.id}" class="btn btn-white btn-sm" ><i class="fa fa-edit"></i> 修改</a>
	    				
							<a href="${ctx}/oa/oaNotify/delete?id=${oaNotify.id}" onclick="return confirmx('确认要删除该通知吗？', this.href)"   class="btn btn-white btn-sm"><i class="fa fa-trash"></i> 删除</a>
						
						</c:if>
										
                    </div>
                    <h2>
                    	查看通知
               		</h2>
                    <div class="mail-tools tooltip-demo m-t-md">
					<h5>
                        <span class="font-noraml">主题： </span>${oaNotify.title }
                    </h5>
                    <h5>
                        <span class="font-noraml">发布者： </span>${oaNotify.createBy.name}
                    </h5>
                    <h5>
                        <span class="font-noraml">发布时间： </span><fmt:formatDate value="${oaNotify.updateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
                    </h5>
                    </div>
                </div>
                <div class="mail-box">
                	<div id="content" class="mail-body">
                       ${oaNotify.content }
                    </div>
                    <div class="mail-attachment">
                     	<span class="font-noraml">相关附件： </span>
                     		<form:hidden id="files" path="files" htmlEscape="false" maxlength="255" class="form-control"/>
								<sys:ckfinder input="files" type="files" uploadPath="/file" selectMultiple="true" readonly="true" />
                    </div>
                </div>
                <c:if test="${oaNotify.status eq '1'}">
				<div class="float-e-margins">
				<div class="ibox-title">
					<h5>查阅信息</h5>
				</div>
				<div class="ibox-content">
					<table id="contentTable" class="table">
									<thead>
										<tr>
											<th>接受人</th>
											<th>接受部门</th>
											<th>阅读状态</th>
											<th>阅读时间</th>
										</tr>
									</thead>
									<tbody>
									<c:forEach items="${oaNotify.oaNotifyRecordList}" var="oaNotifyRecord">
										<tr>
											<td>
												${oaNotifyRecord.user.name}
											</td>
											<td>
												${oaNotifyRecord.user.office.name}
											</td>
											<td>
												${fns:getDictLabel(oaNotifyRecord.readFlag, 'oa_notify_read', '')}
											</td>
											<td>
												<fmt:formatDate value="${oaNotifyRecord.readDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
											</td>
										</tr>
									</c:forEach>
									</tbody>
								</table>
								已查阅：${oaNotify.readNum} &nbsp; 未查阅：${oaNotify.unReadNum} &nbsp; 总共：${oaNotify.readNum + oaNotify.unReadNum}
					</div>
				</div>
				</c:if>
            </div>
		</form:form>
		
		

	</div>
	
		
		
	
</div>	
</body>
</html>