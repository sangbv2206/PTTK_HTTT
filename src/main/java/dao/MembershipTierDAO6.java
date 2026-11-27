package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import model.MembershipTier6;

public class MembershipTierDAO6 extends DAO {

    public MembershipTierDAO6() {
        super();
    }

    public MembershipTierDAO6(Connection con) {
        super(con);
    }

    /**
     * Lấy hạng thành viên mặc định (thấp nhất) dành cho khách hàng đăng ký mới
     */
    public MembershipTier6 getLowestTier() {
        ensureConnection();
        MembershipTier6 tier = null;
        String sql = "SELECT id, tierName, pointRate, minPointsRequired, discountRate, benefitsDescription " +
                     "FROM tblMembershipTier6 " +
                     "ORDER BY minPointsRequired ASC LIMIT 1";

        try (PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                // BƯỚC 17: Lớp MembershipTierDAO6 gọi khởi tạo thực thể new MembershipTier6(...) của lớp MembershipTier6
                // BƯỚC 18: Lớp MembershipTier6 trả về đối tượng lowestTier cho lớp MembershipTierDAO6
                tier = new MembershipTier6(
                    rs.getInt("id"),
                    rs.getString("tierName"),
                    rs.getDouble("pointRate"),
                    rs.getInt("minPointsRequired"),
                    rs.getDouble("discountRate"),
                    rs.getString("benefitsDescription")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tier;
    }

    /**
     * Tra cứu hạng thành viên theo số điểm tích lũy trong Transaction
     */
    public MembershipTier6 getByPoints(Connection c, int points) throws SQLException {
        String sql = "SELECT id, tierName, pointRate, minPointsRequired, discountRate, benefitsDescription " +
                     "FROM tblMembershipTier6 " +
                     "WHERE minPointsRequired <= ? " +
                     "ORDER BY minPointsRequired DESC LIMIT 1";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, points);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new MembershipTier6(
                        rs.getInt("id"),
                        rs.getString("tierName"),
                        rs.getDouble("pointRate"),
                        rs.getInt("minPointsRequired"),
                        rs.getDouble("discountRate"),
                        rs.getString("benefitsDescription")
                    );
                }
            }
        }
        return null;
    }

    /**
     * Tự động kiểm tra và nâng hạng thẻ thành viên nếu đạt mốc điểm mới
     */
    public boolean upgradeTier(Connection c, int customerId) throws SQLException {
        String sqlPoints = "SELECT c.loyaltyPoints, c.tblMembershipCard6id, mc.tblMembershipTier6id " +
                           "FROM tblCustomer c " +
                           "JOIN tblMembershipCard6 mc ON c.tblMembershipCard6id = mc.id " +
                           "WHERE c.tblUserId = ?";
        int points = 0;
        int cardId = 0;
        int currentTierId = 0;
        try (PreparedStatement ps = c.prepareStatement(sqlPoints)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    points = rs.getInt("loyaltyPoints");
                    cardId = rs.getInt("tblMembershipCard6id");
                    currentTierId = rs.getInt("tblMembershipTier6id");
                }
            }
        }
        if (cardId > 0) {
            MembershipTier6 newTier = getByPoints(c, points);
            if (newTier != null && newTier.getId() != currentTierId) {
                String sqlUpgrade = "UPDATE tblMembershipCard6 SET tblMembershipTier6id = ? WHERE id = ?";
                try (PreparedStatement ps = c.prepareStatement(sqlUpgrade)) {
                    ps.setInt(1, newTier.getId());
                    ps.setInt(2, cardId);
                    return ps.executeUpdate() > 0;
                }
            }
        }
        return false;
    }
}
