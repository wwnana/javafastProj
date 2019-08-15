<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>工作报告查看</title>
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
	</script>
</head>
<body class="gray-bg">
<div class="wrapper-content">
<div class="ibox">
	<div class="ibox-title">
		<h5>工作报告查看</h5>
	</div>
	<div class="ibox-content">
		<sys:message content="${message}"/>
		<div class="form-horizontal">
			<h4 class="page-header">基本信息</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">报告类型：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${fns:getDictLabel(oaWorkLog.workLogType, 'work_log_type', '')}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">报告标题：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${oaWorkLog.title}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">报告人：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${oaWorkLog.createBy.name}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">创建时间：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							<fmt:formatDate value="${oaWorkLog.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</p>
						</div>
					</div>
				</div>
			</div>
			<h4 class="page-header">汇报内容</h4>
			<div class="row">
				<div class="col-sm-12">
					<div class="view-group">
						<div class="col-sm-12">
							<div class="well">
							${oaWorkLog.content}
							</div>
						</div>
					</div>
				</div>
			</div>
			
			
			
			<h4 class="page-header">查阅记录</h4>
			<div class="row">
				<div class="col-sm-12">
		
					<table id="contentTable" class="table">
						<thead>
							<tr>
								<th>查阅人</th>
								<th>阅读时间</th>
								<th>评论内容</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach items="${oaWorkLog.oaWorkLogRecordList}" var="oaWorkLogRecord">
								<tr>
											<td>
												${oaWorkLogRecord.user.name}
											</td>
											<td>
												<fmt:formatDate value="${oaWorkLogRecord.readDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
											</td>
											<td>
												<c:if test="${not empty oaWorkLogRecord.auditNotes}">
													<p class="well">${oaWorkLogRecord.auditNotes}</p>
												</c:if>
											</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>			
				</div>		
			</div>		
			
			<c:if test="${fns:getUser().id != oaWorkLog.createBy.id}">
			<form:form id="inputForm" modelAttribute="oaWorkLog" action="${ctx}/oa/oaWorkLog/addReadNote" method="post" class="">
			<form:hidden path="id"/>
			<h4 class="page-header">发表评论</h4>
			<div class="row">
				<div class="col-sm-12">
					<div class="view-group">
						<textarea id="auditNotes" name="auditNotes" rows="" cols="" class="form-control required" maxlength="50"></textarea>
					</div>
				</div>
			</div>
			<div class="row" style="margin-top: 10px;text-align: right;">
				<div class="col-sm-12">
					<div class="view-group">
						<button type="submit" class="btn btn-success" title="评论"><i class="fa fa-pencil"></i> 评论</button>
					</div>
				</div>
			</div>
			</form:form>
			</c:if>
			
			<div class="hr-line-dashed"></div>
			<div class="form-actions">
				<c:if test="${fns:getUser().id == oaWorkLog.createBy.id}">
				<shiro:hasPermission name="oa:oaWorkLog:edit">
			    	<a href="${ctx}/oa/oaWorkLog/form?id=${oaWorkLog.id}" class="btn btn-success" title="修改">修改</a>
				</shiro:hasPermission>
				<shiro:hasPermission name="oa:oaWorkLog:del">
					<a href="${ctx}/oa/oaWorkLog/delete?id=${oaWorkLog.id}" onclick="return confirmx('确认要删除该工作报告吗？', this.href)" class="btn btn-danger" title="删除">删除</a> 
				</shiro:hasPermission>
				</c:if>
				<a id="btnCancel" class="btn btn-white" href="${ctx}/oa/oaWorkLog/">返回</a>
			</div>
		</div>
	</div>
</div>
</div>
</body>
</html>