package controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.CustomerDAO6;
import dao.ShowtimeDAO6;
import dao.ShowtimeSeatDAO6;
import dao.TicketPriceDAO6;
import model.Customer;
import model.Showtime6;
import model.ShowtimeSeat6;
import model.TicketPrice6;

@WebServlet("/seat-booking")
public class SeatBookingServlet6 extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private ShowtimeSeatDAO6 seatDAO;
    private TicketPriceDAO6 priceDAO;
    private ShowtimeDAO6 showtimeDAO;
    private CustomerDAO6 customerDAO;

    @Override
    public void init() {
        seatDAO = new ShowtimeSeatDAO6();
        priceDAO = new TicketPriceDAO6();
        showtimeDAO = new ShowtimeDAO6();
        customerDAO = new CustomerDAO6();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("staff") == null) {
            response.sendRedirect("staff-login");
            return;
        }

        String action = request.getParameter("action");
        if ("cancel".equalsIgnoreCase(action)) {
            // Hủy giữ ghế hiện tại và quay về trang tư vấn phim
            releaseHeldSeats(session);
            response.sendRedirect("movie-consultation");
        } else if ("skipMember".equalsIgnoreCase(action)) {
            session = request.getSession();
            session.removeAttribute("customerMember");
            session.setAttribute("discountAmount", 0.0);
            Double tempTotal = (Double) session.getAttribute("tempTotal");
            session.setAttribute("finalTotal", tempTotal != null ? tempTotal : 0.0);
            response.sendRedirect("payment-ticket?action=showPaymentMethods");
        } else {
            showSeatMap(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("staff") == null) {
            response.sendRedirect("staff-login");
            return;
        }

        String action = request.getParameter("action");
        if ("holdSeats".equalsIgnoreCase(action)) {
            processHoldSeats(request, response);
        } else if ("applyMember".equalsIgnoreCase(action)) {
            processApplyMember(request, response);
        }
    }

    private void releaseHeldSeats(HttpSession session) {
        @SuppressWarnings("unchecked")
        List<ShowtimeSeat6> oldHeld = (List<ShowtimeSeat6>) session.getAttribute("heldSeats");
        if (oldHeld != null && !oldHeld.isEmpty()) {
            List<Integer> oldIds = new ArrayList<>();
            for (ShowtimeSeat6 s : oldHeld) {
                oldIds.add(s.getId());
            }
            seatDAO.releaseSeats(oldIds, session.getId());
            session.removeAttribute("heldSeats");
        }
    }

    private void showSeatMap(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String stParam = request.getParameter("showtimeId");
        int showtimeId = -1;
        HttpSession session = request.getSession();
        if (stParam != null && !stParam.trim().isEmpty()) {
            try {
                showtimeId = Integer.parseInt(stParam.trim());
            } catch (NumberFormatException e) {
                // Fallback to session
            }
        }
        if (showtimeId <= 0) {
            Showtime6 sessSt = (Showtime6) session.getAttribute("selectedShowtime");
            if (sessSt != null) {
                showtimeId = sessSt.getId();
            }
        }
        if (showtimeId <= 0) {
            response.sendRedirect("movie-consultation");
            return;
        }

        // Nếu thu ngân bấm quay lại từ màn hình sau để chọn lại ghế, giải phóng ghế cũ của session
        String resetParam = request.getParameter("reset");
        if ("true".equalsIgnoreCase(resetParam)) {
            releaseHeldSeats(session);
        }

        Showtime6 showtime = showtimeDAO.getById(showtimeId);
        List<ShowtimeSeat6> seatMap = seatDAO.getSeatMap(showtimeId);
        List<TicketPrice6> prices = priceDAO.getByShowtime(showtimeId);

        session.setAttribute("selectedShowtime", showtime);

        request.setAttribute("showtime", showtime);
        request.setAttribute("outSeatMatrix", seatMap);
        request.setAttribute("outSeatPrices", prices);
        request.setAttribute("currentSessionId", session.getId());

        RequestDispatcher dispatcher = request.getRequestDispatcher("SeatSelectionUI6.jsp");
        dispatcher.forward(request, response);
    }

    private void processHoldSeats(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Showtime6 showtime = (Showtime6) session.getAttribute("selectedShowtime");
        if (showtime == null) {
            response.sendRedirect("movie-consultation");
            return;
        }

        String[] selectedSeatIdsStr = request.getParameterValues("selectedSeats");
        if (selectedSeatIdsStr == null || selectedSeatIdsStr.length == 0) {
            selectedSeatIdsStr = request.getParameterValues("inSelectedSeats");
        }
        if (selectedSeatIdsStr == null || selectedSeatIdsStr.length == 0) {
            request.setAttribute("errorMsg", "Vui lòng chọn ít nhất 1 ghế trước khi tiếp tục!");
            showSeatMap(request, response);
            return;
        }

        List<Integer> seatIds = new ArrayList<>();
        try {
            for (String s : selectedSeatIdsStr) {
                seatIds.add(Integer.parseInt(s.trim()));
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMsg", "Dữ liệu ghế không hợp lệ!");
            showSeatMap(request, response);
            return;
        }

        // Sắp xếp danh sách seatIds tăng dần để chống deadlock giữa các quầy
        java.util.Collections.sort(seatIds);

        // Giải phóng các ghế cũ của session nếu trước đó đã giữ ghế khác
        releaseHeldSeats(session);

        // Khóa giữ ghế có kiểm tra Session Holder ID
        boolean success = seatDAO.holdSeats(seatIds, showtime.getId(), session.getId());
        if (!success) {
            request.setAttribute("errorMsg", "Ghế bạn chọn vừa có người đặt hoặc đang được quầy khác giữ chỗ. Vui lòng chọn lại!");
            showSeatMap(request, response);
            return;
        }

        // Tìm danh sách đối tượng ghế đã giữ để tính tiền
        List<ShowtimeSeat6> allSeats = seatDAO.getSeatMap(showtime.getId());
        List<ShowtimeSeat6> heldSeats = new ArrayList<>();
        double tempTotal = 0.0;
        for (ShowtimeSeat6 ss : allSeats) {
            if (seatIds.contains(ss.getId())) {
                heldSeats.add(ss);
                tempTotal += ss.getPrice();
            }
        }

        session.setAttribute("heldSeats", heldSeats);
        session.setAttribute("tempTotal", tempTotal);
        session.setAttribute("finalTotal", tempTotal);
        session.setAttribute("discountAmount", 0.0);
        session.setAttribute("customerMember", null);

        // Xóa sạch trạng thái của hóa đơn cũ trước đó để chuẩn bị cho đơn hàng mới
        session.removeAttribute("lastInvoiceId");
        session.removeAttribute("completedInvoice");
        session.removeAttribute("completedTickets");
        session.removeAttribute("checkoutToken");

        request.setAttribute("outBaseTotal", tempTotal);
        request.setAttribute("outFinalTotal", tempTotal);
        request.setAttribute("heldSeats", heldSeats);

        RequestDispatcher dispatcher = request.getRequestDispatcher("MemberDiscountUI6.jsp");
        dispatcher.forward(request, response);
    }

    private void processApplyMember(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Double tempTotal = (Double) session.getAttribute("tempTotal");
        if (tempTotal == null) tempTotal = 0.0;

        String cardNumber = request.getParameter("inCardNumber");
        Customer customer = customerDAO.getByCard(cardNumber);

        double discountRate = 0.0;
        double discountAmount = 0.0;
        double finalTotal = tempTotal;

        if (customer != null && customer.getCard() != null && customer.getCard().getTier() != null) {
            discountRate = customer.getCard().getTier().getDiscountRate();
            discountAmount = tempTotal * discountRate;
            finalTotal = Math.max(0.0, tempTotal - discountAmount);

            session.setAttribute("customerMember", customer);
            session.setAttribute("discountAmount", discountAmount);
            session.setAttribute("finalTotal", finalTotal);

            request.setAttribute("cus", customer);
            request.setAttribute("card", customer.getCard());
            request.setAttribute("outDiscountRate", discountRate);
        } else {
            session.removeAttribute("customerMember");
            session.setAttribute("discountAmount", 0.0);
            session.setAttribute("finalTotal", tempTotal);
            request.setAttribute("errorMsg", "Không tìm thấy thẻ thành viên hoặc số điện thoại này!");
        }

        request.setAttribute("outBaseTotal", tempTotal);
        request.setAttribute("outDiscountAmount", discountAmount);
        request.setAttribute("outFinalTotal", finalTotal);
        request.setAttribute("heldSeats", session.getAttribute("heldSeats"));

        RequestDispatcher dispatcher = request.getRequestDispatcher("MemberDiscountUI6.jsp");
        dispatcher.forward(request, response);
    }
}
