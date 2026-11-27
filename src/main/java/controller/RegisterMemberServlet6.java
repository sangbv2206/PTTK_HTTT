package controller;

import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.CustomerDAO6;
import dao.MembershipCardDAO6;
import dao.MembershipTierDAO6;
import model.Customer;
import model.MembershipCard6;
import model.MembershipTier6;

@WebServlet("/register")
public class RegisterMemberServlet6 extends HttpServlet {
    // 1. UID xác thực tuần tự hóa chuẩn Java Servlet
    private static final long serialVersionUID = 1L;

    private CustomerDAO6 customerDAO;
    private MembershipTierDAO6 tierDAO;
    private MembershipCardDAO6 cardDAO;

    @Override
    public void init() {
        customerDAO = new CustomerDAO6();
        tierDAO = new MembershipTierDAO6();
        cardDAO = new MembershipCardDAO6();
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // BƯỚC 7: Trang MemberRegistrationUI6.jsp gọi phương thức doPost() của lớp
        // RegisterMemberServlet6
        // BƯỚC 8: Lớp RegisterMemberServlet6 tự gọi lại phương thức doGet()
        doGet(request, response);
    }

    /**
     * Phương thức doGet tập trung nhận mọi yêu cầu và điều hướng (Action
     * Dispatcher)
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // BƯỚC 2: Trang CustomerLoginUI6.jsp gọi phương thức doGet() của lớp
        // RegisterMemberServlet6
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if (action == null) {
            // Nếu người dùng gửi POST form mà không có query action thì mặc định là
            // register
            if ("POST".equalsIgnoreCase(request.getMethod())) {
                action = "register";
            } else {
                action = "home";
            }
        }

        try {
            switch (action) {
                case "register":
                    // BƯỚC 9: Lớp RegisterMemberServlet6 tự gọi hàm processRegister()
                    processRegister(request, response);
                    break;
                case "showForm":
                case "home":
                default:
                    // BƯỚC 3: Lớp RegisterMemberServlet6 tự gọi hàm showRegister()
                    showRegister(request, response);
                    break;
            }
        } catch (Exception ex) {
            throw new ServletException(ex);
        }
    }

    /**
     * Hiển thị màn hình 2: Form nhập thông tin đăng ký (MemberRegistrationUI6.jsp)
     */
    private void showRegister(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // BƯỚC 4: Lớp RegisterMemberServlet6 gọi phương thức forward() sang trang
        // MemberRegistrationUI6.jsp
        RequestDispatcher dispatcher = request.getRequestDispatcher("MemberRegistrationUI6.jsp");
        dispatcher.forward(request, response);
    }

    /**
     * Xử lý toàn bộ logic nghiệp vụ đăng ký thành viên và chuyển màn hình 3
     * (RegistrationSuccessUI6.jsp)
     */
    private void processRegister(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Đọc 8 tham số từ form
        String fullName = request.getParameter("txtFullName");
        String phoneNumber = request.getParameter("txtPhoneNumber");
        String dobStr = request.getParameter("txtDob");
        String username = request.getParameter("txtUsername");
        String address = request.getParameter("txtAddress");
        String email = request.getParameter("txtEmail");
        String password = request.getParameter("txtPassword");
        String confirmPassword = request.getParameter("txtConfirmPassword");

        // Giữ lại các giá trị đã nhập để người dùng không phải gõ lại nếu lỗi
        request.setAttribute("valFullName", fullName);
        request.setAttribute("valPhoneNumber", phoneNumber);
        request.setAttribute("valDob", dobStr);
        request.setAttribute("valUsername", username);
        request.setAttribute("valAddress", address);
        request.setAttribute("valEmail", email);

        // 1. Kiểm tra các trường bắt buộc
        if (fullName == null || fullName.trim().isEmpty() ||
                phoneNumber == null || phoneNumber.trim().isEmpty() ||
                dobStr == null || dobStr.trim().isEmpty() ||
                username == null || username.trim().isEmpty() ||
                email == null || email.trim().isEmpty() ||
                password == null || password.trim().isEmpty() ||
                confirmPassword == null || confirmPassword.trim().isEmpty()) {

            request.setAttribute("errorMsg", "Vui lòng điền đầy đủ các trường thông tin bắt buộc (*).");
            request.getRequestDispatcher("MemberRegistrationUI6.jsp").forward(request, response);
            return;
        }

        // 2. Kiểm tra định dạng số điện thoại (10 chữ số, bắt đầu bằng 0)
        String phoneClean = phoneNumber.trim();
        if (!phoneClean.matches("^0[0-9]{9}$")) {
            request.setAttribute("errorMsg", "Số điện thoại không hợp lệ (phải gồm 10 chữ số và bắt đầu bằng số 0).");
            request.getRequestDispatcher("MemberRegistrationUI6.jsp").forward(request, response);
            return;
        }

        // 3. Kiểm tra định dạng Email
        String emailClean = email.trim();
        if (!emailClean.matches("^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$")) {
            request.setAttribute("errorMsg", "Địa chỉ email không đúng định dạng.");
            request.getRequestDispatcher("MemberRegistrationUI6.jsp").forward(request, response);
            return;
        }

        // 4. Kiểm tra mật khẩu xác nhận
        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMsg", "Mật khẩu xác nhận không khớp. Vui lòng nhập lại!");
            request.getRequestDispatcher("MemberRegistrationUI6.jsp").forward(request, response);
            return;
        }

        // 5. Kiểm tra trùng username bằng getCustomer
        // BƯỚC 10: Lớp RegisterMemberServlet6 gọi hàm getCustomer(username) của lớp
        // CustomerDAO6
        // BƯỚC 11: Lớp CustomerDAO6 trả về null cho lớp RegisterMemberServlet6
        if (customerDAO.getCustomer(username.trim()) != null) {
            request.setAttribute("errorMsg",
                    "Tên đăng nhập '" + username + "' đã được sử dụng. Vui lòng chọn tên khác.");
            request.getRequestDispatcher("MemberRegistrationUI6.jsp").forward(request, response);
            return;
        }

        // 6. Kiểm tra trùng SĐT và Email bằng getCustomer
        // BƯỚC 12: Lớp RegisterMemberServlet6 gọi hàm getCustomer(phone) của lớp
        // CustomerDAO6
        // BƯỚC 13: Lớp CustomerDAO6 trả về null cho lớp RegisterMemberServlet6
        if (customerDAO.getCustomer(phoneClean) != null) {
            request.setAttribute("errorMsg", "Số điện thoại '" + phoneNumber + "' đã được đăng ký thành viên!");
            request.getRequestDispatcher("MemberRegistrationUI6.jsp").forward(request, response);
            return;
        }

        // BƯỚC 14: Lớp RegisterMemberServlet6 gọi hàm getCustomer(email) của lớp
        // CustomerDAO6
        // BƯỚC 15: Lớp CustomerDAO6 trả về null cho lớp RegisterMemberServlet6
        if (customerDAO.getCustomer(emailClean) != null) {
            request.setAttribute("errorMsg", "Email '" + email + "' đã được đăng ký thành viên!");
            request.getRequestDispatcher("MemberRegistrationUI6.jsp").forward(request, response);
            return;
        }

        // 7. Kiểm tra độ dài mật khẩu
        if (password.length() < 6) {
            request.setAttribute("errorMsg", "Mật khẩu phải có độ dài tối thiểu từ 6 ký tự.");
            request.getRequestDispatcher("MemberRegistrationUI6.jsp").forward(request, response);
            return;
        }

        // 7. Parse và kiểm tra ngày sinh hợp lệ (phải trong quá khứ)
        Date dob = null;
        try {
            dob = Date.valueOf(dobStr);
            if (!dob.before(new java.sql.Date(System.currentTimeMillis()))) {
                request.setAttribute("errorMsg", "Ngày sinh không hợp lệ (phải trước ngày hiện tại).");
                request.getRequestDispatcher("MemberRegistrationUI6.jsp").forward(request, response);
                return;
            }
        } catch (IllegalArgumentException e) {
            request.setAttribute("errorMsg", "Ngày sinh không đúng định dạng (YYYY-MM-DD).");
            request.getRequestDispatcher("MemberRegistrationUI6.jsp").forward(request, response);
            return;
        }

        // 8. Lấy hạng thẻ mặc định thấp nhất (Hạng Chuẩn / Đồng)
        // BƯỚC 16: Lớp RegisterMemberServlet6 gọi hàm getLowestTier() của lớp
        // MembershipTierDAO6
        // BƯỚC 19: Lớp MembershipTierDAO6 trả về đối tượng lowestTier cho lớp
        // RegisterMemberServlet6
        MembershipTier6 lowestTier = tierDAO.getLowestTier();
        if (lowestTier == null) {
            lowestTier = new MembershipTier6(1, "Thành viên Chuẩn (Đồng)", 0.05, 0, 0.0, "Tích lũy 5%");
        }

        // 9. Bọc việc tạo thẻ và tạo khách hàng trong CÙNG 1 TRANSACTION DUY NHẤT
        LocalDate now = LocalDate.now();
        Date issueDate = Date.valueOf(now); // Ngày kích hoạt thẻ
        Date expiryDate = Date.valueOf("2099-12-31"); // Thẻ vô thời hạn

        // BƯỚC 20: Lớp RegisterMemberServlet6 gọi khởi tạo thực thể new
        // MembershipCard6(...) của lớp MembershipCard6
        // BƯỚC 21: Lớp MembershipCard6 trả về đối tượng newCard cho lớp
        // RegisterMemberServlet6
        MembershipCard6 newCard = new MembershipCard6(issueDate, expiryDate, "ACTIVE", lowestTier);

        // BƯỚC 22: Lớp RegisterMemberServlet6 gọi khởi tạo thực thể new Customer(...)
        // của lớp Customer
        // BƯỚC 23: Lớp Customer trả về đối tượng newCustomer cho lớp
        // RegisterMemberServlet6
        Customer newCustomer = new Customer(fullName.trim(), dob, address != null ? address.trim() : "",
                phoneClean, emailClean, username.trim(), password);

        boolean transactionSuccess = false;
        try (java.sql.Connection con = dao.DAO.getNewConnection()) {
            con.setAutoCommit(false);
            try {
                // Bước 1: Kích hoạt thẻ trong transaction
                // BƯỚC 24: Lớp RegisterMemberServlet6 gọi hàm issueCard(con, newCard) của lớp
                // MembershipCardDAO6
                // BƯỚC 25: Lớp MembershipCardDAO6 trả về kết quả true cho lớp
                // RegisterMemberServlet6
                boolean cardCreated = cardDAO.issueCard(con, newCard);
                if (!cardCreated) {
                    throw new java.sql.SQLException("Không thể tạo thẻ thành viên!");
                }

                // BƯỚC 26: Lớp RegisterMemberServlet6 gọi hàm setCard(newCard) của đối tượng
                // Customer
                newCustomer.setCard(newCard);

                // Bước 2: Lưu tài khoản và khách hàng trong cùng transaction
                // BƯỚC 27: Lớp RegisterMemberServlet6 gọi hàm createCustomer(con, newCustomer)
                // của lớp CustomerDAO6
                // BƯỚC 28: Lớp CustomerDAO6 trả về kết quả true cho lớp RegisterMemberServlet6
                boolean custCreated = customerDAO.createCustomer(con, newCustomer);
                if (!custCreated) {
                    throw new java.sql.SQLException("Không thể lưu thông tin khách hàng!");
                }

                con.commit(); // Chốt Transaction trọn vẹn cả 2 bảng
                transactionSuccess = true;
            } catch (Exception ex) {
                con.rollback(); // Rollback toàn bộ nếu có bất kỳ lỗi nào, không sinh thẻ thừa
                throw ex;
            }
        } catch (Exception e) {
            request.setAttribute("errorMsg", "Lỗi hệ thống khi lưu thông tin: " + e.getMessage());
            request.getRequestDispatcher("MemberRegistrationUI6.jsp").forward(request, response);
            return;
        }

        if (transactionSuccess) {
            request.getSession().setAttribute("prefillUsername", newCustomer.getUsername());
            request.setAttribute("customer", newCustomer);
            request.setAttribute("card", newCard);
            // BƯỚC 29: Lớp RegisterMemberServlet6 gọi phương thức forward() sang trang
            // RegistrationSuccessUI6.jsp
            RequestDispatcher dispatcher = request.getRequestDispatcher("RegistrationSuccessUI6.jsp");
            dispatcher.forward(request, response);
        }
    }
}
