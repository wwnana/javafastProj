<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<%@ attribute name="id" type="java.lang.String" required="true" description="编号"%>
<%@ attribute name="name" type="java.lang.String" required="false" description="隐藏域名称（ID）"%>
<%@ attribute name="value" type="java.lang.String" required="false" description="隐藏域值（ID）"%>
<%@ attribute name="labelName" type="java.lang.String" required="false" description="输入框名称（Name）"%>
<%@ attribute name="labelValue" type="java.lang.String" required="false" description="输入框值（Name）"%>
<%@ attribute name="fieldLabels" type="java.lang.String" required="false" description="表格Th里显示的名字"%>
<%@ attribute name="fieldKeys" type="java.lang.String" required="false" description="表格Td里显示的值"%>
<%@ attribute name="searchLabel" type="java.lang.String" required="false" description="表格Td里显示的值"%>
<%@ attribute name="searchKey" type="java.lang.String" required="false" description="表格Td里显示的值"%>
<%@ attribute name="title" type="java.lang.String" required="false" description="选择框标题"%>
<%@ attribute name="url" type="java.lang.String" required="true" description="数据地址"%>
<%@ attribute name="cssClass" type="java.lang.String" required="false" description="css样式"%>
<%@ attribute name="cssStyle" type="java.lang.String" required="false" description="css样式"%>
<%@ attribute name="disabled" type="java.lang.String" required="false" description="是否限制选择，如果限制，设置为disabled"%>
<%@ attribute name="allowEmpty" type="java.lang.Boolean" required="false" description="是否允许显示空选项"%>
<script type="text/javascript">
$(function () {
    $.post("${url}", { "action": "one" }, function (data) {
        var table = data;
       
        $("#${id}Id").empty();//首先清空select现在有的内容
        if('${allowEmpty}' == "true"){
        	$("#${id}Id").append("<option selected='selected' value=''></option>");
        }
        
        for (var i = 0; i < table.length; i++) {
            var item = table[i];
            if('${value}'!=null && '${value}'==item.id){
            	$("#${id}Id").append("<option selected='selected' value=" + item.id + ">" + item.name + "</option>");
            }else{
            	$("#${id}Id").append("<option value=" + item.id + ">" + item.name + "</option>");
            }          
        }
        //返回的是json格式的数据
    }, "json");

});
</script>

<select id="${id}Id" name="${name}" class="${cssClass}" style="min-width: 163px;" multiple="multiple">
</select>

	
