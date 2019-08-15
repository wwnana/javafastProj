<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>客户信息</title>
	<meta name="decorator" content="default"/>
	
</head>
<body class="gray-bg">
 <div class="">
    <div class="">
		<div class="">
			<div class="ibox-title">
				<h5>客户信息 </h5>
				
			</div>
			<div class="ibox-content">
			<form:form id="inputForm" modelAttribute="crmCustomer" action="" method="post" class="form-horizontal">
				<form:hidden path="id"/>
				<sys:message content="${message}"/>	
					<h4 class="page-header">基本信息</h4>
					<div class="row">
						<div class="col-sm-6">
							<div class="view-group">
								<label class="col-sm-4 control-label">客户名称：</label>
								<div class="col-sm-8">
									<p class="form-control-static">${crmCustomer.name }</p>
								</div>
							</div>
						</div>
						<div class="col-sm-6">
							<div class="view-group">
								<label class="col-sm-4 control-label">客户分类：</label>
								<div class="col-sm-8">
									<p class="form-control-static">${fns:getDictLabel(crmCustomer.customerType, 'customer_type', '')}</p>
								</div>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-sm-6">
							<div class="view-group">
								<label class="col-sm-4 control-label">客户状态：</label>
								<div class="col-sm-8">
									<p class="form-control-static">${fns:getDictLabel(crmCustomer.customerStatus, 'customer_status', '')}</p>
								</div>
							</div>
						</div>
						<div class="col-sm-6">
							<div class="view-group">
								<label class="col-sm-4 control-label">客户级别：</label>
								<div class="col-sm-8">
									<p class="form-control-static">${fns:getDictLabel(crmCustomer.customerLevel, 'customer_level', '')}</p>
								</div>
							</div>
						</div>
					</div>
					
					<div class="row">
						<div class="col-sm-6">
							<div class="view-group">
								<label class="col-sm-4 control-label">首要联系人：</label>
								<div class="col-sm-8">
									<p class="form-control-static">${crmCustomer.contacterName}</p>
								</div>
							</div>
						</div>
						<div class="col-sm-6">
							<div class="view-group">
								<label class="col-sm-4 control-label">联系方式：</label>
								<div class="col-sm-8">
									<p class="form-control-static">${crmCustomer.mobile}</p>
								</div>
							</div>
						</div>
					</div>
					<h4 class="page-header">详细信息</h4>
					<div class="row">
						<div class="col-sm-6">
							<div class="view-group">
								<label class="col-sm-4 control-label">客户行业：</label>
								<div class="col-sm-8">
									<p class="form-control-static">${fns:getDictLabel(crmCustomer.industryType, 'industry_type', '')}</p>
								</div>
							</div>
						</div>
						<div class="col-sm-6">
							<div class="view-group">
								<label class="col-sm-4 control-label">客户来源：</label>
								<div class="col-sm-8">
									<p class="form-control-static">${fns:getDictLabel(crmCustomer.sourType, 'sour_type', '')}</p>
								</div>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-sm-6">
							<div class="view-group">
								<label class="col-sm-4 control-label">公司性质：</label>
								<div class="col-sm-8">
									<p class="form-control-static">${fns:getDictLabel(crmCustomer.natureType, 'nature_type', '')}</p>
								</div>
							</div>
						</div>
						<div class="col-sm-6">
							<div class="view-group">
								<label class="col-sm-4 control-label">企业规模：</label>
								<div class="col-sm-8">
									<p class="form-control-static">${fns:getDictLabel(crmCustomer.scaleType, 'scale_type', '')}</p>
								</div>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-sm-6">
							<div class="view-group">
								<label class="col-sm-4 control-label">公司电话：</label>
								<div class="col-sm-8">
									<p class="form-control-static">${crmCustomer.phone}</p>
								</div>
							</div>
						</div>
						<div class="col-sm-6">
							<div class="view-group">
								<label class="col-sm-4 control-label">公司传真：</label>
								<div class="col-sm-8">
									<p class="form-control-static">${crmCustomer.fax}</p>
								</div>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-sm-6">
							<div class="view-group">
								<label class="col-sm-4 control-label">公司地址：</label>
								<div class="col-sm-8">
									<p class="form-control-static">${crmCustomer.province}${crmCustomer.city}${crmCustomer.dict}</p>
								</div>
							</div>
						</div>
						<div class="col-sm-6">
							<div class="view-group">
								<label class="col-sm-4 control-label">详细地址：</label>
								<div class="col-sm-8">
									<p class="form-control-static">${crmCustomer.address}</p>
								</div>
							</div>
						</div>
					</div>
					
					<h4 class="page-header">下次联系提醒</h4>
					<div class="row">
						<div class="col-sm-6">
							<div class="view-group">
								<label class="col-sm-4 control-label">下次联系时间：</label>
								<div class="col-sm-8">
									<p class="form-control-static"><fmt:formatDate value="${crmCustomer.nextcontactDate}" pattern="yyyy-MM-dd"/></p>
								</div>
							</div>
						</div>
						<div class="col-sm-6">
							<div class="view-group">
								<label class="col-sm-4 control-label">下次联系内容：</label>
								<div class="col-sm-8">
									<p class="form-control-static">${crmCustomer.nextcontactNote}</p>
								</div>
							</div>
						</div>
					</div>
					<h4 class="page-header">操作信息</h4>
					<div class="row">
						<div class="col-sm-6">
							<div class="view-group">
								<label class="col-sm-4 control-label">负责人：</label>
								<div class="col-sm-8">
									<p class="form-control-static">${crmCustomer.ownBy.name}</p>
								</div>
							</div>
						</div>
						<div class="col-sm-6">
							<div class="view-group">
								<label class="col-sm-4 control-label">创建者：</label>
								<div class="col-sm-8">
									<p class="form-control-static">${crmCustomer.createBy.name}</p>
								</div>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-sm-6">
							<div class="view-group">
								<label class="col-sm-4 control-label">创建时间：</label>
								<div class="col-sm-8">
									<p class="form-control-static"><fmt:formatDate value="${crmCustomer.createDate}" pattern="yyyy-MM-dd"/></p>
								</div>
							</div>
						</div>
						<div class="col-sm-6">
							<div class="view-group">
								<label class="col-sm-4 control-label">最后更新：</label>
								<div class="col-sm-8">
									<p class="form-control-static"><fmt:formatDate value="${crmCustomer.updateDate}" pattern="yyyy-MM-dd"/></p>
								</div>
							</div>
						</div>
					</div>
					<h4 class="page-header">其他信息</h4>
					<div class="row">
						<div class="col-sm-6">
							<div class="view-group">
								<label class="col-sm-4 control-label">客户标签：</label>
								<div class="col-sm-8">
									<p class="form-control-static">${crmCustomer.tags}</p>
								</div>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-sm-6">
							<div class="view-group">
								<label class="col-sm-4 control-label">备注信息：</label>
								<div class="col-sm-8">
									<p class="form-control-static">${crmCustomer.remarks}</p>
								</div>
							</div>
						</div>
					</div>
					
				
				</form:form>
			</div>
		</div>
	 </div>
	
</div>
</body>
</html>