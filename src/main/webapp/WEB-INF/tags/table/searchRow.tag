<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<input id="searchBox" name="searchBox" type="hidden" value="${page.searchBox}"/>
<form:hidden path="keywords"/>
<%-- 使用方法： 1.将本tag写在查询的from里 --%>
<script type="text/javascript">
	$(document).ready(function() {
		if('${page.searchBox}' == '' || '${page.searchBox}' == 'hide'){
			$("#searchForm").hide();
		}
		
		$("#searchBtn").click(function(){
			if($('#searchForm').is(':hidden')){
				$("#searchBox").val("show");
				//$(this).find("i").remove();
				//$(this).html($(this).html()+" <i class=\"fa fa-caret-up\"></i>");
			}else{
				$("#searchBox").val("hide");
				//$(this).find("i").remove();
				//$(this).html($(this).html()+" <i class=\"fa fa-caret-down\"></i>");
			}
			$('#searchForm').toggle();su.autoHeight();
		});
	});
	
</script>