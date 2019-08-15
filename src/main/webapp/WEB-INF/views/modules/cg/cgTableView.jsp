<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>表单设计查看</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">		
	</script>
</head>
<body class="gray-bg">
<div class="wrapper-content">
<div class="ibox">
	<div class="ibox-title">
		<h5>表单设计查看</h5>
	</div>
	<div class="ibox-content">
	<sys:message content="${message}"/>
	<div class="row">
		<div class="col-sm-12">
			<div class="text-center p-lg">
            	<h2>表单设计</h2>
            </div>
		</div>
	</div>
	<form:form id="inputForm" modelAttribute="cgTable" action="${ctx}/cg/cgTable/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
	 <table class="table table-bordered table-condensed dataTables-example dataTable no-footer">
		<tbody>
			<tr>
					<td class="width-15 active"><label class="pull-right">表名称：</label></td>
					<td class="width-35">
						${cgTable.name}
					</td>
					<td class="width-15 active"><label class="pull-right">表描述：</label></td>
					<td class="width-35">
						${cgTable.comments}
					</td>
				</tr>
				<tr> 
					<td class="width-15 active"><label class="pull-right">实体类名称：</label></td>
					<td class="width-35">
						${cgTable.className}
					</td>
					<td class="width-15 active"><label class="pull-right">关联父表：</label></td>
					<td class="width-35">
						${cgTable.parentTable}
					</td>
				</tr>
				<tr> 
					<td class="width-15 active"><label class="pull-right">关联父表外键：</label></td>
					<td class="width-35">
						${cgTable.parentTableFk}
					</td>
					<td class="width-15 active"><label class="pull-right">生成模板分类：</label></td>
					<td class="width-35">
						${cgTable.cgCategory}
					</td>
				</tr>
				<tr> 
					<td class="width-15 active"><label class="pull-right">生成包路径：</label></td>
					<td class="width-35">
						${cgTable.packageName}
					</td>
					<td class="width-15 active"><label class="pull-right">生成模块名：</label></td>
					<td class="width-35">
						${cgTable.moduleName}
					</td>
				</tr>
				<tr> 
					<td class="width-15 active"><label class="pull-right">生成子模块名：</label></td>
					<td class="width-35">
						${cgTable.subModuleName}
					</td>
					<td class="width-15 active"><label class="pull-right">生成功能名：</label></td>
					<td class="width-35">
						${cgTable.functionName}
					</td>
				</tr>
				<tr> 
					<td class="width-15 active"><label class="pull-right">生成功能名（简写）：</label></td>
					<td class="width-35">
						${cgTable.functionNameSimple}
					</td>
					<td class="width-15 active"><label class="pull-right">生成功能作者：</label></td>
					<td class="width-35">
						${cgTable.functionAuthor}
					</td>
				</tr>
				<tr> 
					<td class="width-15 active"><label class="pull-right">编辑页面模型:0:弹窗，1:跳转：</label></td>
					<td class="width-35">
						${fns:getDictLabel(cgTable.pageModel, 'page_model', '')}
					</td>
					<td class="width-15 active"><label class="pull-right">树形列表数据：</label></td>
					<td class="width-35">
						${cgTable.treeData}
					</td>
				</tr>
				<tr> 
					<td class="width-15 active"><label class="pull-right">是否支持列表多选：</label></td>
					<td class="width-35">
						${fns:getDictLabel(cgTable.isListCheckbox, 'yes_no', '')}
					</td>
					<td class="width-15 active"><label class="pull-right">是否生成列表选择器：</label></td>
					<td class="width-35">
						${fns:getDictLabel(cgTable.isTableSelect, 'yes_no', '')}
					</td>
				</tr>
				<tr> 
					<td class="width-15 active"><label class="pull-right">是否支持导入导出：</label></td>
					<td class="width-35">
						${fns:getDictLabel(cgTable.isExcel, 'yes_no', '')}
					</td>
					<td class="width-15 active"><label class="pull-right">同步数据库：</label></td>
					<td class="width-35">
						${fns:getDictLabel(cgTable.isSynch, 'yes_no', '')}
					</td>
				</tr>
				<tr> 
					<td class="width-15 active"><label class="pull-right">更新者：</label></td>
					<td class="width-35">
						${cgTable.updateBy.id}
					</td>
					<td class="width-15 active"><label class="pull-right">更新时间：</label></td>
					<td class="width-35">
						<fmt:formatDate value="${cgTable.updateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
					</td>
				</tr>
				<tr> 
					<td class="width-15 active"><label class="pull-right">备注信息：</label></td>
					<td class="width-35">
						${cgTable.remarks}
					</td>
				</tr>
			</tbody>
		</table>
		<!-- 明细 -->
		<div class="tabs-container">
	    	<ul class="nav nav-tabs">
				<li class="active"><a data-toggle="tab" href="#tab-1" aria-expanded="true">表单字段</a></li>
	    	</ul>
          	<div class="tab-content">
          	   	<div class="panel-body">
					<div id="tab-1" class="tab-pane table-responsive active">
					<table id="contentTable" class="table table-striped table-bordered table-hover table-condensed">
						<thead>
							<tr>
								<th>列名</th>
								<th>说明</th>
								<th>字段类型</th>
								<th>JAVA类型</th>
								<th>JAVA字段名</th>
								<th>主键</th>
								<th>插入</th>
								<th>更新</th>
								<th>列表</th>
								<th>排序</th>
								<th>查询</th>
								<th>查询方式</th>
								<th>表单控件</th>
								<th>字典类型</th>
								<th>非空</th>
								<th>校验类型</th>
								<th>其它设置（扩展字段JSON）</th>
								<th>排序（升序）</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach items="${cgTable.columnList}" var="cgTableColumn">
								<tr>
											<td>
												${cgTableColumn.name}
											</td>
											<td>
												${cgTableColumn.comments}
											</td>
											<td>
												${fns:getDictLabel(cgTableColumn.jdbcType, '', '')}
											</td>
											<td>
												${fns:getDictLabel(cgTableColumn.javaType, '', '')}
											</td>
											<td>
												${cgTableColumn.javaField}
											</td>
											<td>
												${fns:getDictLabel(cgTableColumn.isPk, '', '')}
											</td>
											<td>
												${fns:getDictLabel(cgTableColumn.isInsert, '', '')}
											</td>
											<td>
												${fns:getDictLabel(cgTableColumn.isEdit, '', '')}
											</td>
											<td>
												${fns:getDictLabel(cgTableColumn.isList, '', '')}
											</td>
											<td>
												${fns:getDictLabel(cgTableColumn.isSort, '', '')}
											</td>
											<td>
												${fns:getDictLabel(cgTableColumn.isQuery, '', '')}
											</td>
											<td>
												${fns:getDictLabel(cgTableColumn.queryType, '', '')}
											</td>
											<td>
												${fns:getDictLabel(cgTableColumn.showType, '', '')}
											</td>
											<td>
												${cgTableColumn.dictType}
											</td>
											<td>
												${fns:getDictLabel(cgTableColumn.isNotNull, '', '')}
											</td>
											<td>
												${fns:getDictLabel(cgTableColumn.validateType, '', '')}
											</td>
											<td>
												${cgTableColumn.settings}
											</td>
											<td>
												${cgTableColumn.sort}
											</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>					
					</div>
				</div>
			</div>
		</div>
		
		<br>
			<div class="form-actions">
				<shiro:hasPermission name="cg:cgTable:edit">
			    	<a href="${ctx}/cg/cgTable/form?id=${cgTable.id}" class="btn btn-success" title="修改"><i class="fa fa-edit"></i><span class="hidden-xs">修改</span></a>
				</shiro:hasPermission>
				<shiro:hasPermission name="cg:cgTable:del">
					<a href="${ctx}/cg/cgTable/delete?id=${cgTable.id}" onclick="return confirmx('确认要删除该表单设计吗？', this.href)" class="btn  btn-danger" title="删除"><i class="fa fa-trash"></i><span class="hidden-xs">删除</span></a> 
				</shiro:hasPermission>
				<input id="btnCancel" class="btn btn-white" type="button" value="返 回" onclick="history.go(-1)"/>
			</div>
		<br>
	</form:form>
	</div>
</div>
</div>
</body>
</html>