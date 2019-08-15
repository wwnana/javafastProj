<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<%@ attribute name="hideType" type="java.lang.String" required="false" description="显示类型"%><!-- 0:隐藏tip, 1隐藏box,不设置显示全部 -->
<%@ attribute name="content" type="java.lang.String" required="true" description="消息内容"%>
<%@ attribute name="type" type="java.lang.String" description="消息类型：info、success、warning、error、loading"%>
<%-- <script type="text/javascript">top.$.jBox.closeTip();</script>--%>
<c:if test="${not empty content}">
	<c:if test="${not empty type}">
	<c:set var="ctype" value="${type}"/></c:if>
	<c:if test="${empty type}">
	<c:set var="ctype" value="${fn:indexOf(content,'失败') eq -1?'success':'danger'}"/>
	</c:if>
	<script type="text/javascript">
			if('${ctype}' == 'success'){
				  //提示
				  layer.open({
				    content: '${content}'
				    ,skin: 'msg'
				    ,time: 2 //2秒后自动关闭
				  });
			}else{
				//提示
				  layer.open({
				    content: '${content}'
				    ,skin: 'msg'
				    ,time: 2 //2秒后自动关闭
				  });
			}
			
		</script>
</c:if>