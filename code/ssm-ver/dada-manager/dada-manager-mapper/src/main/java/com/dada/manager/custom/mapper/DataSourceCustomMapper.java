package com.dada.manager.custom.mapper;

import java.util.List;

import com.dada.common.utils.Page;
import com.dada.common.utils.PageData;

public interface DataSourceCustomMapper {

    List<PageData> selectDataSourceByPage(Page page);
}
