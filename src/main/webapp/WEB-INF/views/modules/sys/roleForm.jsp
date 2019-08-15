<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>角色管理</title>
	<meta name="decorator" content="default"/>
	<%@include file="/WEB-INF/views/include/treeview.jsp" %>
	<script type="text/javascript">
	 	var validateForm;
		function doSubmit(){//回调函数，在编辑和保存动作时，供openDialog调用提交表单。
		  if(validateForm.form()){
			  loading('正在提交，请稍等...');
			  $("#inputForm").submit();
			  return true;
		  }
		  return false;
		}
		$(document).ready(function(){
			//$("#name").focus();
			
			validateForm= $("#inputForm").validate({
				rules: {
					name: {remote: "${ctx}/sys/role/checkName?oldName=" + encodeURIComponent("${role.name}")},//设置了远程验证，在初始化时必须预先调用一次。
					enname: {remote: "${ctx}/sys/role/checkEnname?oldEnname=" + encodeURIComponent("${role.enname}")}
				},
				messages: {
					name: {remote: "角色名已存在"},
					enname: {remote: "角色编码已存在"}
				},
				submitHandler: function(form){
					//var ids = [], nodes = tree.getCheckedNodes(true);
					//for(var i=0; i<nodes.length; i++) {
					//	ids.push(nodes[i].id);
					//}
					//$("#menuIds").val(ids);
					var ids2 = [], nodes2 = tree2.getCheckedNodes(true);
					for(var i=0; i<nodes2.length; i++) {
						ids2.push(nodes2[i].id);
					}
					$("#officeIds").val(ids2);
					loading('正在提交，请稍等...');
					form.submit();
				},
				errorContainer: "#messageBox",
				errorPlacement: function(error, element) {
					$("#messageBox").text("输入有误，请先更正。");
					if (element.is(":checkbox")||element.is(":radio")||element.parent().is(".input-append")){
						error.appendTo(element.parent().parent());
					} else {
						error.insertAfter(element);
					}
				}
			});
			
			//在ready函数中预先调用一次远程校验函数，是一个无奈的回避案。(JavaFast）
			//否则打开修改对话框，不做任何更改直接submit,这时再触发远程校验，耗时较长，
			//submit函数在等待远程校验结果然后再提交，而layer对话框不会阻塞会直接关闭同时会销毁表单，因此submit没有提交就被销毁了导致提交表单失败。
			//$("#inputForm").validate().element($("#name"));
			//$("#inputForm").validate().element($("#enname"));
		
			var setting = {check:{enable:true,nocheckInherit:true},view:{selectedMulti:false},
					data:{simpleData:{enable:true}},callback:{beforeClick:function(id, node){
						tree.checkNode(node, !node.checked, true, true);
						return false;
			}}};
			
			// 用户-机构
			var zNodes2=[
					<c:forEach items="${officeList}" var="office">{id:"${office.id}", pId:"${not empty office.parent?office.parent.id:0}", name:"${office.name}"},
		            </c:forEach>];
			// 初始化树结构
			var tree2 = $.fn.zTree.init($("#officeTree"), setting, zNodes2);
			// 不选择父节点
			tree2.setting.check.chkboxType = { "Y" : "ps", "N" : "s" };
			// 默认选择节点
			var ids2 = "${role.officeIds}".split(",");
			for(var i=0; i<ids2.length; i++) {
				var node = tree2.getNodeByParam("id", ids2[i]);
				try{tree2.checkNode(node, true, false);}catch(e){}
			}
			// 默认展开全部节点
			tree2.expandAll(true);
			// 刷新（显示/隐藏）机构
			refreshOfficeTree();
			$("#dataScope").change(function(){
				refreshOfficeTree();
			});
		});
		function refreshOfficeTree(){
			if($("#dataScope").val()==9){
				$("#officeTree").show();
			}else{
				$("#officeTree").hide();
			}
		}

	</script>
</head>
<body class="">
<div class="">
	<div class="">
		
		<div class="ibox-content">
			<sys:message content="${message}"/>
			<form:form id="inputForm" modelAttribute="role" autocomplete="off" action="${ctx}/sys/role/save" method="post" class="form-horizontal" >
				<form:hidden path="id"/>
				<form:hidden path="enname"/>
				<form:hidden path="sysData"/>
				<form:hidden path="menuIds"/>
				
				<div class="row">
					<div class="col-sm-6">
						<div class="form-group">
			            	<label class="col-sm-4 control-label"><font color="red">*</font>角色名称</label>
			            	 <div class="col-sm-8">
			                        <input id="oldName" name="oldName" type="hidden" value="${role.name}">
									<form:input path="name" htmlEscape="false" maxlength="50" class="form-control required"/>
			                 </div>
			            </div>
		            </div>
		        </div>
		        <div class="row">
					<div class="col-sm-6">
						<div class="form-group">
			            	<label class="col-sm-4 control-label"><font color="red">*</font>数据范围</label>
			            	 <div class="col-sm-8">
			                        <form:select path="dataScope" class="form-control">
										<form:options items="${fns:getDictList('sys_data_scope')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
										<%-- <form:option value="9">按明细设置</form:option>--%>
									</form:select>
			                 </div>
			            </div>
		            </div>
		            <%-- 
		            <div class="col-sm-6">
						<div class="form-group">
			            	<label class="col-sm-4 control-label">按明细设置</label>
			            	 <div class="col-sm-8">
			                      <div class="controls">
									<div id="officeTree" class="ztree" style="margin-top:3px;"></div>
									<form:hidden path="officeIds"/>
									
									<span class="help-inline">特殊情况下，设置为“按明细设置”，可进行跨机构授权</span>
								</div>
			                 </div>
			            </div>
		            </div>
		            --%>
		        </div>
		        
		        <div class="row">
		       		<div class="col-sm-12">
						<div class="form-group">
							<label class="col-sm-2 control-label">&nbsp;</label>
				        	<div class="col-sm-10"><div class="alert alert-info alert-dismissable">
					    	<button aria-hidden="true" data-dismiss="alert" class="close" type="button">×</button>
					        	提示和建议：<br>
					        	1、【所有数据】权限，可以查看全公司的数据，适合老总管理<br>
					        	2、【所在部门数据】可以查看该部门人员数据，适合部门管理<br>
					        	3、【仅个人数据】只能查看自己的数据，相互不能查看，适合一般员工
					     </div></div>
			     		</div>
			     	</div>
			     </div>
			</form:form>
			
		</div>
		
	</div>
	
</div>

</body>
</html>