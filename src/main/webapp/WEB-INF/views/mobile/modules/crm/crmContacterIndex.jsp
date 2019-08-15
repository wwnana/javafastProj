<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<%@ include file="/WEB-INF/views/include/weuihead.jsp"%>
<html>
<head>
	<title>${crmContacter.name }</title>
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
			location.href = "${ctx}/mobile/crm/crmContacter";
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
	            <h4 class="weui-media-box__title">${crmContacter.name } <span class="title_label_primary">${fns:getDictLabel(crmContacter.roleType, 'role_type', '')}</span></h4>
            	<p class="weui-media-box__desc">归属客户：${crmContacter.customer.name}</p>
            	<p class="weui-media-box__desc">负责人：${crmContacter.ownBy.name}</p>
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
                    	日志
                </div>
            </div>
            <div class="weui-tab__panel">
				<div id="tab1">
					
					
					<div class="weui-panel weui-panel_access">
					<div class="weui-panel__hd">沟通概况</div>
					<div class="weui-panel__bd">
		                <c:forEach items="${crmContactRecordList}" var="crmContacterRecord">
		                <a href="${ctx}/mobile/crm/crmContacterRecord/view?id=${crmContacterRecord.id}" class="weui-media-box weui-media-box_appmsg">
		                    <div class="weui-media-box__hd">
		                        <img class="weui-media-box__thumb" src="${crmContacterRecord.createBy.photo}" onerror="this.src='${ctxStatic}/images/user.jpg'">
		                    </div>
		                    <div class="weui-media-box__bd">
		                        <h4 class="weui-media-box__title">${crmContacterRecord.createBy.name}</h4>
		                        <p class="weui-media-box__desc">${crmContacterRecord.content}</p>
		                        <ul class="weui-media-box__info">
			                        <li class="weui-media-box__info__meta"></li>
			                        <li class="weui-media-box__info__meta"><fmt:formatDate value="${crmContacterRecord.contactDate}" pattern="yyyy-MM-dd"/></li>
			                        <li class="weui-media-box__info__meta weui-media-box__info__meta_extra">${fns:getTimeDiffer(crmContacterRecord.createDate)}</li>
			                    </ul>
		                    </div>
		                </a>
		                </c:forEach>
		            </div>
					</div>
				</div>
				<div id="tab2">
					<div class="weui-panel weui-panel_access">  
				        <div class="weui-panel__hd">基本信息</div>
				        <div class="weui-panel__bd">
				          <div class="weui-media-box weui-media-box_text" onclick="javascript:window.location.href='${ctx}/mobile/crm/crmCustomer/index?id=${crmContacter.customer.id}'">
				            <h4 class="weui-media-box__title">客户</h4>
				            <p class="weui-media-box__desc">${crmContacter.customer.name}</p>
				          </div>
				          <div class="weui-media-box weui-media-box_text">
				            <h4 class="weui-media-box__title">职务</h4>
				            <p class="weui-media-box__desc">${crmContacter.jobType}</p>
				          </div>
				          <div class="weui-media-box weui-media-box_text">
				            <h4 class="weui-media-box__title">角色</h4>
				            <p class="weui-media-box__desc">${fns:getDictLabel(crmContacter.roleType, 'role_type', '')}</p>
				          </div>
				          <div class="weui-media-box weui-media-box_text">
				            <h4 class="weui-media-box__title">性别</h4>
				            <p class="weui-media-box__desc">${fns:getDictLabel(crmContacter.sex, 'sex', '')}</p>
				          </div>
				          <div class="weui-media-box weui-media-box_text">
				            <h4 class="weui-media-box__title">手机号码</h4>
				            <p class="weui-media-box__desc">${crmContacter.mobile}</p>
				          </div>
				          <div class="weui-media-box weui-media-box_text">
				            <h4 class="weui-media-box__title">电子邮箱</h4>
				            <p class="weui-media-box__desc">${crmContacter.email}</p>
				          </div>
				          <div class="weui-media-box weui-media-box_text">
				            <h4 class="weui-media-box__title">微信</h4>
				            <p class="weui-media-box__desc">${crmContacter.wx}</p>
				          </div>
				          <div class="weui-media-box weui-media-box_text">
				            <h4 class="weui-media-box__title">QQ</h4>
				            <p class="weui-media-box__desc">${crmContacter.qq}</p>
				          </div>
				          <div class="weui-media-box weui-media-box_text">
				            <h4 class="weui-media-box__title">客户描述</h4>
				            <p class="weui-media-box__desc">${crmContacter.remarks}</p>
				          </div>
				        </div>
		      		</div>
				</div>
				
				
				
				<div id="tab3">
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
		for(i = 0; i <= 3; i++) {
			$("#tab" + i).hide(); //将所有的层都隐藏
		}
		$("#tab" + ltab_num).show(); //显示当前层
	}
</script>



	<div class="weui-tabbar">
     	<shiro:hasPermission name="crm:crmContacter:edit">
     	<a href="${ctx}/mobile/crm/crmContacter/form?id=${crmContacter.id}" class="weui-tabbar__item weui-navbar__item">
	          <p class="">编辑</p>
		</a>
		</shiro:hasPermission>
		
	 </div>

   
</body>
</html>