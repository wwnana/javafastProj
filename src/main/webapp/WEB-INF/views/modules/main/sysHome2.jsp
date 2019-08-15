<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>主页</title>
	<meta name="decorator" content="default"/>    
	<link href="${ctxStatic}/hplus/css/calendar.css" rel="stylesheet">
	
    <script type="text/javascript">
	    $(document).ready(function() {
	    	 setInterval(function(){$("#currentTime").html(current)},1000);
	    	getNotepaper();
	    });
	    function showDialog(layertitle,layerurl){	    	
	    	layer.open({
	            type: 2,
	            title: layertitle,
	            shadeClose: true,
	            shade: 0.3,
	            maxmin: true, //开启最大化最小化按钮
	            area: ['800px', '500px'],
	            content: layerurl
	        });
	    }
	    
	    function current(){
		    var d=new Date(),str='';
		    $("#currentDate").html(d.getFullYear()+"/"+d.getMonth()+1+"/"+d.getDate());		    
		    str +=d.getHours()+':';
		    str +=d.getMinutes()+':';
		    str +=d.getSeconds()+'';
		    return str; 
	    }
	   
	    function getNotepaper(){	    	
		    $.ajax({
	    		url:"${ctx}/oa/oaNote/getNote",
	    		type:"POST",
	    		async:true,    //或false,是否异步
	    		dataType:'json',
	    		success:function(data){	    			
	    			if(data != null && data != "false" && data.notes != null){	    				
	    				$("#notepaper").val(data.notes);
	    			}
	    		},
	    		error:function(){
	    			//alert("出错");
	    		}
	    	});
	    }
	    function saveNotepaper(){
	    	var notepaper = $("#notepaper").val();
	    	$.ajax({
	    		url:"${ctx}/oa/oaNote/saveNote",
	    		type:"POST",
	    		async:true,    //或false,是否异步
	    		data:{notes:notepaper},
	    		dataType:'json',
	    		success:function(data){
	    			//alert(data);
	    		},
	    		error:function(){
	    			//alert("出错");
	    		}
	    	});
	    }
	    </script>   
    </script>
</head>

<body class="gray-bg">
	
    <div class="wrapper-content">
		<sys:message content="${message}"/>
        <div class="row">
        	<div class="col-sm-2">
                
                
                <div class="ibox float-e-margins">
                   <div class="ibox-title">                        
	                        <h5>签到</h5>
	               </div>
                   <div class="ibox-content">
                   		<div class="well">
                            <h3 id="currentTime">
                            </h3>
                            <span id="currentDate"></span>
                        </div>
                        <button id="checkBtn" class="btn btn-info btn-block m-t checkBtn hide" onclick="javascript:check(1);">
                        	<span><i class="fa fa-edit"></i>签到</span>
                        </button>
                    </div>
                 </div>      
            	
            	<div class="ibox float-e-margins">
                    <div class="ibox-title">
                        <h5>足迹</h5>
                        <div class="ibox-tools">
                            <a href="" target="mainFrame">
                                <i class="fa fa-chevron-right"></i>
                            </a>
                    	</div>
                    </div>                    
                   <div class="ibox-content no-padding">
                   		<ul class="list-group">
                    	    <c:forEach items="${browseLogPage.list }" var="browseLog">   
                    		<li class="list-group-item" >                                	
                                <div class="agile-detail">
                                	<a href="${ctx}/crm/crmCustomer/index?id=${browseLog.targetId}" class="block-link">${browseLog.targetName }</a> <a href="${ctx}/crm/crmCustomer/index?id=${browseLog.targetId}" class="pull-right btn btn-xs btn-white">客户</a>                                   	
                                </div>
                            </li>
                            </c:forEach>                 	
                        </ul>
                    </div>
                </div>
                
                 <div class="ibox float-e-margins">
                    <div class="ibox-title">                        
                        <h5>便笺</h5>
                    </div>
                    <div class="ibox-content">
                    	<textarea id="notepaper" name="notepaper" rows="" cols="" class="form-control" style="height: 100px;width: 100%" onblur="saveNotepaper()"></textarea>
                    </div>
                </div>
                
            </div>
        	<div class="col-sm-7">
	        	<div class="ibox float-e-margins">
	                    <div class="ibox-title">                        
	                        <h5>任务</h5>
	                    </div>
	                    <div class="ibox-content">
	                    	<div class="project-list">
                            <table class="table table-hover">
                                <tbody>
                                	<c:forEach items="${taskPage.list }" var="oaTask">
                                    <tr>
                                        <td class="project-status">
                                        	<c:if test="${oaTask.status != 3}">
                                            <span class="label label-primary">${fns:getDictLabel(oaTask.status, 'task_status', '')}
                                            </c:if>
                                            <c:if test="${oaTask.status == 3}">
                                            	<span class="label label-default">${fns:getDictLabel(oaTask.status, 'task_status', '')}</span>
                                            </c:if>
                                        </td>
                                        <td class="project-title">
                                            <a href="#" onclick="openDialogView('查看任务', '${ctx}/oa/oaTask/view?id=${oaTask.id}','800px', '500px')">${oaTask.name}</a>
                                            <br/>
                                            <small>创建于<fmt:formatDate value="${oaTask.createDate}" pattern="yyyy.MM.dd"/></small>
                                        </td>
                                        <td class="project-completion">
                                                <small>当前进度： ${oaTask.schedule}%</small>
                                                <div class="progress progress-mini">
                                                    <div style="width: ${oaTask.schedule}%;" class="progress-bar"></div>
                                                </div>
                                        </td>
                                        <td class="project-people">
                                        	<small>${oaTask.relationName}</small>
                                        	<br>
                                        	<small>截止于<fmt:formatDate value="${oaTask.endDate}" pattern="yyyy.MM.dd"/></small>
                                        </td>
                                        <td class="project-actions">
                                            <a href="#" onclick="openDialogView('查看任务', '${ctx}/oa/oaTask/view?id=${oaTask.id}','800px', '500px')" class="btn btn-white btn-sm"><i class="fa fa-folder"></i> 查看 </a>
                                            <a href="#" onclick="openDialog('修改任务', '${ctx}/oa/oaTask/form?id=${oaTask.id}','800px', '500px')" class="btn btn-white btn-sm"><i class="fa fa-pencil"></i> 编辑 </a>
                                        </td>
                                    </tr>
                                    </c:forEach>
                                   </tbody>
                                  </table>
                                 </div>
                                
	                    </div>
	                    
	            </div>
        	
                <div class="ibox float-e-margins">
                    <div class="ibox-title">                        
                        <h5>客户</h5>
                    </div>
                    <div class="ibox-content">
                    	 <div class="clients-list">
                            <ul class="nav nav-tabs">
                                <span class="pull-right small text-muted">${fn:length(contactCustomerPage.list)} 个客户最近需联系</span>
                                <li class="active"><a data-toggle="tab" href="#tab-1"><i class="fa fa-calendar"></i> 最近需联系</a>
                                </li>
                                <li class=""><a data-toggle="tab" href="#tab-2"><i class="fa fa-user"></i> 最新客户</a>
                                </li>
                            </ul>
                         	 <div class="tab-content">
                                <div id="tab-1" class="tab-pane active">
                                	<div class="full-height-scroll">
			                            <div class="table-responsive">
			                                <table class="table table-striped table-hover">
			                                    <tbody>
			                                    <c:forEach items="${contactCustomerPage.list }" var="crmCustomer">
			                                    	<tr>
                                                       
                                                        <td><a href="${ctx}/crm/crmCustomer/index?id=${crmCustomer.id}" class="client-link">${crmCustomer.name}</a>
                                                        </td>
                                                        <td><i class="fa fa-calendar-check-o contact-type"> </i> <fmt:formatDate value="${crmCustomer.nextcontactDate}" pattern="yyyy-MM-dd"/> </td>
                                                       
                                                        </td>
                                                        <td><i class="fa fa-volume-off contact-type"> </i> ${crmCustomer.nextcontactNote}</td>
                                                        <td class="client-status"></td>
                                                    </tr>	
                                                 </c:forEach>		                                        
			                                     </tbody>
			                                  </table>
			                              </div>
			                         </div>
                                </div>
                                <div id="tab-2" class="tab-pane">
                                    <div class="full-height-scroll">
                                        <div class="table-responsive">
                                            <table class="table table-striped table-hover">
                                            	<tbody>
                                            	<c:forEach items="${customerPage.list }" var="crmCustomer">
			                                    	<tr>
			                                            <td><a href="${ctx}/crm/crmCustomer/index?id=${crmCustomer.id}" class="client-link">${crmCustomer.name}</a>
			                                            </td>
			                                            <td>${crmCustomer.contacterName}</td>
			                                            <td><i class="fa fa-flag contact-type"></i> ${fns:getDictLabel(crmCustomer.customerLevel, 'customer_level', '')}</td>
			                                            <td class="client-status"><span class="label label-primary">${fns:getDictLabel(crmCustomer.customerStatus, 'customer_status', '')}</span>
			                                            </td>
			                                        </tr>
			                                    	
			                                    </c:forEach>
			                                    </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                             </div>
                         </div>
                    
                    
                                     
                    </div>
                </div>
            	
            </div>
            <div class="col-sm-3">
                
                
                
                <div class="ibox float-e-margins">
                    <div class="ibox-title">                        
                        <h5>总览</h5>
                    </div>
                    <div class="ibox-content">
                    	
                    	<div>		                    
		                      <table class="table">
		                        <tbody>
		                            <tr>
		                                <td style="border-color: #fff;">
		                                    <button type="button" class="btn btn-danger btn-circle m-r-sm" onclick="javascript:window.location.href='${ctx }/oa/oaNotify/self'"><i class="fa fa-bell-o"></i></button>
		                                   	<br>消息
		                                </td>
		                                <td style="border-color: #fff;">
		                                    <button type="button" class="btn btn-success btn-circle m-r-sm" onclick="javascript:window.location.href='${ctx }/oa/oaTask/self'"><i class="fa fa-tag"></i></button>
		                                 	 <br>任务
		                                </td style="border-color: #fff;">
		                                <td style="border-color: #fff;">
		                                    <button type="button" class="btn btn-info btn-circle m-r-sm" onclick="javascript:window.location.href='${ctx }/iim/myCalendar'"><i class="fa fa-calendar-check-o"></i></button>
		                                  	<br>日程
		                                </td>
		                            </tr>
		                            <tr>
		                                <td>
		                                    <button type="button" class="btn btn-info btn-circle m-r-sm" onclick="javascript:window.location.href='${ctx }/crm/crmCustomer/'"><i class="fa fa-user"></i></button>
		                                   	 <br>客户
		                                </td>
		                                <td>
		                                    <button type="button" class="btn btn-success btn-circle m-r-sm" onclick="javascript:window.location.href='${ctx }/crm/crmChance'"><i class="fa fa-send-o"></i></button>
		                                   	 <br>商机
		                                </td>
		                                <td>
		                                    <button type="button" class="btn btn-danger btn-circle m-r-sm" onclick="javascript:window.location.href='${ctx }/om/omOrder'"><i class="fa fa-file-o"></i></button>
		                                	<br>订单
		                                </td>
		                            </tr>
		                            
		                            <%-- 
		                            <tr>
		                                <td>
		                                    <button type="button" class="btn btn-warning btn-circle m-r-sm">5</button>
		                                    	采购
		                                </td>
		                                <td>
		                                    <button type="button" class="btn btn-default btn-circle m-r-sm">3</button>
		                                    	入库
		                                </td>
		                                <td>
		                                    <button type="button" class="btn btn-warning btn-circle m-r-sm">60</button>
		                                    	出库
		                                </td>
		                            </tr>
		                             <tr>
		                             	<td>
		                                    <button type="button" class="btn btn-info btn-circle m-r-sm">2</button>
		                                    	账户
		                                </td>
		                                <td>
		                                    <button type="button" class="btn btn-danger btn-circle m-r-sm">6</button>
		                                    	应收
		                                </td>
		                                <td>
		                                    <button type="button" class="btn btn-info btn-circle m-r-sm">1</button>
		                                    	应付
		                                </td>		                                
		                            </tr>
		                            --%>
		                        </tbody>
		                    </table>
                		</div>
                    	
                    </div>
                </div>
                
                <div class="ibox float-e-margins">
                    <div class="ibox-title">
                        <h5>日程</h5>
                        <div class="ibox-tools">
                            <a href="${ctx }/iim/myCalendar" target="mainFrame">
                                <i class="fa fa-chevron-right"></i>
                            </a>
                    	</div>
                    </div>                    
                   <div class="ibox-content">
                    	<div class="input-group">
                            <input type="text" placeholder="添加新日程" class="form-control" onclick="openDialog('添加日程', '${ctx}/iim/myCalendar/form?adllDay=1','800px', '500px')">
                            <span class="input-group-btn">
                                <button type="button" class="btn btn-sm btn-white" onclick="openDialog('添加日程', '${ctx}/iim/myCalendar/form?adllDay=1','800px', '500px')"> <i class="fa fa-plus"></i> 添加</button>
                            </span>
                        </div>
                        <ul class="sortable-list connectList agile-list">
                        	
                        	<c:set property="nowDate" value="${fns:getDate('yyyy-MM-dd')}" var="nowDate"></c:set>
                        	<c:forEach items="${calenderList }" var="calender">
                        		<c:if test="${nowDate != calender.start}">
                        			<li class="success-element">
                        		</c:if>
                        		<c:if test="${nowDate eq calender.start}">
                        			<li class="warning-element">
                        		</c:if>
	                                	${calender.title }
	                                <div class="agile-detail">
	                                    <a href="#" class="pull-right btn btn-xs btn-white">标记</a>
	                                    <i class="fa fa-clock-o"></i> ${calender.start} <c:if test="${calender.adllDay == 1}">全天</c:if>
	                                </div>
	                            </li>
                        	</c:forEach>
                          </ul>
                    </div>
                </div>
                
                <div class="ibox float-e-margins">
                    <div class="ibox-title">
                        <%-- <span class="label label-danger pull-right"><c:out value="${fn:length(oaAnnounceEntityList)}" /></span>--%>
                        <h5>通知</h5>
                        <div class="ibox-tools">
                            <a href="${ctx }/oa/oaNotify/self" target="mainFrame">
                                <i class="fa fa-chevron-right"></i>
                            </a>
                    	</div>
                    </div>                    
                   <div class="ibox-content no-padding">
                   		<ul class="list-group">
                   			<c:forEach items="${newNotifyList }" var="oaNotify">
                            <li class="list-group-item">
                                <a onclick="showDialog('${oaNotify.title}','${ctx}/oa/oaNotify/view?id=${oaNotify.id}');">${oaNotify.title}</a>
                            </li>
                            </c:forEach>
                        </ul>
                    </div>
                </div>
                
               
                
                <div class="ibox float-e-margins">
                    <div class="ibox-title">
                        <h5>动态</h5>
                        <div class="ibox-tools">
                            <a href="" target="mainFrame">
                                <i class="fa fa-chevron-right"></i>
                            </a>
                    	</div>
                    </div>                    
                   <div class="ibox-content no-padding">
                   		<ul class="list-group">
                    	<c:forEach items="${sysDynamicPage.list }" var="sysDynamic">                        	
							<li class="list-group-item">
								<fmt:formatDate value="${sysDynamic.createDate}" pattern="MM-dd HH:mm"/> 
								${sysDynamic.createBy.name} <i>${fns:getDictLabel(sysDynamic.actionType, 'action_type', '')}了${fns:getDictLabel(sysDynamic.objectType, 'object_type', '')}</i> 
								${sysDynamic.targetName}
							</li>	
                        </c:forEach>
                        </ul>
                    </div>
                </div>
                
                <div class="ibox float-e-margins">
                    <div class="ibox-title">                        
                        <h5>系统公告</h5>
                    </div>
                    <div class="ibox-content">
                    	尊敬的客户：
							您好！
							为了给您提供更加优质的服务，系统将定于2017年8月1日 23:00至2017年8月2日凌晨5:00进行系统维护升级
                    </div>
                </div>
                
                <div class="ibox float-e-margins">
                    <div class="ibox-title">                        
                        <h5>邀请</h5>
                    </div>
                    <div class="ibox-content">
                    	邀请同事加入！ <button type="button" class="btn btn-outline btn-info"><i class="fa fa-plus"></i> 立即邀请</button>
                    </div>
                </div>
                <div class="alert alert-warning alert-dismissable">
                     <button aria-hidden="true" data-dismiss="alert" class="close" type="button">×</button>
                            	新功能推荐 <a class="alert-link" href="http://www.javafast.cn" target="_blank">了解更多</a>.
                </div>
            </div>
            
        </div>
    </div>
   
   
</body>
</html>