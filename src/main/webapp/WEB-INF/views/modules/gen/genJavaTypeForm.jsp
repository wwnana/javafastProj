<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>自定义java类型</title>
<meta name="decorator" content="default" />
<script type="text/javascript">
//将选择数据绑定供回调
function getInputItem(){
	
	var type = $("#type").val();
	var name = $("#name").val();
	var showValue = $("#showValue").val();
	
	return type+"_item_"+name+"_item_"+showValue;
}
</script>
</head>
<body class="">
<div class="">
	<div class="">
		
		<div class="ibox-content">
				<div class="row">
		            <div class="col-sm-12">
						<div class="form-group">
			            	<label class="col-sm-4 control-label"><font color="red">*</font>类型</label>
			            	 <div class="col-sm-8">
			                      <input id="type" name="type" maxlength="100" class="required form-control"/>
			                      <span class="help-inline">Java字段类型，如：com.javafast.modules.sys.entity.Role</span>
			                 </div>
			            </div>
		            </div>
		        </div>
		        <div class="row">
		            <div class="col-sm-12">
						<div class="form-group">
			            	<label class="col-sm-4 control-label"><font color="red">*</font>名称</label>
			            	 <div class="col-sm-8">
			                      <input id="name" name="name" maxlength="50" class="required form-control"/>
			                      <span class="help-inline">Java字段名称，如：role</span>
			                 </div>
			            </div>
		            </div>
		        </div>
		        <div class="row">
		            <div class="col-sm-12">
						<div class="form-group">
			            	<label class="col-sm-4 control-label"><font color="red">*</font>显示值</label>
			            	 <div class="col-sm-8">
			                      <input id="showValue" name="showValue" maxlength="50" class="required form-control"/>
			                      <span class="help-inline">对象属性在列表或表单的显示值，如：name</span>
			                 </div>
			            </div>
		            </div>
		        </div>
		        
		</div>
	</div>
</div>

</body>
</html>