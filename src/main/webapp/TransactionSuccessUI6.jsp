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
    <title>Giao Dịch Thành Công - TransactionSuccessUI6</title>
    <link rel="stylesheet" href="css/style.css?v=3">
    <style>
        .ticket-receipt {
            background: white;
            color: #1e293b;
            border-radius: var(--radius-md);
            padding: 24px;
            max-width: 440px;
            margin: 0 auto;
            box-shadow: 0 15px 35px rgba(0,0,0,0.5);
            border: 2px dashed #94a3b8;
            text-align: left;
        }
        @media print {
            body { background: white !important; padding: 0 !important; }
            .cinema-container { max-width: 100% !important; margin: 0 !important; }
            h1, p, .cinema-alert, .action-buttons { display: none !important; }
            .ticket-receipt { box-shadow: none !important; border: 1px dashed #000 !important; width: 100% !important; max-width: 380px !important; margin: 0 auto !important; }
        }
    </style>
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

    <div class="cinema-container" style="max-width: 580px; margin: 24px auto; text-align: center;">
        <h1 style="color: #10b981; font-size: 20px; font-weight: 700; margin-bottom: 20px;">BÁN VÉ THÀNH CÔNG</h1>

        <c:if test="${not empty printSuccessMsg}">
            <div class="cinema-alert" style="margin-bottom: 20px; background: rgba(16, 185, 129, 0.2); border-color: #10b981; color: #10b981;">
                <span>${printSuccessMsg}</span>
            </div>
        </c:if>

        <!-- Phiếu hóa đơn / vé in nhiệt (outInvoiceInfo & outTicketList) -->
        <jsp:useBean id="now" class="java.util.Date" />
        <div class="ticket-receipt" id="outInvoiceInfo">
            <div style="text-align: center; border-bottom: 2px dashed #cbd5e1; padding-bottom: 12px; margin-bottom: 16px;">
                <div style="font-weight: 800; font-size: 16px; color: var(--primary-red); text-transform: uppercase;">CINEMA PREMIERE QUỐC GIA</div>
                <div style="font-size: 11px; color: #64748b; margin-top: 2px;">VÉ XEM PHIM & HÓA ĐƠN ĐIỆN TỬ</div>
                <div style="font-size: 12px; font-weight: 700; margin-top: 6px;">
                    Mã HĐ: #INV-${sessionScope.completedInvoice != null ? sessionScope.completedInvoice.id : '2026-001'}
                </div>
                <div style="font-size: 12px; color: #475569; margin-top: 3px;">
                    Thời gian xuất: <fmt:formatDate value="${sessionScope.completedInvoice != null && sessionScope.completedInvoice.createdAt != null ? sessionScope.completedInvoice.createdAt : now}" pattern="HH:mm:ss (dd/MM/yyyy)"/>
                </div>
            </div>

            <div style="font-size: 13px; line-height: 1.9;">
                <div><strong>Phim:</strong> ${sessionScope.selectedMovie.title}</div>
                <div><strong>Suất chiếu:</strong> <fmt:formatDate value="${sessionScope.selectedShowtime.startTime}" pattern="HH:mm (dd/MM/yyyy)"/></div>
                <div><strong>Phòng chiếu:</strong> ${sessionScope.selectedShowtime.room.name} (${sessionScope.selectedShowtime.format})</div>
                
                <div style="margin: 8px 0; padding: 8px 0; border-top: 1px dashed #e2e8f0; border-bottom: 1px dashed #e2e8f0;">
                    <div><strong>Ghế đã mua:</strong>
                        <c:forEach var="t" items="${sessionScope.completedTickets}" varStatus="loop">
                            <span style="font-weight: 800; color: var(--primary-red); font-size: 15px;">${t.showtimeSeat.seat.seatNumber}</span>${!loop.last ? ', ' : ''}
                        </c:forEach>
                    </div>
                </div>

                <div><strong>Tổng tiền vé:</strong> <fmt:formatNumber value="${sessionScope.completedInvoice.totalAmount}" type="currency" currencySymbol="đ" maxFractionDigits="0"/></div>
                <div><strong>Giảm giá thành viên:</strong> -<fmt:formatNumber value="${sessionScope.completedInvoice.discountAmount}" type="currency" currencySymbol="đ" maxFractionDigits="0"/></div>
                <div><strong>Thực thu:</strong> <strong style="font-size: 17px; color: var(--primary-red);"><fmt:formatNumber value="${sessionScope.completedInvoice.finalAmount}" type="currency" currencySymbol="đ" maxFractionDigits="0"/></strong></div>
                <c:if test="${sessionScope.cashGiven > 0}">
                    <div><strong>Tiền khách đưa:</strong> <fmt:formatNumber value="${sessionScope.cashGiven}" type="currency" currencySymbol="đ" maxFractionDigits="0"/></div>
                    <div><strong>Tiền thừa trả khách:</strong> <strong style="color: #10b981;"><fmt:formatNumber value="${sessionScope.cashChange}" type="currency" currencySymbol="đ" maxFractionDigits="0"/></strong></div>
                </c:if>
                <div><strong>Thu ngân:</strong> ${sessionScope.staff != null ? sessionScope.staff.fullName : (sessionScope.completedInvoice.staff != null ? sessionScope.completedInvoice.staff.fullName : 'Nguyễn Văn Thu Ngân')} (Mã NV: <strong>${sessionScope.staff != null ? sessionScope.staff.employeeCode : (sessionScope.completedInvoice.staff != null ? sessionScope.completedInvoice.staff.employeeCode : 'NV001')}</strong>)</div>
            </div>

            <div style="text-align: center; margin-top: 18px; padding-top: 12px; border-top: 2px dashed #cbd5e1;">
                <div style="font-family: monospace; font-size: 12px; background: #f1f5f9; padding: 6px; border-radius: 4px; display: inline-block;">
                    ||| | ||||| ||| |||| |||||||| ||||| [QR_TICKET_VALID]
                </div>
                <div style="font-size: 11px; color: #64748b; margin-top: 4px;">Quét mã tại cửa soát vé để vào phòng chiếu</div>
            </div>
        </div>

        <!-- Các nút thao tác -->
        <div class="action-buttons" style="display: flex; justify-content: center; gap: 14px; margin-top: 25px;">
            <form action="payment-ticket" method="GET" style="display: inline;" onsubmit="setTimeout(function(){ window.print(); }, 200);">
                <input type="hidden" name="action" value="printTicket">
                <button type="submit" id="subPrint" class="btn btn-primary" style="padding: 12px 24px; font-weight: 700;">
                    In Vé & Hóa Đơn
                </button>
            </form>
            <a href="movie-consultation" id="subGoHome" class="btn btn-secondary" style="padding: 12px 24px; text-decoration: none; font-weight: 700;">
                Quay Về Danh Sách Phim (Bán Lượt Mới)
            </a>
        </div>
    </div>
</body>
</html>

