<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Ký Thành Công - RegistrationSuccessUI6</title>
    <link rel="stylesheet" href="css/style.css?v=5">
</head>
<body>

    <!-- BƯỚC 30: Trang RegistrationSuccessUI6.jsp hiển thị màn hình đăng ký thành công cho Khách hàng -->
    <div class="cinema-container" style="max-width: 600px;">
        <!-- Header -->
        <div class="cinema-header" style="margin-bottom: 20px;">
            <div class="brand-badge" style="background: rgba(16, 185, 129, 0.15); border-color: rgba(16, 185, 129, 0.35); color: #34d399;">
                ĐĂNG KÝ THÀNH CÔNG
            </div>
            <h1 class="cinema-title">Chào Mừng Hội Viên Mới!</h1>
            <p class="cinema-desc">
                Thẻ thành viên điện tử của bạn đã được kích hoạt. Hãy quay lại đăng nhập để bắt đầu sử dụng dịch vụ rạp.
            </p>
        </div>

        <!-- THẺ THÀNH VIÊN KỸ THUẬT SỐ (Digital Cinema Card) -->
        <div class="membership-card-wrap">
            <div class="digital-card">
                <div class="card-top">
                    <div class="card-brand">
                        CINEMA PREMIERE
                    </div>
                    <div class="card-chip"></div>
                </div>

                <div class="card-number">
                    CARD &bull; 8899 &bull; ${customer.cus_id} &bull; 2026
                </div>

                <div class="card-bottom">
                    <div>
                        <div class="card-holder-label">CHỦ THẺ / CARD HOLDER</div>
                        <div class="card-holder-name">${customer.fullName}</div>
                    </div>
                    <div class="card-tier-tag">
                        ${card.tier.tierName}
                    </div>
                </div>
            </div>
        </div>

        <!-- BẢNG THÔNG TIN CHI TIẾT TÀI KHOẢN (-outAccountInfo) -->
        <div class="details-list" id="tblAccountInfo">
            <div class="detail-row">
                <span class="detail-label">Mã khách hàng:</span>
                <span class="detail-val" style="color: #60a5fa;">${customer.cus_id}</span>
            </div>
            <div class="detail-row">
                <span class="detail-label">Tên đăng nhập:</span>
                <span class="detail-val">${customer.username}</span>
            </div>
            <div class="detail-row">
                <span class="detail-label">Số điện thoại:</span>
                <span class="detail-val">${customer.phoneNumber}</span>
            </div>
            <div class="detail-row">
                <span class="detail-label">Email:</span>
                <span class="detail-val">${customer.email}</span>
            </div>
            <div class="detail-row">
                <span class="detail-label">Điểm tích lũy ban đầu:</span>
                <span class="detail-val" style="color: #fbbf24;">${customer.loyaltyPoints} PTS</span>
            </div>
            <div class="detail-row">
                <span class="detail-label">Ngày kích hoạt thẻ:</span>
                <span class="detail-val">${card.issueDate}</span>
            </div>
            <%-- Tạm ẩn hiển thị thời hạn thẻ vì thẻ thành viên theo hạng (Standard/VIP/Diamond) là vô thời hạn.
                 Sẽ kích hoạt lại dòng này khi hệ thống phát triển thêm các thẻ ưu đãi theo độ tuổi như U22, Học sinh - Sinh viên.
            <div class="detail-row">
                <span class="detail-label">Thời hạn sử dụng:</span>
                <span class="detail-val" style="color: #34d399; font-weight: 600;">Vô thời hạn (Theo hạng thẻ)</span>
            </div>
            --%>
        </div>

        <!-- Nút Quay lại Cổng Hội Viên (CustomerLoginUI6.jsp) -->
        <div class="cta-group" style="margin-top: 20px;">
            <a href="CustomerLoginUI6.jsp" class="btn btn-cinema-primary" id="lnkGoHome" style="width: 100%; padding: 13px; text-decoration: none; justify-content: center;">
                <svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"/>
                </svg>
                Về Cổng Hội Viên
            </a>
        </div>
    </div>

</body>
</html>
