;SAVE"Expcrack.asm"
*------------------------------
RUN      BSR     EXPDFND
         MOVE.L  D1,A0
         JSR     (A0)
         MOVEQ   #$0C,D0
         BRA     CHO
*------------------------------
VAL      BSR     EXPDFND
         MOVEQ   #'$,D0
         BSR     CHO
         MOVE.L  D1,D0
         BSR     PRNT.L
         MOVE.L  D1,D2
         MOVEQ   #15,D1
         BSR     HTAB
         MOVE.L  D2,D1
         BPL.S   .0
         MOVEQ   #'-,D0
         BSR     CHO
         NEG.L   D1
.0       BSR     DISNUM
         BRA     CRLF
*------------------------------
EXPDFND  BSR.S   EXPR
         BNE     UNDF
         RTS
*------------------------------
EXPR     BSR     GNNB
         BCS     ERBE
         BSR     BACKCHR
EXP1     CLR.B   EXPUDF(A5)
         MOVE.B  #$80,EXPFWD(A5)
         CLR.W   PARLVL(A5)
         CLR.B   LAST(A5)
         CLR.W   STPTR1(A5)
         MOVE.W  #2,STPTR2(A5)
         CLR.W   STACK2(A5)
EXP2     BSR     RDATOM
         BCC.S   .0
         BSR     PUSH1
         BRA.S   EXP2
.0       CMP.B   #8,D1      ;")"
         BNE.S   .2
         TST.W   PARLVL(A5)
         BNE.S   .1
         BSR     BACKCHR
         MOVE.W  #$1209,D1
         BRA.S   .0
.1       BSR     TOS2
         CMP.B   #1,D0      ;"("
         BNE.S   .6
         SUBQ.W  #1,PARLVL(A5)
         BSR     POP2
         BRA.S   EXP2
.2       CMP.B   #1,D1      ;"("
         BNE.S   .4
         ADDQ.W  #1,PARLVL(A5)
.3       BSR     PUSH2
         BRA.S   EXP2
.4       CMP.B   #9,D1      ;EOL
         BNE.S   .5
         BSR     TOS2
         TST.B   D0
         BNE.S   .6
         BSR     TOS1
         MOVE.L  D0,D1
         MOVE.B  EXPUDF(A5),D0
         BEQ.S   .7
         CLR.L   D1
.7       TST.B   D0
         RTS
.5       BSR     TOS2
         CMP.B   D1,D0
         BLO.S   .3
         CMP.B   #7,D1      ;.NOT.
         BEQ.S   .3
.6       MOVE.W  D1,-(A7)
         BSR     EXEC
         MOVE.W  (A7)+,D1
         BRA.S   .0
*------------------------------
PUSH1    LEA     STACK1(A5),A0
         MOVE.W  STPTR1(A5),D7
         MOVE.L  D1,0(A0,D7.W)
         ADDQ.W  #4,D7
         MOVE.W  D7,STPTR1(A5)
         CMP.W   #16*4,D7
         BHS     ERBE
         RTS
PUSH2    LEA     STACK2(A5),A0
         MOVE.W  STPTR2(A5),D7
         MOVE.W  D1,0(A0,D7.W)
         ADDQ.W  #2,D7
         MOVE.W  D7,STPTR2(A5)
         CMP.W   #16*2,D7
         BHS     ERBE
         RTS
TOS1     LEA     STACK1(A5),A0
         MOVE.W  STPTR1(A5),D7
         MOVE.L  -4(A0,D7.W),D0
         RTS
TOS2     LEA     STACK2(A5),A0
         MOVE.W  STPTR2(A5),D7
         MOVE.W  -2(A0,D7.W),D0
         RTS
POP1     TST.W   STPTR1(A5)
         BEQ.S   .0
         SUBQ.W  #4,STPTR1(A5)
.0       RTS
POP2     TST.W   STPTR2(A5)
         BEQ.S   .0
         SUBQ.W  #2,STPTR2(A5)
.0       RTS
*------------------------------
EXEC     BSR     TOS1
         MOVE.L  D0,D2
         BSR     POP1
         BSR     TOS1
         MOVE.L  D0,D1
         BSR     POP1
         BSR     TOS2
         BSR     POP2
         LSR.W   #7,D0
         LEA     OPER(PC),A0
         MOVE.W  -2(A0,D0.W),D0
         LEA     OPAR(PC),A0
         JSR     0(A0,D0.W)
         BRA     PUSH1
OPER     DATA    /OPAR-OPAR
         DATA    /EQU-OPAR
         DATA    /NEQ-OPAR
         DATA    /LT-OPAR
         DATA    /GT-OPAR
         DATA    /LE-OPAR
         DATA    /GE-OPAR
         DATA    /PLUS-OPAR
         DATA    /MINUS-OPAR
         DATA    /MULT-OPAR
         DATA    /DIV-OPAR
         DATA    /MOD-OPAR
         DATA    /OR-OPAR
         DATA    /XOR-OPAR
         DATA    /AND-OPAR
         DATA    /NOT-OPAR
OPAR     BRA     ERBE
TRUE     MOVEQ   #-1,D1
         RTS
FALSE    CLR.L   D1
         RTS
EQU      CMP.L   D2,D1
         BEQ.S   TRUE
         BRA.S   FALSE
NEQ      CMP.L   D2,D1
         BNE.S   TRUE
         BRA.S   FALSE
LT       CMP.L   D2,D1
         BLT.S   TRUE
         BRA.S   FALSE
GT       CMP.L   D2,D1
         BGT.S   TRUE
         BRA.S   FALSE
LE       CMP.L   D2,D1
         BLE.S   TRUE
         BRA.S   FALSE
GE       CMP.L   D2,D1
         BGE.S   TRUE
         BRA.S   FALSE
PLUS     ADD.L   D2,D1
         RTS
MINUS    SUB.L   D2,D1
         RTS
OR       OR.L    D2,D1
         RTS
XOR      EOR.L   D2,D1
         RTS
AND      AND.L   D2,D1
         RTS
NOT      BSR     PUSH1
         MOVE.L  D2,D1
         NOT.L   D1
         RTS
MULT     CLR.B   D6
         TST.L   D1
         BPL.S   .0
         NEG.L   D1
         NOT.B   D6
.0       TST.L   D2
         BPL.S   .1
         NEG.L   D2
         NOT.B   D6
.1       CLR.L   D3
         MOVEQ   #32-1,D4
.2       MOVE.B  D1,D0
         LSR.B   #1,D0
         BCC.S   .3
         ADD.L   D2,D3
.3       ROXR.L  #1,D3
         ROXR.L  #1,D1
         DBRA    D4,.2
         TST.B   D6
         BEQ.S   .4
         NEG.L   D1
.4       RTS
DIV      CLR.B   D6
         CLR.B   D7
         TST.L   D1
         BPL.S   .0
         NEG.L   D1
         NOT.B   D6
         NOT.B   D7
.0       TST.L   D2
         BEQ     ERBE
         BPL.S   .1
         NEG.L   D2
         NOT.B   D6
.1       CLR.L   D3
         MOVEQ   #32-1,D4
.2       LSL.L   #1,D1
         ROXL.L  #1,D3
         CMP.L   D2,D3
         BLO.S   .3
         SUB.L   D2,D3
         ADDQ.L  #1,D1
.3       DBRA    D4,.2
         TST.B   D6
         BEQ.S   .4
         NEG.L   D1
.4       TST.B   D7
         BEQ.S   .5
         NEG.L   D3
.5       RTS
MOD      BSR     DIV
         MOVE.L  D3,D1
         RTS
*------------------------------
ERBE     MOVEQ   #QBDEXP,D7
         BRA     SOFTERR
RDATOM   TST.B   LAST(A5)
         BEQ.S   .4
         BSR     GNC.UC     ;OPERATOR
         BCS.S   .3
         CMP.B   #',,D0
         BEQ.S   .2
         CMP.B   #'(,D0
         BEQ.S   .2
         CMP.B   #' ,D0
         BEQ.S   .2
         BSR     SRCHAT
         BCC.S   ERBE
         CMP.B   #7,D1      ;.NOT.
         BEQ.S   ERBE
         CMP.B   #8,D1      ;")"
         BEQ.S   .1
.0       CLR.B   LAST(A5)
.1       ANDI    #$FE,CCR
         RTS
.2       BSR     BACKCHR
.3       MOVE.W  #$1209,D1
         BRA.S   .0
.4       BSR     GNC.UC     ;OPERAND
         BCS.S   ERBE
         CMP.B   #'+,D0
         BEQ.S   .6
         CMP.B   #'-,D0
         BEQ.S   .5
         CMP.B   #'*,D0
         BEQ.S   .8
         BSR     SRCHAT
         BCC.S   .6
         CMP.B   #1,D1      ;"("
         BEQ.S   .1
         CMP.B   #7,D1      ;.NOT.
         BEQ.S   .1
         BRA.S   ERBE
.5       BSR     GETARG
         NEG.L   D1
         BRA.S   .7
.8       BSR     BACKCHR
.6       BSR     GETARG
.7       MOVE.B  #1,LAST(A5)
         ORI     #1,CCR
         RTS
*------------------------------
GETARG   CLR.L   D1
         BSR     GNC.UC
         BCS.S   .3
         CMP.B   #'0,D0
         BLO.S   .2
         CMP.B   #'@,D0
         BEQ.S   .5
         CMP.B   #'9,D0
         BHI     .12
         BSR     DECN
.0       BSR     BACKCHR
.1       RTS
.2       CMP.B   #'.,D0
         BEQ.S   .12
         CMP.B   #'%,D0
         BEQ.S   .4
         CMP.B   #'$,D0
         BEQ.S   .6
         CMP.B   #'',D0
         BEQ.S   .9
         CMP.B   #'",D0
         BEQ.S   .11
         CMP.B   #'*,D0
         BEQ.S   .10
.3       BRA     ERBE
.4       MOVEQ   #1,D2
         MOVEQ   #1,D3
         BRA.S   .7
.5       MOVEQ   #7,D2
         MOVEQ   #3,D3
         BRA.S   .7
.6       MOVEQ   #15,D2
         MOVEQ   #4,D3
.7       BSR     GETDGT
         BCS.S   .3
.8       BSR     GETDGT
         BCC.S   .8
         BRA.S   .0
.9       BSR     GNC
;        BCS.S   .3
         MOVE.B  D0,D1
         BSR     GNC
         CMP.B   #'',D0
         BEQ.S   .1
         BRA.S   .0
.10      MOVE.L  ORGN(A5),D1
         BRA.S   .1
.11      BSR     GNC
;        BCS.S   .3
         EOR.B   #$80,D0
         MOVE.B  D0,D1
         BSR     GNC
         CMP.B   #'",D0
         BEQ.S   .1
         BRA.S   .0
.12      BSR     PACK
         BEQ.S   .3
         TST.B   F.SYMTB(A5)
         BEQ.S   .13
         BSR     STSRCH
         BCC.S   .14
.13      MOVE.B  #1,EXPUDF(A5)
         CLR.B   EXPFWD(A5)
         CLR.L   D1
         BRA     .1
.14      MOVE.B  SYMBOL+11(A5),D0
         BSR     CHL
         BCC.S   .15
         BTST    #4,(A2)
         BNE.S   .13
.15      MOVE.B  (A2),D0
         AND.B   D0,EXPFWD(A5)
         BRA     .1
GETDGT   BSR     GNC.UC
         EOR.B   #$30,D0
         CMP.B   #10,D0
         BLO.S   .0
         ADD.B   #$89,D0
         CMP.B   #$FA,D0
         BLO.S   .1
         AND.B   #$F,D0
.0       CMP.B   D0,D2
         BLO.S   .1
         LSL.L   D3,D1
         OR.B    D0,D1
.1       RTS
*------------------------------
SRCHAT   BSR     BACKCHR
         LEA     PRIOR(PC),A1
SRCHDIR  MOVE.W  CHRPTR(A5),D1
.0       CLR.W   D6
         MOVE.B  (A1)+,D6
         BEQ.S   .4
.1       BSR     GNC.UC
         CMP.B   (A1)+,D0
         BNE.S   .3
         SUBQ.W  #1,D6
         BNE.S   .1
         MOVE.B  (A1)+,D1
         LSL.W   #8,D1
         MOVE.B  (A1)+,D1
         ORI     #1,CCR
         RTS
.3       ADD.W   D6,A1
         ADDQ.L  #1,A1
         MOVE.W  D1,CHRPTR(A5)
         BRA.S   .0
.4       ANDI    #$FE,CCR
         RTS
*------------------------------
PRIOR    STR     "("    ; Length + String
         DATA    #1,#1  ; No, Prior.
         HEX     01B2   ;<=
         DATA    #6,#2
         STR     "<="
         DATA    #6,#2
         STR     "=<"
         DATA    #6,#2
         STR     ".LE."
         DATA    #6,#2
         HEX     01B3   ;>=
         DATA    #7,#2
         STR     ">="
         DATA    #7,#2
         STR     "=>"
         DATA    #7,#2
         STR     ".GE."
         DATA    #7,#2
         STR     "="
         DATA    #2,#2
         STR     ".EQU."
         DATA    #2,#2
         HEX     01AD   ;<>
         DATA    #3,#2
         STR     "<>"
         DATA    #3,#2
         STR     "><"
         DATA    #3,#2
         STR     ".NEQ."
         DATA    #3,#2
         STR     "<"
         DATA    #4,#2
         STR     ".LT."
         DATA    #4,#2
         STR     ">"
         DATA    #5,#2
         STR     ".GT."
         DATA    #5,#2
         STR     "+"
         DATA    #8,#3
         STR     ".ADD."
         DATA    #8,#3
         STR     "-"
         DATA    #9,#3
         STR     ".SUB."
         DATA    #9,#3
         STR     "*"
         DATA    #10,#4
         STR     ".MULT."
         DATA    #10,#4
         STR     "/"
         DATA    #11,#4
         STR     ".DIV."
         DATA    #11,#4
         STR     ".MOD."
         DATA    #12,#4
         STR     "!"
         DATA    #13,#5
         STR     ".OR."
         DATA    #13,#5
         STR     ".XOR."
         DATA    #14,#5
         STR     ".EOR."
         DATA    #14,#5
         STR     "&"
         DATA    #15,#6
         STR     ".AND."
         DATA    #15,#6
         STR     ".NOT."
         DATA    #16,#7
         STR     ")"
         DATA    #17,#8
         HEX     00
         ADJST
*------------------------------
