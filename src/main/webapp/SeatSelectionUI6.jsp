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
    <title>Sơ Đồ Chọn Ghế - SeatSelectionUI6</title>
    <link rel="stylesheet" href="css/style.css?v=3">
    <style>
        .seat-grid {
            display: grid;
            grid-template-columns: repeat(10, 1fr);
            gap: 8px;
            max-width: 800px;
            margin: 25px auto;
        }
        .seat-item {
            min-height: 50px;
            border-radius: var(--radius-sm);
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            font-size: 12px;
            font-weight: 700;
            cursor: pointer;
            border: 2px solid transparent;
            transition: all 0.2s;
            position: relative;
            padding: 4px;
        }
        .seat-available { background: #f8fafc; color: #1e293b; border-color: #cbd5e1; }
        .seat-available:hover { border-color: #2563eb; background: #e2e8f0; }
        .seat-available.vip { border-color: #f59e0b; background: #fef3c7; color: #92400e; font-weight: 700; }
        .seat-item.sweetbox {
            grid-column: span 2;
            min-height: 52px;
        }
        .seat-available.sweetbox { border-color: #f43f5e; background: #ffe4e6; color: #9f1239; font-weight: 700; }
        .seat-available.sweetbox:hover { background: #fecdd3; border-color: #e11d48; }
        .seat-selected { background: var(--primary-red) !important; color: white !important; border-color: #b91c1c !important; }
        .seat-sold { background: #e2e8f0; color: #94a3b8; cursor: not-allowed; border: 1px dashed #cbd5e1; }
        .seat-holding { background: #f59e0b !important; color: #ffffff !important; cursor: not-allowed; border: 1px solid #d97706 !important; }
        .screen-bar {
            width: 85%;
            height: 28px;
            background: #e2e8f0;
            margin: 10px auto 30px;
            border-radius: 4px;
            border: 1px solid #cbd5e1;
            text-align: center;
            font-size: 12px;
            color: #475569;
            line-height: 28px;
            letter-spacing: 3px;
            font-weight: 700;
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

    <div class="cinema-container" style="max-width: 950px; margin: 24px auto; text-align: center;">
        <div style="display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid var(--card-border); padding-bottom: 15px; margin-bottom: 20px; text-align: left;">
            <div>
                <h1 style="font-size: 20px; font-weight: 800; color: #0f172a;">${sessionScope.selectedMovie.title}</h1>
                <p style="font-size: 13px; color: var(--text-muted); margin-top: 4px;">
                    Phòng: ${sessionScope.selectedShowtime.room.name} &bull; Suất: <fmt:formatDate value="${sessionScope.selectedShowtime.startTime}" pattern="HH:mm (dd/MM)"/>
                </p>
            </div>
            <div>
                <a href="movie-consultation?action=selectMovie&movieId=${sessionScope.selectedMovie.id}" id="subBack" class="btn btn-secondary" style="text-decoration: none;">Chọn Suất Khác</a>
            </div>
        </div>

        <c:if test="${not empty errorMsg}">
            <div class="cinema-alert" id="errorMsg" style="margin-bottom: 20px; text-align: left;">
                <span>${errorMsg}</span>
            </div>
        </c:if>

        <div style="background: var(--card-bg); border: 1px solid var(--card-border); border-radius: var(--radius-md); padding: 25px;">
            <div class="screen-bar" id="outRoomScreen">MÀN HÌNH CHIẾU PHIM</div>

            <form action="seat-booking" method="POST" id="inSeatForm">
                <input type="hidden" name="action" value="holdSeats">
                <input type="hidden" name="showtimeId" value="${showtime.id}">

                <!-- Sơ đồ ghế (outSeatMatrix : Table) -->
                <div class="seat-grid" id="outSeatMatrix">
                    <c:set var="firstSweetbox" value="${null}" />
                    <c:forEach var="ss" items="${outSeatMatrix}">
                        <c:choose>
                            <c:when test="${ss.seat != null && ss.seat.seatType == 'SWEETBOX'}">
                                <c:choose>
                                    <c:when test="${empty firstSweetbox}">
                                        <c:set var="firstSweetbox" value="${ss}" />
                                    </c:when>
                                    <c:otherwise>
                                        <c:set var="ss1" value="${firstSweetbox}" />
                                        <c:set var="ss2" value="${ss}" />
                                        <c:set var="pairSold" value="${ss1.status == 'SOLD' || ss2.status == 'SOLD'}"/>
                                        <c:set var="pairHeldByMe" value="${!pairSold && ss1.status == 'HOLDING' && ss2.status == 'HOLDING' && ss1.holderSessionId == currentSessionId && ss2.holderSessionId == currentSessionId}"/>
                                        <c:set var="pairHeldByOther" value="${!pairSold && !pairHeldByMe && (ss1.status == 'HOLDING' || ss2.status == 'HOLDING')}"/>

                                        <div class="seat-item sweetbox ${pairSold ? 'seat-sold' : (pairHeldByOther ? 'seat-holding' : (pairHeldByMe ? 'seat-selected' : 'seat-available'))}" 
                                             onclick="toggleCouple(this)" title="Ghế Đôi Sweetbox (2 ghế làm 1)">
                                            <input type="checkbox" name="inSelectedSeats" value="${ss1.id}" data-price="${ss1.price}" data-code="${ss1.seat.seatNumber}" 
                                                   style="display:none;" ${pairSold || pairHeldByOther ? 'disabled' : ''} ${pairHeldByMe ? 'checked' : ''} />
                                            <input type="checkbox" name="inSelectedSeats" value="${ss2.id}" data-price="${ss2.price}" data-code="${ss2.seat.seatNumber}" 
                                                   style="display:none;" ${pairSold || pairHeldByOther ? 'disabled' : ''} ${pairHeldByMe ? 'checked' : ''} />
                                            <span style="font-weight: 800; font-size: 13px;">${ss1.seat.seatNumber} - ${ss2.seat.seatNumber}</span>
                                            <span style="font-size: 8px; font-weight: normal; opacity: 0.9;">
                                                ${pairSold ? 'Đã bán' : (pairHeldByOther ? 'Đang giữ' : (pairHeldByMe ? 'Bạn chọn' : 'Ghế Đôi'))}
                                            </span>
                                        </div>
                                        <c:set var="firstSweetbox" value="${null}" />
                                    </c:otherwise>
                                </c:choose>
                            </c:when>
                            <c:otherwise>
                                <c:set var="isSold" value="${ss.status == 'SOLD'}"/>
                                <c:set var="isHolding" value="${ss.status == 'HOLDING'}"/>
                                <c:set var="isHeldByMe" value="${ss.status == 'HOLDING' && not empty ss.holderSessionId && ss.holderSessionId == currentSessionId}"/>
                                <c:set var="isHeldByOther" value="${ss.status == 'HOLDING' && (empty ss.holderSessionId || ss.holderSessionId != currentSessionId)}"/>
                                <c:set var="isVip" value="${ss.seat != null && ss.seat.seatType == 'VIP'}"/>

                                <label class="seat-item ${isSold ? 'seat-sold' : (isHeldByOther ? 'seat-holding' : (isHeldByMe ? 'seat-selected' : 'seat-available'))} ${isVip ? 'vip' : ''}">
                                    <input type="checkbox" name="inSelectedSeats" value="${ss.id}" data-price="${ss.price}" data-code="${ss.seat.seatNumber}" 
                                           style="opacity:0; position:absolute;" ${isSold || isHeldByOther ? 'disabled' : ''} ${isHeldByMe ? 'checked' : ''} onchange="toggleSeat(this)"/>
                                    <span>${ss.seat.seatNumber}</span>
                                    <span style="font-size: 8px; font-weight: normal; opacity: 0.9;">
                                        ${isSold ? 'Đã bán' : (isHeldByOther ? 'Đang giữ' : (isHeldByMe ? 'Bạn chọn' : (isVip ? 'VIP' : 'Thường')))}
                                    </span>
                                </label>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                </div>

                <!-- Chú thích giá (outPriceLegend : Label) -->
                <div id="outPriceLegend" style="display: flex; justify-content: center; flex-wrap: wrap; gap: 20px; font-size: 13px; margin: 25px 0; color: #475569;">
                    <span><span style="display:inline-block; width:14px; height:14px; background:#f8fafc; border:1px solid #cbd5e1; border-radius:3px; vertical-align:middle;"></span> Ghế Thường (85.000đ)</span>
                    <span><span style="display:inline-block; width:14px; height:14px; background:#fef3c7; border:1px solid #f59e0b; border-radius:3px; vertical-align:middle;"></span> Ghế VIP (105.000đ)</span>
                    <span><span style="display:inline-block; width:26px; height:14px; background:#ffe4e6; border:1px solid #f43f5e; border-radius:3px; vertical-align:middle;"></span> Ghế Đôi Sweetbox (170.000đ/cặp)</span>
                    <span><span style="display:inline-block; width:14px; height:14px; background:#dc2626; border-radius:3px; vertical-align:middle;"></span> Đang chọn</span>
                    <span><span style="display:inline-block; width:14px; height:14px; background:#f59e0b; border:1px solid #d97706; border-radius:3px; vertical-align:middle;"></span> Đang giữ chỗ (Tạm giữ 10p)</span>
                    <span><span style="display:inline-block; width:14px; height:14px; background:#e2e8f0; border:1px dashed #cbd5e1; border-radius:3px; vertical-align:middle;"></span> Đã bán</span>
                </div>

                <!-- Tạm tính và tiếp tục -->
                <div style="background: #f8fafc; border: 1px solid var(--card-border); border-radius: var(--radius-md); padding: 18px 24px; display: flex; justify-content: space-between; align-items: center;">
                    <div style="text-align: left;">
                        <div style="font-size: 13.5px; color: #475569;">Ghế đã chọn: <strong id="lblSelectedSeats" style="color: #0f172a;">Chưa chọn</strong></div>
                        <div style="font-size: 14.5px; margin-top: 4px; color: #475569;">Tạm tính: <strong id="outTempTotal" style="color: #dc2626; font-size: 22px; font-weight: 800;">0 đ</strong></div>
                    </div>
                    <button type="submit" id="subContinue" class="btn btn-primary" style="padding: 12px 28px; font-size: 16px; opacity: 0.5;" disabled>
                        Tiếp Tục
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script>
        let selectedList = [];
        let totalAmount = 0;

        function toggleCouple(el) {
            if (el.classList.contains('seat-sold') || el.classList.contains('seat-holding')) return;
            const cbs = el.querySelectorAll('input[type="checkbox"]');
            if (cbs.length < 2) return;

            const isChecking = !cbs[0].checked;
            cbs[0].checked = isChecking;
            cbs[1].checked = isChecking;

            const code1 = cbs[0].getAttribute('data-code');
            const code2 = cbs[1].getAttribute('data-code');
            const price1 = parseFloat(cbs[0].getAttribute('data-price')) || 0;
            const price2 = parseFloat(cbs[1].getAttribute('data-price')) || 0;

            if (isChecking) {
                el.classList.add('seat-selected');
                if (!selectedList.includes(code1)) selectedList.push(code1);
                if (!selectedList.includes(code2)) selectedList.push(code2);
                totalAmount += (price1 + price2);
            } else {
                el.classList.remove('seat-selected');
                selectedList = selectedList.filter(c => c !== code1 && c !== code2);
                totalAmount -= (price1 + price2);
            }

            updateSummary();
        }

        function toggleSeat(cb) {
            const code = cb.getAttribute('data-code');
            const price = parseFloat(cb.getAttribute('data-price')) || 0;
            const parent = cb.parentElement;

            if (cb.checked) {
                if (!selectedList.includes(code)) selectedList.push(code);
                totalAmount += price;
                parent.classList.add('seat-selected');
            } else {
                selectedList = selectedList.filter(c => c !== code);
                totalAmount -= price;
                parent.classList.remove('seat-selected');
            }

            updateSummary();
        }

        function updateSummary() {
            document.getElementById('lblSelectedSeats').innerText = selectedList.length > 0 ? selectedList.join(', ') : 'Chưa chọn';
            document.getElementById('outTempTotal').innerText = Math.max(0, totalAmount).toLocaleString('vi-VN') + ' đ';

            const btn = document.getElementById('subContinue');
            if (selectedList.length > 0) {
                btn.removeAttribute('disabled');
                btn.style.opacity = '1';
                btn.style.cursor = 'pointer';
            } else {
                btn.setAttribute('disabled', 'true');
                btn.style.opacity = '0.5';
                btn.style.cursor = 'not-allowed';
            }
        }

        document.addEventListener('DOMContentLoaded', function() {
            document.querySelectorAll('input[name="inSelectedSeats"]:checked').forEach(function(cb) {
                const code = cb.getAttribute('data-code');
                const price = parseFloat(cb.getAttribute('data-price')) || 0;
                if (!selectedList.includes(code)) {
                    selectedList.push(code);
                    totalAmount += price;
                }
            });
            updateSummary();
        });
    </script>
</body>
</html>

