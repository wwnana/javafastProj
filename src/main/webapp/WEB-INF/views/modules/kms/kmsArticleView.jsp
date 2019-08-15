<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>知识查看</title>
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
<body class="">
<div class="">
	<div class="">
		<div class="row dashboard-header gray-bg">
			<h5>知识查看</h5>
			<div class="pull-right">
				
				<a class="btn btn-white btn-sm"  onclick="history.go(-1)">返回</a>
				<c:if test="${fns:getUser().id == kmsArticle.createBy.id}">
					<shiro:hasPermission name="kms:kmsArticle:edit">
	    					<a href="${ctx}/kms/kmsArticle/form?id=${kmsArticle.id}" class="btn btn-white btn-sm" title="修改">修改</a>
						</shiro:hasPermission>
						
						<shiro:hasPermission name="kms:kmsArticle:del">
							<a href="${ctx}/kms/kmsArticle/delete?id=${kmsArticle.id}" onclick="return confirmx('确认要删除该知识吗？', this.href)" target="_parent" class="btn  btn-white btn-sm" title="删除">删除</a> 
						</shiro:hasPermission>
						
					<c:if test="${kmsArticle.status == 0}">
						<shiro:hasPermission name="kms:kmsArticle:audit">
							<a href="${ctx}/kms/kmsArticle/audit?id=${kmsArticle.id}" onclick="return confirmx('确认要发布该知识吗？', this.href)" target="_parent" class="btn  btn-white btn-sm" title="发布">发布</a> 
						</shiro:hasPermission>
					</c:if>
					<c:if test="${kmsArticle.status == 1}">
						<shiro:hasPermission name="kms:kmsArticle:audit">
							<a href="${ctx}/kms/kmsArticle/unAudit?id=${kmsArticle.id}" onclick="return confirmx('确认要撤销该知识吗？', this.href)" target="_parent" class="btn  btn-white btn-sm" title="撤销">撤销</a> 
						</shiro:hasPermission>
					</c:if>
				</c:if>
			</div>
		</div>
		<div class="ibox-content">
			
			<div class="row">
				<div class="col-sm-12">
					<div class="text-center">
		            	<h2>${kmsArticle.title}</h2>
		            </div>
		            <div class="text-center">
		            	<p>发布者：${kmsArticle.createBy.name}，发布时间：<fmt:formatDate value="${kmsArticle.updateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>，点击数：${kmsArticle.hits}</p>
		            </div>
				</div>
			</div>
			<div class="hr-line-dashed"></div>
			<div class="row">
				<div class="col-sm-12">
					<div class="p-lg">
						${kmsArticle.articleData.content }
					</div>
				</div>
			</div>
			<h4 class="page-header">相关附件</h4>
			<div class="row">
				<div class="col-sm-12">
					<input type="hidden" id="files" value="${kmsArticle.articleData.files }" maxlength="1000" class="form-control"/>
					<sys:ckfinder input="files" type="files" uploadPath="/file" selectMultiple="true" readonly="true"/>
				</div>
			</div>
			
			<h4 class="page-header">用户评论</h4>
			
			<form:form id="inputForm" modelAttribute="kmsComment" action="${ctx}/kms/kmsComment/save" method="post" class="form-horizontal">
			<form:hidden path="id"/>
			<input type="hidden" id="articleId" name="articleId" value="${kmsArticle.id }">
			<input type="hidden" id="categoryId" name="categoryId" value="${kmsArticle.kmsCategory.id }">
				<div class="row">
					<div class="col-sm-12">
						<div class="form-group">
								<form:textarea path="content" htmlEscape="false" rows="4" maxlength="250" class="form-control " placeholder="评论内容..."/>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-sm-12">
						<div class="form-group pull-right">
							<button id="btnSubmit" class="btn btn-white" type="submit"><i class="fa fa-check"></i> 提交</button>
						</div>
					</div>
				</div>				
			</form:form>			
			
			<c:forEach items="${kmsArticle.commentList}" var="comment">
				<div class="feed-element">
                   <a href="profile.html#" class="pull-left">
                       <img alt="${comment.createBy.name}" class="img-circle" src="${comment.createBy.photo}">
                   </a>
                   <div class="media-body ">
                       <small class="pull-right"></small>
                       <small class="text-muted"><i class="fa fa-user"></i> ${comment.createBy.name} <i class="fa fa-clock-o"></i> <fmt:formatDate value="${comment.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/> </small>
                       <div class="well">
                           	<a href="#" onclick="openDialogView('查看评论', '${ctx}/crm/comment/view?id=${comment.id}','800px', '500px')" title="查看">
								${comment.content}
							</a>
							<div class="pull-right">
                           <c:if test="${fns:getUser().id == comment.createBy.id}">
								<a href="${ctx}/kms/kmsComment/delete?id=${comment.id}" onclick="return confirmx('确认要删除该评论吗？', this.href)" title="删除"><i class="fa fa-trash"></i></a> 
                           </c:if>
                       </div>
                       </div>
                       
                   </div>
               </div>
               </c:forEach>
		
		</div>
	</div>
	

</div>
</body>
</html>