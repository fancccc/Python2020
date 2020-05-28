create table Student(SId varchar(10),Sname varchar(10),Sage datetime,Ssex varchar(10));
insert into Student values('01' , '����' , '1990-01-01' , '��');
insert into Student values('02' , 'Ǯ��' , '1990-12-21' , '��');
insert into Student values('03' , '���' , '1990-12-20' , '��');
insert into Student values('04' , '����' , '1990-12-06' , '��');
insert into Student values('05' , '��÷' , '1991-12-01' , 'Ů');
insert into Student values('06' , '����' , '1992-01-01' , 'Ů');
insert into Student values('07' , '֣��' , '1989-01-01' , 'Ů');
insert into Student values('09' , '����' , '2017-12-20' , 'Ů');
insert into Student values('10' , '����' , '2017-12-25' , 'Ů');
insert into Student values('11' , '����' , '2012-06-06' , 'Ů');
insert into Student values('12' , '����' , '2013-06-13' , 'Ů');
insert into Student values('13' , '����' , '2014-06-01' , 'Ů');

create table Course(CId varchar(10),Cname nvarchar(10),TId varchar(10));
insert into Course values('01' , '����' , '02');
insert into Course values('02' , '��ѧ' , '01');
insert into Course values('03' , 'Ӣ��' , '03');

create table Teacher(TId varchar(10),Tname varchar(10));
insert into Teacher values('01' , '����');
insert into Teacher values('02' , '����');
insert into Teacher values('03' , '����');

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


--1.��ѯ" 01 "�γ̱�" 02 "�γ̳ɼ��ߵ�ѧ������Ϣ���γ̷���
select * from student right join(
	select t1.sid,class1,class2 from
		(select SId, score as class1 from SC where CId = '01')as t1,
		(select SId, score as class2 from SC where CId = '02')as t2
	where t1.sid = t2.sid and t1.class1 > t2.class2) r
on student.SId = r.sid
--1.1 ��ѯͬʱ����" 01 "�γ̺�" 02 "�γ̵����
select * from 
	(select * from SC where CId = '01')as t1,
	(select * from SC where CId = '02')as t2
where t1.SId  = t2.sId
	

--1.2 ��ѯ����" 01 "�γ̵����ܲ�����" 02 "�γ̵����(������ʱ��ʾΪ null )
select * from
	(select * from SC where CId = '01')as t1
	left join
	(select * from SC where CId = '02')as t2
	on t1.SId = t2.SId
--1.3 ��ѯ������" 01 "�γ̵�����" 02 "�γ̵����
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
--2.��ѯƽ���ɼ����ڵ��� 60 �ֵ�ͬѧ��ѧ����ź�ѧ��������ƽ���ɼ�
select student.SId ,sname,avgscore from student 
	right join
	(select sid,avg(score)as avgscore from SC 
	group by SId 
	having AVG(score)>=60)r
	on Student.SId = r.SId 
--3.��ѯ�� SC ����ڳɼ���ѧ����Ϣ
select *  from Student 
where SId in(
	select SId from SC )
--
select DISTINCT student.*
from student,sc
where student.SId=sc.SId
--4.��ѯ����ͬѧ��ѧ����š�ѧ��������ѡ�����������пγ̵��ܳɼ�(û�ɼ�����ʾΪ null )
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
--4.1 ���гɼ���ѧ����Ϣ
select * from Student
where SId in(select SId from SC)
--5.��ѯ�������ʦ������
select COUNT(TId ) from Teacher 
where Tname like '��%'

--6.��ѯѧ������������ʦ�ڿε�ͬѧ����Ϣ
select * from Student
where SId in(
	select SId from SC   
	where cid =(
		select CId from Course 
		where tid =(
			select tid from Teacher 
			where Tname = '����')))
--
select student.* from student,teacher,course,sc
where 
    student.sid = sc.sid 
    and course.cid=sc.cid 
    and course.tid = teacher.tid 
    and tname = '����';
--7.��ѯû��ѧȫ���пγ̵�ͬѧ����Ϣ
select * from Student
where SId not in(
	select sc.SId from SC 
	group by SId 
	having COUNT(CId)=(select count(cid) from course)
	)
	
--8.��ѯ������һ�ſ���ѧ��Ϊ" 01 "��ͬѧ��ѧ��ͬ��ͬѧ����Ϣ
select * from Student 
where SId in(
	select SId from SC
	where CId in(
		select CId from SC
		where SId = '01'))
--9.��ѯ��" 01 "�ŵ�ͬѧѧϰ�Ŀγ� ��ȫ��ͬ������ͬѧ����Ϣ


--10.��ѯûѧ��"����"��ʦ���ڵ���һ�ſγ̵�ѧ������
select Sname from Student 
where SId not in(
	select SId from SC,Course,Teacher 
	where sc.CId = Course.CId
		and course.TId = Teacher.TId 
		and Teacher.Tname = '����')

--11.��ѯ���ż������ϲ�����γ̵�ͬѧ��ѧ�ţ���������ƽ���ɼ�
select Student.sid,Student.Sname,avgscore from Student right join(
	select sid,avg(score) as avgscore from SC 
	where SId in(
		select sid from SC 
		where score < 60
		group by SId 
		having COUNT(*) > 1 )
	group by SId )r
	on r.SId = Student.SId  

--12.����" 01 "�γ̷���С�� 60���������������е�ѧ����Ϣ
select * ,score from Student,SC 
where Student.SId = sc.	SId and score < 60 and CId = '01'
order by sc.score DESC

--13.��ƽ���ɼ��Ӹߵ�����ʾ����ѧ�������пγ̵ĳɼ��Լ�ƽ���ɼ�
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
	
--14.��ѯ���Ƴɼ���߷֡���ͷֺ�ƽ���֣�

--   ��������ʽ��ʾ���γ� ID���γ� name����߷֣���ͷ֣�ƽ���֣������ʣ��е��ʣ������ʣ�������
	
--   ����Ϊ>=60���е�Ϊ��70-80������Ϊ��80-90������Ϊ��>=90

--   Ҫ������γ̺ź�ѡ����������ѯ����������������У���������ͬ�����γ̺���������

select 
sc.CId ,
max(sc.score)as ��߷�,
min(sc.score)as ��ͷ�,
AVG(sc.score)as ƽ����,
count(*)as ѡ������,
sum(case when sc.score>=60 then 1 else 0 end )*1./count(*)as ������,
sum(case when sc.score>=70 and sc.score<80 then 1 else 0 end )*1./count(*)as �е���,
sum(case when sc.score>=80 and sc.score<90 then 1 else 0 end )*1./count(*)as ������,
sum(case when sc.score>=90 then 1 else 0 end )*1./count(*)as ������ 
from sc
GROUP BY sc.CId
ORDER BY count(*)DESC, sc.CId ASC

--15.�����Ƴɼ��������򣬲���ʾ������ Score �ظ�ʱ�������ο�ȱ

select a.cid, a.sid, a.score, count(b.score)+1 as rank
from sc as a 
left join sc as b 
on a.score<b.score and a.cid = b.cid
group by a.cid, a.sid,a.score
order by a.cid, rank ASC;
--15.1 �����Ƴɼ��������򣬲���ʾ������ Score �ظ�ʱ�ϲ�����

--16.��ѯѧ�����ܳɼ����������������ܷ��ظ�ʱ�������ο�ȱ
--16.1 ��ѯѧ�����ܳɼ����������������ܷ��ظ�ʱ���������ο�ȱ

--17.ͳ�Ƹ��Ƴɼ����������������γ̱�ţ��γ����ƣ�[100-85]��[85-70]��[70-60]��[60-0] ����ռ�ٷֱ�

--18.��ѯ���Ƴɼ�ǰ�����ļ�¼

--19.��ѯÿ�ſγ̱�ѡ�޵�ѧ����

--20.��ѯ��ֻѡ�����ſγ̵�ѧ��ѧ�ź�����

--21.��ѯ������Ů������

--22.��ѯ�����к��С��硹�ֵ�ѧ����Ϣ

--23.��ѯͬ��ͬ��ѧ����������ͳ��ͬ������

--24.��ѯ 1990 �������ѧ������

--25.��ѯÿ�ſγ̵�ƽ���ɼ��������ƽ���ɼ��������У�ƽ���ɼ���ͬʱ�����γ̱����������

--26.��ѯƽ���ɼ����ڵ��� 85 ������ѧ����ѧ�š�������ƽ���ɼ�

--27.��ѯ�γ�����Ϊ����ѧ�����ҷ������� 60 ��ѧ�������ͷ���

--28.��ѯ����ѧ���Ŀγ̼��������������ѧ��û�ɼ���ûѡ�ε������

--29.��ѯ�κ�һ�ſγ̳ɼ��� 70 �����ϵ��������γ����ƺͷ���

--30.��ѯ������Ŀγ�

--31.��ѯ�γ̱��Ϊ 01 �ҿγ̳ɼ��� 80 �����ϵ�ѧ����ѧ�ź�����

--32.��ÿ�ſγ̵�ѧ������

--33.�ɼ����ظ�����ѯѡ�ޡ���������ʦ���ڿγ̵�ѧ���У��ɼ���ߵ�ѧ����Ϣ����ɼ�

--34.�ɼ����ظ�������£���ѯѡ�ޡ���������ʦ���ڿγ̵�ѧ���У��ɼ���ߵ�ѧ����Ϣ����ɼ�

--35.��ѯ��ͬ�γ̳ɼ���ͬ��ѧ����ѧ����š��γ̱�š�ѧ���ɼ�

--36.��ѯÿ�Ź��ɼ���õ�ǰ����

--37.ͳ��ÿ�ſγ̵�ѧ��ѡ������������ 5 �˵Ŀγ̲�ͳ�ƣ���

--38.��������ѡ�����ſγ̵�ѧ��ѧ��

--39.��ѯѡ����ȫ���γ̵�ѧ����Ϣ

--40.��ѯ��ѧ�������䣬ֻ���������

--41.���ճ����������㣬��ǰ���� < �������µ������������һ

--42.��ѯ���ܹ����յ�ѧ��

--43.��ѯ���ܹ����յ�ѧ��

--44.��ѯ���¹����յ�ѧ��

--45.��ѯ���¹����յ�ѧ��

