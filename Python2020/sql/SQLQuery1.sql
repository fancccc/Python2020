create table Student(SId varchar(10),Sname varchar(10),Sage datetime,Ssex varchar(10));
insert into Student values('01' , '赵雷' , '1990-01-01' , '男');
insert into Student values('02' , '钱电' , '1990-12-21' , '男');
insert into Student values('03' , '孙风' , '1990-12-20' , '男');
insert into Student values('04' , '李云' , '1990-12-06' , '男');
insert into Student values('05' , '周梅' , '1991-12-01' , '女');
insert into Student values('06' , '吴兰' , '1992-01-01' , '女');
insert into Student values('07' , '郑竹' , '1989-01-01' , '女');
insert into Student values('09' , '张三' , '2017-12-20' , '女');
insert into Student values('10' , '李四' , '2017-12-25' , '女');
insert into Student values('11' , '李四' , '2012-06-06' , '女');
insert into Student values('12' , '赵六' , '2013-06-13' , '女');
insert into Student values('13' , '孙七' , '2014-06-01' , '女');

create table Course(CId varchar(10),Cname nvarchar(10),TId varchar(10));
insert into Course values('01' , '语文' , '02');
insert into Course values('02' , '数学' , '01');
insert into Course values('03' , '英语' , '03');

create table Teacher(TId varchar(10),Tname varchar(10));
insert into Teacher values('01' , '张三');
insert into Teacher values('02' , '李四');
insert into Teacher values('03' , '王五');

create table SC(SId varchar(10),CId varchar(10),score decimal(18,1));
insert into SC values('01' , '01' , 80);
insert into SC values('01' , '02' , 90);
insert into SC values('01' , '03' , 99);
insert into SC values('02' , '01' , 70);
insert into SC values('02' , '02' , 60);
insert into SC values('02' , '03' , 80);
insert into SC values('03' , '01' , 80);
insert into SC values('03' , '02' , 80);
insert into SC values('03' , '03' , 80);
insert into SC values('04' , '01' , 50);
insert into SC values('04' , '02' , 30);
insert into SC values('04' , '03' , 20);
insert into SC values('05' , '01' , 76);
insert into SC values('05' , '02' , 87);
insert into SC values('06' , '01' , 31);
insert into SC values('06' , '03' , 34);
insert into SC values('07' , '02' , 89);
insert into SC values('07' , '03' , 98);


--1.查询" 01 "课程比" 02 "课程成绩高的学生的信息及课程分数
select * from student right join(
	select t1.sid,class1,class2 from
		(select SId, score as class1 from SC where CId = '01')as t1,
		(select SId, score as class2 from SC where CId = '02')as t2
	where t1.sid = t2.sid and t1.class1 > t2.class2) r
on student.SId = r.sid
--1.1 查询同时存在" 01 "课程和" 02 "课程的情况
select * from 
	(select * from SC where CId = '01')as t1,
	(select * from SC where CId = '02')as t2
where t1.SId  = t2.sId
	

--1.2 查询存在" 01 "课程但可能不存在" 02 "课程的情况(不存在时显示为 null )
select * from
	(select * from SC where CId = '01')as t1
	left join
	(select * from SC where CId = '02')as t2
	on t1.SId = t2.SId
--1.3 查询不存在" 01 "课程但存在" 02 "课程的情况
select * from
	(select * from SC where CId = '01')as t1
	right join
	(select * from SC where CId = '02')as t2
	on t1.SId = t2.SId
--	
select * from sc
where sc.SId not in (
    select SId from sc 
    where sc.CId = '01'
) 
AND sc.CId= '02';
--2.查询平均成绩大于等于 60 分的同学的学生编号和学生姓名和平均成绩
select student.SId ,sname,avgscore from student 
	right join
	(select sid,avg(score)as avgscore from SC 
	group by SId 
	having AVG(score)>=60)r
	on Student.SId = r.SId 
--3.查询在 SC 表存在成绩的学生信息
select *  from Student 
where SId in(
	select SId from SC )
--
select DISTINCT student.*
from student,sc
where student.SId=sc.SId
--4.查询所有同学的学生编号、学生姓名、选课总数、所有课程的总成绩(没成绩的显示为 null )
select STUDENT.SId,sname,classcount,scoresum from Student left join(
	select sid,COUNT(cid)as classcount,sum(score)as scoresum from SC
	group by SId)r
on Student.SId = R.SId 
--
select student.sid, student.sname,r.coursenumber,r.scoresum
from student,
(select sc.sid, sum(sc.score) as scoresum, count(sc.cid) as coursenumber from sc 
group by sc.sid)r
where student.sid = r.sid;
--4.1 查有成绩的学生信息
select * from Student
where SId in(select SId from SC)
--5.查询「李」姓老师的数量
select COUNT(TId ) from Teacher 
where Tname like '李%'

--6.查询学过「张三」老师授课的同学的信息
select * from Student
where SId in(
	select SId from SC   
	where cid =(
		select CId from Course 
		where tid =(
			select tid from Teacher 
			where Tname = '张三')))
--
select student.* from student,teacher,course,sc
where 
    student.sid = sc.sid 
    and course.cid=sc.cid 
    and course.tid = teacher.tid 
    and tname = '张三';
--7.查询没有学全所有课程的同学的信息
select * from Student
where SId not in(
	select sc.SId from SC 
	group by SId 
	having COUNT(CId)=(select count(cid) from course)
	)
	
--8.查询至少有一门课与学号为" 01 "的同学所学相同的同学的信息
select * from Student 
where SId in(
	select SId from SC
	where CId in(
		select CId from SC
		where SId = '01'))
--9.查询和" 01 "号的同学学习的课程 完全相同的其他同学的信息


--10.查询没学过"张三"老师讲授的任一门课程的学生姓名
select Sname from Student 
where SId not in(
	select SId from SC,Course,Teacher 
	where sc.CId = Course.CId
		and course.TId = Teacher.TId 
		and Teacher.Tname = '张三')

--11.查询两门及其以上不及格课程的同学的学号，姓名及其平均成绩
select Student.sid,Student.Sname,avgscore from Student right join(
	select sid,avg(score) as avgscore from SC 
	where SId in(
		select sid from SC 
		where score < 60
		group by SId 
		having COUNT(*) > 1 )
	group by SId )r
	on r.SId = Student.SId  

--12.检索" 01 "课程分数小于 60，按分数降序排列的学生信息
select * ,score from Student,SC 
where Student.SId = sc.	SId and score < 60 and CId = '01'
order by sc.score DESC

--13.按平均成绩从高到低显示所有学生的所有课程的成绩以及平均成绩
select student.Sname,class1,class2,class3,avgscore from Student left join 
	(select sid,score as class1 from SC
	where CId = '01')r1 on student.SId = r1.SId left join
	(select sid,score as class2 from SC
	where CId = '02')r2 on student.SId = r2.SId left join
	(select sid,score as class3 from SC
	where CId = '03')r3 on student.SId = r3.SId left join
	(select sid,avg(score) as avgscore from SC
	group by SId )r4 on student.SId = r4.SId
order by avgscore DESC

select *  from sc 
left join (
    select sid,avg(score) as avscore from sc 
    group by sid
    )r 
on sc.sid = r.sid
order by avscore desc;	
	
--14.查询各科成绩最高分、最低分和平均分：

--   以如下形式显示：课程 ID，课程 name，最高分，最低分，平均分，及格率，中等率，优良率，优秀率
	
--   及格为>=60，中等为：70-80，优良为：80-90，优秀为：>=90

--   要求输出课程号和选修人数，查询结果按人数降序排列，若人数相同，按课程号升序排列

select 
sc.CId ,
max(sc.score)as 最高分,
min(sc.score)as 最低分,
AVG(sc.score)as 平均分,
count(*)as 选修人数,
sum(case when sc.score>=60 then 1 else 0 end )*1./count(*)as 及格率,
sum(case when sc.score>=70 and sc.score<80 then 1 else 0 end )*1./count(*)as 中等率,
sum(case when sc.score>=80 and sc.score<90 then 1 else 0 end )*1./count(*)as 优良率,
sum(case when sc.score>=90 then 1 else 0 end )*1./count(*)as 优秀率 
from sc
GROUP BY sc.CId
ORDER BY count(*)DESC, sc.CId ASC

--15.按各科成绩进行排序，并显示排名， Score 重复时保留名次空缺

select a.cid, a.sid, a.score, count(b.score)+1 as rank
from sc as a 
left join sc as b 
on a.score<b.score and a.cid = b.cid
group by a.cid, a.sid,a.score
order by a.cid, rank ASC;
--15.1 按各科成绩进行排序，并显示排名， Score 重复时合并名次

--16.查询学生的总成绩，并进行排名，总分重复时保留名次空缺
--16.1 查询学生的总成绩，并进行排名，总分重复时不保留名次空缺

--17.统计各科成绩各分数段人数：课程编号，课程名称，[100-85]，[85-70]，[70-60]，[60-0] 及所占百分比

--18.查询各科成绩前三名的记录

--19.查询每门课程被选修的学生数

--20.查询出只选修两门课程的学生学号和姓名

--21.查询男生、女生人数

--22.查询名字中含有「风」字的学生信息

--23.查询同名同性学生名单，并统计同名人数

--24.查询 1990 年出生的学生名单

--25.查询每门课程的平均成绩，结果按平均成绩降序排列，平均成绩相同时，按课程编号升序排列

--26.查询平均成绩大于等于 85 的所有学生的学号、姓名和平均成绩

--27.查询课程名称为「数学」，且分数低于 60 的学生姓名和分数

--28.查询所有学生的课程及分数情况（存在学生没成绩，没选课的情况）

--29.查询任何一门课程成绩在 70 分以上的姓名、课程名称和分数

--30.查询不及格的课程

--31.查询课程编号为 01 且课程成绩在 80 分以上的学生的学号和姓名

--32.求每门课程的学生人数

--33.成绩不重复，查询选修「张三」老师所授课程的学生中，成绩最高的学生信息及其成绩

--34.成绩有重复的情况下，查询选修「张三」老师所授课程的学生中，成绩最高的学生信息及其成绩

--35.查询不同课程成绩相同的学生的学生编号、课程编号、学生成绩

--36.查询每门功成绩最好的前两名

--37.统计每门课程的学生选修人数（超过 5 人的课程才统计）。

--38.检索至少选修两门课程的学生学号

--39.查询选修了全部课程的学生信息

--40.查询各学生的年龄，只按年份来算

--41.按照出生日期来算，当前月日 < 出生年月的月日则，年龄减一

--42.查询本周过生日的学生

--43.查询下周过生日的学生

--44.查询本月过生日的学生

--45.查询下月过生日的学生

