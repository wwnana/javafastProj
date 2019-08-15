<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html>
  <head>
      <title>版本信息</title>
      <%@ include file="/WEB-INF/views/include/weuihead.jsp"%>
  </head>
  <body ontouchstart>
    	
        <div class="weui-cells">
            <div class="weui-cell">
                <div class="weui-cell__bd">
                    <p>系统名称</p>
                </div>
                <div class="weui-cell__ft">${fns:getSysAccount().systemName }</div>
            </div>
            <div class="weui-cell">
                <div class="weui-cell__bd">
                    <p>当前版本</p>
                </div>
                <div class="weui-cell__ft">企业版V2.0</div>
            </div>
        	
            <div class="weui-cell">
                <div class="weui-cell__bd">
                    <p>授权用户</p>
                </div>
                <div class="weui-cell__ft">${fns:getSysAccount().maxUserNum }个</div>
            </div>
            
        </div>
        <div class="weui-cells__title"></div>
        
    
  </body>
</html>
