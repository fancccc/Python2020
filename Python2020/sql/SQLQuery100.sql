--ʵ��1
--1.���������������ݱ�
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

--2.��Student�����ӡ���ѧʱ�䡱�У�����������Ϊ�����ͣ�DATE����
--������������������ַ��ͣ�����ԭ���������������ַ��ͣ���Ϊ������
--���ӿγ����Ʊ���ȡΨһֵ��Լ��������

alter table student
add ��ѧʱ�� date

alter table student
alter column sage int

alter table course 
add constraint cname unique(cname)

--3.��������
insert into student values('0601001','����','Ů',19, '��ѧԺ','2020-05-06')
insert into student values('0601002','³��','Ů',20, '��ѧԺ','2020-05-06')
insert into student values('0601003','��С·','Ů',20, '��ѧԺ','2020-05-06')
insert into student values('0601004','³��','��',18, 'ͳ��ѧԺ','2020-05-06')
insert into student values('0601005','������','Ů',19, '��ѧԺ','2020-05-06')
insert into student values('0601006','������','��',20, '��ѧԺ','2020-05-06')
insert into student values('0601007','������','Ů',20, '��ѧԺ','2020-05-06')
insert into student values('0601008','����','��',20, 'ͳ��ѧԺ','2020-05-06')
insert into student values('0601009','�׹���','��',20, '��ѧԺ','2020-05-06')
insert into student values('0601010','����','��',21, '��ѧԺ','2020-05-06')


insert into course values('001','�����Ӧ�û���','001',1)
insert into course values('002','��ϵ���ݻ���','001',1)
insert into course values('003','������ƻ���','001',2)
insert into course values('004','���ݽṹ','001',2)
insert into course values('005','��ҳ���','001',2)
insert into course values('006','��վ���','001',2)
insert into course values('007','��ϵ���ݿ�','001',3)
insert into course values('008','�������','001',3)
insert into course values('009','���������','002',3)
insert into course values('010','Windows Server ����','001',1)

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

--ʵ��2
--1.��ѯȫ��ѧ����ѧ����������
select sno,sname from student
--2.��ѯȫ��ѧ����������ѧ�š�����ѧԺ��
select sname,sno,sdept from student
--3.��ѯȫ��ѧ������ϸ��¼�� 
select * from student
--4.��ѯѡ���˿γ̵�ѧ��ѧ�ţ���ʹ��DISTINCT�ؼ���ȡ���ظ��С�
select DISTINCT sno from SC
--5.��ѯ����������20�����µ�ѧ�������������䡣
select sname,sage from student
where sage < 20
--6.��ѯ���Գɼ��в������ѧ����ѧ�š�
select sno from SC
where grade < 60
--7.��ѯ������19-22�꣨����19��22��֮���ѧ����������ϵ������䡣
select sname,sdept,sage from student
where sage >= 1 and sage <= 22
--8.��ѯ�Ȳ�����ϢѧԺ����ѧԺ��Ҳ���Ǿ���ѧԺ��ѧ�����������Ա�
select sname,ssex from student
where sdept not in('��ϢѧԺ','��ѧԺ','����ѧԺ')
--9.��ѯ����������ѧ����������ѧ�ź��Ա�
select sname,sno,ssex from student
where sname like '��%'
--10.��ѯ�����е�2����Ϊ��ΰ���ֵ�ѧ����������ѧ�š�
select sname,sno from student
where sname like '_С%'
--11.ĳЩѧ��ѡ�޿γ̺�û�вμӿ��ԣ�������ѡ�μ�¼����û�п��Գɼ�����ѯȱ�ٳɼ���ѧ����ѧ�ź���Ӧ�Ŀγ̺š�
select sno,cno from SC
where grade is null
--12.��ѯ�����гɼ���ѧ��ѧ�źͿγ̺š�
select sno,cno from SC
where grade is not null
--13.��ѯ��ϢѧԺ������20�����µ�ѧ��������  
select sname from student
where sage < 20 and sdept = '��ѧԺ'

--14.	��ѯѡ����3�ſγ̵�ѧ����ѧ�ż���ɼ�����ѯ����������Ľ������С�
select sno,grade from SC
where Cno = '003'
order by grade desc
--15.	��ѯѡ���˿γ̵�ѧ��������
select COUNT(DISTINCT sno) from SC
where Cno is not null
--16.	��ѯѡ��1�ſγ̵�ѧ����߷�����
select MAX(grade) from SC 
where Cno = '001'
--17.	����1�ſγ̵�ѧ��ƽ���ɼ���
select AVG(grade) from SC
where Cno = '001'
--18.	��ѯĳһѧ��ѧ��ѡ�޿γ̵���ѧ������
select SUM(ccredit) from SC left join course on sc.Cno = course.cno
where Sno = '0601001'

--19.	������γ̺ż���Ӧ��ѡ��������
select COUNT(sno) from SC
group by cno
--20.	��ѯѡ����3�����Ͽγ̵�ѧ��ѧ�š�
select sno from SC
group by Sno
having COUNT(cno)>3
--21.	��ѯÿһ�ſεļ�����޿Σ������޿ε����޿Σ���
select DISTINCT a.cno,cpno from (course a
left join SC b on a.cpno = b.Cno)
--22.	��ѯÿ��ѧ������ѡ�޿γ̵������
select * from student,course,sc
where student.sno = sc.sno and sc.Cno = course.cno
--23.	��ѯѡ��2�ſγ��ҳɼ���90�����ϵ�����ѧ���� 
select * from student
where sno in(
	select sno from SC
	where Cno = '002' and grade > 90)
--24.	��ѯ�롰���֡���ͬһ��ѧԺѧϰ��ѧ����
select * from student
where sdept = (
	select sdept from student
	where sname = '��С·')          
--25.	��ѯѡ���˿γ���Ϊ�����ݿ⡱��ѧ��ѧ�ź�������
  
select student.sno,sname from student,SC,course
where student.sno = sc.Sno 
		and sc.Cno = course.cno 
		and course.cname = '��ϵ���ݿ�'

