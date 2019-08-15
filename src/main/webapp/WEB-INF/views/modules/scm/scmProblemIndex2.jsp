<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>常见问题列表</title>
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
			window.location="${ctx}/scm/scmProblem/index";
		}
	</script>
</head>
<body class="gray-bg">	
	<div class="wrapper-content">
	<div class="ibox">
		<div class="ibox-title">
			<h5>常见问题列表 </h5>			
		</div>
	<div class="ibox-content">
	<sys:message content="${message}"/>
	<div id="content" class="row">
		<div id="left" style="border:1px solid #e7eaec" class="col-sm-1">
			<a onclick="refresh()" class="pull-right mt10" >
				<i class="fa fa-refresh"></i>
			</a>
			<div id="ztree" class="ztree"></div>
		</div>
		<div id="right"  class="col-sm-11  animated fadeInRight">
			<iframe id="listContent" name="listContent" src="${ctx}/scm/scmProblem/list" width="100%" height="91%" frameborder="0"></iframe>
		</div>
	</div>
	</div>
	</div>
	</div>
	<script type="text/javascript">
		var setting = {data:{simpleData:{enable:true,idKey:"id",pIdKey:"pId",rootPId:'0'}},
			callback:{onClick:function(event, treeId, treeNode){
					var id = treeNode.id == '0' ? '' :treeNode.id;
					
					$('#listContent').attr("src","${ctx}/scm/scmProblem/list?scmProblemType.id="+id+"&scmProblemType.parentIds="+treeNode.pIds);
				}
			}
		};
		
		function refreshTree(){
			//加载树形列表
			$.getJSON("${ctx}/scm/scmProblemType/treeData",function(data){
				$.fn.zTree.init($("#ztree"), setting, data).expandAll(true);
			});
		}
		refreshTree();
		 
		var leftWidth = 200; // 左侧窗口大小
		var htmlObj = $("html"), mainObj = $("#main");
		var frameObj = $("#left, #openClose, #right, #right iframe");
		function wSize(){
			var strs = getWindowSize().toString().split(",");
			htmlObj.css({"overflow-x":"hidden", "overflow-y":"hidden"});
			mainObj.css("width","auto");
			frameObj.height(strs[0] - 120);
			var leftWidth = ($("#left").width() < 0 ? 0 : $("#left").width());
			$("#right").width($("#content").width()- leftWidth - $("#openClose").width() -61);
			$(".ztree").width(leftWidth - 10).height(frameObj.height() - 46);
		}
	</script>
	<script src="${ctxStatic}/common/wsize.min.js" type="text/javascript"></script>
</body>
</html>