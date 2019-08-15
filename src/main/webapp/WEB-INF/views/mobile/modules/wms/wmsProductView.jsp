<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<%@ include file="/WEB-INF/views/include/weuihead.jsp"%>
<html>
<head>
	<title>${wmsProduct.name }</title>
    <script type="text/javascript">
    $(function(){ 
    	//监听返回事件
		pushHistory();
		window.addEventListener("popstate", function(e) {
			location.href = "${ctx}/mobile/wms/wmsProduct";
		}, false);
    });
	</script>
</head>
<body ontouchstart>
<mobile:message content="${message}"/>
<div class="page-content">
	<div class="weui-panel weui-panel_access">
        <div class="weui-panel__bd">
          <div class="weui-media-box weui-media-box_text">
            <h4 class="weui-media-box__title">${wmsProduct.name } <span class="title_label_primary">${fns:getDictLabel(wmsProduct.status, 'use_status', '')}</span></h4>
            <p class="weui-media-box__desc">${wmsProduct.no}</p>
          </div>
        </div>
      </div>
    
			<div class="weui-panel weui-panel_access">
        
		        <div class="weui-panel__bd">
		          
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">产品分类</h4>
		            <p class="weui-media-box__desc">${wmsProduct.productType.name}</p>
		          </div>
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">产品编码</h4>
		            <p class="weui-media-box__desc">${wmsProduct.no}</p>
		          </div>
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">产品名称</h4>
		            <p class="weui-media-box__desc">${wmsProduct.name}</p>
		          </div>
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">基本单位</h4>
		            <p class="weui-media-box__desc">${fns:getDictLabel(wmsProduct.unitType, 'unit_type', '')}</p>
		          </div>
		          <div class="weui-media-box weui-media-box_text" >
		            <h4 class="weui-media-box__title">产品规格</h4>
		            <p class="weui-media-box__desc">${wmsProduct.spec}</p>
		          </div>
		         
		          		          
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">产品价格</h4>
		            <p class="weui-media-box__desc">${wmsProduct.salePrice}</p>
		          </div>
		          
		          
		         
		        </div>
		        
		        
      		</div>
      		<div class="weui-panel weui-panel_access">
        
		        <div class="weui-panel__bd">
		        	<div class="weui-media-box weui-media-box_text">
			            <h4 class="weui-media-box__title">产品描述</h4>
			            <p class="weui-body-box_desc">${wmsProduct.wmsProductData.content }</p>
			          </div>
		        </div>
		    </div>
      		
    		
    
     <div class="weui-tabbar">
     	
     	
     	<shiro:hasPermission name="wms:wmsProduct:edit">
		<a href="${ctx}/mobile/wms/wmsProduct/form?id=${wmsProduct.id}" class="weui-tabbar__item weui-navbar__item">
	          <p class="">编辑</p>
		</a>
		</shiro:hasPermission>
		
		
		
	 </div>
</div>
</body>
</html>