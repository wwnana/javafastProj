<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>打卡规则查看</title>
	<meta name="decorator" content="default"/>
</head>
<body class="gray-bg">
<div class="wrapper-content">
	<div class="ibox">
		<div class="ibox-title">
			<h5>打卡规则查看</h5>
		</div>
		<div class="ibox-content">
			<sys:message content="${message}"/>
			<form:form id="inputForm" modelAttribute="hrCheckRule" action="${ctx}/hr/hrCheckRule/save" method="post" class="form-horizontal">
				<form:hidden path="id"/>
				<h4 class="page-header">基本信息</h4>
				<div class="row">
					<div class="col-sm-12">
						<div class="view-group">
							<label class="col-sm-2 control-label">规则名称：</label>
							<div class="col-sm-10">
								<p class="form-control-static">
										${hrCheckRule.groupname}
								</p>
							</div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-sm-12">
						<div class="view-group">
							<label class="col-sm-2 control-label">打卡规则类型：</label>
							<div class="col-sm-10">
								<p class="form-control-static">
										${fns:getDictLabel(hrCheckRule.groupType, '', '')}
								</p>
							</div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-sm-12">
						<div class="view-group">
							<label class="col-sm-2 control-label">打卡规则id：</label>
							<div class="col-sm-10">
								<p class="form-control-static">
										${hrCheckRule.groupId}
								</p>
							</div>
						</div>
					</div>
				</div>

				<h4 class="page-header">岗位要求</h4>
				<div class="row">
					<div class="col-sm-6">
						<div class="view-group">
							<label class="col-sm-4 control-label">弹性时间：</label>
							<div class="col-sm-8">
								<p class="form-control-static">
										${hrCheckRule.flexTime}
								</p>
							</div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-sm-6">
						<div class="view-group">
							<label class="col-sm-4 control-label">下班不需要打卡：</label>
							<div class="col-sm-8">
								<p class="form-control-static">
										${hrCheckRule.noneedOffwork}
								</p>
							</div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-sm-6">
						<div class="view-group">
							<label class="col-sm-4 control-label">打卡时间限制：</label>
							<div class="col-sm-8">
								<p class="form-control-static">
										${hrCheckRule.limitAheadtime}
								</p>
							</div>
						</div>
					</div>
					<div class="col-sm-6">
						<div class="view-group">
							<label class="col-sm-4 control-label">打卡时间：</label>
							<div class="col-sm-8">
								<p class="form-control-static">
										${hrCheckRule.checkintime}
								</p>
							</div>
						</div>
					</div>
				</div>
				<h4 class="page-header">不需要打卡的时间</h4>
				<div class="row">
					<div class="col-sm-6">
						<div class="view-group">
							<label class="col-sm-4 control-label">进度：</label>
							<div class="col-sm-8">
								<p class="form-control-static">
										${hrCheckRule.speOffdays}
								</p>
							</div>
						</div>
					</div>
					<div class="col-sm-6">
						<div class="view-group">
							<label class="col-sm-4 control-label">同步节假日：</label>
							<div class="col-sm-8">
								<p class="form-control-static">
										${hrCheckRule.syncHolidays}
								</p>
							</div>
						</div>
					</div>

				</div>
				<div class="row">
					<div class="col-sm-6">
						<div class="view-group">
							<label class="col-sm-4 control-label">拍照打卡：</label>
							<div class="col-sm-8">
								<p class="form-control-static">
										${hrCheckRule.needPhoto}
								</p>
							</div>
						</div>
					</div>

				</div>
				<div class="row">
					<div class="col-sm-6">
						<div class="view-group">
							<label class="col-sm-4 control-label">是否备注时允许上传本地图片：</label>
							<div class="col-sm-8">
								<p class="form-control-static">
										${hrCheckRule.noteCanUseLocalPic}
								</p>
							</div>
						</div>
					</div>
					<div class="col-sm-6">
						<div class="view-group">
							<label class="col-sm-4 control-label">是否非工作日允许打卡：</label>
							<div class="col-sm-8">
								<p class="form-control-static">
										${hrCheckRule.allowCheckinOffworkday}
								</p>
							</div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-sm-6">
						<div class="view-group">
							<label class="col-sm-4 control-label">补卡申请：</label>
							<div class="col-sm-8">
								<p class="form-control-static">
										${hrCheckRule.allowApplyOffworkday}
								</p>
							</div>
						</div>
					</div>
				</div>
				<h4 class="page-header">WIFI信息</h4>
				<div class="row">
					<div class="col-sm-6">
						<div class="view-group">
							<label class="col-sm-4 control-label">：</label>
							<div class="col-sm-8">
								<p class="form-control-static">
										${hrCheckRule.wifimacInfos}
								</p>
							</div>
						</div>
					</div>
				</div>
				<h4 class="page-header">位置打卡地点信息</h4>
				<div class="row">
					<div class="col-sm-6">
						<div class="view-group">
							<label class="col-sm-4 control-label">创建者：</label>
							<div class="col-sm-8">
								<p class="form-control-static">
										${hrCheckRule.locInfos}
								</p>
							</div>
						</div>
					</div>
				</div>

				<div class="hr-line-dashed"></div>
				<div class="form-actions">

					<a id="btnCancel" class="btn btn-white" onclick="history.go(-1)">返回</a>
				</div>
			</form:form>
		</div>
	</div>
</div>
</body>
</html>