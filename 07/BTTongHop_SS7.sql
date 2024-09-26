create database booking_room;
use booking_room;

create table Category (
Id Int AUTO_INCREMENT primary key,
Name Varchar(100) not null,
Status Tinyint default 1
);
insert into Category(Name) values
('Standard'),-- 1
('Superior'),-- 2
('Deluxe'),-- 3
('Suite'),-- 4
('Junior Suite'),-- 5
('Executive Room'),-- 6
('Family Room'),-- 7
('President Suite'),-- 8
('Penthouse'),-- 9
('Dormitory');-- 10
create table Room (
Id Int AUTO_INCREMENT primary key,
Name Varchar(150) not null ,INDEX(Name),
Status Tinyint default 1 CHECK (Status IN (0, 1)),
Price Float , check (Price>100),
SalePrice Float default 0, check (SalePrice < Price),
CreatedDate TIMESTAMP default now(),INDEX(CreatedDate),
CategoryId int not null references Category(Id) 
);

insert into Room(Name,Price,SalePrice,CategoryId) values
('R1',200,150,1),
('R2',300,250,2),
('R3',400,350,3),
('R4',500,450,3),
('R5',600,550,4),
('R6',700,650,4),
('R7',800,750,5),
('R8',900,850,5),
('R9',1000,950,6),
('R10',1100,1050,6),
('R11',1200,1150,7),
('R12',1300,1250,7),
('R13',1400,1350,8),
('R14',1500,1450,8),
('R16',1600,1550,9);
create table Customer (
Id Int AUTO_INCREMENT primary key,
Name Varchar(150) not null,
Email Varchar(150) not null unique, 
Phone Varchar(50) not null unique,
Address Varchar(255) ,
CreatedDate TIMESTAMP default now(),
Gender Tinyint not null CHECK (Gender IN (0, 1, 2)),
BirthDay Date not null
);
insert into Customer(Name,Email,Phone,Address,Gender,BirthDay) values
('linh','linh@gmail.com','0987654321','tb',1,'1993-11-10'),-- 1
('huong','huong@gmail.com','0987654322','hn',0,'1994-11-10'),-- 2
('hung','hung@gmail.com','0987654323','bn',0,'2001-11-10'),-- 3
('nghia','nghia@gmail.com','0987654324','hn',0,'1995-11-10'),-- 4
('tiep','tiep@gmail.com','0987654325','hn',0,'1997-11-10'),-- 5
('tac','tac@gmail.com','0987654326','tb',0,'2001-11-10'),-- 6
('yen','yen@gmail.com','0987654327','hn',1,'1998-11-10'),-- 7
('minh','minh@gmail.com','0987654328','na',0,'1993-11-10'),-- 8
('huynh','huynh@gmail.com','0987654329','nd',0,'1996-11-10'),-- 9
('duong','duong@gmail.com','0987654320','hn',0,'2001-11-10')-- 10;
;
create table Booking (
Id Int AUTO_INCREMENT primary key,
CustomerId int not null references Customer(Id) ,
Status Tinyint default 1 CHECK (Status IN (0, 1,2,3)),
BookingDate timestamp DEFAULT now() 
);
insert into Booking(CustomerId) values
(1),(2),(3),(4),(5),(6),(7),(8),(9),(10);
create table BookingDetail (
BookingId Int not null REFERENCES Booking(Id),
RoomId int not null REFERENCES Room(Id),
Price Float not null,
StartDate Date not null,
EndDate Date not null, check (EndDate> StartDate),
primary key(BookingId,RoomId)
);

insert into BookingDetail(BookingId,RoomId,Price,StartDate,EndDate) values
(1,1,200,'2024-03-10','2024-03-14'),
(1,2,300,'2024-03-10','2024-03-14'),
(2,2,300,'2024-03-10','2024-03-14'),
(2,3,400,'2024-03-10','2024-03-14'),
(3,3,400,'2024-03-10','2024-03-14'),
(3,4,500,'2024-03-10','2024-03-14'),
(4,5,600,'2024-03-10','2024-03-14'),
(4,10,1100,'2024-03-10','2024-03-14'),
(5,6,700,'2024-03-10','2024-03-14'),
(5,7,800,'2024-03-10','2024-03-14'),
(6,7,800,'2024-03-10','2024-03-14'),
(6,8,900,'2024-03-10','2024-03-14'),
(7,8,900,'2024-03-10','2024-03-14'),
(7,9,1000,'2024-03-10','2024-03-14'),
(8,9,1000,'2024-03-10','2024-03-14'),
(8,10,1100,'2024-03-10','2024-03-14'),
(9,10,1100,'2024-03-10','2024-03-14'),
(9,11,1200,'2024-03-10','2024-03-14'),
(10,12,1300,'2024-03-10','2024-03-14'),
(10,13,1400,'2024-03-10','2024-03-14');

-- Yêu cầu 1 ( Sử dụng lệnh SQL để truy vấn cơ bản ): 
-- 1.	Lấy ra danh phòng có sắp xếp giảm dần theo Price gồm các cột sau: 
-- Id, Name, Price, SalePrice, Status, CategoryName, CreatedDate
select Room.Id, Room.Name,Room.Price,Room.SalePrice,Room.Status,Category.Name,Room.CreatedDate from Room
left join Category on Category.Id =Room.CategoryId;
-- 2.	Lấy ra danh sách Category gồm: Id, Name, TotalRoom, Status (Trong đó cột Status nếu = 0, Ẩn, = 1 là Hiển thị )
select Category.Id,Category.Name, count(Room.Id) as TotalRoom, Category.Status from Room
left join Category on Category.Id=Room.CategoryId
where Category.Status = 1
GROUP BY Room.CategoryId;
-- 3.	Truy vấn danh sách Customer gồm: 
-- Id, Name, Email, Phone, Address, CreatedDate, Gender, BirthDay, Age (Age là cột suy ra từ BirthDay, Gender nếu = 0 là Nam, 1 là Nữ,2 là khác )
select Customer.Id,Customer.Name,Customer.Email,Customer.Phone,Customer.Address,Customer.CreatedDate,
CASE 
	WHEN Gender = 0 THEN 'Nam'
	WHEN Gender = 1 THEN 'Nu'
	WHEN Gender = 2 THEN 'Khac'
	ELSE 'Not specified'
END AS GenderText,
2024- year(BirthDay) as Age
from Customer;
-- 4.	Truy vấn xóa các sản phẩm chưa được bán
DELETE FROM Room WHERE Id not in (
select DISTINCT RoomId from BookingDetail
) ;
-- 5.	Cập nhật Cột SalePrice tăng thêm 10% cho tất cả các phòng có Price >= 250000
select * from Room;
UPDATE Room
SET SalePrice = SalePrice*1.1
WHERE Price> 250 
and SalePrice*1.1 <Price;

SET SQL_SAFE_UPDATES = 0;


-- Yêu cầu 2 ( Sử dụng lệnh SQL tạo View )
-- 1.View v_getRoomInfo Lấy ra danh sách của 10 phòng có giá cao nhất 
create view v_getRoomInfo as
select * from Room
ORDER BY Price desc limit 10;

-- 2.	View v_getBookingList hiển thị danh sách phiếu đặt hàng gồm: 
-- Id, BookingDate, Status, CusName, Email, Phone,TotalAmount 
-- ( Trong đó cột Status nếu = 0 Chưa duyệt, = 1  Đã duyệt, = 2 Đã thanh toán, = 3 Đã hủy ) 
create view sub_booking as
select Booking.Id,Booking.CustomerId,Booking.Status,Booking.BookingDate,sum(BookingDetail.Price) as TotalAmount from  BookingDetail
left join Booking on Booking.Id = BookingDetail.BookingId
left join Room on Room.Id = BookingDetail.RoomId
group by Booking.Id,Booking.CustomerId,Booking.Status,Booking.BookingDate;
select * from sub_booking;

create view v_getBookingList as
select sub_booking.Id,sub_booking.BookingDate, 
CASE 
	WHEN sub_booking.Status = 0 THEN 'Chưa duyệt'
	WHEN sub_booking.Status = 1 THEN 'Đã duyệt'
	WHEN sub_booking.Status = 2 THEN 'Đã thanh toán'
	WHEN sub_booking.Status = 3 THEN 'Đã hủy'
	ELSE 'Not specified'
END AS Status_booking,
sub_booking.CustomerId,
Customer.Name as CusName,Customer.Email,Customer.Phone,
sub_booking.TotalAmount
from sub_booking
left join Customer on Customer.Id=sub_booking.CustomerId
;
select * from v_getBookingList;


-- Yêu cầu 3 ( Sử dụng lệnh SQL tạo thủ tục Stored Procedure )
-- 1.	Thủ tục addRoomInfo thực hiện thêm mới Room, 
-- khi gọi thủ tục truyền đầy đủ các giá trị của bảng Room ( Trừ cột tự động tăng )
DELIMITER $$
CREATE PROCEDURE addRoomInfo(IN Name_new varchar(150),IN Price_new FLOAT,IN SalePrice_new FLOAT,IN CategoryId_new INT )
BEGIN
    INSERT INTO Room(Name,Price,SalePrice,CategoryId)
    VALUES
    (Name_new,Price_new,SalePrice_new,CategoryId_new);
END $$
DELIMITER ;
call addRoomInfo('R17',2000,1900,7);

-- 2.	Thủ tục getBookingByCustomerId hiển thị danh sách phieus đặt phòng của khách hàng theo Id khách hàng gồm: 
-- Id, BookingDate, Status, TotalAmount (Trong đó cột Status nếu = 0 Chưa duyệt, = 1  Đã duyệt,, = 2 Đã thanh toán, = 3 Đã hủy), 
-- Khi gọi thủ tục truyền vào id cảu khách hàng
DELIMITER $$
CREATE PROCEDURE getBookingByCustomerId(IN id INT )
BEGIN
    SELECT * FROM v_getBookingList 
    WHERE v_getBookingList.CustomerId =id;
END $$
DELIMITER ;
call getBookingByCustomerId(1);

-- 3.	Thủ tục getRoomPaginate lấy ra danh sách phòng có phân trang gồm: 
-- Id, Name, Price, SalePrice, Khi gọi thủ tuc truyền vào limit và page
DELIMITER $$
CREATE PROCEDURE getRoomPaginate(IN page_size INT,IN page INT )
BEGIN
	DECLARE page_start INT;
    SET page_start = (page-1)*page_size;
    SELECT * FROM Room
    LIMIT page_start,page_size;
END $$
DELIMITER ;
call getRoomPaginate(5,2);

-- Yêu cầu 4 ( Sử dụng lệnh SQL tạo Trigger )
-- 1.	Tạo trigger tr_Check_Price_Value sao cho khi thêm hoặc sửa phòng Room 
-- nếu nếu giá trị của cột Price > 5000000 thì tự động chuyển về 5000000 và in ra thông báo ‘Giá phòng lớn nhất 5 triệu’
DELIMITER $$
CREATE TRIGGER tr_Check_Price_Value_Update
BEFORE UPDATE ON Room
FOR EACH ROW
BEGIN 
        IF NEW.Price > 5000 THEN
		Set NEW.Price = 5000;
		ELSEIF NEW.SalePrice > 5000 THEN
		Set new.SalePrice = 4500;
		-- SIGNAL SQLSTATE '45000'
		-- SET MESSAGE_TEXT = 'Giá phòng lớn nhất là 5 triệu';
    END IF;
END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER tr_Check_Price_Value_Insert
BEFORE INSERT ON Room
FOR EACH ROW
BEGIN 
        IF NEW.Price > 5000 THEN
		Set NEW.Price = 5000;
        ELSEIF NEW.SalePrice > 5000 THEN
		Set new.SalePrice = 4500;
		-- SIGNAL SQLSTATE '45000'
		-- SET MESSAGE_TEXT = 'Giá phòng lớn nhất là 5 triệu';
    END IF;
END $$
DELIMITER ;

DROP TRIGGER tr_Check_Price_Value_Update;
DROP TRIGGER tr_Check_Price_Value_Insert;

UPDATE Room 
SET Price = 6000 
WHERE id = 17;

call addRoomInfo('R22',10000,6000,7);


-- 2.	Tạo trigger tr_check_Room_NotAllow khi thực hiện đặt pòng, nếu ngày đến (StartDate) và ngày đi (EndDate) 
-- của đơn hiện tại mà phòng đã có người đặt rồi thì báo lỗi “Phòng này đã có người đặt trong thời gian này,
-- vui lòng chọn thời gian khác”


