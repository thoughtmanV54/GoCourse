drop database if exists GoCourse;

create database if not exists GoCourse;

use gocourse;

create table if not exists RequestAddress(
	id int unsigned auto_increment primary key,
	rdName varchar(200) not null,
	description varchar(200) not null 
);

create table if not exists requestParameter(
	id int unsigned auto_increment primary key,
	raid int references RequestAddress(id),
	parameter varchar(50) not null,
	description varchar(100) not null
);

create table if not exists Administrator(
	id int unsigned auto_increment primary key,
	username char(200) not null,
	password tinytext not null
);


insert Administrator values(null, 'chenjunjie', '12345678');

# 学校表
create table if not exists University(
	id int unsigned auto_increment primary key,	-- 主键，递增
	name tinytext not null	-- 学校名称
);

insert university values(null,'长江大学');

# 课时信息
create table slot(
	id int unsigned auto_increment primary key,	-- 主键，递增
	uni_id int unsigned,				-- 外键，学校id
	foreign key(uni_id) references university(id),
	sequenceNo smallint not null,		-- 课时序号
	startHour smallint not null,		-- 起始小时
	startMinute smallint not null,		-- 起始分钟
	endHour smallint not null,			-- 结束小时
	endMinute smallint not null 		-- 结束分钟
);	

ALTER TABLE slot DROP column startHour, 
drop startMinute, 
drop endHour, 
drop endMinute;

#院系表
drop table if exists department;
create table if not exists department(
	id int unsigned auto_increment primary key,	-- 主键，递增
	uni_id int unsigned,			-- 外键，学校id
	name tinytext not null,	-- 院系名称
	foreign key(uni_id) references university(id)
);

insert department values(null, 1, '计算机科学与技术学院');

# 班级表
create table class(
	id int unsigned auto_increment primary key,	-- 主键, 递增
	dept_id int unsigned,	-- 外键，学院id
	name tinytext not null,	-- 班级名称
	enrolYear smallint unsigned,	-- 班级创建年份
	foreign key(dept_id) references department(id)
);

insert class values(null, 1, '计科11101', 2011);
insert class values(null, 1, '计科11102', 2011);

# 用户表
drop table if exists user;

create table user(
	id int unsigned auto_increment primary key,	-- 主键, 递增
	username char(200) not null,		-- 用户名，非空, 唯一
	unique key(username),	
	realName tinytext not null,		-- 真实姓名
	password tinytext not null,		-- 密码
	gendar boolean not null default 1,	-- 性别, false(0)男，true(1) 女
	iconPath text,					-- 头像路径
	type tinyint unsigned not null			-- 用户类型，3，管理员，1，学生，2教师
);

insert user values(null, 'admin', '陈俊杰', 'admin', 0, '', 3);
insert user values(null, 't', 'teacher', 't', 0, '', 2);
insert user values(null, 's', 'student', 's', 0, '', 1);

# 学生信息表
create table student(
	id int unsigned primary key,	-- 主键，外键，用户id
	foreign key(id) references user(id),
	stuNo char(50) not null,	-- 学号，非空，唯一
	unique key(stuNo),
	class_id int unsigned,	-- 学生所在班级id
	foreign key(class_id) references class(id)
);

insert student values(3, '201102806', 1);

# 教师信息表
create table teacher(
	id int unsigned primary key,	-- 主键，外键，用户id
	foreign key(id) references user(id), 
	dept_id int unsigned,	-- 教师所在院系
	foreign key(dept_id) references department(id)
);

insert teacher values(2, 1);

#院系课程表
create table course(
	id int unsigned auto_increment primary key,	-- 主键, 递增
	dept_id int unsigned,	-- 课程所在院系
	foreign key(dept_id) references department(id),
	name tinytext not null
);

insert course values(null, 1, '人工智能');
insert course values(null, 1, '模式识别');
insert course values(null, 1, '数据结构'); 

#课程设置
create table course_setting(
	id int unsigned auto_increment primary key,	-- 主键, 递增
	course_id int unsigned,		-- 外键，
	foreign key(course_id) references course(id),
	openYear smallint not null,		-- 开课年份
	semester boolean not null ,			-- 开课学期，0春季，1秋季
	fromWeek smallint not null,		-- 开始周次
	endWeek smallint not null,		-- 结束周次
	tch_id int unsigned not null,				-- 外键，课程授课教师id	
	foreign key(tch_id) references teacher(id),
	type tinyint not null	-- 课程类别，1（必修课），2（专业选修），3（公共选修）
);

#上课信息
create table course_location(
	id int unsigned auto_increment primary key,	-- 主键, 递增
	course_setting_id int unsigned,					-- 外键，开课信息id
	foreign key(course_setting_id) references course_setting(id),
	weekDay smallint unsigned not null,			-- 开课日，1-7表示周日到周六
	slot_id int unsigned,						-- 课时id
	foreign key(slot_id) references slot(id),
	gapType smallint not null, 					-- 隔周状态，0单双周，1单周，2双周
	location tinytext not null					-- 上课地点
);

# 开课班级对象
create table course_class_registry(
	id int unsigned auto_increment primary key,	-- 主键, 递增
	course_setting_id int unsigned not null,	-- 外键，开课信息id
	class_id int unsigned not null,		-- 外键，班级id
	foreign key(course_setting_id) references course_setting(id),
	foreign key(class_id) references class(id)
);


# 学生选课表
create table course_student_registry(
	id int unsigned auto_increment primary key,	-- 主键, 递增
	course_setting_id int unsigned,	-- 外键，开课信息id	
	stu_id int unsigned,			-- 外键，学生id
	foreign key(course_setting_id) references course_setting(id),
	foreign key(stu_id) references student(id)
);


# 课次
create table lecture(
	id int unsigned auto_increment primary key,	-- 主键, 递增
	course_location_id int unsigned,
	foreign key(course_location_id) references course_location(id),
	week smallint not null,						-- 周次
	title tinytext,								-- 课次标题
	content text								-- 课次内容
);

# 课次签到信息
create table lecture_sign_in(
	id int unsigned auto_increment primary key,	-- 主键, 递增 
	lec_id int unsigned,
	foreign key(lec_id) references lecture(id),
	stu_id int unsigned,
	foreign key(stu_id) references student(id),
	submission_time datetime not null,
	longitude decimal(18,8),
	latitude decimal(18,8)
);

#课次评价信息
create table lecure_feedback(
	id int unsigned auto_increment primary key,	-- 主键, 递增
	lec_id int unsigned,
	foreign key(lec_id) references lecture(id),
	stu_id int unsigned,
	foreign key(stu_id) references student(id),
	rating decimal(2,1),
	comment text,
	state boolean,	-- 是否公开，1公开，0不公开
	submission_time datetime
);

#选择题题库
create table choice_question(
	id int unsigned auto_increment primary key,	-- 主键, 递增
	topic text not null		-- 题干
);

#选择题选项
create table choice_question_option(
	id int unsigned auto_increment primary key,	-- 主键, 递增
	choice_question_id int unsigned,
	foreign key(choice_question_id) references choice_question(id),		
	content tinytext not null,
	correctness boolean
);


# 随堂测验
create table quiz(
	id int unsigned auto_increment primary key,	-- 主键, 递增
	lec_id int unsigned,
	foreign key(lec_id) references lecture(id),
	choice_question_id int unsigned,
	foreign key(choice_question_id) references choice_question(id),
	state boolean								-- 测验状态，1已发布，0未发布
);

# 测验结果
create table quiz_result(
	id int unsigned auto_increment primary key,	-- 主键, 递增
	quiz_id int unsigned,
	foreign key(quiz_id) references quiz(id),
	choice_question_option_id int unsigned,
	foreign key(choice_question_option_id) references choice_question_option(id),
	stu_id int unsigned,
	foreign key(stu_id) references student(id),
	submission_time datetime
);	