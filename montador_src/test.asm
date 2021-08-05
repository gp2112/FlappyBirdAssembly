
rvals: var #32736			; Tabela de nr. Randomicos entre 0 - 4
static rvals + #0, #0
static rvals + #1, #3
static rvals + #2, #4
static rvals + #3, #1
static rvals + #4, #3
static rvals + #5, #1
static rvals + #6, #4
static rvals + #7, #1
static rvals + #8, #0
static rvals + #9, #2
static rvals + #10, #2
static rvals + #11, #1
static rvals + #12, #0
static rvals + #13, #1
static rvals + #14, #4
static rvals + #15, #2
static rvals + #16, #3
static rvals + #17, #3
static rvals + #18, #4
static rvals + #19, #1
static rvals + #20, #0
static rvals + #20, #3
static rvals + #21, #2
static rvals + #22, #2
static rvals + #23, #3
static rvals + #24, #4
static rvals + #25, #4
static rvals + #26, #0
static rvals + #27, #2
static rvals + #28, #0
static rvals + #29, #2


Main:
	loadn r0, #65
	loadn r1, #26

	call imprimeRandom
	call imprimeRandom
	call imprimeRandom

	halt

imprimeRandom:
	push r0
	push r1
	push r2
	push r3
	push r4

	rand r2

	mod r4, r2, r1 ; r4 -> r2 % 26

	add r0, r0, r4 ; r0 -> 65 + r2 % 26

		;loadn r1, #30


	outchar r0, r1
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	rts