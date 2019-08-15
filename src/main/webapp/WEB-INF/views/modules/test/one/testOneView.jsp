<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>商品信息(单表)查看</title>
	<meta name="decorator" content="default"/>
</head>
<body class="gray-bg">
<div class="wrapper-content">
<div class="ibox">
	<div class="ibox-title">
		<h5>商品信息(单表)查看</h5>
	</div>
	<div class="ibox-content">
		<sys:message content="${message}"/>
		<form:form id="inputForm" modelAttribute="testOne" action="${ctx}/test/one/testOne/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
			<h4 class="page-header">基本信息</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">商品分类：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${testOne.testTree.name}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">状态：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${fns:getDictLabel(testOne.status, 'use_status', '')}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">商品编码：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${testOne.no}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">商品名称：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${testOne.name}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">基本单位：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${fns:getDictLabel(testOne.unitType, 'unit_type', '')}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">规格：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${testOne.spec}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">颜色：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${testOne.color}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">尺寸：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${testOne.size}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">零售价：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${testOne.salePrice}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">批发价：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${testOne.batchPrice}
							</p>
						</div>
					</div>
				</div>
			</div>
			<h4 class="page-header">图片信息</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">商品图片：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
								<img alt="" src="${testOne.productImg}" width="100px" height="100px">
							</p>
						</div>
					</div>
				</div>
			</div>
			<h4 class="page-header">描述信息</h4>
			<div class="row">
				<div class="col-sm-12">
					<div class="view-group">
						<label class="col-sm-2 control-label">商品描述：</label>
						<div class="col-sm-10">
							<p class="form-control-static">
							${testOne.content}
							</p>
						</div>
					</div>
				</div>
			</div>
			<h4 class="page-header">操作信息</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">更新者：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${testOne.updateBy.name}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">更新时间：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							<fmt:formatDate value="${testOne.updateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</p>
						</div>
					</div>
				</div>
			</div>
			
			<div class="hr-line-dashed"></div>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<div class="col-sm-offset-2 col-sm-10">
							<shiro:hasPermission name="test:one:testOne:edit">
						    	<a href="${ctx}/test/one/testOne/form?id=${testOne.id}" class="btn btn-success" title="修改">修改</a>
							</shiro:hasPermission>
							<shiro:hasPermission name="test:one:testOne:del">
								<a href="${ctx}/test/one/testOne/delete?id=${testOne.id}" onclick="return confirmx('确认要删除该商品信息(单表)吗？', this.href)" class="btn btn-danger" title="删除">删除</a> 
							</shiro:hasPermission>
							<a id="btnCancel" class="btn btn-white" onclick="history.go(-1)">返回</a>
						</div>
					</div>
				</div>
			</div>
		</form:form>
	</div>
</div>
</div>
</body>
</html>