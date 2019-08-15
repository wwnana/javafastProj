<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html lang="en">
	<head>
	<meta charset="utf-8">
    <meta name="decorator" content="default"/>

	</head> 
<body class="gray-bg">
<div class="wrapper-content">
<div class="row">
            <div class="col-sm-12">
                <div class="ibox float-e-margins">
                    <div class="ibox-title">
                        <h5> ${testInterface.name == null?'服务器':testInterface.name}接口测试</h5>
                        <div class="ibox-tools">
                            <a class="collapse-link">
                                <i class="fa fa-chevron-up"></i>
                            </a>
                            <a class="dropdown-toggle" data-toggle="dropdown" href="form_basic.html#">
                                <i class="fa fa-wrench"></i>
                            </a>
                            <ul class="dropdown-menu dropdown-user">
                            </ul>
                            <a class="close-link">
                                <i class="fa fa-times"></i>
                            </a>
                        </div>
                    </div>
                    <div class="ibox-content">
                        <form method="get" class="form-horizontal">
                        
                        	<div class="form-group">
                                <label class="col-sm-2 control-label">接口类型</label>

                                <div class="col-sm-10">
                                		<input type="hidden" name="S_TYPE" id="S_TYPE" value="${testInterface.type eq 'post'?'POST':'GET'}"/>
                                       <input name="form-field-radio"  class="form-control i-checks" type="radio" value="POST" <c:if test="${testInterface.type eq 'post'}">checked="checked"</c:if> >POST
										<input name="form-field-radio"  class="form-control i-checks" type="radio" value="GET" <c:if test="${testInterface.type eq 'get'}">checked="checked"</c:if> >GET
                                </div>
                            </div>
                            <div class="hr-line-dashed"></div>
                            
                            <div class="form-group">
                                <label class="col-sm-2 control-label">请求url</label>
                                <div class="col-sm-8">
                                         <input type="text" id="serverUrl" title="输入请求地址" value="${testInterface.url }"  class="form-control width100">
                                          <%-- 
                                          <span><font color="gray">如果URL包括SESSIONID字段，请先调用登录接口，把生成的SESSIONID参数替换此处的值，否则会提示没有登录。</font></span>
                                          --%>
                                </div>
                                <div class="col-sm-2">
                                          <a class="btn btn-small btn-success" onclick="sendSever();">请求</a>
										<%--  <a class="btn btn-small btn-info" onclick="gReload();">重置</a>--%>
										 <input id="btnCancel" class="btn btn-white" type="button" value="返 回" onclick="history.go(-1)"/>
                                </div>
                                        
                              
                            </div>
                                <div class="hr-line-dashed"></div>
                              <div class="form-group">
                                <label class="col-sm-2 control-label">post body</label>
                                <div class="col-sm-8">
                                         <input type="text" id="requestBody" title="输入请求地址" value="${testInterface.body }"  class="form-control width100" >
                                          <span><font color="gray">格式:  name1=value1&name2=value2, 如果是get请求请留空。</font></span>
                                </div>
                                <div class="col-sm-2">
                                        
                                </div>
                                        
                              
                            </div>
                            <div class="hr-line-dashed"></div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label">返回结果</label>

                                <div class="col-sm-8">
                                   <textarea id="json-field" title="返回结果" class="form-control span12 width100"></textarea>
                                </div>
                                <div class="col-sm-2">
                                </div>
                            </div>
                            <div class="hr-line-dashed"></div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label">服务器响应：</label>
                                <div class="col-sm-10">
                                	<font color="red" id="stime">-</font>&nbsp;毫秒
                                </div>
                             </div>
                            <div class="hr-line-dashed"></div>
                            <div class="form-group">
                                 <label class="col-sm-2 control-label">客户端请求：</label>
                                <div class="col-sm-10">
                                	<font color="red" id="ctime">-</font>&nbsp;毫秒
                                </div>
                           </div>
                            <div class="hr-line-dashed"></div>
                         </form>
                    </div>
                </div>
            </div>
        </div>
 
 
  </div>
	
		

		<!--引入属于此页面的js -->
		<script type="text/javascript">
		var locat = (window.location+'').split('/'); 
		$(function(){if('tool'== locat[3]){locat =  locat[0]+'//'+locat[2];}else{locat =  locat[0]+'//'+locat[2]+'/'+locat[3];};});



		//重置
		function gReload(){
			$("#serverUrl").val('');
			$("#requestBody").val('');
			$("#json-field").val('');
			$("#S_TYPE_S").val('');
			$("input.i-checks:first").iCheck('check');
		}
		$('input.i-checks:radio').on('ifChecked', function(event){
			
			  $("#S_TYPE").val($(this).attr("value"));
			});
		//请求类型
		function setType(value){
			
		}

		function sendSever(){
			
			if($("#serverUrl").val()==""){
				
				top.layer.alert('输入请求地址！', {icon: 0});
				$("#serverUrl").focus();
				return false;
			}
			
			//alert($.md5(paraname+nowtime+',fh,'));
			
			var startTime = new Date().getTime(); //请求开始时间  毫秒
			//alert('${ctx}/tools/testInterface/severTest');
			$.ajax({
				type: "POST",
				//url: locat+'/home/tools/testInterface/severTest',
				url: '${ctx}/tools/testInterface/severTest',
		    	data: {serverUrl:$("#serverUrl").val(),requestBody:$("#requestBody").val(),requestMethod:$("#S_TYPE").val(),tm:new Date().getTime()},
				dataType:'json',
				cache: false,
				success: function(data){
					 if("success" == data.errInfo){
						 top.layer.alert('请求成功！', {icon: 6});
						 var endTime = new Date().getTime();  //请求结束时间  毫秒 
						 $("#ctime").text(endTime-startTime);
						 
					 }else{
						 top.layer.alert('请求失败！', {icon: 0});
						 var endTime = new Date().getTime();  //请求结束时间  毫秒 
						 $("#ctime").text(endTime-startTime);
					 }
					 
					 $("#json-field").val(data.result);
					 $("#stime").text(data.rTime);
					 
				}
			});
		}

		function intfBox(){
			var intfB = document.getElementById("json-field");
			var intfBt = document.documentElement.clientHeight;
			intfB .style.height = (intfBt  - 320) + 'px';
		}
		intfBox();
		window.onresize=function(){  
			intfBox();
		};

		//js  日期格式
		function date2str(x,y) {
		     var z ={y:x.getFullYear(),M:x.getMonth()+1,d:x.getDate(),h:x.getHours(),m:x.getMinutes(),s:x.getSeconds()};
		     return y.replace(/(y+|M+|d+|h+|m+|s+)/g,function(v) {return ((v.length>1?"0":"")+eval('z.'+v.slice(-1))).slice(-(v.length>2?v.length:2))});
		 	};
		</script>
	</body>
</html>

