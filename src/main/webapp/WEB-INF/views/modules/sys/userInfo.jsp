<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>个人资料</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
		});
		//0:隐藏tip, 1隐藏box,不设置显示全部
		top.$.jBox.closeTip();
	</script>
	<style type="text/css">
		.ibox-content{
			min-height: 500px;
		}
	</style>
</head>
<body class="gray-bg">
	<body class="gray-bg">
		<div class="wrapper-content">
			<sys:message content="${message}"/>
			<div class="row animated fadeInRight">
				
				<div class="col-sm-3">
					<div class="ibox">
						<div class="ibox-title">
							<h5>个人头像</h5>
						</div>
						<div class="ibox-content text-center">
							<br><br>
							<img alt="image" class="img-circle text-center" src="${user.photo }" width="50%" height="50%" onerror="this.src='${ctxStatic}/images/user.jpg'"/>
							<br><br>
							<a href="${ctx}/sys/user/imageEdit" class="btn btn-white">更换头像</a>
							
						</div>
					</div>
				</div>
				<div class="col-sm-9">
					<div class="ibox">
						<div class="ibox-title">
							<h5>个人资料</h5>
						</div>
						<div class="ibox-content">
							<div class="form-horizontal">
									<h4 class="page-header">基本信息</h4>
									<div class="row">
										<div class="col-sm-6">
											<div class="view-group">
												<label class="col-sm-4 control-label">姓名</label>
												<div class="col-sm-8">
													<p class="form-control-static">${user.name}</p>
												</div>
											</div>
										</div>
										<div class="col-sm-6">
											<div class="view-group">
												<label class="col-sm-4 control-label">工号</label>
												<div class="col-sm-8">
													<p class="form-control-static">${user.no}</p>
												</div>
											</div>
										</div>
									</div>
									<div class="row">
										<div class="col-sm-6">
											<div class="view-group">
												<label class="col-sm-4 control-label">手机</label>
												<div class="col-sm-8">
													<p class="form-control-static">${user.mobile}</p>
												</div>
											</div>
										</div>
										<div class="col-sm-6">
											<div class="view-group">
												<label class="col-sm-4 control-label">电话</label>
												<div class="col-sm-8">
													<p class="form-control-static">${user.phone}</p>
												</div>
											</div>
										</div>
									</div>
									<div class="row">
										<div class="col-sm-6">
											<div class="view-group">
												<label class="col-sm-4 control-label">邮箱</label>
												<div class="col-sm-8">
													<p class="form-control-static">${user.email}</p>
												</div>
											</div>
										</div>
										
									</div>
									<div class="row">
										<div class="col-sm-6">
											<div class="view-group">
												<label class="col-sm-4 control-label">公司</label>
												<div class="col-sm-8">
													<p class="form-control-static">${user.company.name}</p>
												</div>
											</div>
										</div>
										<div class="col-sm-6">
											<div class="view-group">
												<label class="col-sm-4 control-label">部门</label>
												<div class="col-sm-8">
													<p class="form-control-static">${user.office.name}</p>
												</div>
											</div>
										</div>
									</div>
									<h4 class="page-header">帐号信息</h4>
									<div class="row">
										<div class="col-sm-6">
											<div class="view-group">
												<label class="col-sm-4 control-label">登录账号</label>
												<div class="col-sm-8">
													<p class="form-control-static">${user.loginName}</p>
												</div>
											</div>
										</div>
										<div class="col-sm-6">
											<div class="view-group">
												<label class="col-sm-4 control-label">绑定手机号</label>
												<div class="col-sm-8">
													<p class="form-control-static">${user.mobile}</p>
												</div>
											</div>
										</div>
									</div>
									<div class="row">
										<div class="col-sm-6">
											<div class="view-group">
												<label class="col-sm-4 control-label">用户角色</label>
												<div class="col-sm-8">
													<p class="form-control-static">${user.roleNames}</p>
												</div>
											</div>
										</div>
										<div class="col-sm-6">
											<div class="view-group">
												<label class="col-sm-4 control-label">用户类型</label>
												<div class="col-sm-8">
													<p class="form-control-static">${fns:getDictLabel(user.userType, 'sys_user_type', '无')}</p>
												</div>
											</div>
										</div>
									</div>
									<div class="row">
										<div class="col-sm-6">
											<div class="view-group">
												<label class="col-sm-4 control-label">上次登录IP</label>
												<div class="col-sm-8">
													<p class="form-control-static">${user.oldLoginIp}</p>
												</div>
											</div>
										</div>
										<div class="col-sm-6">
											<div class="view-group">
												<label class="col-sm-4 control-label">上次登录时间</label>
												<div class="col-sm-8">
													<p class="form-control-static"><fmt:formatDate value="${user.oldLoginDate}" type="both" dateStyle="full"/></p>
												</div>
											</div>
										</div>
									</div>
									<br><br>
									<div class="row">
										<div class="col-sm-6">
											<div class="view-group">
												<a href="#" onclick="openDialog('编辑资料', '${ctx}/sys/user/infoEdit','800px', '500px')" class="btn btn-white">编辑资料</a>
											</div>
										</div>
									</div>
							
							
								</div>
						</div>
					</div>
				</div>
				
			</div>
				
		</div>
</body>
</html>