<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>机构管理</title>
	<meta name="decorator" content="default"/>
	
</head>

<body class="">
<div class="">
	<div class="">
		<div class="row dashboard-header gray-bg">
			<h5>组织机构 </h5>
			<div class="pull-right">
				<a href="${ctx}/sys/office/list" class="btn btn-white btn-sm" title="列表展示"><i class="fa fa-list-ul"></i></a>
				<a href="${ctx}/sys/office/map" class="btn btn-white btn-sm active" title="列块展示"><i class="fa fa-sitemap"></i></a>	
				<a href="${ctx}/sys/office/map" class="btn btn-white btn-sm" title="刷新"><i class="fa fa-refresh"></i></a>
				<shiro:hasPermission name="sys:office:add">
					<table:addRow url="${ctx}/sys/office/form?parent.id=${office.id}" title="机构" width="800px" height="600px" target="officeContent" pageModel="page" label="添加机构"></table:addRow><!-- 增加按钮 -->
				</shiro:hasPermission>
			</div>		
		</div>
		<div class="ibox-content">
			<div class=" animated fadeInRight">
			        <div class="row">
			        	<c:forEach items="${list}" var="office">
			            <div class="col-sm-4">            
			            	<div class="ibox">
			                    <div class="ibox-title">
			                        <h5><strong>${office.name }</strong></h5>
			                    </div>
			                    <div class="ibox-content" style="height: 200px;overflow: hidden;">
			                        
			                        <div class="team-members" style="height: 120px;overflow: hidden;">
			                        	<c:forEach items="${office.userList}" var="user">
			                            <a href="#"><img alt="${user.name }" class="img-circle" src="${user.photo}" onerror="this.src='${ctxStatic}/images/user.jpg'">
			                            </a>
			                            </c:forEach>    
			                        </div>
			                        <div class="pull-right">
									 <shiro:hasPermission name="sys:office:edit">
										<a href="${ctx}/sys/office/form?id=${office.id}" class="btn btn-default btn-sm" title="修改"><i class="fa fa-edit"></i> 修改</a>
									</shiro:hasPermission>
									<shiro:hasPermission name="sys:office:del">
										<a href="${ctx}/sys/office/delete?id=${office.id}" onclick="return confirmx('要删除该机构及所有子机构项吗？', this.href)" class="btn btn-default btn-sm" title="删除"><i class="fa fa-trash"></i> 删除</a>
									</shiro:hasPermission>
									<shiro:hasPermission name="sys:office:add">
										<a href="${ctx}/sys/office/form?parent.id=${office.id}" class="btn btn-default btn-sm" title="添加下级机构"><i class="fa fa-plus"></i> 添加下级</a>
									</shiro:hasPermission>
									</div>
			                    </div>
			                </div>
			            </div>
			            </c:forEach>    
			        </div>
			    </div>
		
		</div>
	</div>
	
</div>
		
</body>
</html>