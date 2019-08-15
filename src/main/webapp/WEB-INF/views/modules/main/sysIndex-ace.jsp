<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="renderer" content="webkit">
    <title>${fns:getSysAccount().systemName} - ${fns:getConfig('productName')}</title>

	<%@ include file="/WEB-INF/views/include/acehead.jsp"%>
	<script src="${ctxStatic}/common/inspinia-ace.js?v=3.2.0"></script>
	<script src="${ctxStatic}/common/contabs.js"></script> 


</head>

<body class="no-skin">
		<!-- #section:basics/navbar.layout -->
		<div id="navbar" class="navbar navbar-default">
			<script type="text/javascript">
				try{ace.settings.check('navbar' , 'fixed')}catch(e){}
			</script>

			<div class="navbar-container" id="navbar-container">
				<!-- #section:basics/sidebar.mobile.toggle -->
				<button type="button" class="navbar-toggle menu-toggler pull-left" id="menu-toggler" data-target="#sidebar">
					<span class="sr-only">Toggle sidebar</span>

					<span class="icon-bar"></span>

					<span class="icon-bar"></span>

					<span class="icon-bar"></span>
				</button>

				<!-- /section:basics/sidebar.mobile.toggle -->
				<div class="navbar-header pull-left">
					<!-- #section:basics/navbar.layout.brand -->
					<a href="#" class="navbar-brand">
						<small>
							<i class="fa fa-fire"></i>
							${fns:getSysAccount().systemName}
						</small>
					</a>

					<!-- /section:basics/navbar.layout.brand -->

					<!-- #section:basics/navbar.toggle -->

					<!-- /section:basics/navbar.toggle -->
					<ul class="nav navbar-nav" id="menu" style="*white-space: nowrap;">
						<c:set var="firstMenu" value="true" />
						<c:forEach items="${fns:getMenuList()}" var="menu"
							varStatus="idxStatus">
							<c:if test="${menu.parent.id eq '1'&&menu.isShow eq '1'}">
								<li
									class="menu ${not empty firstMenu && firstMenu ? ' active' : ''}">
									<c:if test="${empty menu.href}">
										<a class="menu" href="javascript:"
											data-href="${ctx}/sys/menu/treeAce?parentId=${menu.id}"
											data-id="${menu.id}"><span>${menu.name}</span></a>
									</c:if> <c:if test="${not empty menu.href}">
										<a class="menu"
											href="${fn:indexOf(menu.href, '://') eq -1 ? ctx : ''}${menu.href}"
											data-id="${menu.id}" target="mainFrame"><span>${menu.name}</span></a>
									</c:if>
								</li>
								<c:if test="${firstMenu}">
									<c:set var="firstMenuId" value="${menu.id}" />
								</c:if>
								<c:set var="firstMenu" value="false" />
							</c:if>
						</c:forEach>
					</ul>
				</div>

				<!-- #section:basics/navbar.dropdown -->
				<div class="navbar-buttons navbar-header pull-right" role="navigation">
					<ul class="nav ace-nav">
						<%-- 
						<li class="grey">
							
							<a id="lang-switch" class="lang-selector dropdown-toggle" href="#" data-toggle="dropdown" aria-expanded="true">
								<span class="lang-selected">
										<img  class="lang-flag" src="${ctxStatic}/common/img/china.png" alt="中国">
										<span class="lang-id">中国</span>
										<span class="lang-name">中文</span>
									</span>
							</a>

							<ul class="dropdown-menu-right dropdown-navbar dropdown-menu dropdown-caret dropdown-close">
								<li class="dropdown-header">
									<i class="ace-icon fa fa-check"></i>
									选择国家语言
								</li>

								<li class="dropdown-content">
									<ul class="dropdown-menu dropdown-navbar">
										<li>
											<a href="#" class="lang-select">
												<img class="lang-flag" src="${ctxStatic}/common/img/china.png" alt="中国">
												<span class="lang-id">中国</span>
												<span class="lang-name">中文</span>
											</a>
										</li>

										<li>
											<a href="#" class="lang-select">
												<img class="lang-flag" src="${ctxStatic}/common/img/united-kingdom.png" alt="English">
												<span class="lang-id">EN</span>
												<span class="lang-name">English</span>
											</a>
										</li>
										
										<li>
											<a href="#" class="lang-select">
												<img class="lang-flag" src="${ctxStatic}/common/img/france.png" alt="France">
												<span class="lang-id">FR</span>
												<span class="lang-name">Français</span>
											</a>
										</li>
										<li>
											<a href="#" class="lang-select">
												<img class="lang-flag" src="${ctxStatic}/common/img/germany.png" alt="Germany">
												<span class="lang-id">DE</span>
												<span class="lang-name">Deutsch</span>
											</a>
										</li>
										<li>
											<a href="#" class="lang-select">
												<img class="lang-flag" src="${ctxStatic}/common/img/italy.png" alt="Italy">
												<span class="lang-id">IT</span>
												<span class="lang-name">Italiano</span>
											</a>
										</li>
										<li>
											<a href="#" class="lang-select">
												<img class="lang-flag" src="${ctxStatic}/common/img/spain.png" alt="Spain">
												<span class="lang-id">ES</span>
												<span class="lang-name">Español</span>
											</a>
										</li>
									</ul>
								</li>

								<li class="dropdown-footer">
								</li>
							</ul>
						</li>
--%>
						<%-- 
						<li>
							<a href="${ctx}/home" class="J_menuItem"><i class="ace-icon fa fa-home"></i>首页</a>							
						</li>
						<li>
							<a href="${ctx}/oaHome" class="J_menuItem"><i class="ace-icon fa fa-star"></i>任务</a>							
						</li>
						<li>
							<a href="${ctx}/crmHome" class="J_menuItem"><i class="ace-icon fa fa-user"></i>客户</a>							
						</li>
						<li><a href="${ctx}/fiHome" class="J_menuItem"><i class="ace-icon fa fa-usd"></i>财务</a></li>
						<li><a href="${ctx}/wmsHome" class="J_menuItem"><i class="ace-icon fa fa-cart-plus"></i>进销存</a></li>
						--%>
						<li><a href="${ctx}/iim/myCalendar" class="J_menuItem" title="我的日程"><i class="ace-icon fa fa-calendar icon-animated-calendar"></i>日程</a></li>
						<li class="purple">
							<a data-toggle="dropdown" class="dropdown-toggle" href="#">
								<i class="ace-icon fa fa-bell icon-animated-bell"></i>
								<span class="badge badge-important">${count }</span>
							</a>
							<ul class="dropdown-menu-right dropdown-navbar navbar-pink dropdown-menu dropdown-caret dropdown-close">
								<li class="dropdown-header">
									<i class="ace-icon fa fa-exclamation-triangle"></i>
									${count } 条未读消息
								</li>
								<li class="dropdown-content">
									<ul class="dropdown-menu dropdown-navbar navbar-pink">
										  <c:forEach items="${page.list}" var="oaNotify">
										  	<li>
					                            <a class="J_menuItem" href="${ctx}/oa/oaNotify/view?id=${oaNotify.id}&">
					                                        <div class="clearfix">
					                                            <i class="fa fa-envelope fa-fw"></i> ${fns:abbr(oaNotify.title,50)}
					                                            <span class="pull-right text-muted small">${fns:getTimeDiffer(oaNotify.updateDate)}</span>
					                                        </div>
					                             </a>
					                        </li>
										</c:forEach>
									</ul>
								</li>
								<li class="dropdown-footer">
									 <a class="J_menuItem" href="${ctx }/oa/oaNotify/self ">
										查看所有
										<i class="ace-icon fa fa-arrow-right"></i>
									</a>
								</li>
							</ul>
						</li>

						<li class="green">
							<a data-toggle="dropdown" class="dropdown-toggle" href="#">
								<i class="ace-icon fa fa-envelope icon-animated-vertical"></i>
								<span class="badge badge-success">${noReadCount}</span>
							</a>

							<ul class="dropdown-menu-right dropdown-navbar dropdown-menu dropdown-caret dropdown-close">
								<li class="dropdown-header">
									<i class="ace-icon fa fa-envelope-o"></i>
									${noReadCount} 未读邮件
								</li>

								<li class="dropdown-content">
									<ul class="dropdown-menu dropdown-navbar">
										 <c:forEach items="${mailPage.list}" var="mailBox">
			                               	<li>
											<a href="#" class="clearfix">
												<img src="${mailBox.sender.photo }" class="msg-photo" alt="${mailBox.sender.name }的邮件" />
												<span class="msg-body">
													<span class="msg-title">
														<span class="blue">${mailBox.sender.name }:</span>
														<a class="J_menuItem" href="${ctx}/iim/mailBox/detail?id=${mailBox.id}">
			                                             ${mailBox.mail.title}
			                                            </a>
													</span>

													<span class="msg-time">
														<i class="ace-icon fa fa-clock-o"></i>
														<span><fmt:formatDate value="${mailBox.sendtime}" pattern="yyyy-MM-dd HH:mm:ss"/></span>
													</span>
												</span>
											</a>
										</li>
		                                </c:forEach>
									

									</ul>
								</li>


							 	<li class="dropdown-footer">
		                              <a class="J_menuItem" href="${ctx}/iim/mailBox/list?orderBy=sendtime desc">
		                                       	查看所有邮件<i class="ace-icon fa fa-arrow-right"></i>
		                              </a>
		                      	</li>
							</ul>
						</li>

						<!-- #section:basics/navbar.user_menu -->
						<li class="light-blue">
							<a data-toggle="dropdown" href="#" class="dropdown-toggle">
								<img class="nav-user-photo" src="${fns:getUser().photo}" alt="" style="width: 40px;height: 40px;"/>
								<span class="">
									${fns:getUser().name}
								</span>

								<i class="ace-icon fa fa-caret-down"></i>
							</a>

							<ul class="user-menu dropdown-menu-right dropdown-menu dropdown-yellow dropdown-caret dropdown-close">
								<li>
									<a class="J_menuItem" href="${ctx}/sys/user/imageEdit">
										<i class="ace-icon fa fa-cog"></i>
										修改头像
									</a>
								</li>
								<li>
									<a class="J_menuItem" href="${ctx}/sys/user/modifyPwd"><i class="ace-icon fa fa-lock"></i>&nbsp;&nbsp;更换密码</a>
								</li>
								<li>
									<a class="J_menuItem" href="${ctx }/sys/user/info">
										<i class="ace-icon fa fa-user"></i>
										个人资料
									</a>
								</li>

                                <li>
                                	<a class="J_menuItem" href="${ctx }/iim/contact/index">
                                	<i class="ace-icon fa fa-indent"></i>
                                	我的通讯录
                                	</a>
                                </li>
                                <li>
                                	<a class="J_menuItem" href="${ctx }/iim/mailBox/list">
                                		<i class="ace-icon fa fa-inbox"></i>
                                	信箱</a>
                                </li> 
                                 <li class="divider"></li>
                                <li><a href="#" onclick="changeStyle()">
                                	<i class="ace-icon fa  fa-mail-reply"></i>
                                	切换到新版</a>
                                </li> 


								<li class="divider"></li>

								<li>
									<a class="J_menuItem" href="${ctx}/logout">
										<i class="ace-icon fa fa-power-off"></i>
										安全退出
									</a>
								</li>
							</ul>
						</li>

						<!-- /section:basics/navbar.user_menu -->
					</ul>
				</div>

				<!-- /section:basics/navbar.dropdown -->
			</div><!-- /.navbar-container -->
		</div>

		<!-- /section:basics/navbar.layout -->
		<div class="main-container" id="main-container">
			<script type="text/javascript">
				try{ace.settings.check('main-container' , 'fixed')}catch(e){}
			</script>

			<!-- #section:basics/sidebar -->
			<div id="sidebar" class="sidebar responsive">
				<script type="text/javascript">
					try{ace.settings.check('sidebar' , 'fixed')}catch(e){}
				</script>

				<div class="sidebar-shortcuts" id="sidebar-shortcuts">
					<div class="sidebar-shortcuts-large" id="sidebar-shortcuts-large">
						<div style="padding-bottom: 10px;">
				        	<div class="text-bg"><span class="text-semibold">${fns:getUser().name}</span></div>
				        	
				        	<img src="${fns:getUser().photo}" alt="" class="img-circle" style="width: 50px;height: 50px;">
					        
					        <div class="btn-group">
					            <a href="${ctx}/sys/user/info" target="mainFrame" title="个人设置" class="btn btn-xs btn-success btn-outline dark add-tooltip"><i class="fa fa-cog"></i></a>
					            <a href="${ctx}/logout" title="退出" class="btn btn-xs btn-danger btn-outline dark add-tooltip"><i class="fa fa-power-off"></i></a>
					             <a href="${ctx}/home" target="mainFrame" title="主页" class="btn btn-xs btn-success btn-outline dark add-tooltip"><i class="fa fa-home fa-fw"></i></a>
					        </div>
					        <a href="#" class="close">&times;</a>
				   	 	</div>
					</div>

					<div class="sidebar-shortcuts-mini" id="sidebar-shortcuts-mini">						
						<img src="${fns:getUser().photo}" alt="${fns:getUser().name}" class="img-circle" style="width: 30px;height: 30px;">
					</div>
				</div><!-- /.sidebar-shortcuts -->
				
				<div id="left">
				</div>
				<%-- 
				<t:aceMenu  menu="${fns:getTopMenu()}"></t:aceMenu>
				--%>
				<!-- #section:basics/sidebar.layout.minimize -->
				<div class="sidebar-toggle sidebar-collapse" id="sidebar-collapse">
					<i class="ace-icon fa fa-angle-double-left" data-icon1="ace-icon fa fa-angle-double-left" data-icon2="ace-icon fa fa-angle-double-right"></i>
				</div>

				<!-- /section:basics/sidebar.layout.minimize -->
				<script type="text/javascript">
					try{ace.settings.check('sidebar' , 'collapsed')}catch(e){}
				</script>
			</div>

			<!-- /section:basics/sidebar -->
			<div class="main-content">
				<div class="main-content-inner">
					<!-- #section:basics/content.breadcrumbs -->
					<div class="breadcrumbs" id="breadcrumbs">
				  <div class="content-tabs">
                <button class="roll-nav roll-left J_tabLeft"><i class="fa fa-backward"></i>
                </button>
                <nav class="page-tabs J_menuTabs">
                    <div class="page-tabs-content">
                         <a href="javascript:;" class="active J_menuTab" data-id="${ctx}/home">首页</a>
                    </div>
                </nav>
                <button class="roll-nav roll-right J_tabRight"><i class="fa fa-forward"></i>
                </button>
                <div class="btn-group roll-nav roll-right">
                    <button class="dropdown J_tabClose"  data-toggle="dropdown">关闭操作<span class="caret"></span>

                    </button>
                    <ul role="menu" class="dropdown-menu dropdown-menu-right">
                        <li class="J_tabShowActive"><a>定位当前选项卡</a>
                        </li>
                        <li class="divider"></li>
                        <li class="J_tabCloseAll"><a>关闭全部选项卡</a>
                        </li>
                        <li class="J_tabCloseOther"><a>关闭其他选项卡</a>
                        </li>
                    </ul>
                </div>
                <%--
                <a href="${ctx}/logout" class="roll-nav roll-right J_tabExit"><i class="fa fa fa-sign-out"></i> 退出</a>
                 --%>
            	</div>
			</div>

			<div class="J_mainContent"  id="content-main">
             <iframe class="J_iframe" name="mainFrame" width="100%" height="100%" src="${ctx}/home" frameborder="0" data-id="${ctx}/home" seamless></iframe>
            </div>
            </div>
            
            
            </div>
            
            <div class="footer">
				<div class="footer-inner">
					<div class="footer-content">
						<span class="">
							&copy; ${fns:getConfig('copyrightYear')} ${fns:getConfig('productName')} ${fns:getConfig('version')}
						</span>
					</div>
				</div>
			</div>			
            
			<a href="#" id="btn-scroll-up" class="pull-left btn-scroll-up btn btn-sm btn-inverse">
				<i class="ace-icon fa fa-angle-double-up icon-only bigger-110"></i>
			</a>
			
        </div>
	</body>
	<!-- 语言切换插件，为国际化功能预留插件 -->
	<script type="text/javascript">	
	
	$(document).ready(function(){	
		
		// 绑定菜单单击事件
	    $("#menu a.menu").click(function() {
	        // 一级菜单焦点
	        $("#menu li.menu").removeClass("active");
	        $(this).parent().addClass("active");
	        /* // 左侧区域隐藏
	        if ($(this).attr("target") == "mainFrame") {
	            $("#left,#openClose").hide();
	            wSizeWidth();
	            // <c:if test="${tabmode eq '1'}"> 隐藏页签
	            $(".jericho_tab").hide();
	            $("#mainFrame").show(); //</c:if>
	            return true;
	        }
	        // 左侧区域显示
	        $("#left,#openClose").show();
	        if (!$("#openClose").hasClass("close")) {
	            $("#openClose").click();
	        } */
	        // 显示二级菜单
	        var menuId = "#menu-" + $(this).attr("data-id");
	        debugger;
	        $.get($(this).attr("data-href"),
	                function(data) {
	                    if (data.indexOf("id=\"loginForm\"") != -1) {
	                        alert('未登录或登录超时。请重新登录，谢谢！');
	                        top.location = "${ctx}";
	                        return false;
	                    }
	                    $("#left").html('');
	                    $("#left").append(data);
	                    // 链接去掉虚框
	                    $(menuId + " a").bind("focus",
	                    function() {
	                        if (this.blur) {
	                            this.blur()
	                        };
	                    });
	                    // 默认选中第一个菜单
	    				$("#left ul a:first").click();
	    				$("#left ul li:first li:first a:first ").click();
	                });
	        return;
	        if ($(menuId).length > 0) {
	        	$("#left ul").addClass("hide");
	        	 $(menuId).next("ul").find("ul").each(function(){
	            	 if($(this).css('display')=="block"){
	                     $(this).css('display','none');
	                 }
	            });
	            $(menuId).next("ul").removeClass("hide");
	            // 初始化点击第一个二级菜单
	         	/* // 二级标题
				$(menuId + " .accordion-heading a").click(function(){
					$(menuId + " .accordion-toggle i").removeClass('icon-chevron-down').addClass('icon-chevron-right');
					if(!$($(this).attr('data-href')).hasClass('in')){
						$(this).children("i").removeClass('icon-chevron-right').addClass('icon-chevron-down');
					}
				});
				// 二级内容
				$(menuId + " .accordion-body a").click(function(){
					$(menuId + " li").removeClass("active");
					$(menuId + " li i").removeClass("icon-white");
					$(this).parent().addClass("active");
					$(this).children("i").addClass("icon-white");
				});
				// 展现三级
				$(menuId + " .accordion-inner a").click(function(){
					var href = $(this).attr("data-href");
					if($(href).length > 0){
						$(href).toggle().parent().toggle();
						return false;
					}
					// <c:if test="${tabmode eq '1'}"> 打开显示页签
					return addTab($(this)); // </c:if>
				}); */
	        } else {
	            // 获取二级菜单数据
	            $.get($(this).attr("data-href"),
	            function(data) {
	                if (data.indexOf("id=\"loginForm\"") != -1) {
	                    alert('未登录或登录超时。请重新登录，谢谢！');
	                    top.location = "${ctx}";
	                    return false;
	                }
	                $("#left ul").addClass("hide");
	                $("#left").append(data);
	                // 链接去掉虚框
	                $(menuId + " a").bind("focus",
	                function() {
	                    if (this.blur) {
	                        this.blur()
	                    };
	                });
	            });
	        }
	        // 大小宽度调整
	        return false;
	    });
	 	// 初始化点击第一个一级菜单
		$("#menu a.menu:first span").click();
	 
		$("a.lang-select").click(function(){
			$(".lang-selected").find(".lang-flag").attr("src",$(this).find(".lang-flag").attr("src"));
			$(".lang-selected").find(".lang-flag").attr("alt",$(this).find(".lang-flag").attr("alt"));
			$(".lang-selected").find(".lang-id").text($(this).find(".lang-id").text());
			$(".lang-selected").find(".lang-name").text($(this).find(".lang-name").text());
	
		});
	});
	
	function changeStyle(){
		$.get('${pageContext.request.contextPath}/theme/hplus?url='+window.top.location.href,function(result){ window.location.reload();  });
	}
	</script>

	<!-- 即时聊天插件  开始-->
	<link href="${ctxStatic}/layer-v2.3/layim/layui/css/layui.css" type="text/css" rel="stylesheet"/>
	<script type="text/javascript">
		var currentId = '${fns:getUser().loginName}';
		var currentName = '${fns:getUser().name}';
		var currentFace ='${fns:getUser().photo}';
		var url="${ctx}";
		var static_url="${ctxStatic}";
		var wsServer = 'ws://'+window.document.domain+':8118'; 	
	</script>
	<!--webscoket接口  -->
	<script src="${ctxStatic}/layer-v2.3/layim/layui/layui.js"></script>	
	<script src="${ctxStatic}/layer-v2.3/layim/layim.js"></script>
	
	<!-- 即时聊天插件 结束 -->
	<style>
		/*签名样式*/
		.layim-sign-box{
			width:95%
		}
		.layim-sign-hide{
		  border:none;background-color:#F5F5F5;
		}
	</style>
</html>