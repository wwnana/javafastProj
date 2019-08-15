<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html>
  <head>
      <title>关于我们</title>
      <%@ include file="/WEB-INF/views/include/weuihead.jsp"%>
  </head>
  <body ontouchstart>

    <header class='demos-header'>
      <h2 class="demos-title">${fns:getSysAccount().systemName}</h2>
      <p class='demos-sub-title'>新一代智能高效客户关系管理系统</p>
    </header>
   
    <div id="list" class='demos-content-padded'>
      <p>
      	${fns:getSysAccount().systemName}专注于中小企业实现高效客户关系管理，可满足企业移动协同办公、客户统一管理、销售精准管控、数据实时统计等需求，轻松助力企业提升运营效率及销售业绩。
      </p>
      
    </div>
  </body>
</html>
