package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Movie6;
import model.ScreeningRoom6;
import model.Showtime6;

public class ShowtimeDAO6 extends DAO {

    public ShowtimeDAO6() {
        super();
    }

    public ShowtimeDAO6(java.sql.Connection con) {
        super(con);
    }

    /**
     * Tìm các suất chiếu theo mã phim đã chọn
     */
    public List<Showtime6> getByMovie(int movieId) {
        ensureConnection();
        List<Showtime6> list = new ArrayList<>();
        String sql = "SELECT s.id, s.startTime, s.endTime, s.screeningFormat, " +
                     "r.id AS roomId, r.roomName, r.capacity, r.supportedFormats, r.description AS roomDesc, " +
                     "m.id AS movieId, m.title, m.genre, m.duration " +
                     "FROM tblShowtime6 s " +
                     "JOIN tblScreeningRoom6 r ON s.tblScreeningRoom6id = r.id " +
                     "JOIN tblMovie6 m ON s.tblMovie6id = m.id " +
                     "WHERE s.tblMovie6id = ? AND s.startTime >= NOW() " +
                     "ORDER BY s.startTime ASC";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, movieId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ScreeningRoom6 room = new ScreeningRoom6(
                        rs.getInt("roomId"),
                        rs.getString("roomName"),
                        rs.getInt("capacity"),
                        rs.getString("supportedFormats"),
                        rs.getString("roomDesc")
                    );
                    Movie6 movie = new Movie6();
                    movie.setId(rs.getInt("movieId"));
                    movie.setTitle(rs.getString("title"));
                    movie.setGenre(rs.getString("genre"));
                    movie.setDuration(rs.getInt("duration"));

                    list.add(new Showtime6(
                        rs.getInt("id"),
                        rs.getTimestamp("startTime"),
                        rs.getTimestamp("endTime"),
                        rs.getString("screeningFormat"),
                        movie,
                        room
                    ));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Lấy thông tin chi tiết một suất chiếu theo mã ID
     */
    public Showtime6 getById(int showtimeId) {
        ensureConnection();
        String sql = "SELECT s.id, s.startTime, s.endTime, s.screeningFormat, " +
                     "r.id AS roomId, r.roomName, r.capacity, r.supportedFormats, r.description AS roomDesc, " +
                     "m.id AS movieId, m.title, m.genre, m.duration " +
                     "FROM tblShowtime6 s " +
                     "JOIN tblScreeningRoom6 r ON s.tblScreeningRoom6id = r.id " +
                     "JOIN tblMovie6 m ON s.tblMovie6id = m.id " +
                     "WHERE s.id = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, showtimeId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    ScreeningRoom6 room = new ScreeningRoom6(
                        rs.getInt("roomId"),
                        rs.getString("roomName"),
                        rs.getInt("capacity"),
                        rs.getString("supportedFormats"),
                        rs.getString("roomDesc")
                    );
                    Movie6 movie = new Movie6();
                    movie.setId(rs.getInt("movieId"));
                    movie.setTitle(rs.getString("title"));
                    movie.setGenre(rs.getString("genre"));
                    movie.setDuration(rs.getInt("duration"));

                    return new Showtime6(
                        rs.getInt("id"),
                        rs.getTimestamp("startTime"),
                        rs.getTimestamp("endTime"),
                        rs.getString("screeningFormat"),
                        movie,
                        room
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
