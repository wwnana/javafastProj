<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<%@ include file="/WEB-INF/views/include/weuihead.jsp"%>
<html>
<head>
	<title>${fns:getDictLabel(oaCommonAudit.type, 'common_audit_type', '')}</title>
	<style type="text/css">
		
		.weui-cells {
		    font-size: 12px;
		}
		.weui-cell-desc{
		padding: 0 15px;
		}
	</style>
    <script type="text/javascript">
    function doSubmit(){
		
    	$("#inputForm").submit();
    }
    
    $(function(){ 
    	//监听返回事件
		pushHistory();
		window.addEventListener("popstate", function(e) {
			location.href = "${ctx}/mobile/oa/oaCommonAudit/list";
		}, false);
    });
	</script>
</head>
<body ontouchstart>
<mobile:message content="${message}"/>
<div class="page-content">
    <div class="page__bd">
	<div class="weui-panel weui-panel_access">
		<div class="weui-panel__bd">
                <div class="weui-media-box weui-media-box_appmsg">
                    <div class="weui-media-box__hd">
                        <img class="weui-media-box__thumb" src="${oaCommonAudit.createBy.photo}" alt="">
                    </div>
                    <div class="weui-media-box__bd">
                        <h4 class="weui-media-box__title">${oaCommonAudit.title} <span class="title_label_primary">${fns:getDictLabel(oaCommonAudit.status, 'common_audit_status', '')}</span></h4>
                        <p class="weui-media-box__desc">${oaCommonAudit.createBy.name} [${oaCommonAudit.office.name}] <fmt:formatDate value="${oaCommonAudit.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/></p>
                    </div>
                </div>
        </div>
     </div>
     </div>    
         <%-- 
        <div class="weui-panel__bd">
          <div class="weui-media-box weui-media-box_text">
            <h4 class="weui-media-box__title"><img src="${oaCommonAudit.createBy.photo}" alt="" style="width:20px;margin-right:5px;display:block">${oaCommonAudit.title} <span class="title_label">${fns:getDictLabel(oaCommonAudit.status, 'common_audit_status', '')}</span></h4>
            <p class="weui-media-box__desc">申请人：${oaCommonAudit.createBy.name} [${oaCommonAudit.office.name}]</p>
            <p class="weui-media-box__desc">申请时间：<fmt:formatDate value="${oaCommonAudit.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/></p>
          </div>
        </div>
        --%>   
      
    <form:form id="inputForm" modelAttribute="oaCommonAudit" action="${ctx}/mobile/oa/oaCommonAudit/audit" method="post" class="form-horizontal">
		<form:hidden path="id"/>
			<div class="weui-panel weui-panel_access">
        
		        <div class="weui-panel__bd">

		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">内容</h4>
		            <p class="weui-body-box_desc">${oaCommonAudit.content}</p>
		          </div>
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">附件</h4>
		            <p class="weui-media-box__desc">
		            	<form:hidden id="files" path="files" htmlEscape="false" maxlength="255" class="form-control"/>
						<sys:ckfinder input="files" type="files" uploadPath="/oa" selectMultiple="true" readonly="true" />
					</p>
		          </div>
		          
		        </div>
      		</div>
    
    	<div class="weui-panel weui-panel_access">
        <div class="weui-panel__bd">

    	<c:if test="${oaCommonAudit.type == 1}">
			<div class="weui-panel weui-panel_access">
				<div class="weui-cells__title">请假信息</div>	
		        <div class="weui-panel__bd">
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">开始时间</h4>
		            <p class="weui-media-box__desc"><fmt:formatDate value="${oaCommonLeave.startTime}" pattern="yyyy-MM-dd HH:mm:ss"/></p>
		          </div>
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">结束时间</h4>
		            <p class="weui-media-box__desc"><fmt:formatDate value="${oaCommonLeave.endTime}" pattern="yyyy-MM-dd HH:mm:ss"/></p>
		          </div>
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">请假类型</h4>
		            <p class="weui-media-box__desc">${fns:getDictLabel(oaCommonLeave.leaveType, 'leave_type', '')}</p>
		          </div>
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">请假时长(天)</h4>
		            <p class="weui-media-box__desc">${oaCommonLeave.daysNum}</p>
		          </div>
		       
		       </div>
		    </div>
		</c:if>
		<c:if test="${oaCommonAudit.type == 2}">
			<div class="weui-panel weui-panel_access">
				<div class="weui-cells__title">报销信息</div>	
		        <div class="weui-panel__bd">
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">报销总额</h4>
		            <p class="weui-media-box__desc">${oaCommonExpense.amount}</p>
		          </div>
		         <table id="contentTable" class="table">
								<thead>
									<tr>
										<th>报销事项</th>
										<th>日期</th>
										<th>报销金额（元）</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach items="${oaCommonExpense.oaCommonExpenseDetailList}" var="oaCommonExpenseDetail">
										<tr>
													<td>
														${oaCommonExpenseDetail.itemName}
													</td>
													<td>
														<fmt:formatDate value="${oaCommonExpenseDetail.date}" pattern="yyyy-MM-dd"/>
													</td>
													<td>
														${oaCommonExpenseDetail.amount}
													</td>
										</tr>
									</c:forEach>
								</tbody>
							</table>	
		       
		       </div>
		    </div>
		</c:if>
		<c:if test="${oaCommonAudit.type == 3}">
			<div class="weui-panel weui-panel_access">
				<div class="weui-cells__title">差旅信息</div>
		        <div class="weui-panel__bd">
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">出发地</h4>
		            <p class="weui-media-box__desc">${oaCommonTravel.startAddress}</p>
		          </div>
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">出差城市</h4>
		            <p class="weui-media-box__desc">${oaCommonTravel.destAddress}</p>
		          </div>
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">开始时间</h4>
		            <p class="weui-media-box__desc"><fmt:formatDate value="${oaCommonTravel.startTime}" pattern="yyyy-MM-dd"/></p>
		          </div>
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">结束时间</h4>
		            <p class="weui-media-box__desc"><fmt:formatDate value="${oaCommonTravel.endTime}" pattern="yyyy-MM-dd"/></p>
		          </div>
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">预算金额</h4>
		            <p class="weui-media-box__desc">${oaCommonTravel.budgetAmt}</p>
		          </div>
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">预支金额</h4>
		            <p class="weui-media-box__desc">${oaCommonTravel.advanceAmt}</p>
		          </div>
		         	
		       
		       </div>
		    </div>
		</c:if>
		
		<c:if test="${oaCommonAudit.type == 4}">
			<div class="weui-panel weui-panel_access">
				<div class="weui-cells__title">借款信息</div>
		        <div class="weui-panel__bd">
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">借款总额</h4>
		            <p class="weui-media-box__desc">${oaCommonBorrow.amount}</p>
		          </div>
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">借款时间</h4>
		            <p class="weui-media-box__desc"><fmt:formatDate value="${oaCommonBorrow.borrowDate}" pattern="yyyy-MM-dd"/></p>
		          </div>
		       </div>
		    </div>
		</c:if>
		
		<c:if test="${oaCommonAudit.type == 5}">
			<div class="weui-panel weui-panel_access">
				<div class="weui-cells__title">加班信息</div>
		        <div class="weui-panel__bd">
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">开始时间</h4>
		            <p class="weui-media-box__desc"><fmt:formatDate value="${oaCommonExtra.startTime}" pattern="yyyy-MM-dd HH:mm:ss"/></p>
		          </div>
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">结束时间</h4>
		            <p class="weui-media-box__desc"><fmt:formatDate value="${oaCommonExtra.endTime}" pattern="yyyy-MM-dd HH:mm:ss"/></p>
		          </div>
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">加班类型</h4>
		            <p class="weui-media-box__desc">${fns:getDictLabel(oaCommonExtra.extraType, 'extra_type', '')}</p>
		          </div>
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">加班时长(天)</h4>
		            <p class="weui-media-box__desc">${oaCommonExtra.daysNum}</p>
		          </div>
		       </div>
		    </div>
		</c:if>
		</div>
		</div>
		
			<div class="weui-panel weui-panel_access">
			<div class="weui-cells__title">审批流程</div>	
		    <div class="weui-panel__bd">			    	        
		        <div class="weui-cells">
					<c:forEach items="${oaCommonAudit.oaCommonAuditRecordList}" var="oaCommonAuditRecord">
					<c:if test="${oaCommonAuditRecord.dealType == 0}">
		            <a class="weui-cell weui-cell_access" href="javascript:;">
		                <div class="weui-cell__hd"><img src="${oaCommonAuditRecord.user.photo}" alt="" style="width:20px;margin-right:5px;display:block"></div>
		                <div class="weui-cell__bd">
		                    <p>${oaCommonAuditRecord.user.name}
		                    <c:if test="${oaCommonAuditRecord.dealType == 0}"><c:if test="${empty oaCommonAuditRecord.auditStatus && oaCommonAudit.currentBy.id==oaCommonAuditRecord.user.id}"> • 审批中</c:if><c:if test="${not empty oaCommonAuditRecord.auditStatus}"> • ${fns:getDictLabel(oaCommonAuditRecord.auditStatus, 'common_audit_status', '')}</c:if></c:if>
		                    <c:if test="${oaCommonAuditRecord.dealType == 1}"> • ${fns:getDictLabel(oaCommonAuditRecord.readFlag, 'oa_notify_read', '')}</c:if>
		                    </p>
		                </div>
		                <div class="weui-media-box__desc"><fmt:formatDate value="${oaCommonAuditRecord.auditDate}" pattern="yyyy-MM-dd HH:mm:ss"/></div>
		            </a>
		            <div class="weui-cell-desc"><p class="weui-media-box__desc">${oaCommonAuditRecord.auditNotes}</p></div>
		            </c:if>
		            </c:forEach>
		            <a class="weui-cell weui-cell_access" href="javascript:;">
		                <div class="weui-cell__hd">抄送人：
		                <c:forEach items="${oaCommonAudit.oaCommonAuditRecordList}" var="oaCommonAuditRecord">
		                <c:if test="${oaCommonAuditRecord.dealType == 1}">
		                	${oaCommonAuditRecord.user.name}  
		                </c:if>
		                </c:forEach>
		                </div>
		                
		            </a>
		        </div>
        
            </div>
		    </div>
			
		    
		<c:if test="${fns:getUser().id == oaCommonAudit.currentBy.id && oaCommonAudit.status == 1}">
		    
		    <div class="weui-panel weui-panel_access">
		    	<div class="weui-cells__title">待我审批</div>
		        <div class="weui-panel__bd">
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">审批<font color="red">*</font></h4>
		            <p class="weui-media-box__desc">
		            	<input type="radio" name="auditStatus" value="2" class="i-checks" checked="checked">同意 
						&nbsp;<input type="radio" name="auditStatus" value="3" class="i-checks">拒绝
		            </p>
		          </div>
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">意见(非必填)</h4>
		            <p class="weui-media-box__desc">
		            	<textarea id="auditNote" name="auditNote" rows="" cols="2" class="weui-textarea" maxlength="200" placeholder="请输入审批意见"></textarea>
		            </p>
		          </div>
		       </div>
		    </div>
		</c:if>
		
	
	
    
     <div class="weui-tabbar">
     	<c:if test="${fns:getUser().id == oaCommonAudit.currentBy.id && oaCommonAudit.status == 1}">
		<a id="btnSubmit" href="#" onclick="doSubmit()"  class="weui-tabbar__item weui-navbar__item">
	          <p class="">提交</p>
		</a>
		</c:if>
		
	 </div>
	 </form:form>
</div>
</body>
</html>