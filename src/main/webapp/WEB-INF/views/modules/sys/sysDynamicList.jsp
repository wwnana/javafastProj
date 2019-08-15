<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>动态管理</title>
<meta name="decorator" content="default" />
<script type="text/javascript">
	function toView(objectType, targetId) {
		//object_type对象类型    10：项目，11：任务，12:日报，13：通知，14：审批，20：客户，21：联系人，22：商机，23：报价，24：合同订单，25:沟通, 26:订单，27：退货单，30：产品：31：采购，32：入库，33：出库，34：移库，39：供应商，36：盘点，37:调拨，   50：应收款，51：应付款， 52：收款单，53：付款单
		if (objectType == "11") {//任务
			window.location.href = "${ctx}/oa/oaTask/view?id=" + targetId;
		}
		if (objectType == "20") {//客户
			window.location.href = "${ctx}/crm/crmCustomer/index?id="
					+ targetId;
		}
		if (objectType == "18") {//市场活动
			window.location.href = "${ctx}/crm/crmMarket/index?id=" + targetId;
		}
		if (objectType == "19") {//销售线索
			window.location.href = "${ctx}/crm/crmClue/index?id=" + targetId;
		}
		if (objectType == "21") {
			openDialogView("联系人",
					"${ctx}/crm/crmContacter/view?id=" + targetId, '800px',
					'500px');
		}
		if (objectType == "22") {//商机
			window.location.href = "${ctx}/crm/crmChance/index?id=" + targetId;
		}
		if (objectType == "23") {//报价
			window.location.href = "${ctx}/crm/crmQuote/view?id=" + targetId;
		}
		if (objectType == "24") {//合同订单
			window.location.href = "${ctx}/om/omContract/index?id=" + targetId;
		}
		if (objectType == "25") {
			openDialogView("跟进记录", "${ctx}/crm/crmContactRecord/view?id="
					+ targetId, '800px', '500px');
		}
		if (objectType == "26") {//订单
			window.location.href = "${ctx}/om/omOrder/index?id=" + targetId;
		}
		if (objectType == "27") {//退货单
			window.location.href = "${ctx}/om/omReturnorder/view?id="
					+ targetId;
		}
		if (objectType == "39") {
			openDialogView("供应商", "${ctx}/wms/wmsSupplier/view?id=" + targetId,
					'800px', '500px');
		}
		if (objectType == "31") {//采购单
			window.location.href = "${ctx}/wms/wmsPurchase/view?id=" + targetId;
		}
		if (objectType == "32") {//入库单
			window.location.href = "${ctx}/wms/wmsInstock/view?id=" + targetId;
		}
		if (objectType == "33") {//出库单
			window.location.href = "${ctx}/wms/wmsOutstock/view?id=" + targetId;
		}
		if (objectType == "50") {//应收款
			window.location.href = "${ctx}/fi/fiReceiveAble/index?id="
					+ targetId;
		}
		if (objectType == "51") {//应付款
			window.location.href = "${ctx}/fi/fiPaymentAble/index?id="
					+ targetId;
		}
		if (objectType == "52") {
			openDialogView("收款单",
					"${ctx}/fi/fiReceiveBill/view?id=" + targetId, '800px',
					'500px');
		}
		if (objectType == "53") {
			openDialogView("付款单",
					"${ctx}/fi/fiPaymentBill/view?id=" + targetId, '800px',
					'500px');
		}
	}
</script>
</head>
<body class="gray-bg">
	<div class="wrapper-content">
		<div class="ibox float-e-margins">
			<div class="ibox-title">
				<h5>团队动态</h5>
				<div class="ibox-tools hide">
					<a href="${ctx}/sys/sysDynamic" target="mainFrame"> <i
						class="fa fa-chevron-right"></i>
					</a>
				</div>
			</div>
			<div class="ibox-content">
				<div class="row">
					<div class="col-sm-12">
						<form:form id="searchForm" modelAttribute="sysDynamic"
							action="${ctx}/sys/sysDynamic/" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden"
								value="${page.pageNo}" />
							<input id="pageSize" name="pageSize" type="hidden"
								value="${page.pageSize}" />
							<table:sortColumn id="orderBy" name="orderBy"
								value="${page.orderBy}" callback="sortOrRefresh();" />
							<!-- 支持排序 -->
							<div class="form-group">
								<span>操作人：</span>
								<sys:treeselect id="createBy" name="createBy.id"
									value="${sysDynamic.createBy.id}" labelName="createBy.name"
									labelValue="${sysDynamic.createBy.name}" title="用户"
									url="/sys/office/treeData?type=3"
									cssClass="form-control input-small" allowClear="true"
									notAllowSelectParent="true" />
							</div>
							<div class="form-group">
								<span>创建时间：</span>
								<div class="input-group date datepicker">
									<input name="beginCreateDate" type="text" readonly="readonly"
										class="form-control input-small"
										value="<fmt:formatDate value="${sysDynamic.beginCreateDate}" pattern="yyyy-MM-dd"/>"
										onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});">
									<span class="input-group-addon"> <span
										class="fa fa-calendar"></span>
									</span>
								</div>
								-
								<div class="input-group date datepicker">
									<input name="endCreateDate" type="text" readonly="readonly"
										class="form-control input-small"
										value="<fmt:formatDate value="${sysDynamic.endCreateDate}" pattern="yyyy-MM-dd"/>"
										onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});">
									<span class="input-group-addon"> <span
										class="fa fa-calendar"></span>
									</span>
								</div>
							</div>

							<div class="form-group" style="padding-top: 5px;">
								<button class="btn btn-white btn-sm" onclick="search()">
									<i class="fa fa-search"></i> 查询
								</button>
								<button class="btn btn-white btn-sm" onclick="resetSearch()">
									<i class="fa fa-refresh"></i> 重置
								</button>
							</div>
						</form:form>
					</div>
				</div>
				<br>
				<div class="row">
					<div class="col-sm-12">
					<div class="chat-activity-list">

						<c:forEach items="${page.list }" var="sysDynamic">
							<div class="chat-element">
								<a href="#"
									onclick="openDialogView('查看用户信息', '${ctx}/sys/user/view?id=${sysDynamic.createBy.id}','800px', '500px')"
									class="pull-left"> <img alt="${sysDynamic.createBy.name}"
									class="img-circle" src="${sysDynamic.createBy.photo}"
									onerror="this.src='${ctxStatic}/images/user.jpg'">
								</a>
								<div class="media-body ">
									<small class="pull-right"><small class="text-muted">${fns:getTimeDiffer(sysDynamic.createDate)}</small></small>
									<strong><fmt:formatDate
											value="${sysDynamic.createDate}" pattern="MM/dd HH:mm" />
										${sysDynamic.createBy.name}</strong>&nbsp;&nbsp;<i>${fns:getDictLabel(sysDynamic.actionType, 'action_type', '')}了</i>&nbsp;&nbsp;${fns:getDictLabel(sysDynamic.objectType, 'object_type', '')}
									<p style="padding-top: 10px;">

										<c:if test="${sysDynamic.objectType != 20}">

											<a href="#"
												onclick="toView('${sysDynamic.objectType}','${sysDynamic.targetId}');">${sysDynamic.targetName}</a>

											<c:if test="${not empty sysDynamic.customerId}">（客户：<a
													href="${ctx}/crm/crmCustomer/index?id=${sysDynamic.customerId}">${sysDynamic.customerName}</a>）</c:if>

										</c:if>
										<c:if test="${sysDynamic.objectType == 20}">
											<a href="#"
												onclick="toView('${sysDynamic.objectType}','${sysDynamic.targetId}');">${sysDynamic.targetName}</a>
										</c:if>
									</p>

								</div>
							</div>
						</c:forEach>

					</div>
					<br>
					<table:page page="${page}"></table:page>
					<br>
					<br>

				</div>
			</div>
		</div>
		</div>




	</div>
</body>
</html>