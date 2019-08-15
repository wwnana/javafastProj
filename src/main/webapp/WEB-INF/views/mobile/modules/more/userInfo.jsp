<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html>
  <head>
      <title>我的账号</title>
      <%@ include file="/WEB-INF/views/include/weuihead.jsp"%>
  </head>
  <body ontouchstart>
    
    <div class="weui-cells__title"></div>
        <div class="weui-cells">
            <div class="weui-cell">
                <div class="weui-cell__bd">
                    <p>姓名</p>
                </div>
                <div class="weui-cell__ft">${fns:getUser().name }</div>
            </div>
            <div class="weui-cell">
                <div class="weui-cell__bd">
                    <p>绑定手机</p>
                </div>
                <div class="weui-cell__ft">${fns:getUser().mobile}</div>
            </div>
        </div>
        <div class="weui-cells">
			<div class="weui-cell">
                <div class="weui-cell__bd">
                    <p>公司</p>
                </div>
                <div class="weui-cell__ft">${fns:getUser().company.name }</div>
            </div>
            <div class="weui-cell">
                <div class="weui-cell__bd">
                    <p>部门</p>
                </div>
                <div class="weui-cell__ft">${fns:getUser().office.name }</div>
            </div>
        </div>
  </body>
</html>
