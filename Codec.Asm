;SAVE"Codec.asm"
*--------------------------------
* Decimal Printing
* D1 = Number
* D2 = Minimum Digit #
* D7 = Pointer to INBUF
*--------------------------------
DISNUM   MOVEQ   #1,D2
         BRA.S   CMMN
P4DNUM   MOVEQ   #4,D2
CMMN     MOVEQ   #1,D6
         BRA.S   CLN
CNVLP    MOVEQ   #1,D6
         BRA.S   CLN.0
CNVLNP   MOVEQ   #0,D6
CLN.0    MOVEQ   #5,D2
CLN      MOVEM.L D3-D5/A0-A1,-(A7)
         MOVE.L  D1,D3
         MOVEQ   #10,D5
         LEA     PLNTB(PC),A0
.0       MOVEQ   #'0,D0
.1       MOVE.L  D3,D4
         SUB.L   (A0),D4
         BCS.S   .2
         MOVE.L  D4,D3
         ADDQ.B  #1,D0
         BRA.S   .1
.2       CMP.B   #'0,D0
         BNE.S   .3
         CMP.B   D5,D2
         BLO.S   .5
.3       MOVEQ   #10,D2
         TST.B   D6
         BNE.S   .4
         LEA     INBUF(A5),A1
         MOVE.B  D0,0(A1,D7.W)
         ADDQ.W  #1,D7
         BRA.S   .5
.4       BSR     CHO
.5       ADDQ.L  #4,A0
         SUBQ.B  #1,D5
         BNE.S   .0
         MOVE.L  D3,D1
         MOVEM.L (A7)+,D3-D5/A0-A1
         RTS
PLNTB    DATA    1000000000
         DATA    100000000
         DATA    10000000
         DATA    1000000
         DATA    100000
         DATA    10000
         DATA    1000
         DATA    100
         DATA    10
         DATA    1
*--------------------------------
* Hexadecimal Printing
* D0 = Number
*--------------------------------
PRNT.L   MOVE.L  D0,-(A7)
         SWAP    D0
         BSR.S   PRNT.W
         MOVE.L  (A7)+,D0
         BRA.S   PRNT.W
PRNT.A   MOVE.L  D0,-(A7)
         SWAP    D0
         BSR.S   PRNT.B
         MOVE.L  (A7)+,D0
PRNT.W   MOVE.W  D0,-(A7)
         LSR.W   #8,D0
         BSR.S   PRNT.B
         MOVE.W  (A7)+,D0
PRNT.B   MOVE.B  D0,-(A7)
         LSR.B   #4,D0
         BSR.S   PRNT.D
         MOVE.B  (A7)+,D0
PRNT.D   ANDI.B  #$0F,D0
         ADDI.B  #'0,D0
         CMP.B   #'9+1,D0
         BLO.S   .0
         ADDI.B  #7,D0
.0       BRA     CHO
*--------------------------------
* Read ASCII Decimal -> Binary
* D1 = Number
* D2 = Digit Counter
*--------------------------------
DECN     BSR     BACKCHR
         CLR.L   D0
         CLR.L   D1
         CLR.L   D2
.1       BSR     GNC
         EOR.B   #$30,D0
         CMP.B   #10,D0
         BHS.S   .2
         ADD.L   D1,D1
         MOVE.L  D1,-(A7)
         LSL.L   #2,D1
         ADD.L   (A7)+,D1
         ADD.L   D0,D1
         ADDQ.L  #1,D2
         BRA.S   .1
.2       RTS
*--------------------------------
* Get 1 Parameter in INBUF and
* Put it in the Param. stack.
* D1 = Offset in Param. stack.
*--------------------------------
SCND     BSR     GNNB
         BCS.S   .0
         CMP.B   #',,D0
         BEQ.S   SCND
         EOR.B   #$30,D0
         CMP.B   #10,D0
         BHS.S   .0
         MOVE.W  D1,-(A7)
         BSR     DECN
         MOVE.W  D1,D0
         MOVE.W  (A7)+,D1
         LEA     PARAM0(A5),A0
         MOVE.W  D0,0(A0,D1.W)
         ADDQ.W  #2,D1
.0       BRA     BACKCHR
*--------------------------------
* Get RANGE
* SRCP = Start of block
* ENDP = End of block
*--------------------------------
RANGE    BSR     SETUP
         BSR     GNNBAUC
         BCS.S   .4
         BEQ.S   .1
         BSR.S   SCANLN
         BCS.S   .5
         MOVE.L  A1,SRCP(A5)
         BSR     GNNBAUC
         BCS.S   .2
         BEQ.S   .1
         CMP.B   #'!,D0
         BNE.S   .5
         BSR     GNC
         EOR.B   #$30,D0
         CMP.B   #10,D0
         BHS.S   .5
         BSR     DECN
         BSR     BACKCHR
         CMP.W   #2,D1
         BLO.S   .2
         SUBQ.W  #2,D1
         BSR     SERNXT
         BRA.S   .2
.1       BSR     GNNBAUC
         BCS.S   .3
         BEQ.S   .3
         BSR.S   SCANLN
         BCS.S   .5
.2       MOVE.L  A2,ENDP(A5)
.3       AND     #$FE,CCR
.4       RTS
.5       BRA     SYNX
SCANLN   CMP.B   #'#,D0
         BEQ.S   .1
         CMP.B   #'.,D0
         BEQ.S   .2
         CMP.B   #'*,D0
         BEQ.S   .0
         EOR.B   #$30,D0
         CMP.B   #10,D0
         BHS.S   .5
         BSR     DECN
         BSR     BACKCHR
         MOVE.W  D1,D0
         BRA.S   .3
.5       OR      #1,CCR
         RTS
.0       MOVE.W  #-2,D1
         BSR     SERTXT
         MOVE.L  A3,A1
         TST.W   D2
         BEQ.S   .6
         SUBQ.W  #1,D2
         BRA.S   .6
.1       MOVE.W  #0,D1
         BRA.S   .4
.2       MOVE.W  CURLNL(A5),D0
.3       MOVE.W  #-1,D1
.4       BSR     SERTXT
.6       BSR     GNC
         CMP.B   #'-,D0
         BEQ.S   .8
         CMP.B   #'+,D0
         BEQ.S   .8
         BSR     BACKCHR
.7       AND     #$FE,CCR
         RTS
.8       MOVE.B  D0,D5
         BSR     GNC
         EOR.B   #$30,D0
         CMP.B   #10,D0
         BLO.S   .9
         BSR     BACKCHR
         BRA.S   .5
.9       MOVE.W  D2,D6
         BSR     DECN
         BSR     BACKCHR
         CMP.B   #'+,D5
         BNE.S   .10
         TST.W   D1
         BEQ.S   .7
         SUBQ.W  #1,D1
         BSR     SERNXT
         BRA.S   .7
.10      SUB.W   D1,D6
         BCC.S   .11
         CLR.W   D6
.11      MOVE.W  D6,D1
         BSR     SERTXT
         BRA.S   .7
SETUP    MOVE.L  LOMEM(A5),SRCP(A5)
         MOVE.L  EOS(A5),ENDP(A5)
         RTS
GNNBAUC  BSR     GNNB
         BCS.S   .0
         CMP.B   #'A,D0
         BEQ.S   .0
         CMP.B   #'P,D0
         BEQ.S   .0
         CMP.B   #'U,D0
         BEQ.S   .0
         CMP.B   #',,D0
         AND     #$FE,CCR
         RTS
.0       BSR     BACKCHR
         OR      #1,CCR
         RTS
*--------------------------------
