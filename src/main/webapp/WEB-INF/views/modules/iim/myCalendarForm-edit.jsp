<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<link rel="stylesheet" type="text/css" href="${ctxStatic}/fullcalendar/css/jquery-ui.css">
<div class="fancy">
	<h3>编辑事件</h3>
    <form id="add_form" action="${ctx }/iim/myCalendar/edit" method="post" class="form-horizontal">
    <input type="hidden" name="id" id="eventid" value="${myCalendar.id}">
    
    <div class="form-group">
    	<input type="text" name="event" id="event" class="form-control" placeholder="记录你将要做的一件事..." value="${title }" maxlength="12">
    </div>
    
    <div class="form-group">
    	<p>开始时间：<input type="text" class="form-control input-medium" name="startdate" id="startdate" value="${start_d }" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});" readonly="readonly">
    
	    <span id="sel_start" <c:if test="${start_h == '' }">style="display: none;"</c:if>>
	    
		    <select name="s_hour" class="form-control input-mini">
		    	<option value="${start_h}" selected>${start_h}</option>
		    	<option value="00">00</option>
		        <option value="01">01</option>
		        <option value="02">02</option>
		        <option value="03">03</option>
		        <option value="04">04</option>
		        <option value="05">05</option>
		        <option value="06">06</option>
		        <option value="07">07</option>
		        <option value="08">08</option>
		        <option value="09">09</option>
		        <option value="10">10</option>
		        <option value="11">11</option>
		        <option value="12">12</option>
		        <option value="13">13</option>
		        <option value="14">14</option>
		        <option value="15">15</option>
		        <option value="16">16</option>
		        <option value="17">17</option>
		        <option value="18">18</option>
		        <option value="19">19</option>
		        <option value="20">20</option>
		        <option value="21">21</option>
		        <option value="22">22</option>
		        <option value="23">23</option>
		    </select>:
		    <select name="s_minute" class="form-control input-mini">
		    	<option value="${start_m}" selected>${start_m}</option>
		    	<option value="00">00</option>
		        <option value="10">10</option>
		        <option value="20">20</option>
		        <option value="30">30</option>
		        <option value="40">40</option>
		        <option value="50">50</option>
		    </select>
	    </span>
	    </p>
    </div>
    
    <div class="form-group">
	    <p id="p_endtime" <c:if test="${end_d == '' }">style="display: none;"</c:if>>结束时间：<input type="text" class="form-control input-medium" name="enddate" id="enddate" value="${end_d}" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});" readonly="readonly">
	    <span id="sel_end" <c:if test="${end_h == '' }">style="display: none;"</c:if> >
	    
	    <select name="e_hour" class="form-control input-mini">
	    	<option value="${end_h }" selected>${end_h }</option>
	    	<option value="00">00</option>
	    	<option value="01">01</option>
	        <option value="02">02</option>
	        <option value="03">03</option>
	        <option value="04">04</option>
	        <option value="05">05</option>
	        <option value="06">06</option>
	        <option value="07">07</option>
	        <option value="08">08</option>
	        <option value="09">09</option>
	        <option value="10">10</option>
	        <option value="11">11</option>
	        <option value="12">12</option>
	        <option value="13">13</option>
	        <option value="14">14</option>
	        <option value="15">15</option>
	        <option value="16">16</option>
	        <option value="17">17</option>
	        <option value="18">18</option>
	        <option value="19">19</option>
	        <option value="20">20</option>
	        <option value="21">21</option>
	        <option value="22">22</option>
	        <option value="23">23</option>
	    </select>:
	    <select name="e_minute" class="form-control input-mini">
	    	<option value="${end_m}" selected>${end_m }</option>
	    	<option value="00">00</option>
	        <option value="10">10</option>
	        <option value="20">20</option>
	        <option value="30">30</option>
	        <option value="40">40</option>
	        <option value="50">50</option>
	    </select>
	    </span>
	    </p>
	</div>
	
	
    <p style="margin-bottom: 30px;">
    <label><input type="checkbox" value="1" id="isallday" name="isallday"<c:if test="${'1' == allDay }">  checked="checked" </c:if> class="i-checks"> 全天</label>
    <label><input type="checkbox" value="1" id="isend" name="isend"  <c:if test="${'' != end }">  checked="checked" </c:if> class="i-checks"> 结束时间</label>
    </p>
    
    <div class="sub_btn">
    <span class="del"><input type="button" class="btn btn-danger" id="del_event" value="删除"></span>
    <input type="submit" class="btn btn-info" value="确定"> 
    <input type="button" class="btn btn-white" value="取消" onClick="$.fancybox.close()"></div>
    </form>
</div>

<script type="text/javascript" src="${ctxStatic}/fullcalendar/js/jquery.form.min.js"></script>
<script type="text/javascript">
$(function(){
	$(".datepicker").datepicker();
	$("#isallday").click(function(){
		if($("#sel_start").css("display")=="none"){
			$("#sel_start,#sel_end").show();
		}else{
			$("#sel_start,#sel_end").hide();
		}
	});
	
	$("#isend").click(function(){
		if($("#p_endtime").css("display")=="none"){
			$("#p_endtime").show();
		}else{
			$("#p_endtime").hide();
		}
		$.fancybox.resize();//调整高度自适应
	});
	
	//提交表单
	
	$('#add_form').ajaxForm({
		beforeSubmit: showRequest, //表单验证
        success: showResponse //成功返回
    }); 
	
	//删除事件
	$("#del_event").click(function(){
		if(confirm("您确定要删除吗？")){
			var eventid = $("#eventid").val();
			$.post("${ctx }/iim/myCalendar/del",{id:eventid},function(msg){
				if(msg==1){//删除成功
					$.fancybox.close();
					$('#calendar').fullCalendar('refetchEvents'); //重新获取所有事件数据
				}else{
					alert(msg);	
				}
			});
		}
	});
});

function showRequest(){
	var events = $("#event").val();
	if(events==''){
		alert("请输入日程内容！");
		$("#event").focus();
		return false;
	}
}

function showResponse(responseText, statusText, xhr, $form){
	if(statusText=="success"){	
		if(responseText==1){
			$.fancybox.close();
			$('#calendar').fullCalendar('refetchEvents'); //重新获取所有事件数据
		}else{
			alert(responseText);
		}
	}else{
		alert(statusText);
	}
}
</script>