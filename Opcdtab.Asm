;SAVE"Opcdtab.Asm"
*------------------------------
*        DIRECTIVE TABLE
*------------------------------
OPTBLDIR DIR     "ADJST ",PSAD
         DIR     "ASC ",PSAS
         DIR     "AST ",PSAT
         DIR     "DATA ",PSDA
         DIR     "DEFS ",PSBS
         DIR     "DO ",PSDO
         DIR     "ELSE ",PSEL
         DIR     "END ",PSEN
         DIR     "ENDR ",PSENR
         DIR     "=",PSEQ
         DIR     "EQU ",PSEQ
         DIR     "FIN ",PSFI
         DIR     "HEX ",PSHS
         DIR     "INCLUDE ",PSIN
         DIR     "LIST ",PSLI
         DIR     "MACRO ",PSMACRO
         DIR     "ORG ",PSOR
         DIR     "PAGE ",PSPG
         DIR     "RFILE ",PSNA
         DIR     "RSRC ",PSRS
         DIR     "STR ",PSTR
         DIR     "TADDR ",PSTA
         DIR     "TFILE ",PSTF
         DIR     "TITLE ",PSTI
         DIR     "_",PSTRAP
         HEX     00
         ADJST
*------------------------------
*
* REGISTER SYMBOL ENTRIES START
* AT REGTBL, FORMAT IS SAME AS
* SYMBOL TABLE. VALUE BYTES ARE:
*
* LO BYTE OF VALUE: REGISTER #
*
*------------------------------
CHKREG   LEA     REGTBL(PC),A1
         BRA     SRCHDIR
*------------------------------
REGTBL   REG     "A0",8
         REG     "A1",9
         REG     "A2",10
         REG     "A3",11
         REG     "A4",12
         REG     "A5",13
         REG     "A6",14
         REG     "A7",15
         REG     "SP",15
         REG     "CCR",16
         REG     "D0",0
         REG     "D1",1
         REG     "D2",2
         REG     "D3",3
         REG     "D4",4
         REG     "D5",5
         REG     "D6",6
         REG     "D7",7
         REG     "PC",19
         REG     "SR",17
         REG     "USP",18
         HEX     00
         ADJST
*------------------------------
*   OPCODE TABLE
*------------------------------
OPADD    DATA    /OPT.A-OPADD
         DATA    /OPT.B-OPADD
         DATA    /OPT.C-OPADD
         DATA    /OPT.D-OPADD
         DATA    /OPT.E-OPADD
         DATA    /0
         DATA    /0
         DATA    /0
         DATA    /OPT.I-OPADD
         DATA    /OPT.J-OPADD
         DATA    /0
         DATA    /OPT.L-OPADD
         DATA    /OPT.M-OPADD
         DATA    /OPT.N-OPADD
         DATA    /OPT.O-OPADD
         DATA    /OPT.P-OPADD
         DATA    /0
         DATA    /OPT.R-OPADD
         DATA    /OPT.S-OPADD
         DATA    /OPT.T-OPADD
         DATA    /OPT.U-OPADD
         DATA    /0
         DATA    /0
         DATA    /0
         DATA    /0
         DATA    /0
OPT.A    ENTRY1  .01,"ABCD",$C100,$09,$09,AA4000
         ENTRY2  $C108,$04,$04,6A4000
.01      ENTRY1  .02,"ADD",$D000,$11,$09,BFC000
         ENTRY2  $D100,$09,$07,C7F800
.02      ENTRY1  .03,"ADDA",$D0C0,$0D,$08,F9C400
.03      ENTRY1  .04,"ADDQ",$5000,$01,$0C,C7F200
.04      ENTRY1  .05,"ADDI",$0600,$01,$0A,47F000
.05      ENTRY1  .06,"ADDX",$D100,$09,$09,AFC000
         ENTRY2  $D108,$04,$04,6FC000
.06      ENTRY1  .07,"AND",$C000,$12,$09,BFC000
         ENTRY2  $C100,$09,$07,C7F800
.07      ENTRY1  .08,"ANDI",$0200,$01,$0A,87F000
         ENTRY2  $23C,$01,$0E,824000
         ENTRY2  $27C,$01,$0F,414000
.08      ENTRY1  .09,"ASL",$E120,$09,$09,87E800
         ENTRY2  $E100,$01,$09,87E200
         ENTRY2  $E1C0,$07,$00,714000
.09      ENTRY1  *,"ASR",$E020,$09,$09,87E800
         ENTRY2  $E000,$01,$09,87E200
         ENTRY2  $E0C0,$07,$00,714000
OPT.B    ENTRY1  .11,"BCHG",$0140,$09,$0A,803800
         ENTRY2  $0840,$01,$0A,403000
.11      ENTRY1  .12,"BCLR",$0180,$09,$0A,803800
         ENTRY2  $0880,$01,$0A,403000
.12      ENTRY1  .13,"BRA",$6000,$02,$00,43C100
.13      ENTRY1  .14,"BSET",$01C0,$09,$0A,803800
         ENTRY2  $08C0,$01,$0A,403000
.14      ENTRY1  .15,"BSR",$6100,$02,$00,43C100
.15      ENTRY1  .16,"BTST",$0100,$09,$0A,803800
         ENTRY2  $0800,$01,$0A,403000
.16      ENTRY3  *,"B",$6000,$02,$00,43C140
OPT.C    ENTRY1  .18,"CHK",$4180,$0B,$09,790000
.18      ENTRY1  .19,"CLR",$4200,$0A,$00,77C000
.19      ENTRY1  .20,"CMP",$B000,$11,$09,FFC000
.20      ENTRY1  .21,"CMPA",$B0C0,$0D,$08,F9C400
.21      ENTRY1  .22,"CMPI",$0C00,$01,$0A,C7F000
.22      ENTRY1  *,"CMPM",$B108,$05,$05,6FC000
OPT.D    ENTRY3  .24,"DB",$50C8,$09,$02,6000A0
.24      ENTRY1  .25,"DIVS",$81C0,$0B,$09,780000
.25      ENTRY1  *,"DIVU",$80C0,$0B,$09,780000
OPT.E    ENTRY1  .27,"EOR",$B100,$09,$0A,C7F800
.27      ENTRY1  .28,"EORI",$0A00,$01,$0A,87F000
         ENTRY2  $0A3C,$01,$0E,824000
         ENTRY2  $A7C,$01,$0F,414000
.28      ENTRY1  .29,"EXG",$C140,$09,$09,802800
         ENTRY2  $C148,$08,$08,802800
         ENTRY2  $C188,$09,$08,802800
         ENTRY2  $C188,$08,$09,680000
.29      ENTRY1  .30,"EXT.W",$4880,$09,$00,600000
.30      ENTRY1  .90,"EXT.L",$48C0,$09,$00,600000
.90      ENTRY1  *,"EXT",$4880,$09,$00,600000
OPT.I    ENTRY1  *,"ILLEGAL",$4AFC,$00,$00,400000
OPT.J    ENTRY1  .33,"JMP",$4EC0,$06,$00,700000
.33      ENTRY1  *,"JSR",$4E80,$06,$00,700000
OPT.L    ENTRY1  .35,"LEA",$41C0,$06,$08,780000
.35      ENTRY1  .36,"LINK",$4E50,$08,$01,610000
.36      ENTRY1  .37,"LSL",$E128,$09,$09,87E800
         ENTRY2  $E108,$01,$09,87E200
         ENTRY2  $E3C0,$07,$00,714000
.37      ENTRY1  *,"LSR",$E028,$09,$09,87E800
         ENTRY2  $E008,$01,$09,87E200
         ENTRY2  $E2C0,$07,$00,714000
OPT.M    ENTRY1  .39,"MOVE",$0000,$0D,$0A,BBC018
         ENTRY2  $44C0,$0B,$0E,B24000
         ENTRY2  $46C0,$0B,$0F,B14000
         ENTRY2  $40C0,$0F,$0A,817000
         ENTRY2  $4E68,$10,$08,80E000
         ENTRY2  $4E60,$08,$10,E0C000
.39      ENTRY1  .40,"MOVEA",$0040,$0D,$08,B9C018
         ENTRY2  $0008,$08,$0A,79C018
.40      ENTRY1  .41,"MOVEM",$0000,$00,$00,400004
.41      ENTRY1  .42,"MOVEP.W",$0108,$03,$09,A80000
         ENTRY2  $0188,$09,$03,402800
.42      ENTRY1  .43,"MOVEP.L",$0148,$03,$09,A80000
         ENTRY2  $01C8,$09,$03,402800
.43      ENTRY1  .91,"MOVEP",$0108,$03,$09,A80000
         ENTRY2  $0188,$09,$03,402800
.91      ENTRY1  .44,"MOVEQ",$0000,$00,$00,400002
.44      ENTRY1  .45,"MULS",$C1C0,$0B,$09,780000
.45      ENTRY1  *,"MULU",$C0C0,$0B,$09,780000
OPT.N    ENTRY1  .47,"NBCD",$4800,$0A,$00,724000
.47      ENTRY1  .48,"NEG",$4400,$0A,$00,77C000
.48      ENTRY1  .49,"NEGX",$4000,$0A,$00,77C000
.49      ENTRY1  .50,"NOP",$4E71,$00,$00,400000
.50      ENTRY1  *,"NOT",$4600,$0A,$00,77C000
OPT.O    ENTRY1  .52,"OR",$8000,$12,$09,BFC000
         ENTRY2  $8100,$09,$07,C7F800
.52      ENTRY1  *,"ORI",$0000,$01,$0A,87F000
         ENTRY2  $003C,$01,$0E,824000
         ENTRY2  $007C,$01,$0F,414000
OPT.P    ENTRY1  *,"PEA",$4840,$06,$00,700000
OPT.R    ENTRY1  .55,"RESET",$4E70,$00,$00,400000
.55      ENTRY1  .56,"ROL",$E138,$09,$09,87E800
         ENTRY2  $E118,$01,$09,87E200
         ENTRY2  $E7C0,$07,$00,714000
.56      ENTRY1  .57,"ROR",$E038,$09,$09,87E800
         ENTRY2  $E018,$01,$09,87E200
         ENTRY2  $E6C0,$07,$00,714000
.57      ENTRY1  .58,"ROXL",$E130,$09,$09,87E800
         ENTRY2  $E110,$01,$09,87E200
         ENTRY2  $E5C0,$07,$00,714000
.58      ENTRY1  .59,"ROXR",$E030,$09,$09,87E800
         ENTRY2  $E010,$01,$09,87E200
         ENTRY2  $E4C0,$07,$00,714000
.59      ENTRY1  .60,"RTE",$4E73,$00,$00,400000
.60      ENTRY1  .61,"RTR",$4E77,$00,$00,400000
.61      ENTRY1  *,"RTS",$4E75,$00,$00,400000
OPT.S    ENTRY1  .63,"SBCD",$8100,$09,$09,AA4000
         ENTRY2  $8108,$04,$04,6A4000
.63      ENTRY1  .64,"STOP",$4E72,$01,$00,410000
.64      ENTRY1  .65,"SUB",$9000,$11,$09,BFC000
         ENTRY2  $9100,$09,$07,C7F800
.65      ENTRY1  .66,"SUBA",$90C0,$0D,$08,F9C400
.66      ENTRY1  .67,"SUBQ",$5100,$01,$0C,C7F200
.67      ENTRY1  .68,"SUBI",$0400,$01,$0A,47F000
.68      ENTRY1  .69,"SUBX",$9100,$09,$09,AFC000
         ENTRY2  $9108,$04,$04,6FC000
.69      ENTRY1  .70,"SWAP",$4840,$09,$00,600000
.70      ENTRY3  *,"S",$50C0,$0A,$00,700020
OPT.T    ENTRY1  .72,"TAS",$4AC0,$0A,$00,700000
.72      ENTRY1  .73,"TRAPV",$4E76,$00,$00,400000
.73      ENTRY1  .74,"TRAP",$0000,$00,$00,400001
.74      ENTRY1  *,"TST",$4A00,$0A,$00,77C000
OPT.U    ENTRY1  *,"UNLK",$4E58,$08,$00,200000
*------------------------------
ADRTBL   HEX     0000.0001.0018.0040
         HEX     0080.0100.027E.03F8
         HEX     0400.0800.0BF8.0BFF
         HEX     0FF8.0FFF.1000.2000
         HEX     4000.0FFE.0BFE
*------------------------------
SIZETBL  HEX     103020
*------------------------------
COND.16  ASC /T/
         HEX 0000
         ASC /F/
         HEX 0001
         ASC /RA/    FOR DBRA SAME AS DBF
         HEX 01
COND.14  ASC /CC/
         HEX 04
         ASC /CS/
         HEX 05
         ASC /EQ/
         HEX 07
         ASC /GE/
         HEX 0C
         ASC /GT/
         HEX 0E
         ASC /HI/
         HEX 02
         ASC /LE/
         HEX 0F
         ASC /HS/
         HEX 04
         ASC /LO/
         HEX 05
         ASC /LS/
         HEX 03
         ASC /LT/
         HEX 0D
         ASC /MI/
         HEX 0B
         ASC /NE/
         HEX 06
         ASC /PL/
         HEX 0A
         ASC /VC/
         HEX 08
         ASC /VS/
         HEX 09
         HEX 00
         ADJST
*------------------------------
SCOND    MOVE.W  CHRPTR(A5),D2
.0       MOVE.W  D2,CHRPTR(A5)
.1       BSR     GNC.UC
         CMP.B   (A1),D0
         BNE.S   .2
         MOVE.B  1(A1),D1
         BEQ.S   .3
         BSR     GNC.UC
         CMP.B   D1,D0
         BEQ.S   .3
.2       LEA     3(A1),A1
         TST.B   (A1)
         BNE.S   .0
         BRA     ERBA
.3       RTS
*------------------------------
SPECIAL  BSR     GNNB
         BSR     BACKCHR
         BTST    #2,FLAG3(A5)
         BNE     OPMOVEM
         BTST    #1,FLAG3(A5)
         BNE.S   OPMOVEQ
OPTRAP   BSR     GETADDR
         CMP.W   #$0001,TYPE(A5)
         BNE     ERBA
         MOVEQ   #$4E,D0
         BSR     EMIT
         MOVE.L  DISP(A5),D0
         CMP.L   #16,D0
         BLO.S   .0
         ORI.B   #1,RAERFL(A5)
         CLR.L   D0
.0       OR.B    #$40,D0
OPEM     BSR     EMIT
         TST.B   RAERFL(A5)
         BNE     RAER
         RTS
OPMOVEQ  BSR     GETADDR
         CMP.W   #$0001,TYPE(A5)
         BNE     ERBA
         MOVE.L  DISP(A5),D0
         CMP.L   #$00000100,D0
         BLO.S   .0
         CMP.L   #$FFFFFF80,D0
         BHS.S   .0
         ORI.B   #1,RAERFL(A5)
         CLR.L   D0
.0       MOVE.B  D0,OPCODE+1(A5)
         BSR     GNC
         CMP.B   #',',D0
         BNE     ERBA
         BSR     GETADDR
         CMP.W   #$0800,TYPE(A5)
         BNE     ERBA
         MOVE.B  MODEREG(A5),D0
         AND.B   #$07,D0
         LSL.B   #1,D0
         OR.B    #$70,D0
         BSR     EMIT
         MOVE.B  OPCODE+1(A5),D0
         BRA.S   OPEM
OPMOVEM  CLR.B   SIZE(A5)
         CLR.W   REGLST(A5)
         BSR     GNC
         CMP.B   #'.,D0
         BNE.S   .0
         BSR     GNC.UC
         CMP.B   #'W,D0
         BEQ.S   .1
         CMP.B   #'L,D0
         BNE     ERBA
         MOVE.B  #$40,SIZE(A5)
         BRA.S   .1
.0       BSR     BACKCHR
.1       BSR     GNNB
         BSR     BACKCHR
         MOVE.W  CHRPTR(A5),D2
         MOVE.B  #4,FLAG1(A5)
         BSR     CHKREG
         BCC.S   OPMV.MR
OPMV.RM  CLR.B   FLAG1(A5)
         MOVE.W  D2,CHRPTR(A5)
         BSR     PRGLST
         CMP.B   #',',D0
         BNE     ERBA
         BSR     GETADDR
         MOVE.W  TYPE(A5),D0
         AND.W   #$02F8,D0
         BEQ     ERBA
         CMP.W   #$0080,D0
         BNE.S   .0
         BSR     REVREG
.0       BRA     MOVEMIT
OPMV.MR  MOVE.W  D2,CHRPTR(A5)
         BSR     GETADDR
         MOVE.W  TYPE(A5),D0
         AND.W   #$037E,D0
         BEQ     ERBA
         BSR     GNC
         CMP.B   #',',D0
         BNE     ERBA
         BSR     PRGLST
MOVEMIT  MOVEQ   #$48,D0
         OR.B    FLAG1(A5),D0
         BSR     EMIT
         MOVEQ   #$80,D0
         OR.B    SIZE(A5),D0
         OR.B    MODEREG(A5),D0
         BSR     EMIT
         MOVE.B  REGLST(A5),D0
         BSR     EMIT
         MOVE.B  REGLST+1(A5),D0
         BSR     EMIT
         BRA     DONE0
PRGLST   BSR     GETREG
         MOVE.B  D1,D2
         BSR     DOREG
         BSR     GNC
         CMP.B   #'-,D0
         BEQ.S   .1
.0       CMP.B   #'/,D0
         BEQ.S   PRGLST
         RTS
.1       BSR     GETREG
         CMP.B   D1,D2
         BHS     ERBA
.2       BSR     DOREG
         SUBQ.B  #1,D1
         CMP.B   D2,D1
         BNE.S   .2
         BSR     GNC
         BRA.S   .0
GETREG   BSR     CHKREG
         BCC     ERBA
         CMP.B   #$10,D1
         BHS     ERBA
         RTS
DOREG    MOVE.W  REGLST(A5),D0
         BSET    D1,D0
         MOVE.W  D0,REGLST(A5)
         RTS
REVREG   MOVE.W  REGLST(A5),D0
         MOVEQ   #16-1,D2
.0       LSL.W   #1,D0
         ROXR.W  #1,D1
         DBRA    D2,.0
         MOVE.W  D1,REGLST(A5)
         RTS
*------------------------------
