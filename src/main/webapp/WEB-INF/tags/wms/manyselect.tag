<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<%@ attribute name="id" type="java.lang.String" required="true" description="编号"%>
<%@ attribute name="name" type="java.lang.String" required="true" description="隐藏域名称（ID）"%>
<%@ attribute name="value" type="java.lang.String" required="true" description="隐藏域值（ID）"%>
<%@ attribute name="title" type="java.lang.String" required="true" description="选择框标题"%>
<%@ attribute name="url" type="java.lang.String" required="true" description="树结构数据地址"%>
<%@ attribute name="extId" type="java.lang.String" required="false" description="排除掉的编号（不能选择的编号）"%>
<%@ attribute name="isAll" type="java.lang.Boolean" required="false" description="是否列出全部数据，设置true则不进行数据权限过滤（目前仅对Office有效）"%>
<%@ attribute name="notAllowSelectRoot" type="java.lang.Boolean" required="false" description="不允许选择根节点"%>
<%@ attribute name="notAllowSelectParent" type="java.lang.Boolean" required="false" description="不允许选择父节点"%>
<%@ attribute name="module" type="java.lang.String" required="false" description="过滤栏目模型（只显示指定模型，仅针对CMS的Category树）"%>
<%@ attribute name="selectScopeModule" type="java.lang.Boolean" required="false" description="选择范围内的模型（控制不能选择公共模型，不能选择本栏目外的模型）（仅针对CMS的Category树）"%>
<%@ attribute name="allowClear" type="java.lang.Boolean" required="false" description="是否允许清除"%>
<%@ attribute name="allowInput" type="java.lang.Boolean" required="false" description="文本框可填写"%>
<%@ attribute name="cssClass" type="java.lang.String" required="false" description="css样式"%>
<%@ attribute name="cssStyle" type="java.lang.String" required="false" description="css样式"%>
<%@ attribute name="smallBtn" type="java.lang.Boolean" required="false" description="缩小按钮显示"%>
<%@ attribute name="hideBtn" type="java.lang.Boolean" required="false" description="是否显示按钮"%>
<%@ attribute name="disabled" type="java.lang.String" required="false" description="是否限制选择，如果限制，设置为disabled"%>
<%@ attribute name="dataMsgRequired" type="java.lang.String" required="false" description=""%>
<%@ attribute name="checkRepeat" type="java.lang.Boolean" required="true" description="是否检查重复选择数据"%>
<%@ attribute name="checkBefore" type="java.lang.Boolean" required="false" description="弹出前的自定义检查方法"%>

<a id="${id}" name="${name}" class="${cssClass}" value="${value}" checkRepeat="${checkRepeat }" url="${url }" 
checkBefore="${checkBefore }">添加</a>


<script type="text/javascript">
	$("#${id}").click(function(){

		var url = $("#${id}").attr("url");
		
		if($("#${id}").attr("checkBefore")){
			if(! checkBefore()){
				return ;
			}
		}
		
		top.layer.open({
		    type: 2,  
		    area: ['1000px', '500px'],
		    maxmin: true, //开启最大化最小化按钮
		    title:"${title}",
		    name:'friend',
		    content: url ,
		    btn: ['确定', '关闭'],
		    yes: function(index, layero){
		    	 var iframeWin = layero.find('iframe')[0].contentWindow; //得到iframe页的窗口对象，执行iframe页的方法：iframeWin.method();
		    	 var item = iframeWin.getSelectedItemMany();
		    	 
		    	 if(item == "-1"){
			    	 	top.layer.alert('请至少选择一条数据!', {icon: 0, title:'警告'},function(indexAlert){
				            layer.close(indexAlert);
				            top.layer.close(indexAlert);
			         	});
		    	 }else{
// 		    		 console.info("选中---" + item.length);		    		 
		    		 //是否判断重复
		    		 var noRepeat = new Array();
		    		 
		    		 var tipMsg = "";
		    		 
		    		 if($("#${id}").attr("checkRepeat")){
		    			
		    			 //循环选中的 与 已选中的进行匹配
		    			 for(var i=0 ;i < item.length; i++ ){
		    				 isRepeated = false;
		    				 
		    				 //判断 隐藏的id
		    				 $("#contentTable tbody tr td:nth-child(3) input[type='hidden']").each(function(k, obj){
			    				 if($(this).val().length > 0 && ($(this).val() == item[i].children("td").eq(0).find("input").attr("id"))){
		    					 	isRepeated = true;
		    					 	tipMsg = tipMsg + item[i].children("td").eq(2).html() + ",";
		    					 	return false;
		    				 	 }
			    			 });
		    				 
		    				//非重复
		    				 if(! isRepeated) {
		    					 noRepeat.push(item[i]);
		    				 }
		    			 }
		    			 
		    			 //将非重复的赋值
		    			 item = noRepeat;
		    		 }
		    		 
		    		 
// 		    		 console.info("非重复---" + item.length);
		    		 
		    		 
		    		 if(item.length > 0){
		    			 if(tipMsg.length > 0){
		    				 var t1 = tipMsg.substring(0, tipMsg.length - 1);
		    				 alert("产品名称：[" + t1 + "] 重复选择");
		    			 }
		    			 
		    			 
		    			 
		    			 for(var i=0 ;i < item.length; i++ ){
// 			    			 console.info(item[i].children("td").eq(0).find("input").attr("id"));
			    			 
			    			 //页面上自己定义需要赋值出去的 function
			    			 setParamsByItems(item[i]);
			    		 }
		    		 }else{
		    			 alert('全部重复选择!');
		    		 }
		    		 
		    		 

					 top.layer.close(index);//关闭对话框。
		    	 }
		    	 
			  },
			  cancel: function(index){ 
				  
		      }
		}); 
	});
</script>