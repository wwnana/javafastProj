<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<%@ attribute name="modelName" type="java.lang.String" required="true" description="对象名称"%>
<%@ attribute name="url" type="java.lang.String" required="true" description="查询URL"%>

		<!--<a href="javascript:;" class="weui-btn weui-btn_primary">点击展现searchBar</a>-->
        <div class="weui-search-bar" id="searchBar">
            <form:form id="searchForm" modelAttribute="${modelName}" action="${url}/list" method="post" class="weui-search-bar__form">
            <form:hidden path="keywords"/>  	
                <div class="weui-search-bar__box">
                    <i class="weui-icon-search"></i>
                    <input id="searchInput" name="searchInput" type="search" class="weui-search-bar__input" placeholder="搜索" required/>
                    <a href="javascript:" class="weui-icon-clear" id="searchClear"></a>
                </div>
                <label class="weui-search-bar__label" id="searchText">
                    <i class="weui-icon-search"></i>
                    <span>搜索</span>
                </label>
            </form:form>
            <a href="javascript:" class="weui-search-bar__cancel-btn" id="searchCancel">取消</a>
        </div>
        <div class="weui-cells searchbar-result" id="searchResult">
        	
        </div>
        
<script type="text/javascript">
    $(function(){
        var $searchBar = $('#searchBar'),
            $searchResult = $('#searchResult'),
            $searchText = $('#searchText'),
            $searchInput = $('#searchInput'),
            $searchClear = $('#searchClear'),
            $searchCancel = $('#searchCancel');
        $searchResult.hide();
        function hideSearchResult(){
            $searchResult.hide();
            $searchInput.val('');
        }
        function cancelSearch(){
            hideSearchResult();
            $searchBar.removeClass('weui-search-bar_focusing');
            $searchText.show();
        }

        $searchText.on('click', function(){
            $searchBar.addClass('weui-search-bar_focusing');
            $searchInput.focus();
        });
        $searchInput
            .on('blur', function () {
                if(!this.value.length) cancelSearch();
            })
            .on('input', function(){
            	
                if(this.value.length) {
                	//显示结果
                	$searchResult.show();
                	//删除结果
                    $("#searchResult").empty();
                	//自动补齐
                	loadDataBySearchInput();
                } else {
                    $searchResult.hide();
                    //删除结果
                    $("#searchResult").empty();
                }
            })
        ;
        $searchClear.on('click', function(){
            hideSearchResult();
            $searchInput.focus();
        });
        $searchCancel.on('click', function(){
            cancelSearch();
            $searchInput.blur();
        });
        //监听手机输入键盘的搜索事件
        $("#searchInput").on('keypress', function(e) {
        	
        	var keycode = e.keyCode;
        	var searchContent = $(this).val();
        	if (keycode == '13') {
        		e.preventDefault();
        		if (searchContent == '') {
        			alertMsgBox('请输入检索内容！');
        		}else{
        			$("#searchResult").empty();
        			loadDataBySearchInput();
        		}
        	}
        });
    });
    function loadDataBySearchInput(){	
		
	    $.ajax({
    		url:"${url}/listData",
    		data: {pageNo:1, keywords:$("#searchInput").val()},
    		type:"POST",
    		async:true,    //或false,是否异步
    		dataType:'json',
    		success:function(data){
    			if(data != null){	   				
    				if(data.count > 0){
    					
    					//$searchResult.show();
    					var dataList = data.list;
    					var html = "";
    					for(var i=0;i<dataList.length;i++){    						
    						html += "<div class=\"weui-cell weui-cell_access\" onclick=\"viewData('"+ dataList[i].id +"','"+ dataList[i].name +"')\" >";
    						html += "<div class=\"weui-cell__bd weui-cell_primary\">";
    						html += "<p>"+dataList[i].name+"</p>";
    						html += "</div>";
    						html += "</div>";
    					}
    					$("#searchResult").append(html);
    				}
    			}
    		},
    		error:function(){
    			alertMsg("服务器未响应");
    		}
    	});
    }
    
    

</script>

