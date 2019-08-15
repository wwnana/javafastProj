<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<%@ include file="/WEB-INF/views/include/weuihead.jsp"%>
<html>
<head>
	<title>${omOrder.name }</title>
    <script type="text/javascript">
    $(function(){ 
    	//监听返回事件
		pushHistory();
		window.addEventListener("popstate", function(e) {
			location.href = "${ctx}/mobile/om/omOrder";
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
            <h4 class="weui-media-box__title">${omOrder.no } <span class="title_label_primary">${fns:getDictLabel(omOrder.status, 'audit_status', '')}</span></h4>
            <p class="weui-media-box__desc">${omOrder.customer.name}</p>
            		<ul class="weui-media-box__info">
                        <li class="weui-media-box__info__meta">¥${omOrder.amount}</li>
                        <li class="weui-media-box__info__meta weui-media-box__info__meta_extra">${omOrder.ownBy.name}</li>
                        <li class="weui-media-box__info__meta weui-media-box__info__meta_extra"><fmt:formatDate value="${omOrder.dealDate}" pattern="yyyy-MM-dd"/></li>
                    </ul>
          </div>
        </div>
      </div>
      
      <div class="weui-tab">
				<div class="weui-navbar">
					<div class="weui-navbar__item weui-bar__item_on" onclick="changeTab('1')">基本信息</div>
					<div class="weui-navbar__item" onclick="changeTab('2')">订单明细</div>
					<div class="weui-navbar__item" onclick="changeTab('3')">回款</div>
				</div>
				<div class="weui-tab__panel">
					<div id="tab1">
						<div class="weui-panel weui-panel_access">
				            <div class="weui-panel__bd">
		          
					          <div class="weui-media-box weui-media-box_text" onclick="javascript:window.location.href='${ctx}/mobile/crm/crmCustomer/index?id=${omOrder.customer.id}'">
					            <h4 class="weui-media-box__title">客户</h4>
					            <p class="weui-media-box__desc">${omOrder.customer.name}</p>
					          </div>
					          
					          <div class="weui-media-box weui-media-box_text">
					            <h4 class="weui-media-box__title">订单编号</h4>
					            <p class="weui-media-box__desc">${omOrder.no}</p>
					          </div>
					          <div class="weui-media-box weui-media-box_text">
					            <h4 class="weui-media-box__title">订单总额(元)</h4>
					            <p class="weui-media-box__desc">${omOrder.amount}</p>
					          </div>
					          <div class="weui-media-box weui-media-box_text">
					            <h4 class="weui-media-box__title">创建日期</h4>
					            <p class="weui-media-box__desc"><fmt:formatDate value="${omOrder.createDate}" pattern="yyyy-MM-dd"/></p>
					          </div>
					          <div class="weui-media-box weui-media-box_text">
					            <h4 class="weui-media-box__title">订单状态</h4>
					            <p class="weui-media-box__desc">${fns:getDictLabel(omOrder.status, 'audit_status', '')}</p>
					          </div>
					          <div class="weui-media-box weui-media-box_text">
					            <h4 class="weui-media-box__title">描述</h4>
					            <p class="weui-body-box_desc">${omOrder.remarks}</p>
					          </div>
					         
					        </div>
				            
				        </div>
					</div>
					<div id="tab2">
						<div class="">
				            
				            <div class="">
				            
				            	
								<div class="weui-panel__hd"></div>          
				                <c:forEach items="${omOrder.omOrderDetailList}" var="omOrderDetail">
				               	
				               	<div class="weui-form-preview">
						           
						            <div class="weui-form-preview__bd">
						                <div class="weui-form-preview__item">
						                    <label class="weui-form-preview__label">产品名称</label>
						                    <span class="weui-form-preview__value">${omOrderDetail.product.name}</span>
						                </div>
						                <div class="weui-form-preview__item">
						                    <label class="weui-form-preview__label">单价</label>
						                    <span class="weui-form-preview__value">¥${omOrderDetail.price}</span>
						                </div>
						                <div class="weui-form-preview__item">
						                    <label class="weui-form-preview__label">数量</label>
						                    <span class="weui-form-preview__value">${omOrderDetail.num}</span>
						                </div>
						                <div class="weui-form-preview__item">
						                    <label class="weui-form-preview__label">金额</label>
						                    <span class="weui-form-preview__value">¥${omOrderDetail.amount}</span>
						                </div>
						              
						            </div>						            		
								          
						            <div class="weui-form-preview__ft">
						            	<c:if test="${omOrder.status == 0}">
											<shiro:hasPermission name="om:omOrder:edit">
						    					<a class="weui-form-preview__btn weui-form-preview__btn_primary" href="${ctx}/mobile/om/omOrderDetail/form?id=${omOrderDetail.id}" >修改</a>
											</shiro:hasPermission>
											<shiro:hasPermission name="om:omOrder:del">
												<a class="weui-form-preview__btn weui-form-preview__btn_primary" href="javascript:" onclick="return confirmx('确认要删除该明细吗？', '${ctx}/mobile/om/omOrderDetail/delete?id=${omOrderDetail.id}')" >删除</a> 
											</shiro:hasPermission>
										</c:if>
																	
						            </div>
						        </div>
						        </c:forEach>
						        <br>
						        
				                <div class="weui-media-box weui-media-box_text">
								            <h4 class="weui-media-box__title">合计</h4>
								            <p class="weui-media-box__desc">总数量：${omOrder.num}，总计：${omOrder.totalAmt}，其他费用：${omOrder.otherAmt}</p>
								</div>
				            </div>
				        </div>
					</div>
					<div id="tab3">
						
						<c:forEach items="${fiReceiveAbleList}" var="fiReceiveAble">
						<div class="weui-form-preview">
				            <div class="weui-form-preview__hd">
				                <label class="weui-form-preview__label">付款金额</label>
				                <em class="weui-form-preview__value">¥${fiReceiveAble.amount}</em>
				            </div>
				            <div class="weui-form-preview__bd">
				                <div class="weui-form-preview__item">
				                    <label class="weui-form-preview__label">已收</label>
				                    <span class="weui-form-preview__value">${fiReceiveAble.realAmt}</span>
				                </div>
				                <div class="weui-form-preview__item">
				                    <label class="weui-form-preview__label">差额</label>
				                    <span class="weui-form-preview__value">
                 						<c:if test="${(fiReceiveAble.amount - fiReceiveAble.realAmt) > 0}">
											<span class="text_label_warning">${fiReceiveAble.amount - fiReceiveAble.realAmt}</span>
										</c:if>	</span>
				                </div>
				                
				            </div>
				            <div class="weui-form-preview__ft">
       						<c:if test="${fiReceiveAble.status != 2}">
       									<%-- 
								<shiro:hasPermission name="fi:fiReceiveAble:edit">
			    					<a  class="weui-form-preview__btn weui-form-preview__btn_default" href="${ctx}/fi/fiReceiveAble/editForm?id=${fiReceiveAble.id}" title="修改">修改</a>
								</shiro:hasPermission>
								--%>
								<shiro:hasPermission name="fi:fiReceiveBill:add">
			    					<a class="weui-form-preview__btn weui-form-preview__btn_primary" href="${ctx}/fi/fiReceiveBill/form?fiReceiveAble.id=${fiReceiveAble.id}&fiReceiveAble.name=${fiReceiveAble.no}&customer.id=${fiReceiveAble.customer.id}&customer.name=${fiReceiveAble.customer.name}" title="添加收款单">添加收款单</a>
								</shiro:hasPermission>
								
							</c:if>
																	
				              
				            </div>
				        </div>
				        </c:forEach>
				        
					</div>
					
					
				</div>
			</div>
		</div>
	</div>
	<script type="text/javascript">
		$(function() {
			$('.weui-navbar__item').on(
					'click',
					function() {
						$(this).addClass('weui-bar__item_on').siblings(
								'.weui-bar__item_on').removeClass(
								'weui-bar__item_on');
					});
		});
		changeTab(1);
		function changeTab(ltab_num) {
			for (i = 0; i <= 3; i++) {
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
            	<shiro:hasPermission name="om:omOrder:edit">
                	<div class="weui-actionsheet__cell" onclick="javascript:location.href='${ctx}/mobile/om/omOrder/form?id=${omOrder.id}'">编辑</div>
                </shiro:hasPermission>
                <shiro:hasPermission name="om:omOrder:del">
                	<div class="weui-actionsheet__cell" onclick="return confirmx('确认要删除该订单吗？', '${ctx}/mobile/om/omOrder/delete?id=${omOrder.id}')">删除</div>
                </shiro:hasPermission>
                <shiro:hasPermission name="om:omOrder:audit">
                	<div class="weui-actionsheet__cell" onclick="return confirmx('确认要审核该订单吗？', '${ctx}/mobile/om/omOrder/audit?id=${omOrder.id}')">审核</div>
                </shiro:hasPermission>
            </div>
            <div class="weui-actionsheet__action">
                <div class="weui-actionsheet__cell" id="operateActionsheetCancel">取消</div>
            </div>
        </div>
     </div>
      
     <div class="weui-tabbar">
     	<c:if test="${omOrder.status == 0}">
		<shiro:hasPermission name="om:omOrder:add">
		
				<a class="weui-tabbar__item" href="${ctx}/mobile/om/omOrderDetail/form?order.id=${omOrder.id}" class="weui-tabbar__item weui-navbar__item">
			          <i class="fa fa-plus weui-tabbar__icon"></i>
			          <p class="weui-tabbar__label">添加订单明细</p>
				</a>
		
				<a href="javascript:;" class="weui-tabbar__item" id="showOperateActionSheet">
                    <img src="${ctxStatic}/weui/demos/images/foot_set.png" alt="" class="weui-tabbar__icon">
                    <p class="weui-tabbar__label">操作</p>
                </a>
		</shiro:hasPermission>
		</c:if>
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
	  </script>
</body>
</html>