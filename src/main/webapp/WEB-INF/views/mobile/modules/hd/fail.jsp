<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>提交失败</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no, maximum-scale=1, shrink-to-fit=no">
    <%@ include file="/WEB-INF/views/include/weuihead.jsp"%>
</head>
<body>
<mobile:message content="${message}"/>
<div class="page">
    <div class="weui-msg">
        <div class="weui-msg__icon-area"><i class="weui-icon-warn weui-icon_msg"></i></div>
        <div class="weui-msg__text-area">
            <h2 class="weui-msg__title">操作失败</h2>
            <p class="weui-msg__desc">失败原因：${content}</a></p>
        </div>
        <div class="weui-msg__opr-area">
            <p class="weui-btn-area">
                
            </p>
        </div>
        <div class="weui-msg__extra-area">
            <div class="weui-footer">
                
                <p class="weui-footer__text">Copyright &copy; 2008-2019 ${fns:getConfig('productName')}</p>
            </div>
        </div>
    </div>
</div>
</body>
</html>