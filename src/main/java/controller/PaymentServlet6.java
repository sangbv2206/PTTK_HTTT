package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.CustomerDAO6;
import dao.DAO;
import dao.InvoiceDAO6;
import dao.MembershipTierDAO6;
import dao.PaymentMethodDAO6;
import dao.ShowtimeSeatDAO6;
import dao.TicketDAO6;
import model.Customer;
import model.Invoice6;
import model.PaymentMethod6;
import model.SalesStaff;
import model.ShowtimeSeat6;
import model.Ticket6;

@WebServlet("/payment-ticket")
public class PaymentServlet6 extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private PaymentMethodDAO6 paymentDAO;
    private InvoiceDAO6 invoiceDAO;
    private TicketDAO6 ticketDAO;
    private ShowtimeSeatDAO6 seatDAO;
    private CustomerDAO6 customerDAO;
    private MembershipTierDAO6 tierDAO;

    @Override
    public void init() {
        paymentDAO = new PaymentMethodDAO6();
        invoiceDAO = new InvoiceDAO6();
        ticketDAO = new TicketDAO6();
        seatDAO = new ShowtimeSeatDAO6();
        customerDAO = new CustomerDAO6();
        tierDAO = new MembershipTierDAO6();
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
        if ("success".equalsIgnoreCase(action)) {
            showSuccess(request, response);
        } else if ("printTicket".equalsIgnoreCase(action)) {
            processPrint(request, response);
        } else {
            showPayment(request, response);
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
        if ("confirmPayment".equalsIgnoreCase(action)) {
            processPayment(request, response);
        } else {
            doGet(request, response);
        }
    }

    /**
     * Hiển thị màn hình phương thức thanh toán và kiểm tra thời hạn giữ ghế
     */
    private void showPayment(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        @SuppressWarnings("unchecked")
        List<ShowtimeSeat6> heldSeats = (List<ShowtimeSeat6>) session.getAttribute("heldSeats");
        if (heldSeats == null || heldSeats.isEmpty()) {
            response.sendRedirect("movie-consultation");
            return;
        }

        List<Integer> seatIds = extractSeatIds(heldSeats);
        if (!seatDAO.isHoldValid(seatIds, session.getId())) {
            clearCartSession(session);
            request.setAttribute("errorMsg", "Thời gian giữ chỗ (10 phút) đã hết! Ghế đã được nhả tự động, vui lòng chọn lại ghế.");
            request.getRequestDispatcher("seat-booking?action=showSeatMap").forward(request, response);
            return;
        }

        seatDAO.extendHoldTime(seatIds, session.getId());

        String checkoutToken = UUID.randomUUID().toString();
        session.setAttribute("checkoutToken", checkoutToken);

        Double finalTotal = (Double) session.getAttribute("finalTotal");
        request.setAttribute("holdRemainingSeconds", 600);
        request.setAttribute("checkoutToken", checkoutToken);
        request.setAttribute("outPaymentMethods", paymentDAO.getAll());
        request.setAttribute("outFinalAmount", Math.round(finalTotal != null ? finalTotal : 0.0));

        request.getRequestDispatcher("PaymentUI6.jsp").forward(request, response);
    }

    /**
     * Xử lý thanh toán an toàn: Token, Transaction ACID 6 bước và Post-Redirect-Get
     */
    private void processPayment(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();

        // 1. Kiểm tra Token chống double-click
        String formToken = request.getParameter("checkoutToken");
        String sessionToken = (String) session.getAttribute("checkoutToken");
        if (formToken == null || !formToken.equals(sessionToken)) {
            if (session.getAttribute("lastInvoiceId") != null) {
                response.sendRedirect("payment-ticket?action=success");
            } else {
                response.sendRedirect("movie-consultation");
            }
            return;
        }
        session.removeAttribute("checkoutToken");

        @SuppressWarnings("unchecked")
        List<ShowtimeSeat6> heldSeats = (List<ShowtimeSeat6>) session.getAttribute("heldSeats");
        SalesStaff staff = (SalesStaff) session.getAttribute("staff");
        Customer customer = (Customer) session.getAttribute("customerMember");

        if (heldSeats == null || heldSeats.isEmpty() || staff == null) {
            response.sendRedirect("movie-consultation");
            return;
        }

        // 2. Tính toán tiền tại server
        long baseTotal = 0L;
        List<Integer> seatIds = new ArrayList<>();
        for (ShowtimeSeat6 ss : heldSeats) {
            baseTotal += Math.round(ss.getPrice());
            seatIds.add(ss.getId());
        }

        long discountAmount = 0L;
        if (customer != null && customer.getCard() != null && customer.getCard().getTier() != null) {
            discountAmount = Math.round(baseTotal * customer.getCard().getTier().getDiscountRate());
        }
        long amountToPay = Math.max(0L, baseTotal - discountAmount);

        // 3. Xử lý phương thức thanh toán và tiền khách đưa
        int methodId = parseMethodId(request.getParameter("inPaymentMethod"));
        long cashGiven = amountToPay;
        long change = 0L;

        if (methodId == PaymentMethod6.METHOD_CASH) {
            cashGiven = parseCash(request.getParameter("txtCashGiven"), amountToPay);
            if (cashGiven < amountToPay) {
                session.setAttribute("checkoutToken", formToken);
                request.setAttribute("errorMsg", "Số tiền khách đưa (" + cashGiven + " VNĐ) chưa đủ để thanh toán (" + amountToPay + " VNĐ)!");
                showPayment(request, response);
                return;
            }
            change = cashGiven - amountToPay;
        }

        // 4. Thực thi Transaction ACID 6 bước
        int createdInvoiceId = -1;
        Invoice6 invoice = new Invoice6();
        List<Ticket6> tickets;

        try (Connection con = DAO.getNewConnection()) {
            con.setAutoCommit(false);
            try {
                // Bước 1: Đổi trạng thái ghế sang SOLD
                if (!seatDAO.markSeatsAsSold(con, seatIds, session.getId())) {
                    throw new SQLException("Ghế giữ chỗ đã hết hạn hoặc có tranh chấp!");
                }

                // Bước 2: Tạo hóa đơn
                invoice.setTotalAmount(baseTotal);
                invoice.setDiscountAmount(discountAmount);
                invoice.setFinalAmount(amountToPay);
                invoice.setCreatedAt(new Timestamp(System.currentTimeMillis()));
                invoice.setCustomer(customer);
                invoice.setStaff(staff);
                invoice.setPaymentMethod(new PaymentMethod6(methodId, "Selected", ""));

                createdInvoiceId = invoiceDAO.createInvoice(con, invoice);
                if (createdInvoiceId <= 0) {
                    throw new SQLException("Lỗi sinh mã hóa đơn!");
                }
                invoice.setId(createdInvoiceId);

                // Bước 3: Ghi nhận thanh toán
                paymentDAO.recordPayment(con, createdInvoiceId, methodId, amountToPay);

                // Bước 4: Phát hành vé xem phim
                tickets = ticketDAO.issueTickets(con, createdInvoiceId, heldSeats);
                invoice.setTickets(tickets);

                // Bước 5 & 6: Tích lũy điểm và nâng hạng thành viên
                if (customer != null && customer.getCard() != null && customer.getCard().getTier() != null) {
                    int points = (int) Math.round(amountToPay * customer.getCard().getTier().getPointRate());
                    if (points > 0) {
                        customerDAO.updatePoints(con, customer.getId(), points);
                        customer.setLoyaltyPoints(customer.getLoyaltyPoints() + points);
                        tierDAO.upgradeTier(con, customer.getId());
                    }
                }

                con.commit();
            } catch (Exception ex) {
                con.rollback();
                throw new ServletException("Giao dịch thanh toán thất bại: " + ex.getMessage(), ex);
            }
        } catch (SQLException e) {
            request.setAttribute("errorMsg", "Lỗi xử lý giao dịch: " + e.getMessage());
            showPayment(request, response);
            return;
        }

        // Lưu thông tin hóa đơn thành công vào session và dọn giỏ hàng
        session.setAttribute("lastInvoiceId", createdInvoiceId);
        session.setAttribute("completedInvoice", invoice);
        session.setAttribute("completedTickets", tickets);
        session.setAttribute("cashGiven", cashGiven);
        session.setAttribute("cashChange", change);
        clearCartSession(session);

        // 5. Post-Redirect-Get
        response.sendRedirect("payment-ticket?action=success");
    }

    /**
     * Hiển thị màn hình giao dịch thành công (an toàn khi F5)
     */
    private void showSuccess(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer lastInvoiceId = (Integer) session.getAttribute("lastInvoiceId");
        if (lastInvoiceId == null) {
            response.sendRedirect("movie-consultation");
            return;
        }

        Invoice6 invoice = (Invoice6) session.getAttribute("completedInvoice");
        if (invoice == null) {
            invoice = invoiceDAO.getInvoice(lastInvoiceId);
            session.setAttribute("completedInvoice", invoice);
        }

        request.setAttribute("outInvoiceInfo", invoice);
        request.setAttribute("outTicketList", session.getAttribute("completedTickets"));
        request.getRequestDispatcher("TransactionSuccessUI6.jsp").forward(request, response);
    }

    private void processPrint(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setAttribute("printSuccessMsg", "Đã gửi lệnh in vé và hóa đơn thành công ra máy in nhiệt POS!");
        showSuccess(request, response);
    }

    // --- Các hàm tiện ích bổ trợ ---

    private List<Integer> extractSeatIds(List<ShowtimeSeat6> seats) {
        List<Integer> ids = new ArrayList<>();
        if (seats != null) {
            for (ShowtimeSeat6 s : seats) ids.add(s.getId());
        }
        return ids;
    }

    private void clearCartSession(HttpSession session) {
        session.removeAttribute("heldSeats");
        session.removeAttribute("tempTotal");
        session.removeAttribute("discountAmount");
        session.removeAttribute("finalTotal");
        session.removeAttribute("customerMember");
    }

    private int parseMethodId(String methodParam) {
        if (methodParam != null && !methodParam.trim().isEmpty()) {
            try {
                return Integer.parseInt(methodParam.trim());
            } catch (NumberFormatException ignored) {}
        }
        return PaymentMethod6.METHOD_CASH;
    }

    private long parseCash(String raw, long fallback) {
        if (raw == null || raw.trim().isEmpty()) return fallback;
        try {
            String clean = raw.trim();
            if (clean.contains(".")) {
                return Math.round(Double.parseDouble(clean));
            }
            return Long.parseLong(clean.replaceAll("[^0-9]", ""));
        } catch (Exception e) {
            return 0L;
        }
    }
}
