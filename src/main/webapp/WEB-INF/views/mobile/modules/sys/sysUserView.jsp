<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html>
  <head>
      <title>${user.name }</title>
      <%@ include file="/WEB-INF/views/include/weuihead.jsp"%>
  </head>
  <body ontouchstart>
  <div class="page">
    <div class="page__bd">
    	<div class="weui-cells__title"></div>
        <div class="weui-panel weui-panel_access">
           
            <div class="weui-panel__bd">
                <a href="javascript:void(0);" class="weui-media-box weui-media-box_appmsg">
                    <div class="weui-media-box__hd">
                        <img class="weui-media-box__thumb" src="${user.photo }" onerror="this.src='${ctxStatic}/images/user.jpg'">
                    </div>
                    <div class="weui-media-box__bd">
                        <h4 class="weui-media-box__title">${user.name }</h4>
                        <p class="weui-media-box__desc">${user.job }&nbsp;</p>
                    </div>
                </a>
            </div>
        </div>
    </div>
    
    <div class="weui-cells__title"></div>
        
        <div class="weui-cells">
			<div class="weui-cell">
                <div class="weui-cell__bd">
                    <p>公司</p>
                </div>
                <div class="weui-cell__ft">${user.company.name }</div>
            </div>
            <div class="weui-cell">
                <div class="weui-cell__bd">
                    <p>部门</p>
                </div>
                <div class="weui-cell__ft">${user.office.name }</div>
            </div>
        </div>
        <div class="weui-cells">
            <div class="weui-cell">
                <div class="weui-cell__bd">
                    <p>姓名</p>
                </div>
                <div class="weui-cell__ft">${user.name }</div>
            </div>
            <div class="weui-cell">
                <div class="weui-cell__bd">
                    <p>手机</p>
                </div>
                <div class="weui-cell__ft">${user.mobile }</div>
            </div>
        </div>
    </div>
  </body>
</html>
