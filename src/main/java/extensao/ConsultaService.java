package extensao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class ConsultaService {

    public void cargaHorariaPorDiscente() throws SQLException {
        String sql =
                "SELECT pe.nome AS discente, d.matricula, " +
                "       COALESCE(SUM(p.horas_realizadas), 0) AS horas_total " +
                "FROM discente d " +
                "JOIN pessoa pe ON pe.id_pessoa = d.id_pessoa " +
                "LEFT JOIN participacao p ON p.id_discente = d.id_discente AND p.status <> 'cancelada' " +
                "GROUP BY d.id_discente, pe.nome, d.matricula " +
                "ORDER BY horas_total DESC";

        executarEImprimir(sql);
    }

    public void acoesComMaisParticipantes() throws SQLException {
        String sql =
                "SELECT a.titulo AS acao, m.nome AS modalidade, " +
                "       COUNT(p.id_participacao) AS total_participantes " +
                "FROM acao_extensao a " +
                "JOIN modalidade_extensao m ON m.id_modalidade = a.id_modalidade " +
                "LEFT JOIN participacao p ON p.id_acao = a.id_acao " +
                "GROUP BY a.id_acao, a.titulo, m.nome " +
                "ORDER BY total_participantes DESC";

        executarEImprimir(sql);
    }

    public void coordenadoresComMaisAcoes() throws SQLException {
        String sql =
                "SELECT pe.nome AS coordenador, pe.email, " +
                "       COUNT(pp.id_coordenacao) AS total_acoes_coordenadas " +
                "FROM participacao_pessoa pp " +
                "JOIN pessoa pe ON pe.id_pessoa = pp.id_pessoa " +
                "GROUP BY pe.id_pessoa, pe.nome, pe.email " +
                "ORDER BY total_acoes_coordenadas DESC";

        executarEImprimir(sql);
    }

    public void instituicoesEAcoesVinculadas() throws SQLException {
        String sql =
                "SELECT i.nome AS instituicao, i.tipo, a.titulo AS acao, ai.papel " +
                "FROM acao_instituicao ai " +
                "JOIN instituicao_parceira i ON i.id_instituicao = ai.id_instituicao " +
                "JOIN acao_extensao a ON a.id_acao = ai.id_acao " +
                "ORDER BY i.nome, a.titulo";

        executarEImprimir(sql);
    }

    public void acoesPorStatus() throws SQLException {
        String sql =
                "SELECT status_Aprocacao AS status, COUNT(*) AS quantidade " +
                "FROM acao_extensao " +
                "GROUP BY status_Aprocacao " +
                "ORDER BY quantidade DESC";

        executarEImprimir(sql);
    }

    public void distribuicaoPorModalidade() throws SQLException {
        String sql =
                "SELECT m.nome AS modalidade, COUNT(a.id_acao) AS total_acoes " +
                "FROM modalidade_extensao m " +
                "LEFT JOIN acao_extensao a ON a.id_modalidade = m.id_modalidade " +
                "GROUP BY m.id_modalidade, m.nome " +
                "ORDER BY total_acoes DESC";

        executarEImprimir(sql);
    }

    public void planosDeTrabalhoNaoAprovados() throws SQLException {
        String sql =
                "SELECT pl.id_plano, pe.nome AS discente, a.titulo AS acao, pl.data_submissao " +
                "FROM plano_trabalho pl " +
                "JOIN participacao p  ON p.id_participacao = pl.id_participacao " +
                "JOIN discente d      ON d.id_discente = p.id_discente " +
                "JOIN pessoa pe       ON pe.id_pessoa = d.id_pessoa " +
                "JOIN acao_extensao a ON a.id_acao = p.id_acao " +
                "WHERE pl.aprovado <> 'sim' " +
                "ORDER BY pl.data_submissao";

        executarEImprimir(sql);
    }

    public void horasValidadasPorCoordenador() throws SQLException {
        String sql =
                "SELECT pe.nome AS coordenador, c.siape, " +
                "       COUNT(v.id_validacao) AS total_validacoes, " +
                "       COALESCE(SUM(v.horas_validadas), 0) AS total_horas_validadas " +
                "FROM Coordenador c " +
                "JOIN pessoa pe ON pe.id_pessoa = c.id_pessoa " +
                "LEFT JOIN validacao v ON v.id_validador = c.id_Coordenador " +
                "GROUP BY c.id_Coordenador, pe.nome, c.siape " +
                "ORDER BY total_horas_validadas DESC";

        executarEImprimir(sql);
    }

    public void situacaoMatriculaPorPeriodo(int ano, int semestre) throws SQLException {
        String sql =
                "SELECT pe.nome AS discente, d.matricula, m.ano, m.semestre, m.status " +
                "FROM matricula m " +
                "JOIN discente d ON d.id_discente = m.id_discente " +
                "JOIN pessoa pe  ON pe.id_pessoa = d.id_pessoa " +
                "WHERE m.ano = ? AND m.semestre = ? " +
                "ORDER BY pe.nome";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, ano);
            ps.setInt(2, semestre);
            try (ResultSet rs = ps.executeQuery()) {
                ResultSetPrinter.print(rs);
            }
        }
    }

    public void alunosPorProjeto(String tituloAcao) throws SQLException {
        String sql =
                "SELECT a.titulo AS acao, pe.nome AS discente, d.matricula, " +
                "       p.data_entrada, p.data_saida, p.horas_realizadas, p.status " +
                "FROM participacao p " +
                "JOIN acao_extensao a ON a.id_acao = p.id_acao " +
                "JOIN discente d      ON d.id_discente = p.id_discente " +
                "JOIN pessoa pe       ON pe.id_pessoa = d.id_pessoa " +
                "WHERE a.titulo LIKE ? " +
                "ORDER BY pe.nome";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + tituloAcao + "%");
            try (ResultSet rs = ps.executeQuery()) {
                ResultSetPrinter.print(rs);
            }
        }
    }

    public void rankingInstituicoesParceiras() throws SQLException {
        String sql =
                "SELECT i.nome AS instituicao, i.tipo, " +
                "       COUNT(ai.id_acao) AS total_acoes_vinculadas " +
                "FROM instituicao_parceira i " +
                "LEFT JOIN acao_instituicao ai ON ai.id_instituicao = i.id_instituicao " +
                "GROUP BY i.id_instituicao, i.nome, i.tipo " +
                "ORDER BY total_acoes_vinculadas DESC";

        executarEImprimir(sql);
    }

    private void executarEImprimir(String sql) throws SQLException {
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            ResultSetPrinter.print(rs);
        }
    }
}
