<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>审批记录查看</title>
	<meta name="decorator" content="default"/>
</head>
<body class="hideScroll">
	<div class="ibox-content">
		<sys:message content="${message}"/>
		<form:form id="inputForm" modelAttribute="hrApproval" action="${ctx}/hr/hrApproval/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">审批单号：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrApproval.spNum}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">提交时间：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							<fmt:formatDate value="${hrApproval.applyTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">审批名称：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrApproval.name}
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
							${hrApproval.applyName}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">申请人部门：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrApproval.applyOrg}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">审批人姓名：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrApproval.approvalName}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">抄送人姓名：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrApproval.notifyName}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">审批状态：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
								<c:if test="${hrApproval.spStatus==1}">审批中</c:if>
								<c:if test="${hrApproval.spStatus==2}">已通过</c:if>
								<c:if test="${hrApproval.spStatus==3}">已驳回</c:if>
								<c:if test="${hrApproval.spStatus==4}">已取消</c:if>
								<c:if test="${hrApproval.spStatus==6}">通过后撤销</c:if>
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">审批类型：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
								<c:if test="${hrApproval.approvalType==1}">请假</c:if>
								<c:if test="${hrApproval.approvalType==2}">报销</c:if>
								<c:if test="${hrApproval.approvalType==3}">费用</c:if>
								<c:if test="${hrApproval.approvalType==4}">出差</c:if>
								<c:if test="${hrApproval.approvalType==5}">采购</c:if>
								<c:if test="${hrApproval.approvalType==6}">加班</c:if>
								<c:if test="${hrApproval.approvalType==7}">外出</c:if>
								<c:if test="${hrApproval.approvalType==8}">用章</c:if>
								<c:if test="${hrApproval.approvalType==9}">付款</c:if>
								<c:if test="${hrApproval.approvalType==10}">用车</c:if>
								<c:if test="${hrApproval.approvalType==11}">绩效</c:if>
								<c:if test="${hrApproval.approvalType==20}">打卡补卡 </c:if>
							</p>
						</div>
					</div>
				</div>
			</div>
			<c:if test="${hrApproval.approvalType==2}">
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">报销类型：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrApproval.expenseType}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">报销事由：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrApproval.expenseReason}
							</p>
						</div>
					</div>
				</div>
			</div>
			</c:if>
			<c:if test="${hrApproval.approvalType==1}">
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">请假类型：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
								<c:if test="${hrApproval.leaveType==1}">年假</c:if>
								<c:if test="${hrApproval.leaveType==2}">事假</c:if>
								<c:if test="${hrApproval.leaveType==3}">病假</c:if>
								<c:if test="${hrApproval.leaveType==4}">调休假</c:if>
								<c:if test="${hrApproval.leaveType==5}">婚假</c:if>
								<c:if test="${hrApproval.leaveType==6}">产假</c:if>
								<c:if test="${hrApproval.leaveType==7}">陪产假</c:if>
								<c:if test="${hrApproval.leaveType==8}">其他</c:if>
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">请假开始时间：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							<fmt:formatDate value="${hrApproval.leaveStartTime}" pattern="yyyy-MM-dd"/>
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">请假结束时间：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							<fmt:formatDate value="${hrApproval.leaveEndTime}" pattern="yyyy-MM-dd"/>
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">请假时长：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrApproval.leaveDuration/24}天
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">请假事由：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrApproval.leaveReason}
							</p>
						</div>
					</div>
				</div>
			</div>
			</c:if>
			<c:if test="${fns:getUser().accountId == 0}">
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">申请单数据：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${hrApproval.applyData}
							</p>
						</div>
					</div>
				</div>
			</div>
			</c:if>
			<%-- 
			审批类型   1请假、2报销、3费用、4出差、5采购、6加班、7外出、8用章、9付款、10用车、11绩效、20打卡补卡 
			--%>
			<c:if test="${hrApproval.approvalType==1 || hrApproval.approvalType==4 || hrApproval.approvalType==6 || hrApproval.approvalType==7}">
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">开始时间：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							<fmt:formatDate value="${hrApproval.beginTime}" pattern="yyyy-MM-dd HH:mm"/>
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">结束时间：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							<fmt:formatDate value="${hrApproval.endTime}" pattern="yyyy-MM-dd HH:mm"/>
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">时长：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							
							<fmt:formatNumber type="number" value="${hrApproval.duration/3600/24}" pattern="0.0" maxFractionDigits="1"/> 天
							</p>
						</div>
					</div>
				</div>
			</div>
			</c:if>
			<c:if test="${hrApproval.approvalType==20}">
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">补卡时间：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							<fmt:formatDate value="${hrApproval.bkCheckinTime}" pattern="yyyy-MM-dd HH:mm"/>
							</p>
						</div>
					</div>
				</div>
			</div>
			</c:if>
		</form:form>
	</div>
</body>
</html>