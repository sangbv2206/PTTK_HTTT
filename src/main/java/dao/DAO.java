package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DAO {
    private static final String DEFAULT_URL = "jdbc:mysql://localhost:3306/cinema_db?useSSL=false&serverTimezone=Asia/Ho_Chi_Minh&allowPublicKeyRetrieval=true&characterEncoding=UTF-8";
    private static final String DEFAULT_DRIVER = "com.mysql.cj.jdbc.Driver";
    private static final String DEFAULT_USER = "root";
    private static final String DEFAULT_PASS = "13102025";

    // Connection của riêng từng instance DAO, KHÔNG static chia sẻ chung đa luồng
    protected Connection con;

    public DAO() {
        try {
            this.con = getNewConnection();
        } catch (SQLException e) {
            System.err.println("Lỗi mở kết nối CSDL trong DAO: " + e.getMessage());
        }
    }

    public DAO(Connection con) {
        this.con = con;
    }

    /**
     * Đảm bảo connection của instance DAO còn sống, tự kết nối lại nếu bị idle timeout
     */
    public Connection ensureConnection() {
        try {
            if (this.con == null || this.con.isClosed()) {
                this.con = getNewConnection();
            }
        } catch (SQLException e) {
            System.err.println("Lỗi reconnect DAO: " + e.getMessage());
        }
        return this.con;
    }

    /**
     * Mở một Connection mới hoàn toàn độc lập, dùng cho các transaction an toàn (ACID)
     */
    public static Connection getNewConnection() throws SQLException {
        String dbUrl = System.getProperty("cinema.db.url", DEFAULT_URL);
        String dbClass = System.getProperty("cinema.db.driver", DEFAULT_DRIVER);
        String dbUser = System.getProperty("cinema.db.user", DEFAULT_USER);
        String dbPassword = System.getProperty("cinema.db.password", DEFAULT_PASS);

        try {
            Class.forName(dbClass);
        } catch (ClassNotFoundException e) {
            throw new SQLException("Không tìm thấy Driver MySQL: " + dbClass, e);
        }
        return DriverManager.getConnection(dbUrl, dbUser, dbPassword);
    }

    /**
     * Phương thức tương thích ngược
     */
    public static Connection getConnection() {
        try {
            return getNewConnection();
        } catch (SQLException e) {
            System.err.println("Lỗi kết nối CSDL: " + e.getMessage());
            return null;
        }
    }
}

