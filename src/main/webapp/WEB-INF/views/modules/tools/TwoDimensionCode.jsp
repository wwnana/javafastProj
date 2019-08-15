<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>接口管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
	var locat = (window.location+'').split('/'); 
	$(function(){if('tool'== locat[3]){locat =  locat[0]+'//'+locat[2];}else{locat =  locat[0]+'//'+locat[2]+'/'+locat[3];};});


	//清除空格
	String.prototype.trim=function(){
	     return this.replace(/(^\s*)|(\s*$)/g,'');
	};

	//====================上传二维码=================
	$(document).ready(function(){
		var str='';
		$("#uploadify1").uploadify({
			'buttonImg'	: 	locat+"/static/img/twoDimensonCode.png",
			'uploader'	:	locat+"/static/uploadify/uploadify.swf",
			'script'    :	locat+"/static/uploadify/uploadFile.jsp;sessionid="+sessionid,
			'cancelImg' :	locat+"/static/uploadify/cancel.png",
			'folder'	:	locat+"/uploadFiles/twoDimensionCode",//上传文件存放的路径,请保持与uploadFile.jsp中PATH的值相同
			'queueId'	:	"fileQueue",
			'queueSizeLimit'	:	1,//限制上传文件的数量
			//'fileExt'	:	"*.rar,*.zip",
			//'fileDesc'	:	"RAR *.rar",//限制文件类型
			'fileExt'     : '*.jpg;*.gif;*.png',
			'fileDesc'    : 'Please choose(.JPG, .GIF, .PNG)',
			'auto'		:	false,
			'multi'		:	true,//是否允许多文件上传
			'simUploadLimit':	2,//同时运行上传的进程数量
			'buttonText':	"files",
			'scriptData':	{'uploadPath':'/uploadFiles/twoDimensionCode/'},//这个参数用于传递用户自己的参数，此时'method' 必须设置为GET, 后台可以用request.getParameter('name')获取名字的值
			'method'	:	"GET",
			'onComplete':function(event,queueId,fileObj,response,data){
				str = response.trim();//单个上传完毕执行
			},
			'onAllComplete' : function(event,data) {
				//alert(str);	//全部上传完毕执行
				readContent(str);
	    	},
	    	'onSelect' : function(event, queueId, fileObj){
	    		$("#hasTp1").val("ok");
	    	}
		});
				
	});
	//====================上传二维码=================

	function uploadTwo(){
		if($("#uploadify1").val()){
			top.layer.alert('请选择二维码！', {icon: 0});
		return false;
		}
		$('#uploadify1').uploadifyUpload();
	}	

	//去后台解析二维码返回解析内容
	function readContent(str){
		$.ajax({
			type: "POST",
			url: locat+'/a/tools/TwoDimensionCodeController/readTwoDimensionCode',
	    	data: {imgId:str,tm:new Date().getTime()},
			dataType:'json',
			cache: false,
			success: function(data){
				 if("success" == data.result){
					 if('null' == data.readContent || null == data.readContent){
						 top.layer.alert('读取失败，二维码无效！', {icon: 0});
					 }else{
						 $("#readContent").text(data.readContent);
					 }
				 }else{
					 top.layer.alert('后台读取出错！', {icon: 0});
					 return;
				 }
			}
		});
	}

	//生成二维码
	function createTwoD(){
		
		if($("#encoderContent").val()==""){
			top.layer.alert('输入框不能为空！', {icon: 0});
			$("#encoderContent").focus();
			return false;
		}
		$.ajax({
			type: "POST",
			url: '${ctx}/tools/TwoDimensionCodeController/createTwoDimensionCode.do',
	    	data: {encoderContent:$("#encoderContent").val(),tm:new Date().getTime()},
			dataType:'json',
			cache: false,
			success: function(data){
				 
				 if(data.success){
					 $("#encoderImgId").attr("src",data.body.filePath);       
				 }else{
					 top.layer.alert('生成二维码失败！', {icon: 0});
					 return false;
				 }
				 
				 
			}
		});
		return true;
	}
	</script>
</head>
<body>
	

		
<body class="gray-bg">
	<div class="wrapper-content">
	<div class="ibox">
	<div class="ibox-title">
		<h5>二维码测试 </h5>
		<div class="ibox-tools">
			<a class="collapse-link">
				<i class="fa fa-chevron-up"></i>
			</a>
			<a class="dropdown-toggle" data-toggle="dropdown" href="#">
				<i class="fa fa-wrench"></i>
			</a>
			<ul class="dropdown-menu dropdown-user">
				<li><a href="#">选项1</a>
				</li>
				<li><a href="#">选项2</a>
				</li>
			</ul>
			<a class="close-link">
				<i class="fa fa-times"></i>
			</a>
		</div>
	</div>
    
    <div class="ibox-content">
       <form class="form-horizontal">
    	<div class="form-group">
             <div class="col-sm-2">二维码内容</div>

             <div class="col-sm-8">
             		<input type="text" id="encoderContent" title="输入内容" value="http://demo.javafast.cn" class="form-control width100">
             		<span  class="help-inline">请输入要生成二维码的字符串</span>
             </div>
             <div class="col-sm-2">
             		<a class="btn btn-small btn-success" onclick="createTwoD();">生成</a>
             </div>
         </div>
         <div class="hr-line-dashed"></div>
         
         <div class="form-group">
         	<div class="col-sm-2">二维码图像</div>

             <div class="col-sm-8">
             	<img id="encoderImgId" cache="false"  width="265px" height="265px;"  class="block"/>
             	 <span class="help-inline">使用微信扫一扫</span>
            </div>
           
         </div>
       </form>
    </div>
    </div>
    </div>
</body>
</html>