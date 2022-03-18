package com.dada.manager.interceptor;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.util.StringUtils;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.dada.common.utils.CookieUtils;
import com.dada.common.utils.HttpClientUtil;
import com.dada.manager.web.utils.ResultManage;
import com.dada.pojo.UserInfo;

/**
 * <p>项目名称:dada-manager-web</p>
 * <p>包名称:com.dada.manager.interceptor.LoginInterceptor</p>
 * <p>文件名称:LoginInterceptor.java</p>
 * <p>功能描述:dada-manager后台管理-登录拦截器配置</p>
 * <p>其他说明:    </p>
 * <p>@author:thanos<p>   
 * <p> date:2019年4月8日下午11:34:04 </p>
 * <p>@version  jdk1.8</p>
 * <p>Copyright (c) 2019, 892944741@qq.com All Rights Reserved. </p>
 */
public class LoginInterceptor implements HandlerInterceptor {

    @Value("${COOKIE_NAME}")
    private String COOKIE_NAME;

    @Value("${SSO_BASE_URL}")
    private String SSO_BASE_URL;

    @Value("${SSO_USER_TOKEN_SERVICE}")
    private String SSO_USER_TOKEN_SERVICE;

    @Value("${SSO_LOGIN_URL}")
    private String SSO_LOGIN_URL;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {
        // 1、拦截请求的url(在springmvc.xml中配置登录拦截器)
        // 2、从cookie中取token(可以调用自定义的service方法,此处直接获取)
        String token = CookieUtils.getCookieValue(request, COOKIE_NAME);
        // 3、如果没有相应的token则强制跳转到登录页面
        if (StringUtils.isEmpty(token)) {
            // 跳转到登录页面(当前服务器跳转、重定向)
            // request.getRequestDispatcher("URL").forward(request,response);
            response.sendRedirect(SSO_LOGIN_URL);
            return false;
        }
        // 4、获取token,调用dada-sso系统的服务查询用户信息
        String json = HttpClientUtil.doGet(SSO_BASE_URL + SSO_USER_TOKEN_SERVICE + token);
        // 5、把json数据转换成java对象,并将相应的数据转化为相应的实体类
        ResultManage result = JSON.parseObject(json, ResultManage.class);
        Map<String, Object> resultMap = result.getData();
        if (result.getResult_code() != 1) {
            // 判断访问是否成功(返回结果为1:访问成功、返回结果为0:访问失败,访问失败回转到登录页面)
            // request.getRequestDispatcher("URL").forward(request,response);
            response.sendRedirect(SSO_LOGIN_URL);
            return false;
        }
        // 获取对应的用户对象(loginUser)
        UserInfo userInfo = JSON.toJavaObject((JSONObject)resultMap.get("loginUser"),UserInfo.class);
        // 6、如果用户session已经过期,跳转到登录页面(针对redis缓存而言,亦避免数据更新带来的隐患)
        if (userInfo == null) {
            response.sendRedirect(SSO_LOGIN_URL);
            return false;
        }
        // 7、如果数据没有过期，放行。
        return true;
    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex)
            throws Exception {

    }

    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
            ModelAndView modelAndView) throws Exception {

    }

}
