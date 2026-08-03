Algoritmo "semnome"
const
     EN_GASTA = 1
     EN_INICIAL = 0
     EN_GASTA_ARMADILHA = 16
     EN_BONUS = 20
     MOEDA = 10

     TAM_TABULEIRO = 3
     CARACTERES_PERMITIDOS = "XTABM."
     
tipo
    Jogador_Estado = Registro
    nome : caractere
    dinheiro : inteiro
    energia : inteiro
    
    fimregistro
    
Var
   jogador : Jogador_Estado
   tabuleiro : vetor[1..TAM_TABULEIRO , 1..TAM_TABULEIRO] de caractere
   i , j :inteiro
   caracter_escolhido : caractere
   

Funcao validacao_caractere(C_digitado , C_permitidos : caractere): logico
    inicio
    
    se (C_digitado <> "") e (pos(C_digitado, C_permitidos) > 0) entao
        retorne Verdadeiro
    senao
        retorne Falso
    fimse
fimfuncao

Procedimento Mostrar_mapa()
    var
        linha , coluna : inteiro
    inicio
    
        para linha de 1 ate TAM_TABULEIRO faca
             para coluna de 1 ate TAM_TABULEIRO faca
                 escreva(tabuleiro[linha,coluna])
             
             fimpara
             
        escreval()
        fimpara
fimprocedimento


Inicio

para i de 1 ate TAM_TABULEIRO faca
    para j de 1 ate TAM_TABULEIRO faca
    
        repita
            escreva("Digite um dos seguintes caracteres [X, T, A, B, M] para a posicao [", i, ",", j, "]: ")
            leia(tabuleiro[i,j])
            
            se nao validacao_caractere(tabuleiro[i,j], CARACTERES_PERMITIDOS) entao
                escreval("Entrada inválida! Digite apenas X, T, A, B, M , . ")
            fimse
            
        ate validacao_caractere(tabuleiro[i,j], CARACTERES_PERMITIDOS)
   
    fimpara
fimpara

Mostrar_mapa()





Fimalgoritmo