<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<%@ attribute name="name" type="java.lang.String" required="true" description="隐藏域名称（ID）"%>
<%@ attribute name="value" type="java.lang.String" required="true" description="隐藏域值（ID）"%>
<%@ attribute name="format" type="java.lang.String" required="true" description="日期格式"%>
<%@ attribute name="cssClass" type="java.lang.String" required="false" description="css样式"%>

<div class="input-group" data-autoclose="true">
	<input name="${name}" type="text" readonly="readonly" class="form-control" value='<fmt:formatDate value="${value}" pattern="${format}"/>' onclick="WdatePicker({dateFmt:'${format}',isShowClear:true});" >
	<span class="input-group-addon">
		<span class="fa fa-calendar"></span>
	</span>
</div>