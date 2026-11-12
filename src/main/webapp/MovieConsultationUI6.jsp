<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
    <title>Tư Vấn & Tìm Kiếm Phim - MovieConsultationUI6</title>
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

    <div class="cinema-container" style="max-width: 1100px; margin: 24px auto;">
        <!-- Header trang -->
        <div style="border-bottom: 1px solid var(--card-border); padding-bottom: 12px; margin-bottom: 20px;">
            <h1 style="font-size: 20px; font-weight: 800; color: #0f172a;">Danh Sách Phim Đang Chiếu</h1>
        </div>

        <!-- Form tìm kiếm (inSearchForm : Form) -->
        <form action="movie-consultation" method="GET" id="inSearchForm" style="display: flex; gap: 12px; margin-bottom: 25px; background: #f8fafc; padding: 16px; border-radius: var(--radius); border: 1px solid var(--card-border);">
            <input type="hidden" name="action" value="search">
            <div style="flex: 2;">
                <input type="text" class="input-control" id="inKeyword" name="inKeyword" value="${inKeyword}" placeholder="Nhập tên phim, đạo diễn hoặc tên diễn viên...">
            </div>
            <div style="flex: 1;">
                <select class="input-control" id="inGenre" name="inGenre">
                    <option value="">-- Tất cả thể loại --</option>
                    <option value="Hành động" ${inGenre == 'Hành động' ? 'selected' : ''}>Hành động</option>
                    <option value="Tình cảm" ${inGenre == 'Tình cảm' ? 'selected' : ''}>Tình cảm / Tâm lý</option>
                    <option value="Chiến tranh" ${inGenre == 'Chiến tranh' ? 'selected' : ''}>Chiến tranh / Lịch sử</option>
                    <option value="Khoa học" ${inGenre == 'Khoa học' ? 'selected' : ''}>Khoa học viễn tưởng</option>
                </select>
            </div>
            <button type="submit" id="subSearch" class="btn btn-primary" style="padding: 0 24px;">Tìm Kiếm</button>
            <a href="movie-consultation?action=list" class="btn btn-secondary" style="text-decoration: none; padding: 0 16px; display: flex; align-items: center;">Đặt lại</a>
        </form>

        <!-- Bảng danh sách phim (outMovieList : Table) -->
        <c:choose>
            <c:when test="${not empty outMovieList}">
                <div id="outMovieList" style="display: grid; grid-template-columns: repeat(auto-fill, minmax(290px, 1fr)); gap: 20px;">
                    <c:forEach var="movie" items="${outMovieList}">
                        <div style="background: var(--card-bg); border: 1px solid var(--card-border); border-radius: var(--radius); padding: 18px; display: flex; flex-direction: column; justify-content: space-between; overflow: hidden; box-shadow: 0 1px 3px rgba(0,0,0,0.05);">
                            <div>
                                <div style="width: 100%; height: 320px; border-radius: 6px; overflow: hidden; margin-bottom: 12px; background: #e2e8f0;">
                                    <c:choose>
                                        <c:when test="${not empty movie.poster}">
                                            <img src="${movie.poster}" alt="${movie.title}" style="width: 100%; height: 100%; object-fit: cover;" onerror="this.onerror=null; this.src='https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?w=500';">
                                        </c:when>
                                        <c:otherwise>
                                            <img src="https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?w=500" alt="${movie.title}" style="width: 100%; height: 100%; object-fit: cover;">
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <span class="brand-badge" style="font-size: 11px; margin-bottom: 8px;">${movie.genre}</span>
                                <h3 style="font-size: 17px; margin-bottom: 6px; color: #0f172a; font-weight: 700;">${movie.title}</h3>
                                <p style="font-size: 13px; color: var(--text-muted); margin-bottom: 4px;">Thời lượng: <strong style="color: #0f172a;">${movie.duration} phút</strong></p>
                                <p style="font-size: 13px; color: var(--text-muted); margin-bottom: 6px;">Đạo diễn: ${movie.director != null ? movie.director : 'Đang cập nhật'}</p>
                                <p style="font-size: 12px; color: var(--text-muted); margin-bottom: 14px;">Diễn viên: ${movie.cast != null ? movie.cast : 'Đang cập nhật'}</p>
                            </div>
                            <form action="movie-consultation" method="GET">
                                <input type="hidden" name="action" value="selectMovie">
                                <input type="hidden" name="movieId" value="${movie.id}">
                                <button type="submit" class="btn btn-primary" style="width: 100%; padding: 11px; font-weight: 600;">
                                    Chọn Suất Chiếu
                                </button>
                            </form>
                        </div>
                    </c:forEach>
                </div>

                <!-- Thanh Phân Trang (Pagination) -->
                <c:if test="${totalPages > 1}">
                    <div style="display: flex; justify-content: center; align-items: center; margin-top: 25px; padding-top: 15px; border-top: 1px solid var(--card-border);">
                        <div style="display: flex; gap: 6px; align-items: center;">
                            <!-- Nút Trang trước -->
                            <c:choose>
                                <c:when test="${currentPage > 1}">
                                    <a href="movie-consultation?action=${not empty inKeyword or not empty inGenre ? 'search' : 'list'}&page=${currentPage - 1}&inKeyword=${inKeyword}&inGenre=${inGenre}" 
                                       style="padding: 6px 14px; background: #ffffff; border: 1px solid var(--card-border); border-radius: 6px; color: #0f172a; text-decoration: none; font-size: 13px; font-weight: 600;">
                                        &laquo; Trước
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <span style="padding: 6px 14px; background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 6px; color: #94a3b8; font-size: 13px; cursor: not-allowed;">
                                        &laquo; Trước
                                    </span>
                                </c:otherwise>
                            </c:choose>

                            <!-- Danh sách các số trang -->
                            <c:forEach var="p" begin="1" end="${totalPages}">
                                <c:choose>
                                    <c:when test="${p == currentPage}">
                                        <span style="padding: 6px 13px; background: #dc2626; color: #ffffff; border-radius: 6px; font-size: 13px; font-weight: 700; border: 1px solid #dc2626;">
                                            ${p}
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="movie-consultation?action=${not empty inKeyword or not empty inGenre ? 'search' : 'list'}&page=${p}&inKeyword=${inKeyword}&inGenre=${inGenre}" 
                                           style="padding: 6px 13px; background: #ffffff; border: 1px solid var(--card-border); border-radius: 6px; color: #0f172a; text-decoration: none; font-size: 13px; font-weight: 600;">
                                            ${p}
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>

                            <!-- Nút Trang sau -->
                            <c:choose>
                                <c:when test="${currentPage < totalPages}">
                                    <a href="movie-consultation?action=${not empty inKeyword or not empty inGenre ? 'search' : 'list'}&page=${currentPage + 1}&inKeyword=${inKeyword}&inGenre=${inGenre}" 
                                       style="padding: 6px 14px; background: #ffffff; border: 1px solid var(--card-border); border-radius: 6px; color: #0f172a; text-decoration: none; font-size: 13px; font-weight: 600;">
                                        Sau &raquo;
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <span style="padding: 6px 14px; background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 6px; color: #94a3b8; font-size: 13px; cursor: not-allowed;">
                                        Sau &raquo;
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </c:if>
            </c:when>
            <c:otherwise>
                <div style="text-align: center; padding: 40px; color: var(--text-muted);">
                    <p style="font-size: 16px;">Không tìm thấy bộ phim nào phù hợp với yêu cầu tìm kiếm!</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</body>
</html>

