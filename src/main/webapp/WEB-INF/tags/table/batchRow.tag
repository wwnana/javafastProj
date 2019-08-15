<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<%@ attribute name="id" type="java.lang.String" required="true"%>
<%@ attribute name="name" type="java.lang.String" required="false"%>
<%@ attribute name="url" type="java.lang.String" required="true"%>
<%@ attribute name="title" type="java.lang.String" required="true"%>
<%@ attribute name="width" type="java.lang.String" required="false"%>
<%@ attribute name="height" type="java.lang.String" required="false"%>
<%@ attribute name="target" type="java.lang.String" required="false"%>
<%@ attribute name="label" type="java.lang.String" required="false"%>
<%@ attribute name="icon" type="java.lang.String" required="false"%>
<button id="${name}btnBatch" class="btn btn-white btn-sm" onclick="dealBatch()" title="${title }">
	<i class="fa ${icon==null?'fa-file-text-o':icon}"></i> ${label==null?'':label}
</button>

<%-- 使用方法： 1.将本tag写在查询的form之前；2.传入table的id和controller的url --%>
<script type="text/javascript">
$(document).ready(function() {
    $('#${id} thead tr th input.i-checks').on('ifChecked', function(event){ //ifCreated 事件应该在插件初始化之前绑定 
    	  $('#${id} tbody tr td input.i-checks').iCheck('check');
    });

    $('#${id} thead tr th input.i-checks').on('ifUnchecked', function(event){ //ifCreated 事件应该在插件初始化之前绑定 
    	  $('#${id} tbody tr td input.i-checks').iCheck('uncheck');
    });
    
    $("#${name}btnBatch").click(function(){
    	var str="";
  	  	var ids="";
  	  	$("#${id} tbody tr td input.i-checks:checkbox").each(function(){
  	    	if(true == $(this).is(':checked')){
  	      		str+=$(this).attr("id")+",";
  	    	}
  	  	});
  	  	if(str.substr(str.length-1)== ','){
  	    	ids = str.substr(0,str.length-1);
  	  	}
  	  	if(ids == ""){
  			top.layer.alert('请至少选择一条数据!', {icon: 0, title:'警告'});
  			return;
  	  	}
  		top.layer.confirm('确认要${title}吗?', {icon: 3, title:'系统提示'}, function(index){
  			window.location = "${url}?ids="+ids;
  	    	top.layer.close(index);
  		});
    });
});

</script>