;SAVE"Outrout.asm"
*--------------------------------
DOSERR   MOVEQ   #QD33-33,D0
         SUB.W   D7,D0
         MOVE.W  D0,D7
         CMP.W   #QD33,D7
         BLO.S   .0
         CMP.W   #QD61,D7
         BLS.S   HARDERR
.0       MOVEQ   #QDOSERR,D7
HARDERR  MOVE.W  D7,-(A7)
         BSR     CLOSFILE
         MOVE.W  (A7)+,D7
.0       BSR     PRTERRM
         BRA     SOFT
FIRMERR  MOVEQ   #1,D0
         BRA.S   FISO
SOFTERR  CLR.L   D0
FISO     MOVE.B  D0,F.ERR(A5)
         TST.B   PASS(A5)
         BMI.S   HARDERR
         BSR     PRTERRM
         ADDQ.W  #1,ERRCNT(A5)
         BSR     LSTSRC1
         BSR     CRLF
         TST.B   F.ERR(A5)
         BEQ     ASM2
         BRA     SOFT
*--------------------------------
* Print Character
*--------------------------------
SPC      MOVEQ   #$20,D0
CHO      MOVEM.L D0-D3/D5/A0-A4,-(A7)
         TST.B   F.TEXT(A5)
         BNE.S   .1
         BSR     COUT
         TST.B   PRTFL(A5)
         BEQ.S   .0
         BSR     PRTBYT
.0       MOVEM.L (A7)+,D0-D3/D5/A0-A4
         RTS
.1       MOVE.W  TEXT.IO(A5),D5
         BSR     DOUT
         BRA.S   .0
*--------------------------------
* Line Feed with Hold or Abort
*--------------------------------
CRLF     BSR.S   ABORT
         BCC.S   .1
         BEQ.S   .2
.0       BSR.S   ABORT
         BCC.S   .0
         BEQ.S   .2
.1       MOVEQ   #$0D,D0
         BRA.S   CHO
.2       BRA     SOFT
*--------------------------------
* Read Key without case
*--------------------------------
RDKEY    BSR.S   ABORT
         BCC.S   RDKEY
         BRA     LCUC
*--------------------------------
* Check keyboard for Abort
* No Key   CC ??
*    Key   CS NE
* RETURN   CS EQ
*--------------------------------
ABORT    SUBQ.L  #2,A7
         MOVE.W  #$29,-(A7)
         PEA     EVNTRC(A5)
         TBX     GetNextEvent
         TST.B   (A7)+
         BEQ.S   .1
         MOVE.W  WHAT(A5),D0
         CMP.W   #3,D0
         BEQ.S   .0
         CMP.W   #5,D0
         AND     #$FE,CCR
         BNE.S   .1
.0       MOVE.L  MESS(A5),D0
         BSR     CMND
         CMP.B   #$0D,D0
         OR      #1,CCR
.1       RTS
*--------------------------------
* Print Error Message
*--------------------------------
PRTERRM  MOVE.W  D7,-(A7)
         MOVEQ   #QSTARS,D7
         BSR.S   QTO
         MOVE.W  (A7)+,D7
         BSR.S   QTO
         MOVEQ   #QERROR,D7
         BSR.S   QTO
         BRA.S   CRLF
*--------------------------------
* Print Message
* D7 = Message #
*--------------------------------
QTO      MOVE.L  A0,-(A7)
         LEA     QUOTES(PC),A0
.0       SUBQ.B  #1,D7
         BMI.S   .3
.1       TST.B   (A0)+
         BPL.S   .1
         BMI.S   .0
.2       BSR     CHO
.3       MOVE.B  (A0)+,D0
         BPL.S   .2
         AND.B   #$7F,D0
         BSR     CHO
         MOVE.L  (A7)+,A0
         RTS
*--------------------------------
* Display FILNAM
*--------------------------------
DISNAM   LEA     FILNAM(A5),A1
         CLR.W   D1
         MOVE.B  (A1)+,D1
         CMP.W   #32,D1
         BLS.S   .1
         MOVEQ   #32,D1
         BRA.S   .1
.0       MOVE.B  (A1)+,D0
         BSR     CHO
.1       DBRA    D1,.0
         RTS
*--------------------------------
HTAB     MOVEQ   #$20,D0
.0       BSR     CHO
         CMP.W   COLCRS(A5),D1
         BNE.S   .0
         RTS
*--------------------------------
DMES     MOVEQ   #3,D1
.0       ROL.L   #8,D0
         CMP.B   #$20,D0
         BHS.S   .1
         MOVE.B  #$20,D0
.1       BSR     CHO
         DBRA    D1,.0
         RTS
*--------------------------------
DLINE    MOVEQ   #75-1,D1
         MOVEQ   #$3D,D0
.0       BSR     CHO
         DBRA    D1,.0
         RTS
*--------------------------------
