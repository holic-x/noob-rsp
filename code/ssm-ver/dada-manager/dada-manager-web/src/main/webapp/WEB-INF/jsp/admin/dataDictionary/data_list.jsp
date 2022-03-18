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
<%@include file="/public/common.jspf"%>

</head>

<!-- 引入ztree相关的css(针对不同风格的CSS样式)、js -->
<%-- <link href="${pageContext.request.contextPath }/resource/ztree/css/zTreeStyle/zTreeStyle.css" rel="stylesheet" type="text/css">  --%>
<link href="${pageContext.request.contextPath }/resource/ztree/css/metroStyle/metroStyle.css" rel="stylesheet" type="text/css">
<%--  <link href="${pageContext.request.contextPath }/resource/ztree/css/awesomeStyle/awesome.css" rel="stylesheet" type="text/css">  --%>
<!-- 避免重复引入jquery引起js冲突 -->
<%-- <script src="${pageContext.request.contextPath }/resource/ztree/js/jquery-1.4.4.min.js"></script> --%>
<script src="${pageContext.request.contextPath }/resource/ztree/js/jquery.ztree.core.js"></script>
<script src="${pageContext.request.contextPath }/resource/ztree/js/jquery.ztree.exhide.js"></script>


<body>

<SCRIPT type="text/javascript">
		var setting = {
			view: {
				selectedMulti: false,
				showTitle : true , // 是否显示title属性
			},
			edit: {
				// 编辑节点开关
				enable: true,
				removeTitle: "删除节点信息", // 设置删除按钮提示信息
				renameTitle: "重命名节点名称",// 设置重命名按钮信息
				showRemoveBtn: false, // 显示true/隐藏false 删除按钮
				showRenameBtn: false // 显示true/隐藏false 编辑名称按钮
			},
			check: {
				enable:false // 是否在节点上显示单选/复选框
			},
			data: {
				keep: {
					parent:true,// 锁定true(针对 isParent=true的节点,即使该节点的子节点被全部删除或移走，依旧保持父节点状态)/不锁定false叶子节点属性(反之)
					leaf:true // 锁定true(针对 isParent=false的节点，都无法添加子节点)/不锁定false叶子节点属性(反之)
				},
				/*
				key: {
					
				},
				*/
				simpleData: {
					// 此处需要参考API,注意属性的设置(尤其是大小写问题),如果属性设置不正确,则树状图展示可能存在问题(例如全为显示子节点效果)
					// zTree分为简单数据格式、标准数据格式
					// zTree的默认配置是不启用简单数据格式，使用简单数据格式一定要在setting中进行简单数据格式的相关配置
					enable:true,//表示使用简单数据模式
		            // idKey:"id",//设置之后id为在简单数据模式中的父子节点关联的桥梁
		            // pIdKey:"pId",//设置之后pid为在简单数据模式中的父子节点关联的桥梁和id互相对应
		            // rootId:"null"//pid为null的表示根节点
		           	idKey:"nodeId",
		           	pIdKey:"nodePid",
		            rootPId:"-1"//pid为null的表示根节点
				}
			},
			callback: {
				beforeDrag: beforeDrag,
				beforeRemove: beforeRemove,
			 	beforeRename: beforeRename,
				onRemove: onRemove,
				onClick: showInfo // 捕获节点被点击时触发的事件回调函数
			}
		};
		
		// 异步获取节点数据
		$.ajax({
	        url : '${pageContext.request.contextPath}/manager/dataDictionary/listDataByTree',
	        async : false,
	        dataType : 'json',
	        success : function(response) {
	        	// 从后台获取的节点信息
	        	zNodes = response.data.data;
	        	// console.log('back:'+zNodes);
	        },
	        error : function() {
	            alert("服务器反馈^_^:从后台获取数据失败,请联系管理员.");
	        }
	    });
		
		var log, className = "dark";
		function beforeDrag(treeId, treeNodes) {
			return false;
		}
		function beforeRemove(treeId, treeNode) {
			className = (className === "dark" ? "":"dark");
			showLog("[ "+getTime()+" beforeRemove ]&nbsp;&nbsp;&nbsp;&nbsp; " + treeNode.name);
			return confirm("确认删除 节点 -- " + treeNode.name + " 吗？");
		}
		function onRemove(e, treeId, treeNode) {
			showLog("[ "+getTime()+" onRemove ]&nbsp;&nbsp;&nbsp;&nbsp; " + treeNode.name);
		}
		function beforeRename(treeId, treeNode, newName) {
			if (newName.length == 0) {
				alert("友情提示^_^:节点名称不能为空.");
				var zTree = $.fn.zTree.getZTreeObj("treeDemo");
				setTimeout(function(){zTree.editName(treeNode)}, 10);
				return false;
			}
			return true;
		}
		function showLog(str) {
			if (!log) log = $("#log");
			log.append("<li class='"+className+"'>"+str+"</li>");
			if(log.children("li").length > 8) {
				log.get(0).removeChild(log.children("li")[0]);
			}
		}
		function getTime() {
			var now= new Date(),
			h=now.getHours(),
			m=now.getMinutes(),
			s=now.getSeconds(),
			ms=now.getMilliseconds();
			return (h+":"+m+":"+s+ " " +ms);
		}

		var newCount = 1;
		function add(e) {
			var zTree = $.fn.zTree.getZTreeObj("treeDemo"),
			isParent = e.data.isParent,
			nodes = zTree.getSelectedNodes(),
			treeNode = nodes[0];
			if (treeNode) {
				treeNode = zTree.addNodes(treeNode, {id:(100 + newCount), pId:treeNode.id, isParent:isParent, name:"new node" + (newCount++)});
			} else {
				treeNode = zTree.addNodes(null, {id:(100 + newCount), pId:0, isParent:isParent, name:"new node" + (newCount++)});
			}
			if (treeNode) {
				zTree.editName(treeNode[0]);
			} else {
				alert("友情提示^_^:叶子节点被锁定，无法增加子节点.");
			}
		};
		function edit() {
			var zTree = $.fn.zTree.getZTreeObj("treeDemo"),
			nodes = zTree.getSelectedNodes(),
			treeNode = nodes[0];
			if (nodes.length == 0) {
				alert("友情提示^_^:请先选择一个节点.");
				return;
			}
			zTree.editName(treeNode);
		};
		function remove(e) {
			var zTree = $.fn.zTree.getZTreeObj("treeDemo"),
			nodes = zTree.getSelectedNodes(),
			treeNode = nodes[0];
			if (nodes.length == 0) {
				alert("友情提示^_^:请先选择一个节点.");
				return;
			}
			var callbackFlag = $("#callbackTrigger").attr("checked");
			zTree.removeNode(treeNode, callbackFlag);
		};
		function clearChildren(e) {
			var zTree = $.fn.zTree.getZTreeObj("treeDemo"),
			nodes = zTree.getSelectedNodes(),
			treeNode = nodes[0];
			if (nodes.length == 0 || !nodes[0].isParent) {
				alert("友情提示^_^:请先选择一个父节点.");
				return;
			}
			zTree.removeChildNodes(treeNode);
		};
		
		// 定义鼠标点击事件回调方法showInfo
		function showInfo(e) {
			var zTree = $.fn.zTree.getZTreeObj("treeDemo");
			var nodes = zTree.getSelectedNodes();
			if (nodes.length == 0) {
				alert("友情提示^_^:请先选择一个节点.");
				return;
			}
			var treeNode = nodes[0];
			var height = jQuery(window).height()-50;
			var url = "/manager/dataDictionary/showDataUI?dataId="+treeNode.nodeId;
			$("#mainframe").attr("height",height+"px");
			$("#mainframe").attr("src",url);
		};
		
		$(document).ready(function(){
			$.fn.zTree.init($("#treeDemo"), setting, zNodes);
			$("#addParent").bind("click", {isParent:true}, add);
			$("#addLeaf").bind("click", {isParent:false}, add);
			$("#edit").bind("click", edit);
			$("#remove").bind("click", remove);
			$("#clearChildren").bind("click", clearChildren);
		});
	</SCRIPT>


	<div id="wrapper">

		<!-- Navigation -->
		<%@include file="/common/navigation.jsp"%>
		<!-- Navigation end -->

		<!-- 页面显示内容 -->
		<div id="page-wrapper">
			<div class="row">
				<div class="col-lg-12">
					<h1 class="page-header">数据字典管理</h1>
				</div>
				<!-- /.col-lg-12 -->
			</div>
			<!-- /.row -->
			<div class="row">
				<!-- 导航栏 -->
				<div class="col-lg-12">
					<div class="panel panel-default">
						<!-- <div class="panel-heading">机构维护/机构用户管理</div> -->
						<div style="padding: 0px; margin: 0px;">
							<ul class="breadcrumb" style="margin: 0px;">
								<li><a href="#">平台维护</a></li>
								<li>数据字典管理</li>
							</ul>
						</div>
					</div>
				</div>
				
				<div class="col-lg-12">
					<!-- 存放ztree数据 -->
					<div class="col-sm-2"  style=" padding-left:30px;">
						<ul id="treeDemo" class="ztree"></ul>
				    </div>
				    
				    <!-- 存放对应数据的详细信息 -->
					 <div class="col-sm-10">
					 	<div class="row">
					 		<!-- 添加操作按钮组合 -->
					 		<!--  
						 	[ <a id="addParent" href="#" title="增加父节点" onclick="return false;">增加父节点</a> ]
							[ <a id="addLeaf" href="#" title="增加叶子节点" onclick="return false;">增加叶子节点</a> ]
							[ <a id="edit" href="#" title="编辑名称" onclick="return false;">编辑名称</a> ]
							[ <a id="remove" href="#" title="删除节点" onclick="return false;">删除节点</a> ]
							[ <a id="clearChildren" href="#" title="清空子节点" onclick="return false;">清空子节点</a> ]
					 	 	-->
					 		<!-- 考虑到实际操作限制,禁用直接对树节点操作的按钮,通过页面实现节点的添加 -->
					 		<button id="btn_add" type="button" class="btn bg-primary">
								<span class="glyphicon glyphicon-plus" aria-hidden="true"></span>&nbsp;新增数据
							</button>
							<button id="btn_edit" type="button" class="btn bg-info">
								<span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>&nbsp;编辑数据
							</button>
							<button id="btn_delete" type="button" class="btn bg-danger">
								<span class="glyphicon glyphicon-remove" aria-hidden="true"></span>&nbsp;移除数据
							</button>
					 	</div>
					 	&nbsp;
					 	
					 	<div class="row">
					    	<%-- 
					    	// 方式1:
					    	<iframe id="mainframe" name="mainiframe"  style="width:100%; border:0px; " ></iframe>
							<script type="text/javascript">
					        	// var height = jQuery(window).height()-50;
								// jQuery("#mainframe").attr("height",height+"px");
					        	// jQuery("#mainframe").attr("src","#");
					        </script>
					        --%>
					      	<!--  方式2:通过后台Controller实现跳转（借助ZTree中的回调方法进行页面路径赋值） -->
					       <!-- <iframe id="mainframe" name="mainframe" FRAMEBORDER=0 SCROLLING=AUTO width=100%  height=600px src=""></iframe> -->
				    		<iframe id="mainframe" name="mainiframe"  style="width:100%; border:0px; " ></iframe>
				    	</div>
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

	<script type="text/javascript">
	// 点击选中某个节点,查看对应的数据信息(由ztree的回调函数触发)
	
	// 对按钮进行操作处理
	// 添加数据
	$("#btn_add").click(function() {
		// console.log('add');// 控制台打印信息
		// 判断当前所选节点是否为父节点（考虑基础应用,此处只设置两级数据联动）
		// 跳转到数据添加页面(此处跳转是通过Controller实现页面跳转)
		var height = jQuery(window).height()-50;
		$("#mainframe").attr("height",height+"px");
		$("#mainframe").attr("src","/manager/page/other?url=dataDictionary/data_add");
		// var url = "${pageContext.request.contextPath }/manager/page/other?url=menu/menu_add";
		// window.location.href = url;
	});
	
	// 编辑数据
	$("#btn_edit").click(function() {
		console.log('edit');// 控制台打印信息
		// 获取选中的节点信息,跳转到编辑页面
		var zTree = $.fn.zTree.getZTreeObj("treeDemo");
		var nodes = zTree.getSelectedNodes();
		if (nodes.length == 0) {
			alert("友情提示^_^:请先选择一个节点.");
			return;
		}
		var treeNode = nodes[0];
		console.log(treeNode);
		// 跳转到数据编辑跳转页面(此处跳转是通过Controller实现页面跳转)
		var height = jQuery(window).height()-50;
		var url = "/manager/dataDictionary/updateDataUI?dataId="+treeNode.nodeId;
		$("#mainframe").attr("height",height+"px");
		$("#mainframe").attr("src",url);
	});
	
	// 删除数据
	$("#btn_delete").click(function() {
		// 只允许删除单条数据(子节点直接删除,父节点提示删除将会导致其下子节点信息一并删除)
		console.log('delete');// 控制台打印信息
		// 获取选中的节点信息,跳转到编辑页面
		var zTree = $.fn.zTree.getZTreeObj("treeDemo");
		var nodes = zTree.getSelectedNodes();
		if (nodes.length == 0) {
			alert("友情提示^_^:请先选择一个节点.");
			return;
		}
		var treeNode = nodes[0];
		console.log(treeNode);
		// 判断当前选择的节点是否为父节点,如果为父节点,提示用户谨慎操作
		if(treeNode.isParent){
			var oper = confirm("友情提示^_^:您当前要进行删除的数据是一个父节点,继续执行操作会导致其下对应子数据信息也一并删除,请确认后执行.")
			if(!oper){
				alert("操作反馈^_^:用户取消了操作.");
				return;
			}
		}
		
		// 封装操作数据
		var selrow = {
			"dataIds":[
				treeNode.nodeId
			]
		};
		
		// 请求服务器执行删除操作
		$.ajax({
			url : '${pageContext.request.contextPath }/manager/dataDictionary/deleteDatas',
			type : 'POST',
			contentType : 'application/json; charset=UTF-8',
			dataType : 'json',
			data : JSON.stringify(selrow),
			success : function(data) {
				// alert(data.result_code);
				if (data.result_code == "1") {
					alert('操作反馈^_^:数据删除成功.');
					// 删除完成后重新跳转到数据管理页面(刷新页面信息)
					var url = "${pageContext.request.contextPath }/manager/page/other?url=dataDictionary/data_list";
					window.location.href = url;
				}
			},
			error : function(data) {
				// alert(data.result_code);
				console.log(data);
				alert('服务器反馈^_^:服务器无响应，请联系管理员.');
			}
		});
	});
	
	</script>

</body>

</html>
