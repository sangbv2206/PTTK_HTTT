package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import model.SalesStaff;

public class SalesStaffDAO6 extends DAO {

    public SalesStaffDAO6() {
        super();
    }

    public SalesStaffDAO6(java.sql.Connection con) {
        super(con);
    }

    /**
     * Xác thực thông tin đăng nhập nhân viên bán vé (StaffLoginServlet6)
     * Sử dụng LEFT JOIN để hỗ trợ cả nhân viên quầy vé và quản trị viên (Admin)
     */
    public SalesStaff checkLogin(String username, String password) {
        ensureConnection();
        String sql = "SELECT u.id, u.fullName, u.dateOfBirth, u.address, u.phoneNumber, u.email, u.username, u.password, u.role, " +
                     "e.emp_id, s.tblUserId AS salesStaffUserId " +
                     "FROM tblUser u " +
                     "JOIN tblEmployee e ON u.id = e.tblUserId " +
                     "LEFT JOIN tblSalesStaff s ON e.tblUserId = s.tblUserId " +
                     "WHERE u.username = ? AND u.password = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    SalesStaff staff = new SalesStaff();
                    staff.setId(rs.getInt("id"));
                    staff.setFullName(rs.getString("fullName"));
                    staff.setDateOfBirth(rs.getDate("dateOfBirth"));
                    staff.setAddress(rs.getString("address"));
                    staff.setPhoneNumber(rs.getString("phoneNumber"));
                    staff.setEmail(rs.getString("email"));
                    staff.setUsername(rs.getString("username"));
                    staff.setPassword(rs.getString("password"));
                    String role = rs.getString("role");
                    staff.setRole(role != null ? role : "STAFF");
                    staff.setEmployeeCode(rs.getString("emp_id"));
                    staff.setPosition("ADMIN".equalsIgnoreCase(role) ? "Quản lý rạp chiếu" : "Nhân viên bán vé");
                    return staff;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}

