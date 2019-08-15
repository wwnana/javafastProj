<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<%@ attribute name="replace" type="java.lang.String" required="true" description="需要替换的textarea编号"%>
<%@ attribute name="uploadPath" type="java.lang.String" required="false" description="文件上传路径，路径后自动添加年份。若不指定，则编辑器不可上传文件"%>
<%@ attribute name="height" type="java.lang.String" required="false" description="编辑器高度"%>
<%@ attribute name="maxlength" type="java.lang.String" required="false" description="最大输入长度"%>
<link href="${ctxStatic}/umeditor/themes/default/css/umeditor.css" type="text/css" rel="stylesheet" />
<style type="text/css">

</style>
    
    <script type="text/javascript" src="${ctxStatic}/umeditor/third-party/template.min.js"></script>
    <script type="text/javascript" charset="utf-8" src="${ctxStatic}/umeditor/umeditor.config.js"></script>
    <script type="text/javascript" charset="utf-8" src="${ctxStatic}/umeditor/umeditor.min.js"></script>
    <script type="text/javascript" src="${ctxStatic}/umeditor/lang/zh-cn/zh-cn.js"></script>
<script type="text/javascript">
	
	var um = UM.getEditor('${replace}');
	
	var maxlength = "${maxlength}";
	if(maxlength != null && maxlength != ''){
		um.addListener("keyup", function(type, event) {
			
			var count = um.getContentLength(true);
			if(count>maxlength){
			var contentText = um.getContentTxt();
			um.setContent(contentText.substring(0, maxlength));
			}
		});
	}
	
</script>