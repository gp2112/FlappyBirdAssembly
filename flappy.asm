jmp Main



birdcima: string "<=>"
birdbaixo: string "?@A"

apagaP: string "   "

score: string "score: "

perdeuStr: string "Voce perdeu lol -                    jogar novamente s/n ?"

NumAleatorio: var #1 	; Guarda um numero aleatorio de 0 a 4


Tecla: var #255

IncRand: var #1			; Incremento para circular na Tabela de nr. Randomicos
Rand : var #30			; Tabela de nr. Randomicos entre 119 - 1119
	static Rand + #0, #159
	static Rand + #1, #559
	static Rand + #2, #1039
	static Rand + #3, #159
	static Rand + #4, #839
	static Rand + #5, #119
	static Rand + #6, #359
	static Rand + #7, #1079
	static Rand + #8, #559
	static Rand + #9, #199
	static Rand + #10, #999
	static Rand + #11, #639
	static Rand + #12, #879
	static Rand + #13, #1039
	static Rand + #14, #479
	static Rand + #15, #239
	static Rand + #16, #839
	static Rand + #17, #119
	static Rand + #18, #1079
	static Rand + #19, #1039
	static Rand + #20, #279
	static Rand + #20, #519
	static Rand + #21, #879
	static Rand + #22, #239
	static Rand + #23, #679
	static Rand + #24, #199
	static Rand + #25, #1119
	static Rand + #26, #439
	static Rand + #27, #119
	static Rand + #28, #759
	static Rand + #29, #999

;codigo principal

posBird: var #1
grav: var #1
speedBird: var #1
pontuacao: var #1

posTiro1: var #1					
posTiro2: var #1
posTiro3: var #1
posTiro4: var #1
posTiro5: var #1

Main:
	
	; Imprime string "Score"
	loadn r0, #67
	loadn r1, #score
	call ImprimeStr

	; setta os valores iniciais
	loadn r0, #410
	loadn r1, #40
	loadn r2, #0
	store posBird, r0     
	store grav, r1		   
	store speedBird, r2
	store pontuacao, r2
	store posTiro1, r2
	loadn r2, #1
	store posTiro2, r2
	store posTiro3, r2
	store posTiro5, r2
	
	loadn r2, #3
	store posTiro4, r2
	
	loadn r2, #0
				
	; valores de comparacao
	loadn r4, #' '
	loadn r6, #40
	loadn r7, #1079 ;fim da tela
	
	loadn r2, #0; cor branco
	loadn r1, #tela0Linha0 ; imprime o ceu
	call ImprimeTela2
	
	loadn r2, #512 ;cor verde
	loadn r1, #tela1Linha0 ;imprime a grama
	call ImprimeTela2
	
	call ImprimeBird
	
	;valores para pontuacao
	loadn r3, #0 ; r3 -> relogio
	loadn r4, #0 ; r4 -> verificar mod da divisao

	Mainloop:
		
		;movimenta passaro
		load r0, posBird
		call ApagaBird
		call ChangePosBird
		call ImprimeBird
		call VerificaBird
		
		;movimenta os tiros
		call MoveTiro1
		call MoveTiro2
		call MoveTiro3
		call MoveTiro4
		call MoveTiro5
    
		; verifica se o passaro caiu
		cmp r0, r7
		jeg perdeu
		
		; verifica se bateu no teto
		cmp r0, r6
		jle perdeu
	
		call Delay
		call Delay
		call Delay
		call Delay
		call Delay
		
		
	continue:
		
		;checa se pontuou -> r3/20 com resto 0
		loadn r0, #20
		mod r0, r3, r0
		cmp r4, r0
		jne naoPontua
		
		loadn r3, #0
		
		call pontua
		naoPontua:
		
		;incrementa relogio
		inc r3
		
		
		call Delay
		jmp Mainloop

	perdeu:
		
		;mensagem de derrota
		call ApagaTela
		loadn r0, #410
		loadn r1, #perdeuStr
		call ImprimeStr
		
		;imprime score
		loadn r0, #53
		loadn r1, #score
		call ImprimeStr
		
		loadn r0, #95
		load r1, pontuacao
		call ImprimeInt
		
		; jogar de novo?
		call GetDecisao
		
	fim: ; encerra o programa
	
	call ApagaTela
	halt

pontua: ; aumentar pontuacao
	push r0
	push r1
	
	loadn r0, #74 ; posicao

	load r1, pontuacao
	inc r1
	store pontuacao, r1
	
	call ImprimeInt 

	pop r1
	pop r0
	rts

;r0 - posicao atual | r1 - tecla pressionada 
ChangePosBird:
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
	jne FallBird

	;sobe passaro - inverte vetor velocidade
	loadn r1, #0
	sub r2, r2, r0;
	sub r2, r2, r0;
	sub r2, r2, r0;
	sub r2, r2, r0;
	jmp EndChangePosBird

	FallBird:

		add r1, r1, r0 ;velocidade = velocidade_inicial + aceleracao_g
		add r2, r2, r1 ;posicao = posicao_inicial + velocidade

	EndChangePosBird:
		; salva a nova velocidade e posicao do passaro
		store speedBird, r1
		store posBird, r2
		
		
		pop r4
		pop r3	
		pop r2
		pop r1
		pop r0
		rts

ApagaBird:
	push r0
	push r1
	push r2

	load r0, posBird
	loadn r1, #apagaP
	loadn r2, #40

	call ImprimeStr

	add r0, r0, r2
	call ImprimeStr

	pop r2
	pop r1
	pop r0
	rts
	
VerificaBird: ;verifica se passaro bateu em um tiro
		push r0
		push r1
		push r2
		push r3
		push r4
		push r5
		push r6
	
		load r2, posBird

		load r0, posTiro1
		load r3, posTiro2
		load r4, posTiro3
		load r5, posTiro4
		load r6, posTiro5
		loadn r1, #40 
		
		;verificar cada tiro em cada parte do passaro
	  	cmp r0, r2	
	  	jeq perdeu
	  	
	  	cmp r3, r2	
	  	jeq perdeu
	  	
	  	cmp r4, r2	
	  	jeq perdeu
	  	
	  	cmp r5, r2	
	  	jeq perdeu
	  	
	  	cmp r6, r2	
	  	jeq perdeu
	  	
	  	inc r2
	  	cmp r0, r2	
	  	jeq perdeu
	  	
	  	cmp r3, r2	
	  	jeq perdeu
	  	
	  	cmp r4, r2	
	  	jeq perdeu
	  	
	  	cmp r5, r2	
	  	jeq perdeu
	  	
	  	cmp r6, r2	
	  	jeq perdeu
	  	
	  	inc r2
	  	cmp r0, r2	
	  	jeq perdeu
	  	
	  	cmp r3, r2	
	  	jeq perdeu
	  	
	  	cmp r4, r2	
	  	jeq perdeu
	  	
	  	cmp r5, r2	
	  	jeq perdeu
	  	
	  	cmp r6, r2	
	  	jeq perdeu
	  	
	  	add r2, r2, r1
	  	cmp r0, r2	
	  	jeq perdeu
	  	
	  	cmp r3, r2	
	  	jeq perdeu
	  	
	  	cmp r4, r2	
	  	jeq perdeu
	  	
	  	cmp r5, r2	
	  	jeq perdeu
	  	
	  	cmp r6, r2	
	  	jeq perdeu
	  	
	  	dec r2
	  	cmp r0, r2	
	  	jeq perdeu
	  	
	  	cmp r3, r2	
	  	jeq perdeu
	  	
	  	cmp r4, r2	
	  	jeq perdeu
	  	
	  	cmp r5, r2	
	  	jeq perdeu
	  	
	  	cmp r6, r2	
	  	jeq perdeu
	  	
	  	dec r2
	  	cmp r0, r2	
	  	jeq perdeu
	  	
	  	cmp r3, r2	
	  	jeq perdeu
	  	
	  	cmp r4, r2	
	  	jeq perdeu
	  	
	  	cmp r5, r2	
	  	jeq perdeu
	  	
	  	cmp r6, r2	
	  	jeq perdeu

	  	pop r6
	  	pop r5
		pop r4
		pop r3	
		pop r2
		pop r1
		pop r0
 		rts
	
GetDecisao:	; Espera que uma tecla seja digitada (s ou n)
	push r0
	push r1
	push r2
	
	GetDecisao_Loop:
	
		inchar r0			
		loadn r1, #'s'	
		cmp r0, r1			
		jeq novamente ; se foi s
		
		loadn r1, #'n'	
		cmp r0, r1	
		jeq fim ; se foi n
		
		jmp GetDecisao_Loop; se nao foi s nem n
		
	novamente:; reiniciar jogo
	
	call ApagaTela
	
	pop r2
	pop r1
	pop r0
	
	jmp Main

ImprimeBird:
	push r0
	push r1
	push r2
	push r3 

	load r0, posBird

	loadn r3, #40

	loadn r1, #birdcima
	call ImprimeStr

	add r0, r0, r3
	loadn r1, #birdbaixo
	call ImprimeStr

	pop r3
	pop r2
	pop r1
	pop r0
	rts

MoveTiro1: ; apaga tiro1 na pos atual -> busca nova pos -> desenha na nova pos
	push r0
	push r1
	push r2

  load r0, posTiro1	
  call MoveTiro_Apaga
  
  call MoveTiro1_RecalculaPos
  
  load r0, posTiro1
  call MoveTiro_Desenha		
 
 	;verifica se o tiro acertou o passaro
 	loadn r2, #40 
	load r0, posTiro1
	
	load r1, posBird
  	cmp r0, r1	
  	jeq perdeu
  	
  	inc r1
  	cmp r0, r1	
  	jeq perdeu
  	
  	inc r1
  	cmp r0, r1	
  	jeq perdeu
  	
  	add r1, r1, r2
  	cmp r0, r1	
  	jeq perdeu
  	
  	dec r1
  	cmp r0, r1	
  	jeq perdeu
  	
  	dec r1
  	cmp r0, r1	
  	jeq perdeu

	pop r2
	pop r1
	pop r0
	rts 

MoveTiro1_RecalculaPos:
	push r0
	push r1
	push r2
	
	; verificar se o tiro chegou na ultima linha (0)
	load r0, posTiro1
	loadn r1, #40		
	loadn r2, #0
	mod R1, R0, R1		
	cmp R1, R2			
	jeq MoveTiro1_RecalculaPos_Reinicia
	
	; se nao chegou -> decrementar uma casa
		dec r0
	jmp MoveTiro1_RecalculaPos_Fim

	;se chegou -> gerar nova posicao aleatoria
  MoveTiro1_RecalculaPos_Reinicia:
  	loadn r2, #Rand 	; declara ponteiro para tabela rand na memoria!
	load r1, IncRand	; Pega Incremento da tabela Rand
	add r2, r2, r1		; Soma Incremento ao inicio da tabela Rand
						; R2 = Rand + IncRand
	loadi r0, r2 		; busca nr. randomico da memoria em R0
						; R3 = Rand(IncRand)				
	inc r1				; Incremento ++
	loadn r2, #30
	cmp r1, r2			; Compara com o Final da Tabela e re-estarta em 0
	jne MoveTiro1_RecalculaPos_Skip
		loadn r1, #0		; re-estarta a Tabela Rand em 0
  MoveTiro1_RecalculaPos_Skip:
	store IncRand, r1	; Salva incremento ++
  	
  MoveTiro1_RecalculaPos_Fim:
	store posTiro1, r0 ;salva nova posicao
  	
  	
	pop r2
	pop r1
	pop r0
	rts

;-------------------------------------------
MoveTiro2: ; apaga tiro2 na pos atual -> busca nova pos -> desenha na nova pos
	push r0
	push r1
	push r2

  load r0, posTiro2
  call MoveTiro_Apaga
  
  call MoveTiro2_RecalculaPos
 
  load r0, posTiro2
  call MoveTiro_Desenha		
	
	loadn r2, #40 
	load r0, posTiro2
	
	load r1, posBird
  	cmp r0, r1	
  	jeq perdeu
  	
  	inc r1
  	cmp r0, r1	
  	jeq perdeu
  	
  	inc r1
  	cmp r0, r1	
  	jeq perdeu
  	
  	add r1, r1, r2
  	cmp r0, r1	
  	jeq perdeu
  	
  	dec r1
  	cmp r0, r1	
  	jeq perdeu
  	
  	dec r1
  	cmp r0, r1	
  	jeq perdeu
	
	pop r2
	pop r1
	pop r0
	rts

MoveTiro2_RecalculaPos:
	push r0
	push r1
	push r2
	
	; verificar se o tiro chegou na ultima linha (1)
	load r0, posTiro2
	loadn r1, #40		
	loadn r2, #1
	mod R1, R0, R1		
	cmp R1, R2			
	jeq MoveTiro2_RecalculaPos_Reinicia
	
	; se nao chegou -> decrementar 2 casas
		loadn r2, #2
		sub r0, r0, r2
	jmp MoveTiro2_RecalculaPos_Fim

	;se chegou -> gerar nova posicao aleatoria
  MoveTiro2_RecalculaPos_Reinicia:
  	loadn r2, #Rand 	; declara ponteiro para tabela rand na memoria!
	load r1, IncRand	; Pega Incremento da tabela Rand
	add r2, r2, r1		; Soma Incremento ao inicio da tabela Rand
						; R2 = Rand + IncRand
	loadi r0, r2 		; busca nr. randomico da memoria em R0
						; R3 = Rand(IncRand)				
	inc r1				; Incremento ++
	loadn r2, #30
	cmp r1, r2			; Compara com o Final da Tabela e re-estarta em 0
	jne MoveTiro2_RecalculaPos_Skip
		loadn r1, #0		; re-estarta a Tabela Rand em 0
  MoveTiro2_RecalculaPos_Skip:
	store IncRand, r1	; Salva incremento ++
  	
  MoveTiro2_RecalculaPos_Fim:
	store posTiro2, r0 ;salva nova posicao
  	
	pop r2
	pop r1
	pop r0
	rts
;-------------------------------------------
MoveTiro3: ; apaga tiro3 na pos atual -> busca nova pos -> desenha na nova pos
	push r0
	push r1
	push r2
  
  load r0, posTiro3
  call MoveTiro_Apaga
  
  call MoveTiro3_RecalculaPos
  
  load r0, posTiro3
  call MoveTiro_Desenha		
	
	;verifica se o tiro acertou o passaro
	loadn r2, #40 
	load r0, posTiro3
	
	load r1, posBird
  	cmp r0, r1	
  	jeq perdeu
  	
  	inc r1
  	cmp r0, r1	
  	jeq perdeu
  	
  	inc r1
  	cmp r0, r1	
  	jeq perdeu
  	
  	add r1, r1, r2
  	cmp r0, r1	
  	jeq perdeu
  	
  	dec r1
  	cmp r0, r1	
  	jeq perdeu
  	
  	dec r1
  	cmp r0, r1	
  	jeq perdeu
	
	pop r2
	pop r1
	pop r0
	rts

MoveTiro3_RecalculaPos:
	push r0
	push r1
	push r2
	
	; verificar se o tiro chegou na ultima linha (1)
	load r0, posTiro3
	loadn r1, #40		
	loadn r2, #1
	mod R1, R0, R1		
	cmp R1, R2			
	jeq MoveTiro3_RecalculaPos_Reinicia
	
	; se nao chegou -> decrementar 3 casas
		loadn r2, #3
		sub r0, r0, r2
	jmp MoveTiro3_RecalculaPos_Fim

	;se chegou -> gerar nova posicao aleatoria
  MoveTiro3_RecalculaPos_Reinicia:
  	loadn r2, #Rand 	; declara ponteiro para tabela rand na memoria!
	load r1, IncRand	; Pega Incremento da tabela Rand
	add r2, r2, r1		; Soma Incremento ao inicio da tabela Rand
						; R2 = Rand + IncRand
	loadi r0, r2 		; busca nr. randomico da memoria em R0
						; R3 = Rand(IncRand)				
	inc r1				; Incremento ++
	loadn r2, #30
	cmp r1, r2			; Compara com o Final da Tabela e re-estarta em 0
	jne MoveTiro3_RecalculaPos_Skip
		loadn r1, #0		; re-estarta a Tabela Rand em 0
  MoveTiro3_RecalculaPos_Skip:
	store IncRand, r1	; Salva incremento ++
  	
  MoveTiro3_RecalculaPos_Fim:
	store posTiro3, r0 ;salva nova posicao
  	
	pop r2
	pop r1
	pop r0
	rts
;---------------------------------------
MoveTiro4: ; apaga tiro4 na pos atual -> busca nova pos -> desenha na nova pos
	push r0
	push r1
	push r2
  
  load r0, posTiro4
  call MoveTiro_Apaga
  
  call MoveTiro4_RecalculaPos
  
  load r0, posTiro4
  call MoveTiro_Desenha		

	;verifica se o tiro acertou o passaro
    loadn r2, #40 
	load r0, posTiro4
	
	load r1, posBird
  	cmp r0, r1	
  	jeq perdeu
  	
  	inc r1
  	cmp r0, r1	
  	jeq perdeu
  	
  	inc r1
  	cmp r0, r1	
  	jeq perdeu
  	
  	add r1, r1, r2
  	cmp r0, r1	
  	jeq perdeu
  	
  	dec r1
  	cmp r0, r1	
  	jeq perdeu
  	
  	dec r1
  	cmp r0, r1	
  	jeq perdeu
	
	pop r2
	pop r1
	pop r0
	rts

MoveTiro4_RecalculaPos:
	push r0
	push r1
	push r2
	
	; verificar se o tiro chegou na ultima linha
	load r0, posTiro4
	loadn r1, #40		
	loadn r2, #3
	mod R1, R0, R1		
	cmp R1, R2			
	jeq MoveTiro4_RecalculaPos_Reinicia
	
	; se nao chegou -> decrementar 4 casas
		loadn r2, #4
		sub r0, r0, r2
	jmp MoveTiro4_RecalculaPos_Fim

	;se chegou -> gerar nova posicao aleatoria
  MoveTiro4_RecalculaPos_Reinicia:
  	loadn r2, #Rand 	; declara ponteiro para tabela rand na memoria!
	load r1, IncRand	; Pega Incremento da tabela Rand
	add r2, r2, r1		; Soma Incremento ao inicio da tabela Rand
						; R2 = Rand + IncRand
	loadi r0, r2 		; busca nr. randomico da memoria em R0
						; R3 = Rand(IncRand)				
	inc r1				; Incremento ++
	loadn r2, #30
	cmp r1, r2			; Compara com o Final da Tabela e re-estarta em 0
	jne MoveTiro4_RecalculaPos_Skip
		loadn r1, #0		; re-estarta a Tabela Rand em 0
  MoveTiro4_RecalculaPos_Skip:
	store IncRand, r1	; Salva incremento ++
  	
  MoveTiro4_RecalculaPos_Fim:
	store posTiro4, r0 ;salva nova posicao
  	
	pop r2
	pop r1
	pop r0
	rts
	
;-------------------------------------------
MoveTiro5: ; apaga tiro5 na pos atual -> busca nova pos -> desenha na nova pos
	push r0
	push r1
	push r2

  load r0, posTiro5
  call MoveTiro_Apaga
  
  call MoveTiro5_RecalculaPos
 
  load r0, posTiro5
  call MoveTiro_Desenha		
	
	loadn r2, #40 
	load r0, posTiro5
	
	load r1, posBird
  	cmp r0, r1	
  	jeq perdeu
  	
  	inc r1
  	cmp r0, r1	
  	jeq perdeu
  	
  	inc r1
  	cmp r0, r1	
  	jeq perdeu
  	
  	add r1, r1, r2
  	cmp r0, r1	
  	jeq perdeu
  	
  	dec r1
  	cmp r0, r1	
  	jeq perdeu
  	
  	dec r1
  	cmp r0, r1	
  	jeq perdeu
	
	pop r2
	pop r1
	pop r0
	rts

MoveTiro5_RecalculaPos:
	push r0
	push r1
	push r2
	
	; verificar se o tiro chegou na ultima linha (1)
	load r0, posTiro5
	loadn r1, #40		
	loadn r2, #1
	mod R1, R0, R1		
	cmp R1, R2			
	jeq MoveTiro5_RecalculaPos_Reinicia
	
	; se nao chegou -> decrementar 2 casas
		loadn r2, #2
		sub r0, r0, r2
	jmp MoveTiro5_RecalculaPos_Fim

	;se chegou -> gerar nova posicao aleatoria
  MoveTiro5_RecalculaPos_Reinicia:
  	loadn r2, #Rand 	; declara ponteiro para tabela rand na memoria!
	load r1, IncRand	; Pega Incremento da tabela Rand
	add r2, r2, r1		; Soma Incremento ao inicio da tabela Rand
						; R2 = Rand + IncRand
	loadi r0, r2 		; busca nr. randomico da memoria em R0
						; R3 = Rand(IncRand)				
	inc r1				; Incremento ++
	loadn r2, #30
	cmp r1, r2			; Compara com o Final da Tabela e re-estarta em 0
	jne MoveTiro5_RecalculaPos_Skip
		loadn r1, #0		; re-estarta a Tabela Rand em 0
  MoveTiro5_RecalculaPos_Skip:
	store IncRand, r1	; Salva incremento ++
  	
  MoveTiro5_RecalculaPos_Fim:
	store posTiro5, r0 ;salva nova posicao
  	
	pop r2
	pop r1
	pop r0
	rts
;---------------------------------------
MoveTiro_Apaga:
	push r0
	push r1
	push r2
	push r3
	push r4
	push r5

	
	; --> R2 = Tela1Linha0 + posAnt + posAnt/40  ; tem que somar posAnt/40 no ponteiro pois as linas da string terminam com /0 !!
	loadn r1, #tela0Linha0	; Endereco onde comeca a primeira linha do cenario!!
	add r2, r1, r0	; R2 = Tela1Linha0 + posAnt
	loadn r4, #40
	div r3, r0, r4	; R3 = posAnt/40
	add r2, r2, r3	; R2 = Tela1Linha0 + posAnt + posAnt/40
	
	loadi r5, r2	; R5 = Char (Tela(posAnt))
	
	outchar r5, r0	; Apaga o Obj na tela com o Char correspondente na memoria do cenario
	
	pop r5
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	rts

MoveTiro_Desenha:
	push r0
	push r1
	push r2
	
	Loadn r1, #'-'	; Tiro
	loadn r2, #2304 ; carrega a cor (vermelho)
	add r1, r1, r2 ;adiciona a cor 
	outchar r1, r0 ; printa
	
	pop r2
	pop r1
	pop r0
	rts


; r0-> posicao
; r1-> numero a ser impresso
ImprimeInt:
	push r0
	push r1
	push r2
	push r3 ;armazena o digito
	push r4
	push r5

	loadn r2, #10
	loadn r4, #'0'
	loadn r5, #0

	ImprimeIntLoop:

		mod r3, r1, r2
		div r1, r1, r2

		add r3, r3, r4
		outchar r3, r0

		dec r0 ;decrementa posicao

		cmp r1, r5
		jne ImprimeIntLoop

	pop r5
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	rts


; r0 -> posicao
; r1 -> endereco string
ImprimeStr:
	push r0
	push r1
	push r2
	push r3
	push r4

	loadn r3, #'\0'

	Imprimestr_loop:
		loadi r4, r1
		cmp r4, r3
		jeq Imprimestr_end
		outchar r4, r0

		inc r1
		inc r0
		jmp Imprimestr_loop

	Imprimestr_end:

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
						;Utiliza Push e Pop para nao afetar os Registradores do programa principal
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
tela0Linha28 : string "                                        "
tela0Linha29 : string "                                        "	
 
tela1Linha0  : string "                                        "
tela1Linha1  : string "                                        "
tela1Linha2  : string "                                        "
tela1Linha3  : string "                                        "
tela1Linha4  : string "                                        "
tela1Linha5  : string "                                        "
tela1Linha6  : string "                                        "
tela1Linha7  : string "                                        "
tela1Linha8  : string "                                        "
tela1Linha9  : string "                                        "
tela1Linha10 : string "                                        "
tela1Linha11 : string "                                        "
tela1Linha12 : string "                                        "
tela1Linha13 : string "                                        "
tela1Linha14 : string "                                        "
tela1Linha15 : string "                                        "
tela1Linha16 : string "                                        "
tela1Linha17 : string "                                        "
tela1Linha18 : string "                                        "
tela1Linha19 : string "                                        "
tela1Linha20 : string "                                        "
tela1Linha21 : string "                                        "
tela1Linha22 : string "                                        "
tela1Linha23 : string "                                        "
tela1Linha24 : string "                                        "
tela1Linha25 : string "                                        "
tela1Linha26 : string "                                        "
tela1Linha27 : string "                                        "
tela1Linha28 : string "________________________________________"
tela1Linha29 : string "////////////////////////////////////////"



