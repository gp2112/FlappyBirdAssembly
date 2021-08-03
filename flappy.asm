jmp main



birdcima: string "<=>"
birdbaixo: string "?@A"

apagaP: string "   "

perdeuStr: string "Voce perdeu lol -                    aperte espaco p/ voltar"

NumAleatorio: var #1 	; Guarda um numero aleatorio de 0 a 4


Tecla: var #255

IncRand: var #1			; Incremento para circular na Tabela de nr. Randomicos
Rand : var #30			; Tabela de nr. Randomicos entre 0 - 4
	static Rand + #0, #0
	static Rand + #1, #3
	static Rand + #2, #4
	static Rand + #3, #1
	static Rand + #4, #3
	static Rand + #5, #1
	static Rand + #6, #4
	static Rand + #7, #1
	static Rand + #8, #0
	static Rand + #9, #2
	static Rand + #10, #2
	static Rand + #11, #1
	static Rand + #12, #0
	static Rand + #13, #1
	static Rand + #14, #4
	static Rand + #15, #2
	static Rand + #16, #3
	static Rand + #17, #3
	static Rand + #18, #4
	static Rand + #19, #1
	static Rand + #20, #0
	static Rand + #20, #3
	static Rand + #21, #2
	static Rand + #22, #2
	static Rand + #23, #3
	static Rand + #24, #4
	static Rand + #25, #4
	static Rand + #26, #0
	static Rand + #27, #2
	static Rand + #28, #0
	static Rand + #29, #2

;codigo principal

posBird: var #1
grav: var #1
speedBird: var #1


main:

	; setta os valores iniciais
	loadn r0, #410
	loadn r1, #40
	loadn r2, #0
	store posBird, r0
	store grav, r1
	store speedBird, r2

	; valores de comparacao
	loadn r4, #' '
	loadn r6, #40
	loadn r7, #1079 ;fim da tela
	
	loadn r1, #tela0Linha0
	call ImprimeTela2
	call imprimeBird

	mainloop:
		; verifica se o passaro caiu
		load r0, posBird
		cmp r0, r7
		jeg perdeu
		
		cmp r0, r6
		jle perdeu

		call Delay

		call apagaBird

		call changePosBird
		call imprimeBird
		call Delay
		call Delay
		call Delay
		call Delay
		call Delay
		
		
	continue:
		call apagaBird
		call Delay	
		jmp mainloop

	perdeu:
		call ApagaTela
		loadn r0, #410
		loadn r1, #perdeuStr
		call imprimeStr

		call getEspaco
		call ApagaTela
		jmp main
		
	halt


;r0 - posicao atual | r1 - tecla pressionada 
changePosBird:
	push r0
	push r1
	push r2
	push r3
	push r4

	load r0, grav
	load r1, speedBird
	load r2, posBird

	loadn r3, #' '

	inchar r4

	cmp r4, r3
	jne fallBird

	;sobe passaro - inverte vetor velocidade
	loadn r1, #0
	sub r2, r2, r0;
	sub r2, r2, r0;
	sub r2, r2, r0;
	sub r2, r2, r0;
	jmp endChangePosBird

	fallBird:

		add r1, r1, r0 ;velocidade = velocidade_inicial + aceleracao_g
		add r2, r2, r1 ;posicao = posicao_inicial + velocidade

	endChangePosBird:
		; salva a nova velocidade e posicao do passaro
		store speedBird, r1
		store posBird, r2

		pop r4
		pop r3	
		pop r2
		pop r1
		pop r0
		rts

apagaBird:
	push r0
	push r1
	push r2

	load r0, posBird
	loadn r1, #apagaP
	loadn r2, #40

	call imprimeStr

	add r0, r0, r2
	call imprimeStr

	pop r2
	pop r1
	pop r0
	rts

getEspaco:	; Espera que uma tecla seja digitada e salva na variavel global "Letra"
	push r0
	push r1
	loadn r1, #' '	; Se nao digitar nada vem 255

   getEspacoLoop:
		inchar r0			; Le o teclado, se nada for digitado = 255
		cmp r0, r1			;compara r0 com 255
		jne getEspacoLoop	; Fica lendo ate' que digite uma tecla valida

	pop r1
	pop r0
	rts


imprimeBird:
	push r0
	push r1
	push r2
	push r3 

	load r0, posBird

	loadn r3, #40

	loadn r1, #birdcima
	call imprimeStr

	add r0, r0, r3
	loadn r1, #birdbaixo
	call imprimeStr

	pop r3
	pop r2
	pop r1
	pop r0
	rts


; r0 -> posicao
; r1 -> endereco string
imprimeStr:
	push r0
	push r1
	push r2
	push r3
	push r4

	loadn r3, #'\0'

	imprimestr_loop:
		loadi r4, r1
		cmp r4, r3
		jeq imprimestr_end
		outchar r4, r0

		inc r1
		inc r0
		jmp imprimestr_loop

	imprimestr_end:

		pop r4
		pop r3
		pop r2
		pop r1
		pop r0
		rts

;********************************************************
;                       DELAY
;********************************************************

Delay:
						;Utiliza Push e Pop para nao afetar os Ristradores do programa principal
	Push R0
	Push R1
	
	Loadn R1, #50  ; a
   Delay_volta2:				;Quebrou o contador acima em duas partes (dois loops de decremento)
	Loadn R0, #3000	; b
   Delay_volta: 
	Dec R0					; (4*a + 6)b = 1000000  == 1 seg  em um clock de 1MHz
	JNZ Delay_volta	
	Dec R1
	JNZ Delay_volta2
	
	Pop R1
	Pop R0
	
	RTS

;------------------------	
	

;-------------------------------


;********************************************************
;                       IMPRIME TELA2
;********************************************************	

ImprimeTela2: 	;  Rotina de Impresao de Cenario na Tela Inteira
		;  r1 = endereco onde comeca a primeira linha do Cenario
		;  r2 = cor do Cenario para ser impresso

	push r0	; protege o r3 na pilha para ser usado na subrotina
	push r1	; protege o r1 na pilha para preservar seu valor
	push r2	; protege o r1 na pilha para preservar seu valor
	push r3	; protege o r3 na pilha para ser usado na subrotina
	push r4	; protege o r4 na pilha para ser usado na subrotina
	push r5	; protege o r5 na pilha para ser usado na subrotina
	push r6	; protege o r6 na pilha para ser usado na subrotina

	loadn R0, #0  	; posicao inicial tem que ser o comeco da tela!
	loadn R3, #40  	; Incremento da posicao da tela!
	loadn R4, #41  	; incremento do ponteiro das linhas da tela
	loadn R5, #1200 ; Limite da tela!
	loadn R6, #tela0Linha0	; Endereco onde comeca a primeira linha do cenario!!
	
   ImprimeTela2_Loop:
		call ImprimeStr2
		add r0, r0, r3  	; incrementaposicao para a segunda linha na tela -->  r0 = R0 + 40
		add r1, r1, r4  	; incrementa o ponteiro para o comeco da proxima linha na memoria (40 + 1 porcausa do /0 !!) --> r1 = r1 + 41
		add r6, r6, r4  	; incrementa o ponteiro para o comeco da proxima linha na memoria (40 + 1 porcausa do /0 !!) --> r1 = r1 + 41
		cmp r0, r5			; Compara r0 com 1200
		jne ImprimeTela2_Loop	; Enquanto r0 < 1200

	pop r6	; Resgata os valores dos registradores utilizados na Subrotina da Pilha
	pop r5
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	rts
				
;---------------------

;---------------------------	
;********************************************************
;                   IMPRIME STRING2
;********************************************************
	
ImprimeStr2:	;  Rotina de Impresao de Mensagens:    r0 = Posicao da tela que o primeiro caractere da mensagem sera' impresso;  r1 = endereco onde comeca a mensagem; r2 = cor da mensagem.   Obs: a mensagem sera' impressa ate' encontrar "/0"
	push r0	; protege o r0 na pilha para preservar seu valor
	push r1	; protege o r1 na pilha para preservar seu valor
	push r2	; protege o r1 na pilha para preservar seu valor
	push r3	; protege o r3 na pilha para ser usado na subrotina
	push r4	; protege o r4 na pilha para ser usado na subrotina
	push r5	; protege o r5 na pilha para ser usado na subrotina
	push r6	; protege o r6 na pilha para ser usado na subrotina
	
	
	loadn r3, #'\0'	; Criterio de parada
	loadn r5, #' '	; Espaco em Branco

   ImprimeStr2_Loop:	
		loadi r4, r1
		cmp r4, r3		; If (Char == \0)  vai Embora
		jeq ImprimeStr2_Sai
		cmp r4, r5		; If (Char == ' ')  vai Pula outchar do espaco para na apagar outros caracteres
		jeq ImprimeStr2_Skip
		add r4, r2, r4	; Soma a Cor
		outchar r4, r0	; Imprime o caractere na tela
   		storei r6, r4
   ImprimeStr2_Skip:
		inc r0			; Incrementa a posicao na tela
		inc r1			; Incrementa o ponteiro da String
		inc r6
		jmp ImprimeStr2_Loop
	
   ImprimeStr2_Sai:	
	pop r6	; Resgata os valores dos registradores utilizados na Subrotina da Pilha
	pop r5
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	rts
	

;********************************************************
;                       APAGA TELA
;********************************************************
ApagaTela:
	push r0
	push r1
	
	loadn r0, #1200		; apaga as 1200 posicoes da Tela
	loadn r1, #' '		; com "espaco"
	
	   ApagaTela_Loop:	;;label for(r0=1200;r3>0;r3--)
		dec r0
		outchar r1, r0
		jnz ApagaTela_Loop
 
	pop r1
	pop r0
	rts	

;------------------------	
; Declara uma tela vazia para ser preenchida em tempo de execussao:

tela0Linha0  : string "////////////////////////////////////////"
tela0Linha1  : string "                                        "
tela0Linha2  : string "                                        "
tela0Linha3  : string "      .                         .       "
tela0Linha4  : string "                                        "
tela0Linha5  : string "                                        "
tela0Linha6  : string "                                        "
tela0Linha7  : string "                .                       "
tela0Linha8  : string "                                        "
tela0Linha9  : string "                                        "
tela0Linha10 : string "    .                                   "
tela0Linha11 : string "                                        "
tela0Linha12 : string "                             .          "
tela0Linha13 : string "                                        "
tela0Linha14 : string "                                        "
tela0Linha15 : string "                                        "
tela0Linha16 : string "                                        "
tela0Linha17 : string "                                        "
tela0Linha18 : string "                                        "
tela0Linha19 : string "                                        "
tela0Linha20 : string "                                        "
tela0Linha21 : string "                                        "
tela0Linha22 : string "                                        "
tela0Linha23 : string "                                        "
tela0Linha24 : string "                                        "
tela0Linha25 : string "                                        "
tela0Linha26 : string "                                        "
tela0Linha27 : string "                                        "
tela0Linha28 : string "________________________________________"
tela0Linha29 : string "////////////////////////////////////////"	


