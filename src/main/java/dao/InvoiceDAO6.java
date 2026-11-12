package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.List;
import model.Customer;
import model.Invoice6;
import model.PaymentMethod6;
import model.SalesStaff;
import model.ShowtimeSeat6;

public class InvoiceDAO6 extends DAO {

    public InvoiceDAO6() {
        super();
    }

    public InvoiceDAO6(Connection con) {
        super(con);
    }

    /**
     * Tính tổng tiền tạm tính dựa trên danh sách ghế đã chọn
     */
    public double calculateTotal(List<ShowtimeSeat6> seats, int showtimeId) {
        if (seats == null) return 0.0;
        double total = 0.0;
        for (ShowtimeSeat6 ss : seats) {
            total += ss.getPrice();
        }
        return total;
    }

    /**
     * Tạo hóa đơn mới trong Transaction (nhận Connection)
     */
    public int createInvoice(Connection c, Invoice6 invoice) throws SQLException {
        if (invoice == null || invoice.getTotalAmount() < 0 || invoice.getFinalAmount() < 0) {
            return -1;
        }

        String sql = "INSERT INTO tblInvoice6 (totalAmount, discountAmount, finalAmount, createdAt, tblCustomertid, tblSalesStaffid, tblPaymentMethod6id) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
        int generatedId = -1;

        try (PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setDouble(1, invoice.getTotalAmount());
            ps.setDouble(2, invoice.getDiscountAmount());
            ps.setDouble(3, invoice.getFinalAmount());
            ps.setTimestamp(4, invoice.getCreatedAt() != null ? invoice.getCreatedAt() : new Timestamp(System.currentTimeMillis()));

            if (invoice.getCustomer() != null && invoice.getCustomer().getId() > 0) {
                ps.setInt(5, invoice.getCustomer().getId());
            } else {
                ps.setNull(5, java.sql.Types.INTEGER);
            }

            if (invoice.getStaff() != null && invoice.getStaff().getId() > 0) {
                ps.setInt(6, invoice.getStaff().getId());
            } else {
                return -1;
            }

            if (invoice.getPaymentMethod() != null && invoice.getPaymentMethod().getId() > 0) {
                ps.setInt(7, invoice.getPaymentMethod().getId());
            } else {
                ps.setInt(7, 1);
            }

            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    generatedId = rs.getInt(1);
                    invoice.setId(generatedId);
                }
            }
        }
        return generatedId;
    }

    /**
     * Lấy dữ liệu chi tiết hóa đơn (kèm thông tin vé, khách hàng, nhân viên)
     */
    public Invoice6 getInvoice(int invoiceId) {
        ensureConnection();
        String sql = "SELECT i.id, i.totalAmount, i.discountAmount, i.finalAmount, i.createdAt, " +
                     "u.fullName AS customerName, " +
                     "s_u.fullName AS staffName, " +
                     "e.emp_id AS staffCode, " +
                     "pm.methodName AS methodName " +
                     "FROM tblInvoice6 i " +
                     "LEFT JOIN tblCustomer c ON i.tblCustomertid = c.tblUserId " +
                     "LEFT JOIN tblUser u ON c.tblUserId = u.id " +
                     "LEFT JOIN tblSalesStaff ss ON i.tblSalesStaffid = ss.tblUserId " +
                     "LEFT JOIN tblUser s_u ON ss.tblUserId = s_u.id " +
                     "LEFT JOIN tblEmployee e ON ss.tblUserId = e.tblUserId " +
                     "LEFT JOIN tblPaymentMethod6 pm ON i.tblPaymentMethod6id = pm.id " +
                     "WHERE i.id = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, invoiceId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Invoice6 inv = new Invoice6();
                    inv.setId(rs.getInt("id"));
                    inv.setTotalAmount(rs.getDouble("totalAmount"));
                    inv.setDiscountAmount(rs.getDouble("discountAmount"));
                    inv.setFinalAmount(rs.getDouble("finalAmount"));
                    inv.setCreatedAt(rs.getTimestamp("createdAt"));

                    Customer cus = new Customer();
                    cus.setFullName(rs.getString("customerName"));
                    inv.setCustomer(cus);

                    SalesStaff staff = new SalesStaff();
                    staff.setFullName(rs.getString("staffName"));
                    staff.setEmployeeCode(rs.getString("staffCode"));
                    inv.setStaff(staff);

                    PaymentMethod6 pm = new PaymentMethod6();
                    pm.setMethodName(rs.getString("methodName"));
                    inv.setPaymentMethod(pm);

                    return inv;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
