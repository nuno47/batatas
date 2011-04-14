; Definicao de constantes

;STACK POINTER
SP_INICIAL	EQU     FDFFh


;INTERRUPCOES
InterruptMask	EQU     FFFAh
TimerValue	EQU	FFF6h
TimerControl	EQU	FFF7h
Interrupts	EQU	8000h
TimeLong	EQU	0010h
EnableTimer	EQU	0001h

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
PECA4		EQU	'#'
POSPECAINIT	EQU	0025h
QUEDACOUNTDOWN	EQU	0010h

		ORIG	8000h
TITULO		STR	'Jogo Line Breaker',FIM_TEXTO
PONTUACAO	STR	'Pontuacao maxima:',FIM_TEXTO
VALOR_PONT	STR	'0', FIM_TEXTO
PREMIR_JOG	STR	'Premir uma tecla para',FIM_TEXTO
PREMIR_JOG2	STR	'jogar',FIM_TEXTO
PECAJOGAVEL	TAB	1
TEMPCHKPT	WORD	0000h

; Posições onde vão ser escritas as strings
POS_TITULO	EQU	032Eh
POS_PONTUACAO	EQU	062Eh
POS_VALOR_PONT	EQU	0736h
POS_PREMIR_JOG	EQU	0D2Dh
POS_PREMIR_JOG2	EQU	0E2Dh

	


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

		ORIG	FE0Fh	;FE00h + Fh (15)
INT15		WORD	TimerSub

		ORIG	0000h
		JMP	inicio

TimerSub:	PUSH	R1
		MOV	R1, TimeLong
		MOV	M[TimerValue], R1
		MOV	R1, EnableTimer
		MOV	M[TimerControl], R1
		MOV	R1, 1h
		MOV	M[TEMPCHKPT], R1
		POP 	R1
		RTI

LimiteEsquerdo:	PUSH	R1
		PUSH	R2
		PUSH	R3		
		MOV	R1, PAREDE		
		MOV	R2, POS_LIM_ESQ
		MOV	R3, POS_FIM_ESQ         
Cicl:		MOV	M[IO_CURSOR], R2	
		MOV	M[IO_WRITE], R1 
		ADD	R2, MUDA_LINHA					
		CMP	R3, R2
		BR.NN	Cicl
		POP	R3
		POP	R2
		POP	R1
		RET
			

LimiteDireito:	PUSH	R1
		PUSH	R2
		PUSH	R3
		MOV	R1, PAREDE
		MOV	R2, POS_LIM_DIR
		MOV	R3, POS_FIM_DIR
Cicl2:		MOV	M[IO_CURSOR], R2
		MOV	M[IO_WRITE], R1
		ADD	R2, MUDA_LINHA
		CMP	R3, R2
		BR.NN	Cicl2
		POP	R3
		POP	R2
		POP	R1
		RET


Cantos:		PUSH	R1
		PUSH	R2
		MOV	R1, CANTO
		MOV	R2, POS_CANTOE
		MOV	R3, POS_CANTOD
Cicl3:		MOV	M[IO_CURSOR], R2
		MOV	M[IO_WRITE], R1
		ADD	R2, MUDA_LADO
		CMP	R3, R2
		BR.NN	Cicl3
		POP	R2
		POP	R1
		RET	

Fundo:		PUSH	R1
		PUSH	R2
		MOV	R1, FUNDO
		MOV	R2, POS_INI_FUNDO
		MOV	R3, POS_FIM_FUNDO
Cicl4:		MOV	M[IO_CURSOR], R2
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
		RET		


;===============================================================================
; POSICAO STRING OUTPUT: Posições XY de linha/coluna onde vão Ser escritas
;                       as strings (1º caracter)
;===============================================================================            







 
         

EscString:      PUSH    R1
                PUSH    R2
                PUSH    R3
                MOV     R2, M[SP+6]   ; Apontador para inicio da "string"
                MOV     R3, M[SP+5]   ; Localizacao do primeiro carater
Ciclo:          MOV     M[IO_CURSOR], R3
                MOV     R1, M[R2]
                CMP     R1, FIM_TEXTO
                BR.Z    FimEsc
		MOV     M[IO_WRITE], R1
                INC     R2
                INC     R3
                BR      Ciclo
FimEsc:         POP     R3
                POP     R2
                POP     R1
                RETN    2                

DesenhaPeca:	PUSH	R1
		PUSH	R2
		;Chamada Aleatoria por implementar aqui
		;Fica registada em memoria e acedida através de:
		;CALL	EscolhePeca
		;MOV	R1, M[PECAJOGAVEL]
		MOV	R1, PECA4
		MOV	R2, POSPECAINIT
		MOV	M[IO_CURSOR], R2
		MOV	M[IO_WRITE], R1
		POP	R2
		POP	R1
		RET

MovePeca:	PUSH	R1
		PUSH	R2
		PUSH	R3
		PUSH	R4
		PUSH	R5
		;Pecas aleatorias por implementar
		;MOV	R1, M[PECAJOGAVEL]
		MOV	R1, PECA4
		MOV	R2, POSPECAINIT
		MOV	R3, QUEDACOUNTDOWN
		MOV	R5, 8h ;Deslocamentos para a esquerda
PreparaMD:	MOV	R4, 4h ;Deslocamentos para a direita

MoveDireita:	CMP	R3, R0 ;Peca ja deu uma volta
		JMP.Z	FimMovePeca
		CMP	R4, R0 ;Peca Bate na Parede Direita
		BR.Z	PreparaME
		INC	R2
		;Colisoes com outras pecas por fazer
		DEC	R2
		PUSH	R2
		CALL	LimpaCar
		INC	R2
		MOV	M[IO_CURSOR], R2
		MOV	M[IO_WRITE], R1
		DEC	R3
		DEC	R4
AguardaDir:	CMP	M[TEMPCHKPT], R0
		BR.Z	AguardaDir
		MOV	M[TEMPCHKPT], R0
		BR	MoveDireita

MoveEsquerda:	CMP	R5, R0 ;Peca bate na parede esquerda
		BR.Z	PreparaMD
		DEC	R2
		;Colisoes com outras pecas por fazer
		INC	R2
PreparaME:	PUSH	R2
		CALL	LimpaCar
		DEC	R2
		MOV	M[IO_CURSOR], R2
		MOV	M[IO_WRITE], R1
		DEC	R3
		DEC	R5
AguardaEsq:	CMP	M[TEMPCHKPT], R0
		BR.Z	AguardaEsq
		MOV	M[TEMPCHKPT], R0
		BR	MoveEsquerda

FimMovePeca:	POP	R5
		POP	R4
		POP	R3
		POP	R2
		POP	R1
		RET

;===============================================================================
; rotinsa que escrevem os caracteres correspondentes à pista
;                
;===============================================================================

IniciaJogo:	CALL	DesenhaPeca
		ENI
PodeMover:	CMP	M[TEMPCHKPT], R0
		BR.Z	PodeMover
		;DSI
		MOV	M[TEMPCHKPT], R0
		CALL	MovePeca
		RET


;===============================================================================
;EscCar : Rotina que escreve no ecra 1 caracter
;         Entradas: Pilha
;         Saidas:-----
;         Efeitos: Escreve no Ecra 1 caracter
;===============================================================================


EscCar:         PUSH	R1
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



LeCar:		CMP     R0, M[TEXTO_ESTADO]
                BR.Z    LeCar
                MOV     R1,M[LIMPAR_JANELA]
                RET




;===============================================================================
; LimpaJanela:  Rotina que limpa a janela de texto
;               Entradas:-----
;               Saidas:-----
;               Efeitos:-----
;===============================================================================

LimpaJanela:    PUSH    R2
                MOV     R2, LIMPAR_JANELA
                MOV     M[IO_CURSOR], R2
                POP     R2
                RET

LimpaCar:	PUSH	R1
		MOV	R1, M[SP+3]
		MOV	M[IO_CURSOR], R1
		MOV	R1, ' '
		MOV	M[IO_WRITE], R1
		POP	R1
		RETN	1



; Programa Principal

inicio:         MOV     R1, SP_INICIAL
                MOV     SP, R1
		MOV	R1, Interrupts
		MOV	M[InterruptMask], R1
		MOV	R1, TimeLong
		MOV	R1, TimeLong
		MOV	M[TimerValue], R1
		MOV	R1, EnableTimer
		MOV	M[TimerControl], R1
                CALL    LimpaJanela
		CALL	LimiteEsquerdo
		CALL	LimiteDireito
		CALL	Cantos
		CALL	Fundo 
		CALL	EscreveMens	
		CALL    LeCar
		CALL	IniciaJogo
Fim:		BR	Fim