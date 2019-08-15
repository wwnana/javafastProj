<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<%@ include file="/WEB-INF/views/include/weuihead.jsp"%>
<html>
<head>
	<title>${omContract.name }</title>
    <script type="text/javascript">
    $(function(){ 
    	//监听返回事件
		pushHistory();
		window.addEventListener("popstate", function(e) {
			location.href = "${ctx}/mobile/om/omContract";
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
            <h4 class="weui-media-box__title">${omContract.name } <span class="title_label_primary">${fns:getDictLabel(omContract.status, 'audit_status', '')}</span></h4>
            <p class="weui-media-box__desc">¥${omContract.amount} ${omContract.ownBy.name} <fmt:formatDate value="${omContract.dealDate}" pattern="yyyy-MM-dd"/></p>
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
		          
					          <div class="weui-media-box weui-media-box_text" onclick="javascript:window.location.href='${ctx}/mobile/crm/crmCustomer/index?id=${omContract.customer.id}'">
					            <h4 class="weui-media-box__title">客户</h4>
					            <p class="weui-media-box__desc">${omContract.customer.name}</p>
					          </div>
					          <div class="weui-media-box weui-media-box_text" onclick="javascript:location.href='${ctx}/mobile/crm/crmChance/index?id=${omContract.chance.id}'">
					            <h4 class="weui-media-box__title">来源商机</h4>
					            <p class="weui-media-box__desc">${omContract.chance.name}</p>
					          </div>
					          <div class="weui-media-box weui-media-box_text">
					            <h4 class="weui-media-box__title">合同编号</h4>
					            <p class="weui-media-box__desc">${omContract.no}</p>
					          </div>
					          <div class="weui-media-box weui-media-box_text">
					            <h4 class="weui-media-box__title">合同总额(元)</h4>
					            <p class="weui-media-box__desc">${omContract.amount}</p>
					          </div>
					          <div class="weui-media-box weui-media-box_text">
					            <h4 class="weui-media-box__title">签约日期</h4>
					            <p class="weui-media-box__desc"><fmt:formatDate value="${omContract.dealDate}" pattern="yyyy-MM-dd"/></p>
					          </div>
					          <div class="weui-media-box weui-media-box_text">
					            <h4 class="weui-media-box__title">交付日期</h4>
					            <p class="weui-media-box__desc"><fmt:formatDate value="${omContract.deliverDate}" pattern="yyyy-MM-dd"/></p>
					          </div>
					          <div class="weui-media-box weui-media-box_text">
					            <h4 class="weui-media-box__title">合同状态</h4>
					            <p class="weui-media-box__desc">${fns:getDictLabel(omContract.status, 'audit_status', '')}</p>
					          </div>
					          <div class="weui-media-box weui-media-box_text">
					            <h4 class="weui-media-box__title">描述</h4>
					            <p class="weui-body-box_desc">${omContract.remarks}</p>
					          </div>
					         
					        </div>
				            
				        </div>
					</div>
					<div id="tab2">
						<div class="">
				            
				            <div class="">
				            
				            	
								          
				                <c:forEach items="${omContract.omOrderDetailList}" var="omOrderDetail">
				               	<div class="weui-form-preview">
						            <div class="weui-form-preview__hd">
						                <div class="weui-form-preview__item">
						                    <label class="weui-form-preview__label">产品名称</label>
						                    <em class="weui-form-preview__value">${omOrderDetail.product.name}</em>
						                </div>
						            </div>
						            <div class="weui-form-preview__bd">
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
						            	<c:if test="${omContract.status == 0}">
						            		
						            		<%-- 
											<shiro:hasPermission name="fi:fiReceiveBill:edit">
						    					<a class="weui-form-preview__btn weui-form-preview__btn_default" href="${ctx}/fi/fiReceiveBill/form?id=${fiReceiveBill.id}" >修改</a>
											</shiro:hasPermission>
											<shiro:hasPermission name="fi:fiReceiveBill:del">
												<a class="weui-form-preview__btn weui-form-preview__btn_default" href="javascript:" onclick="return confirmx('确认要删除该收款单吗？', '${ctx}/fi/fiReceiveBill/delete?id=${fiReceiveBill.id}')" >删除</a> 
											</shiro:hasPermission>
											<shiro:hasPermission name="fi:fiReceiveBill:audit">
												<button class="weui-form-preview__btn weui-form-preview__btn_primary" href="javascript:" onclick="return confirmx('确认要审核该收款单吗？', '${ctx}/fi/fiReceiveBill/audit?id=${fiReceiveBill.id}')" >审核</button> 
											</shiro:hasPermission>
											--%>
										</c:if>
																	
						            </div>
						        </div>
						        <br>
				                </c:forEach>
				                	<div class="weui-media-box weui-media-box_text">
								            <h4 class="weui-media-box__title">合计</h4>
								            <p class="weui-media-box__desc">总数量：${omContract.order.num}，总计：${omContract.order.totalAmt}，其他费用：${omContract.order.otherAmt}</p>
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
            	<c:if test="${omContract.status == 0}">
            	<shiro:hasPermission name="om:omContract:edit">
                	<div class="weui-actionsheet__cell" onclick="javascript:location.href='${ctx}/mobile/om/omContract/form?id=${omContract.id}'">编辑</div>
                </shiro:hasPermission>
                <shiro:hasPermission name="om:omContract:del">
                	<div class="weui-actionsheet__cell" onclick="return confirmx('确认要删除该合同吗？', '${ctx}/mobile/om/omContract/delete?id=${omContract.id}')">删除</div>
                </shiro:hasPermission>
                <shiro:hasPermission name="om:omContract:audit">
                	<div class="weui-actionsheet__cell" onclick="return confirmx('确认要审核该合同吗？', '${ctx}/mobile/om/omContract/audit?id=${omContract.id}')">审核</div>
                </shiro:hasPermission>
                </c:if>
            </div>
            <div class="weui-actionsheet__action">
                <div class="weui-actionsheet__cell" id="operateActionsheetCancel">取消</div>
            </div>
        </div>
     </div>
      
     <div class="weui-tabbar">
     	<c:if test="${omContract.status == 0}">
		<shiro:hasPermission name="om:omContract:add">
		
				<a class="weui-tabbar__item" href="${ctx}/mobile/om/omOrderDetail/form?order.id=${omContract.id}" class="weui-tabbar__item weui-navbar__item">
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