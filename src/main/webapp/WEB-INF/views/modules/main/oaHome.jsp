<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<jsp:useBean id="now" class="java.util.Date" />  
<html>
<head>
	<title>主页</title>
	<meta name="decorator" content="default"/>    
	<link href="${ctxStatic}/hplus/css/calendar.css" rel="stylesheet">
    <script type="text/javascript">
	    
    </script>
    <style type="text/css">
    	
		
		.ibox-title {
			background-color: #fff;
		}
		
    </style>
</head>

<body class="gray-bg">
	
    <div class="wrapper-content">
		<sys:message content="${message}"/>
		
        
        <div class="row">
            <div class="col-sm-8">
            	<div class="ibox float-e-margins hide">
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
                        	<c:forEach items="${calenderPage.list }" var="calender">
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
                        <h5>我的日程</h5>
                        <div class="ibox-tools">
                            <a href="${ctx}/iim/myCalendar" target="mainFrame"><i class="fa fa-chevron-right"></i></a>
                    	</div>
                    </div>                    
                    <div class="ibox-content no-padding" style="height: 400px;">
                    	<iframe class="J_iframe" name="iframe2" id="iframe2" width="100%" height="100%" src="${ctx}/iim/myCalendar/myCalendarView" frameborder="0" data-id="${ctx}/home" seamless></iframe>
                    </div>
                </div>
            </div>
            <div class="col-sm-4">
				
				<div class="ibox float-e-margins hide">
					<div class="ibox-title">
						<h5>办公总览</h5>
					</div>
					<div class="ibox-content">
						<div>
		                    <table class="table table-bordered">
		                        <tbody>
		                            <tr>
		                                <td>
		                                    <button type="button" class="btn btn-danger m-r-sm"> </button>
		                                    	通知
		                                </td>
		                                <td>
		                                    <button type="button" class="btn btn-success m-r-sm"> </button>
		                                    	审批
		                                </td>
		                                <td>
		                                    <button type="button" class="btn btn-info m-r-sm"> </button>
		                                    	日志
		                                </td>
		                            </tr>
		                        </tbody>
		                    </table>
		                </div>
					</div>
				</div>
				
				<div class="ibox float-e-margins">
					<div class="ibox-title">
						<h5><a href="${ctx}/oa/oaNotify/self" class="h5">公告</a></h5>
						<div class="ibox-tools">
	                        <a class="" href="${ctx}/oa/oaNotify/self">
	                            <i class="fa fa-chevron-right"></i>
	                        </a>
	                    </div>
					</div>
					<div class="ibox-content no-padding" style="height: 400px;">
                   		
						<div class="table-responsive">
						<table id="contentTable" class="table table-hover">
							<tbody>
								<c:forEach items="${newNotifyPage.list }" var="oaNotify" varStatus="status">
									<tr>
										<td>
											<a  href="${ctx}/oa/oaNotify/view?id=${oaNotify.id}">
												<c:if test="${oaNotify.readFlag == 0}"><b></c:if>
												${fns:abbr(oaNotify.title,50)}
												<c:if test="${oaNotify.readFlag == 0}"></b></c:if>
											</a>
										</td>
										<td>
											<fmt:formatDate value="${oaNotify.updateDate}" pattern="MM-dd"/>
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
        <div class="row">
            <div class="col-sm-4">
            	
				
				<div class="ibox float-e-margins">
					<div class="ibox-title">
						<h5><a href="${ctx}/oa/oaCommonAudit/" class="h5">待办审批</a></h5>
						<div class="ibox-tools">
	                        <a class="" href="${ctx}/oa/oaCommonAudit/">
	                            <i class="fa fa-chevron-right"></i>
	                        </a>
	                    </div>
					</div>
					<div class="ibox-content  height300">
                   		
						<div class="table-responsive">
						<table id="contentTable" class="table table-borderedtable-hover ">
							<thead>
								<tr>
									<th>标题</th>
									<th width="100px">申请人</th>
									<th width="100px">日期</th>
								</tr>
							</thead>
							<tbody>
								<c:forEach items="${oaCommonAuditPage.list }" var="oaCommonAudit" varStatus="status">
									<tr>
										<td>
											<a href="${ctx}/oa/oaCommonAudit/view?id=${oaCommonAudit.id}" class="" title="查看" >
												${oaCommonAudit.title}
											</a>
										</td>
										<td>
											${oaCommonAudit.createBy.name}
										</td>
										<td>
											<fmt:formatDate value="${oaCommonAudit.createDate}" pattern="MM-dd"/>
										</td>
									</tr>
								</c:forEach>
							</tbody>
						</table>
						</div>
					</div>
				</div>
            </div>
            <div class="col-sm-4">
            	
				
				<div class="ibox float-e-margins">
					<div class="ibox-title">
						<h5><a href="${ctx}/oa/oaWorkLog/self" class="h5">日志</a></h5>
						<div class="ibox-tools">
	                        <a class="" href="${ctx}/oa/oaWorkLog/self">
	                            <i class="fa fa-chevron-right"></i>
	                        </a>
	                    </div>
					</div>
					<div class="ibox-content height300">
                   		
						<div class="table-responsive">
						<table id="contentTable" class="table table-bordered table-hover">
							<thead>
								<tr>
									<th>标题</th>
									<th width="100px">汇报人</th>
									<th width="100px">日期</th>
								</tr>
							</thead>
							<tbody>
								<c:forEach items="${oaWorkLogPage.list }" var="oaWorkLog" varStatus="status">
									<tr>
										<td>
											<a href="${ctx}/oa/oaWorkLog/view?id=${oaWorkLog.id}" class="" title="查看" >
												${oaWorkLog.title}
											</a>
										</td>
										<td>
											${oaWorkLog.createBy.name}
										</td>
										<td>
											<fmt:formatDate value="${oaWorkLog.createDate}" pattern="MM-dd"/>
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
   
   
</body>
</html>