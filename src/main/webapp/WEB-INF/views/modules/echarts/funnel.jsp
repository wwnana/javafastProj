<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<%@ include file="/WEB-INF/views/include/echarts.jsp"%>

	<div id="funnel"  class="main000"></div>
	<echarts:funnel
	    id="funnel"
		title="销售漏斗" 
		subtitle="纯属虚构"
		orientData="${orientData}"/>