package extensao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public final class ConnectionFactory {

    private ConnectionFactory() {
    }

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException(
                    "Driver JDBC do MySQL (mysql-connector-j) nao encontrado no classpath.", e);
        }

        return DriverManager.getConnection(
                AppConfig.JDBC_URL,
                AppConfig.DB_USER,
                AppConfig.DB_PASSWORD
        );
    }
}
