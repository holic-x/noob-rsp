package com.dada.report.controller;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**       
 * <p>项目名称:dada-manager-web</p>
 * <p>包名称:com.dada.manager.controller.PageController</p>
 * <p>文件名称:PageController.java</p>
 * <p>功能描述:页面控制器</p>
 * <p>其他说明:设置页面跳转    </p>
 * <p>@author:thanos<p>   
 * <p> date:2019年2月6日下午3:30:28 </p>
 * <p>@version  jdk1.8</p>
 * <p>Copyright (c) 2019, 892944741@qq.com All Rights Reserved. </p>    
 */
// 实际访问路径:localhost:8084/custom/report/...(在web.xml中配置拦截路径/custom/*)
@Controller
@RequestMapping("/report")
public class PageController {

	/**
	 * 打开首页
	 */
	@RequestMapping("/page/index")
	public String showIndex() {
		return "index";
	}
	/**
	 * 展示其他页面
	 * <p>Title: showpage</p>
	 * <p>Description: </p>
	 * @param page
	 * @return
	 */
	@RequestMapping("/page/other")
    public String showpage(@Param(value="url") String url) {
        return url;
    }
}