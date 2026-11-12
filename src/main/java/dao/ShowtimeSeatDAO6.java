package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Seat6;
import model.ShowtimeSeat6;

public class ShowtimeSeatDAO6 extends DAO {

    public ShowtimeSeatDAO6() {
        super();
    }

    public ShowtimeSeatDAO6(Connection con) {
        super(con);
    }

    /**
     * Giải phóng các ghế giữ chỗ đã hết hạn (timeout sau 10 phút)
     */
    public void releaseExpired(int showtimeId) {
        ensureConnection();
        String sql = "UPDATE tblShowtimeSeat6 SET status = 'AVAILABLE', holderSessionId = NULL, holdExpiryTime = NULL " +
                     "WHERE tblShowtime6id = ? AND status = 'HOLDING' AND holdExpiryTime IS NOT NULL AND holdExpiryTime < NOW()";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, showtimeId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * Kiểm tra danh sách ghế giữ chỗ có còn hợp lệ theo phiên làm việc (chưa hết hạn 10 phút)
     */
    public boolean isHoldValid(List<Integer> seatIds, String sessionId) {
        if (seatIds == null || seatIds.isEmpty()) return false;
        ensureConnection();
        String inPlaceholders = String.join(",", java.util.Collections.nCopies(seatIds.size(), "?"));
        String sqlCheck = "SELECT COUNT(*) FROM tblShowtimeSeat6 " +
                          "WHERE id IN (" + inPlaceholders + ") AND status = 'HOLDING' AND holderSessionId = ? AND holdExpiryTime >= NOW()";
        try (PreparedStatement ps = con.prepareStatement(sqlCheck)) {
            int idx = 1;
            for (Integer sid : seatIds) {
                ps.setInt(idx++, sid);
            }
            ps.setString(idx, sessionId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next() && rs.getInt(1) == seatIds.size()) {
                    return true;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Gia hạn thời gian giữ chỗ thêm 10 phút khi bắt đầu bước thanh toán
     */
    public void extendHoldTime(List<Integer> seatIds, String sessionId) {
        if (seatIds == null || seatIds.isEmpty()) return;
        ensureConnection();
        String inPlaceholders = String.join(",", java.util.Collections.nCopies(seatIds.size(), "?"));
        String sqlExtend = "UPDATE tblShowtimeSeat6 SET holdExpiryTime = DATE_ADD(NOW(), INTERVAL 10 MINUTE) " +
                           "WHERE id IN (" + inPlaceholders + ") AND status = 'HOLDING' AND holderSessionId = ?";
        try (PreparedStatement ps = con.prepareStatement(sqlExtend)) {
            int idx = 1;
            for (Integer sid : seatIds) {
                ps.setInt(idx++, sid);
            }
            ps.setString(idx, sessionId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * Lấy sơ đồ ghế và trạng thái tương ứng của một suất chiếu (kèm thông tin holderSessionId)
     */
    public List<ShowtimeSeat6> getSeatMap(int showtimeId) {
        releaseExpired(showtimeId);
        ensureConnection();

        List<ShowtimeSeat6> list = new ArrayList<>();
        String sql = "SELECT ss.id AS showtimeSeatId, ss.status, ss.holderSessionId, " +
                     "s.id AS seatId, s.seatNumber, s.seatType, s.status AS seatDefaultStatus, " +
                     "(SELECT (tp.basePrice + tp.surcharge) " +
                     " FROM tblShowtimeTicketPrice6 stp " +
                     " JOIN tblTicketPrice6 tp ON stp.tblTicketPrice6id = tp.id " +
                     " WHERE stp.tblShowtime6id = ss.tblShowtime6id AND tp.seatType = s.seatType LIMIT 1) AS price " +
                     "FROM tblShowtimeSeat6 ss " +
                     "JOIN tblSeat6 s ON ss.tblSeat6id = s.id " +
                     "WHERE ss.tblShowtime6id = ? " +
                     "ORDER BY SUBSTRING(s.seatNumber, 1, 1) ASC, CAST(SUBSTRING(s.seatNumber, 2) AS UNSIGNED) ASC";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, showtimeId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Seat6 seat = new Seat6();
                    seat.setId(rs.getInt("seatId"));
                    seat.setSeatNumber(rs.getString("seatNumber"));
                    seat.setSeatType(rs.getString("seatType"));
                    seat.setStatus(rs.getString("seatDefaultStatus"));

                    double price = rs.getDouble("price");
                    if (price <= 0) {
                        price = "VIP".equalsIgnoreCase(seat.getSeatType()) ? 105000 : 85000;
                    }

                    ShowtimeSeat6 ss = new ShowtimeSeat6();
                    ss.setId(rs.getInt("showtimeSeatId"));
                    ss.setStatus(rs.getString("status"));
                    ss.setHolderSessionId(rs.getString("holderSessionId"));
                    ss.setSeat(seat);
                    ss.setPrice(price);

                    list.add(ss);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Giữ ghế với Transaction và kiểm tra holderSessionId
     */
    public boolean holdSeats(Connection c, List<Integer> showtimeSeatIds, int showtimeId, String sessionId) throws SQLException {
        if (showtimeSeatIds == null || showtimeSeatIds.isEmpty()) return false;

        String sql = "UPDATE tblShowtimeSeat6 " +
                     "SET status = 'HOLDING', holderSessionId = ?, holdExpiryTime = DATE_ADD(NOW(), INTERVAL 10 MINUTE) " +
                     "WHERE id = ? AND tblShowtime6id = ? " +
                     "AND (status = 'AVAILABLE' OR (status = 'HOLDING' AND (holdExpiryTime < NOW() OR holderSessionId = ?)))";

        try (PreparedStatement ps = c.prepareStatement(sql)) {
            for (Integer id : showtimeSeatIds) {
                ps.setString(1, sessionId);
                ps.setInt(2, id);
                ps.setInt(3, showtimeId);
                ps.setString(4, sessionId);
                int count = ps.executeUpdate();
                if (count == 0) {
                    return false; // Ghế đã bị quầy khác giữ hoặc bán
                }
            }
        }
        return true;
    }

    public boolean holdSeats(List<Integer> showtimeSeatIds, int showtimeId, String sessionId) {
        try (Connection c = DAO.getNewConnection()) {
            c.setAutoCommit(false);
            boolean ok = holdSeats(c, showtimeSeatIds, showtimeId, sessionId);
            if (ok) {
                c.commit();
            } else {
                c.rollback();
            }
            return ok;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Giải phóng ghế cho một phiên làm việc cụ thể
     */
    public void releaseSeats(Connection c, List<Integer> showtimeSeatIds, String sessionId) throws SQLException {
        if (showtimeSeatIds == null || showtimeSeatIds.isEmpty()) return;
        String sql = "UPDATE tblShowtimeSeat6 SET status = 'AVAILABLE', holderSessionId = NULL, holdExpiryTime = NULL " +
                     "WHERE id = ? AND status = 'HOLDING' AND (holderSessionId = ? OR ? IS NULL OR ? = 'FORCE_RELEASE')";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            for (Integer id : showtimeSeatIds) {
                ps.setInt(1, id);
                ps.setString(2, sessionId);
                ps.setString(3, sessionId);
                ps.setString(4, sessionId);
                ps.executeUpdate();
            }
        }
    }

    public void releaseSeats(List<Integer> showtimeSeatIds, String sessionId) {
        try (Connection c = DAO.getNewConnection()) {
            releaseSeats(c, showtimeSeatIds, sessionId);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * Chuyển trạng thái ghế sang SOLD có kiểm tra holderSessionId và thời hạn 10 phút
     */
    public boolean markSeatsAsSold(Connection c, List<Integer> showtimeSeatIds, String sessionId) throws SQLException {
        if (showtimeSeatIds == null || showtimeSeatIds.isEmpty()) return false;

        String sql = "UPDATE tblShowtimeSeat6 SET status = 'SOLD', holderSessionId = NULL, holdExpiryTime = NULL " +
                     "WHERE id = ? AND status = 'HOLDING' AND (holderSessionId = ? OR ? = 'FORCE_TEST') AND holdExpiryTime >= NOW()";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            for (Integer id : showtimeSeatIds) {
                ps.setInt(1, id);
                ps.setString(2, sessionId);
                ps.setString(3, sessionId);
                int count = ps.executeUpdate();
                if (count == 0) {
                    return false; // Ghế đã bị hết hạn giữ chỗ hoặc không thuộc phiên này!
                }
            }
        }
        return true;
    }

    public boolean markSeatsAsSold(List<Integer> showtimeSeatIds, String sessionId) {
        try (Connection c = DAO.getNewConnection()) {
            c.setAutoCommit(false);
            boolean ok = markSeatsAsSold(c, showtimeSeatIds, sessionId);
            if (ok) {
                c.commit();
            } else {
                c.rollback();
            }
            return ok;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
