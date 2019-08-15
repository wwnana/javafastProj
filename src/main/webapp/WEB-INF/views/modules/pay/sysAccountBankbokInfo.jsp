<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>企业资金信息</title>
	<meta name="decorator" content="default"/>
</head>
<body class="gray-bg">
	<div class="wrapper-content">
		<div class="row">
			<div class="col-sm-12">
				<div class="ibox">
					<div class="ibox-content">
						<div class="row row-sm text-center">
							<div class="col-xs-3">
                                <div class="panel padder-v item ">
                                    <div class="h3 text-primary font-thin h1">${sysAccount.name }</div>
                                    <span class="text-xs">帐户类型: 正式</span>
                                </div>
                            </div>
                            <div class="col-xs-3">
                                <div class="panel padder-v item ">
                                    <div class="h3 text-info font-thin h1">企业版</div>
                                    <span class="text-xs">当前版本</span>
                                </div>
                            </div>
                            <div class="col-xs-3">
                                <div class="panel padder-v item ">
                                    <div class="h3 text-info font-thin h1">${sysAccount.nowUserNum }</div>
                                    <span class="text-xs">你的企业现拥有的帐号数</span>
                                </div>
                            </div>
                            <div class="col-xs-3">
                                <div class="panel padder-v item ">
                                    <div class="h3 text-info font-thin h1">0</div>
                                    <span class="text-xs">优惠券</span>
                                </div>
                            </div>
                            
                        </div>
					</div>
				</div>
			</div>
		</div>
		<div class="row">
			<div class="col-sm-3">
				<div class="ibox">
					<div class="ibox-title">
						<h5>账户余额 </h5>
					</div>
					<div class="ibox-content">
						<div class="row row-sm text-center">
							<div class="col-xs-3">
                                <div class="panel padder-v item ">
                                    <div class="h3 text-info font-thin h1">${payBankbookBalance.balance}</div>
                                    <span class="text-xs">当前余额</span>
                                    <br><br>
									<a href="#" class="btn btn-success btn-sm" onclick="openDialog('在线充值', '${ctx}/pay/payRechargeOrder/rechargeForm','500px', '300px')">								
                                    <i class="fa fa-rmb"></i> 充值</a>
                                </div>
                            </div>
                         </div>
                     </div>
				</div>
			</div>
			<div class="col-sm-9">
				<div class="ibox">
					<div class="ibox-title">
						<h5>账单明细 </h5>
					</div>
					<div class="ibox-content">
						<div class="table-responsive">
						<table id="contentTable" class="table">
							<thead>
								<tr>
									<th>交易日期</th>
									<th>交易类型</th>
									<th>交易金额</th>
									<th>摘要</th>
								</tr>
							</thead>
							<tbody>
							<c:forEach items="${page.list}" var="payBankbookJournal">
								<tr>
									<td>
										<fmt:formatDate value="${payBankbookJournal.dealDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
									</td>
									<td>
										${fns:getDictLabel(payBankbookJournal.dealType, 'deal_type', '')}
									</td>
									<td>
										${payBankbookJournal.money}
									</td>
									<td>
										${payBankbookJournal.remarks}
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
		</div>
		<div class="alert alert-info alert-dismissable">
    	<button aria-hidden="true" data-dismiss="alert" class="close" type="button">×</button>
        	提示：<br>
        	1、超过试用期，需要付费使用：  10元/月/用户 （企业版）*1人= 10 元/月<br>
        	2、相应使用费会在下一个月进行结算，系统自动从余额中扣除，请保持余额充足<br>
        	3、发票请联系客服进行索取，可以开具增值税普通发票和专用发票
     </div>
	</div>
</body>
</html>