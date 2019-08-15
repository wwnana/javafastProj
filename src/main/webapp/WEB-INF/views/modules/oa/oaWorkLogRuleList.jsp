<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>汇报规则列表</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
	</script>
</head>
<body class="gray-bg">
<div class="wrapper-content">
	<div class="col-sm-5">
		<div class="ibox">
			<div class="ibox-title">
				<h5>设置汇报规则 </h5>
			</div>
			<div class="ibox-content">
			<sys:message content="${message}"/>				
				
				<!-- 工具栏 -->
				<div class="row">
					<div class="col-sm-12 m-b-sm">
						<div class="pull-left">
							<shiro:hasPermission name="oa:oaWorkLogRule:list">
								<table:addRow url="${ctx}/oa/oaWorkLogRule/form" title="固定汇报对象" label="添加固定汇报对象" width="400px" height="260px"></table:addRow><!-- 增加按钮 -->
							</shiro:hasPermission>
							
						</div>
					</div>
				</div>
				<br>
				<div class="row">					
				<!-- 数据表格 -->
				<div class="col-sm-12">
				<table id="contentTable" class="table">
					<thead>
						<tr>
							<th width="100px">固定汇报对象</th>
							<th width="50px"></th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="oaWorkLogRule">
						<tr>
							<td>
								<a href="#" onclick="openDialogView('查看汇报规则', '${ctx}/oa/oaWorkLogRule/view?id=${oaWorkLogRule.id}','800px', '500px')">
									<img src="${oaWorkLogRule.user.photo}" width="50px" height="50px"/> ${oaWorkLogRule.user.name}
								</a>
							</td>
							<td>
								<shiro:hasPermission name="oa:oaWorkLogRule:list">
									<a href="${ctx}/oa/oaWorkLogRule/delete?id=${oaWorkLogRule.id}" onclick="return confirmx('确认要删除该汇报规则吗？', this.href)" class="" title="删除"><i class="fa fa-remove"></i></a> 
								</shiro:hasPermission>
							</td>
						</tr>
					</c:forEach>
					</tbody>
				</table>
				</div>
				</div>
				
				<div class="hr-line-dashed"></div>
				<div class="form-actions">
					<a id="btnCancel" class="btn btn-white" href="${ctx}/oa/oaWorkLog/">返回</a>
				</div>
			</div>
		</div>
	</div>
</div>
</body>
</html>