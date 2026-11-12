<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%
    if (session.getAttribute("staff") == null) {
        response.sendRedirect("staff-login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ưu Đãi Thành Viên - MemberDiscountUI6</title>
    <link rel="stylesheet" href="css/style.css?v=3">
</head>
<body style="display: block;">
    <!-- Thanh điều hướng POS -->
    <nav class="pos-topbar" style="width: 100%; background: #ffffff; border-bottom: 1px solid #e2e8f0; box-shadow: 0 1px 3px rgba(0,0,0,0.05); position: sticky; top: 0; z-index: 1000; font-family: 'Inter', -apple-system, sans-serif;">
        <div class="pos-topbar-container" style="max-width: 1200px; margin: 0 auto; height: 56px; padding: 0 20px; display: flex; align-items: center; justify-content: space-between;">
            <div class="pos-topbar-left" style="display: flex; align-items: center; gap: 12px;">
                <a href="movie-consultation" class="pos-topbar-brand" style="display: flex; align-items: center; gap: 8px; text-decoration: none; color: #0f172a; font-weight: 800; font-size: 16px;">
                    <span class="pos-tag-pos" style="background: #dc2626; color: #ffffff; font-size: 11px; font-weight: 800; padding: 2px 7px; border-radius: 4px; letter-spacing: 0.5px;">POS</span>
                    <span>CINEMA PREMIERE</span>
                </a>
                <span class="pos-counter-pill" style="background: #f1f5f9; color: #475569; font-size: 12px; padding: 3px 9px; border-radius: 6px; font-weight: 600; border: 1px solid #e2e8f0;">Quầy 01</span>
            </div>
            <div class="pos-topbar-right" style="display: flex; align-items: center; gap: 14px;">
                <div class="pos-user-badge" style="display: flex; align-items: center; gap: 6px; font-size: 13.5px; color: #475569; background: #f8fafc; padding: 5px 12px; border-radius: 20px; border: 1px solid #e2e8f0;">
                    <span>Thu ngân:</span>
                    <strong class="pos-user-name" style="color: #0f172a; font-weight: 700;">${sessionScope.staff != null ? sessionScope.staff.fullName : 'Thu Ngân'}</strong>
                    <span class="pos-user-code" style="color: #64748b; font-size: 12px;">(${sessionScope.staff != null ? sessionScope.staff.employeeCode : 'NV001'})</span>
                </div>
                <a href="staff-login?action=logout" class="pos-btn-logout" style="background: #ef4444; color: #ffffff; padding: 6px 14px; border-radius: 6px; font-size: 13px; font-weight: 600; text-decoration: none; display: inline-flex; align-items: center;" title="Đăng xuất khỏi ca trực">
                    Đăng Xuất
                </a>
            </div>
        </div>
    </nav>

    <div class="cinema-container" style="max-width: 680px; margin: 24px auto;">
        <div style="border-bottom: 1px solid var(--card-border); padding-bottom: 12px; margin-bottom: 20px;">
            <h1 style="font-size: 20px; font-weight: 700; color: #0f172a;">Thẻ Thành Viên & Chiết Khấu</h1>
        </div>

        <c:if test="${not empty errorMsg}">
            <div class="cinema-alert" style="margin-bottom: 20px;">
                <span>${errorMsg}</span>
            </div>
        </c:if>

        <div style="background: var(--card-bg); border: 1px solid var(--card-border); border-radius: var(--radius-md); padding: 24px;">
            <!-- Form quét thẻ (inMemberForm : Form) -->
            <form action="seat-booking" method="POST" id="inMemberForm" style="display: flex; gap: 10px; margin-bottom: 24px;">
                <input type="hidden" name="action" value="applyMember">
                <input type="text" class="input-control" id="inCardNumber" name="inCardNumber" value="${param.inCardNumber}" placeholder="Nhập số điện thoại hoặc quét mã thẻ..." required style="flex: 1;">
                <button type="submit" id="subApplyCard" class="btn btn-primary" style="padding: 0 24px;">Áp Dụng</button>
            </form>

            <!-- Thông tin thành viên nếu tìm thấy -->
            <c:if test="${not empty cus}">
                <div style="background: rgba(16, 185, 129, 0.12); border: 1px solid #10b981; border-radius: var(--radius-md); padding: 16px; margin-bottom: 24px;">
                    <div style="color: #10b981; font-weight: 700; font-size: 15px;">Xác thực thành viên: ${cus.fullName}</div>
                    <div style="font-size: 13px; margin-top: 6px; color: #cbd5e1;">
                        Số điện thoại: <strong>${cus.phoneNumber}</strong> &bull; Hạng thẻ: <strong>${card.tier.tierName}</strong> (Giảm <strong><fmt:formatNumber value="${card.tier.discountRate * 100}" maxFractionDigits="0"/>%</strong>) &bull; Điểm tích lũy: ${cus.loyaltyPoints} điểm
                    </div>
                </div>
            </c:if>

            <!-- Bảng tính tiền chi tiết -->
            <div style="background: var(--input-bg); border: 1px solid var(--input-border); border-radius: var(--radius-md); padding: 20px; margin-bottom: 24px;">
                <div style="display: flex; justify-content: space-between; margin-bottom: 10px; font-size: 14px;">
                    <span style="color: var(--text-muted);">Tiền vé tạm tính (${heldSeats != null ? heldSeats.size() : 0} ghế):</span>
                    <strong id="outBaseTotal"><fmt:formatNumber value="${outBaseTotal}" type="currency" currencySymbol="đ" maxFractionDigits="0"/></strong>
                </div>
                <div style="display: flex; justify-content: space-between; margin-bottom: 12px; font-size: 14px; color: #10b981;">
                    <span id="outDiscountRate">Ưu đãi giảm giá thành viên:</span>
                    <strong>-<fmt:formatNumber value="${outDiscountAmount}" type="currency" currencySymbol="đ" maxFractionDigits="0"/></strong>
                </div>
                <hr style="border: 0; border-top: 1px solid var(--input-border); margin: 10px 0;">
                <div style="display: flex; justify-content: space-between; font-size: 18px; margin-top: 8px;">
                    <span>Tổng tiền thanh toán:</span>
                    <strong id="outFinalTotal" style="color: #edc967; font-size: 24px;">
                        <fmt:formatNumber value="${outFinalTotal}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                    </strong>
                </div>
            </div>

            <!-- Nút điều hướng -->
            <div style="display: flex; justify-content: space-between; align-items: center;">
                <a href="seat-booking?action=showSeatMap&reset=true&showtimeId=${sessionScope.selectedShowtime.id}" id="subBack" class="btn btn-secondary" style="text-decoration: none;">Chọn Lại Ghế</a>
                <div style="display: flex; gap: 12px;">
                    <a href="seat-booking?action=skipMember" id="subSkip" class="btn btn-secondary" style="text-decoration: none;">Bỏ Qua Thẻ</a>
                    <a href="payment-ticket?action=showPaymentMethods" id="subContinuePayment" class="btn btn-primary" style="text-decoration: none; padding: 12px 24px;">
                        Tiếp Tục Thanh Toán
                    </a>
                </div>
            </div>
        </div>
    </div>
</body>
</html>

