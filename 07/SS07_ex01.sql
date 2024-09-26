create database QuanlySinhVien;
use QuanlySinhVien;
create table students(
studentId int primary key auto_increment,
studentName varchar(50),
age int,
email varchar(100)
);
insert into students(studentName,age,email) values
('Nguyen Quang An',18,'an@yahoo.com'),
('Nguyen Cong Vinh',19,'vinh@gmail.com'),
('Nguyen Van Quyen',20,'quyen'),
('Pham Thanh Binh',25,'binh@com'),
('Nguyen Van Tai Em',30,'taiem@sport.vn');

create table class(
classId int primary key auto_increment,
className varchar(50)
);
insert into class(className) values
('C0706L'),
('C0708G');
create table subject(
subjectId int primary key auto_increment,
subjectName varchar(50)
);
insert into subject(subjectName) values
('SQL'),
('Java'),
('C'),
('Visual Basic');
create table classStudent(
studentId int references students(studentId),
classId int references class(classId)
);
insert into classStudent() values
(1,2),
(2,1),
(3,2),
(4,2),
(5,2),
(5,1);

create table mark(
subjectId int references subject(subjectId),
studentId int references students(studentId),
mark int
);

insert into mark(mark,subjectId,studentId) values
(8,1,1),
(4,2,1),
(9,1,1),
(7,1,3),
(3,1,4),
(5,2,5),
(8,3,3),
(1,3,5),
(3,2,4);

-- Hiển thị danh sách tất cả học viên
select * from students;

-- Hiển thị danh sách tất cả các môn học
select * from subject;
-- Tính điểm trung bình của từng học sinh
select * from mark; 
select studentId, AVG(mark) from mark
group by studentId;
-- Hiển thị môn học có học sinh thi được trên 9 điểm
select subject.*,mark from mark
join subject using (subjectId)
where mark >= 9;
-- Hiển thị điểm trung bình của từng học sinh theo chiều giảm dần
select * from mark; 
select studentId, students.studentName, AVG(mark) from mark
join students using (studentId)
group by studentId
order by AVG(mark) DESC;
-- Cập nhật thêm dòng chữ “Day la mon hoc” vào trước các bản ghi trên cột SubjectName trong bảng subjects
select 
subjectId,
CONCAT('Day la mon hoc ',subjectName) as SubjectName
from subject; 
-- Viết Trigger để kiểm tra độ tuổi nhập vào trong bảng students yêu cầu age >15 và age < 50
drop trigger tr_Check_Age;
DELIMITER $$
CREATE TRIGGER tr_Check_Age
BEFORE INSERT ON students
FOR EACH ROW
BEGIN 
	IF NEW.age >= 50 OR NEW.age <= 15 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'độ tuổi nhập vào trong bảng students yêu cầu age >15 và age < 50';
    END IF;
END $$
DELIMITER ;
insert into students(studentName,age,email) values
('Tung', 14,'trung@gmail.com');
-- Loại bỏ quan hệ giữa tất cả các bảng

-- Xóa học viên có studentId = 1
delete from students where studentId = 1;

-- Trong bảng students thêm một cột (column) status có kiểu dữ liệu là bit và có gía trị default là 1
ALTER TABLE students
ADD status bit(1) default 1;

-- Cập nhật giá trị status trong bảng students thành 0
SET SQL_SAFE_UPDATES = 0;
update students
set status = 0;