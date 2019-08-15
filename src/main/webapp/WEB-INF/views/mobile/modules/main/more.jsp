<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html>
<head>
<title>更多</title>
<%@ include file="/WEB-INF/views/include/weuihead.jsp"%>
<script type="text/javascript">
	$(function() {

		//监听返回事件
		pushHistory();
		window.addEventListener("popstate", function(e) {
			//不处理
			WeixinJSBridge.call('closeWindow');
		}, false);
		function pushHistory() {
			var state = {
				title : "title",
				url : "#"
			};
			window.history.pushState(state, "title", "#");
		}
	});
</script>
</head>
<body ontouchstart>

	<div class="weui-cells margin-top0">
		<div class="weui-cell" onclick="javascritp:location.href='${ctx}/mobile/more/userInfo'" style="padding-top: 20px;padding-bottom: 20px;">
			<div class="weui-cell__hd" style="position: relative; margin-right: 10px;">
				<img src="${fns:getUser().photo}" style="width:50px;height:50px; display: block;" onerror="this.src='${ctxStatic}/images/user.jpg'">
				<%-- 
                    <span class="weui-badge" style="position: absolute;top: -.4em;right: -.4em;">V</span>
                    --%>
			</div>
			<div class="weui-cell__bd">
				<p>${fns:getUser().name}</p>
				<p style="font-size: 13px; color: #888888;">
					${fns:getSysAccount().name }</p>
			</div>
		</div>
	</div>


	<div class="bd">
		<div class="page__bd">
			<%--
      	<div class="weui-cells__title">内部消息</div>
        <div class="weui-cells">

          <a class="weui-cell weui-cell_access" href="${ctx }/oa/oaNotify/self">
            <div class="weui-cell__bd">
              <p>通知公告</p>
            </div>
            <div class="weui-cell__ft">
            	<c:if test="${notifyCount >0}">
            	<span class="weui-badge" style="margin-left: 5px;margin-right: 5px;">${notifyCount}</span>
            	</c:if>
            </div>
          </a>
          <a class="weui-cell weui-cell_access" href="${ctx}/iim/mailBox/list?orderBy=sendtime desc">
            <div class="weui-cell__bd">
              <p>内部消息</p>
            </div>
            <div class="weui-cell__ft">
            	<c:if test="${notifyCount >0}">
            	<span class="weui-badge" style="margin-left: 5px;margin-right: 5px;">${noReadCount}</span>
            	</c:if>
            </div>
          </a>
        </div>
      	 --%>

				
			
			<div class="weui-cells">
				
				
				
				<a class="weui-cell weui-cell_access" href="${ctx}/mobile/crm/crmCustomerRemind">
					<div class="weui-cell__hd"><img src="${ctxStatic}/weui/images/icon_remind3.png" alt="" style="width:25px;height:25px;margin-right:5px;display:block"></div>
					<div class="weui-cell__bd">
						<p>到期提醒</p>
					</div>
					<div class="weui-cell__ft"></div>
				</a>
				<a class="weui-cell weui-cell_access" href="${ctx}/mobile/crm/crmStar">
					<div class="weui-cell__hd"><img src="${ctxStatic}/weui/images/icon_star.png" alt="" style="width:25px;height:25px;margin-right:5px;display:block"></div>
					<div class="weui-cell__bd">
						<p>我的关注</p>
					</div>
					<div class="weui-cell__ft"></div>
				</a>
				<a class="weui-cell weui-cell_access" href="${ctx}/mobile/crm/crmBrowseLog">
					<div class="weui-cell__hd"><img src="${ctxStatic}/weui/images/icon_foot.png" alt="" style="width:25px;height:25px;margin-right:5px;display:block"></div>
					<div class="weui-cell__bd">
						<p>最近浏览</p>
					</div>
					<div class="weui-cell__ft"></div>
				</a>
				<a class="weui-cell weui-cell_access" href="${ctx}/mobile/sys/sysDynamic">
					<div class="weui-cell__hd"><img src="${ctxStatic}/weui/images/icon_dynamic2.png" alt="" style="width:25px;height:25px;margin-right:5px;display:block"></div>
					<div class="weui-cell__bd">
						<p>团队动态</p>
					</div>
					<div class="weui-cell__ft"></div>
				</a>
			</div>
			
			<div class="weui-cells">
				<a class="weui-cell weui-cell_access" href="${ctx}/mobile/more/set">
					<div class="weui-cell__hd"><img src="${ctxStatic}/weui/images/icon_set.png" alt="" style="width:25px;height:25px;margin-right:5px;display:block"></div>
					<div class="weui-cell__bd">
						<p>设置</p>
					</div>
					<div class="weui-cell__ft"></div>
				</a>
			</div>

		</div>
	</div>
	<c:set value="4" var="nav"></c:set>
	<%@ include file="foot.jsp"%>

</body>
</html>
