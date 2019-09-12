<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html class="gt-ie8 gt-ie9 not-ie">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="renderer" content="webkit">
    <title>${fns:getSysAccount().systemName} </title>
    <%@ include file="/WEB-INF/views/include/hplushead.jsp"%>
    <script src="${ctxStatic}/common/inspinia.js?v=3.2.0"></script>
	<script src="${ctxStatic}/common/contabs-hplus.js"></script> 
	
    <!-- Pixel Admin's stylesheets -->
    <link href="${ctxStatic}/assets/css/bootstrap.min.css" rel="stylesheet" type="text/css">
	<link href="${ctxStatic}/assets/css/bootstrap-duallistbox.css" rel="stylesheet" />
    <link href="${ctxStatic}/assets/css/pixel-admin.min.css" rel="stylesheet" type="text/css">
    <link href="${ctxStatic}/assets/css/widgets.min.css" rel="stylesheet" type="text/css">
    <link href="${ctxStatic}/assets/css/rtl.min.css" rel="stylesheet" type="text/css">
    <link href="${ctxStatic}/assets/css/themes.min.css" rel="stylesheet" type="text/css">
    <link href="${ctxStatic}/assets/css/grid/openplat.css" rel="stylesheet">
    <link href="${ctxStatic}/assets/css/jquery/jquery.webui-popover.min.css" rel="stylesheet">
    <link href="${ctxStatic}/assets/css/morris/morris.css" rel="stylesheet">
	<link href="${ctxStatic}/assets/js/bootstrap-fileinput/css/fileinput.min.css" rel="stylesheet" />
	<link href="${ctxStatic}/awesome/4.4/css/font-awesome.min.css" rel="stylesheet" />
	<style>
	.sgrid table tr {
		height: 36px
	}
	
	.z-loading-wrap {
		overflow: hidden;
		position: absolute;
		top: 45%;
		left: 50%;
		z-index: 1000;
		width: 100px;
		height: 100px;
		display: none;
		margin-left: -50px;
	}
	
	.z-loading-wrap img {
		width: 60px;
		height: 60px;
	}
	</style>
	<script>var _urlPath = "${ctxStatic}/";</script>
    
    <link href="${ctxStatic}/assets/js/colorpicker/jquery.bigcolorpicker.css" rel="stylesheet">
    <script src="${ctxStatic}/assets/js/colorpicker/jquery.bigcolorpicker.js"></script>
    <script type="text/javascript">
    	
        // 影藏popover
        function hideJwpopover(){
            $('.jwpopover').each(function(index, obj){
                $(obj).webuiPopover('hide');
            });
        }
        $.ajaxSetup({
            beforeSend:function(XMLHttpRequest){
                hideJwpopover();
            }
        });
        $(function(){ 
        	 $(document).ajaxStart(function () {
        	　　　　$(".z-loading-wrap").show();
        	　});
        	 
        	　$(document).ajaxComplete(function () {
        		setTimeout(function(){
        			$(".z-loading-wrap").hide();
        		},1000)//3000是表示3秒后执行隐藏代码
        	　　});
        });
    </script>
    <script src="${ctxStatic}/assets/js/bootstrap.min.js"></script>
	<script src="${ctxStatic}/assets/js/jquery.bootstrap-duallistbox.js"></script>
    <script src="${ctxStatic}/assets/js/jquery/jquery.webui-popover.js"></script>
    <script src="${ctxStatic}/assets/js/grid/spagination.js"></script>
    <script src="${ctxStatic}/assets/js/grid/sgrid.js"></script>
    <script src="${ctxStatic}/assets/js/grid/model.js"></script>
    <script src="${ctxStatic}/assets/js/grid/utils.js"></script>
    <script src="${ctxStatic}/assets/js/util/JsUtil.js"></script>
    <script src="${ctxStatic}/assets/js/util/form.js"></script>
    <!-- Pixel Admin's javascripts -->
    <script src="${ctxStatic}/assets/js/pixel-admin.min.js"></script>
    <script src="${ctxStatic}/assets/js/quote.js"></script>
    <script src="${ctxStatic}/assets/js/morris/raphael-min.js"></script>
    <script src="${ctxStatic}/assets/js/morris/morris.min.js"></script>
    <script src="${ctxStatic}/assets/js/util/ajaxupload.3.6.js"></script>
    <script src="${ctxStatic}/assets/js/util/imgbox.js"></script>
    <script src="${ctxStatic}/assets/js/util/md5.js"></script>
	<script src="${ctxStatic}/assets/js/bootstrap-fileinput/js/fileinput.min.js"></script>
	<script src="${ctxStatic}/assets/js/bootstrap-fileinput/js/fileinput_locale_zh.js"></script>
	<script src="${ctxStatic}/assets/js/ueditor/ueditor.config.js" type="text/javascript"></script>
	<script src="${ctxStatic}/assets/js/ueditor/ueditor.all.min.js" type="text/javascript"> </script>
	<script src="${ctxStatic}/assets/js/ueditor/lang/zh-cn/zh-cn.js" type="text/javascript"></script>
    <style type="text/css"> 
		#iconview{display:none;}
		#imgview{display:none;}
		.form-group{margin-bottom: unset;}
		#main-navbar .navbar-collapse, #main-navbar .navbar-collapse.collapse {
    		overflow: visible !important;
		}
	</style>
</head>
<body class="theme-blue-flare main-menu-animated">
<div class="z-loading-wrap">
     <div class="spinner">
       <img src="${ctxStatic}/assets/images/loading2.gif" />
     </div>
     <div class="z-msg">拼命加载中...</div>
 </div>

<script>
	var init = [];
	/* var operations = [
	    <c:if test="${fn:length(operations) != 0}">
		    <c:forEach items="${operations}" var="oper">"${oper.opcode}",</c:forEach>
	    </c:if>
	]; */
	//var operations = [<#list operations as operation><#if operation_index != 0>,</#if>'${operation.opcode}'</#list>];
</script>
<script src="${ctxStatic}/assets/demo/demo.js"></script>
<script src="${ctxStatic}/assets/js/util/lunarUtil.js"></script>
<script src="${ctxStatic}/assets/js/util/Util.js"></script>
<div id="main-wrapper" style="vertical-align: unset;">
	<div id="main-navbar" class="navbar navbar-inverse" role="navigation">
		<button type="button" id="main-menu-toggle">
			<i class="navbar-icon fa fa-bars icon"></i><span class="hide-menu-text">隐藏菜单</span>
		</button>
		<div class="navbar-inner">
			<div class="navbar-header">
				<a href="${ctx}/home" target="mainFrame" class="navbar-brand">${fns:getSysAccount().systemName}</a>
				<button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#main-navbar-collapse">
					<i class="navbar-icon fa fa-bars"></i>
				</button>
			</div>
			<div id="main-navbar-collapse" class="collapse navbar-collapse main-navbar-collapse">
				
					
					<%--
						<c:set var="firstMenu" value="true"/>
						<c:forEach items="${fns:getMenuList()}" var="menu" varStatus="idxStatus">
							<c:if test="${menu.parent.id eq '1'&&menu.isShow eq '1'}">
								<li class="menu ${not empty firstMenu && firstMenu ? ' active' : ''}">
									<c:if test="${empty menu.href}">
										<a class="menu" href="javascript:" data-href="${ctx}/sys/menu/tree?parentId=${menu.id}" data-id="${menu.id}"><span>${menu.name}</span></a>
									</c:if>
									<c:if test="${not empty menu.href}">
										<a class="menu" href="${fn:indexOf(menu.href, '://') eq -1 ? ctx : ''}${menu.href}" data-id="${menu.id}" target="mainFrame"><span>${menu.name}</span></a>
									</c:if>
								</li>
								<c:if test="${firstMenu}">
									<c:set var="firstMenuId" value="${menu.id}"/>
								</c:if>
								<c:set var="firstMenu" value="false"/>
							</c:if>
						</c:forEach>
						 --%>
					<ul class="nav navbar-nav" id="menu" style="*white-space: nowrap;"> 
						
						
						<c:set var="firstMenu" value="true" />
						<c:forEach items="${fns:getMenuList()}" var="menu"
							varStatus="idxStatus">
							<c:if test="${menu.parent.id eq '1'&&menu.isShow eq '1'}">
								<li class="menu ${not empty firstMenu && firstMenu ? ' active' : ''}">
									<c:if test="${empty menu.href}">
										<a class="menu" href="javascript:" data-href="${ctx}/sys/menu/tree?parentId=${menu.id}" data-id="${menu.id}"><span>${menu.name}</span></a>
									</c:if>
									<c:if test="${not empty menu.href}">
										<a class="menu" href="${fn:indexOf(menu.href, '://') eq -1 ? ctx : ''}${menu.href}" data-id="${menu.id}" target="mainFrame"><span>${menu.name}</span></a>
									</c:if>
								</li>
								<c:if test="${firstMenu}">
									<c:set var="firstMenuId" value="${menu.id}" />
								</c:if>
								<c:set var="firstMenu" value="false" />
							</c:if>
						</c:forEach>
						
						
					</ul>
					<div class="right clearfix">
						
						<ul class="nav navbar-nav navbar-top-links pull-right right-navbar-nav">
							
							<li><a href="${ctx}/search" target="mainFrame" title="全局搜索"><i class="fa fa-search"></i></a></li>
							<li><a href="#" onclick="toShowThemeDiv()" title="切换样式"><i class="fa fa-dashboard"></i></a></li>
							
							<li class="dropdown">
	                            <a class="dropdown-toggle count-info" data-toggle="dropdown" href="#">
	                                <i class="fa fa-bell"></i> <c:if test="${count > 0}"><span class="label label-warning">${count }</span></c:if>
	                            </a>
	                            <ul class="dropdown-menu dropdown-alerts">
	                                <li>
	                                    <a href="${ctx}/oa/oaNotify/self" target="mainFrame">
	                                        <div>
	                                            <i class="fa fa-bell"></i> 您有${count }条未读通知
	                                        </div>
	                                    </a>
	                                </li>
	                                <c:forEach items="${page.list}" var="oaNotify">
	                                <li class="divider"></li>
	                                <li>
	                                    <a href="${ctx}/oa/oaNotify/view?id=${oaNotify.id}" target="mainFrame">
	                                        <div>
	                                            ${fns:abbr(oaNotify.title,30)}
	                                            <span class="pull-right text-muted small">${fns:getTimeDiffer(oaNotify.updateDate)}</span>
	                                        </div>
	                                    </a>
	                                </li>
	                                </c:forEach>
	                                <li class="divider"></li>
	                                <li>
	                                    <div class="text-center link-block">
	                                        <a class="J_menuItem" href="${ctx}/oa/oaNotify/self" target="mainFrame">
	                                            <strong>查看所有通知 </strong>
	                                            <i class="fa fa-angle-right"></i>
	                                        </a>
	                                    </div>
	                                </li>
	                            </ul>
	                        </li>
	                        
	                        <li class="dropdown">
	                            <a class="dropdown-toggle count-info" data-toggle="dropdown" href="#">
	                                <i class="fa fa-envelope"></i> <c:if test="${noReadCount > 0}"><span class="label label-warning">${noReadCount}</span></c:if>
	                            </a>
	                            <ul class="dropdown-menu dropdown-alerts">
	                                <li>
	                                    <a href="${ctx}/iim/mailBox/list?orderBy=sendtime desc" target="mainFrame">
	                                        <div>
	                                            <i class="fa fa-envelope"></i> 您有${noReadCount }条未读消息
	                                        </div>
	                                    </a>
	                                </li>
	                                <c:forEach items="${mailPage.list}" var="mailBox">
	                                <li class="divider"></li>
	                                <li>
	                                    <a href="${ctx}/iim/mailBox/detail?id=${mailBox.id}" target="mainFrame">
	                                        <div>
	                                            <strong>${mailBox.sender.name }</strong>：
	                                            ${fns:abbr(mailBox.mail.title,26)}
	                                            <span class="pull-right text-muted small">${fns:getTimeDiffer(mailBox.sendtime)}</span>
	                                        </div>
	                                    </a>
	                                </li>
	                                </c:forEach>
	                                <li class="divider"></li>
	                                <li>
	                                    <div class="text-center link-block">
	                                        <a class="J_menuItem" href="${ctx}/iim/mailBox/list?orderBy=sendtime desc" target="mainFrame">
	                                            <strong>查看所有消息 </strong>
	                                            <i class="fa fa-angle-right"></i>
	                                        </a>
	                                    </div>
	                                </li>
	                            </ul>
	                        </li>
	                        
							
							<li class="dropdown">
								<a href="#" class="dropdown-toggle user-menu" data-toggle="dropdown" id="showHeadImg">
									<img src="${fns:getUser().photo}" onerror="this.src='${ctxStatic}/images/user.jpg'">                                        
									<span>${fns:getUser().name}</span>
									<i class="fa fa-caret-down"></i>
								</a>
								<ul class="dropdown-menu">
									<li>
										<a class="J_menuItem" href="${ctx }/sys/user/info" target="mainFrame"><i class="fa fa-user"></i>&nbsp;&nbsp;<span>个人资料</span></a>
									</li>
									<li>
										<a class="J_menuItem" href="${ctx}/sys/user/modifyPwd" target="mainFrame"><i class="ace-icon fa fa-lock"></i>&nbsp;&nbsp;<span>修改密码</span></a>
									</li>
	                                
	                                <li class="divider"></li>
	                                <li>
	                                	<a href="#" onclick="toShowThemeDiv()"><i class="ace-icon fa fa-dashboard "></i>&nbsp;&nbsp;<span>切换主题</span></a>
	                                </li> 
									<li>
	                                	<a href="#" onclick="changeStyle()"><i class="fa  fa-exchange"></i>&nbsp;&nbsp;<span>返回旧版</span></a>
	                                </li>
	                                
									<li class="divider"></li>
	
									<li>
										<a class="J_menuItem" href="#" onclick="logout();"><i class="ace-icon fa fa-power-off"></i>&nbsp;&nbsp;<span>安全退出</span></a>
									</li>
								</ul>
							</li>
						</ul>
					</div>
				
			</div>
		</div>
	</div>

	<div id="main-menu" role="navigation">
		<div id="main-menu-inner">
			<div class="menu-content top" id="menu-content-demo">
			    <div>
			        <div class="text-bg"><span class="text-semibold">${fns:getUser().name}</span></div>
			        <a class="J_menuItem" href="${ctx }/sys/user/info" target="mainFrame">
      					<img src="${fns:getUser().photo}" alt="${fns:getUser().name}" onerror="this.src='${ctxStatic}/images/user.jpg'">
                    </a>
			        <div class="btn-group ">
			            <a href="${ctx}/home" target="mainFrame" data-original-title="主页" class="btn btn-xs btn-success btn-outline dark add-tooltip"><i class="fa fa-home fa-fw"></i></a>
			            <a href="${ctx}/sys/user/info" target="mainFrame" data-original-title="个人设置" class="btn btn-xs btn-success btn-outline dark add-tooltip"><i class="fa fa-cog"></i></a>
			            <a href="javascript:logout()" data-original-title="退出" class="btn btn-xs btn-danger btn-outline dark add-tooltip"><i class="fa fa-power-off"></i></a>
			        </div>
			        <a href="#" class="close">&times;</a>
			    </div>
			</div>
			
			<div id="left">
			</div>
			<%-- <ul class="navigation">
				<t:hplusMenu  menu="${fns:getTopMenu()}"></t:hplusMenu>			
			</ul>--%>
		</div>
	</div>
	
	
	<div class="row J_mainContent" id="content-main" style="margin-top: 48px;">
    	<iframe class="J_iframe" name="mainFrame" id="mainFrame" width="100%" height="100%" src="${ctx}/home" frameborder="0" data-id="${ctx}/home" seamless></iframe>
    </div>

	<div id="main-menu-bg"></div>

</div>

<script type="text/javascript">

$(document).ready(function(){
	$(".z-loading-wrap").show();
	// 绑定菜单单击事件
    $("#menu a.menu").click(function() {
    	
    	if($("#main-navbar-collapse").hasClass("in")){
    		$("#main-navbar-collapse").removeClass("in collapsing");
    		$("#main-menu-toggle").click();
    	}
    	
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
});
	
	function setCookie(name,value)
	{
	    var Days = 30;
	    var exp = new Date();
	    exp.setTime(exp.getTime() + Days*24*60*60*1000);
	    document.cookie = name + "="+ escape (value) + ";expires=" + exp.toGMTString();
	}	
	//读取cookies
	function getCookie(name)
	{
	    var arr,reg=new RegExp("(^| )"+name+"=([^;]*)(;|$)");
	 
	    if(arr=document.cookie.match(reg))
	 
	        return unescape(arr[2]);
	    else
	        return null;
	}	
	function getSysTheme(){
		var h_theme_name = getCookie("h_theme_name");
		if(h_theme_name != null){			
	    	$("body").attr("class","");
			$("body").addClass(h_theme_name);
		}
	}	
	function setSysTheme(themeName){
		var theme = "theme-"+themeName+" main-menu-animated";
		
		$("body").attr("class","");
		$("body").addClass(theme);
		setCookie("h_theme_name", theme);
	}
	//获取cookie保存的样式
	getSysTheme();
		
	function setCwinHeight(){
		
		var iframeid=document.getElementById("mainFrame"); //iframe id  
  		var hashH = document.documentElement.scrollHeight; 
  		iframeid.height = hashH - 48;
	}
	setCwinHeight();
	
	function changeStyle(){
		   $.get('${pageContext.request.contextPath}/theme/ace?url='+window.top.location.href,function(result){   window.location.reload();});
	}

    init.push(function () {

    });
    window.PixelAdmin.start(init);

	/* $(function(){
	    enterSubmitForm("searchForm", formSubmit);
	    $("li", ".navigation").each(function(index, obj){
	       var opCode = $(obj).attr("opCode");
	       if(opCode && opCode != undefined) {
	          // 权限列表中没有该权限
	          if ($.inArray(opCode, operations) == -1){
	              $(obj).remove();
	          };
	       }
	    });
	}); */

	function goIndex(){
        window.location.href = "${ctx}/login";
    }

    $(function(){
        $('.mm-dropdown li').bind('click',function(){
            $('.mm-dropdown li').removeClass('active');
            $('.mmc-dropdown-delay li').removeClass('active');
            $(this).addClass('active');
        });
        $('.add-tooltip').tooltip();
    })
    
   

	function logout() {
		$.Cfm("确定注销登录?", function() {			
			window.location.href = "${ctx}/logout";
		});
	}

	function index(){
    	window.open("../druid/login.html");
    }
    
    /*
    var headBtn = $("#headBtn");
	new AjaxUpload(headBtn,{
		action: _urlPath+"/admin/uploadPic?type=1&id=" + ${loginUser.id},
		name: "picfile",
		responseType: "json",
		onSubmit: function(file,ext){
			if (!(ext && /^(jpg|png|jpeg|gif)$/.test(ext))){
                modalErr("请选择图片格式文件");
				return false;
			}
			headBtn.text('头像上传中...');
		},
		onComplete: function(file,response){
			if("S" == response.status){
				//goIndex();
			}
		}
	});
	*/
	
	function toShowThemeDiv(){
		//$("#demo-settings-toggler").addClass("hide");
		//$("#demo-settings-toggler").removeClass("hide");
		$('#demo-settings').toggleClass('open');
		return false;
	}
</script>
<%-- 
<!-- 即时聊天插件  开始-->
	<link href="${ctxStatic}/layer-v2.3/layim/layui/css/layui.css" type="text/css" rel="stylesheet"/>
	<script type="text/javascript">
		var currentId = '${fns:getUser().loginName}';
		var currentName = '${fns:getUser().name}';
		var currentFace ='${fns:getUser().photo}';
		var url="${ctx}";
		var static_url="${ctxStatic}";
		var wsServer = 'ws://'+window.document.domain+':8119'; 	
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
	--%>
</body>
</html>