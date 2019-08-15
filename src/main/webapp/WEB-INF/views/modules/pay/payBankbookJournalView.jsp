<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>电子钱包交易明细查看</title>
	<meta name="decorator" content="default"/>
</head>
<body class="hideScroll">
	<div class="ibox-content">
		<sys:message content="${message}"/>
		<form:form id="inputForm" modelAttribute="payBankbookJournal" action="${ctx}/pay/payBankbookJournal/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
			<h4 class="page-header">基本信息</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">交易日期：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							<fmt:formatDate value="${payBankbookJournal.dealDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">交易类型：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${fns:getDictLabel(payBankbookJournal.dealType, 'deal_type', '')}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">交易金额：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${payBankbookJournal.money}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">资金类别：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${fns:getDictLabel(payBankbookJournal.moneyType, 'money_type', '')}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">当前余额：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${payBankbookJournal.balance}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">摘要：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${payBankbookJournal.remarks}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">唯一码：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${payBankbookJournal.uniqueCode}
							</p>
						</div>
					</div>
				</div>
			</div>
			
		</form:form>
	</div>
</body>
</html>