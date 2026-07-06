;SAVE"Macro.asm"
*------------------------------
PSMACRO  TST.B   PASS(A5)
         BNE.S   .0
         BSR     GNCUCSTR
         BEQ.S   .1
         BSR     CHL
         BCC.S   .2
         MOVE.L  ADDLBL(A5),A2
         BSET    #4,(A2)
.0       MOVE.B  #1,F.MACRO(A5)
         RTS
.1       MOVEQ   #QNONAM,D7
         BRA.S   .3
.2       MOVEQ   #QER7,D7
.3       BRA     FIRMERR
PACKML   TST.B   F.MACRO(A5)
         BEQ     D.SET
         TST.B   PASS(A5)
         BNE.S   .9
         BSR     SCANOPC
         BCS.S   .3
         BSR     BACKCHR
         LEA     DIR.MA(PC),A1
         BSR     SCANFL
         BCC.S   .1
.0       MOVEQ   #QER2,D7
         BRA     SOFTERR
.1       BSR     SCANFL
         BCC.S   .2
         CLR.B   D0
         BSR     ADDSKEL
         BRA.S   .10
.2       BSR     SCANFL
         BCS.S   .0
.3       CLR.W   D7
.4       BSR     GNC2
         BCS.S   .8
         BNE.S   .7
         MOVE.B  #$E0,D6
.5       ADDQ.B  #1,D6
         CMP.B   #$FF,D6
         BHS.S   .6
         BSR     GNC2
         BCS.S   .6
         BEQ.S   .5
         SUBQ.W  #1,D7
.6       MOVE.B  D6,D0
.7       BSR     ADDSKEL
         BRA.S   .4
.8       CLR.B   D0
         BSR     ADDSKEL
         ORI     #1,CCR
         RTS
.9       BSR     SCANOPC
         BCS.S   .11
         BSR     BACKCHR
         LEA     DIR.EM(PC),A1
         BSR     SCANFL
         BCC.S   .11
.10      CLR.L   MJRLBL(A5)
         CLR.B   F.MACRO(A5)
.11      ORI     #1,CCR
         RTS
D.SET    BSR     SCANOPC
         BCS.S   .0
         BSR     BACKCHR
         LEA     DIR.SE(PC),A1
         BSR     SCANFL
         BCS.S   .1
.0       ANDI    #$FE,CCR
         RTS
.1       BSR     EXPR
         BNE     UNDF
         MOVE.L  D1,-(A7)
         BSR     GNCUCSTR
         BEQ     NOLBLERR
         BSR     CHL
         BCC     ERRBS
         BSR     PACK
         BEQ     ERRBS
         BSR     STSRCH
         BCC.S   .2
         BSR     STADD
         MOVE.L  ADDLBL(A5),A2
         BSET    #5,(A2)
         BRA.S   .3
.2       BTST    #5,(A2)
         BEQ     ERDBLDF
         TST.B   PASS(A5)
         BEQ.S   .3
         BSET    #7,(A2)
.3       TST.B   PASS(A5)
         BEQ.S   .4
         MOVE.L  (A7),D0
         BSR     PRTAX
.4       MOVE.L  (A7)+,4(A2)
         CLR.L   MJRLBL(A5)
         ORI     #1,CCR
         RTS
ADDSKEL  MOVE.L  EOT(A5),A0
         CMP.L   MACSTK(A5),A0
         BHS     MFER
         MOVE.B  D0,(A0)+
         MOVE.L  A0,EOT(A5)
         RTS
SCANOPC  BSR     GNCUCSTR
         BEQ.S   .1
         BSR     CHCC
         BEQ.S   .2
.0       BSR     GNC.UC
         BNE.S   .0
.1       BRA     GNNB
.2       ORI     #1,CCR
         RTS
GNSRCHR  TST.W   PARPTR(A5)
         BNE.S   .0
         TST.B   MACLVL(A5)
         BNE.S   .2
         BRA     NTKN
.0       MOVE.W  PARPTR(A5),D7
.1       ADDQ.W  #1,PARPTR(A5)
         MOVE.L  MACSTK(A5),A0
         MOVE.B  0(A0,D7.W),D0
         BNE.S   .6
         CLR.W   PARPTR(A5)
.2       BSR     NTKN
         BEQ.S   .6
         CMP.B   #'],D0
         BNE.S   .6
         BSR     NTKN
         CMP.B   #'#,D0
         BEQ.S   .8
         CMP.B   #'9+1,D0
         BHS.S   .7
         CMP.B   #'1,D0
         BLO.S   .7
         SUB.B   #'0,D0
         MOVE.B  D0,D1
         MOVE.L  MACSTK(A5),A0
         MOVEQ   #10,D7
.3       SUBQ.B  #1,D1
         BEQ.S   .5
.4       ADDQ.W  #1,D7
         MOVE.B  0(A0,D7.W),D0
         BNE.S   .4
         BRA.S   .3
.5       ADDQ.W  #1,D7
         MOVE.W  D7,PARPTR(A5)
         BRA.S   .1
.6       TST.B   D0
         RTS
.7       MOVEQ   #QERPARA,D7
         BRA     FIRMERR
.8       MOVE.L  MACSTK(A5),A0
         CLR.W   D7
         MOVE.B  10(A0),D7
         SUB.B   MACSTK+3(A5),D7
         SUBQ.B  #1,D7
         MOVEQ   #10,D1
.9       TST.B   0(A0,D7.W)
         BNE.S   .10
         SUBQ.B  #1,D1
         SUBQ.W  #1,D7
         CMP.W   #11,D7
         BHS.S   .9
         CLR.B   D1
.10      MOVE.B  D1,D0
         OR.B    #$30,D0
         BRA.S   .6
MACER1   MOVEQ   #QNONAM,D7
         BRA     SOFTERR
MACER2   MOVEQ   #QERRMAC,D7
         BRA     SOFTERR
MACER3   MOVE.W  D2,CHRPTR(A5)
         RTS
MACALL   MOVE.W  CHRPTR(A5),D2
         BSR     GNC.UC
         BSR     CHL
         BCC     MACER3
         BSR     PACK
         BEQ.S   MACER1
         BSR     STSRCH
         BCS.S   MACER3
         BTST    #4,(A2)
         BEQ.S   MACER3
         CMP.B   #$FF,MACLVL(A5)
         BEQ     .5
         MOVE.L  A2,-(A7)
         BSR     GNNB
         BSR     BACKCHR
         MOVE.L  MACSTK(A5),-(A7)
         CLR.L   D6
         MOVE.B  #9,PARCNT(A5)
.1       BSR     GET1PAR
         SUBQ.B  #1,PARCNT(A5)
         BNE.S   .1
         MOVE.W  D6,-(A7)
         BSR     PRTLOC
         BSR     LSTSRCIL
         MOVE.W  (A7)+,D6
         LEA     INBUF(A5),A1
.2       MOVE.B  -1(A1,D6.W),D0
         BSR     PSHMSTK
         SUBQ.W  #1,D6
         BNE.S   .2
         MOVE.L  (A7)+,D0
         BSR.S   .3
         MOVE.L  SRCP(A5),D0
         BSR.S   .3
         MOVE.B  F.LIST(A5),D0
         BSR     PSHMSTK
         MOVE.B  CALNUM+1(A5),D0
         BSR     PSHMSTK
         MOVE.B  CALNUM(A5),D0
         BSR     PSHMSTK
         MOVE.L  (A7)+,A2
         CLR.L   D7
         MOVE.B  10(A2),D7
         LEA     11(A2,D7.W),A0
         MOVE.L  A0,SRCP(A5)
         MOVE.B  F.MLIST(A5),D0
         OR.B    D0,F.LIST(A5)
         ADDQ.B  #1,MACLVL(A5)
         ADDQ.W  #1,CALCNT(A5)
         MOVE.W  CALCNT(A5),CALNUM(A5)
         BRA     ASM2
.3       MOVEQ   #4-1,D1
.4       BSR     PSHMSTK
         LSR.L   #8,D0
         DBRA    D1,.4
         RTS
.5       MOVEQ   #QMACLVL,D7
         BRA     SOFTERR
PSHMSTK  MOVE.L  MACSTK(A5),A0
         CMP.L   EOT(A5),A0
         BLS     MFER
         MOVE.B  D0,-(A0)
         MOVE.L  A0,MACSTK(A5)
         RTS
GET1PAR  BSR     GNC
         BEQ.S   .2
         CMP.B   #',',D0
         BEQ.S   .3
         CMP.B   #'"',D0
         BEQ.S   .4
.1       BSR.S   .7
         BSR     GNC
         BEQ.S   .2
         CMP.B   #',',D0
         BNE.S   .1
         BRA.S   .3
.2       BSR     BACKCHR
.3       CLR.B   D0
         BSR.S   .7
         RTS
.4       BSR     GNC
         BCS.S   .3
         CMP.B   #'"',D0
         BEQ.S   .6
.5       BSR.S   .7
         BRA.S   .4
.6       BSR     GNC
         BEQ.S   .2
         CMP.B   #',',D0
         BEQ.S   .3
         BRA.S   .5
.7       MOVE.B  D0,0(A0,D6.W)
         ADDQ.W  #1,D6
         CMP.W   #128,D6
         BHS.S   .8
         RTS
.8       MOVEQ   #QERPARA,D7
         BRA     SOFTERR
SETUPNL  TST.B   MACLVL(A5)
         BEQ.S   .2
         MOVE.L  SRCP(A5),A0
         TST.B   (A0)
         BNE     .8
         MOVE.L  MACSTK(A5),A0
         MOVE.B  (A0)+,CALNUM(A5)
         MOVE.B  (A0)+,CALNUM+1(A5)
         MOVE.B  (A0)+,F.LIST(A5)
         LEA     SRCP(A5),A1
         BSR.S   .0
         LEA     MACSTK(A5),A1
         BSR.S   .0
         SUBQ.B  #1,MACLVL(A5)
         BRA.S   SETUPNL
.0       MOVEQ   #4-1,D0
.1       MOVE.B  (A0)+,(A1)+
         DBRA    D0,.1
         RTS
.2       TST.B   F.INCL(A5)
         BEQ.S   .8
         BSR     DIN
         BNE.S   .3
         LEA     INCLBUF(A5),A1
         MOVE.L  A1,SRCP(A5)
         MOVE.B  D0,(A1)+
         CLR.L   D1
         MOVE.B  D0,D1
         SUBQ.L  #1,D1
         MOVE.W  INCL.IO(A5),D5
         BSR     READREC
         BRA.S   .8
.3       CMP.W   #-39,D7
         BNE     DOSERR
         BSR     RSTORE
.8       MOVE.L  SRCP(A5),A0
         MOVE.L  A0,SRCPSAV(A5)
         TST.B   MACLVL(A5)
         BNE.S   .9
         TST.B   F.INCL(A5)
         BNE.S   .4
         CMP.L   EOS(A5),A0
         BHS.S   .11
.4       BSR     GETLN
.9       LEA     INBUF(A5),A1
.10      BSR     GNSRCHR
         CMP.B   #$09,D0
         BNE.S   .12
         MOVEQ   #$20,D0
.12      MOVE.B  D0,(A1)+
         BNE.S   .10
         ANDI    #$FE,CCR
         RTS
.11      ORI     #1,CCR
         RTS
SCANFL   MOVE.W  CHRPTR(A5),D1
.0       CLR.W   D6
         MOVE.B  (A1)+,D6
.1       BSR     GNC.UC
         CMP.B   (A1)+,D0
         BNE.S   .2
         SUBQ.W  #1,D6
         BNE.S   .1
         ORI     #1,CCR
         RTS
.2       ADD.W   D6,A1
         SUBQ.L  #1,A1
         MOVE.W  D1,CHRPTR(A5)
         ANDI    #$FE,CCR
         RTS
DIR.DO   STR     "DO "
DIR.EL   STR     "ELSE "
DIR.FI   STR     "FIN "
DIR.MA   STR     "MACRO "
DIR.EM   STR     "ENDM "
DIR.IN   STR     "INCLUDE "
DIR.SE   STR     "SET "
         ADJST
