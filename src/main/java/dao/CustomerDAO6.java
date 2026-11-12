package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import model.Customer;
import model.MembershipCard6;
import model.MembershipTier6;

public class CustomerDAO6 extends DAO {

    public CustomerDAO6() {
        super();
    }

    public CustomerDAO6(Connection con) {
        super(con);
    }

    /**
     * Tìm kiếm và kiểm tra khách hàng theo số điện thoại, email hoặc username
     */
    public Customer getCustomer(String key) {
        ensureConnection();
        if (key == null || key.trim().isEmpty()) return null;
        key = key.trim();

        Customer customer = null;
        String sql = "SELECT u.id, u.fullName, u.dateOfBirth, u.address, u.phoneNumber, u.email, u.username, " +
                     "c.cus_id, c.loyaltyPoints, c.tblMembershipCard6id, " +
                     "mc.issueDate, mc.expiryDate, mc.status AS cardStatus, " +
                     "mt.id AS tierId, mt.tierName, mt.pointRate, mt.discountRate " +
                     "FROM tblUser u " +
                     "LEFT JOIN tblCustomer c ON u.id = c.tblUserId " +
                     "LEFT JOIN tblMembershipCard6 mc ON c.tblMembershipCard6id = mc.id " +
                     "LEFT JOIN tblMembershipTier6 mt ON mc.tblMembershipTier6id = mt.id " +
                     "WHERE u.phoneNumber = ? OR u.email = ? OR u.username = ?";

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, key);
            ps.setString(2, key);
            ps.setString(3, key);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    customer = new Customer();
                    customer.setId(rs.getInt("id"));
                    customer.setFullName(rs.getString("fullName"));
                    customer.setDateOfBirth(rs.getDate("dateOfBirth"));
                    customer.setAddress(rs.getString("address"));
                    customer.setPhoneNumber(rs.getString("phoneNumber"));
                    customer.setEmail(rs.getString("email"));
                    customer.setUsername(rs.getString("username"));
                    customer.setCus_id(rs.getString("cus_id"));
                    customer.setLoyaltyPoints(rs.getInt("loyaltyPoints"));

                    int cardId = rs.getInt("tblMembershipCard6id");
                    if (cardId > 0) {
                        String cardStatus = rs.getString("cardStatus");
                        MembershipCard6 card = new MembershipCard6();
                        card.setId(cardId);
                        card.setIssueDate(rs.getDate("issueDate"));
                        card.setExpiryDate(rs.getDate("expiryDate"));
                        card.setStatus(cardStatus != null ? cardStatus : "ACTIVE");

                        MembershipTier6 tier = new MembershipTier6();
                        tier.setId(rs.getInt("tierId"));
                        tier.setTierName(rs.getString("tierName"));
                        tier.setPointRate(rs.getDouble("pointRate"));
                        tier.setDiscountRate(rs.getDouble("discountRate"));
                        card.setTier(tier);

                        customer.setCard(card);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return customer;
    }

    /**
     * Thêm mới khách hàng trong Transaction (nhận Connection)
     */
    public boolean createCustomer(Connection c, Customer cust) throws SQLException {
        String sqlUser = "INSERT INTO tblUser (fullName, dateOfBirth, address, phoneNumber, email, username, password, role) " +
                         "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        String sqlCustomer = "INSERT INTO tblCustomer (tblUserId, cus_id, loyaltyPoints, tblMembershipCard6id) " +
                             "VALUES (?, ?, ?, ?)";

        int userId = -1;
        // 1. Lưu vào bảng tblUser
        try (PreparedStatement psUser = c.prepareStatement(sqlUser, Statement.RETURN_GENERATED_KEYS)) {
            psUser.setString(1, cust.getFullName());
            psUser.setDate(2, cust.getDateOfBirth());
            psUser.setString(3, cust.getAddress());
            psUser.setString(4, cust.getPhoneNumber());
            psUser.setString(5, cust.getEmail());
            psUser.setString(6, cust.getUsername());
            psUser.setString(7, cust.getPassword());
            psUser.setString(8, "CUSTOMER");

            int affected = psUser.executeUpdate();
            if (affected == 0) return false;

            try (ResultSet gk = psUser.getGeneratedKeys()) {
                if (gk.next()) {
                    userId = gk.getInt(1);
                    cust.setId(userId);
                } else {
                    return false;
                }
            }
        }

        // Sinh mã khách hàng định dạng KH00001
        String cusCode = String.format("KH%05d", userId);
        cust.setCus_id(cusCode);

        // 2. Lưu vào bảng tblCustomer
        try (PreparedStatement psCustomer = c.prepareStatement(sqlCustomer)) {
            psCustomer.setInt(1, userId);
            psCustomer.setString(2, cusCode);
            psCustomer.setInt(3, 0); // Điểm khởi đầu = 0
            psCustomer.setInt(4, cust.getCard() != null ? cust.getCard().getId() : 1);
            return psCustomer.executeUpdate() > 0;
        }
    }


    /**
     * Tìm thông tin thành viên theo số thẻ hoặc số điện thoại (phục vụ MemberDiscountUI6)
     */
    public Customer getByCard(String cardNumber) {
        ensureConnection();
        if (cardNumber == null || cardNumber.trim().isEmpty()) return null;
        cardNumber = cardNumber.trim();

        // 1. Ưu tiên tìm theo mã khách hàng cus_id (ví dụ: KH00001) hoặc ID thẻ
        String sql = "SELECT u.id, u.fullName, u.dateOfBirth, u.address, u.phoneNumber, u.email, u.username, " +
                     "c.cus_id, c.loyaltyPoints, c.tblMembershipCard6id, " +
                     "mc.issueDate, mc.expiryDate, mc.status AS cardStatus, " +
                     "mt.id AS tierId, mt.tierName, mt.pointRate, mt.discountRate " +
                     "FROM tblUser u " +
                     "JOIN tblCustomer c ON u.id = c.tblUserId " +
                     "JOIN tblMembershipCard6 mc ON c.tblMembershipCard6id = mc.id " +
                     "JOIN tblMembershipTier6 mt ON mc.tblMembershipTier6id = mt.id " +
                     "WHERE c.cus_id = ? OR mc.id = ?";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, cardNumber);
            int cardId = -1;
            try { cardId = Integer.parseInt(cardNumber); } catch (Exception ex) {}
            ps.setInt(2, cardId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Customer c = new Customer();
                c.setId(rs.getInt("id"));
                c.setFullName(rs.getString("fullName"));
                c.setDateOfBirth(rs.getDate("dateOfBirth"));
                c.setAddress(rs.getString("address"));
                c.setPhoneNumber(rs.getString("phoneNumber"));
                c.setEmail(rs.getString("email"));
                c.setUsername(rs.getString("username"));
                c.setCus_id(rs.getString("cus_id"));
                c.setLoyaltyPoints(rs.getInt("loyaltyPoints"));

                String cardStatus = rs.getString("cardStatus");
                MembershipCard6 card = new MembershipCard6();
                card.setId(rs.getInt("tblMembershipCard6id"));
                card.setIssueDate(rs.getDate("issueDate"));
                card.setExpiryDate(rs.getDate("expiryDate"));
                card.setStatus(cardStatus != null ? cardStatus : "ACTIVE");

                MembershipTier6 tier = new MembershipTier6();
                tier.setId(rs.getInt("tierId"));
                tier.setTierName(rs.getString("tierName"));
                tier.setPointRate(rs.getDouble("pointRate"));
                tier.setDiscountRate(rs.getDouble("discountRate"));
                card.setTier(tier);

                c.setCard(card);
                return c;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // 2. Nếu không khớp thẻ/mã khách, tìm tiếp theo SĐT hoặc Email
        return getCustomer(cardNumber);
    }

    /**
     * Cập nhật điểm tích lũy trong Transaction (nhận Connection)
     */
    public boolean updatePoints(Connection c, int customerId, int pointsEarned) throws SQLException {
        String sql = "UPDATE tblCustomer SET loyaltyPoints = loyaltyPoints + ? WHERE tblUserId = ?";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, pointsEarned);
            ps.setInt(2, customerId);
            return ps.executeUpdate() > 0;
        }
    }
}
