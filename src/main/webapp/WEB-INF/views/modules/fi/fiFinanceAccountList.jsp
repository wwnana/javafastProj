<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>结算账户管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">

	</script>
</head>
<body class="gray-bg">
	<div class="">
		<div class="">
			<div class="row dashboard-header gray-bg">
				<div class="pull-left">					
					<a class="btn btn-link" href="${ctx}/fi/fiFinanceAccount/list">结算账户列表</a>
				</div>
				<div class="pull-right">
					<a href="${ctx}/fi/fiFinanceAccount/list" class="btn btn-white btn-sm active" title="列块展示"><i class="fa fa-th-large"></i></a>
					<a href="${ctx}/fi/fiFinanceAccount/list2" class="btn btn-white btn-sm" title="列表展示"><i class="fa fa-list-ul"></i></a>
					<shiro:hasPermission name="fi:fiFinanceAccount:export">
					    <table:exportExcel url="${ctx}/fi/fiFinanceAccount/export"></table:exportExcel><!-- 导出按钮 -->
					</shiro:hasPermission>
					<shiro:hasPermission name="fi:fiFinanceAccount:add">
						<a class="btn btn-success btn-sm" href="#" onclick="openDialog('添加结算账户', '${ctx}/fi/fiFinanceAccount/form','800px', '500px')" title="添加账户"><i class="fa fa-plus"></i> 添加账户</a>
					</shiro:hasPermission>
					
				</div>			
			</div>
			<div class="ibox-content">
			<sys:message content="${message}"/>
				<form:form id="searchForm" modelAttribute="fiFinanceAccount" action="${ctx}/fi/fiFinanceAccount/list" method="post" class="">
					<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
					<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
				</form:form>
						
				<div class=" animated fadeInRight">
			        <div class="row">
			        	<c:forEach items="${page.list}" var="fiFinanceAccount">
			            <div class="col-sm-4">            
			            	<div class="ibox">
			                    <div class="ibox-title">
			                        <span class="label label-info pull-right"><c:if test="${fiFinanceAccount.isDefault == 1}">默认</c:if></span>
			                        <h5><strong>${fiFinanceAccount.name}</strong></h5>
			                    </div>
			                    <div class="ibox-content">
			                        <div style="height: 80px;overflow: hidden;">
			                           	<p>当前余额：${fiFinanceAccount.balance}</p>
			                           	<p>开户银行：${fiFinanceAccount.bankName}</p>
			                           	<p>开户账号：${fiFinanceAccount.bankcardNo}</p>
			                        </div>
									 <div class="row m-t-sm ">
										<div class="pull-right">
											<a href="#" onclick="openDialogView('查看结算账户', '${ctx}/fi/fiFinanceAccount/view?id=${fiFinanceAccount.id}','800px', '500px')" class="btn btn-info btn-sm pull-right" >查看</a>
										</div>
									</div>
			                    </div>
			                </div>
			            </div>
			            </c:forEach>    
			        </div>
			    </div>
				
				<div class="row">
    				<c:if test="${fn:length(page.list)>10}">
    					<table:page page="${page}"></table:page>
    				</c:if>
    				
    			</div>
			</div>
		</div>
	</div>
</body>
</html>