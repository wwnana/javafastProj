<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>关于</title>
	<meta name="decorator" content="default"/> 
	<style type="text/css">
		.col-sm-6 {
			height: 180px;
			width: 240px;
		}
		.ibox-content {
			border:0;
		}
	</style>   
</head>

<body class="white-bg">
	
    <div class="wrapper-content">
        <div class="row">
        	<div class="col-sm-6" style="float:left;padding-right: 0;border-right: 1px solid #dee5e7;">
            	<div class="float-e-margins">
					<div class="ibox-content text-center">
						<br>
						
						<img alt="image" class="text-center" src="${ctxStatic}/images/logo216.png" width="100px" height="100px"/>
						<br>
                        <h5>版本${fns:getConfig('version')}</h5>
                   	</div>
              	</div>
          	</div>
          	<div class="col-sm-6" style="float:right;">
            	<div class="float-e-margins">
					<div class="ibox-content">
                        <ul class="todo-list m-t small-list ui-sortable">
                            <li>
                                <a href="http://www.javafast.cn/" target="_blank" class="check-link"><i class="fa fa-globe"></i> 
                                <span class="m-l-xs">官方网站</span>
                                </a>
                            </li>
                            <li>
                                <a href="http://crm.qikucrm.com/userfiles/1/files/企酷CRM软件用户操作手册.pdf" download="企酷CRM软件用户操作手册.pdf" target="_blank" class="check-link"><i class="fa fa-book"></i> 
                                <span class="m-l-xs">操作手册</span>
                                </a>
                            </li>
                            <li>
                                <a href="http://wpa.qq.com/msgrd?v=3&uin=1553294881&site=qq&menu=yes" target="_blank" class="check-link"><i class="fa fa-comments-o"></i> 
                                <span class="m-l-xs">在线客服</span>
                                </a>
                            </li>
                        </ul>
                   	</div>
              	</div>
          	</div>
      	</div>
    </div>
 </body>
</html>