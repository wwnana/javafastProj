<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html>
<head>
<title>待办</title>
<%@ include file="/WEB-INF/views/include/weuihead.jsp"%>

<script type="text/javascript">


function omContractViewData(id){
	window.location.href="${ctx}/mobile/om/omContract/index?id="+id;
}
function fiReceiveAbleViewData(id){
	window.location.href="${ctx}/mobile/fi/fiReceiveAble/view?id="+id;
}
function crmServiceViewData(id){
	window.location.href="${ctx}/mobile/crm/crmService/view?id="+id;
}
function crmCustomerViewData(id){
	window.location.href="${ctx}/mobile/crm/crmCustomer/index?id="+id;
}
</script>
</head>
<body>
	<div class="page">
		<div class="page__bd" style="height: 100%;">
			<div class="weui-tab">
				<div id="tagnav" class="weui-navigator weui-navigator-wrapper">
			        <ul class="weui-navigator-list">
			            <li class="weui-state_item weui-state-active"><a href="javascript:;" onclick="changeTab('1')">合同<c:if test="${omContractPage.count > 0}"><span class="weui-badge" style="margin-left: 5px;">${omContractPage.count}</span></c:if></a></li>
			            <li class="weui-state_item"><a href="javascript:;" onclick="changeTab('2')">回款<c:if test="${fiReceiveAblePage.count > 0}"><span class="weui-badge" style="margin-left: 5px;">${fiReceiveAblePage.count}</span></c:if></a></li>
			            <li class="weui-state_item"><a href="javascript:;" onclick="changeTab('3')">工单<c:if test="${crmServicePage.count > 0}"><span class="weui-badge" style="margin-left: 5px;">${crmServicePage.count}</span></c:if></a></li>
			            <li class="weui-state_item"><a href="javascript:;" onclick="changeTab('4')">联系<c:if test="${contactCustomerPage.count > 0}"><span class="weui-badge" style="margin-left: 5px;">${contactCustomerPage.count}</span></c:if></a></li>
			        </ul>
			    </div>
				<div class="weui-tab__panel">
					<div id="tab1">
						<div class="weui-panel weui-panel_access">
				            <div class="weui-panel__hd">待审批合同</div>
				            <div class="weui-panel__bd">
				                <c:forEach items="${omContractPage.list}" var="omContract">
				                <div class="weui-media-box weui-media-box_text" onclick="omContractViewData('${omContract.id}')">
				                    <span class="pull-right weui-media-box__desc">¥${omContract.amount}</span>
				                    <h4 class="weui-media-box__title">${omContract.no}</h4>
				                    <p class="weui-media-box__desc">${omContract.customer.name}</p>
				                    <ul class="weui-media-box__info">
				                        <li class="weui-media-box__info__meta">${omContract.ownBy.name}</li>
				                        <li class="weui-media-box__info__meta weui-media-box__info__meta_extra"><fmt:formatDate value="${omContract.dealDate}" pattern="yyyy-MM-dd"/></li>
				                        <li class="weui-media-box__info__meta weui-media-box__info__meta_extra">${fns:getDictLabel(omContract.status, 'audit_status', '')}</li>
				                    </ul>
				                </div>
				                </c:forEach>
				            </div>
				            <c:if test="${omContractPage.count > 10}">
				            <div class="weui-panel__ft">
				                <a href="${ctx}/mobile/om/omContract?status=0" class="weui-cell weui-cell_access weui-cell_link">
				                    <div class="weui-cell__bd">查看更多</div>
				                    <span class="weui-cell__ft"></span>
				                </a>    
				            </div>
				            </c:if>
				        </div>
					</div>
					<div id="tab2">
						<div class="weui-panel weui-panel_access">
				            <div class="weui-panel__hd">待办回款</div>
				            <div class="weui-panel__bd">
				                <c:forEach items="${fiReceiveAblePage.list}" var="fiReceiveAble">
				                <div class="weui-media-box weui-media-box_text" onclick="fiReceiveAbleViewData('${fiReceiveAble.id}')">
				                    <span class="pull-right weui-media-box__desc font-red">待收：¥${fiReceiveAble.amount - fiReceiveAble.realAmt}</span>
				                    <h4 class="weui-media-box__title">${fiReceiveAble.no}</h4>
				                    <p class="weui-media-box__desc">${fiReceiveAble.customer.name}</p>
				                    <ul class="weui-media-box__info">
				                        <li class="weui-media-box__info__meta">${fiReceiveAble.ownBy.name}</li>
				                        <li class="weui-media-box__info__meta weui-media-box__info__meta_extra"><fmt:formatDate value="${fiReceiveAble.createDate}" pattern="yyyy-MM-dd"/></li>
				                        <li class="weui-media-box__info__meta weui-media-box__info__meta_extra">${fns:getDictLabel(fiReceiveAble.status, 'finish_status', '')}</li>
				                    </ul>
				                </div>
				                </c:forEach>
				            </div>
				            <c:if test="${fiReceiveAble.count > 10}">
				            <div class="weui-panel__ft">
				                <a href="${ctx}/mobile/fi/fiReceiveAble?status=0" class="weui-cell weui-cell_access weui-cell_link">
				                    <div class="weui-cell__bd">查看更多</div>
				                    <span class="weui-cell__ft"></span>
				                </a>    
				            </div>
				            </c:if>
				        </div>
					</div>
					<div id="tab3">
						<div class="weui-panel weui-panel_access">
				            <div class="weui-panel__hd">待办工单</div>
				            <div class="weui-panel__bd">
				                <c:forEach items="${crmServicePage.list}" var="crmService">
				                <div class="weui-media-box weui-media-box_text" onclick="crmServiceViewData('${crmService.id}')">
				                    
				                    <h4 class="weui-media-box__title">${crmService.name}</h4>
				                    <p class="weui-media-box__desc">${crmService.customer.name}</p>
				                    <ul class="weui-media-box__info">
				                        <li class="weui-media-box__info__meta">${crmService.ownBy.name}</li>
				                        <li class="weui-media-box__info__meta weui-media-box__info__meta_extra"><fmt:formatDate value="${crmService.endDate}" pattern="yyyy-MM-dd"/></li>
				                        <li class="weui-media-box__info__meta weui-media-box__info__meta_extra">${fns:getDictLabel(crmService.status, 'finish_status', '')}</li>
				                    </ul>
				                </div>
				                </c:forEach>
				            </div>
				            <c:if test="${crmServicePage.count > 10}">
				            <div class="weui-panel__ft">
				                <a href="${ctx}/mobile/crm/crmService?status=0" class="weui-cell weui-cell_access weui-cell_link">
				                    <div class="weui-cell__bd">查看更多</div>
				                    <span class="weui-cell__ft"></span>
				                </a>    
				            </div>
				            </c:if>
				        </div>
					</div>
					<div id="tab4">
						<div class="weui-panel weui-panel_access">
				            <div class="weui-panel__hd">待联系客户</div>
				            <div class="weui-panel__bd">
				                <c:forEach items="${contactCustomerPage.list}" var="crmCustomer">
				                <div class="weui-media-box weui-media-box_text" onclick="crmCustomerViewData('${crmCustomer.id}')">
				                	<span class="pull-right weui-media-box__desc">
				                		<c:if test="${not empty crmCustomer.nextcontactDate}">
					                   		${fns:getTimeAfterDiffer(crmCustomer.nextcontactDate)}
					                   	</c:if>
					                </span>
				                    <h4 class="weui-media-box__title">${crmCustomer.name}</h4>
				                    <p class="weui-media-box__desc">${crmCustomer.nextcontactNote}</p>
				                    <ul class="weui-media-box__info">
				                        <li class="weui-media-box__info__meta"><fmt:formatDate value="${crmCustomer.nextcontactDate}" pattern="yyyy-MM-dd"/></li>
				                        <li class="weui-media-box__info__meta weui-media-box__info__meta_extra">${crmCustomer.ownBy.name}</li>
				                    </ul>
				                </div>
				                </c:forEach>
				            </div>
				            <c:if test="${contactCustomerPage.count > 10}">
				            <div class="weui-panel__ft">
				                <a href="${ctx}/mobile/crm/crmCustomer" class="weui-cell weui-cell_access weui-cell_link">
				                    <div class="weui-cell__bd">查看更多</div>
				                    <span class="weui-cell__ft"></span>
				                </a>    
				            </div>
				            </c:if>
				        </div>
					</div>
					
					
				</div>
			</div>
		</div>
	</div>
	<script type="text/javascript">
		$(function() {
			$('.weui-state_item').on(
					'click',
					function() {
						$(this).addClass('weui-state-active').siblings(
								'.weui-state-active').removeClass(
								'weui-state-active');
			});
			//导航切换
			TagNav('#tagnav',{
		        type: 'scrollToNext',
		        curClassName: 'weui-state-active',
		        index:0
		    });
		});
		changeTab(1);
		function changeTab(ltab_num) {
			for (i = 0; i <= 4; i++) {
				$("#tab" + i).hide(); //将所有的层都隐藏
			}
			$("#tab" + ltab_num).show(); //显示当前层
		}
	</script>


	<c:set value="3" var="nav"></c:set>
	<%@ include file="foot.jsp"%>
</body>
</html>
