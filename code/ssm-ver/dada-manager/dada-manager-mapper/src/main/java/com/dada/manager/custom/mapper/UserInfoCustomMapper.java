package com.dada.manager.custom.mapper;

import java.util.List;

import com.dada.common.utils.Page;
import com.dada.common.utils.PageData;

public interface UserInfoCustomMapper {

    List<PageData> selectUserInfoByPage(Page page);
    
}