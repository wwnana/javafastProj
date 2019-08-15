<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html>
<head>
<title>首页</title>
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
    $(function(){
    	$("#searchBar").click(function(){
    		
    		window.location.href = "${ctx}/mobile/sys/sysSearch";
    	});
    });
	
    </script>
</head>
<body ontouchstart>
<div class="page">
    <div class="page__bd">
        <!--<a href="javascript:;" class="weui-btn weui-btn_primary">点击展现searchBar</a>-->
        <div class="weui-search-bar" id="searchBar">
            <form class="weui-search-bar__form">
                <div class="weui-search-bar__box">
                    <i class="weui-icon-search"></i>
                    <input type="search" class="weui-search-bar__input" id="searchInput" placeholder="搜索" required readonly="readonly"/>
                    <a href="javascript:" class="weui-icon-clear" id="searchClear"></a>
                </div>
                <label class="weui-search-bar__label" id="searchText">
                    <i class="weui-icon-search"></i>
                    <span>搜索</span>
                </label>
            </form>
            <a href="javascript:" class="weui-search-bar__cancel-btn" id="searchCancel">取消</a>
        </div>
    </div>
    <div class="page__bd" style="padding:0px;">
        <div class="weui-panel weui-panel_access">
            <div class="weui-panel__bd">
                <div class="weui-grids">
			      <a href="${ctx}/mobile/report" class="weui-grid js_grid">
			        <div class="weui-grid__icon">
			          <img src="${ctxStatic}/weui/images/app/icon_report2.png" alt="">
			        </div>
			        <p class="weui-grid__label">
			          	统计分析
			        </p>
			      </a>
			      
			      <a href="${ctx}/mobile/find" class="weui-grid js_grid">
			        <div class="weui-grid__icon">
			          <img src="${ctxStatic}/weui/images/app/icon_remind2.png" alt="">
			        </div>
			        <p class="weui-grid__label">
			          	待办提醒
			        </p>
			      </a>
			      <a href="${ctx}/mobile/crm/crmStar" class="weui-grid js_grid">
			        <div class="weui-grid__icon">
			          <img src="${ctxStatic}/weui/images/app/icon_star2.png" alt="">
			        </div>
			        <p class="weui-grid__label">
			         	 关注客户
			        </p>
			      </a>
			      <a href="${ctx}/mobile/sys/sysDynamic" class="weui-grid js_grid">
			        <div class="weui-grid__icon">
			          <img src="${ctxStatic}/weui/images/app/icon_dynamic.png" alt="">
			        </div>
			        <p class="weui-grid__label">
			         	团队动态
			        </p>
			      </a>
			    </div>
    
            </div>
        </div>
        
        
        
        <div class="weui-panel weui-panel_access">
            <div class="weui-panel__hd"><img src="${ctxStatic}/weui/images/icon_remind2.png" alt="" style="width:25px;height:25px;margin-right:5px;vertical-align: middle;"> 销售简报 <span class="pull-right">${fns:getUser().name} | 本月</span></div>
            <div class="weui-panel__bd">
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
		
            </div>
            <div class="weui-panel__ft">
                <a href="${ctx}/mobile/report" class="weui-cell weui-cell_access weui-cell_link">
                    <div class="weui-cell__bd">查看更多</div>
                    <span class="weui-cell__ft"></span>
                </a>    
            </div>
        </div>
        
        <div class="weui-panel weui-panel_access">
            <div class="weui-panel__hd"><img src="${ctxStatic}/weui/images/app/icon_chance2.png" alt="" style="width:25px;height:25px;margin-right:5px;vertical-align: middle;"> 最新商机</div>
            <div class="weui-panel__bd">
                <c:forEach items="${crmChancePage.list}" var="crmChance">
                <div class="weui-media-box weui-media-box_text" onclick="window.location.href='${ctx}/mobile/crm/crmChance/index?id=${crmChance.id}'">
                    <h4 class="weui-media-box__title">${crmChance.name}</h4>
                    <p class="weui-media-box__desc">${fns:getDictLabel(crmChance.periodType, 'period_type', '')} | ${crmChance.ownBy.name} | <fmt:formatDate value="${crmChance.createDate}" pattern="yyyy-MM-dd"/></p>
                </div>
                </c:forEach>
            </div>
            <div class="weui-panel__ft">
                <a href="${ctx}/mobile/crm/crmChance" class="weui-cell weui-cell_access weui-cell_link">
                    <div class="weui-cell__bd">查看更多</div>
                    <span class="weui-cell__ft"></span>
                </a>    
            </div>
        </div>
        <div class="weui-panel weui-panel_access">
            <div class="weui-panel__hd"><img src="${ctxStatic}/weui/images/app/icon_customer.png" alt="" style="width:25px;height:25px;margin-right:5px;vertical-align: middle;"> 最新客户</div>
            <div class="weui-panel__bd">
                <c:forEach items="${newCustomerPage.list}" var="crmCustomer">
                <div class="weui-media-box weui-media-box_text" onclick="window.location.href='${ctx}/mobile/crm/crmCustomer/index?id=${crmCustomer.id}'">
                    <h4 class="weui-media-box__title">${crmCustomer.name}</h4>
                    <p class="weui-media-box__desc">${fns:getDictLabel(crmCustomer.customerStatus, 'customer_status', '')} | ${crmCustomer.ownBy.name} | <fmt:formatDate value="${crmCustomer.createDate}" pattern="yyyy-MM-dd"/></p>
                </div>
                </c:forEach>
            </div>
            <div class="weui-panel__ft">
                <a href="${ctx}/mobile/crm/crmCustomer" class="weui-cell weui-cell_access weui-cell_link">
                    <div class="weui-cell__bd">查看更多</div>
                    <span class="weui-cell__ft"></span>
                </a>    
            </div>
        </div>
        <div class="weui-panel weui-panel_access">
            <div class="weui-panel__hd"><img src="${ctxStatic}/weui/images/app/icon_msg.png" alt="" style="width:25px;height:25px;margin-right:5px;vertical-align: middle;"> 最新跟进</div>
            <div class="weui-panel__bd">
                <c:forEach items="${crmContactRecordPage.list}" var="crmContactRecord">
                <a href="javascript:void(0);" class="weui-media-box weui-media-box_appmsg" onclick="window.location.href='${ctx}/mobile/crm/crmContactRecord/view?id=${crmContactRecord.id}'">
                    <div class="weui-media-box__hd">
                        <img class="weui-media-box__thumb" src="${crmContactRecord.createBy.photo}" onerror="this.src='${ctxStatic}/images/user.jpg'">
                    </div>
                    <div class="weui-media-box__bd">
                        <h4 class="weui-media-box__title">${crmContactRecord.createBy.name}<span class="weui-body-box_right"><fmt:formatDate value="${crmContactRecord.contactDate}" pattern="yyyy-MM-dd"/></span></h4>
                        <p class="weui-media-box__desc">[${fns:getDictLabel(crmContactRecord.targetType, 'object_type', '')}] ${crmContactRecord.targetName}</p>
                        <p class="weui-media-box__desc">${crmContactRecord.content}</p>
                    </div>
                </a>
                </c:forEach>
            </div>
            <div class="weui-panel__ft">
                <a href="${ctx}/mobile/crm/crmContactRecord/" class="weui-cell weui-cell_access weui-cell_link">
                    <div class="weui-cell__bd">查看更多</div>
                    <span class="weui-cell__ft"></span>
                </a>    
            </div>
        </div>
        <div class="weui-panel">
            <div class="weui-panel__hd"><img src="${ctxStatic}/weui/images/app/icon_rank.png" style="width:25px;height:25px;margin-right:5px;vertical-align: middle;"> 销售排行 <span class="pull-right">本月</span></div>
            <div class="weui-panel__bd">
                <div class="weui-media-box weui-media-box_small-appmsg">
                    <div class="weui-cells">
                        <c:forEach items="${crmReportRankList}" var="crmReportRank" begin="0" end="2">
                        <a class="weui-cell weui-cell_access" href="javascript:;">
                            <div class="weui-cell__hd"><img src="${crmReportRank.userPhoto }" onerror="this.src='${ctxStatic}/images/user.jpg'" style="width:20px;height:20px;margin-right:5px;display:block"></div>
                            <div class="weui-cell__bd weui-cell_primary">
                                <p>${crmReportRank.userName }</p>
                            </div>
                            <span class="weui-cell__ft">${crmReportRank.recOrderAmt }</span>
                        </a>
                        </c:forEach>
                    </div>
                </div>
            </div>
            <div class="weui-panel__ft">
                <a href="${ctx}/mobile/report" class="weui-cell weui-cell_access weui-cell_link">
                    <div class="weui-cell__bd">查看更多</div>
                    <span class="weui-cell__ft"></span>
                </a>    
            </div>
        </div>
    </div>
    <div class="page__ft">
        <br>
    </div>
</div>


	<c:set value="2" var="nav"></c:set>
	<%@ include file="foot.jsp"%>

</body>
</html>
