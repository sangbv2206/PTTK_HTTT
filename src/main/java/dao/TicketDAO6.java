package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import model.ShowtimeSeat6;
import model.Ticket6;

public class TicketDAO6 extends DAO {

    public TicketDAO6() {
        super();
    }

    public TicketDAO6(Connection con) {
        super(con);
    }

    /**
     * Phát hành các bản ghi vé trong tblTicket6 tương ứng với từng ghế khách mua (nhận Connection trong Transaction)
     */
    public List<Ticket6> issueTickets(Connection c, int invoiceId, List<ShowtimeSeat6> seats) throws SQLException {
        List<Ticket6> tickets = new ArrayList<>();
        if (seats == null || seats.isEmpty()) return tickets;

        String sql = "INSERT INTO tblTicket6 (salePrice, purchaseTime, qrCode, tblShowtimeSeat6id, tblInvoice6id) " +
                     "VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            Timestamp now = new Timestamp(System.currentTimeMillis());

            for (ShowtimeSeat6 ss : seats) {
                // Sử dụng UUID để đảm bảo mã QR định danh vé là độc nhất 100%, không bao giờ trùng lặp
                String qr = "TICKET-INV" + invoiceId + "-SEAT" + ss.getId() + "-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
                ps.setDouble(1, ss.getPrice());
                ps.setTimestamp(2, now);
                ps.setString(3, qr);
                ps.setInt(4, ss.getId());
                ps.setInt(5, invoiceId);
                ps.executeUpdate();

                int ticketId = -1;
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        ticketId = rs.getInt(1);
                    }
                }

                Ticket6 t = new Ticket6(ticketId, ss.getPrice(), now, qr, ss, invoiceId);
                tickets.add(t);
            }
        }
        return tickets;
    }
}
