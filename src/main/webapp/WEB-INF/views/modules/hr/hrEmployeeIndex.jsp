<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>员工查看</title>
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
	<div class="row border-bottom white-bg dashboard-header">
        <div class="col-sm-11">
        	<div class="text-center">
        		<span class="index-title">${hrEmployee.name} - ${user.office.name }</span>
        	</div>
        </div>
        <div class="col-sm-1">
        	<div class="pull-right">
        		<a href="${ctx}/hr/hrEmployee/index?id=${hrEmployee.id}" class="btn btn-white btn-sm">刷新</a>
        	</div>
        </div>
        <br><br>
    </div>
    <sys:message content="${message}"/>
<div class="wrapper-content pb80">
	<div class="row">
		<div class="col-sm-9">
			<div class="ibox float-e-margins">
				
                <div class="panel-body">
                	
                	<div class="row">
			            <div class="col-sm-12">
							<div class="col-sm-2 text-center">
								<button class="btn btn-success btn-circle btn-lg pull-right" style="width: 100px;height: 100px;border-radius: 50px;font-size: 50px;" type="button">
									${fn:substring(hrEmployee.name, 0, 1)}
			                          </button>
			                  	</div>
							<div class="col-sm-5">
								<div class="form-horizontal">
									<div class="row">
										<div class="col-sm-12">
											<div class="view-group">
												<p class="form-control-static">姓名：${hrEmployee.name}</p>
											</div>
										</div>
									</div>
									<div class="row">
										<div class="col-sm-12">
											<div class="view-group">
												<p class="form-control-static">手机：${hrEmployee.mobile}</p>
											</div>
										</div>
									</div>
									<div class="row">
										<div class="col-sm-12">
											<div class="view-group">
												<p class="form-control-static">职位：${hrEmployee.position}</p>
											</div>
										</div>
									</div>
								</div>
							</div>
							<div class="col-sm-4">
								<div class="form-horizontal">
									<div class="row">
										<div class="col-sm-12">
											<div class="view-group">
												<p class="form-control-static">性别：${fns:getDictLabel(hrEmployee.sex, 'sex', '')}</p>
											</div>
										</div>
									</div>
									<div class="row">
										<div class="col-sm-12">
											<div class="view-group">
												<p class="form-control-static">邮箱：${hrEmployee.email}</p>
											</div>
										</div>
									</div>
									<div class="row">
										<div class="col-sm-12">
											<div class="view-group">
												<p class="form-control-static">状态：${fns:getDictLabel(hrEmployee.status, 'employ_status', '')}</p>
											</div>
										</div>
									</div>
								</div>
							</div>
							<div class="col-sm-1 pull-right">
								<a href="${ctx}/hr/hrEmployee/form?id=${hrEmployee.id}" title="修改" class="btn btn-white btn-bitbucket pull-right"><i class="fa fa-edit"></i></a>
							</div>	
						</div>
		            </div>
   
                </div>
			</div>
			
			<div class="tabs-container">
			 	<ul class="nav nav-tabs">
			 		<li class="active"><a data-toggle="tab" href="#tab-1" aria-expanded="true">基本信息</a></li>
			 		<li><a data-toggle="tab" href="#tab-2" aria-expanded="false">岗位信息</a></li>
			 		<li><a data-toggle="tab" href="#tab-3" aria-expanded="false">期权信息</a></li>
			 		<c:if test="${hrEmployee.status == 1}"><li><a data-toggle="tab" href="#tab-4" aria-expanded="false">离职信息</a></li></c:if>
			 	</ul>
			 	<div class="tab-content">
			 		<div id="tab-1" class="tab-pane active">
			 			<div class="panel-body">
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
			 			<div class="panel-body">
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
			 			
			 			<div class="panel-body">
			 				<div class="row">
				 				<div class="col-sm-12 m-b-sm">
				 				<shiro:hasPermission name="hr:hrEmployee:add">
									<table:addRow url="${ctx}/hr/hrOption/form?hrEmployee.id=${hrEmployee.id}" title="期权" pageModel="page" label="添加期权"></table:addRow><!-- 增加按钮 -->
								</shiro:hasPermission>
								</div>
							</div>
							<div class="table-responsive">
			 				<table id="contentTable" class="table table-bordered table-hover">
								<thead>
									<tr>
										<th>授予日期</th>
										<th>授予数量</th>
										<th>比例</th>
										<th>轮次</th>
										<th>锁定期</th>
										<th>已成熟数量</th>
										<th>期权合同</th>
										<th>操作</th>
									</tr>
								</thead>
								<tbody>
								<c:forEach items="${hrOptionList}" var="hrOption">
									<tr>
										<td>
											<a href="${ctx}/hr/hrOption/view?id=${hrOption.id}" title="查看">
											<fmt:formatDate value="${hrOption.grantDate}" pattern="yyyy-MM-dd"/>
										</a></td>
										<td>
											${hrOption.grantNum}
										</td>
										<td>
											${hrOption.proportion}
										</td>
										<td>
											${hrOption.roundNum}
										</td>
										<td>
											${hrOption.lockPeriod}
										</td>
										<td>
											${hrOption.matureNum}
										</td>
										<td>
											${hrOption.optionFile}
										</td>
										<td>
											
											<shiro:hasPermission name="hr:hrEmployee:edit">
						    					<a href="${ctx}/hr/hrOption/form?id=${hrOption.id}" class="btn btn-white btn-sm" title="修改"><i class="fa fa-pencil"></i> 修改</a>
											</shiro:hasPermission>
											
											<shiro:hasPermission name="hr:hrEmployee:del">
												<a href="${ctx}/hr/hrOption/delete?id=${hrOption.id}" onclick="return confirmx('确认要删除该期权吗？', this.href)" class="btn btn-white btn-sm" title="删除"><i class="fa fa-trash"></i> 删除</a> 
											</shiro:hasPermission>
										</td>
									</tr>
								</c:forEach>
								</tbody>
							</table>
							</div>
			 			</div>
			 		</div>
			 		<div id="tab-4" class="tab-pane">
			 			<div class="panel-body">
			 				<div class="form-horizontal">
			 					<div class="row">
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">离职类型：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												${fns:getDictLabel(hrQuit.quitType, 'quit_type', '')}
												</p>
											</div>
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">离职时间：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												<fmt:formatDate value="${hrQuit.quitDate}" pattern="yyyy-MM-dd"/>
												</p>
											</div>
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">离职原因：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												${hrQuit.quitCause}
												</p>
											</div>
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">申请离职原因：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												${hrQuit.applyQuitCause}
												</p>
											</div>
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">补偿金：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												${hrQuit.compensation}
												</p>
											</div>
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">社保减员月：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												${fns:getDictLabel(hrQuit.socialOverMonth, 'over_month_type', '')}
												</p>
											</div>
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">公积金减员月：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												${fns:getDictLabel(hrQuit.fundOverMonth, 'over_month_type', '')}
												</p>
											</div>
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">剩余年假：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												${hrQuit.annualLeave}
												</p>
											</div>
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">剩余调休：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												${hrQuit.restLeave}
												</p>
											</div>
										</div>
									</div>
								</div>
								<h4 class="page-header">工作交接</h4>
								<div class="row">
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">工作交接内容：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												${hrQuit.workContent}
												</p>
											</div>
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">工作交接给：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												${hrQuit.workBy.name}
												</p>
											</div>
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">工作交接完成情况：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												${fns:getDictLabel(hrQuit.workStatus, 'finish_status', '')}
												</p>
											</div>
										</div>
									</div>
								</div>
								<h4 class="page-header">操作信息</h4>
								<div class="row">
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">状态：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												${fns:getDictLabel(hrQuit.status, 'audit_status', '')}
												</p>
											</div>
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">提交人：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												${hrQuit.createBy.name}
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
												<fmt:formatDate value="${hrQuit.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
												</p>
											</div>
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">备注信息：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												${hrQuit.remarks}
												</p>
											</div>
										</div>
									</div>
								</div>
			 				</div>
			 			</div>
			 		</div>
			 	</div>
			</div>
		
		</div>
		<div class="col-sm-3">
			<div class="ibox float-e-margins">
				<div class="ibox-title">                        
                    <h5>员工记录</h5>
                </div>
                <div class="ibox-content timeline">
               		<c:forEach items="${hrResumeLogList}" var="hrResumeLog">
                       	<div class="timeline-item">
                            <div class="row">
                                <div class="col-xs-3 date">
                                    <i class="fa fa-circle-thin text-navy"></i> ${hrResumeLog.createBy.name}<br>
                                    <small><fmt:formatDate value="${hrResumeLog.createDate}" pattern="yyyy-MM-dd"/> <br><fmt:formatDate value="${hrResumeLog.createDate}" pattern="HH:mm"/></small>
                                </div>
                                <div class="col-xs-7 content">
                                    <p class="m-b-xs">${fns:getDictLabel(hrResumeLog.type, 'resume_action', '')}</p>
                                    <p class="small">${hrResumeLog.note}</p>
                                </div>
                            </div>
                        </div>	
                    </c:forEach>
                </div>
			</div>
		</div>
	</div>	
</div>

	<div class="row dashboard-footer white-bg">
         <div class="col-sm-12">
        	<div class="text-center">
        		<c:if test="${hrEmployee.status==0}">
        		<c:if test="${hrEmployee.regularStatus!=1}">
        		<a href="${ctx}/hr/hrEmployee/regularForm?id=${hrEmployee.id}" class="btn btn-success btn-sm">转正</a>
        		</c:if>
        		<a href="${ctx}/hr/hrPositionChange/form?hrEmployee.id=${hrEmployee.id}" class="btn btn-success btn-sm">调岗</a>
        		<a href="${ctx}/hr/hrSalaryChange/form?hrEmployee.id=${hrEmployee.id}" class="btn btn-success btn-sm">调薪</a>
        		<a href="${ctx}/hr/hrQuit/form?hrEmployee.id=${hrEmployee.id}" class="btn btn-success btn-sm">离职</a>
        		<a href="${ctx}/hr/hrEmployee/form?id=${hrEmployee.id}" class="btn btn-success btn-sm">修改</a>
        		</c:if>
        		
        		
        		<%-- <a href="#" onclick="openDialog('删除, '${ctx}/hr/hrEmployee/delete?id=${hrEmployee.id}','800px', '500px')" class="btn btn-danger btn-sm">删除</a>
        		--%>
        		<button id="btnCancel" class="btn btn-white btn-sm" type="button" onclick="history.go(-1)">返回</button>
        	</div>
        </div>
    </div>
</body>
</html>