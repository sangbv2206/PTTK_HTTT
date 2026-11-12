
CREATE DATABASE cinema_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE cinema_db;

CREATE TABLE tblUser (
    id INT AUTO_INCREMENT PRIMARY KEY,
    fullName VARCHAR(255) NOT NULL,
    dateOfBirth DATE NULL,
    address VARCHAR(255) NULL,
    phoneNumber VARCHAR(20) NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    username VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE tblMembershipTier6 (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tierName VARCHAR(255) NOT NULL,
    pointRate DOUBLE NOT NULL,
    minPointsRequired INT NOT NULL,
    discountRate DOUBLE NOT NULL,
    benefitsDescription VARCHAR(255) NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE tblPaymentMethod6 (
    id INT AUTO_INCREMENT PRIMARY KEY,
    methodName VARCHAR(255) NOT NULL,
    description VARCHAR(255) NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE tblPromotion6 (
    id INT AUTO_INCREMENT PRIMARY KEY,
    programName VARCHAR(255) NOT NULL,
    programType VARCHAR(255) NOT NULL,
    startDate DATE NOT NULL,
    endDate DATE NOT NULL,
    minBillAmount DOUBLE NOT NULL,
    discountAmount DOUBLE NOT NULL,
    status VARCHAR(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE tblScreeningRoom6 (
    id INT AUTO_INCREMENT PRIMARY KEY,
    roomName VARCHAR(255) NOT NULL,
    capacity INT NOT NULL,
    supportedFormats VARCHAR(255) NOT NULL,
    description VARCHAR(255) NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE tblSeat6 (
    id INT AUTO_INCREMENT PRIMARY KEY,
    seatNumber VARCHAR(10) NOT NULL,
    seatType VARCHAR(255) NOT NULL,
    status VARCHAR(50) NOT NULL DEFAULT 'ACTIVE',
    tblScreeningRoom6id INT NOT NULL,
    CONSTRAINT fk_seat_room FOREIGN KEY (tblScreeningRoom6id)
        REFERENCES tblScreeningRoom6(id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE tblMovie6 (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    poster VARCHAR(255) NULL,
    director VARCHAR(255) NULL,
    `cast` VARCHAR(255) NULL,
    genre VARCHAR(255) NOT NULL,
    duration INT NOT NULL,
    ageRestriction INT NOT NULL,
    status VARCHAR(50) NOT NULL,
    description TEXT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE tblShowtime6 (
    id INT AUTO_INCREMENT PRIMARY KEY,
    startTime DATETIME NOT NULL,
    endTime DATETIME NOT NULL,
    screeningFormat VARCHAR(255) NOT NULL,
    tblMovie6id INT NOT NULL,
    tblScreeningRoom6id INT NOT NULL,
    CONSTRAINT fk_showtime_movie FOREIGN KEY (tblMovie6id)
        REFERENCES tblMovie6(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_showtime_screeningroom FOREIGN KEY (tblScreeningRoom6id)
        REFERENCES tblScreeningRoom6(id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE tblShowtimeSeat6 (
    id INT AUTO_INCREMENT PRIMARY KEY,
    status VARCHAR(50) NOT NULL DEFAULT 'AVAILABLE',
    holderSessionId VARCHAR(100) NULL,
    holdExpiryTime DATETIME NULL,
    tblShowtime6id INT NOT NULL,
    tblSeat6id INT NOT NULL,
    CONSTRAINT fk_showtimeseat_showtime FOREIGN KEY (tblShowtime6id)
        REFERENCES tblShowtime6(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_showtimeseat_seat FOREIGN KEY (tblSeat6id)
        REFERENCES tblSeat6(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT uq_showtime_seat UNIQUE (tblShowtime6id, tblSeat6id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE tblTicketPrice6 (
    id INT AUTO_INCREMENT PRIMARY KEY,
    seatType VARCHAR(255) NOT NULL,
    screeningFormat VARCHAR(255) NOT NULL,
    dayType VARCHAR(255) NOT NULL,
    basePrice DOUBLE NOT NULL,
    surcharge DOUBLE NOT NULL DEFAULT 0,
    status VARCHAR(50) NOT NULL,
    effectiveDate DATE NOT NULL,
    endDate DATE NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE tblShowtimeTicketPrice6 (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tblShowtime6id INT NOT NULL,
    tblTicketPrice6id INT NOT NULL,
    CONSTRAINT fk_showtimeticketprice_showtime FOREIGN KEY (tblShowtime6id)
        REFERENCES tblShowtime6(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_showtimeticketprice_price FOREIGN KEY (tblTicketPrice6id)
        REFERENCES tblTicketPrice6(id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE tblMembershipCard6 (
    id INT AUTO_INCREMENT PRIMARY KEY,
    issueDate DATE NOT NULL,
    expiryDate DATE NOT NULL,
    status VARCHAR(50) NOT NULL,
    tblMembershipTier6id INT NOT NULL,
    CONSTRAINT fk_card_tier FOREIGN KEY (tblMembershipTier6id)
        REFERENCES tblMembershipTier6(id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE tblCustomer (
    tblUserId INT PRIMARY KEY,
    cus_id VARCHAR(255) NOT NULL UNIQUE,
    loyaltyPoints INT NOT NULL DEFAULT 0,
    tblMembershipCard6id INT NOT NULL,
    CONSTRAINT fk_customer_user FOREIGN KEY (tblUserId)
        REFERENCES tblUser(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_customer_card FOREIGN KEY (tblMembershipCard6id)
        REFERENCES tblMembershipCard6(id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE tblEmployee (
    tblUserId INT PRIMARY KEY,
    emp_id VARCHAR(255) NOT NULL UNIQUE,
    CONSTRAINT fk_employee_user FOREIGN KEY (tblUserId)
        REFERENCES tblUser(id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE tblManager (
    tblUserId INT PRIMARY KEY,
    CONSTRAINT fk_manager_employee FOREIGN KEY (tblUserId)
        REFERENCES tblEmployee(tblUserId) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE tblSalesStaff (
    tblUserId INT PRIMARY KEY,
    CONSTRAINT fk_salesstaff_employee FOREIGN KEY (tblUserId)
        REFERENCES tblEmployee(tblUserId) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE tblInvoice6 (
    id INT AUTO_INCREMENT PRIMARY KEY,
    totalAmount DOUBLE NOT NULL,
    discountAmount DOUBLE NOT NULL DEFAULT 0,
    finalAmount DOUBLE NOT NULL,
    createdAt DATETIME NOT NULL,
    tblCustomertid INT NULL,
    tblSalesStaffid INT NOT NULL,
    tblPaymentMethod6id INT NOT NULL,
    CONSTRAINT chk_invoice_amount CHECK (totalAmount >= 0 AND finalAmount >= 0),
    CONSTRAINT fk_invoice_customer FOREIGN KEY (tblCustomertid)
        REFERENCES tblCustomer(tblUserId) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT fk_invoice_salesstaff FOREIGN KEY (tblSalesStaffid)
        REFERENCES tblSalesStaff(tblUserId) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_invoice_paymentmethod FOREIGN KEY (tblPaymentMethod6id)
        REFERENCES tblPaymentMethod6(id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE tblTicket6 (
    id INT AUTO_INCREMENT PRIMARY KEY,
    salePrice DOUBLE NOT NULL,
    purchaseTime DATETIME NOT NULL,
    qrCode VARCHAR(255) NOT NULL,
    tblShowtimeSeat6id INT NOT NULL,
    tblInvoice6id INT NOT NULL,
    CONSTRAINT fk_ticket_showtimeseat FOREIGN KEY (tblShowtimeSeat6id)
        REFERENCES tblShowtimeSeat6(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_ticket_invoice FOREIGN KEY (tblInvoice6id)
        REFERENCES tblInvoice6(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT uq_ticket_showtimeseat UNIQUE (tblShowtimeSeat6id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE tblInvoicePromotion6 (
    id INT AUTO_INCREMENT PRIMARY KEY,
    discountAmount DOUBLE NOT NULL,
    appliedAt DATE NOT NULL,
    tblInvoice6id INT NOT NULL,
    CONSTRAINT fk_invpromo_invoice FOREIGN KEY (tblInvoice6id)
        REFERENCES tblInvoice6(id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE tblPromotionTier6 (
    id INT AUTO_INCREMENT PRIMARY KEY,
    discountRate DOUBLE NOT NULL,
    tblMembershipTier6id INT NOT NULL,
    tblPromotion6id INT NOT NULL,
    CONSTRAINT fk_promotier_tier FOREIGN KEY (tblMembershipTier6id)
        REFERENCES tblMembershipTier6(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_promotier_promo FOREIGN KEY (tblPromotion6id)
        REFERENCES tblPromotion6(id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE tblRevenueClosingPeriod6 (
    id INT AUTO_INCREMENT PRIMARY KEY,
    startTime DATETIME NOT NULL,
    endTime DATETIME NOT NULL,
    totalRevenue DOUBLE NOT NULL,
    status VARCHAR(50) NOT NULL,
    tblManagerid INT NOT NULL,
    tblInvoice6id INT NOT NULL,
    CONSTRAINT fk_revenue_manager FOREIGN KEY (tblManagerid)
        REFERENCES tblManager(tblUserId) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_revenue_invoice FOREIGN KEY (tblInvoice6id)
        REFERENCES tblInvoice6(id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ==============================================================================
-- DỮ LIỆU MẪU BAN ĐẦU
-- ==============================================================================

INSERT INTO tblMembershipTier6 (id, tierName, pointRate, minPointsRequired, discountRate, benefitsDescription) VALUES
(1, 'Thành viên Chuẩn (Đồng)', 0.05, 0, 0.00, 'Hạng mặc định cho thành viên mới, tích lũy 5% điểm chi tiêu'),
(2, 'Thành viên Bạc (Silver)', 0.07, 1000, 0.05, 'Tích lũy 7% điểm, giảm giá 5% giá vé'),
(3, 'Thành viên Vàng (Gold)', 0.10, 3000, 0.10, 'Tích lũy 10% điểm, giảm giá 10% giá vé, miễn phí bắp nước sinh nhật'),
(4, 'Thành viên Kim Cương (Diamond)', 0.15, 6000, 0.15, 'Tích lũy 15% điểm, giảm giá 15% giá vé, phòng chờ VIP');

INSERT INTO tblPaymentMethod6 (id, methodName, description) VALUES
(1, 'Tiền mặt', 'Thanh toán trực tiếp bằng tiền mặt tại quầy vé'),
(2, 'Thẻ ngân hàng / POS', 'Quẹt thẻ ATM, Visa, MasterCard tại quầy'),
(3, 'Ví điện tử VNPay / MoMo', 'Quét mã QR thanh toán qua ứng dụng ngân hàng hoặc ví điện tử');

INSERT INTO tblMovie6 (id, title, poster, director, `cast`, genre, duration, ageRestriction, status, description) VALUES
(1, 'Avatar 3: The Seed Bearer', 'https://images.unsplash.com/photo-1536440136628-849c177e76a1?w=600', 'James Cameron', 'Sam Worthington, Zoe Saldana, Sigourney Weaver', 'Khoa học viễn tưởng, Hành động', 160, 13, 'NOW_SHOWING', 'Cuộc đối đầu kịch tính với tộc người Tro trên hành tinh Pandora.'),
(2, 'Thám Tử Conan: Ngôi Sao 5 Cánh', 'https://images.unsplash.com/photo-1579783902614-a3fb3927b675?w=600', 'Chika Nagaoka', 'Minami Takayama, Wakana Yamazaki, Kappei Yamaguchi', 'Hoạt hình, Trinh thám', 110, 12, 'NOW_SHOWING', 'Conan và Siêu đạo chích Kid cùng tranh đoạt thanh kiếm báu tại Hakodate.'),
(3, 'Dune: Hành Tinh Cát - Phần Hai', 'https://images.unsplash.com/photo-1509198397868-475647b2a1e5?w=600', 'Denis Villeneuve', 'Timothée Chalamet, Zendaya, Rebecca Ferguson', 'Khoa học viễn tưởng, Phiêu lưu', 166, 16, 'NOW_SHOWING', 'Paul Atreides hợp lực cùng người Fremen để trả thù cho gia tộc.'),
(4, 'Mai', 'https://images.unsplash.com/photo-1518676590629-3dcbd9c5a5c9?w=600', 'Trấn Thành', 'Phương Anh Đào, Tuấn Trần, Hồng Đào', 'Tình cảm, Tâm lý', 131, 18, 'NOW_SHOWING', 'Câu chuyện cảm động về tình yêu và số phận của Mai.'),
(5, 'Lật Mặt 7: Một Điều Ước', 'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?w=600', 'Lý Hải', 'Thanh Hiền, Trương Minh Cường, Đinh Y Nhung', 'Gia đình, Tình cảm', 138, 13, 'NOW_SHOWING', 'Hành trình xúc động về tình mẫu tử của bà Hai và 5 người con.'),
(6, 'Deadpool & Wolverine', 'https://images.unsplash.com/photo-1563089145-599997674d42?w=600', 'Shawn Levy', 'Ryan Reynolds, Hugh Jackman, Emma Corrin', 'Hành động, Hài hước', 128, 18, 'NOW_SHOWING', 'Sự kết hợp bùng nổ và hài hước giữa hai dị nhân Marvel.'),
(7, 'Exhuma: Quật Mộ Trùng Ma', 'https://images.unsplash.com/photo-1509281373149-e957c6296406?w=600', 'Jang Jae-hyun', 'Choi Min-sik, Kim Go-eun, Lee Do-hyun', 'Kinh dị, Bí ẩn', 134, 16, 'NOW_SHOWING', 'Nhóm pháp sư và thầy phong thủy khai quật ngôi mộ bí ẩn.'),
(8, 'Kung Fu Panda 4', 'https://images.unsplash.com/photo-1534447677768-be436bb09401?w=600', 'Mike Mitchell', 'Jack Black, Awkwafina, Viola Davis', 'Hoạt hình, Võ thuật', 94, 0, 'NOW_SHOWING', 'Po bước vào hành trình mới tìm người kế thừa Thần Long Đại Hiệp.');

INSERT INTO tblScreeningRoom6 (id, roomName, capacity, supportedFormats, description) VALUES
(1, 'Phòng Chiếu 01 (IMAX Laser)', 36, '2D, 3D, IMAX', 'Màn hình vòm IMAX Laser cực đại, âm thanh 12 kênh'),
(2, 'Phòng Chiếu 02 (Dolby Atmos)', 10, '2D, 3D', 'Âm thanh đa chiều Dolby Atmos sống động'),
(3, 'Phòng Chiếu 03 (Gold Class VIP)', 10, '2D, VIP', 'Ghế da bọc nệm chỉnh điện cao cấp'),
(4, 'Phòng Chiếu 04 (Tiêu Chuẩn)', 10, '2D', 'Phòng chiếu tiêu chuẩn rạp hiện đại');

INSERT INTO tblSeat6 (id, seatNumber, seatType, status, tblScreeningRoom6id) VALUES
(1, 'A01', 'STANDARD', 'ACTIVE', 1), (2, 'A02', 'STANDARD', 'ACTIVE', 1), (3, 'A03', 'STANDARD', 'ACTIVE', 1), (4, 'A04', 'STANDARD', 'ACTIVE', 1),
(5, 'A05', 'STANDARD', 'ACTIVE', 1), (6, 'A06', 'STANDARD', 'ACTIVE', 1), (7, 'A07', 'STANDARD', 'ACTIVE', 1), (8, 'A08', 'STANDARD', 'ACTIVE', 1),
(9, 'B01', 'STANDARD', 'ACTIVE', 1), (10, 'B02', 'STANDARD', 'ACTIVE', 1), (11, 'B03', 'STANDARD', 'ACTIVE', 1), (12, 'B04', 'STANDARD', 'ACTIVE', 1),
(13, 'B05', 'STANDARD', 'ACTIVE', 1), (14, 'B06', 'STANDARD', 'ACTIVE', 1), (15, 'B07', 'STANDARD', 'ACTIVE', 1), (16, 'B08', 'STANDARD', 'ACTIVE', 1),
(17, 'C01', 'VIP', 'ACTIVE', 1), (18, 'C02', 'VIP', 'ACTIVE', 1), (19, 'C03', 'VIP', 'ACTIVE', 1), (20, 'C04', 'VIP', 'ACTIVE', 1),
(21, 'C05', 'VIP', 'ACTIVE', 1), (22, 'C06', 'VIP', 'ACTIVE', 1), (23, 'C07', 'VIP', 'ACTIVE', 1), (24, 'C08', 'VIP', 'ACTIVE', 1),
(25, 'D01', 'VIP', 'ACTIVE', 1), (26, 'D02', 'VIP', 'ACTIVE', 1), (27, 'D03', 'VIP', 'ACTIVE', 1), (28, 'D04', 'VIP', 'ACTIVE', 1),
(29, 'D05', 'VIP', 'ACTIVE', 1), (30, 'D06', 'VIP', 'ACTIVE', 1), (31, 'D07', 'VIP', 'ACTIVE', 1), (32, 'D08', 'VIP', 'ACTIVE', 1),
(33, 'E01-E02', 'SWEETBOX', 'ACTIVE', 1), (34, 'E03-E04', 'SWEETBOX', 'ACTIVE', 1), (35, 'E05-E06', 'SWEETBOX', 'ACTIVE', 1), (36, 'E07-E08', 'SWEETBOX', 'ACTIVE', 1),
(37, 'A01', 'STANDARD', 'ACTIVE', 2), (38, 'A02', 'STANDARD', 'ACTIVE', 2), (39, 'A03', 'STANDARD', 'ACTIVE', 2), (40, 'A04', 'STANDARD', 'ACTIVE', 2),
(41, 'B01', 'VIP', 'ACTIVE', 2), (42, 'B02', 'VIP', 'ACTIVE', 2), (43, 'B03', 'VIP', 'ACTIVE', 2), (44, 'B04', 'VIP', 'ACTIVE', 2),
(45, 'C01-C02', 'SWEETBOX', 'ACTIVE', 2), (46, 'C03-C04', 'SWEETBOX', 'ACTIVE', 2);

INSERT INTO tblTicketPrice6 (id, seatType, screeningFormat, dayType, basePrice, surcharge, status, effectiveDate) VALUES
(1, 'STANDARD', '2D', 'WEEKDAY', 85000.0, 0.0, 'ACTIVE', '2026-01-01'),
(2, 'VIP', '2D', 'WEEKDAY', 105000.0, 0.0, 'ACTIVE', '2026-01-01'),
(3, 'SWEETBOX', '2D', 'WEEKDAY', 180000.0, 0.0, 'ACTIVE', '2026-01-01'),
(4, 'STANDARD', 'IMAX 2D', 'WEEKDAY', 130000.0, 20000.0, 'ACTIVE', '2026-01-01'),
(5, 'VIP', 'IMAX 2D', 'WEEKDAY', 160000.0, 30000.0, 'ACTIVE', '2026-01-01'),
(6, 'SWEETBOX', 'IMAX 2D', 'WEEKDAY', 260000.0, 40000.0, 'ACTIVE', '2026-01-01');

-- Tài khoản nhân viên bán vé & quản lý mẫu
INSERT INTO tblUser (id, fullName, dateOfBirth, address, phoneNumber, email, username, password, role) VALUES
(1, 'Nguyễn Minh Tuấn', '1997-04-10', 'Hà Nội', '0980001111', 'staff1@cinema.vn', 'staff', '123456', 'STAFF'),
(2, 'Trần Quản Lý', '1990-01-01', 'Hà Nội', '0988889999', 'admin@cinema.vn', 'admin', 'admin123', 'ADMIN');

INSERT INTO tblEmployee (tblUserId, emp_id) VALUES
(1, 'NV001'),
(2, 'QL001');

INSERT INTO tblSalesStaff (tblUserId) VALUES (1);
INSERT INTO tblManager (tblUserId) VALUES (2);

-- Khách hàng thành viên mẫu
INSERT INTO tblUser (id, fullName, dateOfBirth, address, phoneNumber, email, username, password, role) VALUES
(20, 'Nguyễn Văn An', '2002-08-15', 'Cầu Giấy, Hà Nội', '0987654321', 'vana@gmail.com', 'nguyenvanan', 'Pass123@', 'CUSTOMER'),
(21, 'Trần Thị Bích', '1999-12-01', 'Đống Đa, Hà Nội', '0911223344', 'bichtran@gmail.com', 'bichtran', 'Pass123@', 'CUSTOMER'),
(22, 'Lê Hoàng Nam', '1996-03-20', 'Ba Đình, Hà Nội', '0977889900', 'namle@gmail.com', 'namle', 'Pass123@', 'CUSTOMER'),
(23, 'Đỗ Khắc Cường', '1995-07-22', 'Hai Bà Trưng, Hà Nội', '0944556677', 'cuongdo@gmail.com', 'cuongdo', 'Pass123@', 'CUSTOMER');

INSERT INTO tblMembershipCard6 (id, issueDate, expiryDate, status, tblMembershipTier6id) VALUES
(20, '2026-01-01', '2099-12-31', 'ACTIVE', 2),
(21, '2026-01-01', '2099-12-31', 'ACTIVE', 3),
(22, '2026-01-01', '2099-12-31', 'ACTIVE', 4),
(23, '2024-01-01', '2025-01-01', 'EXPIRED', 1);

INSERT INTO tblCustomer (tblUserId, cus_id, loyaltyPoints, tblMembershipCard6id) VALUES
(20, 'KH00001', 1200, 20),
(21, 'KH00002', 3500, 21),
(22, 'KH00003', 7800, 22),
(23, 'KH00004', 150, 23);

-- Suất chiếu động theo ngày hiện tại (trải đều từ hôm nay tới +3 ngày sau) cho cả 8 phim
INSERT INTO tblShowtime6 (id, startTime, endTime, screeningFormat, tblMovie6id, tblScreeningRoom6id) VALUES
(1, TIMESTAMP(CURDATE(), '21:30:00'), TIMESTAMP(CURDATE(), '23:50:00'), 'IMAX 2D', 1, 1),
(2, TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 1 DAY), '10:00:00'), TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 1 DAY), '12:40:00'), 'IMAX 2D', 1, 1),
(3, TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 1 DAY), '19:30:00'), TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 1 DAY), '22:10:00'), 'IMAX 2D', 1, 1),
(4, TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 2 DAY), '15:00:00'), TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 2 DAY), '17:40:00'), '2D Tiêu Chuẩn', 1, 2),
(5, TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 3 DAY), '20:00:00'), TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 3 DAY), '22:40:00'), 'IMAX 2D', 1, 1),
(6, TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 1 DAY), '10:15:00'), TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 1 DAY), '12:05:00'), '2D Tiêu Chuẩn', 2, 2),
(7, TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 2 DAY), '16:30:00'), TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 2 DAY), '18:20:00'), '2D Tiêu Chuẩn', 2, 2),
(8, TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 3 DAY), '14:00:00'), TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 3 DAY), '15:50:00'), '2D Tiêu Chuẩn', 2, 2),
(9, TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 1 DAY), '13:00:00'), TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 1 DAY), '15:46:00'), '2D Tiêu Chuẩn', 3, 2),
(10, TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 3 DAY), '18:30:00'), TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 3 DAY), '21:16:00'), '2D Tiêu Chuẩn', 3, 2),
(11, TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 1 DAY), '18:15:00'), TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 1 DAY), '20:26:00'), '2D Tiêu Chuẩn', 4, 2),
(12, TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 3 DAY), '20:30:00'), TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 3 DAY), '22:41:00'), '2D Tiêu Chuẩn', 4, 2),
(13, TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 1 DAY), '19:00:00'), TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 1 DAY), '21:18:00'), '2D Tiêu Chuẩn', 5, 2),
(14, TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 3 DAY), '16:00:00'), TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 3 DAY), '18:18:00'), '2D Tiêu Chuẩn', 5, 2),
(15, TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 1 DAY), '21:00:00'), TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 1 DAY), '23:08:00'), '2D Tiêu Chuẩn', 6, 2),
(16, TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 3 DAY), '21:15:00'), TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 3 DAY), '23:23:00'), '2D Tiêu Chuẩn', 6, 2),
(17, TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 2 DAY), '18:30:00'), TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 2 DAY), '20:44:00'), '2D Tiêu Chuẩn', 7, 2),
(18, TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 3 DAY), '19:30:00'), TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 3 DAY), '21:44:00'), '2D Tiêu Chuẩn', 7, 2),
(19, TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 2 DAY), '15:00:00'), TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 2 DAY), '16:34:00'), '2D Tiêu Chuẩn', 8, 2),
(20, TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 3 DAY), '10:30:00'), TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 3 DAY), '12:04:00'), '2D Tiêu Chuẩn', 8, 2);

INSERT INTO tblShowtimeTicketPrice6 (tblShowtime6id, tblTicketPrice6id) VALUES
(1, 4), (1, 5), (1, 6),
(2, 4), (2, 5), (2, 6),
(3, 4), (3, 5), (3, 6),
(4, 1), (4, 2), (4, 3),
(5, 4), (5, 5), (5, 6),
(6, 1), (6, 2), (6, 3),
(7, 1), (7, 2), (7, 3),
(8, 1), (8, 2), (8, 3),
(9, 1), (9, 2), (9, 3),
(10, 1), (10, 2), (10, 3),
(11, 1), (11, 2), (11, 3),
(12, 1), (12, 2), (12, 3),
(13, 1), (13, 2), (13, 3),
(14, 1), (14, 2), (14, 3),
(15, 1), (15, 2), (15, 3),
(16, 1), (16, 2), (16, 3),
(17, 1), (17, 2), (17, 3),
(18, 1), (18, 2), (18, 3),
(19, 1), (19, 2), (19, 3),
(20, 1), (20, 2), (20, 3);

INSERT INTO tblShowtimeSeat6 (tblShowtime6id, tblSeat6id, status)
SELECT s.id, seat.id, 'AVAILABLE'
FROM tblShowtime6 s
JOIN tblSeat6 seat ON seat.tblScreeningRoom6id = s.tblScreeningRoom6id;

