
BS	=$08		; backspace
SP	=$20		; space
CR	=$0D		; carriage return
LF	=$0A		; line feed
ESC	=$1B		; escape

IN              =     $0200           ;  Input buffer to $027F

CHFLG   =       $1C     ;temp space to emulate 6821 keyboard rdy
XAML            =     $24             ;  Last "opened" location Low
XAMH            =     $25             ;  Last "opened" location High
STL             =     $26             ;  Store address Low
STH             =     $27             ;  Store address High
L               =     $28             ;  Hex value parsing Low
H               =     $29             ;  Hex value parsing High
YSAVM           =     $2A             ;  Used to see if hex value is given
MODEM           =     $2B             ;  $00=XAM, $7F=STOR, $AE=BLOCK XAM

ACIA = $A000
ACIAControl = ACIA+0
ACIAStatus = ACIA+0
ACIAData = ACIA+1

RAMTEST = 0		;EITHER rOM FE00 OR RAM 7E00

GETCH1 = $DFF9		;These are from the compiled 'shims' code
OUTCH4 = $DFB8

	.START RESET
	
MONPROMPT          =     '\'             ;  Prompt character
;debug/testing
	.IF 	RAMTEST
        .ORG     $7F00 ;$FF00
        .ELSE
        .ORG	$FF00
        .ENDIF
                
RESET           CLD                   ;  Clear decimal arithmetic mode
;                CLI		      ;interupt is connected but not used in the normal way, leave disabled
;                
                LDA     #$95          ; Set ACIA baud rate, word size and Rx
                                      ; interrupt (to control RTS)
        	STA     ACIAControl

ESCAPE          LDA     #MONPROMPT    ;  Print prompt character
                JSR     OUTCH         ;  Output it.
GET             JSR 	GETLINE
                BCC 	ESCAPE
                BCS 	GET
GETLINE         JSR 	CRLF
                LDY     #0+1          ;  Start a new input line
BACKSPACE       DEY                   ;  Backup text index
                BMI     GETLINE       ;  Oops, line's empty, reinitialize
NEXTCHAR        JSR 	GETCH1
		STA     IN,Y          ;  Add to text buffer
                CMP     #CR
                BEQ 	.CONT
		CMP     #BS           ;  Backspace key?
                BEQ     BACKSPACE     ;  Yes
                CMP     #ESC          ;  ESC?
                BEQ     ESCAPE        ;  Yes
                INY                   ;  Advance text index
                BPL     NEXTCHAR      ;  Auto ESC if line longer than 127
.CONT				      ;  Line received, now let's parse it
                LDY     #-1           ;  Reset text index
                LDA     #0            ;  Default mode is XAM
                TAX                   ;  X=0
SETSTOR         ASL                   ;  Leaves $7B if setting STOR mode
SETMODE         STA     MODEM         ;  Set mode flags
BLSKIP          INY                   ;  Advance text index
NEXTITEM        LDA     IN,Y          ;  Get character
                CMP     #CR
                BNE 	.CONT
     		SEC
     		RTS           
.CONT           ORA 	#$80
                CMP     #'.'+$80
                BCC     BLSKIP        ;  Ignore everything below "."!
                BEQ     SETMODE       ;  Set BLOCK XAM mode ("." = $AE)
                CMP     #':'+$80
                BEQ     SETSTOR       ;  Set STOR mode! $BA will become $7B
                CMP     #'R'+$80
                BEQ     RUNM          ;  Run the program! Forget the rest
                STX     L             ;  Clear input value (X=0)
                STX     H
                STY     YSAVM          ;  Save Y for comparison
NEXTHEX         LDA     IN,Y          ;  Get character for hex test
                EOR     #$30          ;  Map digits to 0-9
                CMP     #$0A          ;  Is it a decimal digit?
                BCC     DIG           ;  Yes!
                ADC     #$88          ;  Map letter "A"-"F" to $FA-FF
                CMP     #$FA          ;  Hex letter?
                BCC     NOTHEX        ;  No! Character not hex
DIG             ASL
                ASL                   ;  Hex digit to MSD of A
                ASL
                ASL
                LDX     #4            ;  Shift count
HEXSHIFT        ASL                   ;  Hex digit left, MSB to carry
                ROL     L             ;  Rotate into LSD
                ROL     H             ;  Rotate into MSD's
                DEX                   ;  Done 4 shifts?
                BNE     HEXSHIFT      ;  No, loop
                INY                   ;  Advance text index
                BNE     NEXTHEX       ;  Always taken
NOTHEX          CPY     YSAVM         ;  Was at least 1 hex digit given?
                BNE 	.CONT
                CLC		      ;  No! Ignore all, start from scratch
                RTS
.CONT		BIT     MODEM         ;  Test MODE byte
                BVC     NOTSTOR       ;  B6=0 is STOR, 1 is XAM or BLOCK XAM
                LDA     L             ;  LSD's of hex data
                STA     (STL,X)       ;  Store current 'store index'(X=0)
                INC     STL           ;  Increment store index.
                BNE     NEXTITEM      ;  No carry!
                INC     STH           ;  Add carry to 'store index' high
TONEXTITEM      JMP     NEXTITEM      ;  Get next command item.
RUNM            JMP     (XAML)        ;  Run user's program
NOTSTOR         BMI     XAMNEXT       ;  B7 = 0 for XAM, 1 for BLOCK XAM
                LDX     #2            ;  Copy 2 bytes
SETADR          LDA     L-1,X         ;  Copy hex data to
                STA     STL-1,X       ;   'store index'
                STA     XAML-1,X      ;   and to 'XAM index'
                DEX                   ;  Next of 2 bytes
                BNE     SETADR        ;  Loop unless X = 0
NXTPRNT         BNE     PRDATA        ;  NE means no address to print
                JSR 	CRLF
                LDA     XAMH          ;  Output high-order byte of address
                JSR     OUTHEX
                LDA     XAML          ;  Output low-order byte of address
                JSR     OUTHEX
                LDA     #':'          ;  Print colon
                JSR     OUTCH
PRDATA          JSR 	OUTSP
                LDA     (XAML,X)      ;  Get data from address (X=0)
                JSR     OUTHEX        ;  Output it in hex format
XAMNEXT         STX     MODEM         ;  0 -> MODE (XAM mode).
                LDA     XAML          ;  See if there's more to print
                CMP     L
                LDA     XAMH
                SBC     H
                BCS     TONEXTITEM    ;  Not less! No more data to output
                INC     XAML          ;  Increment 'examine index'
                BNE     MOD8CHK       ;  No carry!
                INC     XAMH
MOD8CHK         LDA     XAML          ;  If address MOD 8 = 0 start new line
                AND     #$07
                BPL     NXTPRNT       ;  Always taken.
CRLF			; Go to a new line.
	LDA #CR		; "CR"
	JSR OUTCH4
	LDA #LF		; "LF" - is this needed for the Apple 1?
	JMP OUTCH4
;	

		
	.IF RAMTEST
	.ORG $7FDC ;$FFDC
	.ELSE
	.ORG	$FFDC	;$FECC
	.ENDIF
	
OUTHEX	PHA 		; Print 1 hex byte. 
	LSR
	LSR 
	LSR
	LSR 
	JSR PRHEX
	PLA 
PRHEX	AND #$0F	; Print 1 hex digit
	ORA #$30
	CMP #$3A
	BCC OUTCH
	ADC #$06
OUTCH	JMP OUTCH4
OUTSP	
	LDA #SP
	JMP OUTCH4
	
	.IF RAMTEST
	.ORG $7FFA ;$FFFA	; INTERRUPT VECTORS
	.ELSE
	.ORG $FFFA
	.ENDIF
	
	.WORD $0F00
	.WORD RESET
	.WORD $FE18		;debug in krusaider, from compiled krusader code.
	
; Apple 1 I/O values for reference only
;OUTCH	=$FFEF		; Apple 1 Echo
;PRHEX	=$FFE5		; Apple 1 Echo
;OUTHEX	=$FFDC		; Apple 1 Print Hex Byte Routine

;KBD     =$D010		; Apple 1 Keyboard character read.
;KBDRDY  =$D011		; Apple 1 Keyboard data waiting when negative.
