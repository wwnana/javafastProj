<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<%@ include file="/WEB-INF/views/include/weuihead.jsp"%>
<html>
<head>
	<title>${crmCustomer.name }</title>
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
			location.href = "${ctx}/mobile/crm/crmCustomer";
		}, false);
    });


    //关注
    function saveCustomerStar(customerId){    	
    	var is_star = $("#label_star").hasClass("color-orange");    	    	
    	$.ajax({
    		url:"${ctx}/crm/crmCustomerStar/saveCustomerStar",
    		type:"POST",
    		async:true,    //或false,是否异步
    		data:{customerId:customerId, isStar:is_star},
    		dataType:'json',
    		success:function(data){
    			//alert(data);
    			if(is_star == false){
    				$("#label_star").addClass("color-orange");
    				$("#img_star").attr("src", "${ctxStatic}/weui/demos/images/foot_collection_fill.png");
    				alertMsg("关注成功");
    			}else{
    				$("#label_star").removeClass("color-orange");
    				$("#img_star").attr("src", "${ctxStatic}/weui/demos/images/foot_collection.png");
    				alertMsg("已取消关注");
    			}    				
    		},
    		error:function(){
    			//alert("出错");
    		}
    	});
    }
	</script>
</head>
<body ontouchstart>
<mobile:message content="${message}"/>
<div class="page">
    <div class="page__bd" style="height: 100%;">
        <div class="weui-panel weui-panel_access">
	        <div class="weui-panel__bd">
	          <div class="weui-media-box weui-media-box_text">
	            <h4 class="weui-media-box__title">
		            ${crmCustomer.name } 
		            <c:if test="${not empty crmCustomer.ownBy.id}">
		            	<span class="title_label_primary">${fns:getDictLabel(crmCustomer.customerStatus, 'customer_status', '')}</span>
		            </c:if>
		            <c:if test="${empty crmCustomer.ownBy.id}">
		            	<span class="title_label_success" >公海</span>
		            </c:if>
	            </h4>
	            <p class="weui-media-box__desc"><c:if test="${not empty crmCustomer.ownBy.id}">负责人：${crmCustomer.ownBy.name}</c:if></p>
	          </div>
	        </div>
	    </div>

        <div  class="weui-tab">
        	<div class="weui-navbar">
                <div class="weui-navbar__item weui-bar__item_on" onclick="changeTab('1')">
                    	概况
                </div>
                <div class="weui-navbar__item" onclick="changeTab('2')">
                    	详情
                </div>
                <div class="weui-navbar__item" onclick="changeTab('3')">
                    	联系人
                </div>
                <div class="weui-navbar__item" onclick="changeTab('4')">
                    	商机
                </div>
                <div class="weui-navbar__item" onclick="changeTab('5')">
                    	合同
                </div>
                <div class="weui-navbar__item" onclick="changeTab('6')">
                    	回款
                </div>
                <div class="weui-navbar__item" onclick="changeTab('7')">
                    	日志
                </div>
            </div>
            
        	
            <%-- 
            <div class="weui-navbar">
                <div class="weui-navbar__item weui-bar__item_on" onclick="changeTab('1')">
                    	概况列表
                </div>
                <div class="weui-navbar__item" onclick="changeTab('2')">
                    	详情列表
                </div>
                <div class="weui-navbar__item" onclick="changeTab('3')">
                   		联系人列表
                </div>
                <div class="weui-navbar__item" onclick="changeTab('4')">
                    	商机列表
                </div>
                <div class="weui-navbar__item" onclick="changeTab('5')">
                    	合同列表
                </div>
                <div class="weui-navbar__item" onclick="changeTab('6')">
                    	回款列表
                </div>
                <div class="weui-navbar__item" onclick="changeTab('7')">
                    	日志列表
                </div>
            </div>
            --%>
            <div class="weui-tab__panel">
				<div id="tab1">
					<div class="weui-panel weui-panel_access">
					<div class="weui-panel__hd">客户概况</div>
					<div class="weui-grids">
						<div class="weui-grid js_grid">
							<div class="weui-grid_label">¥${generalCout.totalChanceAmt}</div>
							<p class="weui-grid__label">
								<span class="weui-media-box__desc">商机总额</span>
							</p>
						</div>
						<div class="weui-grid js_grid">
							<div class="weui-grid_label">¥${generalCout.totalOrderAmt}</div>
							<p class="weui-grid__label">
								<span class="weui-media-box__desc">订单总额</span>
							</p>
						</div>
						<div class="weui-grid js_grid">
							<div class="weui-grid_label">¥${generalCout.totalReceiveAmt}</div>
							<p class="weui-grid__label">
								<span class="weui-media-box__desc">回款总额</span>
							</p>
						</div>
						<div class="weui-grid js_grid">
							<div class="weui-grid_label">¥${generalCout.totalRefundAmt}</div>
							<p class="weui-grid__label">
								<span class="weui-media-box__desc">退款总额</span>
							</p>
						</div>
					</div>
					</div>
					<div class="weui-panel weui-panel_access">
					<div class="weui-panel__bd">
		                <c:forEach items="${crmContactRecordList}" var="crmContactRecord">
		                <a href="${ctx}/mobile/crm/crmContactRecord/view?id=${crmContactRecord.id}" class="weui-media-box weui-media-box_appmsg">
		                    <div class="weui-media-box__hd">
		                        <img class="weui-media-box__thumb" src="${crmContactRecord.createBy.photo}" onerror="this.src='${ctxStatic}/images/user.jpg'">
		                    </div>
		                    <div class="weui-media-box__bd">
		                        <h4 class="weui-media-box__title">${crmContactRecord.createBy.name}</h4>
		                        <p class="weui-media-box__desc">${crmContactRecord.content}</p>
		                        <ul class="weui-media-box__info">
			                        <li class="weui-media-box__info__meta">${fns:getDictLabel(crmContactRecord.contactType, 'contact_type', '')}</li>
			                        <li class="weui-media-box__info__meta weui-media-box__info__meta_extra"><fmt:formatDate value="${crmContactRecord.contactDate}" pattern="yyyy-MM-dd"/></li>
			                        <li class="weui-media-box__info__meta weui-media-box__info__meta_extra">${fns:getTimeDiffer(crmContactRecord.createDate)}</li>
			                    </ul>
		                    </div>
		                </a>
		                </c:forEach>
		            </div>
					</div>
				</div>
				<div id="tab2">
					<div class="weui-panel weui-panel_access">  
				        <div class="weui-panel__hd">客户基本信息</div>
				        <div class="weui-panel__bd">
				          <div class="weui-media-box weui-media-box_text">
				            <h4 class="weui-media-box__title">客户分类</h4>
				            <p class="weui-media-box__desc">${fns:getDictLabel(crmCustomer.customerType, 'customer_type', '')}</p>
				          </div>
				          <div class="weui-media-box weui-media-box_text">
				            <h4 class="weui-media-box__title">客户级别</h4>
				            <p class="weui-media-box__desc">${fns:getDictLabel(crmCustomer.customerLevel, 'customer_level', '')}</p>
				          </div>
				          <div class="weui-media-box weui-media-box_text">
				            <h4 class="weui-media-box__title">客户行业</h4>
				            <p class="weui-media-box__desc">${fns:getDictLabel(crmCustomer.industryType, 'industry_type', '')}</p>
				          </div>
				          <div class="weui-media-box weui-media-box_text">
				            <h4 class="weui-media-box__title">客户来源</h4>
				            <p class="weui-media-box__desc">${fns:getDictLabel(crmCustomer.sourType, 'sour_type', '')}</p>
				          </div>
				          <div class="weui-media-box weui-media-box_text">
				            <h4 class="weui-media-box__title">公司性质</h4>
				            <p class="weui-media-box__desc">${fns:getDictLabel(crmCustomer.sourType, 'sour_type', '')}</p>
				          </div>
				          <div class="weui-media-box weui-media-box_text">
				            <h4 class="weui-media-box__title">企业规模</h4>
				            <p class="weui-media-box__desc">${fns:getDictLabel(crmCustomer.scaleType, 'scale_type', '')}</p>
				          </div>
				          <div class="weui-media-box weui-media-box_text">
				            <h4 class="weui-media-box__title">客户地址</h4>
				            <p class="weui-body-box_desc">${crmCustomer.province}${crmCustomer.city}${crmCustomer.dict}${crmCustomer.address}</p>
				          </div>
				          <div class="weui-media-box weui-media-box_text">
				            <h4 class="weui-media-box__title">客户描述</h4>
				            <p class="weui-body-box_desc">${crmCustomer.remarks}</p>
				          </div>
				          <div class="weui-media-box weui-media-box_text">
				            <h4 class="weui-media-box__title">客户标签</h4>
				            <p class="weui-body-box_desc">${crmCustomer.tags}</p>
				          </div>
				        </div>
		      		</div>
				</div>
				<div id="tab3">
					<div class="weui-panel weui-panel_access">
			            <div class="weui-panel__hd">联系人列表</div>
			            <div class="weui-panel__bd">
			                <c:forEach items="${crmContacterList}" var="crmContacter">
			                <div class="weui-media-box weui-media-box_text" onclick="javascript:location.href='${ctx}/mobile/crm/crmContacter/index?id=${crmContacter.id}'">
			                	<span class="weui-body-box_right font-green"><c:if test="${crmContacter.isDefault == 1}">首要</c:if></span>
			                    <h4 class="weui-media-box__title">${crmContacter.name}</h4>
			                    <p class="weui-media-box__desc">${crmContacter.jobType}</p>
			                    
			                    <ul class="weui-media-box__info">
			                        <li class="weui-media-box__info__meta">${crmContacter.mobile}</li>
			                    </ul>
			                </div>
			                </c:forEach>
			            </div>
			        </div>
				</div>
				<div id="tab4">
					<div class="weui-panel">
			            <div class="weui-panel__hd">商机列表</div>
			            <div class="weui-panel__bd">
			                <c:forEach items="${crmChanceList}" var="crmChance">
			                <div class="weui-media-box weui-media-box_text" onclick="javascript:location.href='${ctx}/mobile/crm/crmChance/index?id=${crmChance.id}'">
			                	<span class="weui-body-box_right <c:if test='${crmChance.periodType < 6}'>font-green</c:if> <c:if test='${crmChance.periodType == 6}'>font-red</c:if>">${fns:getDictLabel(crmChance.periodType, 'period_type', '')}</span>
			                    <h4 class="weui-media-box__title">${fns:abbr(crmChance.name,50)}</h4>
			                    <p class="weui-media-box__desc">${crmChance.remarks}</p>
			                    <ul class="weui-media-box__info">
			                        <li class="weui-media-box__info__meta">${crmChance.ownBy.name}</li>
			                        <li class="weui-media-box__info__meta weui-media-box__info__meta_extra"><fmt:formatDate value="${crmChance.createDate}" pattern="yyyy-MM-dd"/></li>
			                        <li class="weui-media-box__info__meta weui-media-box__info__meta_extra">预计金额：¥${crmChance.saleAmount}</li>
			                        <li class="weui-media-box__info__meta weui-media-box__info__meta_extra">赢单率：${fns:getDictLabel(crmChance.probability, 'probability_type', '')}</li>
			                    </ul>
			                </div>
			                </c:forEach>
			            </div>
			        </div>
				</div>
				<div id="tab5">
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
				<div id="tab6">
					<div class="weui-panel">
			            <div class="weui-panel__hd">回款列表</div>
			            <div class="weui-panel__bd">
			                <c:forEach items="${fiReceiveAbleList}" var="fiReceiveAble">
			                <div class="weui-media-box weui-media-box_text" onclick="javascript:location.href='${ctx}/mobile/fi/fiReceiveAble/view?id=${fiReceiveAble.id}'">
			                	
			                	<span class="weui-body-box_right <c:if test='${fiReceiveAble.status !=2}'>font-red</c:if>">${fns:getDictLabel(fiReceiveAble.status, 'finish_status', '')}</span>
			                    <h4 class="weui-media-box__title">${fns:abbr(fiReceiveAble.no,50)}</h4>
			                    <p class="weui-media-box__desc">¥${fiReceiveAble.amount}</p>
			                    <ul class="weui-media-box__info">
			                        <li class="weui-media-box__info__meta">${fiReceiveAble.ownBy.name}</li>
			                        <li class="weui-media-box__info__meta"><fmt:formatDate value="${fiReceiveAble.createDate}" pattern="yyyy-MM-dd"/></li>
			                    </ul>
			                </div>
			                </c:forEach>
			            </div>
			        </div>
				</div>
				<div id="tab7">
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
		for(i = 0; i <= 7; i++) {
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
            	<c:if test="${crmCustomer.lockFlag==0}">
            	<shiro:hasPermission name="crm:crmCustomer:edit">
                <div class="weui-actionsheet__cell" onclick="javascript:location.href='${ctx}/mobile/crm/crmCustomer/form?id=${crmCustomer.id}'">编辑</div>
                </shiro:hasPermission>
                
                <c:if test="${empty crmCustomer.ownBy.id}">
                <div class="weui-actionsheet__cell" onclick="javascript:location.href='${ctx}/mobile/crm/crmCustomer/receipt?id=${crmCustomer.id}'">领取</div>
                </c:if>
               
                <div class="weui-actionsheet__cell" onclick="javascript:location.href='${ctx}/mobile/crm/crmCustomer/shareForm?id=${crmCustomer.id}'"> 指派</div>
                
                 <c:if test="${crmCustomer.isPool == 0}">
                <div class="weui-actionsheet__cell" onclick="return confirmx('确认要将该客户放入公海吗？', '${ctx}/mobile/crm/crmCustomer/toPool?id=${crmCustomer.id}')">放弃</div>
                </c:if>
                <shiro:hasPermission name="crm:crmCustomer:del">
                <div class="weui-actionsheet__cell" onclick="return confirmx('确认要删除该客户吗？', '${ctx}/mobile/crm/crmCustomer/delete?id=${crmCustomer.id}')">删除</div>
                </shiro:hasPermission>
                </c:if>
                
                <c:if test="${crmCustomer.delFlag==1}">
                <shiro:hasPermission name="crm:crmCustomer:edit">
                <div class="weui-actionsheet__cell" onclick="return confirmx('确认要还原该客户吗？', '${ctx}/mobile/crm/crmCustomerRecycle/replay?id=${crmCustomer.id}')">还原</div>
                </shiro:hasPermission>
                </c:if>
                
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
            	<div class="weui-actionsheet__cell" onclick="javascript:location.href='${ctx}/mobile/crm/crmContacter/form?customer.id=${crmCustomer.id}'">新建联系人</div>
                <div class="weui-actionsheet__cell" onclick="javascript:location.href='${ctx}/mobile/crm/crmChance/form?customer.id=${crmCustomer.id}'">新建商机</div>
                <div class="weui-actionsheet__cell" onclick="javascript:location.href='${ctx}/mobile/om/omContract/form?customer.id=${crmCustomer.id}'">新建合同</div>
                <div class="weui-actionsheet__cell" onclick="javascript:location.href='${ctx}/mobile/crm/crmService/form?customer.id=${crmCustomer.id}'">新建工单</div>
                
            </div>
            <div class="weui-actionsheet__action">
                <div class="weui-actionsheet__cell" id="createActionsheetCancel">取消</div>
            </div>
        </div>
    </div>
    
    
	<div class="weui-tabbar">
                <a href="${ctx}/mobile/crm/crmContactRecord/form?targetType=20&targetId=${crmCustomer.id}&targetName=${crmCustomer.name}" class="weui-tabbar__item weui-bar__item_on">
                    <span style="display: inline-block;position: relative;">
                        <img src="${ctxStatic}/weui/demos/images/foot_editor.png" alt="" class="weui-tabbar__icon">
                        <span class="weui-badge" style="position: absolute;top: -2px;right: -13px;">${fn:length(crmContactRecordList)}</span>
                    </span>
                    <p class="weui-tabbar__label">沟通</p>
                </a>
                <a href="javascript:;" class="weui-tabbar__item" onclick="saveCustomerStar('${crmCustomer.id}')">
                    <img src="${ctxStatic}/weui/demos/images/foot_collection<c:if test='${not empty isStar}'>_fill</c:if>.png" alt="" class="weui-tabbar__icon" id="img_star">
                    <p class="weui-tabbar__label <c:if test='${not empty isStar}'>color-orange</c:if>" id="label_star">关注</p>
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
	</script>
	
</body>
</html>