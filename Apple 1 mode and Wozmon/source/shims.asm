;
;Small 'shims' of code to help emulate the PIA interface from the original Apple 1
;

CHFLG   	=     $1C     	;temp space to emulate 6821 keyboard rdy

;acia serial port
ACIA = $A000
ACIAControl = ACIA+0
ACIAStatus = ACIA+0
ACIAData = ACIA+1

	.ORG	$DFB8	;$FE9C
;	
;routenes for 'shim' to get BASIC on ACIA and krusader
;
	
OUTCH4	PHA			;normal Serial send a character
.SOUT	LDA	ACIAStatus
	AND	#2
	BEQ	.SOUT
	PLA
        STA     ACIAData		;send it
        RTS
        	
OUTCH3	PHA			;used as outch, adds a LF suitable for most serial terminals.
	AND	#$7F	
	JSR	OUTCH4		;SEND THE CHAR
        CMP	#$0D		;IS IT A RETURN
        BNE	.DONE
	LDA	#$0A
	JSR	OUTCH4
.DONE	PLA
	RTS

	
GETCH3	PHA			;simulates apple checking bit 7 of PIA keyboard in, sets sign flag
	LDA	#$0	
	STA	CHFLG	
	LDA	ACIAStatus	; get bit 1
	AND	#$1
	BEQ	.done
	DEC	CHFLG
.done	PLA
	BIT	CHFLG
	RTS
			
GETCH   		; Get a character from the keyboard.
        LDA     ACIAStatus
        AND     #1
        BEQ     GETCH
        LDA     ACIAData
        RTS
        
GETCH2			;used as the original GETCH, sets bit 7 high
	JSR	GETCH
	ORA	#$80
	RTS	

GETCH1	JSR GETCH	;used to get and echo a single key at a time
	JMP OUTCH4	
;