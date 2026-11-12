# Hệ Thống Quản Lý Rạp Chiếu Phim – Cinema Premiere (PTTK HTTT)

Dự án Java Web MVC (`JSP` + `Servlet` + `DAO` + `Model` + `MySQL`) triển khai 2 module:
1. **Đăng ký thành viên** (`CustomerLoginUI6.jsp` → `MemberRegistrationUI6.jsp` → `RegistrationSuccessUI6.jsp`)
2. **Bán vé tại quầy** (`StaffLoginUI6.jsp` → `MovieConsultationUI6.jsp` → `ShowtimeSelectionUI6.jsp` → `SeatSelectionUI6.jsp` → `MemberDiscountUI6.jsp` → `PaymentUI6.jsp` → `TransactionSuccessUI6.jsp`)

---

## 1. Yêu cầu môi trường
- **JDK:** Java 8 trở lên
- **Server:** Apache Tomcat 8.5 / 9.0
- **Database:** MySQL 5.7+ / 8.0+
- **Build tool:** Apache Maven 3.x (hoặc import *Existing Maven Project* trong Eclipse / IntelliJ)

---

## 2. Cài đặt nhanh để chạy dự án

### Bước 1: Tạo cơ sở dữ liệu MySQL
Chạy file [`cinema_db.sql`](cinema_db.sql) ở thư mục gốc của repo (bằng MySQL Workbench, phpMyAdmin hoặc CLI) để tạo database `cinema_db` (21 bảng) kèm dữ liệu mẫu (tài khoản, phim, phòng chiếu, ghế, bảng giá, suất chiếu động theo ngày hiện tại).

### Bước 2: Cấu hình kết nối MySQL (nếu khác mặc định)
Mở [`src/main/java/dao/DAO.java`](src/main/java/dao/DAO.java) kiểm tra các thông số ở đầu file:
- `DEFAULT_URL`: `jdbc:mysql://localhost:3306/cinema_db?...`
- `DEFAULT_USER`: `root`
- `DEFAULT_PASS`: sửa lại cho khớp mật khẩu MySQL trên máy bạn (ví dụ `""` nếu dùng XAMPP).

### Bước 3: Build & Chạy trên Apache Tomcat 9
```bash
mvn clean package
```
Copy file `target/CinemaRegistrationWeb.war` vào thư mục `webapps/` của Tomcat 9 và khởi động Tomcat (hoặc chạy trực tiếp trong Eclipse *Run on Server*).

---

## 3. Đường dẫn & Tài khoản test nhanh
- **Module Bán vé tại quầy:** `http://localhost:8080/CinemaRegistrationWeb/staff-login`
  - Tài khoản nhân viên thu ngân: **`staff`** / **`123456`**
  - Mã thẻ / SĐT thành viên mẫu (để áp dụng chiết khấu): **`KH00001`** (`0987654321` - Hạng Bạc 5%), **`KH00002`** (`0911223344` - Hạng Vàng 10%), **`KH00003`** (`0977889900` - Hạng Kim Cương 15%)
- **Module Đăng ký thành viên:** `http://localhost:8080/CinemaRegistrationWeb/CustomerLoginUI6.jsp`

