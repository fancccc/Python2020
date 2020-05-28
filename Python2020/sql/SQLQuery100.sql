--实验1
--1.创建创建三个数据表：
create table student
( sno char(8) primary key,
  sname char(10) Unique,
  ssex char(2),
  sage char(2),
  sdept char(10),
)

create table course
( cno char(3) primary key,
  cname char(20),
  cpno char(3),
  Ccredit int,
  FOREIGN KEY ( Cpno ) REFERENCES Course ( Cno )
)

create table SC
(Sno char(8),
 Cno char(3),
 grade int check(grade>=0 and grade<=100),
 FOREIGN KEY ( Sno ) REFERENCES Student ( Sno ),
FOREIGN KEY ( Cno ) REFERENCES Course ( Cno )
);

--2.向Student表增加“入学时间”列，其数据类型为日期型（DATE）。
--将年龄的数据类型由字符型（假设原来的数据类型是字符型）改为整数。
--增加课程名称必须取唯一值的约束条件。

alter table student
add 入学时间 date

alter table student
alter column sage int

alter table course 
add constraint cname unique(cname)

--3.插入数据
insert into student values('0601001','李玉','女',19, '数学院','2020-05-06')
insert into student values('0601002','鲁敏','女',20, '文学院','2020-05-06')
insert into student values('0601003','李小路','女',20, '商学院','2020-05-06')
insert into student values('0601004','鲁斌','男',18, '统计学院','2020-05-06')
insert into student values('0601005','王宁静','女',19, '数学院','2020-05-06')
insert into student values('0601006','张明明','男',20, '文学院','2020-05-06')
insert into student values('0601007','刘晓玲','女',20, '商学院','2020-05-06')
insert into student values('0601008','周晓','男',20, '统计学院','2020-05-06')
insert into student values('0601009','易国梁','男',20, '数学院','2020-05-06')
insert into student values('0601010','季风','男',21, '文学院','2020-05-06')


insert into course values('001','计算机应用基础','001',1)
insert into course values('002','关系数据基础','001',1)
insert into course values('003','程序设计基础','001',2)
insert into course values('004','数据结构','001',2)
insert into course values('005','网页设计','001',2)
insert into course values('006','网站设计','001',2)
insert into course values('007','关系数据库','001',3)
insert into course values('008','程序设计','001',3)
insert into course values('009','计算机网络','002',3)
insert into course values('010','Windows Server 配置','001',1)

insert into sc values('0601001','001',78)
insert into sc values('0601002','001',88)
insert into sc values('0601003','001',65)
insert into sc values('0601004','001',76)
insert into sc values('0601005','001',56)
insert into sc values('0601006','001',87)
insert into sc values('0601007','001',67)
insert into sc values('0601008','001',95)
insert into sc values('0601009','001',98)
insert into sc values('0601010','001',45)

insert into sc values('0601001','002',48)
insert into sc values('0601002','002',68)
insert into sc values('0601003','002',95)
insert into sc values('0601004','002',86)
insert into sc values('0601005','002',76)
insert into sc values('0601006','002',57)
insert into sc values('0601007','002',77)
insert into sc values('0601008','002',85)
insert into sc values('0601009','002',98)
insert into sc values('0601010','002',75)
 
insert into sc values('0601001','003',88)
insert into sc values('0601002','003',78)
insert into sc values('0601003','003',65)
insert into sc values('0601004','003',56)
insert into sc values('0601005','003',96)
insert into sc values('0601006','003',87)
insert into sc values('0601007','003',77)
insert into sc values('0601008','003',65)
insert into sc values('0601009','003',98)
insert into sc values('0601010','003',75)
 
insert into sc values('0601001','004',74)
insert into sc values('0601002','004',68)
insert into sc values('0601003','004',95)
insert into sc values('0601004','004',86)
insert into sc values('0601005','004',76)
insert into sc values('0601006','004',67)
insert into sc values('0601007','004',77)
insert into sc values('0601008','004',85)
insert into sc values('0601009','004',98)
insert into sc values('0601010','004',75)
 
insert into sc values('0601001','005',74)
insert into sc values('0601002','005',68)
insert into sc values('0601005','005',76)
insert into sc values('0601008','005',85)
insert into sc values('0601009','005',98)
insert into sc values('0601010','005',75)
 
insert into sc values('0601002','006',88)
insert into sc values('0601003','006',95)
insert into sc values('0601006','006',77)
insert into sc values('0601008','006',85)
insert into sc values('0601010','006',55)
 
insert into sc values('0601001','007',84)
insert into sc values('0601002','007',68)
insert into sc values('0601003','007',95)
 
insert into sc values('0601004','008',86)
insert into sc values('0601005','008',76)
insert into sc values('0601006','008',67)
 
insert into sc values('0601007','009',67)
insert into sc values('0601008','009',85)
 
insert into sc values('0601009','010',98)
insert into sc values('0601010','010',75)

--实验2
--1.查询全体学生的学号与姓名。
select sno,sname from student
--2.查询全体学生的姓名、学号、所在学院。
select sname,sno,sdept from student
--3.查询全体学生的详细记录。 
select * from student
--4.查询选修了课程的学生学号，并使用DISTINCT关键词取消重复行。
select DISTINCT sno from SC
--5.查询所有年龄在20岁以下的学生姓名及其年龄。
select sname,sage from student
where sage < 20
--6.查询考试成绩有不及格的学生的学号。
select sno from SC
where grade < 60
--7.查询年龄在19-22岁（包括19和22）之间的学生的姓名、系别和年龄。
select sname,sdept,sage from student
where sage >= 1 and sage <= 22
--8.查询既不是信息学院、理学院，也不是经管学院的学生的姓名和性别。
select sname,ssex from student
where sdept not in('信息学院','理学院','经管学院')
--9.查询所有姓刘的学生的姓名、学号和性别。
select sname,sno,ssex from student
where sname like '刘%'
--10.查询名字中第2个字为“伟”字的学生的姓名和学号。
select sname,sno from student
where sname like '_小%'
--11.某些学生选修课程后没有参加考试，所以有选课记录，但没有考试成绩。查询缺少成绩的学生的学号和相应的课程号。
select sno,cno from SC
where grade is null
--12.查询所有有成绩的学生学号和课程号。
select sno,cno from SC
where grade is not null
--13.查询信息学院年龄在20岁以下的学生姓名。  
select sname from student
where sage < 20 and sdept = '数学院'

--14.	查询选修了3号课程的学生的学号及其成绩，查询结果按分数的降序排列。
select sno,grade from SC
where Cno = '003'
order by grade desc
--15.	查询选修了课程的学生人数。
select COUNT(DISTINCT sno) from SC
where Cno is not null
--16.	查询选修1号课程的学生最高分数。
select MAX(grade) from SC 
where Cno = '001'
--17.	计算1号课程的学生平均成绩。
select AVG(grade) from SC
where Cno = '001'
--18.	查询某一学号学生选修课程的总学分数。
select SUM(ccredit) from SC left join course on sc.Cno = course.cno
where Sno = '0601001'

--19.	求各个课程号及相应的选课人数。
select COUNT(sno) from SC
group by cno
--20.	查询选修了3门以上课程的学生学号。
select sno from SC
group by Sno
having COUNT(cno)>3
--21.	查询每一门课的间接先修课（即先修课的先修课）。
select DISTINCT a.cno,cpno from (course a
left join SC b on a.cpno = b.Cno)
--22.	查询每个学生及其选修课程的情况。
select * from student,course,sc
where student.sno = sc.sno and sc.Cno = course.cno
--23.	查询选修2号课程且成绩在90分以上的所有学生。 
select * from student
where sno in(
	select sno from SC
	where Cno = '002' and grade > 90)
--24.	查询与“李林”在同一个学院学习的学生。
select * from student
where sdept = (
	select sdept from student
	where sname = '李小路')          
--25.	查询选修了课程名为“数据库”的学生学号和姓名。
  
select student.sno,sname from student,SC,course
where student.sno = sc.Sno 
		and sc.Cno = course.cno 
		and course.cname = '关系数据库'

