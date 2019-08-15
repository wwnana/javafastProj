<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>话题查看</title>
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
	<div class="ibox float-e-margins">
         <div class="ibox-title">
             <h5>话题讨论 - ${oaTopic.title}</h5>
             <div class="ibox-tools">
                 
             </div>
         </div>
            <div class="ibox-content">            	
            	<div class="social-avatar">
                 <a href="" class="pull-left">
                     <img alt="image" src="${oaTopic.createBy.photo}">
                 </a>
                 <div class="pull-right">
	                 <c:if test="${fns:getUser().id == oaTopic.createBy.id}">			    	
						<a href="${ctx}/oa/oaTopic/delete?id=${oaTopic.id}" onclick="return confirmx('确认要删除该话题吗？', this.href)" class="" title="删除"><i class="fa fa-trash"></i></a> 
					</c:if>
                 </div>
                 <div class="media-body">
                     <a href="#">
                           ${oaTopic.createBy.name}
                     </a>
                     <small class="text-muted">${fns:getTimeDiffer(oaTopic.createDate)}</small>
                 </div>
          </div>
          <div class="social-body">
                  <p>
                      ${oaTopic.content}
                  </p>
          </div>
			<h4 class="page-header">最新讨论</h4>
			<div class="social-footer">
				<c:forEach items="${oaTopic.oaTopicRecordList}" var="oaTopicRecord" varStatus="status">
	                 <div class="social-comment">
	                     <a href="" class="pull-left">
	                         <img alt="image" src="${oaTopicRecord.user.photo}">
	                     </a>
	                     <div class="media-body">
	                         <a href="#">
	                             ${oaTopicRecord.user.name}
	                         </a> 
	                         <c:if test="${status.index == 0}">1楼</c:if>
	                         <c:if test="${fns:getUser().id == oaTopicRecord.user.id}">
	                         	<a href="${ctx}/oa/oaTopic/deleteOaTopicRecord?id=${oaTopic.id}&recordId=${oaTopicRecord.id}" class="small" title="删除" onclick="return confirmx('确认要删除该记录吗？', this.href)"><i class="fa fa-trash"></i></a>
	                         </c:if>
	                         <br/>
	                         <a href="${ctx}/oa/oaTopic/thumbOaTopicRecord?id=${oaTopic.id}&recordId=${oaTopicRecord.id}" class="small" title="点赞"><i class="fa fa-thumbs-up"></i> ${oaTopicRecord.thumbs}</a> -
	                         <small class="text-muted">${fns:getTimeDiffer(oaTopicRecord.createDate)}</small>
	                     </div>
	                 </div>
	                 <div class="social-body">
	                  <p>
	                      ${oaTopicRecord.notes}
	                  </p>
	          		</div>
				</c:forEach>


              
				<form:form id="inputForm" modelAttribute="oaTopic" action="${ctx}/oa/oaTopic/addOaTopicRecord" method="post" class="">
				<form:hidden path="id"/>
                <div class="social-comment">
                    <a href="" class="pull-left">
                        <img alt="image" src="${fns:getUser().photo}">
                    </a>
                    <div class="media-body">
                        <textarea id="notes" name="notes" class="form-control" placeholder="发表讨论..." maxlength="500" rows="4"></textarea>
                        <div class="view-group" style="padding-top: 5px;">
                        <button type="submit" class="btn btn-success" title="提交">提交</button>
                        </div>
                    </div>
                </div>
                </form:form>
            </div>
                    
                    
            
		
			<div class="hr-line-dashed"></div>
			<div class="form-actions">				
				<a id="btnCancel" class="btn btn-white" onclick="history.go(-1)"><i class="fa fa-reply"></i> 返回</a>
			</div>
		
	</div>
</div>
</div>
</body>
</html>