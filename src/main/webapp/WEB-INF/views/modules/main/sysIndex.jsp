<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html class="gt-ie8 gt-ie9 not-ie">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="renderer" content="webkit">
    <title>${fns:getConfig('productName')} - 企业级JAVA快速开发平台, 内置Java代码生成器</title>
  	<meta name="description" content="JavaFast企业级快速开发平台，基于代码生成器的开发方式，可以帮助解决java项目中80%的重复工作，极大降低开发成本。可以应用在任何Java Web项目的开发中，尤其适合企业级ERP、OA、CRM、WMS、OMS、金融系统、电子商务系统、各类互联网平台管理后台等。">
  	<meta name="keywords" content="java快速开发平台,java开源架构,代码生成器,开源OA,java代码生成器,JEECG,开源CRM,CRM源码,微信开发源码">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no, minimum-scale=1.0, maximum-scale=1.0">
   
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
        	　　　　$(".z-loading-wrap").show()
        	　})
        	 
        	　$(document).ajaxComplete(function () {
        	　　　　$(".z-loading-wrap").hide()
        	　　})
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
	</style>
</head>
<body class="theme-frost main-menu-animated">
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
				<a href="#" class="navbar-brand" style="font-size: 20px;">JavaFast</a>
				<button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#main-navbar-collapse">
					<i class="navbar-icon fa fa-bars"></i>
				</button>
			</div>
			<div id="main-navbar-collapse" class="collapse navbar-collapse main-navbar-collapse">
				<div>
					<ul class="nav navbar-nav">
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
						<li><a href="${ctx}/home" target="mainFrame">主页</a></li>
						<li><a href="${ctx}/oaHome" target="mainFrame">任务</a></li>
						<li><a href="${ctx}/crmHome" target="mainFrame">客户</a></li>
						
						<li><a href="${ctx}/fiHome" target="mainFrame">财务</a></li>
						<li><a href="${ctx}/wmsHome" target="mainFrame">仓储</a></li>
						
						<li><a href="${ctx}/sysHelp" target="mainFrame">简介</a></li>
						<li><a href="${ctx}/sysGuide" target="mainFrame">购买</a></li>
						
						<li>
							<a href="#" data-toggle="dropdown" class="dropdown-toggle">更多</a>
							<ul class="dropdown-menu-right dropdown-navbar navbar-pink dropdown-menu dropdown-caret dropdown-close">
								<li><a href="http://www.javafast.cn" target="mainFrame"><i class="ace-icon fa fa-home"></i>&nbsp;&nbsp;官网</a></li>
								<li>
									<a href="http://ui.javafast.cn/" target="_blank"><i class="ace-icon fa fa-cog"></i>&nbsp;&nbsp;Admin UI组件</a>
								</li>
								<li>
									<a href="http://ace.javafast.cn/" target="_blank"><i class="ace-icon fa fa-cog"></i>&nbsp;&nbsp;ACE UI组件</a>
								</li>
								<li>
									<a href="http://www.javafast.cn/doc/code.pdf" target="mainFrame"><i class="ace-icon fa fa-cog"></i>&nbsp;&nbsp;技术文档</a>
								</li>
							</ul>
						</li>
					</ul>
					<div class="right clearfix">
						
						<ul class="nav navbar-nav pull-right right-navbar-nav">
							<li><a href="${ctx}/iim/myCalendar" target="mainFrame"><i class="ace-icon fa fa-calendar icon-animated-calendar"></i><span>日程</span></a></li>
							<li class="purple">
								<a data-toggle="dropdown" class="dropdown-toggle" href="#">
									<i class="ace-icon fa fa-bell icon-animated-bell"></i><span>通知</span>
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
						                            <a class="J_menuItem" href="${ctx}/oa/oaNotify/view?id=${oaNotify.id}&" target="mainFrame">
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
										 <a class="J_menuItem" href="${ctx }/oa/oaNotify/self" target="mainFrame">
											查看所有
											<i class="ace-icon fa fa-arrow-right"></i>
										</a>
									</li>
								</ul>
							</li>
							<li class="green">
								<a data-toggle="dropdown" class="dropdown-toggle" href="#">
									<i class="ace-icon fa fa-envelope icon-animated-vertical"></i><span>邮件</span>
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
															<a class="J_menuItem" href="${ctx}/iim/mailBox/detail?id=${mailBox.id}" target="mainFrame">
				                                             ${mailBox.mail.overview}
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
			                              <a class="J_menuItem" href="${ctx}/iim/mailBox/list?orderBy=sendtime desc" target="mainFrame">
			                                       	查看所有邮件<i class="ace-icon fa fa-arrow-right"></i>
			                              </a>
			                      	</li>
								</ul>
							</li>
							<li class="dropdown">
								<a href="#" class="dropdown-toggle user-menu" data-toggle="dropdown" id="showHeadImg">
									<img src="${fns:getUser().photo}" alt=""><span>${fns:getUser().name}</span>
									<i class="fa fa-caret-down"></i>
								</a>
								<ul class="dropdown-menu">
									<li>
										<a class="J_menuItem" href="${ctx}/sys/user/imageEdit" target="mainFrame"><i class="ace-icon fa fa-cog"></i>&nbsp;&nbsp;修改头像</a>
									</li>
									<li>
										<a class="J_menuItem" href="${ctx }/sys/user/info" target="mainFrame"><i class="ace-icon fa fa-user"></i>&nbsp;&nbsp;个人资料</a>
									</li>
									<li>
										<a href="#" onclick="openDialog('修改密码', '${ctx}/sys/user/modifyPwd','800px', '500px')"><i class="ace-icon fa fa-lock"></i>&nbsp;&nbsp;更换密码</a>
									</li>
	                                <li>
	                                	<a class="J_menuItem" href="${ctx }/iim/contact/index" target="mainFrame"><i class="ace-icon fa fa-indent"></i>&nbsp;&nbsp;我的通讯录</a>
	                                </li>
	                                <li>
	                                	<a class="J_menuItem" href="${ctx }/iim/mailBox/list" target="mainFrame"><i class="ace-icon fa fa-inbox"></i>&nbsp;&nbsp;信箱</a>
	                                </li> 
	                                 <li class="divider"></li>
	                                <li>
	                                	<a href="#" onclick="toShowThemeDiv()"><i class="ace-icon fa fa-share-alt"></i>&nbsp;&nbsp;样式设置</a>
	                                </li> 
									<li>
	                                	<a href="#" onclick="changeStyle()"><i class="ace-icon fa  fa-mail-reply"></i>&nbsp;&nbsp;切换到ACE模式</a>
	                                </li>
	
									<li class="divider"></li>
	
									<li>
										<a class="J_menuItem" href="#" onclick="logout();"><i class="ace-icon fa fa-power-off"></i>&nbsp;&nbsp;安全退出</a>
									</li>
								</ul>
							</li>
						</ul>
					</div>
				</div>
			</div>
		</div>
	</div>

	<div id="main-menu" role="navigation">
		<div id="main-menu-inner">
			<div class="menu-content top" id="menu-content-demo">
			    <div>
			        <div class="text-bg"><span class="text-semibold">${fns:getUser().name}</span></div>
			        <img src="${fns:getUser().photo}" alt="" class="">
			        <div class="btn-group">
			            <a href="${ctx }/sys/user/info" target="mainFrame" data-original-title="个人设置" class="btn btn-xs btn-success btn-outline dark add-tooltip"><i class="fa fa-cog"></i></a>
			            <a href="javascript:logout()" data-original-title="退出" class="btn btn-xs btn-danger btn-outline dark add-tooltip"><i class="fa fa-power-off"></i></a>
			            <a href="${ctx}/home" target="mainFrame" data-original-title="主页" class="btn btn-xs btn-danger btn-outline dark add-tooltip"><i class="fa fa-home fa-fw"></i></a>
			        </div>
			        <a href="#" class="close">&times;</a>
			    </div>
			</div>
			
			<ul class="navigation">
				<t:hplusMenu  menu="${fns:getTopMenu()}"></t:hplusMenu>			
			    
			</ul>
		</div>
	</div>
	
	
	<div class="row J_mainContent" id="content-main" style="margin-top: 38px;">
    	<iframe class="J_iframe" name="mainFrame" id="mainFrame" width="100%" height="100%" src="${ctx}/home" frameborder="0" data-id="${ctx}/home" seamless></iframe>
    </div>

	<div id="main-menu-bg"></div>

</div>

<script type="text/javascript">
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
  		iframeid.height = hashH - 38;
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
</body>
</html>