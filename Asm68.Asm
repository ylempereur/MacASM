;SAVE"Asm68.asm"
*------------------------------
ASM68    MOVE.L  A1,OPTPTR(A5)
         MOVE.W  CHRPTR(A5),SVCHPTR(A5)
         MOVE.L  ORGN(A5),D0
         BTST    #0,D0
         BEQ.S   COPS
         MOVEQ   #0,D0
         BSR     EMIT
         MOVEQ   #QERWORD,D7
         BRA     SOFTERR
COPS     MOVE.W  SVCHPTR(A5),CHRPTR(A5)
         CLR.B   EXTSZ(A5)
         CLR.B   EXTSZSRC(A5)
         CLR.B   UNDFL(A5)
         CLR.B   RAERFL(A5)
         MOVE.L  OPTPTR(A5),A1
         MOVE.B  4(A1),FLAG1(A5)
         MOVE.B  5(A1),FLAG2(A5)
         MOVE.B  6(A1),FLAG3(A5)
         LEA     ADRTBL(PC),A0
         CLR.W   D0
         MOVE.B  2(A1),D0
         LSL.W   #1,D0
         MOVE.W  0(A0,D0.W),SAM(A5)
         CLR.W   D0
         MOVE.B  3(A1),D0
         LSL.W   #1,D0
         MOVE.W  0(A0,D0.W),DAM(A5)
         MOVE.B  (A1),OPCODE(A5)
         MOVE.B  1(A1),OPCODE+1(A5)
*------------------------------
         MOVE.B  FLAG3(A5),D0
         AND.B   #$07,D0         Special Handling?
         BNE     SPECIAL
         MOVE.B  FLAG3(A5),D0
         AND.B   #$60,D0         Conditional?
         BEQ.S   OPNCOND
         LEA     COND.14(PC),A1
         AND.B   #$40,D0         14 or 16?
         BNE.S   .0
         LEA     COND.16(PC),A1
.0       BSR     SCOND
         MOVE.B  2(A1),D0
         OR.B    D0,OPCODE(A5)
*------------------------------
OPNCOND  MOVE.B  #1,SIZE(A5)
         MOVE.B  FLAG1(A5),D0
         AND.B   #$03,D0
         CMP.B   #2,D0
         BNE.S   .1
         CLR.B   SIZE(A5)
.1       BTST    #6,FLAG2(A5)
         BEQ.S   .6
         BSR     GNC
         BNE.S   .2
         BSR     BACKCHR
         BRA.S   .6
.2       CMP.B   #'.,D0
         BNE     NEXT
         BSR     GNC.UC
         CMP.B   #'W,D0
         BNE.S   .3
         MOVE.B  #1,SIZE(A5)
         BTST    #0,FLAG1(A5)
         BEQ     NEXT
         BRA.S   .6
.3       CMP.B   #'L,D0
         BNE.S   .4
         MOVE.B  #2,SIZE(A5)
         BTST    #7,FLAG2(A5)
         BEQ     NEXT
         BRA.S   .6
.4       CMP.B   #'B,D0
         BEQ.S   .5
         CMP.B   #'S,D0
         BNE     NEXT
.5       CLR.B   SIZE(A5)
         BTST    #1,FLAG1(A5)
         BEQ     NEXT
.6       BSR     GNC
         CMP.B   #'.,D0
         BEQ     NEXT
         BSR     BACKCHR
         BSR     GNNB
         BSR     BACKCHR
         TST.W   SAM(A5)
         BEQ     DONE
         BSR     GETADDR
         MOVE.W  TYPE(A5),D0
         AND.W   SAM(A5),D0
         BEQ     NEXT
         MOVE.B  EXPUDF(A5),UNDFL(A5)
*------------------------------
OPDOSRC  CMP.W   #$0400,TYPE(A5)
         BNE.S   .0
         TST.B   SIZE(A5)
         BEQ     NEXT
.0       CMP.W   #$0001,TYPE(A5)
         BNE.S   .2
         BTST    #1,FLAG2(A5)  Data 3?
         BEQ.S   .1
         MOVE.L  DISP(A5),D0
         BEQ     NEXT
         CMP.L   #9,D0
         BHS     NEXT
         AND.B   #$07,D0
         LSL.B   #1,D0
         OR.B    D0,OPCODE(A5)
         CLR.B   EXTSZ(A5)
         BRA.S   .2
.1       CMP.B   #$02,SIZE(A5)
         BEQ.S   .2
         MOVE.B  #2,EXTSZ(A5)
         TST.B   SIZE(A5)
         BNE.S   .2
         CLR.B   DISP+2(A5)
.2       BTST    #2,FLAG1(A5)  Size in 6-7?
         BEQ.S   .3
         MOVE.B  SIZE(A5),D0
         ROR.B   #2,D0
         OR.B    D0,OPCODE+1(A5)
.3       BTST    #2,FLAG2(A5)  W/L in bit 8?
         BEQ.S   .4
         MOVE.B  SIZE(A5),D0
         LSR.B   #1,D0
         OR.B    D0,OPCODE(A5)
.4       BTST    #3,FLAG3(A5)  Size in 12-13?
         BEQ.S   .5
         CLR.W   D0
         MOVE.B  SIZE(A5),D0
         LEA     SIZETBL(PC),A0
         MOVE.B  0(A0,D0.W),D0
         OR.B    D0,OPCODE(A5)
.5       BTST    #5,FLAG1(A5)  S Reg 0-2?
         BEQ.S   .6
         MOVE.B  MODEREG(A5),D0
         AND.B   #$07,D0
         OR.B    D0,OPCODE+1(A5)
.6       BTST    #4,FLAG1(A5)  S Mode 3-5?
         BEQ.S   .7
         MOVE.B  MODEREG(A5),D0
         AND.B   #$38,D0
         OR.B    D0,OPCODE+1(A5)
.7       BTST    #3,FLAG2(A5)  S Reg 9-11?
         BEQ.S   RELSRC
         MOVE.B  MODEREG(A5),D0
         AND.B   #$07,D0
         LSL.B   #1,D0
         OR.B    D0,OPCODE(A5)
RELSRC   BTST    #0,FLAG2(A5)
         BEQ.S   .5
         MOVE.B  SIZE(A5),D0
         BEQ.S   .0
         MOVEQ   #2,D2
         CMP.B   #$02,D0
         BEQ.S   .1
         TST.B   EXPUDF(A5)
         BNE.S   .1
         TST.B   PASS(A5)
         BEQ.S   .0
         TST.B   EXPFWD(A5)
         BEQ.S   .1
.0       MOVEQ   #1,D2
.1       BSR     RELADR
         MOVEQ   #2,D1
         TST.B   SIZE(A5)
         BNE.S   .2
         TST.B   PASS(A5)
         BEQ.S   .3
         CMP.B   #1,D2
         BEQ.S   .3
         BSR     RAERS
         BRA.S   .3
.2       CMP.B   #1,D2
         BNE.S   .4
.3       MOVEQ   #0,D1
         MOVE.B  DISP+3(A5),OPCODE+1(A5)
.4       MOVE.B  D1,EXTSZ(A5)
.5       MOVE.B  EXTSZ(A5),EXTSZSRC(A5)
         MOVE.L  DISP(A5),EXTSAVE(A5)
OPDODEST CLR.B   EXTSZ(A5)
         TST.W   DAM(A5)
         BEQ     DONE
         BSR     GNC
         CMP.B   #',',D0
         BNE     ERBA
         BSR     GETADDR
         MOVE.W  TYPE(A5),D0
         AND.W   DAM(A5),D0
         BEQ     NEXT
         MOVE.B  EXPUDF(A5),D0
         OR.B    D0,UNDFL(A5)
         CMP.W   #$0400,TYPE(A5)
         BNE.S   .0
         TST.B   SIZE(A5)
         BEQ     NEXT
.0       CMP.W   #$0001,TYPE(A5)
         BNE.S   .1
         MOVE.B  #2,EXTSZ(A5)
         MOVE.L  DISP(A5),D1
         BSR     ADDR16
         BCC.S   .1
         BSR     RAERS
.1       BTST    #3,FLAG1(A5)  D Reg 9-11?
         BEQ.S   .2
         MOVE.B  MODEREG(A5),D0
         AND.B   #$07,D0
         LSL.B   #1,D0
         OR.B    D0,OPCODE(A5)
.2       BTST    #5,FLAG2(A5)  D Reg 0-2?
         BEQ.S   .3
         MOVE.B  MODEREG(A5),D0
         AND.B   #$07,D0
         OR.B    D0,OPCODE+1(A5)
.3       BTST    #4,FLAG2(A5)  D Mode 3-5?
         BEQ.S   .4
         MOVE.B  MODEREG(A5),D0
         AND.B   #$38,D0
         OR.B    D0,OPCODE+1(A5)
.4       BTST    #4,FLAG3(A5)  D Mode 6-8?
         BEQ.S   .5
         MOVE.B  MODEREG(A5),D0
         AND.W   #$0038,D0
         LSL.W   #3,D0
         OR.W    D0,OPCODE(A5)
.5       BTST    #7,FLAG3(A5)  Rel. Dest?
         BEQ.S   DONE
         MOVEQ   #2,D2
         BSR     RELADR
         MOVE.B  #2,EXTSZ(A5)
DONE     MOVE.B  OPCODE(A5),D0
         BSR     EMIT
         MOVE.B  OPCODE+1(A5),D0
         BSR     EMIT
         MOVE.B  EXTSZSRC(A5),D0
         BEQ.S   DONE0
         CMP.B   #2,D0
         BEQ.S   .0
         MOVE.B  EXTSAVE(A5),D0
         BSR     EMIT
         MOVE.B  EXTSAVE+1(A5),D0
         BSR     EMIT
.0       MOVE.B  EXTSAVE+2(A5),D0
         BSR     EMIT
         MOVE.B  EXTSAVE+3(A5),D0
         BSR     EMIT
DONE0    MOVE.B  EXTSZ(A5),D0
         BEQ.S   .3
         CMP.B   #2,D0
         BEQ.S   .2
         MOVE.B  DISP(A5),D0
         BSR     EMIT
         MOVE.B  DISP+1(A5),D0
         BSR     EMIT
.2       MOVE.B  DISP+2(A5),D0
         BSR     EMIT
         MOVE.B  DISP+3(A5),D0
         BSR     EMIT
.3       TST.B   RAERFL(A5)
         BNE     RAER
         MOVE.B  UNDFL(A5),D0
         OR.B    D0,EXPUDF(A5)
         RTS
*------------------------------
NEXT     BTST    #7,FLAG1(A5)
         BEQ.S   ERBA
         MOVE.L  OPTPTR(A5),A1
         LEA     7(A1),A1
         BTST    #6,FLAG1(A5)
         BEQ.S   .1
         ADDQ.L  #1,A1
.0       MOVE.B  (A1)+,D0
         BMI.S   .1
         BNE.S   .0
.1       MOVE.L  A1,OPTPTR(A5)
         BRA     COPS
*------------------------------
ERBA     MOVEQ   #QER5,D7
         BRA     SOFTERR
*------------------------------
RELADR   SUBQ.L  #2,DISP(A5)
         TST.B   EXPUDF(A5)
         BNE.S   .1
         MOVE.L  ORGN(A5),D0
         SUB.L   D0,DISP(A5)
         MOVE.L  DISP(A5),D1
         BSR     ADDR16
         BCC.S   .0
         BSR     RAERS
.0       CMP.B   #1,D2
         BNE.S   .1
         TST.L   D1
         BEQ.S   .2
         BSR     ADDR8
         BCC.S   .1
.2       MOVEQ   #2,D2
.1       RTS
RAER     MOVEQ   #QER3,D7
         BRA     SOFTERR
*------------------------------
