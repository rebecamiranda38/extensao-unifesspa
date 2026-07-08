package extensao;

import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public final class ResultSetPrinter {

    private ResultSetPrinter() {
    }

    public static void print(ResultSet rs) throws SQLException {
        ResultSetMetaData meta = rs.getMetaData();
        int colCount = meta.getColumnCount();

        List<String[]> rows = new ArrayList<>();
        String[] header = new String[colCount];
        for (int i = 1; i <= colCount; i++) {
            header[i - 1] = meta.getColumnLabel(i);
        }
        rows.add(header);

        int rowCount = 0;
        while (rs.next()) {
            String[] row = new String[colCount];
            for (int i = 1; i <= colCount; i++) {
                Object value = rs.getObject(i);
                row[i - 1] = (value == null) ? "NULL" : value.toString();
            }
            rows.add(row);
            rowCount++;
        }

        if (rowCount == 0) {
            System.out.println("Nenhum registro encontrado.");
            return;
        }

        int[] widths = new int[colCount];
        for (String[] row : rows) {
            for (int i = 0; i < colCount; i++) {
                widths[i] = Math.max(widths[i], row[i].length());
            }
        }

        printSeparator(widths);
        printRow(rows.get(0), widths);
        printSeparator(widths);
        for (int r = 1; r < rows.size(); r++) {
            printRow(rows.get(r), widths);
        }
        printSeparator(widths);
        System.out.println("Total de registros: " + rowCount);
    }

    private static void printRow(String[] row, int[] widths) {
        StringBuilder sb = new StringBuilder("|");
        for (int i = 0; i < row.length; i++) {
            sb.append(" ").append(pad(row[i], widths[i])).append(" |");
        }
        System.out.println(sb);
    }

    private static void printSeparator(int[] widths) {
        StringBuilder sb = new StringBuilder("+");
        for (int w : widths) {
            sb.append("-".repeat(w + 2)).append("+");
        }
        System.out.println(sb);
    }

    private static String pad(String value, int width) {
        return value + " ".repeat(Math.max(0, width - value.length()));
    }
}
