# caca_ao_tesouro
repositório onde eu eu o gabriel desenvelvemos um código de caça ao tesouro no visualg


# Objetivo do trabalho:

  CAÇA AO TESOURO

DESCRIÇÃO
O jogo de Caça ao Tesouro consiste em explorar uma ilha em busca de um
tesouro escondido. A ilha é representada por um tabuleiro 10 x 10, no qual
existem obstáculos, armadilhas, bônus e um tesouro. O objetivo é encontrar o
tesouro antes que a energia do jogador chegue a zero.
SÍMBOLOS

Cada posição do tabuleiro poderá conter:

  Símbolo Significado Símbolo Significado
  . espaço vazio 
  A armadilha
  X obstáculo 
  B bônus de energia
  T tesouro 
  M moeda

CONFIGURAÇÃO INICIAL
• o jogo é iniciado com o jogador na posição (1,1);
• tesouro, obstáculos, armadilhas e bônus são distribuídos aleatoriamente
pelo tabuleiro;
• o jogador possui 100 pontos de energia e 0 moeda.

REGRAS
  • cada movimento consome 1 ponto de energia;
  • cada armadilha consome 15 pontos de energia;
  • cada bônus acumula 20 pontos de energia;
  • cada moeda acumula 10 moedas;
  • ao encontrar o tesouro, o jogo termina com vitória;
  • caso a energia chegue a zero, o jogador perde o jogo.
  
MOVIMENTAÇÃO
O jogador pode se mover utilizando:
  - W (cima)
  - S (baixo)
  - A (esquerda)
  - D (direita)
OBS.: não é permitido sair do tabuleiro e nem atravessar obstáculos.

REQUISITOS
• a cada jogada deve ser exibida a configuração do tabuleiro até o
momento;
• ao final da partida, devem ser apresentados:
1. número de movimentos;
2. energia restante;
3. moedas coletadas;
4. armadilhas encontradas;
5. bônus coletados;
   
AVALIAÇÃO
1. o trabalho pode ser feito em dupla e as duplas devem ser informadas em
um comentário no preâmbulo do algoritmo;
2. mesmo sendo em dupla, cada integrante da dupla deve fazer a postagem
do arquivo (.alg) do algoritmo no Classroom;
3. o trabalho só será válido se estiver funcionando e se for apresentado
pelo(s) aluno(s) no laboratório;
4. a atividade vale 2,0 pontos na nota correspondente à primeira metade do
semestre.

# Formulação do código

O código foi feito visando a programação funcional, dividido em funções e procedimentos organizados por responsabilidade:

## Validação de entrada
- **validacao_caractere** (func) — verifica se um caractere digitado está dentro de um conjunto de caracteres permitidos.

## Geração do tabuleiro
- **montar_lista_itens** (proc) — monta a lista de itens (paredes, armadilhas, bônus, moedas, tesouro) que serão distribuídos pelo tabuleiro, na quantidade definida pelas constantes.
- **montar_posicoes_disponiveis** (proc) — lista todas as casas do tabuleiro, exceto a posição inicial [1,1].
- **embaralhar_posicoes** (proc) — embaralha a ordem das casas disponíveis usando o algoritmo Fisher-Yates, garantindo distribuição aleatória sem repetição.
- **gerar_tabuleiro** (proc) — combina a lista de itens com as posições já embaralhadas para preencher o tabuleiro real, e inicializa o tabuleiro visível todo com "." (nada revelado ainda).

## Movimento e validação
- **calcular_mov_x** (func) — calcula o deslocamento no eixo X a partir da direção digitada (A/D).
- **calcular_mov_y** (func) — calcula o deslocamento no eixo Y a partir da direção digitada (W/S).
- **validar_mov** (func) — verifica se o movimento é válido, checando limites do tabuleiro e presença de paredes.
- **revelar_parede_se_houver** (proc) — revela uma parede no tabuleiro visível quando o jogador tenta se mover contra ela, mesmo que o movimento seja bloqueado.

## Efeitos das casas
- **verificar_condicao_casa** (proc) — aplica o efeito da casa em que o jogador está (armadilha, bônus, moeda ou tesouro) e atualiza o estado do jogador.

## Exibição
- **mostrar_mapa** (proc) — exibe o tabuleiro visível (com fog of war), mostrando apenas as casas já reveladas.
- **revelar_casa_atual** (proc) — copia o conteúdo real da casa atual do jogador para o tabuleiro visível.
- **mostrar_mapa_debug** (proc) — exibe o tabuleiro real completo, sem esconder nada, usado apenas para depuração.


## Constantes de configuração

O código foi pensado para que ajustes futuros sejam feitos apenas mexendo nas constantes, sem precisar alterar a lógica interna das funções.

### Regras do jogo
- **EN_INICIAL** — energia inicial do jogador ao começar o jogo.
- **EN_GASTA** — energia gasta a cada movimento realizado.
- **EN_GASTA_ARMADILHA** — energia perdida ao cair em uma armadilha.
- **EN_BONUS** — energia ganha ao pegar um bônus.
- **MOEDA** — quantidade de dinheiro ganha ao pegar uma moeda.

### Tabuleiro
- **TAM_TABULEIRO** — tamanho do tabuleiro (número de linhas e colunas). Hoje é 3, gerando um tabuleiro 3x3.
- **CARACTERES_PERMITIDOS** — conjunto de caracteres válidos para representar o conteúdo de uma casa ("X", "T", "A", "B", "M", ".").
- **DIRECAO_PERMITIDA** — conjunto de caracteres válidos para movimentação (A, D, W, S).

### Quantidade de itens no tabuleiro
- **QTD_PAREDES** — quantidade de paredes (X) geradas no tabuleiro.
- **QTD_ARMADILHAS** — quantidade de armadilhas (A) geradas.
- **QTD_BONUS** — quantidade de bônus (B) gerados.
- **QTD_MOEDAS** — quantidade de moedas (M) geradas.
- **QTD_TESOUROS** — quantidade de tesouros (T) gerados. Deve ser sempre 1, já que encontrar o tesouro é a condição de vitória.
- **TOTAL_ITENS** — soma automática de todas as quantidades acima. Usada para validar se o total de itens cabe no tabuleiro.
- **TOTAL_CASAS** — número de casas disponíveis para receber itens (todas exceto a posição inicial [1,1]).

> Ao ajustar `TAM_TABULEIRO` ou as quantidades de itens, é importante garantir que `TOTAL_ITENS` não ultrapasse `TOTAL_CASAS` — o código já faz essa verificação no início da execução e exibe uma mensagem de erro caso isso aconteça.
