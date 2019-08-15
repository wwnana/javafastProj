<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>日程管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
		});
		//0:隐藏tip, 1隐藏box,不设置显示全部
		top.$.jBox.closeTip();
	</script>
</head>
<body class="gray-bg">
<div class="">
		<div class="ibox">
			<div class="ibox-title">
				<h5>日程列表 </h5>
			</div>
			<div class="ibox-content">
			<sys:message content="${message}"/>
				
				
				<!-- 工具栏 -->
				<div class="row">
					<div class="col-sm-12 m-b-sm">
						<div class="pull-left">
						<table:addRow url="${ctx}/iim/myCalendar/form?customerId=${crmCustomer.id}&title=${crmCustomer.name}&adllDay=1" title="日程"></table:addRow><!-- 增加按钮 -->
					       <button class="btn btn-white btn-sm " data-toggle="tooltip" data-placement="left" onclick="sortOrRefresh()" title="刷新"><i class="glyphicon glyphicon-repeat"></i> 刷新</button>
						
						</div>
						<div class="pull-right">
							<button  class="btn btn-success btn-rounded btn-outline btn-sm " onclick="search()" ><i class="fa fa-search"></i> 查询</button>
							<button  class="btn btn-success btn-rounded btn-outline btn-sm " onclick="resetSearch()" ><i class="fa fa-refresh"></i> 重置</button>
						</div>
					</div>
				</div>
					
				<!-- 表格 -->
				<div class="table-responsive">
				<table id="contentTable" class="table table-bordered table-striped table-hover">
					<thead>
						<tr>
							
							<th>内容</th>
							<th>开始时间</th>
							<th>结束时间</th>
							<th width="250px">操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="myCalendar">
						<tr>
							
							<td>
								${myCalendar.title}
							</td>
							<td>
								${myCalendar.start}
							</td>
							<td>
								${myCalendar.end}
							</td>
							
							<td>
								 
								
								
			    					<a href="#" onclick="openDialog('修改日程', '${ctx}/iim/myCalendar/form?id=${myCalendar.id}','800px', '500px')" class="btn btn-success btn-xs" title="修改"><i class="fa fa-edit"></i> 修改</a>
								
									<a href="${ctx}/iim/myCalendar/delete?id=${myCalendar.id}" onclick="return confirmx('确认要删除该日程吗？', this.href)" class="btn  btn-danger btn-xs" title="删除"><i class="fa fa-trash"></i> 删除</a> 
								
								
							</td>
						</tr>
					</c:forEach>
					</tbody>
				</table>
				<table:page page="${page}"></table:page>
				</div>
			</div>
		</div>
	</div>
</body>
</html>