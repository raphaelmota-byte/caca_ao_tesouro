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


# Formulação do código:

O código será feito visando a programação funcional, logo será dividida em diversar funções e procedimentos como:
- mostrar_tabuleiro(proc)
- calcular_mov(func)
- validar_mov(func)
- verificar_obstáculo(func)
- mover(proc)
- finalizar_game(proc)
- validar_caracter(proc)
  
