<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>跟进记录管理</title>
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
				<h5>跟进记录列表 </h5>
			</div>
			<div class="ibox-content">
			<sys:message content="${message}"/>
				
				
				<!-- 工具栏 -->
				<div class="row">
					<div class="col-sm-12">
						<div class="pull-left">
							<shiro:hasPermission name="crm:crmCustomer:add">
								<a href="${ctx}/crm/crmContactRecord/form?customer.id=${crmContactRecord.customer.id}" title="新增跟进记录" class="btn btn-white btn-sm" target="_parent"><i class="fa fa-plus"></i> 新增跟进记录</a>
								<a href="${ctx}/crm/crmContactRecord/nextContactForm?id=${crmContactRecord.customer.id}" title="下次跟进提醒设置" class="btn btn-white btn-sm" target="_parent"><i class="fa fa-plus"></i> 下次跟进提醒设置</a>
							</shiro:hasPermission>
							
						</div>
						
					</div>
				</div>
				<br>	
				<!-- 表格 -->
				<c:forEach items="${list}" var="crmContactRecord">
				<div class="feed-element">
                   <a href="profile.html#" class="pull-left">
                       <img alt="${crmContactRecord.createBy.name}" class="img-circle" src="${crmContactRecord.createBy.photo}">
                   </a>
                   <div class="media-body ">
                       <small class="pull-right"><label class="badge <c:if test='${crmContactRecord.status == 2}'>badge-primary</c:if> <c:if test='${crmContactRecord.status != 2}'>badge-danger</c:if>">${fns:getDictLabel(crmContactRecord.status, 'finish_status', '')}</label></small>
                       <strong>跟进日期：<fmt:formatDate value="${crmContactRecord.contactDate}" pattern="yyyy-MM-dd"/>， 跟进主题：${fns:getDictLabel(crmContactRecord.contactType, 'contact_type', '')}， 联系人：${crmContactRecord.contacter.name}</strong> 
                       <br>
                       
                       <div class="well">
                           	<a href="#" onclick="openDialogView('查看跟进记录', '${ctx}/crm/crmContactRecord/view?id=${crmContactRecord.id}','800px', '500px')" title="查看">
										${crmContactRecord.content}
									</a>
                       </div>
                       <small class="text-muted"><i class="fa fa-user"></i> ${crmContactRecord.createBy.name} <i class="fa fa-clock-o"></i> <fmt:formatDate value="${crmContactRecord.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/> </small>
                       <div class="pull-right">
                           <%-- 
                           <a class="btn btn-xs btn-white"><i class="fa fa-thumbs-up"></i> 赞 </a>
                           <a class="btn btn-xs btn-white"><i class="fa fa-heart"></i> 收藏</a>
                           <a class="btn btn-xs btn-success"><i class="fa fa-pencil"></i> 评论</a>
                           --%>
                           <c:if test="${fns:getUser().id == crmContactRecord.createBy.id || fns:getUser().id == crmContactRecord.createBy.id}">
                           		<a href="${ctx}/crm/crmContactRecord/form?id=${crmContactRecord.id}" class="btn btn-success btn-xs" title="修改" target="_parent"><i class="fa fa-edit"></i> </a>
								<a href="${ctx}/crm/crmContactRecord/indexDelete?id=${crmContactRecord.id}" onclick="return confirmx('确认要删除该跟进记录吗？', this.href)" class="btn  btn-danger btn-xs" title="删除"><i class="fa fa-trash"></i> </a> 
                           </c:if>
                       </div>
                   </div>
               </div>
               <div class="hr-line-dashed"></div>
               </c:forEach>
               
               
                                                    
				<div class="table-responsive  hide">
				<table id="contentTable" class="table table-bordered table-striped table-hover">
					<thead>
						<tr>
							<%-- <th><input type="checkbox" class="i-checks"></th>--%>
							
							<th>跟进日期</th>
							<th>跟进主题</th>
							<th width="30%">跟进内容</th>
							<th>负责人</th>
							<th>创建者</th>
							<th>创建时间</th>
							<th class="sort-column a.status">完成状态</th>
							<th>完成时间</th>
							<th width="100px">操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${list}" var="crmContactRecord">
						<tr>
							<td colspan="8">
								<c:if test="${crmContactRecord.status != 2}">
									<a href="${ctx}/crm/crmContactRecord/form?id=${crmContactRecord.id}" title="跟进">
										${crmContactRecord.content}
									</a>
								</c:if>
								<c:if test="${crmContactRecord.status == 2}">
									<a href="#" onclick="openDialogView('查看跟进记录', '${ctx}/crm/crmContactRecord/view?id=${crmContactRecord.id}','800px', '500px')" title="查看">
										${crmContactRecord.content}
									</a>
								</c:if>
							</td>
						</tr>
						<tr>
							<%-- <td><input type="checkbox" id="${crmContactRecord.id}" class="i-checks"></td>--%>
							
							<td>
								<fmt:formatDate value="${crmContactRecord.contactDate}" pattern="yyyy-MM-dd"/>
							</td>
							<td>
								${fns:getDictLabel(crmContactRecord.contactType, 'contact_type', '')}
							</td>
							<td>
								
								<c:if test="${fns:getUser().id == crmContactRecord.createBy.id && crmContactRecord.status != 2}">
									<a href="${ctx}/crm/crmContactRecord/form?id=${crmContactRecord.id}" title="跟进">
										${crmContactRecord.content}
									</a>
								</c:if>
								<c:if test="${fns:getUser().id != crmContactRecord.createBy.id || crmContactRecord.status == 2}">
									<a href="#" onclick="openDialogView('查看跟进记录', '${ctx}/crm/crmContactRecord/view?id=${crmContactRecord.id}','800px', '500px')" title="查看">
										${crmContactRecord.content}
									</a>
								</c:if>
							</td>
							<td>
								${crmContactRecord.createBy.name}
							</td>
							<td>
								${crmContactRecord.createBy.name}
							</td>
							<td>
								<fmt:formatDate value="${crmContactRecord.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</td>
							<td>
								 <label class="badge <c:if test='${crmContactRecord.status == 2}'>badge-primary</c:if> <c:if test='${crmContactRecord.status != 2}'>badge-danger</c:if>">${fns:getDictLabel(crmContactRecord.status, 'finish_status', '')}</label>
							</td>
							<td>
								<fmt:formatDate value="${crmContactRecord.updateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</td>
							<td>
								<c:if test="${fns:getUser().id == crmContactRecord.createBy.id || fns:getUser().id == crmContactRecord.createBy.id}">
			    					<a href="${ctx}/crm/crmContactRecord/form?id=${crmContactRecord.id}" class="btn btn-success btn-xs" title="修改" target="_parent"><i class="fa fa-edit"></i> </a>
									<a href="${ctx}/crm/crmContactRecord/indexDelete?id=${crmContactRecord.id}" onclick="return confirmx('确认要删除该跟进记录吗？', this.href)" class="btn  btn-danger btn-xs" title="删除"><i class="fa fa-trash"></i> </a> 
								</c:if>
							</td>
						</tr>
					</c:forEach>
					</tbody>
				</table>
				</div>
			</div>
		</div>
	</div>
</body>
</html>