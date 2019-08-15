<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>充值订单微信支付</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
	$(document).ready(function() {
		createWxPayQrCode();
	});
	//生成微信支付二维码
	function createWxPayQrCode(){
		
		$.ajax({
			type: "POST",
			url: '${ctx}/pay/wxPay/createWxPayCode',
	    	data: {orderId:'${payRechargeOrder.id}',notes:'${payRechargeOrder.notes}'},
			dataType:'json',
			cache: false,
			success: function(data){
				 
				 if(data.success){
					 $("#encoderImgId").attr("src",data.body.filePath);       
				 }else{
					 top.layer.alert('微信支付二维码生成失败！', {icon: 0});
					 return false;
				 }
			}
		});
		return true;
	}
	</script>
</head>
<body class="white-bg">

    <div class="wrapper-content gray-bg">
		<div class="row">
			<div class="col-sm-12">
                      <label>订单编号：</label>
                      ${payRechargeOrder.no }
                     
                      <label>订单金额：</label>
                      ${payRechargeOrder.amount }
             </div>
             <div class="col-sm-12">
                      <label>商品信息：</label>
                     	 ${payRechargeOrder.notes }
             </div>
          </div>
	</div>
	<div class="wrapper">
		<div class="row mt10">
			<div class="col-sm-12">
                <div  style="border: 1px solid #FF6600;border-radius: 4px;">
    
                    <div class="" style="margin: 10px 10px 0px 10px;">
                    	<div class="row">
	                            <div class="col-sm-6">
	                            	<img alt="" src="${ctxStatic }/images/WePayLogo.png" height="20px">
	                            </div>
	                            <div class="col-sm-6">
	                            	<p class="text-right">支付金额：<span class="text-warning">${payRechargeOrder.amount}</span>元</p>
	                            </div>
	                    </div>
						
					</div>
                </div>
        	</div>    
        </div>                    
		
		<div class="row mt10">
			<div class="col-sm-12">
				<img id="encoderImgId" width="120px">
			</div>
		</div>
		<div class="row mt10">
			<div class="col-sm-12">
				<img alt="" src="${ctxStatic }/images/WePayDesc.png" width="120px">
			</div>
		</div>
		<div class="row">
			<div class="col-sm-12">
				<div class="hr-line-dashed"></div>
				<p>温馨提示：本次支付只做演示，扫码付款后会真实扣款，若有疑问请咨询客服</p>
			</div>
		</div>
	</div>
</body>
</html>