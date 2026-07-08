package extensao;


import java.sql.Connection;
import java.sql.SQLException;
import java.util.Scanner;

public class Main {

    private static final Scanner SCANNER = new Scanner(System.in);
    private static final ConsultaService consultaService = new ConsultaService();

    public static void main(String[] args) {
        System.out.println("-----------------------------------------------------------------");
        System.out.println(" SISTEMA DE GESTAO DE ATIVIDADES DE EXTENSAO UNIVERSITARIA");
        System.out.println("-----------------------------------------------------------------");

        if (!testarConexao()) {
            System.out.println("\nNao foi possivel conectar ao banco de dados");
            return;
        }

        boolean continuar = true;
        while (continuar) {
            exibirMenu();
            int opcao = lerOpcao();
            try {
                continuar = executarOpcao(opcao);
            } catch (SQLException e) {
                System.out.println("\nErro ao executar a consulta: " + e.getMessage());
            }
            if (continuar) {
                System.out.println("\nAperte ENTER para continuar");
                SCANNER.nextLine();
            }
        }

        System.out.println("\nFim.");
        SCANNER.close();
    }

    private static boolean testarConexao() {
        try (Connection conn = ConnectionFactory.getConnection()) {
            System.out.println("\nConexao feita!");
            return true;
        } catch (SQLException e) {
            System.out.println("\nFalha na conexao");
            return false;
        }
    }

    private static void exibirMenu() {
        System.out.println("\n----------------------------- MENU -----------------------------");
        System.out.println(" 1  - Carga horária total acumulada por discente");
        System.out.println(" 2  - Ações de extensão com mais participantes");
        System.out.println(" 3  - Coordenadores que mais coordenam ações");
        System.out.println(" 4  - Instituiçoes parceiras e ações vinculadas");
        System.out.println(" 5  - Quantidade de ações por status");
        System.out.println(" 6  - Distribuição das ações por modalidade de extensão");
        System.out.println(" 7  - Planos de trabalho ainda não aprovados");
        System.out.println(" 8 - Total de horas validadas por Coordenador");
        System.out.println(" 9  - Situação de matricula dos discentes por ano/semestre");
        System.out.println(" 10  - Ranking de instituições parceiras por número de ações");
        System.out.println(" 11  - Alunos que participam/participaram de um projeto específico");
        System.out.println(" 0  - Sair");
        System.out.println("-------------------------------------------------------------------");
        System.out.print("Escolha uma opção: ");
    }

    private static int lerOpcao() {
        try {
            int opcao = Integer.parseInt(SCANNER.nextLine().trim());
            return opcao;
        } catch (NumberFormatException e) {
            return -1;
        }
    }

    private static boolean executarOpcao(int opcao) throws SQLException {
        System.out.println();
        switch (opcao) {

            case 1:
                consultaService.cargaHorariaPorDiscente();
                break;
            case 2:
                consultaService.acoesComMaisParticipantes();
                break;
            case 3:
                consultaService.coordenadoresComMaisAcoes();
                break;
            case 4:
                consultaService.instituicoesEAcoesVinculadas();
                break;
            case 5:
                consultaService.acoesPorStatus();
                break;
            case 6:
                consultaService.distribuicaoPorModalidade();
                break;
            case 7:
                consultaService.planosDeTrabalhoNaoAprovados();
                break;
            case 8:
                consultaService.horasValidadasPorCoordenador();
                break;
            case 9:
                System.out.print("Digite o ano (ex: 2025): ");
                int ano = lerInteiro();
                System.out.print("Digite o semestre (1 ou 2): ");
                int semestre = lerInteiro();
                consultaService.situacaoMatriculaPorPeriodo(ano, semestre);
                break;
            case 10:
                consultaService.rankingInstituicoesParceiras();
                break;
            case 11:
                System.out.print("Digite o nome (ou parte do nome) do projeto/ação: ");
                String titulo = SCANNER.nextLine().trim();
                consultaService.alunosPorProjeto(titulo);
                break;
            case 0:
                return false;
            default:
                System.out.println("Opção inválida. Tente novamente.");
        }
        return true;
    }

    private static int lerInteiro() {
        try {
            return Integer.parseInt(SCANNER.nextLine().trim());
        } catch (NumberFormatException e) {
            return 0;
        }
    }
}
