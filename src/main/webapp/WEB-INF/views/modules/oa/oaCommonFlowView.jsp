<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>流程配置查看</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">		
	</script>
</head>
<body class="gray-bg">
<div class=" ">
<div class="">

	<div class="ibox-content">
	<sys:message content="${message}"/>
	
	<form:form id="inputForm" modelAttribute="oaCommonFlow" action="${ctx}/oa/oaCommonFlow/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
	 <table class="table table-bordered table-condensed dataTables-example dataTable no-footer">
		<tbody>
			<tr>
					<td class="width-15 active"><label class="pull-right">审批类型：</label></td>
					<td class="width-35">
						${fns:getDictLabel(oaCommonFlow.type, 'common_audit_type', '')}
					</td>
				</tr>
				<tr> 
					<td class="width-15 active"><label class="pull-right">流程名称：</label></td>
					<td class="width-35">
						${oaCommonFlow.title}
					</td>
				</tr>
				<tr> 	
					<td class="width-15 active"><label class="pull-right">备注信息：</label></td>
					<td class="width-35">
						${oaCommonFlow.remarks}
					</td>
				</tr>
				<tr> 
				</tr>
			</tbody>
		</table>
		<!-- 明细 -->
		<div class="tabs-container">
	    	<ul class="nav nav-tabs">
				<li class="active"><a data-toggle="tab" href="#tab-1" aria-expanded="true">流程执行</a></li>
	    	</ul>
          	<div class="tab-content">
          	   	<div class="panel-body">
					<div id="tab-1" class="tab-pane table-responsive active">
					<table id="contentTable" class="table table-striped table-bordered table-hover table-condensed">
						<thead>
							<tr>
								<th>执行顺序</th>
								<th>执行类型</th>
								<th>执行人</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach items="${oaCommonFlow.oaCommonFlowDetailList}" var="oaCommonFlowDetail">
								<tr>
											<td>
												${oaCommonFlowDetail.sort}
											</td>
											<td>
												${fns:getDictLabel(oaCommonFlowDetail.dealType, 'audit_deal_type', '')}
											</td>
											<td>
												${oaCommonFlowDetail.user.name}
											</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>					
					</div>
				</div>
			</div>
		</div>
		
	</form:form>
	</div>
</div>
</div>
</body>
</html>