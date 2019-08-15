<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>通知管理</title>
<meta name="decorator" content="default" />
</head>
<body class="gray-bg">
	<div class="">
		<div class="ibox">
			<div class="ibox-content">
				<sys:message content="${message}" />
				<div class="row">

					<table id="contentTable"
						class="table table-striped  table-hover">
						
						<tbody>
							<c:forEach items="${page.list}" var="oaNotify">
								<tr>
									<td>[${fns:getDictLabel(oaNotify.type, 'oa_notify_type', '')}] <a href="#"
										onclick="openDialogView('查看通知', '${ctx}/oa/oaNotify/view?id=${oaNotify.id}','800px', '500px')">
											${fns:abbr(oaNotify.title,50)} </a>
									</td>
									
									<td><span class="pull-right text-muted small">${fns:getTimeDiffer(oaNotify.updateDate)}</span>
									</td>
								</tr>
							</c:forEach>
						</tbody>
						<tfoot>
						<td><a class="J_menuItem"
							href="${ctx }/oa/oaNotify/self" target="mainFrame"> 查看所有 <i
								class="ace-icon fa fa-arrow-right"></i>
						</a></td>
						</tfoot>
					</table>

					<!-- 分页代码 -->
				</div>
			</div>
		</div>
</body>
</html>