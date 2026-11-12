<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Nhập Nhân Viên - StaffLoginUI6</title>
    <link rel="stylesheet" href="css/style.css?v=3">
</head>
<body>
    <div class="cinema-container" style="max-width: 480px; text-align: center;">
        <div class="cinema-header">
            <h1 class="cinema-title" style="font-size: 22px;">Đăng Nhập Ca Trực POS</h1>
        </div>

        <c:if test="${not empty errorMsg}">
            <div class="cinema-alert" id="errorMsg" style="margin-bottom: 20px;">
                <span>${errorMsg}</span>
            </div>
        </c:if>

        <form action="staff-login" method="POST" id="inLoginForm">
            <div class="input-field" style="margin-bottom: 16px; text-align: left;">
                <label class="input-label" for="inUsername">Mã nhân viên / Tên đăng nhập <span class="req">*</span></label>
                <div class="input-box">
                    <input type="text" class="input-control" id="inUsername" name="inUsername" value="${param.inUsername != null ? param.inUsername : 'staff'}" placeholder="Ví dụ: staff" required>
                </div>
            </div>

            <div class="input-field" style="margin-bottom: 24px; text-align: left;">
                <label class="input-label" for="inPassword">Mật khẩu <span class="req">*</span></label>
                <div class="input-box">
                    <input type="password" class="input-control" id="inPassword" name="inPassword" value="123456" placeholder="Mật khẩu" required>
                </div>
            </div>

            <button type="submit" id="subLogin" class="btn btn-primary" style="width: 100%; padding: 14px; font-size: 16px;">
                Đăng Nhập Vào Ca Trực
            </button>
        </form>
    </div>
</body>
</html>

