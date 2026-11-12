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
    <title>Chọn Suất Chiếu - ShowtimeSelectionUI6</title>
    <link rel="stylesheet" href="css/style.css?v=3">
    <style>
        .date-filter-bar {
            display: flex;
            gap: 8px;
            overflow-x: auto;
            padding-bottom: 12px;
            margin-bottom: 16px;
            border-bottom: 1px solid #e2e8f0;
        }
        .date-pill {
            padding: 7px 14px;
            border-radius: 6px;
            background: #f1f5f9;
            color: #475569;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            border: 1px solid #cbd5e1;
            white-space: nowrap;
            transition: all 0.15s;
        }
        .date-pill:hover {
            background: #e2e8f0;
            color: #0f172a;
        }
        .date-pill.active {
            background: #dc2626 !important;
            color: #ffffff !important;
            border-color: #dc2626 !important;
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

    <div class="cinema-container" style="max-width: 950px; margin: 24px auto;">
        <div style="display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid var(--card-border); padding-bottom: 15px; margin-bottom: 20px;">
            <div>
                <h1 id="outMovieTitle" style="font-size: 20px; font-weight: 800; color: #0f172a;">
                    Lịch Chiếu: <span style="color: var(--primary-red);">${movie != null ? movie.title : sessionScope.selectedMovie.title}</span>
                </h1>
            </div>
            <div>
                <a href="movie-consultation?action=list" id="subBack" class="btn btn-secondary" style="text-decoration: none;">Chọn Phim Khác</a>
            </div>
        </div>

        <div style="background: var(--card-bg); border: 1px solid var(--card-border); border-radius: var(--radius); padding: 20px;">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px;">
                <h3 style="font-size: 15px; font-weight: 700; color: #0f172a;">Chọn Ngày Xem:</h3>
                <span style="font-size: 13px; color: var(--text-muted);">Hiển thị toàn bộ lịch chiếu sắp tới</span>
            </div>

            <c:choose>
                <c:when test="${not empty outShowtimeList}">
                    <!-- Thanh Tab Lọc Ngày Chiếu Nhanh -->
                    <div class="date-filter-bar" id="dateFilterBar">
                        <button type="button" class="date-pill active" onclick="filterByDate('ALL', this)">Tất Cả Ngày</button>
                        <c:set var="prevDate" value="" />
                        <c:forEach var="st" items="${outShowtimeList}">
                            <fmt:formatDate var="curDate" value="${st.startTime}" pattern="yyyy-MM-dd"/>
                            <fmt:formatDate var="displayDate" value="${st.startTime}" pattern="dd/MM (EEEE)"/>
                            <c:if test="${curDate != prevDate}">
                                <button type="button" class="date-pill" onclick="filterByDate('${curDate}', this)">
                                    ${displayDate}
                                </button>
                                <c:set var="prevDate" value="${curDate}" />
                            </c:if>
                        </c:forEach>
                    </div>

                    <table id="outShowtimeList" style="width: 100%; border-collapse: collapse; text-align: left;">
                        <thead>
                            <tr style="border-bottom: 2px solid #e2e8f0; color: #475569; font-size: 12.5px;">
                                <th style="padding: 12px;">GIỜ & NGÀY CHIẾU</th>
                                <th style="padding: 12px;">PHÒNG CHIẾU</th>
                                <th style="padding: 12px;">ĐỊNH DẠNG</th>
                                <th style="padding: 12px;">SỨC CHỨA</th>
                                <th style="padding: 12px; text-align: right;">THAO TÁC</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="st" items="${outShowtimeList}">
                                <fmt:formatDate var="stDate" value="${st.startTime}" pattern="yyyy-MM-dd"/>
                                <tr class="showtime-row" data-date="${stDate}" style="border-bottom: 1px solid #e2e8f0;">
                                    <td style="padding: 13px 12px;">
                                        <strong style="font-size: 16px; color: #dc2626;">
                                            <fmt:formatDate value="${st.startTime}" pattern="HH:mm"/>
                                        </strong>
                                        <span style="font-size: 13px; color: #475569; margin-left: 8px; font-weight: 500;">
                                            (<fmt:formatDate value="${st.startTime}" pattern="dd/MM/yyyy"/>)
                                        </span>
                                    </td>
                                    <td style="padding: 13px 12px; font-weight: 500;">
                                        ${st.room != null ? st.room.name : 'Phòng 01'}
                                    </td>
                                    <td style="padding: 13px 12px;">
                                        <span class="pos-counter-pill" style="font-weight: 700; color: #0f172a;">${st.format}</span>
                                    </td>
                                    <td style="padding: 13px 12px; color: var(--text-muted);">
                                        ${st.room != null ? st.room.capacity : 80} ghế
                                    </td>
                                    <td style="padding: 13px 12px; text-align: right;">
                                        <form action="seat-booking" method="GET" style="display: inline;">
                                            <input type="hidden" name="action" value="showSeatMap">
                                            <input type="hidden" name="showtimeId" value="${st.id}">
                                            <button type="submit" class="btn btn-primary" id="subSelectShowtime" style="padding: 8px 18px; font-size: 13.5px; font-weight: 600;">
                                                Chọn Ghế
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>

                    <!-- Thanh Phân Trang Lịch Chiếu (Pagination) -->
                    <div id="showtimePagination" style="display: flex; justify-content: center; align-items: center; margin-top: 20px; padding-top: 15px; border-top: 1px solid var(--card-border);">
                        <div id="showtimePageControls" style="display: flex; gap: 6px; align-items: center;"></div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div style="text-align: center; padding: 30px; color: var(--text-muted);">
                        <p>Hiện tại chưa có suất chiếu khả dụng cho bộ phim này!</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <script>
        const SHOWTIMES_PER_PAGE = 8;
        let currentShowtimePage = 1;
        let activeDateFilter = 'ALL';

        function getFilteredRows() {
            const rows = Array.from(document.querySelectorAll('.showtime-row'));
            if (activeDateFilter === 'ALL') {
                return rows;
            }
            return rows.filter(r => r.getAttribute('data-date') === activeDateFilter);
        }

        function renderShowtimePagination() {
            const allRows = document.querySelectorAll('.showtime-row');
            const matchingRows = getFilteredRows();
            const totalItems = matchingRows.length;
            const totalPages = Math.ceil(totalItems / SHOWTIMES_PER_PAGE) || 1;

            if (currentShowtimePage > totalPages) currentShowtimePage = totalPages;
            if (currentShowtimePage < 1) currentShowtimePage = 1;

            // Ẩn toàn bộ các hàng trước
            allRows.forEach(r => r.style.display = 'none');

            // Hiển thị các hàng của trang hiện tại
            const startIndex = (currentShowtimePage - 1) * SHOWTIMES_PER_PAGE;
            const endIndex = Math.min(startIndex + SHOWTIMES_PER_PAGE, totalItems);
            for (let i = startIndex; i < endIndex; i++) {
                matchingRows[i].style.display = '';
            }

            const controlsEl = document.getElementById('showtimePageControls');
            const containerEl = document.getElementById('showtimePagination');

            if (!containerEl) return;

            if (totalItems === 0 || totalPages <= 1) {
                containerEl.style.display = 'none';
                return;
            }
            containerEl.style.display = 'flex';

            let html = '';
            // Nút Trước
            if (currentShowtimePage > 1) {
                html += '<button type="button" onclick="goToPage(' + (currentShowtimePage - 1) + ')" style="padding: 6px 14px; background: #ffffff; border: 1px solid var(--card-border); border-radius: 6px; color: #0f172a; font-size: 13px; font-weight: 600; cursor: pointer;">&laquo; Trước</button>';
            } else {
                html += '<span style="padding: 6px 14px; background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 6px; color: #94a3b8; font-size: 13px; cursor: not-allowed;">&laquo; Trước</span>';
            }

            // Các nút số trang
            for (let p = 1; p <= totalPages; p++) {
                if (p === currentShowtimePage) {
                    html += '<span style="padding: 6px 13px; background: #dc2626; color: #ffffff; border-radius: 6px; font-size: 13px; font-weight: 700; border: 1px solid #dc2626;">' + p + '</span>';
                } else {
                    html += '<button type="button" onclick="goToPage(' + p + ')" style="padding: 6px 13px; background: #ffffff; border: 1px solid var(--card-border); border-radius: 6px; color: #0f172a; font-size: 13px; font-weight: 600; cursor: pointer;">' + p + '</button>';
                }
            }

            // Nút Sau
            if (currentShowtimePage < totalPages) {
                html += '<button type="button" onclick="goToPage(' + (currentShowtimePage + 1) + ')" style="padding: 6px 14px; background: #ffffff; border: 1px solid var(--card-border); border-radius: 6px; color: #0f172a; font-size: 13px; font-weight: 600; cursor: pointer;">Sau &raquo;</button>';
            } else {
                html += '<span style="padding: 6px 14px; background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 6px; color: #94a3b8; font-size: 13px; cursor: not-allowed;">Sau &raquo;</span>';
            }

            controlsEl.innerHTML = html;
        }

        function goToPage(page) {
            currentShowtimePage = page;
            renderShowtimePagination();
        }

        function filterByDate(dateStr, btnElement) {
            document.querySelectorAll('.date-pill').forEach(function(pill) {
                pill.classList.remove('active');
            });
            btnElement.classList.add('active');
            activeDateFilter = dateStr;
            currentShowtimePage = 1;
            renderShowtimePagination();
        }

        // Tự động phân trang khi trang tải xong
        document.addEventListener('DOMContentLoaded', function() {
            renderShowtimePagination();
        });
    </script>
</body>
</html>
