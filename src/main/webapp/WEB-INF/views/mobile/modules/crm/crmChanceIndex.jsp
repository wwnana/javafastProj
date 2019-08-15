<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<%@ include file="/WEB-INF/views/include/weuihead.jsp"%>
<html>
<head>
	<title>${crmChance.name }</title>
	<style type="text/css">
	.color-orange{
		color: #f8ac59;
	}
	.weui-grid_label {
		text-align: center;
		color: #4C84C4;
	}
	.weui-grid {
		width:25%;
		border: 0 !important;
	}
	.weui-cell__bd {
		font-size: 13px;
	}
	.weui-grid:before{
		border-right: 0;
	}
	.weui-grid:after{
		border-bottom: 0;
	}
	
	</style>
    <script type="text/javascript">
    $(function(){ 
    	//监听返回事件
		pushHistory();
		window.addEventListener("popstate", function(e) {
			location.href = "${ctx}/mobile/crm/crmChance";
		}, false);
    });
   
	</script>
</head>
<body ontouchstart>
<mobile:message content="${message}"/>
<div class="page">
    <div class="page__bd" style="height: 100%;">
        <div class="weui-panel weui-panel_access">
	        <div class="weui-panel__bd">
	          <div class="weui-media-box weui-media-box_text">
	            <h4 class="weui-media-box__title">${crmChance.name } <span class="title_label_primary">${fns:getDictLabel(crmChance.periodType, 'period_type', '')}</span></h4>
            <p class="weui-media-box__desc">负责人：${crmChance.ownBy.name}</p>
	          </div>
	        </div>
	    </div>
        <div class="weui-tab">
            <div class="weui-navbar">
                <div class="weui-navbar__item weui-bar__item_on" onclick="changeTab('1')">
                    	概况
                </div>
                <div class="weui-navbar__item" onclick="changeTab('2')">
                    	详情
                </div>
                <div class="weui-navbar__item" onclick="changeTab('3')">
                    	合同
                </div>
                <div class="weui-navbar__item" onclick="changeTab('4')">
                    	日志
                </div>
            </div>
            <div class="weui-tab__panel">
				<div id="tab1">
					
					
					<div class="weui-panel weui-panel_access">
					<div class="weui-panel__hd">商机概况</div>
					<div class="weui-panel__bd">
		                <c:forEach items="${crmContactRecordList}" var="crmChanceRecord">
		                <a href="${ctx}/mobile/crm/crmChanceRecord/view?id=${crmChanceRecord.id}" class="weui-media-box weui-media-box_appmsg">
		                    <div class="weui-media-box__hd">
		                        <img class="weui-media-box__thumb" src="${crmChanceRecord.createBy.photo}" onerror="this.src='${ctxStatic}/images/user.jpg'">
		                    </div>
		                    <div class="weui-media-box__bd">
		                        <h4 class="weui-media-box__title">${crmChanceRecord.createBy.name}</h4>
		                        <p class="weui-media-box__desc">${crmChanceRecord.content}</p>
		                        <ul class="weui-media-box__info">
			                        <li class="weui-media-box__info__meta"></li>
			                        <li class="weui-media-box__info__meta"><fmt:formatDate value="${crmChanceRecord.contactDate}" pattern="yyyy-MM-dd"/></li>
			                        <li class="weui-media-box__info__meta weui-media-box__info__meta_extra">${fns:getTimeDiffer(crmChanceRecord.createDate)}</li>
			                    </ul>
		                    </div>
		                </a>
		                </c:forEach>
		            </div>
					</div>
				</div>
				<div id="tab2">
					<div class="weui-panel weui-panel_access">  
				        <div class="weui-panel__hd">商机基本信息</div>
				        <div class="weui-panel__bd">
				          <div class="weui-media-box weui-media-box_text" onclick="javascript:window.location.href='${ctx}/mobile/crm/crmCustomer/index?id=${crmChance.customer.id}'">
				            <h4 class="weui-media-box__title">客户</h4>
				            <p class="weui-media-box__desc">${crmChance.customer.name}</p>
				          </div>
				          <div class="weui-media-box weui-media-box_text">
				            <h4 class="weui-media-box__title">销售阶段</h4>
				            <p class="weui-media-box__desc">${fns:getDictLabel(crmChance.periodType, 'period_type', '')}</p>
				          </div>
				          <div class="weui-media-box weui-media-box_text">
				            <h4 class="weui-media-box__title">预计销售金额(元)</h4>
				            <p class="weui-media-box__desc">${crmChance.saleAmount}</p>
				          </div>		          
				          <div class="weui-media-box weui-media-box_text">
				            <h4 class="weui-media-box__title">商机类型</h4>
				            <p class="weui-media-box__desc">${fns:getDictLabel(crmChance.changeType, 'change_type', '')}</p>
				          </div>
				          <div class="weui-media-box weui-media-box_text">
				            <h4 class="weui-media-box__title">商机来源</h4>
				            <p class="weui-media-box__desc">${fns:getDictLabel(crmChance.sourType, 'sour_type', '')}</p>
				          </div>
				          <div class="weui-media-box weui-media-box_text">
				            <h4 class="weui-media-box__title">预计赢单率</h4>
				            <p class="weui-media-box__desc">${fns:getDictLabel(crmChance.probability, 'probability_type', '')}</p>
				          </div>
				          <div class="weui-media-box weui-media-box_text">
				            <h4 class="weui-media-box__title">商机描述</h4>
				            <p class="weui-body-box_desc">${crmChance.remarks}</p>
				          </div>
				        </div>
		      		</div>
				</div>
				
				<div id="tab3">
					<div class="weui-panel">
			            <div class="weui-panel__hd">合同列表</div>
			            <div class="weui-panel__bd">
			                <c:forEach items="${omContractList}" var="omContract">
			                <div class="weui-media-box weui-media-box_text" onclick="javascript:location.href='${ctx}/mobile/om/omContract/index?id=${omContract.id}'">
			                	<span class="weui-body-box_right <c:if test='${omContract.status == 0}'>font-red</c:if><c:if test='${omContract.status == 1}'>font-blue</c:if>">${fns:getDictLabel(omContract.status, 'audit_status', '')}</span>
			                    <h4 class="weui-media-box__title">${fns:abbr(omContract.name,50)}</h4>
			                    <p class="weui-media-box__desc">¥${omContract.amount}</p>
			                    <ul class="weui-media-box__info">
			                        <li class="weui-media-box__info__meta">${omContract.ownBy.name}</li>
			                        <li class="weui-media-box__info__meta"><fmt:formatDate value="${omContract.dealDate}" pattern="yyyy-MM-dd"/></li>
			                    </ul>
			                </div>
			                </c:forEach>
			            </div>
			        </div>
				</div>
				
				<div id="tab4">
					<div class="weui-panel weui-panel_access">
			            <div class="weui-panel__hd">操作日志列表</div>
			            <div class="weui-panel__bd">
			                <c:forEach items="${sysDynamicList }" var="sysDynamic">
			                <div class="weui-media-box weui-media-box_text">
			                    <h4 class="weui-media-box__title"><fmt:formatDate value="${sysDynamic.createDate}" pattern="yyyy-MM-dd HH:mm"/> </h4>
			                    <p class="weui-media-box__desc">${sysDynamic.createBy.name} <i>${fns:getDictLabel(sysDynamic.actionType, 'action_type', '')}了</i> <strong>${fns:getDictLabel(sysDynamic.objectType, 'object_type', '')} </strong> ${sysDynamic.targetName}</p>
			                </div>
			                </c:forEach>
			            </div>
			        </div>
				</div>
            </div>
        </div>
    </div>
</div>
<script type="text/javascript">
    $(function(){
        $('.weui-navbar__item').on('click', function () {
            $(this).addClass('weui-bar__item_on').siblings('.weui-bar__item_on').removeClass('weui-bar__item_on');
        });
    });
	changeTab(1);
	function changeTab(ltab_num) {
		for(i = 0; i <= 4; i++) {
			$("#tab" + i).hide(); //将所有的层都隐藏
		}
		$("#tab" + ltab_num).show(); //显示当前层
	}
</script>





    
    <!--BEGIN actionSheet-->
    <div>
        <div class="weui-mask" id="operateMask" style="display: none"></div>
        <div class="weui-actionsheet" id="operateActionsheet">
            <div class="weui-actionsheet__title">
                <p class="weui-actionsheet__title-text">操作菜单</p>
            </div>
            <div class="weui-actionsheet__menu">
            	<shiro:hasPermission name="crm:crmChance:edit">
                	<div class="weui-actionsheet__cell" onclick="javascript:location.href='${ctx}/mobile/crm/crmChance/form?id=${crmChance.id}'">编辑</div>
                </shiro:hasPermission>
                <shiro:hasPermission name="crm:crmChance:del">
                	<div class="weui-actionsheet__cell" onclick="return confirmx('确认要删除该商机吗？', '${ctx}/mobile/crm/crmChance/delete?id=${crmChance.id}')">删除</div>
                </shiro:hasPermission>
            </div>
            <div class="weui-actionsheet__action">
                <div class="weui-actionsheet__cell" id="operateActionsheetCancel">取消</div>
            </div>
        </div>
        
        <div class="weui-mask" id="createMask" style="display: none"></div>
        <div class="weui-actionsheet" id="createActionsheet">
            <div class="weui-actionsheet__title">
                <p class="weui-actionsheet__title-text">快速创建</p>
            </div>
            <div class="weui-actionsheet__menu">
                <div class="weui-actionsheet__cell" onclick="javascript:location.href='${ctx}/mobile/om/omContract/form?chance.id=${crmChance.id}&customer.id=${crmChance.customer.id}'">新建合同</div>
                
            </div>
            <div class="weui-actionsheet__action">
                <div class="weui-actionsheet__cell" id="createActionsheetCancel">取消</div>
            </div>
        </div>
        
        <div class="weui-mask" id="periodMask" style="display: none"></div>
        <div class="weui-actionsheet" id="periodActionsheet">
            <div class="weui-actionsheet__title">
                <p class="weui-actionsheet__title-text">请选择阶段</p>
            </div>
            <div class="weui-actionsheet__menu">
            	<c:forEach items="${fns:getDictList('period_type')}" var="dict">
            		
                	<div class="weui-actionsheet__cell" onclick="updatePeriodType('${crmChance.id}', '${crmChance.periodType}', '${dict.value}', '${dict.label}')">
                		
                		<c:if test="${dict.value == crmChance.periodType}"><i class="weui-icon-success-no-circle"></i></c:if>
                		<c:if test="${dict.value != crmChance.periodType}">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</c:if>
                		${dict.label}
                		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                	</div>
                	
                </c:forEach>
            </div>
            <div class="weui-actionsheet__action">
                <div class="weui-actionsheet__cell" id="periodActionsheetCancel">取消</div>
            </div>
        </div>
    </div>
    
    
	<div class="weui-tabbar">
                <a href="${ctx}/mobile/crm/crmContactRecord/form?targetType=22&targetId=${crmChance.id}&targetName=${crmChance.name}" class="weui-tabbar__item weui-bar__item_on">
                    <span style="display: inline-block;position: relative;">
                        <img src="${ctxStatic}/weui/demos/images/foot_editor.png" alt="" class="weui-tabbar__icon">
                        <span class="weui-badge" style="position: absolute;top: -2px;right: -13px;">${fn:length(crmContactRecordList)}</span>
                    </span>
                    <p class="weui-tabbar__label">沟通</p>
                </a>
                <a href="javascript:;" class="weui-tabbar__item" id="showPeriodActionSheet">
                    <img src="${ctxStatic}/weui/demos/images/foot_dynamic.png" alt="" class="weui-tabbar__icon" id="img_star">
                    <p class="weui-tabbar__label">进阶</p>
                </a>
                <a href="javascript:;" class="weui-tabbar__item" id="showCreateActionSheet">
                    <span style="display: inline-block;position: relative;">
                        <img src="${ctxStatic}/weui/demos/images/foot_addition_fill.png" alt="" class="weui-tabbar__icon">
                        <span class="weui-badge weui-badge_dot" style="position: absolute;top: 0;right: -6px;"></span>
                    </span>
                    <p class="weui-tabbar__label">新建</p>
                </a>
                <a href="javascript:;" class="weui-tabbar__item" id="showOperateActionSheet">
                    <img src="${ctxStatic}/weui/demos/images/foot_set.png" alt="" class="weui-tabbar__icon">
                    <p class="weui-tabbar__label">操作</p>
                </a>
            </div>
	
    
    <script type="text/javascript">
	    //操作菜单
	    $(function(){
	        var $operateActionsheet = $('#operateActionsheet');
	        var $operateMask = $('#operateMask');
	
	        function hideActionSheet() {
	            $operateActionsheet.removeClass('weui-actionsheet_toggle');
	            $operateMask.fadeOut(200);
	        }
	
	        $operateMask.on('click', hideActionSheet);
	        $('#operateActionsheetCancel').on('click', hideActionSheet);
	        $("#showOperateActionSheet").on("click", function(){
	            $operateActionsheet.addClass('weui-actionsheet_toggle');
	            $operateMask.fadeIn(200);
	        });
	    });
		//创建菜单
	    $(function(){
	        var $createActionsheet = $('#createActionsheet');
	        var $createMask = $('#createMask');
	
	        function hideActionSheet() {
	            $createActionsheet.removeClass('weui-actionsheet_toggle');
	            $createMask.fadeOut(200);
	        }
	
	        $createMask.on('click', hideActionSheet);
	        $('#createActionsheetCancel').on('click', hideActionSheet);
	        $("#showCreateActionSheet").on("click", function(){
	            $createActionsheet.addClass('weui-actionsheet_toggle');
	            $createMask.fadeIn(200);
	        });
	    });
		//进阶菜单
		$(function(){
	        var $periodActionsheet = $('#periodActionsheet');
	        var $periodMask = $('#periodMask');
	
	        function hideActionSheet() {
	            $periodActionsheet.removeClass('weui-actionsheet_toggle');
	            $periodMask.fadeOut(200);
	        }
	
	        $periodMask.on('click', hideActionSheet);
	        $('#periodActionsheetCancel').on('click', hideActionSheet);
	        $("#showPeriodActionSheet").on("click", function(){
	            $periodActionsheet.addClass('weui-actionsheet_toggle');
	            $periodMask.fadeIn(200);
	        });
	    });
		//进阶
		function updatePeriodType(id, oldPeriodType, newPeriodType, newPeriodName){
			
			if(oldPeriodType == newPeriodType){
				return;
			}
			var title = "您确定更新销售阶段为\""+newPeriodName+"\"吗？";
			var url = "${ctx}/mobile/crm/crmChance/updateChancePeriod?id="+id+"&periodType="+newPeriodType;
			
			//询问框
			  layer.open({
			    content: title
			    ,btn: ['确定', '取消']
			    ,yes: function(index){
			    	window.location.href = url;
			    }
			  });
		}
	</script>
</body>
</html>