<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Ký Thành Viên - Cinema Premiere</title>
    <link rel="stylesheet" href="css/style.css?v=5">
</head>
<body>

    <div class="cinema-container">
        <!-- Header -->
        <div class="cinema-header">
            <div class="brand-badge">
                CINEMA PREMIERE &bull; HỆ THỐNG RẠP
            </div>
            <h1 class="cinema-title">Đăng Ký Tài Khoản Thành Viên</h1>
            <p class="cinema-desc">
                Điền đầy đủ thông tin bên dưới để mở thẻ thành viên kỹ thuật số và hưởng ưu đãi lập tức.
            </p>
        </div>

        <!-- Thông báo lỗi khi validate thất bại -->
        <c:if test="${not empty errorMsg}">
            <div class="cinema-alert" id="errorMsg">
                <svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/>
                </svg>
                <span>${errorMsg}</span>
            </div>
        </c:if>

        <!-- BƯỚC 5: Trang MemberRegistrationUI6.jsp hiển thị form đăng ký cho Khách hàng -->
        <!-- Form nhập thông tin thành viên (inRegistrationInfo : frm) -->
        <form action="register" method="POST" id="frmRegistration">
            <input type="hidden" name="action" value="register">

            <div class="form-grid">
                <!-- 1. Họ và tên -->
                <div class="input-field">
                    <label class="input-label" for="txtFullName">
                        Họ và tên <span class="req">*</span>
                    </label>
                    <div class="input-box">
                        <svg class="input-icon" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
                        </svg>
                        <input type="text" class="input-control" id="txtFullName" name="txtFullName" 
                               value="${valFullName}" placeholder="Nguyễn Văn A" required>
                    </div>
                </div>

                <!-- 2. Số điện thoại -->
                <div class="input-field">
                    <label class="input-label" for="txtPhoneNumber">
                        Số điện thoại <span class="req">*</span>
                    </label>
                    <div class="input-box">
                        <svg class="input-icon" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z"/>
                        </svg>
                        <input type="tel" class="input-control" id="txtPhoneNumber" name="txtPhoneNumber" 
                               value="${valPhoneNumber}" placeholder="0987654321" required>
                    </div>
                </div>

                <!-- 3. Ngày sinh -->
                <div class="input-field">
                    <label class="input-label" for="txtDob">
                        Ngày sinh <span class="req">*</span>
                    </label>
                    <div class="input-box">
                        <svg class="input-icon" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/>
                        </svg>
                        <input type="date" class="input-control" id="txtDob" name="txtDob" 
                               value="${valDob}" required>
                    </div>
                </div>

                <!-- 4. Tên đăng nhập -->
                <div class="input-field">
                    <label class="input-label" for="txtUsername">
                        Tên đăng nhập <span class="req">*</span>
                    </label>
                    <div class="input-box">
                        <svg class="input-icon" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M16 12a4 4 0 10-8 0 4 4 0 008 0zm0 0v1.5a2.5 2.5 0 005 0V12a9 9 0 10-9 9m4.5-1.206a8.959 8.959 0 01-4.5 1.207"/>
                        </svg>
                        <input type="text" class="input-control" id="txtUsername" name="txtUsername" 
                               value="${valUsername}" placeholder="nguyenvana" required>
                    </div>
                </div>

                <!-- 5. Email -->
                <div class="input-field">
                    <label class="input-label" for="txtEmail">
                        Địa chỉ Email <span class="req">*</span>
                    </label>
                    <div class="input-box">
                        <svg class="input-icon" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"/>
                        </svg>
                        <input type="email" class="input-control" id="txtEmail" name="txtEmail" 
                               value="${valEmail}" placeholder="vana@example.com" required>
                    </div>
                </div>

                <!-- 6. Địa chỉ thường trú -->
                <div class="input-field">
                    <label class="input-label" for="txtAddress">
                        Địa chỉ thường trú
                    </label>
                    <div class="input-box">
                        <svg class="input-icon" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z"/>
                            <path stroke-linecap="round" stroke-linejoin="round" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"/>
                        </svg>
                        <input type="text" class="input-control" id="txtAddress" name="txtAddress" 
                               value="${valAddress}" placeholder="Hà Đông, Hà Nội">
                    </div>
                </div>

                <!-- 7. Mật khẩu -->
                <div class="input-field">
                    <label class="input-label" for="txtPassword">
                        Mật khẩu <span class="req">*</span>
                    </label>
                    <div class="input-box">
                        <svg class="input-icon" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"/>
                        </svg>
                        <input type="password" class="input-control" id="txtPassword" name="txtPassword" 
                               placeholder="Ít nhất 6 ký tự..." required>
                    </div>
                </div>

                <!-- 8. Xác nhận mật khẩu -->
                <div class="input-field">
                    <label class="input-label" for="txtConfirmPassword">
                        Xác nhận mật khẩu <span class="req">*</span>
                    </label>
                    <div class="input-box">
                        <svg class="input-icon" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"/>
                        </svg>
                        <input type="password" class="input-control" id="txtConfirmPassword" name="txtConfirmPassword" 
                               placeholder="Nhập lại mật khẩu..." required>
                    </div>
                </div>
            </div>

            <!-- Nút Thao tác -->
            <!-- BƯỚC 6: Khách hàng nhập thông tin và click nút "Hoàn Tất Đăng Ký" (gửi POST sang Servlet) -->
            <div class="cta-group">
                <button type="submit" class="btn btn-cinema-primary" id="btnRegister" name="subRegister" style="width: 100%; padding: 13px; font-size: 15px;">
                    <svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M5 13l4 4L19 7"/>
                    </svg>
                    Hoàn Tất Đăng Ký
                </button>
            </div>

        </form>
    </div>

</body>
</html>
