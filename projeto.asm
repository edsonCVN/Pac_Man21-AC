; *********************************************************************
; * IST-UL
; * Projeto
; * 
; *
; *
; * 
; *********************************************************************

; **********************************************************************
; * Constantes
; **********************************************************************
; ATENÇÃO: constantes hexadecimais que comecem por uma letra devem ter 0 antes.
;          Isto não altera o valor de 16 bits e permite distinguir números de identificadores
DISPLAYS   EQU 0A000H  ; endereço dos displays de 7 segmentos (periférico POUT-1)
TEC_LIN    EQU 0C000H  ; endereço das linhas do teclado (periférico POUT-2)
TEC_COL    EQU 0E000H  ; endereço das colunas do teclado (periférico PIN)
MASCARA_1  EQU 0FH     ; para eliminar os bits extra quando se lê o teclado
LINHA      EQU 1       ; linha a testar

DEFINE_LINHA        EQU 600AH      ; endereço do comando para definir a linha
DEFINE_COLUNA       EQU 600CH      ; endereço do comando para definir a coluna
ESCREVE_8_PIXELS    EQU 601CH      ; endereço do comando para escrever 8 pixels  APENAS UM PIXEL 6012H
SELECIONA_FUNDO     EQU 6042H
ALTERA_COR_PIXEL    EQU 6012H
APAGA_ECRAS         EQU 6002H      ; endereço do comando para apagar todos os pixels de todos os ecrãs
APAGA_AVISO         EQU 6040H      ; endereço do comando para apagar o aviso de nenhum cenário selecionado
APAGA_PIXEL	    EQU 6018H

SELECINA_SOM	    EQU 6048H
REPRODUZ_SOM	    EQU 605AH
VOLUME_DO_SOM       EQU 604AH
	
N_LINHAS            EQU  32        ; número de linhas do écrã
BARRA               EQU  0FFH      ; valor do byte usado para representar a barra
DELAY               EQU  5000H     ; valor usado para implementar um atraso temporal
MASCARA_2	    EQU  1H
MASCARA_3	    EQU  0FFFEH


PLACE 	   400H
pacman_obj_fechada: 
			WORD 5		; linhas
			WORD 4		; colunas
			WORD 0F0F0H	; COR
			WORD 6H  	; 0110
			WORD 0FH 	; 1111
			WORD 0FH 	; 1111
			WORD 0FH 	; 1111
			WORD 6H  	; 0110
			
pacman_obj_aberta: 
			WORD 5		; linhas
			WORD 4		; colunas
			WORD 0F0F0H    	; COR 
			WORD 6H  	; 0110
			WORD 0FH 	; 1111
			WORD 8H  	; 1000
			WORD 0FH 	; 1111
			WORD 6H  	; 0110
			
fantasma_obj:
			WORD 4		; linhas
			WORD 4		; colunas
			WORD 0F00FH     ; COR
			WORD 6H  	; 0110
			WORD 0FH 	; 1111
			WORD 0FH 	; 1111
			WORD 9H  	; 1001
			
trofeu_obj:
			WORD 6		; linhas
			WORD 6		; colunas
			WORD 0FFF0H     ; COR
			WORD 1FH  	; 11111
			WORD 1FH  	; 11111
			WORD 0EH  	; 01110
			WORD 4H   	; 00100
			WORD 4H   	; 00100
			WORD 0EH  	; 01110
			
explosao_obj:
			WORD 5		; linhas
			WORD 5		; colunas
			WORD 0F0FFH     ; COR
			WORD 0AH  	; 01010
			WORD 15H  	; 10101
			WORD 0AH  	; 01010
			WORD 15H  	; 10101
			WORD 0AH  	; 01010
		
cartao_vermelho_obj:
			WORD 5		; linhas
			WORD 3		; colunas
			WORD 0FF00H     ; COR
			WORD 7H   	; 111
			WORD 7H  	; 111
			WORD 7H  	; 111
			WORD 7H  	; 111
			WORD 7H  	; 111
		
	
bola_caixa_obj:
			WORD 9		; linhas
			WORD 10		; colunas
			WORD 0FFFFH     	; COR
			WORD 84H   	; 0010000100
			WORD 102H  	; 0100000010
			WORD 201H  	; 1000000001
			WORD 201H  	; 1000000001
			WORD 201H  	; 1000000001
			WORD 201H  	; 1000000001
			WORD 102H  	; 0100000010
			WORD 84H   	; 0010000100
			WORD 78H   	; 0001111000

pacman_pos_aberta:	
			WORD 23		; Linha 23
			WORD 32		; Coluna 32
		
pacman_pos_fechada:
			WORD 23		; Linha
			WORD 38		; Coluna
			
fantasma1_pos:
			WORD 14		; Linha
			WORD 33		; Coluna

fantasma2_pos:
			WORD 7	 	; Linha
			WORD 15		; Coluna
			
trofeu1_pos: 
			WORD 1		; Linha
			WORD 5		; Coluna
			
trofeu2_pos: 
			WORD 1		; Linha
			WORD 62		; Coluna			
			
trofeu3_pos: 
			WORD 25		; Linha
			WORD 5		; Coluna

trofeu4_pos: 
			WORD 25		; Linha
			WORD 62		; Coluna
		
explosao_pos:
			WORD 20	  	; Linha
			WORD 17		; Coluna

cartao_vermelho_pos:
			WORD 20
			WORD 21
circulo_pos:
			WORD 12		; Linha
			WORD 36 	; Coluna CONFIRMAR DEPOIS
			
		
; **********************************************************************
; * Código
; **********************************************************************
PLACE      2000H
stack: 	   TABLE 100H   

fim_de_stack:	

; Inicio do programa  
PLACE      0  
inicio:		
	MOV SP, fim_de_stack
	MOV  [APAGA_ECRAS], R1   ; apaga todos os pixels de todos os ecrãs (o valor de R1 não é relevante)
	MOV  [APAGA_AVISO], R1   ; apaga o aviso de nenhum cenário selecionado (o valor de R1 não é relevante)
	MOV  R1, 0
	MOV  R2, 7
	MOV  R3, 100
	MOV  [SELECIONA_FUNDO], R1 ;
	MOV  R1, 1
	MOV  [SELECINA_SOM], R1
	MOV  [VOLUME_DO_SOM], R2
	MOV  [REPRODUZ_SOM], R1
	MOV  R1, 0
	MOV  [SELECINA_SOM], R1
	MOV  [VOLUME_DO_SOM], R3

	MOV R0, pacman_pos_aberta
	MOV R2, pacman_obj_aberta
	CALL DESENHA_OBJECTO

	MOV R0, fantasma1_pos
	MOV R2, fantasma_obj
	CALL DESENHA_OBJECTO
	
	MOV R0, fantasma2_pos
	MOV R2, fantasma_obj
	CALL DESENHA_OBJECTO

	MOV R0, circulo_pos
	MOV R2, bola_caixa_obj
	CALL DESENHA_OBJECTO

	MOV R0, trofeu1_pos
	MOV R2, trofeu_obj 
	CALL DESENHA_OBJECTO

	MOV R0, trofeu2_pos
	MOV R2, trofeu_obj 
	CALL DESENHA_OBJECTO

	MOV R0, trofeu3_pos
	MOV R2, trofeu_obj 
	CALL DESENHA_OBJECTO

	MOV R0, trofeu4_pos
	MOV R2, trofeu_obj 
	CALL DESENHA_OBJECTO

	MOV R0, explosao_pos
	MOV R2, explosao_obj
	CALL DESENHA_OBJECTO

	MOV R0, pacman_pos_fechada
	MOV R2, pacman_obj_fechada 
	CALL DESENHA_OBJECTO

	MOV R0, cartao_vermelho_pos
	MOV R2, cartao_vermelho_obj
	CALL DESENHA_OBJECTO
	
; inicializações
	MOV  R2, TEC_LIN   ; endereço do periférico das linhas
	MOV  R3, TEC_COL   ; endereço do periférico das colunas
	MOV  R4, DISPLAYS  ; endereço do periférico dos displays
        MOV  R10, 0
	MOV [R4], R10      ; escreve linha e coluna a zero nos displays
				; ou seja inicializa os displays para ficarem a 0
	MOV R11, 0		; INICIALIZACAO DO CONTADOR A 0
ciclo:
		
	MOV  R1, LINHA     ; 
	MOV  R6, 8 		   ; Valor maximo (para ser comparado com R1) 
	MOV  R7, R1        ; R7 guarda o nosso R1 para depois efetuar a verificação do ha_tecla
	JMP espera_tecla    
	
shift_linha: 			; Muda o valor de R1 para a proxima linha (vamos rodando pelas 4 linha do teclado)
	CMP R1, R6			; Se R1 = valor maximo(ultima linha), voltamos a meter o ciclo na linha 0
	JZ ciclo 
	SHL R1, 1
	MOV R7, R1			; Guardamos R1 em R7 (R1 é + tarde alterado)
	
espera_tecla:          ; neste ciclo espera-se até uma tecla ser premida
    	MOVB [R2], R1      ; escrever no periférico de saída (linhas)
	MOVB R0, [R3]      ; ler do periférico de entrada (colunas)
	MOV  R5, MASCARA_1
	AND  R0, R5        ; elimina os bits 7..4, que estão "no ar" (teclado só liga aos bits 3..0, mas o input leva 8 bits que podem sem querer ir dar coisas random) 
	CMP  R0, 0         ; há tecla premida?
	JZ   shift_linha   ; se nenhuma tecla premida, repete
				; vai mostrar a linha e a coluna da tecla
	CALL REPRODUZIR_SOM
	


	
ha_tecla:              ; neste ciclo espera-se até NENHUMA tecla estar premida
	CALL converte
	MOV R1, R8
	CMP  R1, 4
	JNZ  PROXIMO
	CALL CONTADOR
PROXIMO:	
	CMP  R1, 6
	JNZ  PROXIMO_2
	CALL CONTADOR
PROXIMO_2:	
	MOV  R1, R7          
	MOVB R0, [R3]      ; ler do periférico de entrada (colunas)
	MOV  R5, MASCARA_1
	AND  R0, R5        ; elimina os bits 7..4, que estão "no ar" (teclado só liga aos bits 3..0)
	CMP  R0, 0         ; há tecla premida?
	JNZ  SE_HA_TECLA   ; se ainda houver uma tecla premida, espera até não haver
	CALL REPRODUZIR_SOM
	JMP  ciclo         ; repete ciclo
SE_HA_TECLA:
	CALL atraso
	JMP ha_tecla
	

REPRODUZIR_SOM:
	PUSH R10
	MOV  [REPRODUZ_SOM], R10
	POP  R10
	RET
	
CONTADOR:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R4
	MOV R0, 0
	MOV R2, 100
	CMP R1, 6
	JZ  CASO_6
	CMP R11, R0
	JZ  FIM_3
	SUB R11, 1
	CALL display
	JMP FIM_3
CASO_6:
	CMP R11, R2
	JZ  FIM_3
	ADD R11, 1
	CALL display
FIM_3:	
	POP R4
	POP R2
	POP R1
	POP R0
	RET

display:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R10
	PUSH R11
	MOV  R0, 100
	MOV  R1, 10
	MOV  R2, R11
	MOV  R3, 1
	DIV  R2, R0
	CMP  R2, R3
	JZ   CASO_100
	MOV  R2, R11
	DIV  R2, R1
	SHL  R2, 4
	ADD  R10, R2
	MOV  R2, R11
	MOD  R2, R1
	ADD  R10, R2
MOSTRAR:	
	MOV  [R4], R10
	JMP  TERMINAR
CASO_100:
	MOV  R10, 100H
	JMP  MOSTRAR
TERMINAR:	
	POP  R11
	POP  R10
	POP  R4
	POP  R3
	POP  R2
	POP  R1
	POP  R0
	RET
	
	

	
DESENHA_OBJECTO:	
	PUSH R0 
	PUSH R1
	PUSH R0		
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R6
	PUSH R7
	PUSH R8
	PUSH R9
	PUSH R10
	PUSH R11
	MOV R1, R0		  ; COPIA O ENDERECO
	ADD R1, 2		  ; RECEBE O ENDERECO DA COLUNA
	MOV R3, R2		  ; COPIA O ENDERECO
	ADD R3, 2		  ; RECEBE O ENDERECO DO NUMERO DE COLUNAS
	MOV R4, R3		  ; COPIA O ENDERECO
	ADD R4, 2		  ; RECEBE O ENDERECO DA COR
	MOV R5, R4		  ; COPIA O ENDERECO
	ADD R5, 2		  ; RECEBE O ENDERECO DAS CARTEC DA 1 LINHA
	MOV R0, [R0]	 	  ; RECEBE O POS LINHA
	MOV R1, [R1]		  ; RECEBE O POS COLUNA
	MOV R2, [R2] 		  ; RECEBE N LINHAS
	MOV R3, [R3]		  ; RECEBE N COLUNAS
	MOV R4, [R4]              ; RECEBE COR
	MOV R6, [R5] 		  ;  RECEBE CARACTE DA 1 LINHACOPIA CARACTE
	MOV R11, R6
	MOV R7, 0		  ; INICIALIZA A 1 CONTADOR LINHAS
	MOV R9, MASCARA_2
	MOV R10, R1
CICLO_LINHA:
	CMP R2, R7
	JZ FIM_LINHAS
	MOV R8, 0
CICLO_COLUNAS:
	CMP R3, R8
	JZ NEXT_LINE
	AND R11, R9
	CMP R11, 0
	JZ CONTINUA
	MOV  [DEFINE_LINHA], R0           ; seleciona a linha
	MOV  [DEFINE_COLUNA], R10           ; seleciona a coluna
	MOV  [ALTERA_COR_PIXEL], R4        ; escreve o pixel correspondentes ao byte
CONTINUA:
	SHR R6, 1
	MOV R11, R6
	ADD R8, 1
	SUB R10,1
	JMP CICLO_COLUNAS
NEXT_LINE:
	ADD R7, 1
	ADD R5, 2
	ADD R0, 1
	MOV R10, R1
	MOV R6, [R5]
	MOV R11, R6
	JMP CICLO_LINHA
FIM_LINHAS:
	POP R11
	POP R10
	POP R9
	POP R8
	POP R7
	POP R6
	POP R5
	POP R4
	POP R3
	POP R2
	POP R1
	POP R0
	RET


; **********************************************************************
; CONVERTE - O valor da linha e da coluna sao convertidos para o seu respetivo valor em decimal
; Argumentos: R8 - Valor convertido
; **********************************************************************
converte:
	PUSH 	R0
	PUSH 	R1
	PUSH 	R2
	MOV	R2, 8
	CMP	R1, R2
	JZ l_c_3
aaaa:
	SHR	R1, 1
	MOV	R8, R1
	SHL	R8, 2
	MOV	R1, R0
	CMP	R1, R2
	JZ l_c_4
aaab:
	SHR	R1, 1
	ADD	R8, R1
	POP	R2
	POP	R1
	POP	R0
	RET
l_c_3:
	MOV	R1, 6
	JMP aaaa
l_c_4:
	MOV	R1, 6
	JMP aaab	

; **********************************************************************
; ATRASO - Espera algum tempo
; Argumentos: R1 - Valor a usar no contador para o atraso
; **********************************************************************
atraso:
	PUSH R1
	MOV R1,DELAY
continua:
     	SUB  R1, 1                    ; decrementa o contador de 1 unidade
	JNZ  continua                 ; só sai quando o contador chegar a 0
	POP  R1
	RET	
	
		
	


	
