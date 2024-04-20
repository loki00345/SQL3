use Academy

create table Students
(
Id int primary key identity (0, 1),
Name nvarchar(max) not null check(Name != ''),
Surname nvarchar(max) not null check(Surname != ''),
Rating int not null check(Rating between 0 and 5)
)

create table GroupsStudents
(
Id int primary key identity (0, 1),
GroupID int not null,
StudentID int not null
)

create table Curators
(
Id int primary key identity (0, 1),
Name nvarchar(max) not null check(Name != ''),
Surname nvarchar(max) not null check(Surname != '')
)

create table GroupsCurators
(
Id int primary key identity (0, 1),
GroupID int not null,
CuratorID int not null
)

select f.Id from Faculties as f, Departments as d where f.Id = d.FacultyID and d.Financing > 5000

select g.Name from Groups as g, Departments as d, GroupsLectures as gl, Lectures as l where g.Years = 5 and g.DepartmentID = d.Id and d.Name = 'Priddie' and gl.GroupID = g.Id and gl.LectureID = l.Id and (select count(l.id) from GroupsLectures as gl, Lectures as l where gl.GroupID = g.Id and gl.LectureID = l.Id) > 3

select g.Name from Groups as g where (select avg(s.Rating) from Students as s, GroupsStudents as gs where gs.StudentID = s.Id and gs.GroupID = g.Id) >= (select avg(s.Rating) from Students as s, GroupsStudents as gs where gs.StudentID = s.Id and gs.GroupID = g.Id and g.Name = 'Burgin')

select t.Surname, t.Name from Teachers as t where t.Salary+t.Premium > (select avg(t.Salary+t.Premium) from Teachers as t where t.IsProfessor = 1)

select g.Name from Groups as g where (select count(c.Id) from Curators as c, GroupsCurators as gc where gc.CuratorID = c.Id and gc.GroupID = g.Id) > 1

select g.Name from Groups as g where (select avg(s.Rating) from Students as s, GroupsStudents as gs where gs.StudentID = s.Id and gs.GroupID = g.Id) < (select min(s.Rating) from Groups as g2, Students as s, GroupsStudents as gs where gs.StudentID = s.Id and gs.GroupID = g2.Id and g2.Years = 5)

select d.Name from Departments as d where d.Financing > (select d2.Financing from Departments as d2 where d2.Name = 'Hanaby')

with allCounts as (select l2.Id, count(l2.DayOfWeek) as daysCount from Lectures as l2 group by l2.Id)

select s.Name from Lectures as l, Subjects as s where l.SubjectID = s.Id group by s.Name having count(l.DayOfWeek) = (select min(al.daysCount) from allCounts as al)

with studentCounts as (select s.Id, count(s.Id) as sCount from Students as s, Departments as d, Groups as g, GroupsLectures as gl, GroupsStudents as gs where g.DepartmentID = d.Id and gs.GroupID = g.Id and gs.StudentID = s.Id group by s.Id)
, lecturesCounts as (select l.Id, count(l.Id) as lCount from Lectures as l, Departments as d, Groups as g, GroupsLectures as gl, GroupsStudents as gs where g.DepartmentID = d.Id and gl.GroupID = g.Id and gl.LectureID = l.Id group by l.Id)
select sc.sCount as [Amount of students], lc.lCount as [Amount of lectures] from studentCounts as sc, lecturesCounts as lc