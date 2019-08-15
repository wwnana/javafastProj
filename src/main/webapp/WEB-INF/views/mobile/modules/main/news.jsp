<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html>
  <head>
      <title>提醒</title>
      <%@ include file="/WEB-INF/views/include/weuihead.jsp"%>
  </head>
  <body ontouchstart>

    <div class="page-content page__bd">
      <div class="weui-cells__title">我的待办</div>
      <div class="weui-panel weui-panel_access">
        <div class="weui-panel__bd">
        
          <c:forEach items="${calenderPage.list }" var="myCalendar" varStatus="status">
          <a href="javascript:void(0);" class="weui-media-box weui-media-box_appmsg">
            <div class="weui-media-box__hd" style="background-color: #35ae98;color: #fff;">
              	提醒
            </div>
            <div class="weui-media-box__bd">
              <h4 class="weui-media-box__title">${myCalendar.start}<c:if test="${not empty myCalendar.end}"> 至 </c:if>${myCalendar.end}</h4>
              <p class="weui-media-box__desc">${myCalendar.title }</p>
            </div>
            <div class="weui-media-box__desc"></div>
          </a>
          </c:forEach>
       
          <c:forEach items="${oaCommonAuditPage.list}" var="oaAudit" varStatus="status">
          <a href="${ctx}/mobile/oa/oaCommonAudit/view?id=${oaAudit.id}" class="weui-media-box weui-media-box_appmsg">
            <div class="weui-media-box__hd" style="background-color: #f7714d;color: #fff;">
              	审批
            </div>
            <div class="weui-media-box__bd">
              <h4 class="weui-media-box__title">${oaAudit.title }</h4>
              <p class="weui-media-box__desc">${oaAudit.createBy.name }</p>
            </div>
            <div class="weui-media-box__desc">${fns:getTimeDiffer(oaAudit.createDate)}</div>
          </a>
          </c:forEach>
          
          <c:forEach items="${crmContactRecordList.list }" var="crmContactRecord" varStatus="status">
          <a href="${ctx}/mobile/crm/crmContactRecord/view?id=${crmContactRecord.id}" class="weui-media-box weui-media-box_appmsg">
            <div class="weui-media-box__hd" style="background-color:#94c53e;color: #fff;">
              	拜访
            </div>
            <div class="weui-media-box__bd">
              <h4 class="weui-media-box__title"><fmt:formatDate value="${crmContactRecord.contactDate}" pattern="yyyy-MM-dd"/></h4>
              <p class="weui-media-box__desc">${crmContactRecord.content}</p>
            </div>
            <div class="weui-media-box__desc">${fns:getTimeDiffer(crmContactRecord.createDate)}</div>
          </a>
          </c:forEach>
          
          <c:forEach items="${taskPage.list }" var="task" varStatus="status">
          <a href="${ctx}/mobile/oa/oaTask/view?id=${task.id}" class="weui-media-box weui-media-box_appmsg">
            <div class="weui-media-box__hd" style="background-color:#9577cd;color: #fff;">
              	任务
            </div>
            <div class="weui-media-box__bd">
              <h4 class="weui-media-box__title">${task.name }</h4>
              <p class="weui-media-box__desc">${fns:abbr(task.content,50)}</p>
            </div>
            <div class="weui-media-box__desc">${fns:getTimeDiffer(task.createDate)}</div>
          </a>
          </c:forEach>
          
          <c:forEach items="${projectPage.list }" var="project" varStatus="status">
          <a href="${ctx}/mobile/oa/oaProject/view?id=${project.id}" class="weui-media-box weui-media-box_appmsg">
            <div class="weui-media-box__hd" style="background-color:#29e;color: #fff;">
              	项目
            </div>
            <div class="weui-media-box__bd">
              <h4 class="weui-media-box__title">${project.name }</h4>
              <p class="weui-media-box__desc">${fns:abbr(project.content,50)}</p>
            </div>
            <div class="weui-media-box__desc">${fns:getTimeDiffer(project.createDate)}</div>
          </a>
          </c:forEach>
          
          
        </div>
      </div>
      
     
    
   </div>   
   <c:set value="3" var="nav"></c:set>
 	<%@ include file="foot.jsp"%>
  </body>
</html>
