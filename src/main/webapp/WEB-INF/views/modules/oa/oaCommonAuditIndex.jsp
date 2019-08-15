<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>审批列表</title>
	<meta name="decorator" content="default"/>
	<%@include file="/WEB-INF/views/include/treeview.jsp"%>
	<style type="text/css">
		.ztree {overflow:auto;margin:0;_margin-top:10px;padding:10px 0 0 10px;}
	</style>
	<script type="text/javascript">
		$(document).ready(function() {
		});
		//0:隐藏tip, 1隐藏box,不设置显示全部
		top.$.jBox.closeTip();
		//刷新
		function refresh(){
			window.location="${ctx}/oa/oaCommonAudit/index";
		}
	</script>
</head>
<body class="gray-bg">
	<div class="wrapper-content">
		<div class="row">
        	<div class="col-sm-2">
        		<div class="ibox float-e-margins">
                    <div class="ibox-title">                        
                        <h5>按审批类型查看</h5>
                    </div>
                    <div class="ibox-content">
                    	<ul class="nav">
                    		<li>
                            	<a href="${ctx}/oa/oaCommonAudit/list" target="listContent"><span class="nav-label">全部流程</span></a>
                            </li>
                    		<c:forEach items="${fns:getDictList('common_audit_type')}" var="type">
                    		<li>
                            	<a href="${ctx}/oa/oaCommonAudit/list?type=${type.value}" target="listContent"><span class="nav-label">${type.label}</span></a>
                            </li>
                    		</c:forEach>
                        </ul>
                    </div>
                </div>
        	</div>
        	<div class="col-sm-10" id="right">
        		<iframe id="listContent" name="listContent" src="${ctx}/oa/oaCommonAudit/list" width="100%" height="100%" frameborder="0"></iframe>
        	</div>
        </div>
	</div>
	
	<script type="text/javascript">
		
		var leftWidth = "auto"; // 左侧窗口大小
		var htmlObj = $("html"), mainObj = $("#main");
		var frameObj = $("#left, #openClose, #right, #right iframe");				
		function wSize(){
			var strs = getWindowSize().toString().split(",");
			htmlObj.css({"overflow-x":"hidden", "overflow-y":"hidden"});
			mainObj.css("width","auto");			
			$("#right").height(strs[0] - 60);
			$("#listContent").height(strs[0] - 60);
		}
	</script>
	<script src="${ctxStatic}/common/wsize.min.js" type="text/javascript"></script>
</body>
</html>