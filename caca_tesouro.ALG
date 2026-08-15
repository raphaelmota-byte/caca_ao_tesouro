Algoritmo "semnome"
const
     EN_GASTA = 1
     EN_INICIAL = 100
     EN_GASTA_ARMADILHA = 15
     EN_BONUS = 20
     MOEDA = 10

     TAM_TABULEIRO = 3
     CARACTERES_PERMITIDOS = "XTABM."
     DIRECAO_PERMITIDA = "ADWS"


     QTD_PAREDES = 2
     QTD_ARMADILHAS = 2
     QTD_BONUS = 1
     QTD_MOEDAS = 2
     QTD_TESOUROS = 1
     TOTAL_ITENS = QTD_PAREDES + QTD_ARMADILHAS + QTD_BONUS + QTD_MOEDAS + QTD_TESOUROS
     TOTAL_CASAS = TAM_TABULEIRO * TAM_TABULEIRO - 1
     
     MODO_DEBUG = FALSO


tipo
    Jogador_Estado = Registro
    nome : caractere
    dinheiro : inteiro
    energia : inteiro
    posicao_x , posicao_y : inteiro

    fimregistro

Var
   jogador : Jogador_Estado
   tabuleiro_real : vetor[1..TAM_TABULEIRO , 1..TAM_TABULEIRO] de caractere
   tabuleiro_visivel : vetor[1..TAM_TABULEIRO , 1..TAM_TABULEIRO] de caractere
   aux_tabuleiro : caractere

   lista_itens : vetor[1..TOTAL_ITENS] de caractere
   pos_linha , pos_coluna : vetor[1..TOTAL_CASAS] de inteiro

   direcao_atual : caractere
   contador_armadilhas  , contador_bonus: inteiro
   achou_tesouro : logico


// ===================== VALIDAÇÃO DE ENTRADA =====================

Funcao validacao_caractere(C_digitado , C_permitidos : caractere): logico
    inicio
    se (C_digitado <> "") e (pos(C_digitado, C_permitidos) > 0) entao
        retorne Verdadeiro
    senao
        retorne Falso
    fimse
fimfuncao

// ===================== GERAÇÃO DO TABULEIRO =====================

// Monta a lista de itens que vão ser distribuídos pelo tabuleiro.
// A ordem aqui dentro não importa pro resultado final, porque quem decide onde cada item
// vai parar é o embaralhamento das posições (feito em embaralhar_posicoes())

Procedimento montar_lista_itens()
    var
        i, indice : inteiro
    inicio
        indice <- 1
        para i de 1 ate QTD_PAREDES faca
            lista_itens[indice] <- "X"
            indice <- indice + 1
        fimpara

        para i de 1 ate QTD_ARMADILHAS faca
            lista_itens[indice] <- "A"
            indice <- indice + 1
        fimpara

        para i de 1 ate QTD_BONUS faca
            lista_itens[indice] <- "B"
            indice <- indice + 1
        fimpara

        para i de 1 ate QTD_MOEDAS faca
            lista_itens[indice] <- "M"
            indice <- indice + 1
        fimpara

        para i de 1 ate QTD_TESOUROS faca
            lista_itens[indice] <- "T"
            indice <- indice + 1
        fimpara
    fimprocedimento

// Lista todas as casas do tabuleiro, EXCETO a [1,1]. Guarda cada casa como um
// par de coordenadas nos vetores pos_linha[i] e pos_coluna[i].

Procedimento montar_posicoes_disponiveis()
    var
        linha, coluna, indice : inteiro
    inicio
        indice <- 1
        para linha de 1 ate TAM_TABULEIRO faca
            para coluna de 1 ate TAM_TABULEIRO faca

                se nao ((linha = 1) e (coluna = 1)) entao
                    pos_linha[indice] <- linha
                    pos_coluna[indice] <- coluna
                    indice <- indice + 1
                fimse

            fimpara
        fimpara
    fimprocedimento

// Embaralha a ORDEM das casas guardadas em pos_linha/pos_coluna,
// usando o algoritmo Fisher-Yates.
//
// Por que essa técnica: em vez de sortear uma casa aleatória pra cada
// item e ficar checando "essa casa já foi usada?" a gente simplesmente
// embaralha a lista de casas inteira uma única vez. Depois é só andar
// nela em ordem e distribuir os itens — cada casa é usada exatamente
// uma vez, sem repetição e sem loop de tentativa e erro.

// Funcionamento: percorremos o vetor de trás pra frente (do ultimo até o segundo)
// Para cada posição i, sorteamos um "indice_sorteado" entre 1 e i
// (ou seja, dentro da parte do vetor que ainda não foi "fechada") e trocamos o valor da
// posição i com o valor da posição sorteada. Isso garante que, ao final,
// toda posição teve a mesma chance de acabar em qualquer lugar do vetor

// pos_linha e pos_coluna são embaralhados juntos, usando o MESMO índice
// sorteado nos dois, porque eles são vetores paralelos: a posição i de
// um sempre corresponde à posição i do outro (juntos formam uma coordenada
// [linha,coluna] só). Se embaralhássemos cada vetor separadamente, essa
// correspondência se perderia e as coordenadas ficariam erradas.

Procedimento embaralhar_posicoes()
    var
        i, indice_sorteado : inteiro
        temp_linha, temp_coluna : inteiro
    inicio
        para i de TOTAL_CASAS ate 2 passo -1 faca
            // RandI(i) retorna um inteiro entre 0 e i-1, por isso somamos 1 pra obter um índice válido entre 1 e i
            indice_sorteado <- RandI(i) + 1

            // troca as coordenadas da posição i com as da posição sorteada
            temp_linha <- pos_linha[i]
            pos_linha[i] <- pos_linha[indice_sorteado]
            pos_linha[indice_sorteado] <- temp_linha

            temp_coluna <- pos_coluna[i]
            pos_coluna[i] <- pos_coluna[indice_sorteado]
            pos_coluna[indice_sorteado] <- temp_coluna
        fimpara
    fimprocedimento

// Junta tudo: distribui lista_itens (o conteúdo) nas posições já embaralhadas
//(pos_linha/pos_coluna), preenchendo o tabuleiro_real.
// Também inicializa o tabuleiro_visivel inteiro como "."

Procedimento gerar_tabuleiro()
    var
        i, linha, coluna : inteiro
    inicio
        tabuleiro_real[1,1] <- "."
        tabuleiro_visivel[1,1] <- "."

        // distribui os itens nas casas já embaralhadas, na ordem em que
        // aparecem em lista_itens e pos_linha/pos_coluna (índice a índice)
        para i de 1 ate TOTAL_ITENS faca
            linha <- pos_linha[i]
            coluna <- pos_coluna[i]
            tabuleiro_real[linha, coluna] <- lista_itens[i]
        fimpara

        // casas que sobraram (se TOTAL_ITENS for menor que TOTAL_CASAS) viram "."

        para i de (TOTAL_ITENS + 1) ate TOTAL_CASAS faca
            linha <- pos_linha[i]
            coluna <- pos_coluna[i]
            tabuleiro_real[linha, coluna] <- "."
        fimpara

        // tabuleiro_visivel começa inteiramente "."
        para linha de 1 ate TAM_TABULEIRO faca
            para coluna de 1 ate TAM_TABULEIRO faca
                tabuleiro_visivel[linha, coluna] <- "."
            fimpara
        fimpara
    fimprocedimento

// ===================== MOVIMENTO E VALIDAÇÃO =====================

Funcao calcular_mov_x(direcao:caractere): inteiro
 inicio
    escolha maiusc(direcao)
        caso "D"
            retorne 1
        caso "A"
              retorne (-1)
        outrocaso
            retorne 0

    fimescolha

fimfuncao

Funcao calcular_mov_y(direcao:caractere): inteiro
  inicio
        escolha maiusc(direcao)
            caso "W"
                 retorne (-1)
            caso "S"
                 retorne (1)
            outrocaso
                retorne 0
        fimescolha
fimfuncao

Funcao validar_mov(pos_x , pos_y:inteiro ; direcao:caractere):logico
    var
        novo_x , novo_y: inteiro
    inicio
        novo_x <- pos_x + calcular_mov_x(direcao)
        novo_y <- pos_y + calcular_mov_y(direcao)

        se (novo_x > TAM_TABULEIRO) ou (novo_x <= 0) ou (novo_y > TAM_TABULEIRO) ou (novo_y <= 0) entao
           retorne Falso
        senao
            se tabuleiro_real[novo_y , novo_x] = "X" entao
                retorne Falso
            senao
               retorne Verdadeiro
            fimse

        fimse
fimfuncao

// Verifica se a casa pra onde o jogador está tentando ir é uma parede,
// e se for, revela ela no tabuleiro_visivel — mesmo que o movimento
// não seja permitido (é isso que faz o "esbarrar na parede" funcionar).
// Repare que essa checagem de limites é parecida com a que já existe
// dentro de validar_mov(), mas aqui ela é feita separadamente porque
// precisamos "espiar" a casa de destino antes de decidir se o jogador
// realmente vai se mover pra lá.

Procedimento revelar_parede_se_houver(pos_x, pos_y : inteiro; direcao : caractere)
    var
        novo_x, novo_y : inteiro
    inicio
        novo_x <- pos_x + calcular_mov_x(direcao)
        novo_y <- pos_y + calcular_mov_y(direcao)

        se (novo_x >= 1) e (novo_x <= TAM_TABULEIRO) e (novo_y >= 1) e (novo_y <= TAM_TABULEIRO) entao
            se tabuleiro_real[novo_y, novo_x] = "X" entao
                tabuleiro_visivel[novo_y, novo_x] <- "X"
            fimse
        fimse
    fimprocedimento
    
// ===================== EFEITOS DAS CASAS =====================

Procedimento verificar_condicao_casa()
  inicio
      escolha tabuleiro_real[jogador.posicao_y , jogador.posicao_x]

          caso "A"
              jogador.energia <- jogador.energia - EN_GASTA_ARMADILHA
              contador_armadilhas <- contador_armadilhas + 1
              tabuleiro_real[jogador.posicao_y, jogador.posicao_x] <- "."
              
          caso "B"
              jogador.energia <- jogador.energia + EN_BONUS
              contador_bonus <- contador_bonus + 1
              tabuleiro_real[jogador.posicao_y, jogador.posicao_x] <- "."
              
          caso "M"
              jogador.dinheiro <- jogador.dinheiro + MOEDA
              tabuleiro_real[jogador.posicao_y, jogador.posicao_x] <- "."
              
          caso "T"
            achou_tesouro <- Verdadeiro

       fimescolha
fimprocedimento

// ===================== EXIBIÇÃO =====================

Procedimento mostrar_mapa()
    var
        linha , coluna : inteiro
    inicio
        para linha de 1 ate TAM_TABULEIRO faca
             para coluna de 1 ate TAM_TABULEIRO faca
                 escreva(tabuleiro_visivel[linha,coluna] , " ")

             fimpara
        escreval()
        fimpara
fimprocedimento

Procedimento revelar_casa_atual()
    inicio
        tabuleiro_visivel[jogador.posicao_y, jogador.posicao_x] <- tabuleiro_real[jogador.posicao_y, jogador.posicao_x]
    fimprocedimento


// Mostra o tabuleiro_real completo, sem esconder nada — só pra debug.
// Não devolve nem altera o tabuleiro_real, só empresta a posição do
// jogador na hora de imprimir (usando um "se" na exibição), então
// é seguro chamar isso a qualquer momento sem bagunçar o estado do jogo.

Procedimento mostrar_mapa_debug()
    var
        linha, coluna : inteiro
    inicio
        escreval("--- MAPA REAL (debug) ---")
        para linha de 1 ate TAM_TABULEIRO faca
            para coluna de 1 ate TAM_TABULEIRO faca
                se (linha = jogador.posicao_y) e (coluna = jogador.posicao_x) entao
                    escreva("J ")
                senao
                    escreva(tabuleiro_real[linha, coluna] , " ")
                fimse
            fimpara
            escreval()
        fimpara
        escreval("-------------------------")
    fimprocedimento

Inicio

se TOTAL_ITENS > TOTAL_CASAS entao
    escreval("ERRO: quantidade de itens maior que o número de casas disponíveis!")

fimse

jogador.posicao_x <- 1
jogador.posicao_y <- 1

jogador.energia <-  EN_INICIAL
contador_armadilhas <- 0
contador_bonus <- 0
achou_tesouro <- falso

// geração aleatória do tabuleiro
montar_lista_itens()
montar_posicoes_disponiveis()
embaralhar_posicoes()
gerar_tabuleiro()

aux_tabuleiro <- tabuleiro_visivel[jogador.posicao_y , jogador.posicao_x]

Enquanto (achou_tesouro = falso) e (jogador.energia > 0) faca
     se MODO_DEBUG = verdadeiro entao
        mostrar_mapa_debug()
     fimse

    tabuleiro_visivel[jogador.posicao_y , jogador.posicao_x] <- "J"
    mostrar_mapa()
    escreval("energia atual do jogador: " , jogador.energia)

    repita
        escreva("digite para qual direção vc vai(use AWSD): ")
        leia(direcao_atual)

        se nao validacao_caractere(direcao_atual , DIRECAO_PERMITIDA) entao
            escreval("Digite apenas os caracteres válidos!! ")
        fimse
    ate validacao_caractere(direcao_atual , DIRECAO_PERMITIDA)

    tabuleiro_visivel[jogador.posicao_y , jogador.posicao_x] <- aux_tabuleiro
    
    revelar_parede_se_houver(jogador.posicao_x, jogador.posicao_y, direcao_atual)

    se validar_mov(jogador.posicao_x, jogador.posicao_y, direcao_atual) entao
       jogador.posicao_x <- jogador.posicao_x + calcular_mov_x(direcao_atual)
       jogador.posicao_y <- jogador.posicao_y + calcular_mov_y(direcao_atual)
       jogador.energia <- jogador.energia - EN_GASTA

    // revela a casa nova antes de processar o efeito
       revelar_casa_atual()

       verificar_condicao_casa()

    // depois de processado (e zerado no real), reflete no visível também
       revelar_casa_atual()
       
       aux_tabuleiro <- tabuleiro_visivel[jogador.posicao_y , jogador.posicao_x]
fimse


fimEnquanto

escreval("caiu na armadilha:" ,contador_armadilhas , " vezes")
escreval("pegou:" ,jogador.dinheiro , " moedas")
escreval("pegou:" ,contador_bonus , " bonus")


Fimalgoritmo
