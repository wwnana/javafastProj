package com.javafast.modules.test.dao.note;

import org.hibernate.validator.constraints.Length;

import java.util.List;
import com.javafast.common.persistence.CrudDao;
import com.javafast.common.persistence.annotation.MyBatisDao;
import com.javafast.modules.test.entity.note.TestNote;

/**
 * 富文本测试DAO接口
 * @author javafast
 * @version 2018-07-18
 */
@MyBatisDao
public interface TestNoteDao extends CrudDao<TestNote> {
	
}