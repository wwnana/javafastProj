<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>员工信息查看</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
			comWorkAge();
		});
		//计算工龄
		function comWorkAge(){			
	        var firstWorkDate = '${hrEmployee.firstWorkDate}';
	        if(firstWorkDate != null && firstWorkDate != ""){
	        	var endTime = new Date(Date.parse(firstWorkDate)).getTime();    
	            var startTime = new Date().getTime();
	            var dates = Math.abs((startTime - endTime))/(1000*60*60*24*365); 
	            $("#workAge").html(dates.toFixed(2));
	        }            
		}
	</script>
</head>
<body class="gray-bg">
	<div class="wrapper-content">
		<div class="ibox">
			<div class="tabs-container">
			 	<ul class="nav nav-tabs">
			 		<li class="active"><a data-toggle="tab" href="#tab-1" aria-expanded="true">基本信息</a></li>
			 		<li><a data-toggle="tab" href="#tab-2" aria-expanded="false">岗位信息</a></li>
			 	</ul>
			 	<div class="tab-content">
			 		<div id="tab-1" class="tab-pane active">
			 			<div class="ibox-content">
			 				<div class="form-horizontal">
				 				<h4 class="page-header">基本信息</h4>
								<div class="row">
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">姓名：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												${hrEmployee.name}
												</p>
											</div>
										</div>
									</div>
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label"> 英文名：</label>
											<div class="col-sm-8">
												<p class="form-control-static">${hrEmployee.enName}</p>
											</div>
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">性别：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												${fns:getDictLabel(hrEmployee.sex, 'sex', '')}
												</p>
											</div>
										</div>
									</div>
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">出生日期：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												<fmt:formatDate value="${hrEmployee.birthDate}" pattern="yyyy-MM-dd"/>
												</p>
											</div>
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">身份证号：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												${hrEmployee.idCard}
												</p>
											</div>
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">身份证照：</label>
											<div class="col-sm-8">
													<input type="hidden" id="idCardImg" value="${hrEmployee.idCardImg}"/>
													<sys:ckfinder input="idCardImg" type="images" uploadPath="/image" readonly="true"/>
											</div>
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">籍贯：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												${hrEmployee.nativePlace}
												</p>
											</div>
										</div>
									</div>
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">民族：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												${hrEmployee.nation}
												</p>
											</div>
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">户籍所在地：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												${hrEmployee.registration}
												</p>
											</div>
										</div>
									</div>
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">政治面貌：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												${hrEmployee.political}
												</p>
											</div>
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">生日：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												${hrEmployee.birthday}
												</p>
											</div>
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">婚姻状况：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												${fns:getDictLabel(hrEmployee.maritalStatus, 'marital_status', '')}
												</p>
											</div>
										</div>
									</div>
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">子女状态：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												${hrEmployee.children}
												</p>
											</div>
										</div>
									</div>
								</div>
								<h4 class="page-header">通讯信息</h4>
								<div class="row">
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">联系手机：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												${hrEmployee.mobile}
												</p>
											</div>
										</div>
									</div>
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">个人邮箱：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												${hrEmployee.email}
												</p>
											</div>
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">QQ：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												${hrEmployee.qq}
												</p>
											</div>
										</div>
									</div>
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">微信：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												${hrEmployee.wx}
												</p>
											</div>
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">居住城市：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												${hrEmployee.city}
												</p>
											</div>
										</div>
									</div>
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">通讯地址：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												${hrEmployee.address}
												</p>
											</div>
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">紧急联系人：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												${hrEmployee.contactPeople}
												</p>
											</div>
										</div>
									</div>
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">紧急联系电话：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												${hrEmployee.contactPhone}
												</p>
											</div>
										</div>
									</div>
								</div>
								<h4 class="page-header">账号信息</h4>
								<div class="row">
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">社保电脑号：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												${hrEmployee.socialSecurityNo}
												</p>
											</div>
										</div>
									</div>
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">公积金账号：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												${hrEmployee.accumulationNo}
												</p>
											</div>
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">银行卡号：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												${hrEmployee.bankCardNo}
												</p>
											</div>
										</div>
									</div>
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">开户行：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												${hrEmployee.bankCardName}
												</p>
											</div>
										</div>
									</div>
								</div>
								<h4 class="page-header">教育信息</h4>
								<div class="row">
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">毕业学校：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												${hrEmployee.graduateSchool}
												</p>
											</div>
										</div>
									</div>
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">专业：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												${hrEmployee.specialty}
												</p>
											</div>
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">入学时间：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												${hrEmployee.schoolStart}
												</p>
											</div>
										</div>
									</div>
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">毕业时间：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												${hrEmployee.schoolEnd}
												</p>
											</div>
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">最高学历：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												${fns:getDictLabel(hrEmployee.educationType, 'education_type', '')}
												</p>
											</div>
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">毕业证书：</label>
											<div class="col-sm-8">
													<input type="hidden" id="certificateImg" name="certificateImg" htmlEscape="false" maxlength="255" value="${hrEmployee.certificateImg}"/>
													<sys:ckfinder input="certificateImg" type="images" uploadPath="/image" selectMultiple="false" readonly="true"/>
											</div>
										</div>
									</div>
								</div>
								<h4 class="page-header">从业信息</h4>
								<div class="row">
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">上家公司：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												${hrEmployee.lastCompany}
												</p>
											</div>
										</div>
									</div>
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">上家公司职位：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												${hrEmployee.lastPosition}
												</p>
											</div>
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">前公司离职证明：</label>
											<div class="col-sm-8">
													<input type="hidden" id="leavingCertify" name="leavingCertify" htmlEscape="false" maxlength="255" value="${hrEmployee.leavingCertify}"/>
													<sys:ckfinder input="leavingCertify" type="images" uploadPath="/image" selectMultiple="false" readonly="true"/>
											</div>
										</div>
									</div>
								</div>
								
								<h4 class="page-header">备注信息</h4>
								<div class="row">
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">备注：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												${hrEmployee.remarks}
												</p>
											</div>
										</div>
									</div>
								</div>
							</div>
			 			</div>
			 		</div>
			 		<div id="tab-2" class="tab-pane">
			 			<div class="ibox-content">
			 				<div class="form-horizontal">
			 					<h4 class="page-header">岗位信息</h4>
								<div class="row">
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">入职日期：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												<fmt:formatDate value="${hrEmployee.entryDate}" pattern="yyyy-MM-dd"/>
												</p>
											</div>
										</div>
									</div>
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">当前职位：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												${hrEmployee.position}
												</p>
											</div>
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">转正日期：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												<fmt:formatDate value="${hrEmployee.regularDate}" pattern="yyyy-MM-dd"/>
												</p>
											</div>
										</div>
									</div>
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">转正状态：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												${fns:getDictLabel(hrEmployee.regularStatus, 'regular_status', '')}
												</p>
											</div>
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">聘用形式：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												${fns:getDictLabel(hrEmployee.employType, 'employ_type', '')}
												</p>
											</div>
										</div>
									</div>
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">工作地点：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												${hrEmployee.workAddress}
												</p>
											</div>
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">首次参加工作时间：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												<fmt:formatDate value="${hrEmployee.firstWorkDate}" pattern="yyyy-MM-dd"/>
												</p>
											</div>
										</div>
									</div>
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">工龄：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
													<span id="workAge"></span>
												</p>
											</div>
										</div>
									</div>
								</div>
								<h4 class="page-header">合同信息</h4>
								<div class="row">
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">现合同开始时间：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												<fmt:formatDate value="${hrEmployee.contractStartDate}" pattern="yyyy-MM-dd"/>
												</p>
											</div>
										</div>
									</div>
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">现合同结束时间：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												<fmt:formatDate value="${hrEmployee.contractEndDate}" pattern="yyyy-MM-dd"/>
												</p>
											</div>
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">合同文件：</label>
											<div class="col-sm-8">
													<input type="hidden" id="contractFile" name="contractFile" htmlEscape="false" maxlength="255" value="${hrEmployee.contractFile}"/>
													<sys:ckfinder input="contractFile" type="files" uploadPath="/file" selectMultiple="false" readonly="true"/>
											</div>
										</div>
									</div>
								</div>
								<h4 class="page-header">招聘信息</h4>
								<div class="row">
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">招聘渠道：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												${fns:getDictLabel(hrEmployee.recruitSource, 'resume_source', '')}
												</p>
											</div>
										</div>
									</div>
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">推荐企业/人：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												${hrEmployee.recommend}
												</p>
											</div>
										</div>
									</div>
								</div>
								
							</div>
			 			</div>
			 		</div>
			 		<div id="tab-3" class="tab-pane">
			 			<div class="ibox-content">
			 				
			 			</div>
			 		</div>
			 	</div>
			</div>
	</div>
</div>
</body>
</html>