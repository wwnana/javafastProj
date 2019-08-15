<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html>
<head>
<title>设置</title>
<%@ include file="/WEB-INF/views/include/weuihead.jsp"%>
<script type="text/javascript">
	
</script>
</head>
<body ontouchstart>
	<div class="bd">
		<div class="page__bd">
			<div class="weui-cells">

				<a class="weui-cell weui-cell_access" href="${ctx}/mobile/more/userInfo">
					<div class="weui-cell__bd">
						<p>账号</p>
					</div>
					<div class="weui-cell__ft">${fns:getUser().loginName }</div>
				</a>
			</div>
			<div class="weui-cells">
				<a class="weui-cell weui-cell_access" href="${ctx}/mobile/more/version">
					<div class="weui-cell__bd">
						<p>版本信息</p>
					</div>
					<div class="weui-cell__ft">
						<p class="weui-media-box__desc">
							<i class="weui-icon-success-no-circle"></i>企业版
						</p>
					</div>
				</a> <a class="weui-cell weui-cell_access" href="${ctx}/mobile/more/contact">
					<div class="weui-cell__bd">
						<p>联系客服</p>
					</div>
					<div class="weui-cell__ft"></div>
				</a> <a class="weui-cell weui-cell_access" href="${ctx}/mobile/more/about">
					<div class="weui-cell__bd">
						<p>关于我们</p>
					</div>
					<div class="weui-cell__ft"></div>
				</a>
				
			</div>
			<shiro:hasPermission name="sys:user:list">
			<div class="weui-cells">
				<a class="weui-cell weui-cell_access" href="${ctx}/mobile/more/permission">
					<div class="weui-cell__hd"><img src="${ctxStatic}/weui/images/icon_tv.png" alt="" style="width:25px;height:25px;margin-right:5px;display:block"></div>
					<div class="weui-cell__bd">
						<p>权限管理</p>
					</div>
					<div class="weui-cell__ft"></div>
				</a>
			</div>
			</shiro:hasPermission>

		</div>
	</div>
	

</body>
</html>
