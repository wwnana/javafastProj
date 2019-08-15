<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>报表主页</title>
   	<meta name="decorator" content="default"/>
</head>
<body class="gray-bg">
    <div class="wrapper-content">
        <div class="row">
            
            <div class="col-sm-12 animated fadeInRight">
                <div class="mail-box-header">

                   <form:form id="searchForm" modelAttribute="genReport" action="${ctx}/reportHome" method="post" class="form-inline hide">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
							<span>业务分类：</span>
							<form:select path="countType" class="form-control input-medium">
								<form:option value="" label=""/>
								<form:options items="${fns:getDictList('count_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
							<span>报表名称：</span>
							<form:input path="name" htmlEscape="false" maxlength="50" class="form-control input-medium"/>
							<button  class="btn btn-white btn-sm " onclick="search()" ><i class="fa fa-search"></i> 查询</button>	 
							<button class="btn btn-white btn-sm" data-toggle="tooltip" data-placement="left" onclick="sortOrRefresh()" title="刷新列表"><i class="fa fa-refresh"></i> 刷新</button>
                       
						</form:form>
                   
                   
                </div>
                <div class="mail-box">

                    <table id="contentTable" class="table table-hover table-mail">
                    	<thead> 
                    		<tr>
                    			
                    			<th>报表名称</th>
								<th>报表描述</th>
								
								<th>操作</th>
                    		</tr>
                    	</thead>
                        <tbody>
                        
                        	<c:forEach items="${page.list}" var="genReport">
								<tr>
									
	                                <td>
	                                	<a href="${ctx}/gen/genReport/report?id=${genReport.id}" title="查看图表">
										${genReport.name}
										</a>
									</td>
									<td>
										${genReport.comments}
									</td>
									<td>								
										<a href="${ctx}/gen/genReport/report?id=${genReport.id}" class="btn btn-info btn-xs" title="查看"><i class="fa fa-search-plus"></i>
										<span class="hidden-xs">查看</span></a>
									</td>
								</tr>
							</c:forEach>
                         
                        </tbody>
                    </table>
                   <table:page page="${wmsInstockPage}"></table:page>
					
                </div>
            </div>
        </div>
    </div>



    <script>
      
        
	   function search(){//查询，页码清零
			$("#pageNo").val(0);
			$("#searchForm").submit();
	   		return false;
	   }

		function resetSearch(){//重置，页码清零
			$("#pageNo").val(0);
			$("#searchForm div.form-group input").val("");
			$("#searchForm div.form-group select").val("");
			$("#searchForm").submit();
	  		return false;
	 	 }
		function sortOrRefresh(){//刷新或者排序，页码不清零
			
			$("#searchForm").submit();
	 		return false;
	 	}
		function page(n,s){//翻页
			$("#pageNo").val(n);
			$("#pageSize").val(s);
			$("#searchForm").submit();
			$("span.page-size").text(s);
			return false;
		}
    </script>


</body>

</html>