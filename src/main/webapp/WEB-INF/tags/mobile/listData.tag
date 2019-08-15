<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<%@ attribute name="url" type="java.lang.String" required="true"%>

<%-- 使用方法： 1.将本tag写在列表页面；2.传入查询列表数据的controller的url --%>
<script type="text/javascript">
var page_no = 1;//当前页
var load_all = false;//已加载全部
$(document).ready(function() {
	
	loadData();
	
	//滚动条到底自动加载下一页
	$(window).scroll(function() {
		if ($(document).scrollTop() >= $(document).height() - $(window).height()) {
			if(load_all == false){
				loadData();
			}                    
        }
	});
});
function loadData(){	
	
    $.ajax({
		url:"${url}",
		data: {pageNo:page_no,name:$("#name").val()},
		type:"POST",
		async:true,    //或false,是否异步
		dataType:'json',
		success:function(data){	    			
			if(data != null && data != "false"){	    				
				setData(data.list);
				
				if(data.count == 0){
					$(".weui-loadmore").hide();
					$("#list-panel").append("<div class=\"weui-loadmore weui-loadmore_line\"><span class=\"weui-loadmore__tips\">未查询到任何数据</span></div>");
					load_all = true;
				}
				if(data.count >0 && data.count <= page_no*20){
					$(".weui-loadmore").hide();
					$("#list-panel").append("<div class=\"weui-loadmore weui-loadmore_line\"><span class=\"weui-loadmore__tips\">已加载全部</span></div>");
					load_all = true;
				}
				page_no++;
			}
		},
		error:function(){
			alert("服务器未响应");
		}
	});
}
</script>