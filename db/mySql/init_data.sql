USE GOCOURSE;

-- ---------------------------------------------------------------------
#	系统参数
-- ---------------------------------------------------------------------

-- 添加数据字典
INSERT INTO TB_DATA_DICT(ID, TYPE_CODE, TYPE_VALUE, VALUE_NAME, DESCRIPTION)
	VALUES(0, 'ROLE_TYPE', '1', '管理员', '具有管理权限的用户');
INSERT INTO TB_DATA_DICT(ID, TYPE_CODE, TYPE_VALUE, VALUE_NAME, DESCRIPTION)
	VALUES(0, 'ROLE_TYPE', '2', '普通用户', '普通权限的用户');

-- ---------------------------------------------------------------------
#	单位管理
-- ---------------------------------------------------------------------

-- 添加学校
INSERT INTO TB_UNIVERSITY VALUES(NULL, '长江大学', '长大');
INSERT INTO TB_UNIVERSITY VALUES(NULL, '荆州职业技术学院', '荆职');
INSERT INTO TB_UNIVERSITY VALUES(NULL, '武汉大学', '武大');
INSERT INTO TB_UNIVERSITY VALUES(NULL, '湖北工业大学', '湖工大');

-- 添加院系
INSERT INTO TB_DEPARTMENT VALUES(NULL, '计算机科学与技术学院', '计科院', 1);
INSERT INTO TB_DEPARTMENT VALUES(NULL, '管理学院', '管院', 1);
INSERT INTO TB_DEPARTMENT VALUES(NULL, '化学与环境工程学院', '化工院', 1);

-- 班级
INSERT INTO TB_CLASS VALUES(NULL, '计科11101', 1);
INSERT INTO TB_CLASS VALUES(NULL, '计科11102', 1);
INSERT INTO TB_CLASS VALUES(NULL, '计科11103', 1);
INSERT INTO TB_CLASS VALUES(NULL, '计科11104', 1);

-- 课时
INSERT INTO TB_CLASS_HOUR VALUES(NULL, 1, 1, '08:00', '08:45');
INSERT INTO TB_CLASS_HOUR VALUES(NULL, 1, 2, '08:50', '09:35');
INSERT INTO TB_CLASS_HOUR VALUES(NULL, 1, 3, '10:05', '10:50');
INSERT INTO TB_CLASS_HOUR VALUES(NULL, 1, 4, '10:55', '11:40');
INSERT INTO TB_CLASS_HOUR VALUES(NULL, 1, 5, '14:00', '14:45');
INSERT INTO TB_CLASS_HOUR VALUES(NULL, 1, 6, '14:50', '15:35');
INSERT INTO TB_CLASS_HOUR VALUES(NULL, 1, 7, '16:05', '16:50');
INSERT INTO TB_CLASS_HOUR VALUES(NULL, 1, 8, '17:55', '17:40');
INSERT INTO TB_CLASS_HOUR VALUES(NULL, 1, 9, '19:00', '19:45');
INSERT INTO TB_CLASS_HOUR VALUES(NULL, 1, 10, '19:50', '20:35');

-- ---------------------------------------------------------------------
#	权限
-- ---------------------------------------------------------------------

-- 添加角色
INSERT INTO TB_ROLE(ID, ABBREVIATION, ROLE_NAME, ROLE_TYPE, DESCRIPTION) VALUES(NULL, 'SA', '超级管理员', '1', '超级管理员');
INSERT INTO TB_Role(ID, ABBREVIATION, ROLE_NAME, ROLE_TYPE, DESCRIPTION)  VALUES(NULL, 'STU', '学生', '2', '学生');
INSERT INTO TB_ROLE(ID, ABBREVIATION, ROLE_NAME, ROLE_TYPE, DESCRIPTION)  VALUES(NULL, 'TEAC', '教师', '2', '教师');

-- 添加模块
INSERT INTO TB_MODULE(ID, PARENT_MODULE_ID, ABBREVIATION, MODULE_NAME, DESCRIPTION) VALUES(NULL, NULL, 'UNIT', '单位管理', '管理单位信息');
INSERT INTO TB_MODULE(ID, PARENT_MODULE_ID, ABBREVIATION, MODULE_NAME, DESCRIPTION) VALUES(NULL, NULL, 'COURSE', '课程管理', '管理课程信息');
INSERT INTO TB_MODULE(ID, PARENT_MODULE_ID, ABBREVIATION, MODULE_NAME, DESCRIPTION) VALUES(NULL, NULL, 'AUTH', '权限管理', '管理权限信息'); 

-- ---------------------------------------------------------------------
#	用户
-- ---------------------------------------------------------------------

-- 添加用户
INSERT INTO TB_USER(ID, USERNAME, PASSWORD) VALUES(NULL, 'admin', '000000');
INSERT INTO TB_USER(ID, USERNAME, PASSWORD) VALUES(NULL, 'student', '000000');
INSERT INTO TB_USER(ID, USERNAME, PASSWORD) VALUES(NULL, 'teacher', '000000');

-- 绑定角色
INSERT INTO TB_USER_ROLE(USER_ID, ROLE_ID) VALUES(2, 2);
INSERT INTO TB_USER_ROLE(USER_ID, ROLE_ID) VALUES(3, 3);



