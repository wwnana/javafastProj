<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>组织机构管理</title>
	<meta name="decorator" content="default"/>
	<%@include file="/WEB-INF/views/include/treeview.jsp" %>
	<style type="text/css">
		.ztree {overflow:auto;margin:0;_margin-top:10px;padding:10px 0 0 10px;}
	</style>
	<script type="text/javascript">
		function refresh(){//刷新			
			window.location="${ctx}/sys/office/";
		}
	</script>
</head>
<body class="gray-bg">
	
	<div class="wrapper-content">
		<div class="row">
        	<div class="col-sm-2">
        		<div class="ibox float-e-margins">
                    <div class="ibox-title">                        
                        <h5>组织机构</h5>
                        <div class="ibox-tools">
                            <a onclick="refresh()"><i class="fa fa-refresh"></i></a>
                    	</div>
                    </div>
                    <div class="ibox-content" id="left">                    	
						<div id="ztree" class="ztree leftBox-content"></div>
                    </div>
                </div>
        	</div>
        	<div class="col-sm-10" id="right">
        		<iframe id="officeContent" name="officeContent" src="${ctx}/sys/office/list" width="100%" height="91%" frameborder="0"></iframe>
        	</div>
        </div>
	</div>
	<script type="text/javascript">
		var setting = {data:{simpleData:{enable:true,idKey:"id",pIdKey:"pId",rootPId:'0'}},
			callback:{onClick:function(event, treeId, treeNode){
					var id = treeNode.id == '0' ? '' :treeNode.id;
					$('#officeContent').attr("src","${ctx}/sys/office/list?id="+id+"&parentIds="+treeNode.pIds);
				}
			}
		};
		
		function refreshTree(){
			$.getJSON("${ctx}/sys/office/treeData",function(data){
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
			$("#officeContent").height(strs[0] - 61);
			
			//frameObj.height(strs[0] - 120);
			//var leftWidth = ($("#left").width() < 0 ? 0 : $("#left").width());
			//$("#right").width($("#content").width()- leftWidth - $("#openClose").width() -61);
			//$(".ztree").width(leftWidth - 10).height(frameObj.height() - 46);
		}
	</script>
	<script src="${ctxStatic}/common/wsize.min.js" type="text/javascript"></script>
</body>
</html>