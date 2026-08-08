Algoritmo "semnome"
const
     EN_GASTA = 1
     EN_INICIAL = 0
     EN_GASTA_ARMADILHA = 16
     EN_BONUS = 20
     MOEDA = 10

     TAM_TABULEIRO = 3
     CARACTERES_PERMITIDOS = "XTABM."
     DIRECAO_PERMITIDA = "ADWS"


tipo
    Jogador_Estado = Registro
    nome : caractere
    dinheiro : inteiro
    energia : inteiro
    posicao_x , posicao_y : inteiro

    fimregistro

Var
   jogador : Jogador_Estado
   tabuleiro : vetor[1..TAM_TABULEIRO , 1..TAM_TABULEIRO] de caractere
   aux_tabuleiro : caractere
   i , j :inteiro
   caracter_escolhido , direcao_atual : caractere
   deslocamento_x , deslocamento_y: inteiro
   flag : inteiro



Funcao validacao_caractere(C_digitado , C_permitidos : caractere): logico
    inicio

    se (C_digitado <> "") e (pos(C_digitado, C_permitidos) > 0) entao
        retorne Verdadeiro
    senao
        retorne Falso
    fimse
fimfuncao

Procedimento preencher_tabuleiro()
var
    linha, coluna : inteiro
inicio

    para linha de 1 ate TAM_TABULEIRO faca
        para coluna de 1 ate TAM_TABULEIRO faca

            repita
                escreva( "Digite o caractere da posição [",linha,",",coluna, "]: "  )
                leia( tabuleiro[linha, coluna])
            ate validacao_caractere(tabuleiro[linha, coluna],CARACTERES_PERMITIDOS)

        fimpara
    fimpara
fimprocedimento

Procedimento mostrar_mapa()
    var
        linha , coluna : inteiro
    inicio

        para linha de 1 ate TAM_TABULEIRO faca
             para coluna de 1 ate TAM_TABULEIRO faca
                 escreva(tabuleiro[linha,coluna] , " ")
                 
             fimpara
        escreval()
        fimpara
fimprocedimento

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
       se tabuleiro[novo_y , novo_x] = "X" entao
           retorne Falso
       senao
           retorne Verdadeiro
       fimse
       
    fimse
fimfuncao



Inicio
flag <- 0

jogador.posicao_x <- 1
jogador.posicao_y <- 1

preencher_tabuleiro()

aux_tabuleiro <- tabuleiro[jogador.posicao_y , jogador.posicao_x]

Enquanto FLAG <> -1 faca
    tabuleiro[jogador.posicao_y , jogador.posicao_x] <- "J"
    mostrar_mapa()

    repita
        escreva("digite para qual direção vc vai(use AWSD): ")
        leia(direcao_atual)

        se nao validacao_caractere(direcao_atual , DIRECAO_PERMITIDA) entao
            escrevaL("Digite apenas os caracteres válidos!! ")
        fimse
    ate validacao_caractere(direcao_atual , DIRECAO_PERMITIDA)

    tabuleiro[jogador.posicao_y , jogador.posicao_x] <- aux_tabuleiro

    se validar_mov(jogador.posicao_x, jogador.posicao_y, direcao_atual) entao
        jogador.posicao_x <- jogador.posicao_x + calcular_mov_x(direcao_atual)
        jogador.posicao_y <- jogador.posicao_y + calcular_mov_Y(direcao_atual)
        
        aux_tabuleiro <- tabuleiro[jogador.posicao_y , jogador.posicao_x]
    fimse

     escreva("digite -1 para interromper: ")
    leia(FLAG)


fimEnquanto
escreva("Posicao do jogador no final: ")
escreval(jogador.posicao_x)

Fimalgoritmo
