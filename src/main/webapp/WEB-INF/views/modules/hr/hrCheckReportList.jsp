<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
    <title>月度打卡汇总列表</title>
    <meta name="decorator" content="default"/>
    <script type="text/javascript">
    </script>
</head>
<body class="gray-bg">
<div class="wrapper-content">
    <c:if test="${not empty configMsg}">
        <div class="alert alert-info">
            打卡数据来源于企业微信，获取企业微信打卡数据需要配置打卡应用的Secret，请前往进行配置<a class="alert-link"
                                                            href="${ctx}/sys/sysConfig/secret">立即配置</a>.
        </div>
    </c:if>
    <div class="tabs-container">
        <ul class="nav nav-tabs">
            <li><a href="${ctx}/hr/hrCheckReportDay/">按日统计</a></li>
            <li class="active"><a href="${ctx}/hr/hrCheckReport/">按月统计</a></li>
            <li class="pull-right">
                <div style="margin:5px;">
                    <shiro:hasPermission name="hr:hrCheckReport:export">
                        <table:exportExcel url="${ctx}/hr/hrCheckReportDay/export"
                                           label="导出月报"></table:exportExcel><!-- 导出按钮 -->
                    </shiro:hasPermission>
                    <shiro:hasPermission name="hr:hrCheckReport:list">
                        <a href="${ctx}/hr/hrCheckRule/" class="btn btn-white btn-sm"><i class="fa fa-cog"></i> 打卡规则</a>
                    </shiro:hasPermission>
                </div>
            </li>
        </ul>

        <div class="tab-content">
            <div id="tab-1" class="tab-pane">
                <div class="panel-body">

                </div>
            </div>
            <div id="tab-2" class="tab-pane active">
                <div class="panel-body">
                    <sys:message content="${message}"/>
                    <!-- 查询栏 -->
                    <div class="row">
                        <div class="col-sm-12">
                            <form:form id="searchForm" modelAttribute="hrCheckReport" action="${ctx}/hr/hrCheckReport/"
                                       method="post" class="form-inline">
                                <input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
                                <input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
                                <table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}"
                                                  callback="sortOrRefresh();"/><!-- 支持排序 -->

                                <div class="form-group"><span>时间：</span>
                                    <div class="input-group date datepicker">
                                        <input name="beginCheckinDate" type="text" readonly="readonly"
                                               class="form-control input-small"
                                               value="<fmt:formatDate value="${hrCheckReport.beginCheckinDate}" pattern="yyyy-MM"/>"
                                               onclick="WdatePicker({dateFmt:'yyyy-MM',isShowClear:true});">
                                        <span class="input-group-addon">
				                                    <span class="fa fa-calendar"></span>
				                            </span>
                                    </div>
                                    -
                                    <div class="input-group" data-autoclose="true">
                                        <input name="endCheckinDate" type="text" readonly="readonly"
                                               class="form-control input-small"
                                               value="<fmt:formatDate value="${hrCheckReport.endCheckinDate}" pattern="yyyy-MM"/>"
                                               onclick="WdatePicker({dateFmt:'yyyy-MM',isShowClear:true});">
                                        <span class="input-group-addon">
				                                    <span class="fa fa-calendar"></span>
				                            </span>
                                    </div>
                                </div>
                                <div class="form-group"><span>部门：</span>
                                    <sys:treeselect id="office" name="office.id" value="${hrCheckReport.office.id}"
                                                    labelName="office.name" labelValue="${hrCheckReport.office.name}"
                                                    title="部门" url="/sys/office/treeData?type=2"
                                                    cssClass="form-control input-small" allowClear="true"
                                                    notAllowSelectParent="false"/>
                                </div>

                                <div class="form-group"><span>状态：</span>
                                    <form:select path="checkinStatus" class="form-control input-medium"
                                                 cssClass="input-small">
                                        <form:option value="" label="全部"/>
                                        <form:options items="${fns:getDictList('checkin_status')}" itemLabel="label"
                                                      itemValue="value" htmlEscape="false"/>
                                    </form:select>
                                </div>
                                <div class="form-group"><span>用户：</span>
                                    <form:select path="user.id" class="form-control input-small">
                                        <form:option value="" label=""/>
                                        <form:options items="${fns:getUserList()}" itemLabel="name" itemValue="id"
                                                      htmlEscape="false"/>
                                    </form:select>
                                        <%--
                                        <sys:treeselect id="user" name="user.id" value="${hrCheckReport.user.id}" labelName="user.name" labelValue="${hrCheckReport.user.name}"
                                            title="用户" url="/sys/office/treeData?type=3" cssClass="form-control input-small" allowClear="true" notAllowSelectParent="true"/>
                                            --%>
                                </div>
                                <div class="form-group">
                                    <button class="btn btn-white btn-sm " onclick="search()"><i
                                            class="fa fa-search"></i> 查询
                                    </button>
                                    <button class="btn btn-white btn-sm " onclick="resetSearch()"><i
                                            class="fa fa-refresh"></i> 重置
                                    </button>
                                </div>

                            </form:form>
                        </div>
                    </div>

                    <!-- 数据表格 -->
                    <div class="table-responsive">
                        <table id="contentTable" class="table table-bordered table-striped table-hover">
                            <thead>
                            <tr>
                                <th>月份</th>
                                <th>姓名</th>
                                <th>部门</th>
                                <th>所属规则</th>
                                <th>应打卡天数</th>
                                <th>正常天数</th>
                                <th>异常天数</th>
                                <th>补卡</th>
                                <th>年假</th>
                                <th>事假</th>
                                <th>病假</th>
                                <th>婚假</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach items="${page.list}" var="hrCheckReport">
                                <tr>
                                    <td>
                                        <a href="${ctx}/hr/hrCheckReport/view?id=${hrCheckReport.id}" title="查看">
                                            <fmt:formatDate value="${hrCheckReport.checkMonth}" pattern="yyyy-MM"/>

                                        </a>
                                    </td>
                                    <td>
                                            ${hrCheckReport.user.name}
                                    </td>
                                    <td>
                                            ${hrCheckReport.office.name}
                                    </td>
                                    <td>
                                            ${hrCheckReport.groupname}
                                    </td>
                                    <td>
                                            ${hrCheckReport.attendanceDay}
                                    </td>
                                    <td>
                                            ${hrCheckReport.normalDay}
                                    </td>
                                    <td>
                                            ${hrCheckReport.abnormalDay}
                                    </td>
                                    <td>
                                            ${hrCheckReport.attendanceCard}
                                    </td>
                                    <td>
                                            ${hrCheckReport.annualLeave/24}
                                    </td>
                                    <td>
                                            ${hrCheckReport.unpaidLeave/24}
                                    </td>
                                    <td>${hrCheckReport.sickLeave/24}
                                    </td>
                                    <td>
                                            ${hrCheckReport.maritalLeave/24}
                                    </td>

                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                        <table:page page="${page}"></table:page>
                    </div>

                </div>
            </div>

        </div>
    </div>

</div>
</body>
</html>