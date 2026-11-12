package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.TicketPrice6;

public class TicketPriceDAO6 extends DAO {

    public TicketPriceDAO6() {
        super();
    }

    public TicketPriceDAO6(Connection con) {
        super(con);
    }

    /**
     * Tra cứu bảng giá vé theo suất chiếu
     */
    public List<TicketPrice6> getByShowtime(int showtimeId) {
        ensureConnection();
        List<TicketPrice6> list = new ArrayList<>();
        String sql = "SELECT tp.id, tp.seatType, tp.dayType, (tp.basePrice + tp.surcharge) AS price " +
                     "FROM tblTicketPrice6 tp " +
                     "JOIN tblShowtimeTicketPrice6 stp ON tp.id = stp.tblTicketPrice6id " +
                     "WHERE stp.tblShowtime6id = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, showtimeId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    TicketPrice6 tp = new TicketPrice6();
                    tp.setId(rs.getInt("id"));
                    tp.setSeatType(rs.getString("seatType"));
                    tp.setDayType(rs.getString("dayType"));
                    tp.setPrice(rs.getDouble("price"));
                    list.add(tp);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
