<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>充值订单列表</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
		});
		//打开微信支付对话框(添加修改)
		function openWxPayDialog(title,url,width,height,target){
			
			if(navigator.userAgent.match(/(iPhone|iPod|Android|ios)/i)){//如果是移动端，就使用自适应大小弹窗
				width='auto';
				height='auto';
			}else{//如果是PC端，根据用户设置的width和height显示。
			
			}
			
			top.layer.open({
			    type: 2,  
			    area: [width, height],
			    title: title,
		        maxmin: false, //开启最大化最小化按钮
			    content: url ,
			    btn: ['完成支付', '关闭'],
			    yes: function(index, layero){
			    	
			    	window.location.href="${ctx}/pay/payRechargeOrder";
			    	top.layer.close(index);//关闭对话框。
			      
					
				  },
				  cancel: function(index){ 
			       }
			}); 	
			
		}
		//打开支付宝支付窗口
		function openAliPayPage(url){
			window.open(url);
		}
	</script>
</head>
<body class="">
	<div class="">
		<div class="">
			<div class="row dashboard-header gray-bg">
				<h5>充值订单列表 </h5>
				<div class="pull-right">
					<button id="searchBtn" class="btn btn-white btn-sm" title="搜索"><i class="fa fa-search"></i> 搜索</button>
					<shiro:hasPermission name="pay:payRechargeOrder:add">
						<table:addRow url="${ctx}/pay/payRechargeOrder/form" title="充值订单" ></table:addRow><!-- 增加按钮 -->
					</shiro:hasPermission>
				</div>
			</div>
			<div class="ibox-content">
			<sys:message content="${message}"/>
				
				<!-- 查询条件 -->
				<div class="row">
					<div class="col-sm-12">
						<form:form id="searchForm" modelAttribute="payRechargeOrder" action="${ctx}/pay/payRechargeOrder/" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
							<table:searchRow></table:searchRow>
								<div class="form-group"><span>订单编号：</span>
									<form:input path="no" htmlEscape="false" maxlength="50" class="form-control input-small"/>
								</div>
								<div class="form-group"><span>支付完成状态：</span>
									<form:select path="status" class="form-control input-small" cssClass="input-small">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>支付类型：</span>
									<form:select path="payType" class="form-control input-small" cssClass="input-small">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('pay_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>业务日期：</span>
									<div class="input-group date datepicker">
			                            <input name="beginCreateDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${payRechargeOrder.beginCreateDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
			                            <span class="input-group-addon">
			                                    <span class="fa fa-calendar"></span>
			                            </span>
			                        </div>
			                         - 
			                        <div class="input-group" data-autoclose="true">
			                        	 <input name="endCreateDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${payRechargeOrder.endCreateDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
			                            <span class="input-group-addon">
			                                    <span class="fa fa-calendar"></span>
			                            </span>
			                        </div>
								</div>
								<div class="form-group">
									<button class="btn btn-white btn-sm " onclick="search()"><i class="fa fa-search"></i> 查询</button>
									<button class="btn btn-white btn-sm " onclick="resetSearch()"><i class="fa fa-refresh"></i> 重置</button>
								</div>
						</form:form>
					</div>
				</div>
				
					
				<!-- 表格 -->
				<div class="table-responsive">
				<table id="contentTable" class="table table-bordered table-striped table-hover">
					<thead>
						<tr>
							<th width="30px"><input type="checkbox" class="i-checks"></th>
							<th class="sort-column a.no">订单编号</th>
							<th class="sort-column a.amount">订单金额</th>
							<th class="sort-column a.status">支付完成状态</th>
							<th class="sort-column a.pay_type">支付类型</th>
							<th class="sort-column a.create_date">创建时间</th>
							<th class="sort-column a.create_by">创建人</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="payRechargeOrder">
						<tr>
							<td><input type="checkbox" id="${payRechargeOrder.id}" class="i-checks"></td>
							<td>
								<a href="#" onclick="openDialogView('查看充值订单', '${ctx}/pay/payRechargeOrder/view?id=${payRechargeOrder.id}','800px', '500px')">
								${payRechargeOrder.no}
							</a></td>
							<td>
								${payRechargeOrder.amount}
							</td>
							<td>
								${fns:getDictLabel(payRechargeOrder.status, 'yes_no', '')}
							</td>
							<td>
								${fns:getDictLabel(payRechargeOrder.payType, 'pay_type', '')}
							</td>
							<td>
								<fmt:formatDate value="${payRechargeOrder.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</td>
							<td>
								${payRechargeOrder.createBy.name}
							</td>
							<td>
								<c:if test="${payRechargeOrder.status == 0}">
									
								
								<a href="#" onclick="openWxPayDialog('收银台', '${ctx}/pay/payRechargeOrder/wxPayForm?id=${payRechargeOrder.id}','800px', '500px')" class="btn btn-success btn-xs" title="微信支付"><i class="fa fa-comments"></i> 微信支付</a>
								
								<a href="#" onclick="openAliPayPage('${ctx}/pay/aliPay/toPay?id=${payRechargeOrder.id}')" class="btn btn-warning btn-xs" title="微信支付"><i class="fa fa-cny"></i> 支付宝支付</a>
								
								</c:if>
								<%-- 
								<shiro:hasPermission name="pay:payRechargeOrder:view">
									<a href="#" onclick="openDialogView('查看充值订单', '${ctx}/pay/payRechargeOrder/view?id=${payRechargeOrder.id}','800px', '500px')" class="btn btn-info btn-xs" title="查看"><i class="fa fa-search-plus"></i> 查看</a>
								</shiro:hasPermission>
								<shiro:hasPermission name="pay:payRechargeOrder:edit">
			    					<a href="#" onclick="openDialog('修改充值订单', '${ctx}/pay/payRechargeOrder/form?id=${payRechargeOrder.id}','800px', '500px')" class="btn btn-success btn-xs" title="修改"><i class="fa fa-edit"></i><span class="hidden-xs">修改</span></a>
								</shiro:hasPermission>
								
								<shiro:hasPermission name="pay:payRechargeOrder:del">
									<a href="${ctx}/pay/payRechargeOrder/delete?id=${payRechargeOrder.id}" onclick="return confirmx('确认要删除该充值订单吗？', this.href)" class="btn  btn-danger btn-xs" title="删除"><i class="fa fa-trash"></i><span class="hidden-xs">删除</span></a> 
								</shiro:hasPermission>
								--%>
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
</body>
</html>