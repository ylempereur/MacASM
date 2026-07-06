;SAVE"Symtbl.asm"
*------------------------------
STINIT   MOVE.L  EOS(A5),EOT(A5)
         MOVE.L  HIMEM(A5),A0
         ADDQ.L  #1,A0
         MOVE.L  A0,MACSTK(A5)
         CLR.L   MJRLBL(A5)
         LEA     HSHTBL(A5),A0
         MOVEQ   #28-1,D0
.0       CLR.L   (A0)+
         DBRA    D0,.0
         MOVE.B  #1,F.SYMTB(A5)
         RTS
*------------------------------
PACK     LEA     SYMBOL(A5),A1
         CLR     D6
         CMP.B   #'.,D0
         BEQ.S   PACKL
         CMP.B   #':,D0
         BEQ.S   PACKP
PACKN    BSR     CHL
         BCC.S   CPAK
.0       CMP     #32,D6
         BEQ.S   .1
         MOVE.B  D0,11(A1,D6)
         ADDQ    #1,D6
.1       BSR     GNC.UC
         BSR     CHDDL
         BCS.S   .0
CPAK     BSR     BACKCHR
         MOVE.B  D6,10(A1)
         RTS
PACKL    MOVE.B  D0,11(A1)
         BSR     GNC.UC
         BSR     CHD
         BCC.S   CPAK
         BSR     DECN
         CMP.L   #10000,D1
         BHS.S   CPAK
         BSET    #14,D1
         MOVE    D1,12(A1)
         MOVEQ   #3,D6
         BRA.S   CPAK
PACKP    MOVE.B  D0,11(A1)
         BSR     GNC.UC
         BSR     CHD
         BCC.S   CPAK
         BSR     DECN
         CMP.L   #100,D1
         BHS.S   CPAK
         MOVE.B  D1,12(A1)
         MOVE.B  CALNUM(A5),13(A1)
         MOVE.B  CALNUM+1(A5),14(A1)
         MOVEQ   #4,D6
         BRA.S   CPAK
*------------------------------
STSRCH   LEA     SYMBOL(A5),A1
         CLR     D0
         MOVE.B  11(A1),D0
         CMP.B   #'.,D0
         BEQ.S   STLOC
         CMP.B   #':,D0
         BNE.S   .0
         MOVEQ   #'Z+1,D0
.0       SUB     #$40,D0
         LSL     #2,D0
         LEA     HSHTBL(A5),A2
         LEA     0(A2,D0),A2
STSRCH1  MOVE.L  (A2),D0
         AND.L   #$00FFFFFF,D0
         BEQ.S   STS3
         MOVE.L  D0,A3
         MOVE.B  10(A1),D6
         CMP.B   10(A3),D6
         BLO.S   .0
         MOVE.B  10(A3),D6
.0       CLR     D7
.1       MOVE.B  11(A3,D7),D0
         CMP.B   11(A1,D7),D0
         BLO.S   STS2
         BNE.S   STS3
         SUBQ.B  #1,D6
         BEQ.S   STS4
         ADDQ    #1,D7
         BRA.S   .1
STS2     MOVE.L  A3,A2
         BRA.S   STSRCH1
STS3     ORI     #1,CCR
         RTS
STS4     MOVE.B  10(A3),D0
         CMP.B   10(A1),D0
         BEQ.S   STS5
         BHS.S   STS3
         BRA.S   STS2
STS5     MOVE.L  4(A3),D1
         MOVE.L  A3,A2
         ANDI    #$FE,CCR
         RTS
STLOC    MOVE.L  MJRLBL(A5),D0
         BEQ.S   .2
         MOVE.L  D0,A2
         BTST    #6,(A2)
         BEQ.S   STS3
         MOVEQ   #4,D7
         ADD     8(A2),D7
.0       MOVE    0(A2,D7.L),D0
         AND     #$7FFF,D0
         CMP     12(A1),D0
         BEQ.S   .1
         CLR.L   D0
         MOVE    4(A2,D7.L),D0
         BEQ.S   STS3
         ADD.L   D0,D7
         BRA.S   .0
.1       CLR.L   D1
         MOVE    2(A2,D7.L),D1
         ADD.L   4(A2),D1
         LEA     0(A2,D7.L),A2
         ANDI    #$FE,CCR
         RTS
.2       MOVEQ   #QER9,D7
         BRA     SOFTERR
*------------------------------
STADD    BTST    #0,EOT+3(A5)
         BEQ.S   .0
         ADDQ.L  #1,EOT(A5)
.0       LEA     SYMBOL(A5),A1
         CMP.B   #'.,11(A1)
         BEQ.S   .5
         MOVE.L  (A2),(A1)
         CLR.B   (A1)
         MOVE.L  EOT(A5),D0
         MOVE.B  (A2),-(SP)
         MOVE.L  D0,(A2)
         MOVE.B  (SP)+,(A2)
         CMP.B   #':,11(A1)
         BEQ.S   .1
         CMP.B   #'@,11(A1)
         BEQ.S   .1
         MOVE.L  D0,MJRLBL(A5)
.1       MOVE.L  ORGN(A5),4(A1)
         CLR     8(A1)
         MOVEQ   #11,D0
         ADD.B   10(A1),D0
.2       MOVE.L  EOT(A5),A3
         LEA     0(A3,D0),A0
         CMP.L   MACSTK(A5),A0
         BHS     MFER
         MOVE.L  A0,EOT(A5)
         MOVE.L  A3,ADDLBL(A5)
         BRA.S   .4
.3       MOVE.B  (A1)+,(A3)+
.4       DBRA    D0,.3
         RTS
.5       BSET    #6,(A2)
         BNE.S   .6
         MOVEQ   #4,D7
.6       MOVE    12(A1),(A1)
         MOVE.L  ORGN(A5),D0
         SUB.L   4(A2),D0
         CMP.L   #$10000,D0
         BHS     GT65535ERR
         MOVE    D0,2(A1)
         CLR     4(A1)
         MOVEQ   #6,D0
         MOVE.L  EOT(A5),A3
         LEA     0(A3,D0),A0
         CMP.L   MACSTK(A5),A0
         BHS     MFER
         LEA     0(A2,D7.L),A0
         SUB.L   A0,A3
         CMP.L   #$10000,A3
         BHS     GT65535ERR
         MOVE    A3,4(A0)
         BRA.S   .2
*------------------------------
SETLBL   TST.B   F.SYMTB(A5)
         BNE.S   .0
         BSR     STINIT
.0       MOVE    CHRPTR(A5),-(SP)
         BSR     GNNB
         BSR     CHL
         BCC     ERRBS
         BSR     PACK
         BEQ     ERRBS
         BSR     GNC
         CMP.B   #'=,D0
         BNE     SYNX
         BSR     EXPDFND
         MOVE    (SP)+,CHRPTR(A5)
         MOVE.L  D1,-(SP)
         BSR     GNNB
         BSR     PACK
         BSR     STSRCH
         BCC     ERDBLDF
         BSR     STADD
         MOVE.L  (SP)+,D1
         MOVE.L  ADDLBL(A5),A2
         CMP.B   #'.,SYMBOL+11(A5)
         BEQ.S   .1
         MOVE.L  D1,ORGN(A5)
         MOVE.L  D1,4(A2)
         RTS
.1       MOVE.L  MJRLBL(A5),A3
         SUB.L   4(A3),D1
         CMP.L   #$10000,D1
         BHS     GT65535ERR
         MOVE    D1,2(A2)
         RTS
*------------------------------
SYMB     MOVEQ   #QST,D7
         BSR     QTO
         BSR     CRLF
         TST.B   F.SYMTB(A5)
         BNE.S   STPRNT
         BSR     STINIT
*------------------------------
STPRNT   CLR     D7
.1       MOVE    D7,PNTR(A5)
         LEA     HSHTBL(A5),A2
         LEA     4(A2,D7),A2
.2       MOVE.L  (A2),D0
         AND.L   #$00FFFFFF,D0
         BEQ.S   .5
         MOVE.L  D0,A2
         BTST    #4,(A2)
         BNE.S   .2
         MOVE.L  4(A2),D0
         BSR     PRTAX
         BSR     SPC
         MOVE.B  10(A2),D6
         CLR     D7
.3       MOVE.B  11(A2,D7),D0
         BSR     CHO
         ADDQ    #1,D7
         SUBQ.B  #1,D6
         BNE.S   .3
         BTST    #6,(A2)
         BNE.S   .6
.4       BSR     CRLFWP
         BRA.S   .2
.5       MOVE    PNTR(A5),D7
         ADDQ    #4,D7
         CMP     #26*4,D7
         BLO.S   .1
         RTS
.6       MOVEQ   #4,D7
         ADD     8(A2),D7
.7       MOVEQ   #1,D6
.8       MOVE    0(A2,D7.L),D1
         AND.L   #$3FFF,D1
         SUBQ.B  #1,D6
         BEQ.S   .9
         MOVEQ   #',,D0
         BSR     CHO
         BRA.S   .10
.9       BSR     CRLFWP
         MOVEQ   #5,D6
.10      MOVEQ   #'.,D0
         BSR     CHO
         MOVE.B  D6,-(SP)
         BSR     P4DNUM
         MOVE.B  (SP)+,D6
         MOVEQ   #'=,D0
         BSR     CHO
         CLR.L   D0
         MOVE    2(A2,D7.L),D0
         ADD.L   4(A2),D0
         BSR     PRNT.L
         CLR.L   D0
         MOVE    4(A2,D7.L),D0
         BEQ.S   .4
         ADD.L   D0,D7
         BRA.S   .8
*------------------------------
SERNCHK  SUBQ.L  #4,A7
         MOVE.L  #$59564553,-(SP)
         MOVE    #0,-(SP)
         TBX     GetResource
         MOVE    resErr,D7
         BNE     SYSERR
         MOVE.L  (SP)+,A0
         LEA     HSERN(PC),A1
         MOVE.L  A0,(A1)
         MOVE.L  (A0),A0
         MOVEQ   #5-1,D1
         MOVEQ   #-1,D0
.0       ADD.B   (A0)+,D0
         ROL.B   #1,D0
         DBRA    D1,.0
         CMP.B   (A0),D0
         BNE     SYSERR
         RTS
*--------------------------------
