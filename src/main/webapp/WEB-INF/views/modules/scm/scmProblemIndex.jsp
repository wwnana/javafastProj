<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>常见问题</title>
	<meta name="decorator" content="default"/>
	<%@include file="/WEB-INF/views/include/treeview.jsp" %>
	<style type="text/css">
		.ztree {overflow:auto;margin:0;_margin-top:10px;padding:10px 0 0 10px;}
	</style>
	<script type="text/javascript">
		function refresh(){//刷新			
			window.location="${ctx}/scm/scmProblem/index";
		}
	</script>
</head>
<body class="">
	<div class="">
		<div class="row">
        	<div class="col-sm-2" style="padding-right: 0;border-right: 1px solid #dee5e7;">
        		<div class="">
                    <div class="dashboard-header gray-bg" style="height: 47px;">                        
                        <h5 onclick="refresh()">问题分类</h5>
                        <div class="pull-right">
                        <shiro:hasPermission name="wms:wmsProduct:edit">
                            <a href="${ctx}/scm/scmProblemType/" class="btn btn-white btn-sm">分类维护</a>
                    	</shiro:hasPermission>
                    	</div>
                    </div>
                    <div class="ibox-content" id="left" style="min-height: 178px">                    	
						<div id="ztree" class="ztree leftBox-content"></div>
                    </div>
                </div>
        	</div>
        	<div class="col-sm-10" id="right"  style="padding-left:0;">
        		<iframe id="listContent" name="listContent" src="${ctx}/scm/scmProblem/list" width="100%" height="100%" frameborder="0"></iframe>
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
			$.getJSON("${ctx}/scm/scmProblemType/treeData",function(data){
				$.fn.zTree.init($("#ztree"), setting, data).expandAll(true);
			});
		}
		refreshTree();
		 
		var leftWidth = "auto"; // 左侧窗口大小
		var htmlObj = $("html"), mainObj = $("#main");
		var frameObj = $("#left, #openClose, #right, #right iframe");
		
		
		function wSize(){
			var strs = getWindowSize().toString().split(",");
			htmlObj.css({"overflow-x":"hidden", "overflow-y":"hidden"});
			mainObj.css("width","auto");
			
			$("#right").height(strs[0] - 61);
			$("#listContent").height(strs[0] - 61);
			$("#left").height(strs[0] - 86);

			//frameObj.height(strs[0] - 120);
			//var leftWidth = ($("#left").width() < 0 ? 0 : $("#left").width());
			//$("#right").width($("#content").width()- leftWidth - $("#openClose").width() -61);
			//$(".ztree").width(leftWidth - 10).height(frameObj.height() - 46);
		}
	</script>
	<script src="${ctxStatic}/common/wsize.min.js" type="text/javascript"></script>
</body>
</html>