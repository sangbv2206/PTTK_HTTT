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
    <title>Thanh Toán - PaymentUI6</title>
    <link rel="stylesheet" href="css/style.css?v=3">
    <style>
        .pay-method-card {
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            padding: 16px;
            cursor: pointer;
            background: #ffffff;
            transition: all 0.15s;
        }
        .pay-method-card.selected {
            border-color: #10b981;
            background: #f0fdf4;
        }
        .pay-detail-box {
            display: none;
            margin-top: 14px;
            padding: 16px;
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 6px;
        }
        .quick-cash-btn {
            background: #e2e8f0;
            color: #334155;
            border: 1px solid #cbd5e1;
            padding: 6px 12px;
            border-radius: 6px;
            font-size: 13px;
            cursor: pointer;
            transition: 0.15s;
        }
        .quick-cash-btn:hover {
            background: #cbd5e1;
            color: #0f172a;
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

    <div class="cinema-container" style="max-width: 650px; margin: 24px auto;">
        <div style="border-bottom: 1px solid var(--card-border); padding-bottom: 12px; margin-bottom: 20px;">
            <h1 style="font-size: 20px; font-weight: 700; color: #0f172a;">Thanh Toán & Xuất Vé</h1>
        </div>

        <div style="background: var(--card-bg); border: 1px solid var(--card-border); border-radius: var(--radius); padding: 25px;">
            <!-- Đồng hồ đếm ngược giữ chỗ 10 phút -->
            <div style="background: #fef2f2; border: 1px solid #fecaca; border-radius: 6px; padding: 10px 16px; margin-bottom: 20px; display: flex; align-items: center; justify-content: space-between;">
                <span style="font-size: 13.5px; font-weight: 600; color: #dc2626;">Thời gian giữ chỗ còn lại:</span>
                <div id="holdCountdown" style="font-family: monospace; font-size: 20px; font-weight: 700; color: #dc2626;">10:00</div>
            </div>

            <!-- Tổng tiền cần thu (outTotalAmount : Label) -->
            <div style="background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 6px; padding: 16px 20px; display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                <span style="font-size: 14.5px; color: #475569; font-weight: 600;">Số tiền cần thanh toán:</span>
                <strong id="outTotalAmount" style="color: #dc2626; font-size: 26px; font-weight: 800;">
                    <fmt:formatNumber value="${outFinalAmount}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                </strong>
            </div>

            <form action="payment-ticket" method="POST" id="inPaymentForm" onsubmit="return validatePayment();">
                <input type="hidden" name="action" value="confirmPayment">
                <input type="hidden" name="checkoutToken" value="${checkoutToken}">
                <input type="hidden" id="finalAmountValue" value="${outFinalAmount}">

                <!-- Các phương thức thanh toán -->
                <div style="display: grid; gap: 14px; margin-bottom: 20px;">
                    <c:forEach var="pm" items="${outPaymentMethods}" varStatus="loop">
                        <label class="pay-method-card ${loop.first ? 'selected' : ''}" id="card_method_${pm.id}" onclick="selectMethod(${pm.id})">
                            <div style="display: flex; align-items: center; gap: 14px;">
                                <input type="radio" name="inPaymentMethod" value="${pm.id}" ${loop.first ? 'checked' : ''} style="width: 18px; height: 18px; accent-color: #10b981;">
                                <div>
                                    <div style="font-weight: 700; font-size: 15px;">${pm.methodName}</div>
                                    <div style="font-size: 12px; color: var(--text-muted); margin-top: 2px;">${pm.description}</div>
                                </div>
                            </div>

                            <!-- Chi tiết cho Tiền mặt (ID 1) -->
                            <c:if test="${pm.id == 1}">
                                <div id="box_method_1" class="pay-detail-box" style="display: block;">
                                    <div style="margin-bottom: 10px;">
                                        <label style="font-size: 13px; color: #cbd5e1; display: block; margin-bottom: 6px;">Tiền khách đưa (VNĐ):</label>
                                        <input type="number" id="txtCashGiven" name="txtCashGiven" class="input-control" placeholder="Nhập số tiền khách đưa..." value="<fmt:formatNumber value='${outFinalAmount}' pattern='#' maxFractionDigits='0'/>" oninput="calcChange()">
                                    </div>
                                    <div style="display: flex; gap: 8px; margin-bottom: 12px;">
                                        <button type="button" class="quick-cash-btn" onclick="setCash(<fmt:formatNumber value='${outFinalAmount}' pattern='#' maxFractionDigits='0'/>)">Đúng tiền</button>
                                        <button type="button" class="quick-cash-btn" onclick="setCash(100000)">100.000đ</button>
                                        <button type="button" class="quick-cash-btn" onclick="setCash(200000)">200.000đ</button>
                                        <button type="button" class="quick-cash-btn" onclick="setCash(500000)">500.000đ</button>
                                    </div>
                                    <div style="font-size: 14px; padding-top: 8px; border-top: 1px dashed rgba(255,255,255,0.1); display: flex; justify-content: space-between;">
                                        <span>Tiền thừa trả khách:</span>
                                        <strong id="lblChange" style="color: #34d399; font-size: 16px;">0 đ</strong>
                                    </div>
                                </div>
                            </c:if>

                            <!-- Chi tiết cho Thẻ POS (ID 2) -->
                            <c:if test="${pm.id == 2}">
                                <div id="box_method_2" class="pay-detail-box">
                                    <div style="font-size: 13px; color: #cbd5e1; line-height: 1.6;">
                                        Vui lòng quẹt hoặc cắm thẻ ATM / Visa / MasterCard của khách hàng vào máy POS đặt tại quầy. Bấm xác nhận sau khi máy POS báo giao dịch thành công.
                                    </div>
                                </div>
                            </c:if>

                            <!-- Chi tiết cho Ví điện tử / QR Code (ID 3) -->
                            <c:if test="${pm.id == 3}">
                                <div id="box_method_3" class="pay-detail-box" style="text-align: center;">
                                    <div style="font-size: 13px; color: #cbd5e1; margin-bottom: 10px;">
                                        Khách hàng mở App Ngân hàng hoặc Ví VNPay / MoMo quét mã QR bên dưới:
                                    </div>
                                    <div style="background: white; padding: 12px; display: inline-block; border-radius: 8px; margin-bottom: 10px;">
                                        <img src="https://api.qrserver.com/v1/create-qr-code/?size=160x160&data=CINEMA_PREMIERE_POS_PAYMENT_${outFinalAmount}" alt="QR Pay" style="width: 140px; height: 140px; display: block;">
                                    </div>
                                    <div style="font-size: 12px; color: #94a3b8;">
                                        Trạng thái: <span style="color: #38bdf8; font-weight: 600;">Sẵn sàng nhận thanh toán</span>
                                    </div>
                                </div>
                            </c:if>
                        </label>
                    </c:forEach>
                </div>

                <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 25px;">
                    <a href="MemberDiscountUI6.jsp" id="subBack" class="btn btn-secondary" style="text-decoration: none;">Quay Lại</a>
                    <button type="submit" id="subConfirmPayment" class="btn btn-primary" style="padding: 14px 28px; font-size: 16px; background: #10b981; font-weight: 700;">
                        Xác Nhận Đã Nhận Tiền & In Vé
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function selectMethod(methodId) {
            document.querySelectorAll('.pay-method-card').forEach(c => c.classList.remove('selected'));
            document.querySelectorAll('.pay-detail-box').forEach(b => b.style.display = 'none');

            const card = document.getElementById('card_method_' + methodId);
            if (card) {
                card.classList.add('selected');
                const radio = card.querySelector('input[type="radio"]');
                if (radio) radio.checked = true;
            }

            const box = document.getElementById('box_method_' + methodId);
            if (box) box.style.display = 'block';

            if (methodId === 1) calcChange();
        }

        function setCash(val) {
            document.getElementById('txtCashGiven').value = val;
            calcChange();
        }

        function calcChange() {
            const finalAmount = parseFloat(document.getElementById('finalAmountValue').value) || 0;
            const cashGiven = parseFloat(document.getElementById('txtCashGiven').value) || 0;
            const change = cashGiven - finalAmount;
            const lbl = document.getElementById('lblChange');

            if (change < 0) {
                lbl.style.color = '#f87171';
                lbl.innerText = 'Thiếu ' + Math.abs(change).toLocaleString('vi-VN') + ' đ';
            } else {
                lbl.style.color = '#34d399';
                lbl.innerText = change.toLocaleString('vi-VN') + ' đ';
            }
        }

        function validatePayment() {
            const methodRadio = document.querySelector('input[name="inPaymentMethod"]:checked');
            if (methodRadio && methodRadio.value === '1') {
                const finalAmount = parseFloat(document.getElementById('finalAmountValue').value) || 0;
                const cashGiven = parseFloat(document.getElementById('txtCashGiven').value) || 0;
                if (cashGiven < finalAmount) {
                    alert('Số tiền khách đưa chưa đủ để thanh toán đơn hàng!');
                    return false;
                }
            }
            // Vô hiệu hóa nút bấm để chống double-click gửi 2 request song song
            const btn = document.getElementById('subConfirmPayment');
            if (btn) {
                btn.disabled = true;
                btn.innerText = 'Đang xử lý giao dịch...';
                btn.style.opacity = '0.7';
            }
            return true;
        }

        // Tự động tính tiền thừa ban đầu
        calcChange();

        // Đếm ngược thời gian giữ chỗ thanh toán 10 phút
        let remainingSeconds = ${holdRemainingSeconds != null ? holdRemainingSeconds : 600};
        const timerEl = document.getElementById('holdCountdown');
        const timerInterval = setInterval(function() {
            if (remainingSeconds <= 0) {
                clearInterval(timerInterval);
                if (timerEl) timerEl.innerText = "00:00";
                alert("Thời gian giữ chỗ thanh toán (10 phút) đã hết! Ghế đã được giải phóng tự động. Vui lòng chọn lại ghế.");
                window.location.href = "seat-booking?action=showSeatMap";
                return;
            }
            remainingSeconds--;
            const mins = Math.floor(remainingSeconds / 60);
            const secs = remainingSeconds % 60;
            if (timerEl) {
                timerEl.innerText = (mins < 10 ? '0' : '') + mins + ':' + (secs < 10 ? '0' : '') + secs;
            }
        }, 1000);
    </script>
</body>
</html>

