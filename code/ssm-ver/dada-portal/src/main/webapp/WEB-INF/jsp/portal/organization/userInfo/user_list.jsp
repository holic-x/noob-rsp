<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!-- <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">-->

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="">
<meta name="author" content="">

<title>哒哒报表服务平台后台管理</title>
<!-- 引入相关的css、js文件 -->
<%@include file="/public/table.jspf"%>

</head>

<body>

	<div id="wrapper">

		<!-- Navigation -->
		<!-- 后台导航模块引入,替换前台框架后不需要引入,只显示局部页面 -->
		<%-- <%@include file="/common/admin_navigation.jsp"%> --%>
		<!-- Navigation end -->

		<!-- 页面显示内容 -->
		<!-- 取消后台导航样式：替换样式 -->
		<!-- <div id="page-wrapper">   -->
		<div class="admin-content">
			<div class="row">
				<div class="col-lg-12">
					<h1 class="page-header">&nbsp;机构用户管理</h1>
				</div>
				<!-- /.col-lg-12 -->
			</div>
			<!-- /.row -->
			<div class="row">
				<div class="col-lg-12">
					<div class="panel panel-default">
						<!-- <div class="panel-heading">机构维护/机构用户管理</div> -->
						<div style="padding: 0px; margin: 0px;">
							<ul class="breadcrumb" style="margin: 0px;">
								<li><a href="#">机构信息维护</a></li>
								<li>机构用户管理</li>
							</ul>
						</div>
						
						<!-- 添加隐藏属性categoryId -->
						<input type="hidden" id= "categoryId" name="categoryId" value="${loginUser.categoryId }" />
 						
						<!-- 操作按钮组合  class="btn-group operation"  -->
						<div class="panel-heading btn-group operation">
							<button id="btn_add" type="button" class="btn bg-primary">
								<span class="glyphicon glyphicon-plus" aria-hidden="true"></span>新增
							</button>
							<button id="btn_edit" type="button" class="btn bg-info">
								<span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>查看
							</button>
						</div>
						<!-- 操作按钮组合 end -->

						<!-- /.panel-heading -->
						<div class="panel-body">
							<table width="100%"
								class="table table-striped table-bordered table-hover"
								id="dataTables-example" data-show-columns="false">
								<!-- 表头 -->
								<thead>
									<tr>
										<th class="text-center">用户编号</th>
										<th class="text-center">用户名称</th>
										<th class="text-center">角色名称</th>
										<th class="text-center">所属机构</th>
										<th class="text-center">出生日期</th>
										<th class="text-center">用户性别</th>
										<th class="text-center">用户地址</th>
										<th class="text-center">联系方式</th>
										<th class="text-center">电子邮箱</th>
										<th class="text-center">用户状态</th>
										<th class="text-center">用户分类</th>
										<th class="text-center">登录账号</th>
										<th class="text-center">操作</th>
									</tr>
								</thead>
								<!-- 表体数据 -->
								<tbody>
									<!-- 
									<tr class="gradeU">
										<td>Other browsers</td>
										<td>All others</td>
										<td>-</td>
									</tr> 
									-->
								</tbody>
							</table>
							<!-- /.table-responsive -->

						</div>
						<!-- /.panel-body -->
					</div>
					<!-- /.panel -->
				</div>
				<!-- /.col-lg-12 -->
			</div>
			<!-- /.row -->
		</div>
		<!-- /#page-wrapper -->
		<!-- 页面显示内容 end -->

	</div>
	<!-- /#wrapper -->

	<!-- Page-Level Demo Scripts - Tables - Use for reference -->
	<script>
		$(document).ready(function() {
			// 生成操作按钮
			var operatorButton = '<button type="button" id="editrow" data-toggle="modal" class="btn btn-outline btn-circle btn-sm purple"><i class="fa fa-edit">编辑</i></button>&nbsp;&nbsp;&nbsp;<button id="delrow" class="btn btn-outline btn-circle dark btn-sm black"><i class="fa fa-trash-o">删除</i></button>';
			var contentPath = "/" + location.pathname.split("/")[1];
			$('#dataTables-example').dataTable().fnDestroy();//作用是在翻页的时候，需要将先前实用datatable生成的table摧毁，以便在翻页或者条件查找的时候，新的表格的搭建。 
			$('#dataTables-example').DataTable(
			{
				// dom : 'Bit',dom : '<"wrapper"flipt>',dom : 'Bit <"top"i>rt<"bottom"flp><"clear">',
				dom : 'Bit <lf<t>ip>',
				paging : true,
				"info" : false,
				"searching" : true,
				"ordering" : true,
				"stateSave" : true,
				buttons : [ 'colvis' ],
				'language' : {
					'emptyTable' : '没有数据',
					'loadingRecords' : '加载中...',
					'processing' : '查询中...',
					'search' : '数据检索:',
					'lengthMenu' : '每页 _MENU_ 条数据',
					'zeroRecords' : '没有数据',
					'paginate' : {
						'first' : '第一页',
						'last' : '最后一页',
						'next' : '下一页',
						'previous' : '上一页'
					},
					'info' : '第 _PAGE_ 页 / 总 _PAGES_ 页',
					'infoEmpty' : '没有数据',
					'infoFiltered' : '(过滤总件数 _MAX_ 条)'
				},
			ajax : function(data, callback,settings) {
				//封装请求参数
				var param = {
					"pageData" : {
						"categoryId" : $("#categoryId").val()
					}
				};
				//ajax请求数据
				$.ajax({
					url : contentPath + '/organization/listUserInfoByPage',
					type : "POST",
					contentType : 'application/json; charset=UTF-8',
					// cache: false, //禁用缓存
					dataType : "json",
					data : JSON.stringify(param),
					success : function(result) {
						//封装返回数据
						var returnData = {};
						returnData.draw = data.draw;//这里直接自行返回了draw计数器,应该由后台返回
						returnData.recordsTotal = result.recordsTotal;//返回数据全部记录
						returnData.recordsFiltered = result.recordsFiltered;//后台不实现过滤功能，每次查询均视作全部结果
						returnData.data = result.data;//返回的数据列表
						//console.log(returnData);
						//调用DataTables提供的callback方法，代表数据已封装完成并传回DataTables进行渲染
						//此时的数据需确保正确无误，异常判断应在执行此回调前自行处理完毕
						callback(returnData);
					}
				});
			},
			// 设置属性，封装数据
			columns : [
				{
					"data" : "userId",
					"name" : "用户id",
					"sDefaultContent" : "", //默认空字符串 
					"sClass" : "text-center",
					"visible" : false // 设置默认隐藏
				},
				{
					"orderable" : true,
					"data" : "userName",
					"sDefaultContent" : "", //默认空字符串 
					'sClass' : "text-center"
				},
				{
					"orderable" : true,
					"data" : "roleName",
					"sDefaultContent" : "", //默认空字符串 
					'sClass' : "text-center"
				},
				{
					"orderable" : true,
					"data" : "categoryName",
					"sDefaultContent" : "", //默认空字符串 
					'sClass' : "text-center"
				},
				{
					"orderable" : true,
					//"data" : "birthday",
					"data" : function(obj) {
						return getDate(obj.birthday)//通过调用函数来格式化所获取的时间戳
					},
					"sDefaultContent" : "", //默认空字符串 
					'sClass' : "text-center",
					"visible" : false // 设置默认隐藏
				},
				{
					"orderable" : false,
					"data" : "genderContext",
					"sDefaultContent" : "", //默认空字符串 
					'sClass' : "text-center",
					"visible" : false // 设置默认隐藏
				},
				{
					"orderable" : false,
					"data" : "address",
					"sDefaultContent" : "", //默认空字符串 
					'sClass' : "text-center",
					"visible" : false // 设置默认隐藏
				},
				{
					"orderable" : false,
					"data" : "phone",
					"sDefaultContent" : "", //默认空字符串 
					'sClass' : "text-center"
				},
				{
					"orderable" : false,
					"data" : "email",
					"sDefaultContent" : "", //默认空字符串 
					'sClass' : "text-center"
				},
				{
					"orderable" : false,
					"data" : "userState",
					"sDefaultContent" : "", //默认空字符串 
					'sClass' : "text-center",
					"visible" : false // 设置默认隐藏
				},
				{
					"orderable" : false,
					"data" : "userCategory",
					"sDefaultContent" : "", //默认空字符串 
					'sClass' : "text-center",
					"visible" : false // 设置默认隐藏
				},
				{
					"orderable" : false,
					"data" : "loginAccount",
					"sDefaultContent" : "", //默认空字符串 
					'sClass' : "text-center",
					"visible" : false // 设置默认隐藏
				},
				{
					"orderable" : false,
					"data" : null,
					"className" : "center",
					// "defaultContent" : '<button type="button" id="editrow" data-toggle="modal" class="btn btn-outline btn-circle btn-sm purple"><i class="fa fa-edit">编辑</i></button>  <button id="delrow" class="btn btn-outline btn-circle dark btn-sm black"><i class="fa fa-trash-o">删除</i></button>'
					"defaultContent" : operatorButton
				} 
			]
		});
	});

		// 添加信息
		$("#btn_add").click(function() {
			// 跳转到用户添加页面
			var url = "${pageContext.request.contextPath }/portal/page/other?url=portal/organization/userInfo/user_add";
				window.location.href = url;
		});

		//表数据删除
		$('#dataTables-example').on('click','button#delrow',
			function(even) {
				even.preventDefault;//方法阻止元素发生默认的行为（例如，当点击提交按钮时阻止对表单的提交）。
				if (confirm("确定删除该用户信息?") == false) {
					return;
				} else {
					/* 得到当前对象的值 */
					var data = $("#dataTables-example").DataTable().row($(this).parents('tr')).data();
					// 封装选择的数据行
					/* {
						"id" : data.userId
					} */
					var selrow = {
						userIds : [ data.userId ]
					};
					$.ajax({
						url : '${pageContext.request.contextPath }/portal/organization/deleteUserInfos',
						type : 'POST',
						contentType : 'application/json; charset=UTF-8',
						dataType : 'json',
						data : JSON.stringify(selrow),
						/* success是指后台数据库的表么？如果是，先将success表中相关的数据封装在list里面，然后将list转为json数据格式的字符串返回到前台。如果你用的是jQuery的ajax方法，那么记得在前台接受的时候一定要指定数据接受格式为json,否则你得到是一个json的字符串，不是一个json的对象 */
						success : function(data) {
							// alert(data.result_code);
							if (data.result_code == "1") {
								alert('用户信息删除成功!');
								start = $("#dataTables-example").dataTable().fnSettings()._iDisplayStart;//从第几行开始显示数据
								total = $("#dataTables-example").dataTable().fnSettings().fnRecordsDisplay();
								// alert(start);
								// alert(total);
								window.location.reload();
								if ((total - start) == 1) {
									if (start > 0) {
										$("#dataTables-example").dataTable().fnPageChange('previous',true);//已回到上一页中 
										/* 注意$("#sorting-advanced").dataTable().fnPageChange( ‘previous‘); 是不行的，必需进行刷新，否则页面中显示的iDisplayStart会从cookie中取得，还是删除前的iDisplayStart */
									}
								}
							}
						},
						error : function(data) {
							// alert(data.result_code);
							console.log(data);
							alert('服务器无响应，请联系管理员!');
						}
					})
				}
			});

		//表数据编辑(跳转页面)
		$('#dataTables-example').on('click','button#editrow',
			function(even) {
				even.preventDefault;//方法阻止元素发生默认的行为（例如，当点击提交按钮时阻止对表单的提交）。
				/* 得到当前对象的值 */
				var data = $("#dataTables-example").DataTable().row($(this).parents('tr')).data();
				// 封装选择的数据行
				// var url = "${pageContext.request.contextPath }/portal/page/other?url=portal/organization/userInfo/user_edit";
				var url = "${pageContext.request.contextPath }/portal/organization/updateUserInfoUI/"+data.userId;
				window.location.href = url;
			});
		// 时间转化
		function getDate(time) {
			if (typeof (time) == "undefined") {
				return "";
			}
			var oDate = new Date(time), oYear = oDate.getFullYear(), oMonth = oDate
					.getMonth() + 1, oDay = oDate.getDate(), oHour = oDate
					.getHours(), oMin = oDate.getMinutes(), oSen = oDate
					.getSeconds(),
			// oTime = oYear +'-'+ getzf(oMonth) +'-'+ getzf(oDay) +' '+ getzf(oHour) +':'+ getzf(oMin) +':'+getzf(oSen);//最后拼接时间  
			oTime = oYear + '-' + getzf(oMonth) + '-' + getzf(oDay);//最后拼接时间  yy-mm-dd
			return oTime;
		};

		//补0操作,当时间数据小于10的时候，给该数据前面加一个0  
		function getzf(num) {
			if (parseInt(num) < 10) {
				num = '0' + num;
			}
			return num;
		}
	</script>
</body>

</html>
