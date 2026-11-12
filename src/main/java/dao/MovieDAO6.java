package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Movie6;

public class MovieDAO6 extends DAO {

    public MovieDAO6() {
        super();
    }

    public MovieDAO6(java.sql.Connection con) {
        super(con);
    }

    /**
     * Lấy danh sách phim đang chiếu phục vụ tư vấn bán vé
     */
    public List<Movie6> getNowShowing() {
        ensureConnection();
        List<Movie6> list = new ArrayList<>();
        String sql = "SELECT DISTINCT id, title, genre, duration, director, `cast`, description, poster FROM tblMovie6 WHERE status = 'NOW_SHOWING'";
        try (PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new Movie6(
                    rs.getInt("id"),
                    rs.getString("title"),
                    rs.getString("genre"),
                    rs.getInt("duration"),
                    rs.getString("director"),
                    rs.getString("cast"),
                    null,
                    rs.getString("description"),
                    rs.getString("poster")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Tìm kiếm phim theo từ khóa (tên phim, diễn viên, đạo diễn) hoặc theo thể loại
     */
    public List<Movie6> search(String keyword, String genre) {
        ensureConnection();
        List<Movie6> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT DISTINCT id, title, genre, duration, director, `cast`, description, poster FROM tblMovie6 WHERE status = 'NOW_SHOWING' ");
        
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (title LIKE ? OR `cast` LIKE ? OR director LIKE ?) ");
        }
        if (genre != null && !genre.trim().isEmpty()) {
            sql.append("AND genre LIKE ? ");
        }

        try (PreparedStatement ps = con.prepareStatement(sql.toString())) {
            int idx = 1;
            if (keyword != null && !keyword.trim().isEmpty()) {
                String kwParam = "%" + keyword.trim() + "%";
                ps.setString(idx++, kwParam);
                ps.setString(idx++, kwParam);
                ps.setString(idx++, kwParam);
            }
            if (genre != null && !genre.trim().isEmpty()) {
                ps.setString(idx++, "%" + genre.trim() + "%");
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new Movie6(
                        rs.getInt("id"),
                        rs.getString("title"),
                        rs.getString("genre"),
                        rs.getInt("duration"),
                        rs.getString("director"),
                        rs.getString("cast"),
                        null,
                        rs.getString("description"),
                        rs.getString("poster")
                    ));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Lấy thông tin chi tiết một phim theo mã ID
     */
    public Movie6 getById(int movieId) {
        ensureConnection();
        String sql = "SELECT id, title, genre, duration, director, `cast`, description, poster FROM tblMovie6 WHERE id = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, movieId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Movie6(
                        rs.getInt("id"),
                        rs.getString("title"),
                        rs.getString("genre"),
                        rs.getInt("duration"),
                        rs.getString("director"),
                        rs.getString("cast"),
                        null,
                        rs.getString("description"),
                        rs.getString("poster")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Lấy danh sách các thể loại phim phục vụ cho dropdown lọc
     */
    public List<String> getAllGenres() {
        ensureConnection();
        List<String> genres = new ArrayList<>();
        String sql = "SELECT DISTINCT genre FROM tblMovie6 WHERE genre IS NOT NULL AND status = 'NOW_SHOWING'";
        try (PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                genres.add(rs.getString("genre"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return genres;
    }
}
