	#include<p18f4550.inc>
	
			org		0x00
			goto	start
			org		0x08
			retfie	
			org		0x18
			retfie
			
						
loop_cnt	equ	0x00
loop_cnt1	equ	0x01

RS			equ	RC4
RW			equ	RC5
EN			equ	RC6


;****************************************************
;Subroutine for DELAY 10ms with 20MHZ crystal
;****************************************************

dup_nop		macro	kk
			variable i
i=0
			while i < kk
			nop	
i+=1
			endw
			endm

D10ms		movlw	D'20'
			movwf	loop_cnt1,A
again1		movlw	D'250'
			movwf	loop_cnt,A
again		dup_nop	D'17'
			decfsz	loop_cnt,F,A
			bra		again	
			decfsz	loop_cnt1,F,A
			bra		again1
			return
			

;***********************************************************
;Subroutine to Configure LCD
;***********************************************************

setting_up	movlw	B'00000110'	;Setting up
			movwf	TRISC,A
			clrf	TRISD,A

line_matrix	movlw	0x38		;Configure 2 lines and 5x7 matrix
			movwf	PORTD,A
			call	writeCmd

cursor		movlw	0x0F		;Display on with cursor blinking
			movwf	PORTD,A
			call	writeCmd

clearDisp	movlw	0x01		;Clear display
			movwf	PORTD,A
			call	writeCmd
			return	

;********************************************************
;Subroutine for LCD Command
;********************************************************

writeCmd	bcf		PORTC,RS,A	;RS=0
			bcf		PORTC,RW,A	;RW=O
			bsf		PORTC,EN,A	;E=1
			call	D10ms
			bcf		PORTC,EN,A	;E=1
			return
		
;**********************************************************
;Subroutine for Send Data Command
;*********************************************************

writeData	bsf		PORTC,RS,A	;RS=1	
			bcf		PORTC,RW,A	;RW=0
			bsf		PORTC,EN,A	;E=1
			call	D10ms
			bcf		PORTC,EN,A	;E=1
			return

;**********************************************************
;Configure LCD Line
;*************************************************************

firstline	call	setting_up
			movlw	0x80
			movwf	PORTD,A
			call	writeCmd
			return

secondline	call	setting_up
			movlw	0xC0
			movwf	PORTD,A
			call	writeCmd
			return	


;**********************************************************
;Subroutine to display my Name on first row LCD
;**********************************************************
			
MyName		call	firstline
			movlw	D'68'		
			movwf	PORTD,A
			call	writeData
	
			movlw	D'73'		
			movwf	PORTD,A
			call	writeData

			movlw	D'89'	
			movwf	PORTD,A
			call	writeData

			movlw	D'65'		
			movwf	PORTD,A
			call	writeData

			movlw	D'78'		
			movwf	PORTD,A
			call	writeData
			
			movlw	D'65'		
			movwf	PORTD,A
			call	writeData
			
			return

;**********************************************************
;Subroutine to display my ID on first row LCD
;**********************************************************

MyID		call	firstline
			movlw	D'68'
			movwf	PORTD,A
			call	writeData	

			movlw	D'69'
			movwf	PORTD,A
			call	writeData	

			movlw	D'57'
			movwf	PORTD,A
			call	writeData
			
			movlw	D'54'
			movwf	PORTD,A
			call	writeData
			
			movlw	D'51'
			movwf	PORTD,A
			call	writeData

			movlw	D'53'
			movwf	PORTD,A
			call	writeData
	
   			movlw	D'54'
			movwf	PORTD,A
			call	writeData	

			return				


;******************************************************
;Subroutine for keypad configuration
;*****************************************************

conA	bsf		PORTB,4,A
		bcf		PORTB,5,A
		bcf		PORTB,6,A
		bcf		PORTB,7,A
		return

conB	bcf		PORTB,4,A
		bsf		PORTB,5,A
		bcf		PORTB,6,A
		bcf		PORTB,7,A
		return

conC	bcf		PORTB,4,A
		bcf		PORTB,5,A
		bsf		PORTB,6,A
		bcf		PORTB,7,A
		return

conD	bcf		PORTB,4,A
		bcf		PORTB,5,A
		bcf		PORTB,6,A
		bsf		PORTB,7,A
		return

;******************************************************
;Subroutine for keypad number
;******************************************************

keypad	movlw	B'00001110'
		movwf	TRISB,A

num1	call	conA
		btfss	PORTB,1,A
		bra		num2
		call	show1

num2	call	conA
		btfss	PORTB,2,A
		bra		num3
		call	show2

num3	call	conA
		btfss	PORTB,3,A
		bra		num4
		call	show3

num4	call	conB
		btfss	PORTB,1,A
		bra		num5
		call	show4

num5	call	conB
		btfss	PORTB,2,A
		bra		num6
		call	show5

num6	call	conB
		btfss	PORTB,3,A
		bra		num7
		call	show6

num7	call	conC
		btfss	PORTB,1,A
		bra		num8
		call	show7

num8	call	conC
		btfss	PORTB,2,A
		bra		num9
		call	show8

num9	call	conC
		btfss	PORTB,3,A
		bra		numstar
		call	show9

numstar	call	conD
		btfss	PORTB,1,A
		bra		num0
		call	star


num0	call	conD
		btfss	PORTB,2,A
		bra		numH
		call	show0


numH	call	conD
		btfss	PORTB,3,A
		bra		num1
		call	Hashtag

		return	

;********************************************************
;Subroutine to display Keypad on LCD
;********************************************************

show1	call	secondline
		movlw	D'49'
		movwf	PORTD,A
		call	writeData
		return

show2	call	secondline
		movlw	D'50'
		movwf	PORTD,A
		call	writeData
		return	

show3	call	secondline
		movlw	D'51'
		movwf	PORTD,A
		call	writeData
		return

show4	call	secondline
		movlw	D'52'
		movwf	PORTD,A
		call	writeData
		return

show5	call	secondline
  		movlw	D'53'
		movwf	PORTD,A
		call	writeData
		return	

show6	call	secondline	
		movlw	D'54'
		movwf	PORTD,A
		call	writeData
		return

show7	call	secondline
		movlw	D'55'
		movwf	PORTD,A
		call	writeData
		return

show8	call	secondline
		movlw	D'56'
		movwf	PORTD,A
		call	writeData
		return	

show9	call	secondline
		movlw	D'57'
		movwf	PORTD,A
		call	writeData
		return

star	call	secondline
		movlw	D'42'
		movwf	PORTD,A
		call	writeData
		return

show0	call	secondline
		movlw	D'48'
		movwf	PORTD,A
		call	writeData
		return

Hashtag	call	secondline
		movlw	D'35'
		movwf	PORTD,A
		call	writeData
		return
			
;*****************************************************************
;My Main Program.
;*****************************************************************			
			
start		call	setting_up
			movlw	B'00000110'
			movwf	TRISC,A

button1		BTFSS	PORTC,1,A
			bra		button2
			call	MyName

button2		BTFSS	PORTC,2,A
			bra		button1
			call	MyID

PressAny	call	keypad
			bra		button1	

			end
			
	