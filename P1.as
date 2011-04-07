; Definicao de constantes

;STACK POINTER
SP_INICIAL	EQU     FDFFh


;INTERRUPCOES
TAB_INT0	EQU     FE00h
TAB_INT1	EQU     FE0Bh
MASCARA_INT	EQU     0000100000000001b



;I/O
DISP7S1         EQU     FFF0h
DISP7S2         EQU     FFF1h
DISP7S3         EQU     FFF2h
DISP7S4         EQU     FFF3h
LCD_WRITE       EQU     FFF5h
LEDS            EQU     FFF8h
INTERRUPTORES   EQU     FFF9h
IO_CURSOR       EQU     FFFCh
IO_WRITE        EQU     FFFEh
FIM_TEXTO       EQU     '@'
LIMPAR_JANELA   EQU     FFFFh
TEXTO_ESTADO    EQU     FFFDh
MUDA_LINHA	EQU	0100h
MUDA_LADO	EQU	000Ah
PAREDE		EQU	'|'
BASE		EQU	'-'
CANTO		EQU	'+'
FUNDO		EQU	'-'

		ORIG	8000h
TITULO		STR	'Jogo Line Breaker', FIM_TEXTO
PONTUACAO	STR	'Pontuação maxima:', FIM_TEXTO
VALOR_PONT	STR	'0', FIM_TEXTO
PREMIR_JOG	STR	'Premir uma tecla para', FIM_TEXTO
PREMIR_JOG2	STR	'jogar', FIM_TEXTO

; Posições onde vão ser escritas as strings
POS_TITULO	EQU	032Eh
POS_PONTUACAO	EQU	062Eh
POS_VALOR_PONT	EQU	0760h
POS_PREMIR_JOG	EQU	096Dh
POS_PREMIR_JOG2	EQU	0A6Dh

	


;Posições da coluna esquerda
POS_LIM_ESQ  	EQU	0020h
POS_FIM_ESQ	EQU	1320h

;Posições da coluna direita
POS_LIM_DIR	EQU	002Ah
POS_FIM_DIR	EQU	132Ah

;Posição do canto esquerdo
POS_CANTOE	EQU	1420h

;Posição do canto direito
POS_CANTOD	EQU	142Ah

;Posição do 1º caracter do fundo
POS_INI_FUNDO	EQU	1421h

;Ultima posição do caracter do fundo
POS_FIM_FUNDO	EQU	1429h

		ORIG	0000h
		JMP	inicio

LimiteEsquerdo:		PUSH	R1
			PUSH	R2
			PUSH	R3		
			MOV	R1, PAREDE		
			MOV	R2, POS_LIM_ESQ
			MOV	R3, POS_FIM_ESQ         
Cicl:			MOV	M[IO_CURSOR], R2	
			MOV	M[IO_WRITE], R1 
	                ADD	R2, MUDA_LINHA					
			CMP	R3, R2
			BR.NN	Cicl
			POP	R3
			POP	R2
			POP	R1
			RET
			

LimiteDireito:		PUSH	R1
			PUSH	R2
			PUSH	R3
			MOV	R1, PAREDE
			MOV	R2, POS_LIM_DIR
			MOV	R3, POS_FIM_DIR
Cicl2:			MOV	M[IO_CURSOR], R2
			MOV	M[IO_WRITE], R1
			ADD	R2, MUDA_LINHA
			CMP	R3, R2
			BR.NN	Cicl2
			POP	R3
			POP	R2
			POP	R1
			RET


Cantos:			PUSH	R1
			PUSH	R2
			MOV	R1, CANTO
			MOV	R2, POS_CANTOE
			MOV	R3, POS_CANTOD
Cicl3:			MOV	M[IO_CURSOR], R2
			MOV	M[IO_WRITE], R1
			ADD	R2, MUDA_LADO
			CMP	R3, R2
			BR.NN	Cicl3
			POP	R2
			POP	R1
			RET	

Fundo:			PUSH	R1
			PUSH	R2
			MOV	R1, FUNDO
			MOV	R2, POS_INI_FUNDO
			MOV	R3, POS_FIM_FUNDO
Cicl4:			MOV	M[IO_CURSOR], R2
			MOV	M[IO_WRITE], R1
			INC	R2
			CMP	R3,R2
			BR.NN	Cicl4
			POP	R2
			POP	R1
			RET	

EscreveMens:	PUSH	TITULO
		PUSH	POS_TITULO
		CALL	EscString
		PUSH	PONTUACAO
		PUSH	POS_PONTUACAO
		CALL	EscString
		PUSH	VALOR_PONT
		PUSH	POS_VALOR_PONT
		CALL	EscString
		PUSH	PREMIR_JOG
		PUSH	POS_PREMIR_JOG
		CALL	EscString
		PUSH	PREMIR_JOG2
		PUSH	POS_PREMIR_JOG2
		CALL	EscString			






; posição da margem direita

DPOS_PISTA0   	EQU     002Ah
DPOS_PISTA1   	EQU     012Ah
DPOS_PISTA2   	EQU     022Ah
DPOS_PISTA3   	EQU     032Ah
DPOS_PISTA4   	EQU     042Ah
DPOS_PISTA5   	EQU     052Ah
DPOS_PISTA6   	EQU     062Ah
DPOS_PISTA7   	EQU     072Ah
DPOS_PISTA8   	EQU     082Ah
DPOS_PISTA9   	EQU     092Ah
DPOS_PISTA10 	EQU     0A2Ah  
DPOS_PISTA11 	EQU     0B2Ah  
DPOS_PISTA12 	EQU     0C2Ah  
DPOS_PISTA13 	EQU     0D2Ah
DPOS_PISTA14 	EQU     0E2Ah  
DPOS_PISTA15 	EQU     0F2Ah  
DPOS_PISTA16 	EQU     102Ah  
DPOS_PISTA17 	EQU     112Ah  
DPOS_PISTA18 	EQU     122Ah
DPOS_PISTA19 	EQU     132Ah  


;posição da margem fundo

POS_CANTO0	EQU	1420h
POS_FPISTA0	EQU	1421h
POS_FPISTA1	EQU     1422h
POS_FPISTA2	EQU  	1423h
POS_FPISTA3	EQU   	1424h
POS_FPISTA4	EQU   	1425h
POS_FPISTA5	EQU   	1426h	
POS_FPISTA6	EQU   	1427h
POS_FPISTA7	EQU   	1428h
POS_FPISTA8	EQU   	1429h
POS_CANTO1	STR	142Ah


 
         

EscString:      PUSH    R1
                PUSH    R2
                PUSH    R3
                MOV     R2, M[SP+6]   ; Apontador para inicio da "string"
                MOV     R3, M[SP+5]   ; Localizacao do primeiro carater
Ciclo:          MOV     M[IO_CURSOR], R3
                MOV     R1, M[R2]
                CMP     R1, FIM_TEXTO
                BR.Z    FimEsc
                CALL    EscCar
                INC     R2
                INC     R3
                BR      Ciclo
FimEsc:         POP     R3
                POP     R2
                POP     R1
                RETN    2                


;===============================================================================
;EscCar : Rotina que escreve no ecra 1 caracter
;         Entradas: R1
;         Saidas:-----
;         Efeitos: Escreve no Ecra 1 caracter
;===============================================================================


EscCar:		PUSH	R1
		MOV	R1, M[SP+3]      
		MOV     M[IO_WRITE], R1
		POP	R1
		RETN	1

;===============================================================================
;leCar : Rotina que efectua a leitura de um caracter
;       proveniente do teclado (fica em ciclo enquanto nao for
;       primida nenhuma tecla)

;       Entradas:----
;       Saidas: R1
;       Efeitos: Altera R1
;================================================================================



LeCar:                  CMP     R0, M[TEXTO_ESTADO]
                        BR.Z    LeCar
                        MOV     R1,M[LIMPAR_JANELA]
                        RET




;===============================================================================
; LimpaJanela:  Rotina que limpa a janela de texto
;               Entradas:-----
;               Saidas:-----
;               Efeitos:-----
;===============================================================================

LimpaJanela:            PUSH    R2
                        MOV     R2, LIMPAR_JANELA
                        MOV     M[IO_CURSOR], R2
                        POP     R2
                        RET

 


; Programa Principal

inicio:         MOV     R1, SP_INICIAL
                MOV     SP, R1
                ENI
                CALL    LimpaJanela
		CALL	LimiteEsquerdo
		CALL	LimiteDireito
		CALL	Cantos
		CALL	Fundo 
		CALL	EscreveMens	
Fim:            CALL    LeCar  
                CALL    Fim
