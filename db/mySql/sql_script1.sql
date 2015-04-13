

drop database if exists GoCourse;

create database if not exists GoCourse;

use gocourse;

# 用户表
drop table if exists user;
create table user(
	id int unsigned auto_increment primary key,	-- 主键, 递增
	username char(200) not null,		-- 用户名，非空, 唯一
	unique key(username),	
	real_name tinytext not null,		-- 真实姓名
	password tinytext not null,		-- 密码
	gendar boolean not null default 1,	-- 性别, true(1)男，false(0) 女
	iconPath text,					-- 头像路径
	type tinyint unsigned not null			-- 用户类型，3，管理员，1，学生，2教师
);

insert user values(null, 'admin', '陈俊杰', 'admin', 0, '', 0);
insert user values(null, 'teacher', '陈俊杰', '123', 0, '', 2);
insert user values(null, 'student', '陈俊杰', '123', 0, '', 1);

#学校表
create table if not exists university(
	id int unsigned auto_increment primary key,	-- 主键，递增
	name tinytext not null	-- 学校名称
);

insert university values(null,'长江大学');

# 课时信息
drop table if exists slot;
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

insert slot values(null, 1, 1, 8, 0, 9, 35);
insert slot values(null, 1, 2, 10, 5, 11, 40);
insert slot values(null, 1, 3, 14, 0, 15, 35);
insert slot values(null, 1, 4, 16, 5, 17, 40);
insert slot values(null, 1, 5, 19, 0, 20, 35);

#院系表
drop table if exists department;
create table if not exists department(
	id int unsigned auto_increment primary key,	-- 主键，递增
	name tinytext not null	-- 院系名称
);

insert department values(null,'计算机科学与技术学院');
insert department values(null,'管理学院');

#学校院系表
create table uni_dept(
id int unsigned auto_increment primary key,	-- 主键，递增
uni_id int unsigned,
foreign key(uni_id) references university(id),
dept_id int unsigned,
foreign key(dept_id) references department(id)
);

insert uni_dept values(null, 1, 1);
insert uni_dept values(null, 1, 2);

#学校院系视图
create or replace view vi_uni_dept as 
select
ud.id uni_dept_id,
d.id dept_id,
d.name dept_name,
u.id uni_id,
u.name uni_name
from university u, department d, uni_dept ud
where u.id=ud.uni_id and d.id=ud.dept_id;

# 班级表
create table class(
	id int unsigned auto_increment primary key,	-- 主键, 递增
	uni_dept_id int unsigned,	-- 外键，学院id
	name tinytext not null,	-- 班级名称
	enrolYear smallint unsigned,	-- 班级创建年份
	foreign key(uni_dept_id) references uni_dept(id)
);

insert class values(null, 1, '计科11101', 2011);
insert class values(null, 1, '计科11102', 2011);

#班级视图
create or replace view vi_class_dept_uni as
select 
	c.id class_id,
	c.name class_name,
	v.*
from class c, vi_uni_dept v
where c.uni_dept_id=v.uni_dept_id;

# 学生信息表
create table student(
	id int unsigned primary key,	-- 主键，外键，用户id
	foreign key(id) references user(id),
	stu_No char(50) not null,	-- 学号，非空，唯一
	unique key(stu_No),
	class_id int unsigned,	-- 学生所在班级id
	foreign key(class_id) references class(id)
);

insert student values(3, '201102806', 1);

#学生信息视图
create or replace view vi_student_info as
select 
	s.id stu_id,
	s.stu_No,
	v.*
from student s, user u, vi_class_dept_uni v
where u.type=1 and u.id=s.id and s.class_id=v.class_id;

#教师信息表
create table teacher(
	id int unsigned primary key,	-- 主键，外键，用户id
	foreign key(id) references user(id), 
	uni_dept_id int unsigned,	-- 教师所在院系
	foreign key(uni_dept_id) references uni_dept(id)
);

insert teacher values(2, 1);

#教师信息视图
create or replace view vi_teacher_info as
select 
	t.id tch_id,
	v.*
from teacher t, user u, vi_uni_dept v
where u.type=2 and u.id=t.id and t.uni_dept_id=v.uni_dept_id;

#课程
create table curriculum(
	id int unsigned auto_increment primary key,	-- 主键, 递增
	name tinytext not null
);
insert curriculum values(null, '人工智能');
insert curriculum values(null, '数据结构');
insert curriculum values(null, '模式识别');

#院系课程
create table dept_curi(
	id int unsigned auto_increment primary key,	-- 主键, 递增
	uni_dept_id int unsigned,
	foreign key(uni_dept_id) references uni_dept(id),
	curi_id int unsigned,
	foreign key(curi_id) references curriculum(id)
);

insert dept_curi values(null,1,1);
insert dept_curi values(null,1,2);
insert dept_curi values(null,1,3);

#院系课程视图
create or replace view vi_dept_curi as
select 
	dc.id dept_curi_id,
	c.id curi_id,
	c.name curi_name,
	v.*
from curriculum c, dept_curi dc, vi_uni_dept v
where dc.curi_id=c.id and dc.uni_dept_id=v.uni_dept_id;

#院系每学期开设的课程
create table course_setting(
	id int unsigned auto_increment primary key,	-- 主键, 递增
	dept_curi_id int unsigned,		-- 外键，
	foreign key(dept_curi_id) references dept_curi(id),
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
	crs_set_id int unsigned,					-- 外键，开课信息id
	foreign key(crs_set_id) references course_setting(id),
	weekDay smallint unsigned not null,			-- 开课日，0-6表示周日到周一
	slot_id int unsigned,						-- 课时id
	foreign key(slot_id) references slot(id),
	gapType smallint not null, 					-- 隔周状态，0单双周，1单周，2双周
	location tinytext not null					-- 上课地点
);

# 开课班级对象
create table course_class_registry(
	id int unsigned auto_increment primary key,	-- 主键, 递增
	crs_set_id int unsigned not null,	-- 外键，开课信息id
	class_id int unsigned not null,		-- 外键，班级id
	foreign key(crs_set_id) references course_setting(id),
	foreign key(class_id) references class(id)
);

# 学生选课表
create table course_stu_registry(
	id int unsigned auto_increment primary key,	-- 主键, 递增
	crs_set_id int unsigned,	-- 外键，开课信息id	
	stu_id int unsigned,			-- 外键，学生id
	foreign key(crs_set_id) references course_setting(id),
	foreign key(stu_id) references student(id)
);

# 课次
create table lecture(
	id int unsigned auto_increment primary key,	-- 主键, 递增
	crs_set_id int unsigned,				-- 外键，开课信息id
	foreign key(crs_set_id) references course_setting(id),
	week smallint not null,						-- 周次
	weekday smallint not null,					-- 星期
	crs_loc_id int unsigned,
	foreign key(crs_loc_id) references course_location(id),
	title tinytext,								-- 课次标题
	content text								-- 课次内容
);


# 课次签到信息
create table lec_sign_in(
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
create table lec_feedback(
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






