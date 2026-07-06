;SAVE"Getaddr.asm"
*------------------------------
* Address  Mode   Reg  Type
* USP      ?      ?    $4000
* SR       ?      ?    $2000
* CCR      ?      ?    $1000
* Dn       000    N    $0800
* An       001    N    $0400
* (An)     010    N    $0200
* (An)+    011    N    $0100
* -(An)    100    N    $0080
* d(An)    101    N    $0040
* d(An,Ri) 110    N    $0020
* Abs.W    111    000  $0010
* Abs.L    111    001  $0008
* d(PC)    111    010  $0004
* d(PC,Ri) 111    011  $0002
* #Value   111    100  $0001
*------------------------------
*  D0=0    A0=8     SP =15
*  D1=1    A1=9     CCR=16
*  D2=2    A2=10    SR =17
*  D3=3    A3=11    USP=18
*  D4=4    A4=12    PC =19
*  D5=5    A5=13
*  D6=6    A6=14
*  D7=7    A7=15
*------------------------------
GETADDR  CLR.W   TYPE(A5)
         CLR.B   MODEREG(A5)
         CLR.B   EXTSZ(A5)
         MOVE.W  CHRPTR(A5),D2
         BSR     GNC
         CMP.B   #'#,D0
         BEQ     IMED 
         CMP.B   #'-,D0
         BEQ     PREDEC
         CMP.B   #'>,D0
         BEQ     ABS.L
         CMP.B   #'<,D0
         BEQ     ABS.W
         CMP.B   #'(,D0
         BEQ     INDIRECT
         MOVE.W  D2,CHRPTR(A5)
         BSR     CHKREG
         BCC     NUMBER
         BSR     GNC.UC
         BSR     CHDDL
         BCS     NUMBER
REGIST   BSR     BACKCHR
         MOVE.B  D1,MODEREG(A5)
         CMP.B   #8,D1
         BHS.S   .0
         MOVE.W  #$0800,D0
         BRA.S   .4
.0       CMP.B   #16,D1
         BHS.S   .1
         MOVE.W  #$0400,D0
         BRA.S   .4
.1       CMP.B   #16,D1
         BNE.S   .2
         MOVE.W  #$1000,D0
         BRA.S   .4
.2       CMP.B   #17,D1
         BNE.S   .3
         MOVE.W  #$2000,D0
         BRA.S   .4
.3       CMP.B   #18,D1
         BNE     ERBA
         MOVE.W  #$4000,D0
.4       MOVE.W  D0,TYPE(A5)
         RTS
ABS.L    BSR     EXPR
         MOVE.L  D1,DISP(A5)
         MOVE.B  #4,EXTSZ(A5)
         MOVE.W  #$0008,TYPE(A5)
         MOVE.B  #$39,MODEREG(A5)
         RTS
ABS.W    BSR     EXPR
         MOVE.L  D1,DISP(A5)
         BSR     ADDR16
         BCC.S   .0
         BSR     RAERS
.0       MOVE.B  #2,EXTSZ(A5)
         MOVE.W  #$0010,TYPE(A5)
         MOVE.B  #$38,MODEREG(A5)
         RTS
IMED     BSR     EXPR
         MOVE.L  D1,DISP(A5)
         MOVE.B  #4,EXTSZ(A5)
         MOVE.W  #$0001,TYPE(A5)
         MOVE.B  #$3C,MODEREG(A5)
         RTS
PREDEC   BSR     GNC
         CMP.B   #'(,D0
         BNE     NUMBER
         BSR     CHKREG
         BCC     ERBA
         BCLR    #3,D1
         BEQ     ERBA
         OR.B    #$20,D1
         MOVE.B  D1,MODEREG(A5)
         BSR     GNC
         CMP.B   #'),D0
         BNE     ERBA
         MOVE.W  #$0080,TYPE(A5)
         RTS
INDIRECT BSR     CHKREG
         BCC     ERBA
         BTST    #3,D1
         BEQ     ERBA
         BSR     GNC
         CMP.B   #'),D0
         BNE     ERBA
         OR.B    #$18,D1
         MOVE.B  D1,MODEREG(A5)
         MOVE.W  #$0100,D1
         BSR     GNC
         CMP.B   #'+,D0
         BEQ.S   .0
         BSR     BACKCHR
         BCLR    #3,MODEREG(A5)
         MOVE.W  #$0200,D1
.0       MOVE.W  D1,TYPE(A5)
         RTS
NUMBER   MOVE.W  D2,CHRPTR(A5)
         BSR     EXPR
         MOVE.L  D1,DISP(A5)
         BSR     GNC
         CMP.B   #'(,D0
         BEQ.S   INDEXED
         BSR     BACKCHR
         MOVE.W  #$0008,TYPE(A5)
         MOVE.B  #$39,MODEREG(A5)
         MOVE.B  #4,EXTSZ(A5)
         TST.B   EXPUDF(A5)
         BNE.S   .1
         TST.B   PASS(A5)
         BEQ.S   .0
         TST.B   EXPFWD(A5)
         BEQ.S   .1
.0       BSR     ADDR16
         BCS.S   .1
         MOVE.W  #$0010,TYPE(A5)
         MOVE.B  #$38,MODEREG(A5)
         MOVE.B  #2,EXTSZ(A5)
.1       RTS
INDEXED  MOVE.B  #2,EXTSZ(A5)
         BSR     CHKREG
         BCC     ERBA
         CMP.B   #19,D1
         BEQ     PCREL
         BTST    #3,D1
         BEQ     ERBA
         OR.B    #$20,D1
         MOVE.B  D1,MODEREG(A5)
         MOVE.L  DISP(A5),D1
         BSR     ADDR16
         BCC.S   .0
         BSR     RAERS
.0       BSR     GNC
         CMP.B   #'),D0
         BNE.S   INDEX
         MOVE.W  #$0040,TYPE(A5)
         RTS
INDEX    CMP.B   #',',D0
         BNE     ERBA
         MOVE.B  MODEREG(A5),D0
         AND.B   #$F7,D0
         OR.B    #$10,D0
         MOVE.B  D0,MODEREG(A5)
         MOVE.W  #$0020,TYPE(A5)
IND0     MOVE.L  DISP(A5),D1
         BSR     ADDR8
         BCC.S   .2
         BSR     RAERS
.2       BSR     CHKREG
         BCC     ERBA
         CMP.B   #16,D1
         BHS     ERBA
         LSL.B   #4,D1
         MOVE.B  D1,DISP+2(A5)
         BSR     GNC
         CMP.B   #'.,D0
         BNE.S   .1
         BSR     GNC.UC
         CMP.B   #'W,D0
         BEQ.S   .0
         CMP.B   #'L,D0
         BNE     ERBA
         OR.B    #$08,DISP+2(A5)
.0       BSR     GNC
.1       CMP.B   #'),D0
         BNE     ERBA
         RTS
PCREL    SUBQ.L  #2,DISP(A5)
         TST.B   EXPUDF(A5)
         BNE.S   .0
         MOVE.L  ORGN(A5),D0
         SUB.L   D0,DISP(A5)
         MOVE.L  DISP(A5),D1
         BSR     ADDR16
         BCC.S   .0
         BSR     RAERS
.0       MOVE.B  #$3A,MODEREG(A5)
         BSR     GNC
         CMP.B   #'),D0
         BNE.S   .1
         MOVE.W  #$0004,TYPE(A5)
         RTS
.1       CMP.B   #',',D0
         BNE     ERBA
         MOVE.B  #$3B,MODEREG(A5)
         MOVE.W  #$0002,TYPE(A5)
         BRA     IND0
*------------------------------
ADDR16   CMP.L   #$00008000,D1
         BLO.S   .0
         CMP.L   #$FFFF8000,D1
         BLO.S   .1
.0       ANDI    #$FE,CCR
.1       RTS
*------------------------------
ADDR8    CMP.L   #$00000080,D1
         BLO.S   .0
         CMP.L   #$FFFFFF80,D1
         BLO.S   .1
.0       ANDI    #$FE,CCR
.1       RTS
*------------------------------
RAERS    ORI.B   #1,RAERFL(A5)
         CLR.L   DISP(A5)
         RTS
*------------------------------
