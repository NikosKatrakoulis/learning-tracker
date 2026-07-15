package db.migration;

import org.flywaydb.core.api.migration.BaseJavaMigration;
import org.flywaydb.core.api.migration.Context;

import java.io.InputStream;
import java.nio.file.Path;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class V11__SeedPdfsToDatabase extends BaseJavaMigration {

    @Override
    public void migrate(Context context) throws Exception {
        var conn = context.getConnection();

        ResultSet rs = conn.createStatement().executeQuery(
                "SELECT id, pdf_path FROM units WHERE pdf_path IS NOT NULL AND pdf_data IS NULL");

        while (rs.next()) {
            long unitId = rs.getLong("id");
            String pdfPath = rs.getString("pdf_path");

            InputStream stream = getClass().getClassLoader()
                    .getResourceAsStream("lessons/" + pdfPath);
            if (stream == null) continue;

            byte[] data = stream.readAllBytes();
            stream.close();
            String fileName = Path.of(pdfPath).getFileName().toString();

            PreparedStatement ps = conn.prepareStatement(
                    "UPDATE units SET pdf_data = ?, pdf_name = ? WHERE id = ?");
            ps.setBytes(1, data);
            ps.setString(2, fileName);
            ps.setLong(3, unitId);
            ps.executeUpdate();
            ps.close();
        }
        rs.close();
    }
}
