package com.javafast.common.persistence.proxy;

import org.apache.ibatis.binding.BindingException;
import org.apache.ibatis.binding.MapperRegistry;
import org.apache.ibatis.session.Configuration;
import org.apache.ibatis.session.SqlSession;

/**
 * 分页映射注册
 * @author JavaFast
 */
public class PaginationMapperRegistry extends MapperRegistry {
    public PaginationMapperRegistry(Configuration config) {
        super(config);
    }

    @Override
    public <T> T getMapper(Class<T> type, SqlSession sqlSession) {
        if (!hasMapper(type)) {
            throw new BindingException("Type " + type + " is not known to the MapperRegistry.");
        }
        try {
            return PaginationMapperProxy.newMapperProxy(type, sqlSession);
        } catch (Exception e) {
            throw new BindingException("Error getting mapper instance. Cause: " + e, e);
        }
    }
}
