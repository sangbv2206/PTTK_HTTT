package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import model.MembershipCard6;

public class MembershipCardDAO6 extends DAO {

    public MembershipCardDAO6() {
        super();
    }

    public MembershipCardDAO6(Connection con) {
        super(con);
    }

    /**
     * Cấp thẻ thành viên mới trong Transaction (Thẻ theo hạng - Vô thời hạn)
     */
    public boolean issueCard(Connection c, MembershipCard6 card) throws SQLException {
        String sql = "INSERT INTO tblMembershipCard6 (issueDate, expiryDate, status, tblMembershipTier6id) " +
                     "VALUES (?, ?, ?, ?)";

        try (PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setDate(1, card.getIssueDate());
            ps.setDate(2, card.getExpiryDate());
            ps.setString(3, card.getStatus());
            ps.setInt(4, card.getTier().getId());

            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        card.setId(generatedKeys.getInt(1));
                    }
                }
                return true;
            }
        }
        return false;
    }
}
