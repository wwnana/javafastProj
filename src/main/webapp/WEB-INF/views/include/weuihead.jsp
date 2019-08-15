<%@ page contentType="text/html;charset=UTF-8" %>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no">

<link rel="stylesheet" href="${ctxStatic}/weui/src/lib/weui.css" type="text/css">

<%-- 
<link rel="stylesheet" href="http://cdn.bootcss.com/weui/0.4.3/style/weui.min.css" type="text/css">
<link rel="stylesheet" href="http://cdn.bootcss.com/jquery-weui/0.8.0/css/jquery-weui.min.css" type="text/css">
--%>

<link rel="stylesheet" href="${ctxStatic}/weui/demos/css/demos.css">

<link href="${ctxStatic}/awesome/4.4/css/font-awesome.min.css" rel="stylesheet" />

<script src="${ctxStatic}/weui/src/lib/jquery-2.1.4.js"></script>
<script src="${ctxStatic}/weui/src/lib/fastclick.js"></script>
<script type="text/javascript">
    $(function() {
        FastClick.attach(document.body);
    });
</script>

<script src="http://cdn.bootcss.com/jquery-weui/0.8.0/js/jquery-weui.min.js"></script>

<script src="${ctxStatic}/layer-v2.3/mobile/layer.js"></script>

<script src="${ctxStatic}/weui/extend/zepto.weui.js"></script>
<link rel="stylesheet" href="${ctxStatic}/weui/extend/extend.css">

<script type="text/javascript">
	//消息提示框
	function alertMsgBox(msg){
		layer.open({
		    content: msg
		    ,btn: '我知道了'
		});
	}
	function alertMsg(msg){
		//提示
		layer.open({
		    content: msg
		    ,skin: 'msg'
		    ,time: 2 //2秒后自动关闭
		});
	}
	//消息确认框
	function confirmx(title, url){
		layer.open({
		    content: title
		    ,btn: ['确定', '取消']
		    ,yes: function(index){
		    	//layer.close(index);
		    	window.location.href = url;
		    }
		});
	}
	//返回监听
	function pushHistory() {
		var state = {
			title : "title",
			url : "#"
		};
		window.history.pushState(state, "title", "#");
	}
	//获取数据字典LIST的方法
	function getDictList(type){
		var list;
		$.ajax({
			url:"${ctx}/sys/dict/listDataJson",
			data: {type:type},
			type:"POST",
			async:false,    //或false,是否异步
			dataType:'json',
			success:function(data){
				if(data != null){
					list = data;
				}
			},
    		error:function(){
    			alert("服务器未响应");
    		}
		});
		return list;
	}
	//获取数据字典的标签
	function getDictLabel(dict_list, dict_value){
		for(var i=0;i<dict_list.length;i++){
			if(dict_list[i].value == dict_value){
				return dict_list[i].label;
			}
		}
	}
	//客户选择器
	function selectCustomer(){
		
		var iframeHeight = document.body.clientHeight + "px";
		var html = "<iframe src=\"${ctx}/mobile/crm/crmCustomer/selectList\" style=\"border:0;width: 100%;height: "+iframeHeight+"\"></iframe>";
		
		var pageii = layer.open({
			  type: 1
			  ,content: html
			  ,anim: 'up'
			  ,style: 'position:fixed; left:0; top:0; width:100%; height:100%; border: none; -webkit-animation-duration: .5s; animation-duration: .5s;'
		});
	}
	
</script>
<style type="text/css">
		img {
			border-radius:3px;
		}
		.table>thead>tr>th{
			 border-collapse: collapse;
			border: 1px solid #D9D9D9;
			font-weight: 400;
			font-size: 12px;
		}
		.table>tbody>tr>td{
			 border-collapse: collapse;
			border: 1px solid #D9D9D9;
			font-weight: 400;
			font-size: 12px;
		}
		.page-content{
			padding-bottom: 50px;
		}
		.page{
			padding-bottom: 50px;
		}
		.weui-bar__item_on {
			border-bottom: 0 !important;
		}
		.weui-bar__item_on .weui-tabbar__label {
		    color: #2F7DCD !important;
		}
		.weui-tab{
			height: auto !important;
			position: relative;
			padding-bottom: 50px;
		}
    	.weui-tabbar{
    		position:fixed;
    		bottom: 0;
    		clear:both;
    	}
		.weui-bar__item_on{
			border-bottom: 2px solid #2F7DCD;
			color: #333 !important;
		}
		.weui-navbar__item{
			color: #999;
		}
		.weui-media-box__title{
			/*font-size: 15px;*/
		}
		.demos-title{
			/*font-size: 20px !important;*/
		}
		.weui-body-box_desc {
		    color: #999999;
		    font-size: 13px;
		    line-height: 1.2;
		}
		.weui-body-box_right {
		    color: #999999;
		    font-size: 13px;
		    line-height: 1.2;
		    padding-top: 5px;
		    float: right;
		}
		.pull-right {
		    float: right;
		}
		.red {
	    	color: #ef4f4f !important;
	    	font-size: 12px !important;
	    }
		.font-blue {
	    	color: #18b4ed !important;
		}
		.font-green {
		    color: #04be02 !important;
		}
		.font-red {
		    color: #ef4f4f !important;
		}
		.font-orange {
			color: #ff7f0d;
		}
		.weui-form-preview__value{
			font-size: 18px;
		}
		body{
			font-family: -apple-system-font,Helvetica Neue,Helvetica,sans-serif;
  			background-color: #f8f8f8;
		}
		.weui-grid {
		    background: #fff !important;
		}
		.title_label_success{
			padding: 2px 2px 1px 2px;
			vertical-align: middle;
			font-size: 10px;
			border: 1px solid #1AAD19;
			border-radius: 2px;
		}
		.title_label_primary{
			padding: 2px 2px 1px 2px;
			vertical-align: middle;
			font-size: 10px;
			border: 1px solid #4C84C4;
			border-radius:2px;
		}
		.text_label_warning{
			color: orange;
		}
		.margin0{
			margin: 0 !important;
		}
		.margin-top0{
			margin-top:0px !important;
		}
		.margin-bottom10{
			margin-bottom: 10px;
		}
		.searchbar-result{
			margin-top:0px !important;
			margin-bottom: 10px;
		}
		.weui-media-box__thumb{
			width:60px;
			height:60px;
		}
		
		.layui-m-layerbtn span[yes] {
		    color: #467DB9;
		}
		.layui-m-layerbtn span {
		    font-size: 18px;
		}
		.layui-m-layerbtn {
		    border-top: 1px solid #E0E0E0;
		    background-color: #FFFFFF;
		}
		.layui-m-layercont {
		    font-size: 15px;
		}
		.weui-grid__icon{
		  width:45px !important;
		  height:45px !important;
		  margin:0 auto;
		}
		.weui-loadmore__tips {
			background-color: #f8f8f8 !important;
		}
		.weui-navigator-list li {
		    line-height: 50px;
		    font-size: 16px;
		}
</style>

      
