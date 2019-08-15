<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
    <title>打卡规则查看</title>
    <meta name="decorator" content="default"/>
</head>
<body class="gray-bg">
<div class="wrapper-content">
    <div class="ibox">
        <div class="ibox-title">
            <h5>打卡规则查看</h5>
        </div>
        <div class="ibox-content">
            <jsp:useBean id="dateValue" class="java.util.Date"/> <!-- 通过jsp:userBean标签引入java.util.Date日期类 -->
            <sys:message content="${message}"/>
            <form:form id="inputForm" modelAttribute="hrCheckRuleDto" action="${ctx}/hr/hrCheckRuleDto/save"
                       method="post" class="form-horizontal">
                <h4 class="page-header">基本信息</h4>
                <div class="row">
                    <div class="col-sm-12">
                        <div class="view-group">
                            <label class="col-sm-2 control-label">规则名称：</label>
                            <div class="col-sm-10">
                                <p class="form-control-static">
                                        ${hrCheckRuleDto.groupname}
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-12">
                        <div class="view-group">
                            <label class="col-sm-2 control-label">打卡规则类型：</label>
                            <div class="col-sm-10">
                                <p class="form-control-static">
                                        ${fns:getDictLabel(hrCheckRuleDto.grouptype, '', '')}
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
                <%-- 
                <div class="row">
                    <div class="col-sm-12">
                        <div class="view-group">
                            <label class="col-sm-2 control-label">打卡规则ID：</label>
                            <div class="col-sm-10">
                                <p class="form-control-static">
                                        ${hrCheckRuleDto.groupid}
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
				--%>
                <h4 class="page-header">岗位要求</h4>
                <div class="row">
                    <div class="col-sm-6">
                        <div class="view-group">
                            <label class="col-sm-4 control-label">弹性时间：</label>
                            <div class="col-sm-8">
                                <p class="form-control-static">
                                        ${hrCheckRuleDto.flexTime}
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-6">
                        <div class="view-group">
                            <label class="col-sm-4 control-label">下班不需要打卡：</label>
                            <div class="col-sm-8">
                                <p class="form-control-static">
                                        ${hrCheckRuleDto.noneedOffwork==true?'是':'否'}
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-6">
                        <div class="view-group">
                            <label class="col-sm-4 control-label">打卡时间限制：</label>
                            <div class="col-sm-8">
                                <p class="form-control-static">
                                        ${hrCheckRuleDto.limitAheadtime}
                                </p>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-6">
                        <div class="view-group">
                            <label class="col-sm-4 control-label">打卡时间：</label>
                            <div class="col-sm-8">
                                <c:forEach var="checkbean" items="${hrCheckRuleDto.checkintime}">
                                    <p class="form-control-static">
                                        <fmt:formatNumber type="number" pattern="00"
                                                          value="${checkbean.work_sec/3600}"/>:<fmt:formatNumber
                                            type="number" pattern="00" value="${checkbean.work_sec%3600/60}"/> -
                                        <fmt:formatNumber type="number" pattern="00"
                                                          value="${checkbean.off_work_sec/3600}"/>:<fmt:formatNumber
                                            type="number" pattern="00" value="${checkbean.off_work_sec%3600/60}"/>

                                    </p>
                                </c:forEach>
                            </div>
                        </div>
                    </div>
                </div>
                <h4 class="page-header">打卡时间</h4>
                <div class="row">
                    <div class="col-sm-6">
                        <div class="view-group">
                            <label class="col-sm-4 control-label">打卡时间：</label>
                            <div class="col-sm-6">
                                <c:forEach var="checkbean" items="${hrCheckRuleDto.checkintime}">
                                    <p class="form-control-static">
                                        上班： <fmt:formatNumber type="number" pattern="00"
                                                              value="${checkbean.work_sec/3600}"/>:<fmt:formatNumber
                                            type="number" pattern="00" value="${checkbean.work_sec%3600/60}"/> -
                                        下班： <fmt:formatNumber type="number" pattern="00"
                                                              value="${checkbean.off_work_sec/3600}"/>:<fmt:formatNumber
                                            type="number" pattern="00" value="${checkbean.off_work_sec%3600/60}"/>
                                    </p>
                                </c:forEach>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-6">
                        <div class="view-group">
                            <label class="col-sm-4 control-label">提醒：</label>
                            <div class="col-sm-6">
                                <c:forEach var="checkbean" items="${hrCheckRuleDto.checkintime}">
                                    <p class="form-control-static">
                                        上班： <fmt:formatNumber type="number" pattern="00"
                                                              value="${checkbean.remind_work_sec/3600}"/>:<fmt:formatNumber
                                            type="number" pattern="00" value="${checkbean.remind_work_sec%3600/60}"/> -
                                        下班： <fmt:formatNumber type="number" pattern="00"
                                                              value="${checkbean.remind_off_work_sec/3600}"/>:<fmt:formatNumber
                                            type="number" pattern="00"
                                            value="${checkbean.remind_off_work_sec%3600/60}"/>
                                    </p>
                                </c:forEach>
                            </div>
                        </div>
                    </div>
                </div>
                <h4 class="page-header">特殊日期</h4>
                <div class="row">
                    <div class="col-sm-6">
                        <div class="view-group">
                            <label class="col-sm-4 control-label">必须打卡日期：</label>
                            <div class="col-sm-6">
                                <c:forEach var="specwork" items="${hrCheckRuleDto.specWorkDays}">
                                    ${specwork.notes}
                                    <jsp:setProperty name="dateValue" property="time"
                                                     value="${specwork.timestamp*1000}"/>
                                    <!-- 使用jsp:setProperty标签将时间戳设置到Date的time属性中 -->
                                    <fmt:formatDate value="${dateValue}" pattern="yyyy-MM-dd"/>
                                    <c:forEach var="checkbean" items="${specwork.checkintime}">

                                        <p class="form-control-static">
                                            上班： <fmt:formatNumber type="number" pattern="00"
                                                                  value="${checkbean.work_sec/3600}"/>:<fmt:formatNumber
                                                type="number" pattern="00" value="${checkbean.work_sec%3600/60}"/> -
                                            下班： <fmt:formatNumber type="number" pattern="00"
                                                                  value="${checkbean.off_work_sec/3600}"/>:<fmt:formatNumber
                                                type="number" pattern="00" value="${checkbean.off_work_sec%3600/60}"/>
                                            <br>
                                        </p>
                                    </c:forEach>
                                </c:forEach>
                            </div>
                        </div>
                    </div>

                </div>
               <div class="row">
                   <div class="col-sm-6">
                       <div class="view-group">
                           <label class="col-sm-4 control-label">不用打卡日期：</label>
                           <div class="col-sm-6">
                               <c:forEach var="specwork" items="${hrCheckRuleDto.specOffDays}">
                                   ${specwork.notes}
                                   <jsp:setProperty name="dateValue" property="time"
                                                    value="${specwork.timestamp*1000}"/>
                                   <!-- 使用jsp:setProperty标签将时间戳设置到Date的time属性中 -->
                                   <fmt:formatDate value="${dateValue}" pattern="yyyy-MM-dd"/>
                                   <%--<c:forEach var="checkbean" items="${specwork.checkintime}">

                                       <p class="form-control-static">
                                           上班：  <fmt:formatNumber type="number" pattern="00" value="${checkbean.work_sec/3600}"/>:<fmt:formatNumber type="number" pattern="00" value="${checkbean.work_sec%3600/60}"/> -
                                           下班：  <fmt:formatNumber type="number" pattern="00" value="${checkbean.off_work_sec/3600}"/>:<fmt:formatNumber type="number" pattern="00" value="${checkbean.off_work_sec%3600/60}"/>
                                           <br>
                                       </p>
                                   </c:forEach>--%>
                               </c:forEach>
                           </div>
                       </div>
                   </div>
               </div>
                <h4 class="page-header">WIFI信息</h4>
                <div class="row">
                    <div class="col-sm-6">
                        <div class="view-group">
                            <label class="col-sm-4 control-label"></label>
                            <div class="col-sm-8">
                                <c:forEach var="wifi" items="${hrCheckRuleDto.wifimacInfos}">
                                    <p class="form-control-static">
                                            ${wifi.name}&nbsp;&nbsp;${wifi.mac}
                                    </p>
                                </c:forEach>
                            </div>
                        </div>
                    </div>
                </div>
                <h4 class="page-header">位置打卡地点信息</h4>
                <div class="row">
                    <div class="col-sm-6">
                        <div class="view-group">
                            <label class="col-sm-4 control-label">位置：</label>
                            <div class="col-sm-8">
                                <c:forEach var="loc" items="${hrCheckRuleDto.locInfos}">
                                    <p class="form-control-static">
                                            ${loc.loc_title}&nbsp;&nbsp;${loc.loc_detail}&nbsp;|&nbsp;${loc.distance}米
                                    </p>
                                </c:forEach>
                            </div>
                        </div>
                    </div>
                </div>
                <h4 class="page-header">其它</h4>

                <div class="row">
                    <div class="col-sm-6">
                        <div class="view-group">
                            <label class="col-sm-4 control-label">同步节假日：</label>
                            <div class="col-sm-8">
                                <p class="form-control-static">
                                        ${hrCheckRuleDto.syncHolidays==true?"是":"否"}
                                </p>
                            </div>
                        </div>
                    </div>


                </div>
                <div class="row">
                    <div class="col-sm-6">
                        <div class="view-group">
                            <label class="col-sm-4 control-label">拍照打卡：</label>
                            <div class="col-sm-8">
                                <p class="form-control-static">
                                        ${hrCheckRuleDto.needPhoto==true?"是":"否"}
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-6">
                        <div class="view-group">
                            <label class="col-sm-4 control-label">备注不允许上传本地图片，只能拍照：</label>
                            <div class="col-sm-8">
                                <p class="form-control-static">
                                        ${hrCheckRuleDto.noteCanUseLocalPic==true?"是":"否"}
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-6">
                        <div class="view-group">
                            <label class="col-sm-4 control-label">非工作日允许打卡：</label>
                            <div class="col-sm-8">
                                <p class="form-control-static">
                                        ${hrCheckRuleDto.allowCheckinOffworkday==true?"是":"否"}
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-6">
                        <div class="view-group">
                            <label class="col-sm-4 control-label">补卡申请（员工异常打卡时可提交申请，审批通过后修正异常）：</label>
                            <div class="col-sm-8">
                                <p class="form-control-static">
                                        ${hrCheckRuleDto.allowApplyOffworkday==true?"是":"否"}
                                </p>
                            </div>
                        </div>
                    </div>
                </div>


                <div class="hr-line-dashed"></div>
                <div class="form-actions">

                    <a id="btnCancel" class="btn btn-white" onclick="history.go(-1)">返回</a>
                </div>
            </form:form>
        </div>
    </div>
</div>
</body>
</html>