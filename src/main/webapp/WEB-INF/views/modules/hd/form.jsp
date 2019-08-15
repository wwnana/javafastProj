<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>${crmClue.crmMarket.crmMarketData.title}</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no, maximum-scale=1, shrink-to-fit=no">
    <%@ include file="/WEB-INF/views/include/weuihead.jsp"%>
    <script type="text/javascript">
		var validateForm;
		function doSubmit(){
			
			if($("#name").val()==""){
				
				layer.open({
				    content: '请输入您的公司！'
				    ,btn: '我知道了'
				});
				return false;
			}
			if($("#contacterName").val()==""){
				
				layer.open({
				    content: '请输入您的姓名！'
				    ,btn: '我知道了'
				});
				return false;
			}
			
			if($("#mobile").val()=="" || $("#mobile-error").text()!=""){
				
				layer.open({
				    content: '请输入有效的手机号码！'
				    ,btn: '我知道了'
				});
				return false;
			}
			if($("#jobType").val()==""){
				
				layer.open({
				    content: '请输入您的职位！'
				    ,btn: '我知道了'
				});
				return false;
			}
			
			layer.open({
			    type: 2
			    ,content: '提交中...'
			 });
			
			$("#inputForm").submit();
			
		 
		}
		
	</script>
</head>
<body>

<c:if test="${not empty fns:getUser().name}">
<script type="text/javascript">
	share();
</script>
</c:if>
<div class="page">
	<c:if test="${not empty crmClue.crmMarket.crmMarketData.coverImage}">
    <div class="">
        <img src="${crmClue.crmMarket.crmMarketData.coverImage}" style="width: 100%;height: 200px;"/>
    </div>
    </c:if>
    <div class="page__hd">
        <h1 class="page__title">${crmClue.crmMarket.crmMarketData.title}</h1>
        <p class="page__desc">请填写您的信息</p>
    </div>
    <div class="page__bd">
    	<form:form id="inputForm" modelAttribute="crmClue" action="${ctx}/wechat/hd/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<form:hidden path="accountId"/>
		<form:hidden path="crmMarket.id"/>	
		<form:hidden path="ownBy.id"/>
    	<div class="weui-cells__title"><label style="color: red;">*</label> 公司</div>
        <div class="weui-cells">
            <div class="weui-cell">
                <div class="weui-cell__bd">
                    <form:input path="name" class="weui-input" type="text" placeholder="请输入您的公司"/>
                </div>
            </div>
        </div>
        <div class="weui-cells__title"><label style="color: red;">*</label> 姓名</div>
        <div class="weui-cells">
            <div class="weui-cell">
                <div class="weui-cell__bd">
                    <form:input path="contacterName" class="weui-input" type="text" placeholder="请输入您的姓名"/>
                </div>
            </div>
        </div>
        <div class="weui-cells__title"><label style="color: red;">*</label> 手机</div>
        <div class="weui-cells">
            <div class="weui-cell">
                <div class="weui-cell__bd">
                    <form:input path="mobile" class="weui-input" type="tel" placeholder="请输入您的手机"/>
                </div>
            </div>
        </div>
        <div class="weui-cells__title"><label style="color: red;">*</label> 职位</div>
        <div class="weui-cells">
            <div class="weui-cell">
                <div class="weui-cell__bd">
                    <form:input path="jobType" class="weui-input" type="text" placeholder="请输入您的职位"/>
                </div>
            </div>
        </div>
        
        
        </form:form>
        
    </div>
    <br>
    <div class="page__bd page__bd_spacing" style="padding: 10px">
        <button type="button" class="weui-btn weui-btn_primary" onclick="doSubmit()">提交</button>
    </div>
    <br>
    <div class="page__hd">
        ${crmClue.crmMarket.crmMarketData.content}
    </div>
</div>

</body>
</html>