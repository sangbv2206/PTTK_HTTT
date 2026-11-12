package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.PaymentMethod6;

public class PaymentMethodDAO6 extends DAO {

    public PaymentMethodDAO6() {
        super();
    }

    public PaymentMethodDAO6(Connection con) {
        super(con);
    }

    /**
     * Lấy tất cả phương thức thanh toán trong hệ thống
     */
    public List<PaymentMethod6> getAll() {
        ensureConnection();
        List<PaymentMethod6> list = new ArrayList<>();
        String sql = "SELECT id, methodName, description FROM tblPaymentMethod6";
        try (PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new PaymentMethod6(
                    rs.getInt("id"),
                    rs.getString("methodName"),
                    rs.getString("description")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Ghi nhận phương thức thanh toán cho hóa đơn trong Transaction
     */
    public boolean recordPayment(Connection c, int invoiceId, int methodId, double amount) throws SQLException {
        String sql = "UPDATE tblInvoice6 SET tblPaymentMethod6id = ? WHERE id = ?";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, methodId);
            ps.setInt(2, invoiceId);
            return ps.executeUpdate() > 0;
        }
    }
}
