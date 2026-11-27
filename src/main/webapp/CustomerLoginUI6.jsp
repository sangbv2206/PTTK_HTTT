<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cổng Hội Viên - Premiere Cinema</title>
    <link rel="stylesheet" href="css/style.css?v=4">
    <style>
        @keyframes fadeInDown {
            from {
                opacity: 0;
                transform: translateY(-8px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
    </style>
</head>
<body>

    <div class="cinema-container" style="max-width: 540px; text-align: center;">
        <!-- Header Rạp chiếu phim -->
        <div class="cinema-header" style="margin-bottom: 20px;">
            <div class="brand-badge">
                CINEMA PREMIERE &bull; CỔNG HỘI VIÊN TOÀN QUỐC
            </div>
            <h1 class="cinema-title" style="font-size: 26px;">Chào Mừng Đến Với Cinema Premiere</h1>
            <p class="cinema-desc">
                Đăng ký thẻ thành viên điện tử ngay hôm nay để nhận ưu đãi giảm giá vé xem phim trọn đời, tích điểm đổi quà và tận hưởng các suất chiếu đặc quyền.
            </p>
        </div>

        <!-- Khối 3 đặc quyền thành viên rạp chiếu -->
        <div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 10px; margin: 20px 0;">
            <div style="background: #f8fafc; border: 1px solid #e2e8f0; padding: 14px 8px; border-radius: 10px;">
                <div style="font-weight: 700; font-size: 12px; color: #0f172a; text-transform: uppercase;">Thẻ Vô Thời Hạn</div>
                <div style="font-size: 11px; color: #64748b; margin-top: 3px;">Trọn đời theo hạng</div>
            </div>
            <div style="background: #f8fafc; border: 1px solid #e2e8f0; padding: 14px 8px; border-radius: 10px;">
                <div style="font-weight: 700; font-size: 12px; color: #0f172a; text-transform: uppercase;">Chiết Khấu Vé</div>
                <div style="font-size: 11px; color: #64748b; margin-top: 3px;">Giảm 5% - 15%</div>
            </div>
            <div style="background: #f8fafc; border: 1px solid #e2e8f0; padding: 14px 8px; border-radius: 10px;">
                <div style="font-weight: 700; font-size: 12px; color: #0f172a; text-transform: uppercase;">Tự Động NÂNG HẠNG</div>
                <div style="font-size: 11px; color: #64748b; margin-top: 3px;">Tích điểm nâng hạng</div>
            </div>
        </div>

        <!-- NÚT THAO TÁC CHÍNH -->
        <!-- BƯỚC 1: Khách hàng click nút "Đăng Ký Thành Viên Mới" trên giao diện CustomerLoginUI6.jsp -->
        <div style="display: flex; flex-direction: column; gap: 12px; margin-top: 25px;">
            <a href="register?action=showForm" class="btn-cinema-primary" id="lnkRegisterNew" style="font-size: 16px; padding: 15px; width: 100%; text-decoration: none; justify-content: center;">
                <svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M18 9v3m0 0v3m0-3h3m-3 0h-3m-2-5a4 4 0 11-8 0 4 4 0 018 0zM3 20a6 6 0 0112 0v1H3v-1z"/>
                </svg>
                Đăng Ký Thành Viên Mới
            </a>
        </div>
    </div>

</body>
</html>
