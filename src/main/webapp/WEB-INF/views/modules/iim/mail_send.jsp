<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html>

<head>

    <meta charset="utf-8">
    <meta name="decorator" content="default"/>
     <!-- SUMMERNOTE -->
	 <link href="${ctxStatic}/summernote/summernote.css" rel="stylesheet">
	 <link href="${ctxStatic}/summernote/summernote-bs3.css" rel="stylesheet">
	 <script src="${ctxStatic}/summernote/summernote.min.js"></script>
	 <script src="${ctxStatic}/summernote/summernote-zh-CN.js"></script>
	<style type="text/css">
	.note-editor .note-editable {
	    min-height: 300px !important;
	}
	</style>
</head>

<body class="gray-bg">
    <div class="wrapper-content">
        <div class="row">
            <div class="col-sm-2">
            	
                <div class="ibox float-e-margins">
                    <div class="ibox-content mailbox-content">
                        <div class="file-manager">
                            <a class="btn btn-block btn-success compose-mail" href="${ctx}/iim/mailCompose/sendLetter">写信</a>
                            <div class="space-25"></div>
                            <h5>文件夹</h5>
                            <ul class="folder-list m-b-md" style="padding: 0">
                                <li>
                                    <a href="${ctx}/iim/mailBox/list?orderBy=sendtime desc"> <i class="fa fa-inbox "></i> 收件箱 <span class="label label-warning pull-right">${noReadCount}/${mailBoxCount}</span>
                                    </a>
                                </li>
                                <li>
                                    <a href="${ctx}/iim/mailCompose/list?status=1&orderBy=sendtime desc"> <i class="fa fa-envelope-o"></i> 已发送<span class="label label-info pull-right">${mailComposeCount}</span></a>
                                </li>
                                <li>
                                    <a href="${ctx}/iim/mailCompose/list?status=0&orderBy=sendtime desc"> <i class="fa fa-file-text-o"></i> 草稿箱 <span class="label label-danger pull-right">${mailDraftCount}</span>
                                    </a>
                                </li>
                            </ul>
                            
                            <div class="clearfix"></div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-sm-10 animated fadeInRight">
                <div class="mail-box-header">
                    <div class="pull-right tooltip-demo">
                    	<button type="button" class="btn btn-success  btn-sm" onclick="sendLetter()"> <i class="fa fa-reply"></i> 发送</button>
                    	<a href="${ctx}/iim/mailBox/list" class="btn btn-danger btn-sm" data-toggle="tooltip" data-placement="top" title="放弃"><i class="fa fa-times"></i> 放弃</a>
                       <button type="button" class="btn btn-white  btn-sm" onclick="saveLetter()"> <i class="fa fa-pencil"></i> 存为草稿</button>
                        
                        <button type="button" class="btn btn-white  btn-sm" onclick="history.go(-1)"> 返 回</button>
                    </div>
                    <h2>
                    写信
                </h2>
                </div>
               
                <div class="mail-box">


                    <div class="mail-body">
					<form:form id="inputForm" modelAttribute="mailBox" action="${ctx}/iim/mailCompose/save" method="post" class="form-horizontal">
                            <div class="form-group">
                                <label class="col-sm-2 control-label"><font color="red">*</font>发送到：</label>

                                <div class="col-sm-8">
                                  		 <sys:treeselect id="receiver" name="receiverIds" value="${receiver.id}" labelName="receiverNames" labelValue="${receiver.name}"
								title="用户" url="/sys/office/treeData?type=3" cssClass="form-control required" notAllowSelectParent="true" checked="true"/>
                                  <!--  <input type="text" class="form-control" value="${receiver.name}">
                                    <input type="hidden" id="receiver" name="receiver" value="${receiver.id }">-->
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label"><font color="red">*</font>主题：</label>

                                <div class="col-sm-8">
                                    <input type="text" id="title" name="mail.title"  class="form-control required" value="">
                                </div>
                            </div>
                          <input type="hidden" id="status" name="status" value="1"><!-- 0 草稿  1 已发送 -->
                          <input type="hidden" id="overview" name="mail.overview"><!-- 内容简介 -->
                    	  <input type="hidden" id="content" name="mail.content"><!-- 内容 -->
 					</form:form>	
                    </div>

                    <div class="mail-text h-200">

                        <div class="summernote">
                           

                        </div>
                        <div class="clearfix"></div>
                    </div>
                    <div class="mail-body text-right tooltip-demo">
                    	
                    	 <button type="button" class="btn btn-success  btn-sm" onclick="sendLetter()"> <i class="fa fa-reply"></i> 发送</button>
                        <a href="${ctx}/iim/mailBox/list" class="btn btn-danger btn-sm" data-toggle="tooltip" data-placement="top" title="Discard email"><i class="fa fa-times"></i> 放弃</a>
                   		 <button type="button" class="btn btn-white  btn-sm" onclick="saveLetter()"> <i class="fa fa-pencil"></i> 存为草稿</button>
                   		 <button type="button" class="btn btn-white  btn-sm" onclick="history.go(-1)"> 返 回</button>
                    </div>
                    <div class="clearfix"></div>



                </div>
            
            </div>
			
        </div>
        
    </div>



    <script>
        $(document).ready(function () {
            $('.i-checks').iCheck({
                checkboxClass: 'icheckbox_square-green',
                radioClass: 'iradio_square-green',
            });


            $('.summernote').summernote({
                lang: 'zh-CN'
            });

            

        });
        var edit = function () {
            $('.click2edit').summernote({
                focus: true
            });
        };
        var save = function () {
            var aHTML = $('.click2edit').code(); //save HTML If you need(aHTML: array).
            $('.click2edit').destroy();
        };

        function sendLetter(){
            if($("#receiverRecordId").val()==''){
            	top.layer.alert('收件人不能为空！', {icon: 0});
            	return;
            }
            if($("#title").val()==''){
              	top.layer.alert('标题不能为空！', {icon: 0});
              	return;
              }
            $("#status").val("1");
			$("#content").val($(".note-editable").html());
			$("#overview").val($(".note-editable").text().substring(0,20));
			var index = layer.load(1, {
			    shade: [0.3,'#fff'] //0.1透明度的白色背景
			});
			$("#inputForm").submit();
	    }
        function saveLetter(){
        	if($("#title").val()==''){
              	top.layer.alert('标题不能为空！', {icon: 0});
              	return;
              }
            $("#status").val("0");
			$("#content").val($(".note-editable").html());
			$("#overview").val($(".note-editable").text().substring(0,20));
			var index = layer.load(1, {
			    shade: [0.3,'#fff'] //0.1透明度的白色背景
			});
			$("#inputForm").submit();
	    }
    </script>

</body>

</html>