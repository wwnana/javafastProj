<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<%@ include file="/WEB-INF/views/include/weuihead.jsp"%>
<html>
<head>
	<title>${fiReceiveAble.name }</title>
    <script type="text/javascript">
    $(function(){ 
    	//监听返回事件
		pushHistory();
		window.addEventListener("popstate", function(e) {
			location.href = "${ctx}/mobile/fi/fiReceiveAble";
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
		            <h4 class="weui-media-box__title">${fiReceiveAble.no } <span class="title_label_primary">${fns:getDictLabel(fiReceiveAble.status, 'finish_status', '')}</span></h4>
		            <p class="weui-media-box__desc">应收：${fiReceiveAble.amount}，实收：${fiReceiveAble.realAmt }
		            			<c:if test="${(fiReceiveAble.amount - fiReceiveAble.realAmt) > 0}">
									（差额：<span class="text_label_warning">${fiReceiveAble.amount - fiReceiveAble.realAmt}</span>）
								</c:if>	
								</p>
		            <p class="weui-media-box__desc">负责人：${fiReceiveAble.ownBy.name}</p>
		          </div>
		        </div>
		      </div>
      
			<div class="weui-tab">
				<div class="weui-navbar">
					<div class="weui-navbar__item weui-bar__item_on" onclick="changeTab('1')">基本信息</div>
					<div class="weui-navbar__item" onclick="changeTab('2')">收款单</div>
				</div>
				<div class="weui-tab__panel">
					<div id="tab1">
						<div class="weui-panel weui-panel_access">
				            <div class="weui-panel__bd">
		          
					          <div class="weui-media-box weui-media-box_text">
					            <h4 class="weui-media-box__title">应收款编码</h4>
					            <p class="weui-media-box__desc">${fiReceiveAble.no}</p>
					          </div>
					          <div class="weui-media-box weui-media-box_text">
					            <h4 class="weui-media-box__title">应收款状态</h4>
					            <p class="weui-media-box__desc">${fns:getDictLabel(fiReceiveAble.status, 'finish_status', '')}</p>
					          </div>
					          <div class="weui-media-box weui-media-box_text" onclick="javascript:window.location.href='${ctx}/mobile/crm/crmCustomer/index?id=${fiReceiveAble.customer.id}'">
					            <h4 class="weui-media-box__title">客户</h4>
					            <p class="weui-media-box__desc">${fiReceiveAble.customer.name}</p>
					          </div>
					          <div class="weui-media-box weui-media-box_text" onclick="javascript:window.location.href='${ctx}/mobile/om/omContract/index?id=${fiReceiveAble.order.id}'">
					            <h4 class="weui-media-box__title">订单合同</h4>
					            <p class="weui-media-box__desc">${fiReceiveAble.order.no}</p>
					          </div>
					         
					          		          
					          <div class="weui-media-box weui-media-box_text">
					            <h4 class="weui-media-box__title">应收金额</h4>
					            <p class="weui-media-box__desc">${fiReceiveAble.amount }	</p>
					          </div>
					          <div class="weui-media-box weui-media-box_text">
					            <h4 class="weui-media-box__title">实际已收</h4>
					            <p class="weui-media-box__desc">${fiReceiveAble.realAmt }	</p>
					          </div>
					          <div class="weui-media-box weui-media-box_text">
					            <h4 class="weui-media-box__title">应收日期</h4>
					            <p class="weui-media-box__desc"><fmt:formatDate value="${fiReceiveAble.ableDate}" pattern="yyyy-MM-dd"/></p>
					          </div>
					          
					          <div class="weui-media-box weui-media-box_text">
					            <h4 class="weui-media-box__title">备注</h4>
					            <p class="weui-body-box_desc">${fiReceiveAble.remarks }</p>
					          </div>
					         
					        </div>
				            
				        </div>
					</div>
					<div id="tab2">
						<div class="">
				            
				            <div class="">
				                <c:forEach items="${fiReceiveAble.fiReceiveBillList}" var="fiReceiveBill">
				               	<div class="weui-form-preview">
						            <div class="weui-form-preview__hd">
						                <div class="weui-form-preview__item">
						                    <label class="weui-form-preview__label">收款金额</label>
						                    <em class="weui-form-preview__value">¥${fiReceiveBill.amount }</em>
						                </div>
						            </div>
						            <div class="weui-form-preview__bd">
						                <div class="weui-form-preview__item">
						                    <label class="weui-form-preview__label">收款日期</label>
						                    <span class="weui-form-preview__value"><fmt:formatDate value="${fiReceiveBill.dealDate}" pattern="yyyy-MM-dd"/></span>
						                </div>
						                <div class="weui-form-preview__item">
						                    <label class="weui-form-preview__label">负责人</label>
						                    <span class="weui-form-preview__value">${fiReceiveBill.ownBy.name}</span>
						                </div>
						                <div class="weui-form-preview__item">
						                    <label class="weui-form-preview__label">状态</label>
						                    <span class="weui-form-preview__value">${fns:getDictLabel(fiReceiveBill.status, 'audit_status', '')}</span>
						                </div>
						            </div>
						            <div class="weui-form-preview__ft">
						            	<c:if test="${fiReceiveBill.status == 0}">
											<shiro:hasPermission name="fi:fiReceiveBill:edit">
						    					<a class="weui-form-preview__btn weui-form-preview__btn_default" href="${ctx}/fi/fiReceiveBill/form?id=${fiReceiveBill.id}" >修改</a>
											</shiro:hasPermission>
											<shiro:hasPermission name="fi:fiReceiveBill:del">
												<a class="weui-form-preview__btn weui-form-preview__btn_default" href="javascript:" onclick="return confirmx('确认要删除该收款单吗？', '${ctx}/fi/fiReceiveBill/delete?id=${fiReceiveBill.id}')" >删除</a> 
											</shiro:hasPermission>
											<shiro:hasPermission name="fi:fiReceiveBill:audit">
												<button class="weui-form-preview__btn weui-form-preview__btn_primary" href="javascript:" onclick="return confirmx('确认要审核该收款单吗？', '${ctx}/fi/fiReceiveBill/audit?id=${fiReceiveBill.id}')" >审核</button> 
											</shiro:hasPermission>
										</c:if>
																	
						            </div>
						        </div>
						        <br>
				                </c:forEach>
				            </div>
				        </div>
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
			for (i = 0; i <= 2; i++) {
				$("#tab" + i).hide(); //将所有的层都隐藏
			}
			$("#tab" + ltab_num).show(); //显示当前层
		}
	</script>
	
	
	
	
	
	
	
      		
    		
    
     <div class="weui-tabbar">
     	
     	<%-- 
     	<shiro:hasPermission name="fi:fiReceiveAble:edit">
		<a href="${ctx}/mobile/fi/fiReceiveAble/form?id=${fiReceiveAble.id}" class="weui-tabbar__item weui-navbar__item">
	          <p class="">编辑</p>
		</a>
		</shiro:hasPermission>
		--%>
		<c:if test="${fiReceiveAble.status != 2}">
		<a href="${ctx}/mobile/fi/fiReceiveBill/form?fiReceiveAble.id=${fiReceiveAble.id}" class="weui-tabbar__item weui-navbar__item">
	          <p class="">新建收款单</p>
		</a>
		</c:if>
	 </div>
</div>
</body>
</html>