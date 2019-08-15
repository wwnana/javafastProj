<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>审批流程查看</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">		
	</script>
</head>
<body class="gray-bg">
<div class="wrapper-content">
<div class="ibox">
	<div class="ibox-title">
		<h5>审批详情</h5>
	</div>
	<div class="ibox-content">
		<sys:message content="${message}"/>
		<form:form id="inputForm" modelAttribute="oaCommonAudit" action="${ctx}/oa/oaCommonAudit/audit" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		
			<h4 class="page-header">基本信息</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">审批类型：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
								${fns:getDictLabel(oaCommonAudit.type, 'common_audit_type', '')}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">申请部门：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
								${oaCommonAudit.office.name}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">申请人：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
								${oaCommonAudit.createBy.name}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">申请时间：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
								<fmt:formatDate value="${oaCommonAudit.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="view-group">
						<label class="col-sm-2 control-label">标题：</label>
						<div class="col-sm-10">
							<p class="form-control-static">
								${oaCommonAudit.title}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="view-group">
						<label class="col-sm-2 control-label">内容：</label>
						<div class="col-sm-10">
							<p class="form-control-static">
								${oaCommonAudit.content}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="view-group">
						<label class="col-sm-2 control-label">附件：</label>
						<div class="col-sm-10">
							<p class="form-control-static">
								<form:hidden id="files" path="files" htmlEscape="false" maxlength="255" class="form-control"/>
						<sys:ckfinder input="files" type="files" uploadPath="/file" selectMultiple="true" readonly="true" />
							</p>
						</div>
					</div>
				</div>
			</div>
			
			
			
			<c:if test="${oaCommonAudit.type == 1}">
			<h4 class="page-header">请假信息</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">开始时间：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
								<fmt:formatDate value="${oaCommonLeave.startTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">结束时间：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
								<fmt:formatDate value="${oaCommonLeave.endTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">请假类型：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
								${fns:getDictLabel(oaCommonLeave.leaveType, 'leave_type', '')}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">请假时长(天)：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
								${oaCommonLeave.daysNum}
							</p>
						</div>
					</div>
				</div>
			</div>
			</c:if>
			<c:if test="${oaCommonAudit.type == 2}">
			<h4 class="page-header">报销信息</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">报销总额：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
								${oaCommonExpense.amount}
							</p>
						</div>
					</div>
				</div>
				
			</div>
							<table id="contentTable" class="table table-striped table-bordered table-hover table-condensed">
								<thead>
									<tr>
										<th>报销事项</th>
										<th>日期</th>
										<th>报销金额（元）</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach items="${oaCommonExpense.oaCommonExpenseDetailList}" var="oaCommonExpenseDetail">
										<tr>
													<td>
														${oaCommonExpenseDetail.itemName}
													</td>
													<td>
														<fmt:formatDate value="${oaCommonExpenseDetail.date}" pattern="yyyy-MM-dd"/>
													</td>
													<td>
														${oaCommonExpenseDetail.amount}
													</td>
										</tr>
									</c:forEach>
								</tbody>
							</table>	
					
			</c:if>
			<c:if test="${oaCommonAudit.type == 3}">
			<h4 class="page-header">差旅信息</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">出发地：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
								${oaCommonTravel.startAddress}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">出差城市：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
								${oaCommonTravel.destAddress}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">开始时间：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
								<fmt:formatDate value="${oaCommonTravel.startTime}" pattern="yyyy-MM-dd"/>
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">结束时间：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
								<fmt:formatDate value="${oaCommonTravel.endTime}" pattern="yyyy-MM-dd"/>
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">预算金额：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
								${oaCommonTravel.budgetAmt}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">预支金额：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
								${oaCommonTravel.advanceAmt}
							</p>
						</div>
					</div>
				</div>
			</div>
			</c:if>
			<c:if test="${oaCommonAudit.type == 4}">
			<h4 class="page-header">借款信息</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">借款总额：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
								${oaCommonBorrow.amount}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">借款时间：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
								<fmt:formatDate value="${oaCommonBorrow.borrowDate}" pattern="yyyy-MM-dd"/>
							</p>
						</div>
					</div>
				</div>
			</div>
			</c:if>
			<c:if test="${oaCommonAudit.type == 5}">
			<h4 class="page-header">加班信息</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">开始时间：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
								<fmt:formatDate value="${oaCommonExtra.startTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">结束时间：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
								<fmt:formatDate value="${oaCommonExtra.endTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">加班类型：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
								${fns:getDictLabel(oaCommonExtra.extraType, 'extra_type', '')}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">加班时长(天)：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
								${oaCommonExtra.daysNum}
							</p>
						</div>
					</div>
				</div>
			</div>
			</c:if>
			
			<h4 class="page-header">审批状态</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">状态：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
								${fns:getDictLabel(oaCommonAudit.status, 'common_audit_status', '')}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">下一审批人：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
								${oaCommonAudit.currentBy.name}
							</p>
						</div>
					</div>
				</div>
			</div>
			
			<c:if test="${fns:getUser().id == oaCommonAudit.currentBy.id && oaCommonAudit.status == 1}">
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 审批：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
								<input type="radio" name="auditStatus" value="2" class="i-checks" checked="checked">同意 
								<input type="radio" name="auditStatus" value="3" class="i-checks">拒绝
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">意见(非必填)：</label>
						<div class="col-sm-8">
							<textarea id="auditNote" name="auditNote" rows="" cols="2" class="form-control" maxlength="200"></textarea>
						</div>
					</div>
				</div>
			</div>
			</c:if>	
			
			<div class="hr-line-dashed"></div>
			<div class="form-actions">
				<div class="col-sm-4 col-sm-offset-2">
					<c:if test="${fns:getUser().id == oaCommonAudit.currentBy.id && oaCommonAudit.status == 1}">
						<input id="btnSubmit" class="btn btn-success" type="submit" value="提 交"/>&nbsp;
					</c:if>
					<input id="btnCancel" class="btn btn-white" type="button" value="返 回" onclick="history.go(-1)"/>
				</div>
			</div>
			<br><br><br>
		</form:form>
	</div>
</div>
		
		<!-- 明细 -->
		<div class="tabs-container">
	    	<ul class="nav nav-tabs">
				<li class="active"><a data-toggle="tab" href="#tab-1" aria-expanded="true">审批记录</a></li>
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
								<th>阅读标记</th>
								<th>阅读时间</th>
								<th>审批结果</th>
								<th>审批时间</th>
								<th>审批意见</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach items="${oaCommonAudit.oaCommonAuditRecordList}" var="oaCommonAuditRecord">
								<tr>
											<td>
												${oaCommonAuditRecord.auditOrder}
											</td>
											<td>
												${fns:getDictLabel(oaCommonAuditRecord.dealType, 'audit_deal_type', '')}
											</td>
											<td>
												${oaCommonAuditRecord.user.name}
											</td>
											<td>
												${fns:getDictLabel(oaCommonAuditRecord.readFlag, 'oa_notify_read', '')}
											</td>
											<td>
												<fmt:formatDate value="${oaCommonAuditRecord.readDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
											</td>
											<td>
												${fns:getDictLabel(oaCommonAuditRecord.auditStatus, 'common_audit_status', '')}
											</td>
											<td>
												<fmt:formatDate value="${oaCommonAuditRecord.auditDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
											</td>
											<td>
												${oaCommonAuditRecord.auditNotes}
											</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>					
					</div>
				</div>
			</div>
		</div>
</div>
</body>
</html>