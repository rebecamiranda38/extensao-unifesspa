package extensao;

public final class AppConfig {

    public static final String DB_HOST = "127.0.0.1";
    public static final String DB_PORT = "3306";
    public static final String DB_NAME = "extensao_unifesspa";

    public static final String DB_USER = "root";
    public static final String DB_PASSWORD = "Rebeca56!";

    public static final String JDBC_URL =
            "jdbc:mysql://" + DB_HOST + ":" + DB_PORT + "/" + DB_NAME
                    + "?useSSL=false&serverTimezone=America/Belem&allowPublicKeyRetrieval=true";

    private AppConfig() {
    }
}
