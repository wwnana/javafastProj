<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<jsp:useBean id="now" class="java.util.Date" />     
<fmt:formatDate value="${now}" type="both" dateStyle="long" pattern="yyyy-MM-dd" var="nowDate"/> 
<html>
<head>
	<title>客户查重</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript" src="${ctxStatic}/address/jsAddress.js"></script>
	<style type="text/css">
	
	</style>
	<script type="text/javascript">
		
		function page(n,s){
			$("#pageNo").val(n);
			$("#pageSize").val(s);
			$("#searchForm").submit();
	    	return false;
	    }
		
	</script>
</head>
<body class="">
	<div class="">
		<div class="">
			<div class="row dashboard-header gray-bg">
				<div class="pull-left">					
					<h5>客户查重</h5>
				</div>
			</div>
		
		<div class="ibox-content">
			<sys:message content="${message}"/>
				
				<!-- 查询条件 -->
				<div class="row">
					<div class="col-sm-12">
						<form id="searchForm" action="${ctx}/crm/crmCustomer/query" method="post" class="form-inline text-center">
	                    	<div class="input-group">	
	                        	<input type="text" id="keywords" name="keywords" value="${crmCustomer.keywords}"  class=" form-control input-xxlarge" placeholder="搜索客户名称"/>
	                            <div class="input-group-btn">
	                                <button id="btnSubmit" type="submit" class="btn btn-sm btn-info">
	                                    	<i class="fa fa-search" style="color:#fff;"></i>
	                                </button>
	                            </div>
	                        </div>
	                    </form>
					</div>
				</div>
				<br>
				<!-- 表格 -->
				<c:if test="${not empty page && page.count > 0}">
				<div class="table-responsive">
				<table id="contentTable" class="table table-bordered table-hover">
					<thead>
						<tr>
							<th style="min-width:250px;">客户名称</th>
							
							<th style="min-width:100px;width:100px;" class="sort-column customer_status">客户状态</th>
							<th style="min-width:100px;width:100px;" class="sort-column customer_level">客户级别</th>
							<%--
							<th style="min-width:100px;width:100px;">首要联系人</th>
							<th style="min-width:100px;width:100px;">联系手机</th>
							--%>
							
							
							<th style="min-width:100px;width:100px;" class="sort-column a.create_date">创建时间</th>
							<th style="min-width:100px;width:100px;">负责人</th>
							<th style="min-width:200px;width:200px;">操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="crmCustomer">
						<tr>
							<td>
									${crmCustomer.name}
							</td>
							<td>
								<span class="<c:if test='${crmCustomer.customerStatus == 1}'>text-success</c:if><c:if test='${crmCustomer.customerStatus == 2}'>text-info</c:if><c:if test='${crmCustomer.customerStatus == 3}'>text-danger</c:if>">
									${fns:getDictLabel(crmCustomer.customerStatus, 'customer_status', '')}
								</span>
							</td>
							<td>
								${fns:getDictLabel(crmCustomer.customerLevel, 'customer_level', '')}
							</td>
							<%-- 
							<td>
								${crmCustomer.contacterName}
							</td>
							<td>
								${crmCustomer.mobile}
							</td>
							--%>
							
							<td>
								<fmt:formatDate value="${crmCustomer.createDate}" pattern="yyyy-MM-dd"/>
							</td>
							<td>
								${crmCustomer.ownBy.name}
							</td>
							<td>
								<c:if test="${empty crmCustomer.ownBy.id or fns:getUser().id eq crmCustomer.ownBy.id}">
	                            	<shiro:hasPermission name="crm:crmCustomer:view">
										<a href="${ctx}/crm/crmCustomer/index?id=${crmCustomer.id}"  class="" title="查看">查看</a>
									</shiro:hasPermission>
								</c:if>
									
			                           
							</td>
						</tr>
					</c:forEach>
					</tbody>
				</table>
				</div>
				<table:page page="${page}"></table:page>
				</c:if>
				<c:if test="${not empty page && page.count < 1}">
					<p class="text-center text-muted mt80">没有找到与 “${crmCustomer.keywords}” 相关数据</p>
				</c:if>
			</div>
		</div>
	</div>
	  
	
<script type="text/javascript">

function openMainDialog(title,url){
	
	var width = $(window).width()-300;
	var height = $(window).height();
	
	top.layer.open({
	    type: 2,  
	    shadeClose: true,
	    shade: 0.3,
	    offset: 'rb', //右弹出
	    area: [width+"px", height+"px"],
	    title: title,
        maxmin: false, //开启最大化最小化按钮
	    content: url ,
	    btn: ['关闭'],
	    cancel: function(index){ 
	       }
	}); 
}
</script>
</body>
</html>