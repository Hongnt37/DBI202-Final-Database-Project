-- tạo database
CREATE DATABASE MyNewspapers7;
GO
USE MyNewspapers7;
GO
/* MENU (search các từ khóa để đi tới các phần code)
PHẦN 1: Tạo bảng
PHẦN 2: Tạo các ràng buộc trong CSDL sử dụng trigger
PHẦN 3: Tạo stored procedure hỗ trợ nhập dữ liệu, Index 
PHẦN 4: THÊM DỮ LIỆU CƠ BẢN VÀO DATABASE
PHẦN 5: THÊM DỮ LIỆU SỬ DỤNG STORE PROCEDURE
PHẦN 6: TẠO FUNTION 
PHẦN 7: THỰC HIỆN CÁC TRUY VẤN THEO YÊU CẦU
*/

/* PHẦN 1:TẠO BẢNG:
Thứ tự:
1. Position/Employee/Filters/Customer/Newsletters
2. Posts/Author/Users/Subscribe/Transactions
3. Images/Audio/Video/Keywords/PostAuthor/SocialMedia/SavePost/Comment
*/
--1.1 Position
CREATE TABLE Position (
	Position_ID INT IDENTITY(1,1) PRIMARY KEY,
	Position VARCHAR(100) NOT NULL
);
-- 1.2 Employee
CREATE TABLE Employee (
	Employee_ID INT IDENTITY(1,1) PRIMARY KEY,
	NameEmployee VARCHAR(100) NOT NULL,
	StatusEmployee BIT DEFAULT NULL
);
-- 1.3 Filter
CREATE TABLE Filters (
	Filter_ID INT IDENTITY(1,1) PRIMARY KEY,
	Applications VARCHAR(100),
	EndUser VARCHAR(100),
	Sector VARCHAR(100),
	SourceData VARCHAR(100),
	Technology VARCHAR(100)
);
--1.4 Customer
CREATE TABLE Customer (
	Customer_ID INT IDENTITY(1,1) PRIMARY KEY,
	Email NVARCHAR(100) NOT NULL UNIQUE,
	CusPassword NVARCHAR(100),
	TimeRegis DATETIME NOT NULL, 
	TypeAccount VARCHAR(50) DEFAULT 'Regular' NOT NULL,
	isBlocked BIT DEFAULT 0 CHECK(isBlocked = 1 OR isBlocked = 0),
	AccBalance DECIMAL(10,2) DEFAULT 0 NOT NULL
);
--1.5 Newsletters
CREATE TABLE Newsletters (
	Newsletter_ID INT IDENTITY(1,1) PRIMARY KEY,
	TopicLetter VARCHAR(100) NOT NULL,
	Frequency VARCHAR(100) NOT NULL
);
-- 2.1 Posts
CREATE TABLE Posts (
	Post_ID INT IDENTITY(1,1) PRIMARY KEY,
	Employee_ID INT,
	Filter_ID INT,
	TimePost DATETIME NOT NULL,
	Title VARCHAR(255) NOT NULL,
	TypePost VARCHAR(10) CHECK(TypePost = 'Article' OR TypePost = 'Podcast' OR TypePost = 'Video'),
	LinkText VARCHAR(255),
	Topic VARCHAR(50) NOT NULL,
	StatusPost BIT DEFAULT NULL,
	CONSTRAINT FK_Posts_Employee FOREIGN KEY (Employee_ID) REFERENCES Employee(Employee_ID),
	CONSTRAINT FK_Posts_Filters FOREIGN KEY (Filter_ID) REFERENCES Filters(Filter_ID)
);
--2.2 Author 
CREATE TABLE Author (
	Author_ID INT IDENTITY(1,1) PRIMARY KEY,
	Employee_ID INT NOT NULL,
	LinkAvatar NVARCHAR(255),
	NameAuthor VARCHAR(100) NOT NULL,
	IntroAuthor VARCHAR(255) NOT NULL,
	StatusAuthor BIT DEFAULT 1 CHECK(StatusAuthor = 1 OR StatusAuthor = 0),
	CONSTRAINT FK_Author_Employee FOREIGN KEY (Employee_ID) REFERENCES Employee(Employee_ID)
);
-- 2.3 Users
CREATE TABLE Users (
	UserName VARCHAR(20) PRIMARY KEY,
	Employee_ID INT NOT NULL,
	Position_ID INT NOT NULL,
	Time_start DATE NOT NULL,
	Time_end DATE,
	StatusUser BIT DEFAULT 1 CHECK(StatusUser = 1 OR StatusUser = 0),
	CONSTRAINT FK_Users_Employee FOREIGN KEY (Employee_ID) REFERENCES Employee(Employee_ID),
	CONSTRAINT FK_Users_Position FOREIGN KEY (Position_ID) REFERENCES Position(Position_ID)
);
-- 2.4 Subscribe
CREATE TABLE Subscribe (
	Customer_ID INT NOT NULL,
	Newsletter_ID INT NOT NULL,
	CONSTRAINT PK_Subscribe PRIMARY KEY (Customer_ID, Newsletter_ID),
	CONSTRAINT FK_Subscribe_Customer FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID),
	CONSTRAINT FK_Subscribe_Newsletters FOREIGN KEY (Newsletter_ID) REFERENCES Newsletters(Newsletter_ID)
);
--2.5 Transactions
CREATE TABLE Transactions (
	Transaction_ID INT IDENTITY(1,1) PRIMARY KEY,
	Customer_ID INT NOT NULL,
	TimeTrans DATETIME NOT NULL,
	Amount DECIMAL(10,2) NOT NULL,
	StatusTrans BIT CHECK(StatusTrans = 1 OR StatusTrans = 0),
	CONSTRAINT FK_Transactions_Customer FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID)
);
--3.1 Images
CREATE TABLE Images (
	Image_ID INT IDENTITY(1,1) PRIMARY KEY,
	Post_ID INT NOT NULL,
	LinkImage VARCHAR(255) NOT NULL,
	Photographer VARCHAR(100) NOT NULL,
	Note VARCHAR(255),
	CONSTRAINT FK_Images_Posts FOREIGN KEY (Post_ID) REFERENCES Posts(Post_ID)
);
--3.2 Audio
CREATE TABLE Audio (
	Audio_ID INT IDENTITY(1,1) PRIMARY KEY,
	Post_ID INT NOT NULL,
	LinkAudio VARCHAR(255) NOT NULL,
	IntroAudio VARCHAR(255),
	TitleAudio VARCHAR(255) NOT NULL,
	CONSTRAINT FK_Audio_Posts FOREIGN KEY (Post_ID) REFERENCES Posts(Post_ID)
);
--3.3 Video
CREATE TABLE Video (
	Video_ID INT IDENTITY(1,1) PRIMARY KEY,
	Post_ID INT NOT NULL,
	LinkVideo VARCHAR(255) NOT NULL,
	Transcript VARCHAR(255) NOT NULL,
	IntroVideo VARCHAR(255),
	CONSTRAINT FK_Video_Posts FOREIGN KEY (Post_ID) REFERENCES Posts(Post_ID)
);
--3.4 Keywords
CREATE TABLE Keywords (
	Keyword_ID INT IDENTITY(1,1) PRIMARY KEY,
	Post_ID INT NOT NULL,
	Keywords VARCHAR(255) NOT NULL,
	CONSTRAINT FK_Keywords_Posts FOREIGN KEY (Post_ID) REFERENCES Posts(Post_ID)
);
--3.5 PostAuthor
CREATE TABLE PostAuthor (
	Post_ID INT NOT NULL,
	Author_ID INT NOT NULL,
	TypeAuthor VARCHAR(50) NOT NULL,
	CONSTRAINT PK_PostAuthor PRIMARY KEY (Post_ID, Author_ID),
	CONSTRAINT FK_PostAuthor_Posts FOREIGN KEY (Post_ID) REFERENCES Posts(Post_ID),
	CONSTRAINT FK_PostAuthor_Author FOREIGN KEY (Author_ID) REFERENCES Author(Author_ID)
);
--3.6 SocialMedia
CREATE TABLE SocialMedia (
	Author_ID INT NOT NULL,
	TypeSocial VARCHAR(20) NOT NULL,
	Link VARCHAR(255) NOT NULL,
	CONSTRAINT PK_SocialMedia PRIMARY KEY (Author_ID, TypeSocial),
	CONSTRAINT FK_SocialMedia_Author FOREIGN KEY (Author_ID) REFERENCES Author(Author_ID)
);
--3.7 SavePost
CREATE TABLE SavePost (
	Post_ID INT NOT NULL,
	Customer_ID INT NOT NULL,
	TimeSave DATE NOT NULL,
	CONSTRAINT PK_SavePost PRIMARY KEY (Post_ID, Customer_ID),
	CONSTRAINT FK_SavePost_Posts FOREIGN KEY (Post_ID) REFERENCES Posts(Post_ID),
	CONSTRAINT FK_SavePost_Customer FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID)
);
--3.8 Comment
CREATE TABLE Comment (
	Comment_ID INT IDENTITY(1,1) PRIMARY KEY,
	Post_ID INT NOT NULL,
	Customer_ID INT NOT NULL,
	TimeComment DATETIME NOT NULL,
	Comment VARCHAR(1000) NOT NULL,
	StatusComment BIT DEFAULT 1 CHECK(StatusComment = 1 OR StatusComment = 0),
	CONSTRAINT FK_Comment_Posts FOREIGN KEY (Post_ID) REFERENCES Posts(Post_ID),
	CONSTRAINT FK_Customer_Posts FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID)
);
--------------------------------------------------
--PHẦN 2: Tạo các ràng buộc trong CSDL sử dụng trigger
--1- TG_Position_delete --Không xóa các Position_ID có nhân viên.
--2- TG_Employee_insert --Khi nhân viên mới được thêm vào CSDL StatusEmployee luôn là 'NULL'
--3- TG_Employee_delete --Không xóa các Employee_ID có StatusEmployee = ‘True’ (nhân viên đang làm việc)
--4- TG_Employee_update --Khi StatusEmployee = ‘False’ tự động update StatusAuthor = ‘False’ và toàn bộ các hàng của bảng Users có Employee_ID trùng khớp sẽ tự động update StatusUser  thành ’False’
--5- TG_Customer_insert_update --Check định dạng email, password > 6 ký tự trong bảng Customer
--6- TG_Customer_delete --Không xóa các Customer_ID có TypeAccount = ‘VIP’ (khách hàng đã trả phí)
--7.0- TG_Posts_insert --Khi bài post được thêm vào bảng, statusPost = 'Null' 
--7.1- TG_Posts_insert_update --Khi insert & update Chỉ Employee có position = ‘Website Administrator’ và StatusUser = ‘True’ mới có thể được thêm vào bảng Posts ở cột Employee_ID và nếu thông tin cần thiết đã đủ thì update statuspost = 1
--8- TG_Posts_delete --Không xóa dữ liệu các bảng Posts có status = ‘True’ (bài đăng đang hiển thị trên trang)
--9- TG_Author_update --Không thể Update Author với statusAuthor = 'true' khi statusEmployee = 'False'
--10- TG_Author_insert --Không thể thêm mới 1 Author khi StatusEmployee = 'False' or 'NULL'
--11- TG_Author_delete --Không xóa các Author có bài Posts hoặc có StatusAuthor = ‘True’ (tác giả có bài đăng trên trang hoặc vẫn đang hoạt động)
--12.0- TG_Users_insert_update --Trong bảng Users trường time_end phải là ‘null’ hoặc có giá trị lớn hơn time_start
--12.1- TG_Users_insert_update --Bảng Users không có các dòng dữ liệu trùng lặp vô lý (1 employee có 2 user tại cùng 1 vị trí cùng đang hoạt động)
--13- TG_Users_insert --Không thể thêm user cho nhân viên đã nghỉ việc, nếu dữ liệu thêm vào có statusUser = 1 và statusEmployee = 'NULL' thì update statusEmployee = 1
--14- TG_Users_update --Không cho phép update Employee_ID và Position_ID trong bảng Users và không thể update trạng thái của user thành đang hoạt động với nhân viên đã nghỉ việc
--15- TG_Users_update_delete --Khi tất cả StatusUser (bảng Users) của một employee_ID là ‘False’ thì tự động update StatusEmployee (bảng Employee) thành ‘False’
--16- TG_Transactions_update --Không cho update dữ liệu trong bảng Transactions
--17- TG_Transactions_insert --Tự động update bảng Customer các trường TypeAccount và AccBalance khi có giao dịch được hoàn thành trong bảng Transactions.
--18- TG_Audio_insert_update --Ràng buộc giữa Posts và Audio: chỉ những Post_ID có TypePost = 'Podcast' mới thêm được dữ liệu vào bảng Audio
--19- TG_Video_insert_update --Ràng buộc giữa Posts và Video: chỉ những Post_ID có TypePost = 'Video' mới thêm được dữ liệu vào bảng Video
--20.0- TG_PostAuthor_insert --Không thể thêm vào bảng PostAuthor nếu Author_ID có StatusAuthor tương ứng là ‘False’
--20.1-- TG_PostAuthor_insert_update --Khi insert/update post_ID thì StatusPost tương ứng được chuyển thành 1
--21- TG_SavePost_insert_update --Số lượng các bài post được thêm vào bảng SavePost không quá 10 bài/account (với TypeAccount = VIP) và không cho thêm với TypeAccount = 'regular'
--22- TG_Comment_delete --Không xóa các Comment có StatusComment = ‘True’ (comment đang hiển thị trên trang)
--23- TG_Comment_insert_update --Chỉ chấp nhận các comment của các customer có TypeAcount = VIP và isBlocked khác "True", không thể thêm comment vào posts có statuspost = 'False' 
------------------------------------------------
--1- Không xóa các Position_ID có nhân viên.
CREATE TRIGGER TG_Position_delete
ON Position FOR DELETE
AS
BEGIN
	IF EXISTS ( SELECT * FROM deleted JOIN Users ON deleted.Position_ID = Users.Position_ID)
		BEGIN
			RAISERROR('Không thể xóa bộ phận đang có nhân viên', 16, 1);
			ROLLBACK TRAN;
		END;
END;
GO
--2- Khi nhân viên mới được thêm vào CSDL StatusEmployee luôn là 'NULL'
CREATE TRIGGER TG_Employee_insert
ON Employee FOR INSERT 
AS
BEGIN
	UPDATE Employee 
	SET StatusEmployee = NULL 
	WHERE Employee_ID IN (SELECT Employee_ID FROM inserted);
END;
GO
--3- Không xóa các Employee_ID có StatusEmployee = ‘True’ (nhân viên đang làm việc)
CREATE TRIGGER TG_Employee_delete
ON Employee FOR DELETE
AS
BEGIN
	IF EXISTS ( SELECT * FROM deleted WHERE StatusEmployee = 1)
		BEGIN
			RAISERROR('Không thể xóa nhân viên đang làm việc', 16, 1);
			ROLLBACK TRAN;
		END;
END;
GO
--4- Khi StatusEmployee = ‘False’ tự động update StatusAuthor = ‘False’ và toàn bộ các hàng của bảng Users có Employee_ID trùng khớp sẽ tự động update StatusUser  thành ’False’
CREATE TRIGGER TG_Employee_update
ON Employee FOR UPDATE
AS
BEGIN
	IF EXISTS (SELECT * FROM inserted i WHERE i.StatusEmployee = 0)
	BEGIN
		UPDATE Author SET StatusAuthor = 0 FROM author a INNER JOIN inserted i ON a.employee_ID = i.employee_ID WHERE i.StatusEmployee = 0;
		UPDATE Users SET StatusUser = 0 FROM Users u INNER JOIN inserted i ON u.employee_ID = i.employee_ID WHERE i.StatusEmployee = 0; 
	END;
END;
GO
--5- Check định dạng email, password > 6 ký tự trong bảng Customer
CREATE TRIGGER TG_Customer_insert_update
ON CUSTOMER
FOR INSERT, UPDATE
AS
BEGIN
	IF EXISTS (SELECT * FROM inserted WHERE Email not like '%_@__%.__%')
		BEGIN
			RAISERROR('Email không hợp lệ',16,1);
			ROLLBACK TRAN;
		END;
	IF EXISTS (SELECT * FROM inserted WHERE LEN(CusPassword) <6)
		BEGIN
			RAISERROR('độ dài Password phải >6 ký tự',16,1)
			ROLLBACK TRAN;
		END;
END;
GO
--6- Không xóa các Customer_ID có TypeAccount = ‘VIP’ (khách hàng đã trả phí)
CREATE TRIGGER TG_Customer_delete
ON Customer FOR DELETE
AS
BEGIN
	IF EXISTS ( SELECT * FROM deleted WHERE TypeAccount = 'VIP')
		BEGIN
			RAISERROR('Không thể xóa Khách hàng đang trả phí', 16, 1);
			ROLLBACK TRAN;
		END;
END;
GO
--7.0- TG_Posts_insert --Khi bài post được thêm vào bảng, statusPost = 'Null' 
CREATE TRIGGER TG_Posts_insert
ON Posts
FOR INSERT
AS
BEGIN
	--Update status posts là null 
	UPDATE Posts SET StatusPost = NULL
	WHERE Posts.Post_ID IN (SELECT DISTINCT Post_ID FROM inserted WHERE StatusPost = 1 OR StatusPost IS NULL)
END;
GO
--7.1- TG_Posts_insert_update --Khi insert & update Chỉ Employee có position = ‘Website Administrator’ và StatusUser = ‘True’ mới có thể được thêm vào bảng Posts ở cột Employee_ID 
-- Chặn update statuspost = 1 khi bài posts chưa có đủ các thông tin cần thiết.

CREATE TRIGGER TG_Posts_insert_update
ON Posts
FOR INSERT, UPDATE
AS
BEGIN
    -- Check Employee_ID hợp lệ
	IF EXISTS (SELECT 1 FROM Inserted i
		JOIN Employee e ON i.Employee_ID = e.Employee_ID
		JOIN Users u ON e.Employee_ID = u.Employee_ID
		JOIN Position pos ON u.Position_ID = pos.Position_ID
		WHERE e.StatusEmployee != 1 OR pos.Position != 'Website Administrator' OR u.StatusUser != 1)
		BEGIN
			RAISERROR ('Employee_ID không thỏa mãn', 16, 1)
			ROLLBACK TRAN
		END;

	IF UPDATE(StatusPost)
	BEGIN
		IF EXISTS (SELECT 1 FROM Inserted WHERE StatusPost = 1)
		BEGIN
			IF EXISTS (SELECT 1 FROM Inserted i WHERE StatusPost = 1 
				AND ( Employee_ID IS NULL 
					OR EXISTS (SELECT 1 FROM inserted i LEFT JOIN PostAuthor p ON i.Post_ID = p.Post_ID WHERE Author_ID IS NULL)
					OR (TypePost = 'Article' AND NOT EXISTS (SELECT 1 FROM Posts WHERE Post_ID = i.Post_ID AND LinkText IS NOT NULL))
					OR (TypePost = 'Video' AND NOT EXISTS (SELECT 1 FROM Video WHERE Post_ID = i.Post_ID AND LinkVideo IS NOT NULL))
					OR (TypePost = 'Audio' AND NOT EXISTS (SELECT 1 FROM Audio WHERE Post_ID = i.Post_ID AND LinkAudio IS NOT NULL))))
			BEGIN
				RAISERROR ('Employee_ID không thỏa mãn', 16, 1)
				ROLLBACK TRAN
			END;
		END;
	END;
END;
GO
--8-TG_Posts_delete --Không xóa dữ liệu các bảng Posts có status = ‘True’ (bài đăng đang hiển thị trên trang)
CREATE TRIGGER TG_Posts_delete
ON Posts FOR DELETE
AS
BEGIN
	IF EXISTS (SELECT * FROM deleted WHERE StatusPost = 1)
	BEGIN
		RAISERROR('Không thể xóa bài đăng đang hiển thị', 16, 1);
		ROLLBACK TRAN;
	END;
END;
GO
--9- TG_Author_update --Không thể Update Author với statusAuthor = 'true' khi statusEmployee = 'False'
CREATE TRIGGER TG_Author_update
ON Author FOR UPDATE
AS
BEGIN
	IF UPDATE (StatusAuthor)
		BEGIN
			IF EXISTS (SELECT * FROM inserted 
			JOIN Employee ON inserted.Employee_ID = Employee.Employee_ID 
			WHERE inserted.StatusAuthor =1 AND Employee.StatusEmployee = 0)
				BEGIN
					RAISERROR('Không thể update trạng thái của tác giả thành đang hoạt động cho nhân viên đã nghỉ việc', 16, 1);
					ROLLBACK TRAN;
				END;		
		END
END;
GO
--10- TG_Author_insert --Không thể thêm mới 1 Author khi StatusEmployee = 'False' or 'NULL'
CREATE TRIGGER TG_Author_insert
ON Author FOR INSERT 
AS
BEGIN
	IF EXISTS (SELECT * FROM inserted JOIN Employee ON inserted.Employee_ID = Employee.Employee_ID WHERE StatusEmployee = 0)
		BEGIN
			RAISERROR('Không thể thêm thông tin tác giả cho nhân viên đã nghỉ việc', 16, 1);
			ROLLBACK TRAN;
		END;
END;
GO
--11- TG_Author_delete --Không xóa các Author có bài Posts hoặc có StatusAuthor = ‘True’ (tác giả có bài đăng trên trang hoặc vẫn đang hoạt động)
CREATE TRIGGER TG_Author_delete
ON Author FOR DELETE
AS
BEGIN
	IF EXISTS (SELECT * FROM deleted WHERE StatusAuthor = 1)
		BEGIN
			RAISERROR('Không thể xóa tác giả đang hoạt động', 16, 1);
			ROLLBACK TRAN;
		END;
	IF 0 < (SELECT COUNT(*) FROM deleted JOIN PostAuthor ON deleted.Author_ID = PostAuthor.Author_ID)
		BEGIN
			RAISERROR('Không thể xóa tác giả có bài đăng', 16, 1);
			ROLLBACK TRAN;
		END;
END;
GO
--12.0- TG_Users_insert_update --Trong bảng Users trường time_end phải là ‘null’ hoặc có giá trị lớn hơn time_start
--12.1- TG_Users_insert_update --Bảng Users không có các dòng dữ liệu trùng lặp vô lý (1 employee có 2 user tại cùng 1 vị trí cùng đang hoạt động)

CREATE TRIGGER TG_Users_insert_update
ON Users FOR INSERT, UPDATE
AS
BEGIN 
	IF EXISTS (SELECT * FROM inserted WHERE Time_end IS NOT NULL AND Time_start >= Time_end)
		BEGIN
			RAISERROR('Time_end không thỏa mãn', 16, 1);
			ROLLBACK TRAN;
		END;
	IF EXISTS (SELECT * FROM inserted i JOIN Users u ON i.Employee_ID = u.Employee_ID AND i.Position_ID = u.Position_ID AND i.StatusUser = u.StatusUser WHERE i.UserName != u.UserName)
		BEGIN
			RAISERROR('Không thể thêm mới/update statusUser do nhân viên có UserName khác tại cùng vị trí đang hoạt động', 16, 1);
			ROLLBACK TRAN;
		END;
END;
GO
--13- TG_Users_insert --Không thể thêm user cho nhân viên đã nghỉ việc, nếu dữ liệu thêm vào có statusUser = 1 và statusEmployee = 'NULL' thì update statusEmployee = 1
CREATE TRIGGER TG_Users_insert
ON Users
FOR INSERT 
AS
BEGIN
    -- Check nhân viên đã nghỉ việc
	IF EXISTS (SELECT * FROM inserted 
	JOIN Employee ON inserted.Employee_ID = Employee.Employee_ID 
	WHERE inserted.StatusUser = 1 AND Employee.StatusEmployee = 0)
	BEGIN
		RAISERROR('Không thể thêm thông tin user cho nhân viên đã nghỉ việc', 16, 1);
		ROLLBACK TRAN;
		RETURN;
	END;

	-- Update trạng thái nhân viên mới từ NULL sang đang làm việc
	UPDATE e
	SET e.StatusEmployee = 1
	FROM Employee e
	INNER JOIN inserted i ON e.Employee_ID = i.Employee_ID
	WHERE i.StatusUser = 1 AND e.StatusEmployee IS NULL;
END;
GO
--14- TG_Users_update --Không cho phép update Employee_ID và Position_ID trong bảng Users và không thể update trạng thái của user thành đang hoạt động với nhân viên đã nghỉ việc
CREATE TRIGGER TG_Users_update
ON Users FOR UPDATE
AS
BEGIN
	IF UPDATE(Employee_ID) OR UPDATE (Position_ID)
		BEGIN
			RAISERROR('Không thể update Employee_ID và Position_ID', 16, 1);
			ROLLBACK TRAN;
		END;
	IF UPDATE (StatusUser)
		BEGIN
			IF EXISTS (SELECT * FROM inserted 
			JOIN Employee ON inserted.Employee_ID = Employee.Employee_ID
			WHERE inserted.StatusUser = 1 AND Employee.StatusEmployee = 0)
				BEGIN
					RAISERROR('Không thể update trạng thái của user thành đang hoạt động với nhân viên đã nghỉ việc', 16, 1);
					ROLLBACK TRAN;

				END
		END;
END;
GO
--15- TG_Users_update_delete --Khi tất cả StatusUser (bảng Users) của một employee_ID là ‘False’ thì tự động update StatusEmployee (bảng Employee) thành ‘False’
CREATE TRIGGER TG_Users_update_delete
ON Users FOR UPDATE, DELETE
AS
BEGIN
	-- Cập nhật trạng thái "StatusEmployee" trong bảng "Employee" dựa trên dữ liệu từ bảng "Users"
	-- Cập nhật các nhân viên có StatusUser = 0 nhưng không có bất kỳ user nào có StatusUser = 1
	UPDATE Employee
	SET StatusEmployee = 0
	WHERE Employee_ID IN (
		SELECT DISTINCT e.Employee_ID
		FROM Employee e
		LEFT JOIN Users u ON e.Employee_ID = u.Employee_ID
		WHERE u.StatusUser = 0 AND u.Employee_ID IS NULL);

	-- Cập nhật các nhân viên có StatusUser = 0 và StatusUser = 1 cùng là NULL
	UPDATE Employee
	SET StatusEmployee = 0
	WHERE Employee_ID IN (
		SELECT DISTINCT e.Employee_ID
		FROM Employee e
		INNER JOIN Users u ON e.Employee_ID = u.Employee_ID
		WHERE u.StatusUser IS NULL AND e.StatusEmployee = 1);

	-- In ra thông báo về các nhân viên đã được cập nhật thành nghỉ việc
	DECLARE @EmployeeID INT;
	DECLARE CS_User_Employee CURSOR FOR SELECT DISTINCT Employee_ID FROM deleted;
	OPEN CS_User_Employee;
	FETCH NEXT FROM CS_User_Employee INTO @EmployeeID;
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF NOT EXISTS (SELECT * FROM Users WHERE Employee_ID = @EmployeeID AND StatusUser = 1)
		BEGIN
			PRINT 'Nhân viên mã số ' + CAST(@EmployeeID AS NVARCHAR(10)) + ' đã được update thành nghỉ việc';
		END
		FETCH NEXT FROM CS_User_Employee INTO @EmployeeID;
	END
	CLOSE CS_User_Employee;
	DEALLOCATE CS_User_Employee;
END;
GO

--16- TG_Transactions_update --Không cho update dữ liệu trong bảng Transactions
CREATE TRIGGER TG_Transactions_update
ON Transactions FOR UPDATE
AS
BEGIN
	RAISERROR('Không thể update dữ liệu trong bảng này', 16, 1);
	ROLLBACK TRAN;
END;
GO

--17- TG_Transactions_insert --Tự động update bảng Customer các trường TypeAccount và AccBalance khi có giao dịch được hoàn thành trong bảng Transactions.
-- Giả định mức phí/năm cố định 5$/year
CREATE TRIGGER TG_Transactions_insert
ON Transactions FOR INSERT
AS
BEGIN
	DECLARE @CustomerID INT;
	DECLARE @amount DECIMAl(10,2);
	DECLARE CS_Transactions CURSOR FOR SELECT Customer_ID, SUM(Amount) FROM inserted WHERE StatusTrans = 1 GROUP BY Customer_ID;
	OPEN CS_Transactions;
	FETCH NEXT FROM CS_Transactions INTO @CustomerID, @amount
	WHILE @@FETCH_STATUS = 0
		BEGIN
			IF @amount >= 5
				BEGIN
					UPDATE Customer SET TypeAccount = 'VIP', AccBalance = @amount - 5 WHERE Customer_ID = @CustomerID
					Print 'Customer được update TypeAccount và AccBalance thành công'
				END;
			FETCH NEXT FROM CS_Transactions INTO @CustomerID, @amount
		END
	CLOSE CS_Transactions;
	DEALLOCATE CS_Transactions;
END;
GO
--18- TG_Audio_insert_update --Ràng buộc giữa Posts và Audio: chỉ những Post_ID có TypePost = 'Podcast' mới thêm được dữ liệu vào bảng Audio
CREATE TRIGGER TG_Audio_insert_update
ON Audio FOR INSERT, UPDATE
AS
BEGIN
	If EXISTS (SELECT Posts.TypePost FROM Inserted JOIN Posts ON Inserted.Post_ID = Posts.Post_ID WHERE TypePost != 'Podcast')
		BEGIN
			RAISERROR('TypePost không thỏa mãn', 16, 1);
			ROLLBACK TRAN;
		END
END;
GO
--19- TG_Video_insert_update --Ràng buộc giữa Posts và Video: chỉ những Post_ID có TypePost = 'Video' mới thêm được dữ liệu vào bảng Video
CREATE TRIGGER TG_Video_insert_update
ON Video FOR INSERT, UPDATE
AS
BEGIN
	If EXISTS (SELECT Posts.TypePost FROM Inserted JOIN Posts ON Inserted.Post_ID = Posts.Post_ID WHERE TypePost != 'Video')
		BEGIN
			RAISERROR('TypePost không thỏa mãn', 16, 1);
			ROLLBACK TRAN;
		END
END;
GO
--20.0- TG_PostAuthor_insert --Không thể thêm vào bảng PostAuthor nếu Author_ID có StatusAuthor tương ứng là ‘False’
CREATE TRIGGER TG_PostAuthor_insert
ON PostAuthor FOR INSERT 
AS
BEGIN
	IF EXISTS (SELECT * FROM inserted JOIN Author ON inserted.Author_ID = Author.Author_ID WHERE StatusAuthor = 0)
		BEGIN
			RAISERROR('Author_ID không thỏa mãn', 16, 1);
			ROLLBACK TRAN;
		END
END;
GO
--20.1-- TG_PostAuthor_insert_update --Khi insert/update post_ID thì StatusPost tương ứng được chuyển thành 1
CREATE TRIGGER TG_PostAuthor_insert_update
ON PostAuthor FOR INSERT, UPDATE
AS
BEGIN
	UPDATE Posts SET StatusPost = 1 WHERE StatusPost IS NULL AND Post_ID IN (SELECT Post_ID FROM inserted)
END;
GO
--21- TG_SavePost_insert_update --Số lượng các bài post được thêm vào bảng SavePost không quá 10 bài/account (với TypeAccount = VIP) và không cho thêm với TypeAccount = 'regular'
CREATE TRIGGER TG_SavePost_insert_update
ON SavePost FOR INSERT, UPDATE
AS
BEGIN
	IF EXISTS (SELECT * FROM inserted JOIN Customer ON inserted.Customer_ID = Customer.Customer_ID WHERE TypeAccount != 'VIP')
		BEGIN
			RAISERROR('Loại Account không thể lưu bài', 16, 1);
			ROLLBACK TRAN;
		END;
	ELSE
		BEGIN
			DECLARE @CustomeID INT;
			DECLARE CS_SavePost CURSOR FOR SELECT Customer_ID FROM inserted;
			OPEN CS_SavePost;
			FETCH NEXT FROM CS_SavePost INTO @CustomeID;
			WHILE @@FETCH_STATUS = 0
				BEGIN
					IF 10 <= (SELECT Count(*) FROM SavePost WHERE Customer_ID = @CustomeID)
						BEGIN
							RAISERROR('Quá số lượng bài cho phép', 16, 1);
							ROLLBACK TRAN; 
						END;
					FETCH NEXT FROM CS_SavePost INTO @CustomeID;
				END
			CLOSE CS_SavePost;
			DEALLOCATE CS_SavePost;
		END
END;
GO
--22- TG_Comment_delete --Không xóa các Comment có StatusComment = ‘True’ (comment đang hiển thị trên trang)
CREATE TRIGGER TG_Comment_delete
ON Comment FOR DELETE
AS
BEGIN
	IF EXISTS ( SELECT * FROM deleted WHERE StatusComment = 1)
		BEGIN
			RAISERROR('Không thể xóa comment đang được hiển thị', 16, 1);
			ROLLBACK TRAN;
		END;
END;
GO
--23- TG_Comment_insert_update --Chỉ chấp nhận các comment của các customer có TypeAcount = VIP và isBlocked khác "True", không thể thêm comment vào posts có statuspost = 'False' 
CREATE TRIGGER TG_Comment_insert_update
ON Comment FOR INSERT, UPDATE
AS
BEGIN
	IF EXISTS (SELECT * FROM inserted 
	JOIN Customer ON inserted.Customer_ID = Customer.Customer_ID
	JOIN Posts ON inserted.Post_ID = Posts.Post_ID
	WHERE Customer.TypeAccount != 'VIP' OR Customer.isBlocked = 1 OR Posts.StatusPost = 0)
		BEGIN
			RAISERROR('Không thể thêm Comment', 16, 1);
			ROLLBACK TRAN;
		END;
END;
GO
SELECT * FROM sys.triggers;
---------------------------------------------------------------
/* PHẦN 3: Tạo stored procedure hỗ trợ nhập dữ liệu
-- Tạo Chỉ mục
-- Ít nhất 1 stored procedure
-- Ít nhất 1 transaction (có tối thiểu 2 công việc cần thực thi).*/
--1. SP_Employee_Users -- Insert vào bảng Employee + Users
--2. SP_Author_SocialMedia --Insert vào bảng Author + SocialMedia
--3. SP_Posts_PostAuthor --Insert vào bảng Posts + PostAuthor 
--4. SP_Posts_Video_PostAuthor --Insert vào bảng Posts + Video + PostAuthor 
--5. SP_Customer_Subscribe --Insert vào bảng Customer + Subscribe
--------------------------------------------------------------
--Tạo chỉ mục: Giúp truy vấn nhanh các bài viết theo thời gian, mới nhất - cũ nhất
CREATE INDEX Idx_Posts
ON Posts (TimePost);
GO

--1. Insert vào bảng Employee + Users
CREATE PROCEDURE SP_Employee_Users
	@NameEmployee VARCHAR(100),
	@UserName VARCHAR(20),
	@Position_ID INT,
	@Time_start DATE,
	@Time_end DATE
AS
BEGIN TRANSACTION;
BEGIN TRY
	DECLARE @Employee_ID INT; 
	INSERT INTO Employee (NameEmployee)
	VALUES (@NameEmployee);
	SET @Employee_ID = SCOPE_IDENTITY(); 
	INSERT INTO Users (UserName, Employee_ID, Position_ID, Time_start, Time_end)
	VALUES (@UserName, @Employee_ID, @Position_ID, @Time_start, @Time_end);
	COMMIT TRANSACTION;
END TRY
BEGIN CATCH
	RAISERROR('Thêm dữ liệu không thành công',16,1)
    ROLLBACK TRANSACTION;
END CATCH;
GO
--2. Insert vào bảng Author + SocialMedia
CREATE PROCEDURE SP_Author_SocialMedia
	@Employee_ID INT,
	@LinkAvatar NVARCHAR(255),
	@NameAuthor VARCHAR(100),
	@IntroAuthor VARCHAR(255),
	@TypeSocial VARCHAR(20),
	@Link VARCHAR(255)
AS
BEGIN TRY
	BEGIN TRANSACTION;
	DECLARE @Author_ID INT;
	INSERT INTO Author (Employee_ID, LinkAvatar, NameAuthor, IntroAuthor)
	VALUES (@Employee_ID, @LinkAvatar, @NameAuthor, @IntroAuthor);
	SET @Author_ID = SCOPE_IDENTITY(); 
	INSERT INTO SocialMedia (Author_ID, TypeSocial, Link)
	VALUES (@Author_ID, @TypeSocial, @Link);
	COMMIT TRANSACTION;
END TRY
BEGIN CATCH
	RAISERROR('Thêm dữ liệu không thành công',16,1)
    ROLLBACK TRANSACTION;
END CATCH;
GO
--3. Insert vào bảng Posts + PostAuthor
CREATE PROCEDURE SP_Posts_PostAuthor
	@Employee_ID INT,
	@Filter_ID INT,
	@TimePost DATETIME,
	@Title VARCHAR(255),
	@TypePost VARCHAR(10),
	@LinkText VARCHAR(255),
	@Topic VARCHAR(50),
	@Author_ID INT,
	@TypeAuthor VARCHAR(50)
AS
BEGIN TRY
	BEGIN TRANSACTION;
	DECLARE @Post_ID INT;
	INSERT INTO Posts (Employee_ID, Filter_ID, TimePost, Title, TypePost, LinkText, Topic)
	VALUES (@Employee_ID, @Filter_ID, @TimePost, @Title, @TypePost, @LinkText, @Topic);
	SET @Post_ID = SCOPE_IDENTITY();
	INSERT INTO PostAuthor (Post_ID, Author_ID, TypeAuthor)
	VALUES (@Post_ID, @Author_ID, @TypeAuthor);
	COMMIT TRANSACTION;
END TRY
BEGIN CATCH
	RAISERROR('Thêm dữ liệu không thành công',16,1)
    ROLLBACK TRANSACTION;
END CATCH;
GO
--4. Insert vào bảng Posts + Video + PostAuthor 
CREATE PROCEDURE SP_Posts_Video_PostAuthor
	@Employee_ID INT,
	@Filter_ID INT,
	@TimePost DATETIME,
	@Title VARCHAR(255),
	@TypePost VARCHAR(10),
	@LinkText VARCHAR(255),
	@Topic VARCHAR(50),
	@LinkVideo VARCHAR(255),
	@Transcript VARCHAR(255),
	@IntroVideo VARCHAR(255),
	@Author_ID INT,
	@TypeAuthor VARCHAR(50)
AS
BEGIN TRY
	BEGIN TRANSACTION;
	DECLARE @Post_ID INT;
	INSERT INTO Posts (Employee_ID, Filter_ID, TimePost, Title, TypePost, LinkText, Topic)
	VALUES (@Employee_ID, @Filter_ID, @TimePost, @Title, @TypePost, @LinkText, @Topic);
	SET @Post_ID = SCOPE_IDENTITY();
	INSERT INTO Video (Post_ID, LinkVideo, IntroVideo, Transcript)
	VALUES (@Post_ID, @LinkVideo, @IntroVideo, @Transcript);
	INSERT INTO PostAuthor (Post_ID, Author_ID, TypeAuthor)
	VALUES (@Post_ID, @Author_ID, @TypeAuthor);
	COMMIT TRANSACTION;
END TRY
BEGIN CATCH
	RAISERROR('Thêm dữ liệu không thành công',16,1)
    ROLLBACK TRANSACTION;
END CATCH;
GO
--5. Insert vào bảng Customer + Subscribe
CREATE PROCEDURE SP_Customer_Subscribe
	@Email NVARCHAR(100),
	@CusPassword NVARCHAR(100),
	@TimeRegis DATETIME,
	@Newsletter_ID INT
AS
BEGIN TRY
	BEGIN TRANSACTION;
	DECLARE @Customer_ID INT;
	INSERT INTO Customer (Email, CusPassword, TimeRegis)
	VALUES (@Email, @CusPassword, @TimeRegis);
	SET @Customer_ID = SCOPE_IDENTITY();
	INSERT INTO Subscribe (Customer_ID, Newsletter_ID)
	VALUES (@Customer_ID, @Newsletter_ID);
	COMMIT TRANSACTION;
END TRY
BEGIN CATCH
	RAISERROR('Thêm dữ liệu không thành công',16,1)
    ROLLBACK TRANSACTION;
END CATCH;
GO
--------------------------------------------------------
--PHẦN 4: THÊM DỮ LIỆU CƠ BẢN VÀO DATABASE
-- Tối thiểu mỗi bảng 10 dòng dữ liệu 
-- Dữ liệu được thêm theo trình tự tạo bảng 
-- Dữ liệu thực tế lấy theo các bài đăng trên trang web, bổ sung thêm các dữ kiện còn thiếu


-- Insert vào bảng Position
INSERT INTO Position (Position)
VALUES
	('Contributor'),
	('Editor'),
	('Global Editorial Director'),
	('Host'),
	('Human Resources'),
	('Ideas Contributor'),
	('Marketing'),
	('News Editor'),
	('Product Manager'),
	('Product Writer'),
	('Reviewer'),
	('Reviews Editor'),
	('Senior Associate Reviews Editor'),
	('Senior Editor'),
	('Senior Writer'),
	('Service Writter'),
	('Staff Writer'),
	('Website Administrator'),
	('Writer'),
	('Writer and Reviewer');
GO
-- Insert vào bảng Employee
INSERT INTO Employee (NameEmployee)
VALUES
    ('Lauren Goode'),
    ('Gideon Lichfield'),
    ('Ramin Skibba'),
    ('Jason Parham'),
    ('James Temperton'),
    ('Kim Zetter'),
    ('John Semley'),
    ('Medea Giordano'),
    ('Peter Guest'),
    ('Adrienne So'),
    ('Nena Farrell'),
    ('Rowan Moore Gerety'),
    ('Brenda Stolyar'),
    ('David Barr Kirtley'),
    ('Michael Calore'),
    ('Katherine Alejandra Cross'),
    ('Will Knight'),
	('Urbano Hidalgo'),
	('Michiaki Matsushima'),
	('Boone Ashworth'),
	('Sarah Gundle'),
	('Reece Rogers');
GO
-- Insert vào bảng Filters
INSERT INTO Filters (Applications, EndUser, Sector, SourceData, Technology)
VALUES
    ('Autonomous driving', 'Big company', 'Agriculture', 'Biometric', 'Chips'),
    ('Blockchain', 'Consumer', 'Automotive', 'Clickstream', 'Machine learning'),
    ('Cryptocurrency', 'Government', 'Aviation', 'Geolocation', 'Machine vision'),
    ('Cloud computing', 'Research', 'Consumer services', 'Images', 'Natural language processing'),
    ('Content moderation', 'Small company', 'Defense', 'Sensors', 'Neural Network'),
    ('Deepfakes', 'Startup', 'Ecommerce', 'Speech', 'Photonics'),
    ('Ethics', 'Big company', 'Education', 'Synthetic data', 'Robotics'),
    ('Face recognition', 'Consumer', 'Energy', 'Text', 'Chips'),
    ('Games', 'Government', 'Entertainment', 'Transactions', 'Machine learning'),
    ('Hardware', 'Research', 'Finance', 'Video', 'Machine vision'),
    ('Human-computer interaction', 'Small company', 'Games', 'Biometric', 'Natural language processing'),
    ('Identifying Fabrications', 'Startup', 'Health care', 'Clickstream', 'Neural Network'),
    ('Logistics', 'Big company', 'IT', 'Geolocation', 'Photonics'),
    ('Personal assistant', 'Consumer', 'Manufacturing', 'Images', 'Robotics'),
    ('Personal finance', 'Government', 'Public safety', 'Speech', 'Chips'),
    ('Personal services', 'Research', 'Publishing', 'Synthetic data', 'Machine learning'),
    ('Prediction', 'Small company', 'Research', 'Text', 'Machine vision'),
    ('Recommendation algorithm', 'Startup', 'Semiconductors', 'Transactions', 'Natural language processing'),
    ('Regulation', 'Big company', 'social media', 'Video', 'Neural Network'),
    ('Robotics', 'Consumer', 'Video', 'Biometric', 'Photonics');
GO
-- Insert vào bảng Customer
INSERT INTO Customer (Email, CusPassword, TimeRegis)
VALUES
    ('customer1@example.com', 'password1', '2023-05-31 08:00:00'),
    ('customer2@example.com', 'password2', '2023-05-30 09:00:00'),
    ('customer3@example.com', 'password3', '2023-06-01 10:00:00'),
    ('customer4@example.com', 'password4', '2023-05-29 11:00:00'),
    ('customer5@example.com', 'password5', '2023-05-28 12:00:00'),
    ('customer6@example.com', 'password6', '2023-05-27 13:00:00'),
    ('customer7@example.com', 'password7', '2023-06-02 14:00:00'),
    ('customer8@example.com', 'password8', '2023-06-01 15:00:00'),
    ('customer9@example.com', 'password9', '2023-06-04 16:00:00'),
    ('customer10@example.com', 'password10', '2023-06-03 17:00:00'),
    ('customer11@example.com', 'password11', '2023-06-02 18:00:00'),
    ('customer12@example.com', 'password12', '2023-06-01 19:00:00'),
    ('customer13@example.com', 'password13', '2023-05-31 20:00:00'),
    ('customer14@example.com', 'password14', '2023-05-30 21:00:00'),
    ('customer15@example.com', 'password15', '2023-05-29 22:00:00'),
    ('customer16@example.com', 'password16', '2023-05-28 23:00:00'),
    ('customer17@example.com', 'password17', '2023-05-27 00:00:00'),
    ('customer18@example.com', 'password18', '2023-06-01 01:00:00'),
    ('customer19@example.com', 'password19', '2023-05-30 02:00:00'),
    ('customer20@example.com', 'password20', '2023-05-29 03:00:00');
GO

-- Insert vào bảng Newsletters
INSERT INTO Newsletters (TopicLetter, Frequency)
VALUES
    ('WIRED daily', 'every day'),
    ('Classics', 'every Saturday'),
    ('WIRED Science', 'weekly'),
    ('Deals', 'every Sunday'),
    ('Longreads', 'every Sunday'),
    ('Fast Forward', 'every Thursday'),
    ('Games', 'weekly'),
    ('Gadget Lap', 'a twice-weekly'),
    ('WIRED Weekly', 'every Thursday'),
    ('Podcasts: News from Tomorrow', 'weekly'),
    ('The Rise and Fall of AlphaBay', 'weekly'),
    ('Plaintext', 'every Friday');
GO
-----------------------
--CHECK INSERT 1
SELECT * FROM Position;
SELECT * FROM Employee;
SELECT * FROM Filters;
SELECT * FROM Customer
SELECT * FROM Newsletters;

-- Insert vào bảng Users
INSERT INTO Users (UserName, Employee_ID, Position_ID, Time_start)
VALUES
    ('Lauren1', 1, 15, '2010-01-01'),
    ('Gideon1', 2, 2, '2010-02-01'),
    ('Ramin1', 3, 17, '2010-03-01'),
    ('Jason1', 4, 15, '2010-04-01'),
    ('James1', 5, 8, '2010-05-01'),
    ('Kim1', 6, 17, '2010-06-01'),
    ('John1', 7, 1, '2010-07-01'),
    ('Medea1', 8, 20, '2010-08-01'),
    ('Peter1', 9, 2, '2010-09-01'),
    ('Adrienne1', 10, 13, '2010-10-01'),
    ('Nena1', 11, 20, '2010-11-01'),
    ('Rowan1', 12, 1, '2010-12-01'),
    ('Brenda1', 13, 10, '2011-01-01'),
    ('David1', 14, 4, '2011-02-01'),
    ('Michael1', 15, 14, '2011-03-01'),
    ('Katherine1', 16, 6, '2011-04-01'),
    ('Will1', 17, 15, '2011-05-01'),
    ('Urbano1', 18, 18, '2011-06-01'),
    ('Michiaki1', 19, 18, '2011-07-01'),
    ('Boone1', 20, 17, '2011-08-01'),
    ('Sarah1', 21, 1, '2011-09-01'),
    ('Reece1', 22, 16, '2011-10-01');
GO

-- Insert vào bảng Posts
INSERT INTO Posts (Employee_ID, Filter_ID, TimePost, Title, TypePost, LinkText, Topic)
VALUES
    (18, 2, '2023-07-24 20:14:00', 'Social Media Has Run Out of Fresh Ideas', 'Article', 'https://www.wired.com/story/social-media-has-run-out-of-fresh-ideas/', 'GEAR'),
    (19, 3, '2023-07-12 07:00:00', 'To Understand the Human Brain, Give an Octopus MDMA', 'Podcast', 'https://www.wired.com/story/have-a-nice-future-podcast-13/', 'SCIENCE'),
    (18, 1, '2022-11-21 07:00:00', 'This Copyright Lawsuit Could Shape the Future of Generative AI', 'Article', 'https://www.wired.com/story/this-copyright-lawsuit-could-shape-the-future-of-generative-ai/', 'BUSINESS'),
    (18, 1, '2022-11-05 09:00:00', 'Google Expands Flood and Wildfire Tracking to More Countries', 'Article', 'https://www.wired.com/story/google-ai-wildfire-flood-tracking/', 'GEAR'),
    (18, 2, '2023-07-22 07:00:00', 'Please Stop Asking Chatbots for Love Advice', 'Article', 'https://www.wired.com/story/please-stop-asking-chatbots-for-love-advice/', 'CULTURE'),
    (19, 20, '2023-05-19 07:00:00', 'I Finally Bought a ChatGPT Plus Subscription—and It’s Worth It', 'Article', 'https://www.wired.com/story/chatgpt-plus-web-browsing-openai/', 'GEAR'),
    (18, 4, '2023-07-17 00:00:00', 'Atomic Expert Explains "Oppenheimer" Bomb Scenes', 'Video', NULL, 'SCIENCE'),
    (18, 5, '2023-06-19 00:00:00', 'Pro Interpreters vs. AI Challenge: Who Translates Faster and Better?', 'Video', NULL, 'SCIENCE'),
    (18, 8, '2023-07-06 00:00:00', 'Why The Average Human Could not Drive An F1 Car', 'Video', NULL, 'IDEAS'),
    (19, 9, '2023-03-17 00:00:00', 'A.I. Tries 20 Jobs', 'Video', NULL, 'SCIENCE'),
    (19, 11, '2023-02-28 00:00:00', 'All the Ways a Cold Plunge Affects the Body', 'Video', NULL, 'SCIENCE'),
    (18, 7, '2022-07-06 00:00:00', 'How Public Cameras Recognize and Track You', 'Video', NULL, 'SECURITY'),
    (18, 6, '2021-12-16 00:00:00', 'Are We Living In A Simulation?', 'Video', NULL, 'CULTURE'),
    (19, 5, '2021-10-01 00:00:00', 'How Disney Designed a Robotic Spider-Man', 'Video', NULL, 'SCIENCE'),
    (18, 1, '2021-09-07 00:00:00', 'Why Vegan Cheese Doesn not Melt', 'Video', NULL, 'GEAR'),
    (18, 2, '2021-09-03 00:00:00', 'Why You’ll Fail the Milk Crate Challenge', 'Video', NULL, 'GEAR'),
    (19, 5, '2023-06-29 08:00:00', 'Your Clothes Are Making You Sick', 'Podcast', NULL, 'GEAR'),
    (19, 7, '2023-06-14 07:00:00', 'Is a Parking-Free Future Possible?', 'Podcast', NULL, 'BUSINESS'),
	(18, 13, '2023-07-13 06:00:00','The Dark Secrets Buried at Red Cloud Boarding School', 'Article', 'https://www.wired.com/story/marsha-small-red-cloud-boarding-school/', 'BACKCHANNEL');
GO
-- Insert vào bảng Author
INSERT INTO Author (Employee_ID, LinkAvatar, NameAuthor, IntroAuthor)
VALUES
    (1, 'https://media.wired.com/photos/635b058da8552c961517a879/1:1/w_320,c_limit/Lauren%20Goode.jpg', 'Lauren Goode', 'https://www.wired.com/author/lauren-goode/'),
    (2, 'https://media.wired.com/photos/635b2aa3721498963daf9ab0/1:1/w_320,c_limit/Gideon%20Lichfield.jpg', 'Gideon Lichfield', 'https://www.wired.com/author/gideon-lichfield/'),
    (3, 'https://media.wired.com/photos/635b2ec4721498963daf9ab2/1:1/w_320,c_limit/Ramin%20Skibba.jpg', 'Ramin Skibba', 'https://www.wired.com/author/ramin-skibba/'),
    (4, NULL, 'Jason Parham', 'https://www.wired.com/author/jason-parham/'),
    (5, 'https://media.wired.com/photos/635b05772315f22f918339dd/1:1/w_320,c_limit/James%20Temperton.jpg', 'James Temperton', 'https://www.wired.co.uk/profile/james-temperton'),
    (6, NULL, 'Kim Zetter', 'https://www.wired.com/author/kim-zetter/'),
    (7, NULL, 'John Semley', 'https://www.wired.com/author/john-semley/'),
    (8, 'https://media.wired.com/photos/635b0599721498963daf9aa6/1:1/w_320,c_limit/Medea%20Giordano.jpg', 'Medea Giordano', 'https://www.wired.com/author/medea-giordano/'),
    (9, NULL, 'Peter Guest', 'https://www.wired.co.uk/profile/peter-guest'),
    (10, 'https://media.wired.com/photos/635b054de53b9bdcb463c643/1:1/w_320,c_limit/Adrienne%20So.jpg', 'Adrienne So', 'https://www.wired.com/author/adrienne-so/'),
    (11, NULL, 'Nena Farrell', 'https://www.wired.com/author/nena-farrell/'),
    (12, NULL, 'Rowan Moore Gerety', 'https://www.wired.com/author/rowan-moore-gerety/'),
    (13, 'https://media.wired.com/photos/635b055da398fb738c4b9241/1:1/w_320,c_limit/Brenda%20Stolyar.jpg', 'Brenda Stolyar', 'https://www.wired.com/author/brenda-stolyar/'),
    (14, 'http://davidbarrkirtley.com/wp-content/uploads/2018/08/27173269_10210501895848441_2554616061892235470_o-768x960.jpg', 'David Barr Kirtley', 'https://www.wired.com/author/david-barr-kirtley/'),
    (15, 'https://media.wired.com/photos/635b059e3d7842cc349a220e/1:1/w_320,c_limit/Michael%20Calore.jpg', 'Michael Calore', 'https://www.wired.com/author/michael-calore/'),
    (16, 'https://media.wired.com/photos/635b0584a398fb738c4b924b/1:1/w_320,c_limit/Katherine%20Cross.jpg', 'Katherine Alejandra Cross', 'https://www.wired.com/author/katherine-alejandra-cross/'),
    (17, 'https://media.wired.com/photos/635b05bc0c761e833be17fee/1:1/w_320,c_limit/Will%20Knight.jpg', 'Will Knight', 'https://www.wired.com/author/will-knight/'),
    (20, 'https://media.wired.com/photos/635b055c2315f22f918339d1/1:1/w_320,c_limit/Boone%20Ashworth.jpg', 'Boone Ashworth', 'https://www.wired.com/author/boone-ashworth/'),
    (21, NULL, 'Sarah Gundle', 'https://www.wired.com/author/sarah-gundle/'),
    (22, 'https://media.wired.com/photos/635b05abbaca2e722bfbc6f4/1:1/w_320,c_limit/Reece%20Rogers.jpg', 'Reece Rogers', 'https://www.wired.com/author/reece-rogers/');
GO
-- Insert vào bảng Subscribe
INSERT INTO Subscribe (Customer_ID, Newsletter_ID)
VALUES
    (1, 1),
    (2, 4),
    (3, 7),
    (4, 12),
    (5, 8),
    (6, 3),
    (7, 5),
    (8, 2),
    (9, 6),
    (10, 9),
    (11, 10),
    (12, 11),
    (13, 1),
    (15, 3),
    (16, 4),
    (17, 5),
    (19, 7);
GO
-- Insert vào bảng Transactions
INSERT INTO Transactions (Customer_ID, TimeTrans, Amount, StatusTrans)
VALUES
    (3, '2023-06-01 10:30:00', 7.50, 1),
    (8, '2023-06-02 15:45:00',  5.00, 1),
    (15, '2023-06-02 09:15:00',  5.00, 0),
    (5, '2023-06-03 12:20:00',  5.00, 1),
    (13, '2023-06-04 17:00:00', 5.00, 1),
    (18, '2023-06-05 14:10:00', 8.20, 1),
    (12, '2023-06-06 08:00:00',  5.00, 1),
    (1, '2023-06-07 11:30:00', 5.60, 1),
    (4, '2023-06-08 13:45:00', 7.85, 1),
    (9, '2023-06-09 16:20:00',  5.00, 1),
    (20, '2023-06-10 10:15:00',  5.00, 1);
GO

SELECT * FROM Users;
SELECT * FROM Posts;
SELECT * FROM Author;
SELECT * FROM Subscribe;
SELECT * FROM Transactions;

-- Insert vào bảng Images
INSERT INTO Images (Post_ID, LinkImage, Photographer, Note)
VALUES
    (1, 'https://www.zilliondesigns.com/blog/wp-content/uploads/PayPal-sues-Pandora.png', 'JACEK KITA', 'GETTY IMAGES'),
    (2, 'https://media.wired.com/photos/64ad8d05f2de86183cf5b601/master/w_1920,c_limit/HANF-gul%20dolen.jpg', 'WIRED STAFF', 'COURTESY OF GUL DOLEN'),
    (3, 'https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcQGL17ZBush2WOB6iiUxv7wq8ptyp2h59CGLsrOTfyHg6qi53QL', 'JACQUI VANLIEW', 'GETTY IMAGES'),
    (4, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQh-Q9tFXs8j76PqGryGa0FO8sLxGl7_204ep92OZdK6wtSp-Mx', 'MATEUS MORBECK', 'GETTY IMAGES'),
    (5, 'https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcR6A4BbBbyJClWg4y5dByl09FA1VWoh5BhWWHTWqa0U8ZcfyRO_', 'SOMPONG_TOM', 'GETTY IMAGES'),
    (6, 'https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcSAhYAlouwozH4LLCsSUh2iP4rOIca5l7NCsY-WZ6mZzje1s19c', 'ANDRIY ONUFRIYENKO', 'GETTY IMAGES'),
    (17, 'https://pbs.twimg.com/card_img/1682003971391758337/9fVtgfKd?format=jpg&name=900x900', 'ALFIAN WIDIANTONO', NULL),
    (18, 'https://media.wired.com/photos/6488ae419d819fb102d00742/master/w_1920,c_limit/HANF-henry-grabar.jpg', 'WIRED STAFF', 'AMY ELISABETH SPASOFF'),
    (19, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ8rXeW9BJjYBpaTkRGb1xJSIWFAlq_IQTtyNvLi1RTPC9SVW9T', 'TAILYR IRVINE', 'Marsha Small is one of the very few Indigenous researchers who use ground-penetrating radar—and the only one with significant experience using the technology at boarding schools.'),
    (19, 'https://media.wired.com/photos/64ada24082d37ced55dff70d/master/w_1600,c_limit/Backchannel-Boarding-Schools-Small-268.jpg', 'TAILYR IRVINE', 'The day after the Drexel Hall excavation, Rosalie Whirlwind Soldier was among several survivors of boarding schools to deliver testimonies to Secretary Deb Haaland at the Rosebud Sioux reservation.'),
    (19, 'https://media.wired.com/photos/64ad9d65a6c1fece8f4bb4c3/master/w_1600,c_limit/Backchannel-Boarding-Schools-Small-244.jpg', 'TAILYR IRVINE', NULL),
    (19, 'https://media.wired.com/photos/64ad9d65ef8671d76d4a8a31/master/w_1600,c_limit/Backchannel-Boarding-Schools-Small-237.jpg', 'TAILYR IRVINE', NULL),
    (19, 'https://media.wired.com/photos/648b6c4f9a01d944fee35f85/master/w_1600,c_limit/WI070123_FF_BoardingSchools_12.jpg', 'TAILYR IRVINE', 'The stained-glass windows of the chapel at Red Cloud were designed by Francis He Crow and a group of high school students in 1997.'),
    (19, 'https://media.wired.com/photos/648b6a7340f1b0ff57844605/master/w_1600,c_limit/WI070123_FF_BoardingSchools_04.jpg', 'TAILYR IRVINE', 'Graduates of Red Cloud have carved their names into the bricks of Drexel Hall.'),
    (19, 'https://media.wired.com/photos/64ad994ed96882f74caa4064/master/w_1600,c_limit/Backchannel-Boarding-Schools-Small-072.jpg', 'TAILYR IRVINE', 'When Marsha Small fused her interests in Native American studies and ecological fieldwork, a path opened up with ease for the first time in her life.'),
    (19, 'https://media.wired.com/photos/64ada30fd96882f74caa4066/master/w_1600,c_limit/Backchannel-Boarding-Schools-Small-318.jpg', 'TAILYR IRVINE', NULL),
    (19, 'https://media.wired.com/photos/648b6d368d6da8ab812d853d/master/w_1600,c_limit/WI070123_FF_BoardingSchools_05.jpg', 'TAILYR IRVINE', 'Students sit outside of Drexel Hall.');
GO
-- Insert vào bảng Audio
INSERT INTO Audio (Post_ID, LinkAudio, IntroAudio, TitleAudio)
VALUES
    (2, 'https://www.wired.com/story/have-a-nice-future-podcast-13/', NULL, 'To Understand the Human Brain, Give an Octopus MDMA'),
    (17, 'https://www.wired.com/story/gadget-lab-podcast-603/', NULL, 'Your Clothes Are Making You Sick'),
    (18, 'https://www.wired.com/story/have-a-nice-future-podcast-10/', 'Episodes 1', 'Is a Parking-Free Future Possible?'),
    (18, 'https://www.wired.com/story/have-a-nice-future-podcast-10/', 'Episodes 2', 'We Do not Deserve (Immortal) Dogs'),
    (18, 'https://www.wired.com/story/have-a-nice-future-podcast-10/', 'Episodes 3', 'Play button for To Save The Planet, Start Drilling'),
    (18, 'https://www.wired.com/story/have-a-nice-future-podcast-10/', 'Episodes 4', 'To Save The Planet, Start Drilling'),
    (18, 'https://www.wired.com/story/have-a-nice-future-podcast-10/', 'Episodes 5', 'Play button for To Fix Cities, Change This One Thing'),
    (18, 'https://www.wired.com/story/have-a-nice-future-podcast-10/', 'Episodes 6', 'To Fix Cities, Change This One Thing'),
    (18, 'https://www.wired.com/story/have-a-nice-future-podcast-10/', 'Episodes 7', 'Play button for Weight Loss in the Age of Ozempic'),
    (18, 'https://www.wired.com/story/have-a-nice-future-podcast-10/', 'Episodes 8', 'Weight Loss in the Age of Ozempic'),
    (18, 'https://www.wired.com/story/have-a-nice-future-podcast-10/', 'Episodes 9', 'Play button for We will Never Have Another Twitter'),
    (18, 'https://www.wired.com/story/have-a-nice-future-podcast-10/', 'Episodes 10', 'We will Never Have Another Twitter'),
    (18, 'https://www.wired.com/story/have-a-nice-future-podcast-10/', 'Episodes 11', 'Play button for Why Fake Drake Is Here To Stay'),
    (18, 'https://www.wired.com/story/have-a-nice-future-podcast-10/', 'Episodes 12', 'Why Fake Drake Is Here To Stay'),
    (18, 'https://www.wired.com/story/have-a-nice-future-podcast-10/', 'Episodes 13', 'Play button for How To Stop AI From Taking Your Job'),
    (18, 'https://www.wired.com/story/have-a-nice-future-podcast-10/', 'Episodes 14', 'How To Stop AI From Taking Your Job');
GO
-- Insert vào bảng Video
INSERT INTO Video (Post_ID, LinkVideo, IntroVideo, Transcript)
VALUES
    (7, 'https://www.wired.com/video/watch/wired-news-and-science-atomic-expert-explains-oppenheimer-bomb-scenes', NULL, 'https://www.wired.com/video/watch/wired-news-and-science-atomic-expert-explains-oppenheimer-bomb-scenes'),
    (8, 'https://www.wired.com/video/watch/pro-interpreters-vs-ai-who-translates-faster-and-better', NULL, 'https://www.wired.com/video/watch/pro-interpreters-vs-ai-who-translates-faster-and-better'),
    (9, 'https://www.wired.com/video/watch/wired-news-and-science-why-the-average-human-couldnt-drive-an-f1-car', NULL, 'https://www.wired.com/video/watch/wired-news-and-science-why-the-average-human-couldnt-drive-an-f1-car'),
    (10, 'https://www.wired.com/video/watch/ai-tries-20-jobs', NULL, 'https://www.wired.com/video/watch/ai-tries-20-jobs'),
    (11, 'https://www.wired.com/video/watch/wired-news-and-science-cold-plunge-benefits', NULL, 'https://www.wired.com/video/watch/wired-news-and-science-cold-plunge-benefits'),
    (12, 'https://www.wired.com/video/watch/wired-news-and-science-surveillance', NULL, 'https://www.wired.com/video/watch/wired-news-and-science-surveillance'),
    (13, 'https://www.wired.com/video/watch/are-we-living-in-a-simulation', NULL, 'https://www.wired.com/video/watch/are-we-living-in-a-simulation'),
    (14, 'https://www.wired.com/video/watch/disney-stuntronics', NULL, 'https://www.wired.com/video/watch/disney-stuntronics'),
    (15, 'https://www.wired.com/video/watch/wired-news-and-science-vegan-melty-cheese', NULL, 'https://www.wired.com/video/watch/wired-news-and-science-vegan-melty-cheese'),
    (16, 'https://www.wired.com/video/watch/wired-news-and-science-why-the-milk-crate-challenge-structure-fails', NULL, 'https://www.wired.com/video/watch/wired-news-and-science-why-the-milk-crate-challenge-structure-fails');
GO
-- Insert vào bảng Keywords
INSERT INTO Keywords (Post_ID, Keywords)
VALUES
    (1, 'new group of apps'),
    (1, 'a more open-source protocol'),
    (1, 'billed by TikTok'),
    (2, 'Have a Nice Future'),
    (2, 'psychedelic'),
    (2, 'clinical studies of psychedelics'),
    (3, 'GitHub Copilot'),
    (3, 'Microsoft'),
    (3, 'OpenAI'),
    (4, 'flood warning system'),
    (4, 'Google Hangouts'),
    (4, 'Horizon Workrooms'),
    (5, 'Character.ai'),
    (5, 'Zencare'),
    (6, 'OpenAI'),
    (6, 'with ChatGPT Plus'),
    (6, 'web browsing'),
    (17, 'EcoCult');
GO
-- Insert vào bảng PostAuthor
INSERT INTO PostAuthor (Post_ID, Author_ID, TypeAuthor)
VALUES
    (1, 1, 'First Author'),
    (2, 2, 'Co-Author'),
    (2, 1, 'First Author'),
    (3, 17, 'First Author'),
    (4, 18, 'First Author'),
    (5, 19, 'First Author'),
    (6, 20, 'First Author'),
    (7, 6, 'First Author'),
    (8, 7, 'First Author'),
    (9, 8, 'First Author'),
    (10, 9, 'First Author'),
    (11, 10, 'First Author'),
    (12, 11, 'First Author'),
    (13, 14, 'First Author'),
    (14, 15, 'First Author'),
    (15, 16, 'First Author'),
    (16, 17, 'First Author'),
    (17, 15, 'First Author'),
    (17, 1, 'Co-Author'),
    (18, 2, 'First Author'),
    (18, 1, 'Co-Author'),
    (19, 12, 'First Author');
GO
-- Insert vào bảng SocialMedia
INSERT INTO SocialMedia (Author_ID, TypeSocial, Link)
VALUES
    (1, 'twitter', 'https://twitter.com/LaurenGoode'),
    (2, 'twitter', 'https://twitter.com/glichfield'),
    (3, 'twitter', 'https://www.twitter.com/raminskibba'),
    (4, 'twitter', 'https://www.twitter.com/nonlinearnotes'),
    (5, 'twitter', 'https://www.twitter.com/jtemperton'),
    (6, 'twitter', 'https://twitter.com/KimZetter'),
    (7, 'twitter', 'https://www.twitter.com/johnsemley3000'),
    (8, 'twitter', 'https://www.twitter.com/medeajulianna'),
    (10, 'twitter', 'https://www.twitter.com/adriennemso'),
    (12, 'twitter', 'https://www.twitter.com/rowanmg'),
    (13, 'twitter', 'https://www.twitter.com/BStoly'),
    (14, 'website', 'http://davidbarrkirtley.com/'),
    (15, 'instagram', 'https://www.instagram.com/snackfight'),
    (17, 'twitter', 'https://www.twitter.com/willknight'),
    (18, 'twitter', 'https://www.twitter.com/BooneAshworth'),
    (19, 'linkedin', 'https://www.linkedin.com/sarah-gundle-psyd-96076b1'),
    (20, 'twitter', 'https://www.twitter.com/thiccreese');
GO
-- Insert vào bảng SavePost
INSERT INTO SavePost (Post_ID, Customer_ID, TimeSave)
VALUES
    (1, 1, '2023-07-26'),
    (3, 5, '2023-07-25'),
    (7, 3, '2023-07-24'),
    (10, 12, '2023-07-23'),
    (12, 18, '2023-07-22'),
    (15, 8, '2023-07-21'),
    (17, 18, '2023-07-20'),
    (2, 4, '2023-07-19'),
    (6, 20, '2023-07-18'),
    (8, 5, '2023-07-17');
GO
-- Insert vào bảng Comment
INSERT INTO Comment (Post_ID, Customer_ID, TimeComment, Comment)
VALUES
    (1, 3, '2023-07-26 12:30:00', 'Great article!'),
    (3, 12, '2023-07-25 14:45:00', 'I found this very helpful.'),
    (7, 5, '2023-07-24 09:10:00', 'Interesting topic.'),
    (10, 8, '2023-07-23 18:20:00', 'Thanks for sharing.'),
    (12, 13, '2023-07-22 11:55:00', 'Looking forward to more content like this.'),
    (15, 1, '2023-07-21 16:05:00', 'This is amazing!'),
    (17, 12, '2023-07-20 22:30:00', 'I have some questions about this.'),
    (2, 4, '2023-07-19 13:15:00', 'Keep up the good work!'),
    (6, 9, '2023-07-18 07:40:00', 'I learned something new.'),
    (8, 4, '2023-07-17 17:50:00', 'Can you provide more details on this?');
GO
--CHECK INSERT 3
SELECT * FROM Images
SELECT * FROM Audio
SELECT * FROM Video
SELECT * FROM Keywords
SELECT * FROM PostAuthor
SELECT * FROM SocialMedia
SELECT * FROM SavePost
SELECT * FROM Comment

---------------------------------------------------------------------------
-- PHẦN 5: THÊM DỮ LIỆU SỬ DỤNG STORE PROCEDURE
--1. SP_Employee_Users -- Insert vào bảng Employee + Users
--2. SP_Author_SocialMedia --Insert vào bảng Author + SocialMedia
--3. SP_Posts_PostAuthor --Insert vào bảng Posts + PostAuthor 
--4. SP_Posts_Video_PostAuthor --Insert vào bảng Posts + Video + PostAuthor 
--5. SP_Customer_Subscribe --Insert vào bảng Customer + Subscribe

--EXEC SP_Employee_Users (@NameEmployee, @UserName, @Position_ID, @Time_start, @Time_end)
--EXEC SP_Author_SocialMedia (@Employee_ID, @LinkAvatar, @NameAuthor, @IntroAuthor, @TypeSocial, @Link)
--EXEC SP_Posts_PostAuthor (@Employee_ID, @Filter_ID, @TimePost, @Title, @TypePost, @LinkText, @Topic, @Author_ID, @TypeAuthor)
--EXEC SP_Posts_Video_PostAuthor (@Employee_ID, @Filter_ID, @TimePost, @Title, @TypePost, @LinkText, @Topic, @LinkVideo, @Transcript, @IntroVideo, @Author_ID, @TypeAuthor)
--EXEC SP_Customer_Subscribe (@Email, @CusPassword, @TimeRegis, @Newsletter_ID)

SELECT * FROM Employee
SELECT * FROM Users
EXEC SP_Employee_Users 'Test', 'Test1', 1, '2023-07-01', NULL
SELECT * FROM Employee
SELECT * FROM Users

SELECT * FROM Author
SELECT * FROM SocialMedia
EXEC SP_Author_SocialMedia 23, 'link_test', 'Test', 'Link_test', 'twitter', 'link_test'
SELECT * FROM Author
SELECT * FROM SocialMedia

SELECT * FROM Posts
SELECT * FROM PostAuthor
EXEC SP_Posts_PostAuthor 18, null, '2023-07-24 20:14:00.00', 'test', 'Article', 'link_test', 'test', 21, 'first author'
SELECT * FROM Posts
SELECT * FROM PostAuthor
--3. Insert vào bảng Posts + PostAuthor

SELECT * FROM Posts
SELECT * FROM Video
SELECT * FROM PostAuthor
EXEC SP_Posts_Video_PostAuthor 18, null, '2023-07-24 20:14:00.00', 'test','Video', 'link_test', 'test', 'link_test', 'link_test', null, 21, 'first author'
SELECT * FROM Posts
SELECT * FROM Video
SELECT * FROM PostAuthor

SELECT * FROM Customer
SELECT * FROM Subscribe
EXEC SP_Customer_Subscribe 'test@test.com', 'Password', '2023-07-24 20:14:00.00', 10
SELECT * FROM Customer
SELECT * FROM Subscribe
--------------------------------------------------------------------------------------------
--PHẦN 6 TẠO FUNTION 
-- COUNT số bài báo đang hiển thị trên trang
-- tính toán tỷ lệ khách hàng trả phí/số khách hàng đăng ký trên trang

--1. COUNT số bài báo đang hiển thị trên trang
CREATE FUNCTION CountPostActive ()
RETURNS INT
AS
BEGIN
	DECLARE @count INT
	SELECT @count = COUNT(*) FROM Posts WHERE StatusPost = 1
    RETURN @count;
END;
GO
--2. tính toán tỷ lệ khách hàng trả phí/số khách hàng đăng ký trên trang trong 1 khoảng thời gian
CREATE FUNCTION RateOfPayingCus (@timesBegin DATE, @timeEnd DATE)  --rate of paying customer: tỷ lệ khách hàng trả phí
RETURNS FLOAT
AS
BEGIN
	DECLARE @CountAllCus INT;
	DECLARE @CountVIPCus INT;
	SET @CountAllCus = (SELECT COUNT(*) FROM Customer c WHERE CAST(c.TimeRegis AS DATE) BETWEEN @timesBegin AND @timeEnd)
	SET @CountVIPCus = (SELECT COUNT(*) FROM Customer c JOIN Transactions t ON c.Customer_ID = t.Customer_ID 
	WHERE t.StatusTrans = 1 AND Amount >= 5 AND CAST(t.TimeTrans AS DATE) BETWEEN @timesBegin AND @timeEnd) --5 USD phí/1 năm
	RETURN (CAST(@CountVIPCus AS FLOAT)/@CountAllCus)
END;
---------------------------------------------------------------------------------------------
--PHẦN 7 THỰC HIỆN CÁC TRUY VẤN THEO YÊU CẦU
-- Truy vấn dữ liệu trên một bảng: lấy ra tất cả dữ liệu có trong bảng Transactions
SELECT * FROM Transactions;
GO
-- Truy vấn có sử dụng Order by: Lấy ra tất cả dữ liệu có trong bảng customer sắp xếp theo thời gian đăng ký tài khoản (TimeRegis)
SELECT * FROM Customer ORDER BY TimeRegis;
GO
-- Truy vấn sử dụng toán tử Like và các so sánh xâu ký tự: Lấy ra tất cả các nhân viên mà trong Nameemployee có chứa 'es' và Nameemployee khác 'Test'
SELECT * FROM Employee WHERE NameEmployee LIKE '%es%' AND NameEmployee != 'Test';
GO
-- Truy vấn liên quan tới điều kiện về thời gian: Lấy ra các bài posts được post trong khoảng từ 1/7/2023 - 27/7/2023
SELECT * FROM Posts WHERE CAST(TimePost AS DATE) BETWEEN '2023-07-01' AND '2023-07-27';
GO
-- Truy vấn dữ liệu từ nhiều bảng sử dụng Inner join: Lấy ra các nhân viên là các tác giả đang hoạt động
SELECT * FROM Employee e INNER JOIN Author a ON e.Employee_ID = a.Employee_ID WHERE a.StatusAuthor = 1;
GO
-- Truy vấn sử dụng Self join, Outer join: 
--+ Self join: lấy ra tất cả các bài post ở dạng audio mà có hình ảnh minh họa.
SELECT DISTINCT a.Post_ID FROM Audio a, Images
GO
--+ outer join: lấy ra các nhân viên của tổ chức và các thông tin về tác giả (nếu có)
SELECT * FROM Employee e LEFT JOIN Author a ON e.Employee_ID = a.Employee_ID
GO
-- Truy vấn sử dụng truy vấn con: lấy ra thông tin về tất cả các nhân viên có vị trí là Website Administrator
SELECT * FROM Employee WHERE Employee_ID IN (SELECT Employee_ID FROM Users u JOIN Position p ON u.Position_ID = p.Position_ID WHERE Position = 'Website Administrator')
GO
-- Truy vấn sử dụng With: lấy ra mã tác giả và tên các tác giả đã có bài posts
With T_table (authorID, NameAu) AS (SELECT DISTINCT p.Author_ID, NameAuthor FROM PostAuthor p JOIN Author a ON p.Author_ID = a.Author_ID)
SELECT * FROM T_table;
GO
-- Truy vấn thống kê sử dụng Group by và Having
--+ Group by: count số bài viết của từng tác giả, ngoại trừ các tác giả có 0 bài viết
SELECT a.Author_ID, NameAuthor, COUNT(p.Post_ID) AS 'XCount' FROM Author a JOIN PostAuthor p ON a.Author_ID = p.Author_ID 
GROUP BY a.Author_ID, NameAuthor
HAVING COUNT(p.Post_ID) > 0
GO
-- Truy vấn sử dụng function (hàm) đã viết trong bước trước.
SELECT dbo.RateOfPayingCus ('2023-05-27', '2023-06-10'); --in ra tỷ lệ khách hàng trả phí/số khách hàng đăng ký trong giai đoạn từ 27/5-10/6
SELECT dbo.CountPostActive(); --in ra số bài viết đang hiển thị trên trang
