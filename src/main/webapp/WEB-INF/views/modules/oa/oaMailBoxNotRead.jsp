<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>邮件通知</title>
<meta name="decorator" content="default" />
</head>
<body class="gray-bg">
	<div class="">
		<div class="ibox">
			<div class="ibox-content">
				<sys:message content="${message}" />
				<div class="row">

					<table id="contentTable"
						class="table">
						
						<tbody>
							<c:forEach items="${page.list}" var="mailBox">
								<tr>
									<td><a href="${ctx}/iim/mailBox/detail?id=${mailBox.id}" target="mainFrame">
											${fns:abbr(mailBox.mail.title,50)} </a>
									</td>
									
									<td><span class="pull-right text-muted small">${fns:getTimeDiffer(mailBox.sendtime)}</span>
									</td>
								</tr>
							</c:forEach>
						</tbody>
						<tfoot>
						<td>
							<a href="${ctx}/iim/mailBox/" target="mainFrame">
							查看所有 <i class="ace-icon fa fa-arrow-right"></i> </a></td>
						</tfoot>
					</table>

					<!-- 分页代码 -->
				</div>
			</div>
		</div>
</body>
</html>