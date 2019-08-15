<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html>
<head>
<title>看板</title>
<%@ include file="/WEB-INF/views/include/weuihead.jsp"%>
<style type="text/css">
.weui-grid_label {
	text-align: center;
	color: #4C84C4;
}

.weui-cell__bd {
	font-size: 13px;
}
</style>
<script type="text/javascript">

$(document).ready(function(){
  
	//监听返回事件
	pushHistory();
	window.addEventListener("popstate", function(e) {
		//不处理
	}, false);
	function pushHistory() {
		var state = {
			title : "title",
			url : "#"
		};
		window.history.pushState(state, "title", "#");
	}
	
	$("#userTypeSelect").hide();
	$("#userTypeDiv").click(function(){
		$("#userTypeSelect").toggle();
		$("#dateTypeSelect").hide();
	});
 
	$("#dateTypeSelect").hide();
	$("#dateTypeDiv").click(function(){
		$("#dateTypeSelect").toggle();
		$("#userTypeSelect").hide();
	});
	
    $("input[name='userTypeRadio']").click(function(){
		var user_type = $("input[name='userTypeRadio']:checked").val();
		$("#userType").val(user_type);
        $("#searchForm").submit();
    });
    
    $("input[name='dateTypeRadio']").click(function(){
		var date_type = $("input[name='dateTypeRadio']:checked").val();
		$("#dateType").val(date_type);
        $("#searchForm").submit();
	});
});
 
</script>
</head>
<body ontouchstart>

	<form action="${ctx}/mobile/home" method="get" id="searchForm">
		<input type="hidden" id="userType" name="userType" value="${userType}">
		<input type="hidden" id="dateType" name="dateType" value="${dateType}">
	</form>
	<div class="page-content">
		<div class="weui-form-preview">

			<div class="weui-form-preview__ft">
				<div class="weui-form-preview__btn weui-form-preview__btn_default" id="userTypeDiv">
					<i class="fa fa-filter"></i>
					<c:if test="${userType==0}">个人</c:if>
					<c:if test="${userType==1}">全公司</c:if>
					<i class="fa fa-angle-down"></i>
				</div>
				<div class="weui-form-preview__btn weui-form-preview__btn_default" id="dateTypeDiv">
						<i class="fa fa-filter"></i>
						<c:if test="${dateType=='C'}">今天</c:if>
                    	<c:if test="${dateType=='W'}">本周</c:if>
                    	<c:if test="${dateType=='LW'}">上周</c:if>
                    	<c:if test="${dateType=='M'}">本月</c:if>
                    	<c:if test="${dateType=='LM'}">上月</c:if>
                    	<c:if test="${dateType=='Q'}">本季度</c:if>
                    	<c:if test="${dateType=='Y'}">本年度</c:if>
                   	<i class="fa fa-angle-down"></i>
				</div>
			</div>
		</div>
		<div class="weui-cells weui-cells_radio" id="userTypeSelect" style="margin-top: 0">
            <label class="weui-cell weui-check__label" for="x11" id="userTypeSelect1">
                <div class="weui-cell__bd">
                    <p>个人</p>
                </div>
                <div class="weui-cell__ft">
                    <input type="radio" class="weui-check" name="userTypeRadio" id="x11"  <c:if test='${userType==0}'>checked="checked"</c:if> value="0"/>
                    <span class="weui-icon-checked"></span>
                </div>
            </label>
            <label class="weui-cell weui-check__label" for="x12">

                <div class="weui-cell__bd">
                    <p>全公司</p>
                </div>
                <div class="weui-cell__ft">
                    <input type="radio" name="userTypeRadio" class="weui-check" id="x12" <c:if test='${userType==1}'>checked="checked"</c:if> value="1"/>
                    <span class="weui-icon-checked"></span>
                </div>
            </label>
        </div>
        <div class="weui-cells weui-cells_radio" id="dateTypeSelect" style="margin-top: 0">
            <label class="weui-cell weui-check__label" for="x21">
                <div class="weui-cell__bd">
                    <p>今天</p>
                </div>
                <div class="weui-cell__ft">
                    <input type="radio" class="weui-check" name="dateTypeRadio" id="x21" <c:if test='${dateType eq "C"}'>checked="checked"</c:if> value="C"/>
                    <span class="weui-icon-checked"></span>
                </div>
            </label>
            <label class="weui-cell weui-check__label" for="x22">
                <div class="weui-cell__bd">
                    <p>本周</p>
                </div>
                <div class="weui-cell__ft">
                    <input type="radio" class="weui-check" name="dateTypeRadio" id="x22" value="W"/>
                    <span class="weui-icon-checked"></span>
                </div>
            </label>
            <label class="weui-cell weui-check__label" for="x23">
                <div class="weui-cell__bd">
                    <p>上周</p>
                </div>
                <div class="weui-cell__ft">
                    <input type="radio" class="weui-check" name="dateTypeRadio" id="x23" value="LW"/>
                    <span class="weui-icon-checked"></span>
                </div>
            </label>
            <label class="weui-cell weui-check__label" for="x24">
                <div class="weui-cell__bd">
                    <p>本月</p>
                </div>
                <div class="weui-cell__ft">
                    <input type="radio" class="weui-check" name="dateTypeRadio" id="x24" checked="checked" value="M"/>
                    <span class="weui-icon-checked"></span>
                </div>
            </label>
            <label class="weui-cell weui-check__label" for="x25">
                <div class="weui-cell__bd">
                    <p>上月</p>
                </div>
                <div class="weui-cell__ft">
                    <input type="radio" class="weui-check" name="dateTypeRadio" id="x25" checked="checked" value="LM"/>
                    <span class="weui-icon-checked"></span>
                </div>
            </label>
            <label class="weui-cell weui-check__label" for="x26">
                <div class="weui-cell__bd">
                    <p>本季度</p>
                </div>
                <div class="weui-cell__ft">
                    <input type="radio" name="dateTypeRadio" class="weui-check" id="x26" value="Q"/>
                    <span class="weui-icon-checked"></span>
                </div>
            </label>
            <label class="weui-cell weui-check__label" for="x27">
                <div class="weui-cell__bd">
                    <p>本年度</p>
                </div>
                <div class="weui-cell__ft">
                    <input type="radio" name="dateTypeRadio" class="weui-check" id="x27" value="Y"/>
                    <span class="weui-icon-checked"></span>
                </div>
            </label>
        </div>
		
		<div class="weui-cells__title">线索转化</div>
		<div class="weui-grids">
			<div class="weui-grid js_grid">
				<div class="weui-grid_label">${crmClueReport.totalClueNum }&nbsp;</div>
				<p class="weui-grid__label">
					<span class="weui-media-box__desc">线索总数</span>
				</p>
			</div>
			<div class="weui-grid js_grid">
				<div class="weui-grid_label">${crmClueReport.toCustomerNum }&nbsp;</div>
				<p class="weui-grid__label">
					<span class="weui-media-box__desc">转化为客户</span>
				</p>
			</div>
			<div class="weui-grid js_grid">
				<div class="weui-grid_label">${crmClueReport.toChanceNum }&nbsp;</div>
				<p class="weui-grid__label">
					<span class="weui-media-box__desc">转化为商机</span>
				</p>
			</div>
			<div class="weui-grid js_grid">
				<div class="weui-grid_label">${crmClueReport.toOrderNum }&nbsp;</div>
				<p class="weui-grid__label">
					<span class="weui-media-box__desc">转化为订单</span>
				</p>
			</div>
		</div>
		<div class="weui-cells__title">销售简报</div>
		<div class="weui-grids" style="background: #fff;">
			<div class="weui-grid js_grid">
				<div class="weui-grid_label">${crmSimpleReport.createNum}&nbsp;</div>
				<p class="weui-grid__label">
					<span class="weui-media-box__desc">创建客户数</span>
				</p>
			</div>
			<div class="weui-grid js_grid">
				<div class="weui-grid_label">${crmSimpleReport.ownNum}&nbsp;</div>
				<p class="weui-grid__label">
					<span class="weui-media-box__desc">负责客户数</span>
				</p>
			</div>
			
			<div class="weui-grid js_grid">
				<div class="weui-grid_label">
					${crmSimpleReport.createChangeNum}&nbsp;</div>
				<p class="weui-grid__label">
					<span class="weui-media-box__desc">创建商机数</span>
				</p>
			</div>
			<div class="weui-grid js_grid">
				<div class="weui-grid_label">${crmSimpleReport.ownChangeNum }&nbsp;
				</div>
				<p class="weui-grid__label">
					<span class="weui-media-box__desc">负责商机数</span>
				</p>
			</div>
			
			<div class="weui-grid js_grid">
				<div class="weui-grid_label">
					${crmSimpleReport.createOrderAmt}&nbsp;</div>
				<p class="weui-grid__label">
					<span class="weui-media-box__desc">订单总额</span>
				</p>
			</div>
			<div class="weui-grid js_grid">
				<div class="weui-grid_label">
					${crmSimpleReport.recOrderAmt}&nbsp;</div>
				<p class="weui-grid__label">
					<span class="weui-media-box__desc">回款总额</span>
				</p>
			</div>
		</div>
		
		
		
		<div class="weui-cells__title">商机分布</div>
		<div class="weui-cells">
			<div class="weui-cell">
				<div class="weui-cell__bd">
					<p>初步恰接</p>
				</div>
				<div class="weui-cell__ft">${chanceReport.purposeCustomerNum }</div>
			</div>

			<div class="weui-cell">
				<div class="weui-cell__bd">
					<p>需求确定</p>
				</div>
				<div class="weui-cell__ft">${chanceReport.demandCustomerNum }</div>
			</div>

			<div class="weui-cell">
				<div class="weui-cell__bd">
					<p>方案报价</p>
				</div>
				<div class="weui-cell__ft">${chanceReport.quoteCustomerNum }</div>
			</div>

			<div class="weui-cell">
				<div class="weui-cell__bd">
					<p>签订合同</p>
				</div>
				<div class="weui-cell__ft">${chanceReport.dealOrderNum }</div>
			</div>

			<div class="weui-cell">
				<div class="weui-cell__bd">
					<p>销售回款</p>
				</div>
				<div class="weui-cell__ft">${chanceReport.completeOrderNum }</div>
			</div>

		</div>
		<div class="weui-cells__title">销售漏斗</div>
		<div class="page__bd">
		<%@ include file="/WEB-INF/views/include/echarts.jsp"%>
						<div id="funnel"  class="main000"></div>
						<echarts:funnel
						    id="funnel"
							title="销售漏斗" 
							subtitle="（商机金额）"
							orientData="${orientData}"/>

		</div>
		
		<div class="weui-cells__title"></div>

	</div>
	<c:set value="2" var="nav"></c:set>
	<%@ include file="foot.jsp"%>

</body>
</html>
