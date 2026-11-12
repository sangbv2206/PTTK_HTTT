package controller;

import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.SalesStaffDAO6;
import model.SalesStaff;

@WebServlet("/staff-login")
public class StaffLoginServlet6 extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private SalesStaffDAO6 staffDAO;

    @Override
    public void init() {
        staffDAO = new SalesStaffDAO6();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("logout".equalsIgnoreCase(action)) {
            processLogout(request, response);
            return;
        }
        RequestDispatcher dispatcher = request.getRequestDispatcher("StaffLoginUI6.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        processLogin(request, response);
    }

    private void processLogin(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String username = request.getParameter("inUsername");
        String password = request.getParameter("inPassword");

        SalesStaff staff = staffDAO.checkLogin(username, password);
        if (staff != null) {
            HttpSession session = request.getSession();
            session.setAttribute("staff", staff);
            response.sendRedirect("movie-consultation");
        } else {
            request.setAttribute("errorMsg", "Sai tên đăng nhập hoặc mật khẩu nhân viên!");
            RequestDispatcher dispatcher = request.getRequestDispatcher("StaffLoginUI6.jsp");
            dispatcher.forward(request, response);
        }
    }

    private void processLogout(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        response.sendRedirect("staff-login");
    }
}
