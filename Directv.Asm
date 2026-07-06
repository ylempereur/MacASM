;SAVE"Directv.asm"
*------------------------------
ERSTF    MOVEQ   #QSYNX,D7
         BRA     FIRMERR
PSTF     BSR     TFEND
         MOVE.B  #1,F.TF(A5)
         ADDQ.B  #1,TF.CNT(A5)
         TST.B   PASS(A5)
         BEQ     ASM2
         BSR     GETNAM
         BCS.S   ERSTF
         BSR     DELTF
         BSR     CREATEF
         MOVE.L  #TYPBIN,32(A0)
         MOVE.L  #CREAT,36(A0)
         OST     SetFileInfo
         MOVE.W  16(A0),D7
         BNE     DOSERR
         BSR     SETPAR
         MOVE.B  #2,27(A0)
         MOVE.L  PATHBUF(A5),28(A0)
         OST     Open
         MOVE.W  24(A0),TF.IO(A5)
         MOVE.B  #1,F.TFIO(A5)
         MOVE.W  16(A0),D7
         BNE     DOSERR
TFHDR    MOVE.L  TRGT(A5),D1
         BSR.S   .0
         BSR     FORMTF
         BSR     STSRCH
.0       MOVE.W  TF.IO(A5),D5
         MOVEQ   #4-1,D2
.1       ROL.L   #8,D1
         MOVE.B  D1,D0
         BSR     DOUT
         DBRA    D2,.1
         RTS
FORMTF   LEA     SYMBOL(A5),A0
         MOVE.B  #'@,11(A0)
         MOVE.B  #'T,12(A0)
         MOVE.B  TF.CNT(A5),13(A0)
         MOVE.B  #3,10(A0)
         RTS
TFSYM    BSR     FORMTF
         BSR     STSRCH
         BSR     STADD
         MOVE.L  ADDLBL(A5),A0
         MOVE.L  TRGT(A5),4(A0)
         RTS
TFEND    TST.B   F.TF(A5)
         BEQ.S   .2
         TST.B   PASS(A5)
         BNE.S   .0
         BSR.S   TFSYM
         BRA.S   .1
.0       MOVE.W  TF.IO(A5),D5
         MOVEQ   #0,D0
         BSR     DOUT
         MOVE.W  TF.IO(A5),D0
         BSR     CLOSEF
         CLR.B   F.TFIO(A5)
.1       CLR.B   F.TF(A5)
.2       RTS
TFENX    TST.B   F.TF(A5)
         BEQ.S   .1
         TST.B   PASS(A5)
         BNE.S   .0
         BSR.S   TFSYM
         RTS
.0       MOVE.W  TF.IO(A5),D5
         MOVEQ   #0,D0
         BSR     DOUT
.1       RTS
TFENY    TST.B   F.TF(A5)
         BEQ.S   .0
         ADDQ.B  #1,TF.CNT(A5)
         TST.B   PASS(A5)
         BEQ.S   .0
         BSR     TFHDR
.0       RTS
*------------------------------
PSOR     BSR     EXPDFND
         MOVE.L  D1,ORGN(A5)
         BRA.S   TA1
PSTA     BSR     EXPDFND
TA1      MOVE.L  D1,-(A7)
         BSR     TFENX
         MOVE.L  (A7)+,TRGT(A5)
         BSR     TFENY
         RTS
*------------------------------
PSAT     MOVEQ   #$80,D1
         BRA.S   PSAST
PSAS     MOVEQ   #0,D1
PSAST    MOVE.B  D1,ATHIBIT(A5)
         MOVEQ   #0,D1
.1       MOVE.B  D1,ASHIBIT(A5)
.2       BSR     GNNB
         BCS.S   .6
         MOVEQ   #$80,D1
         CMP.B   #'-,D0
         BEQ.S   .1
         MOVE.B  D0,DLIM(A5)
         BSR     GNC.UC
         BCS.S   .6
         CMP.B   DLIM(A5),D0
         BEQ.S   .5
.3       BSR     GNC.UC
         BCS.S   .6
         CMP.B   DLIM(A5),D0
         BEQ.S   .4
         MOVE.B  -2(A0,D7.W),D0
         OR.B    ASHIBIT(A5),D0
         BSR     EMIT
         BRA.S   .3
.4       MOVE.B  -2(A0,D7.W),D0
         OR.B    ASHIBIT(A5),D0
         MOVE.B  ATHIBIT(A5),D1
         EOR.B   D1,D0
         BSR     EMIT
.5       RTS
.6       BRA     ERBA
*------------------------------
PSHS     BSR     GNNB
         BCS     ERBA
         BSR     BACKCHR
.0       MOVEQ   #15,D2
         MOVEQ   #4,D3
.1       BSR     GETDGT
         BCS.S   .2
         BSR     GETDGT
         BCS     ERBA
         MOVE.B  D1,D0
         BSR     EMIT
         BRA.S   .0
.2       MOVE.B  CURCHR(A5),D0
         BEQ.S   .3
         CMP.B   #'.,D0
         BEQ.S   .1
         CMP.B   #'_,D0
         BEQ.S   .1
         CMP.B   #' ,D0
         BNE     ERBA
.3       RTS
*------------------------------
GT65535ERR
         MOVEQ   #QER10,D7
         BRA     SOFTERR
NOLBLERR MOVEQ   #QER1,D7
         BRA     SOFTERR
UNDF     MOVEQ   #QER6,D7
         BRA     SOFTERR
PSEQ     CMP.B   #' ,INBUF(A5)
         BEQ.S   NOLBLERR
         BSR     EXPDFND
         TST.B   PASS(A5)
         BEQ.S   .2
         MOVE.L  D1,D0
         BSR     PRTAX
.1       RTS
.2       MOVE.L  ADDLBL(A5),A2
         CMP.B   #'.,INBUF(A5)
         BEQ.S   .3
         MOVE.L  D1,4(A2)
         BRA.S   .1
.3       MOVE.L  MJRLBL(A5),A3
         SUB.L   4(A3),D1
         CMP.L   #$10000,D1
         BHS.S   GT65535ERR
         MOVE.W  D1,2(A2)
         BRA.S   .1
*------------------------------
PSDA     CLR.B   -(A7)
.0       BSR     GNNB
         BCS     ERBA
.1       MOVE.B  D0,DLIM(A5)
         CMP.B   #'#,D0
         BEQ.S   .2
         CMP.B   #'/,D0
         BEQ.S   .2
         BSR     BACKCHR
.2       BSR     EXPR
         MOVE.L  D1,KEYADDR(A5)
         MOVE.B  DLIM(A5),D0
         CMP.B   #'#,D0
         BEQ.S   .4
         CMP.B   #'/,D0
         BEQ.S   .3
         MOVE.B  KEYADDR(A5),D0
         BSR     EMIT
         MOVE.B  KEYADDR+1(A5),D0
         BSR     EMIT
.3       MOVE.B  KEYADDR+2(A5),D0
         BSR     EMIT
.4       MOVE.B  KEYADDR+3(A5),D0
         BSR     EMIT
         MOVE.B  EXPUDF(A5),D0
         OR.B    D0,(A7)
         BSR     GNC.UC
         CMP.B   #',,D0
         BEQ.S   .0
         MOVE.B  (A7)+,EXPUDF(A5)
         RTS
*------------------------------
PSIN     TST.B   F.INCL(A5)
         BNE.S   .0
         TST.B   MACLVL(A5)
         BNE     OPERR
         BSR     GETNAM
         BCS.S   .1
         BSR     GETINF
         CMP.L   #TYPSRC,32(A0)
         BNE.S   .2
         MOVEQ   #1,D0
         BSR     OPNTFIL
         MOVE.W  D0,INCL.IO(A5)
         MOVE.B  #1,F.INCL(A5)
         TST.W   D7
         BNE     DOSERR
         SUBQ.L  #4,A7
         MOVEQ   #4,D1
         MOVE.L  A7,A1
         MOVE.W  INCL.IO(A5),D5
         BSR     READREC
         ADDQ.L  #4,A7
         BSR     LSTSRCIL
         MOVE.L  SRCP(A5),INSAVE(A5)
         BRA     ASM2
.0       MOVEQ   #QNIN,D7
         BRA     FIRMERR
.1       MOVEQ   #QSYNX,D7
         BRA     FIRMERR
.2       MOVEQ   #QFTM,D7
         BRA     FIRMERR
*------------------------------
PSEN     BSR     LSTSRCIL
ENDM     TST.B   F.INCL(A5)
         BEQ.S   .0
         BSR     RSTORE
         CLR.B   MACLVL(A5)
         BRA     ASM2
.0       BSR     TFEND
         TST.B   PASS(A5)
         BNE.S   .1
         ADDQ.B  #1,PASS(A5)
         BRA     ASM1
.1       TST.B   F.LIST(A5)
         BNE.S   ASMEND
         BSR     CRLFWP
         BSR     CRLFWP
         BSR     CRLFWP
         MOVEQ   #QST,D7
         BSR     QTO
         BSR     CRLFWP
         BSR     CRLFWP
         BSR     STPRNT
ASMEND   BSR     CRLF
         CLR.L   D1
         MOVE.W  ERRCNT(A5),D1
         BSR     P4DNUM
         MOVEQ   #QERRCNT,D7
         BSR     QTO
         BRA     SOFT
RSTORE   TST.B   F.INCL(A5)
         BEQ.S   .0
         MOVE.W  INCL.IO(A5),D0
         BSR     CLOSEF
         CLR.B   F.INCL(A5)
         MOVE.L  INSAVE(A5),SRCP(A5)
.0       RTS
*------------------------------
PSTI     TST.B   PASS(A5)
         BEQ.S   PGXIT
         BSR     EXPDFND
         MOVE.W  D1,PGLEN(A5)
         LEA     KBUF(A5),A1
         CLR.W   D6
         BSR     GNC
         CMP.B   #',,D0
         BNE.S   .2
.1       BSR     GNC
         BCS.S   .2
         MOVE.B  D0,0(A1,D6.W)
         ADDQ.W  #1,D6
         CMP.W   #70,D6
         BLO.S   .1
.2       CLR.B   0(A1,D6.W)
PSPG     BSR     FEED
PGXIT    BRA     ASM2
FEED     TST.B   PASS(A5)
         BEQ.S   .2
         TST.B   F.LIST(A5)
         BNE.S   .2
         MOVEQ   #$0C,D0
         BSR     CHO
         CLR.W   LINCNT(A5)
         ADDQ.W  #1,PGNUM(A5)
         CMP.W   #3,PGLEN(A5)
         BLO.S   .2
         LEA     KBUF(A5),A1
.0       MOVE.B  (A1)+,D0
         BEQ.S   .1
         BSR     CHO
         BRA.S   .0
.1       MOVEQ   #PAGEQT,D7
         BSR     QTO
         CLR.L   D1
         MOVE.W  PGNUM(A5),D1
         BSR     DISNUM
         BSR     CRLFWP
.2       RTS
*------------------------------
PSBS     BSR     EXPDFND
         CMP.L   #$10000,D1
         BHS     RAER
         MOVE.L  D1,KEYADDR(A5)
         BSR     PRTLOC
         MOVE.L  KEYADDR(A5),D1
         ADD.L   D1,ORGN(A5)
         ADD.L   D1,TRGT(A5)
         TST.B   PASS(A5)
         BEQ.S   .1
         TST.B   F.TF(A5)
         BEQ.S   .1
.0       TST.L   KEYADDR(A5)
         BEQ.S   .1
         SUBQ.L  #1,KEYADDR(A5)
         MOVE.W  TF.IO(A5),D5
         MOVEQ   #0,D0
         BSR     DOUT
         BRA.S   .0
.1       RTS
*------------------------------
PSLI     MOVEQ   #$FF,D1
         LEA     F.LIST(A5),A1
         BRA.S   .2
.1       LEA     F.MLIST(A5),A1
.2       BSR     GNC.UC
         BCS.S   .4
         CMP.B   #',,D0
         BEQ.S   .4
         CMP.B   #'M,D0
         BEQ.S   .1
         CMP.B   #'N,D0
         BEQ.S   .3
         CMP.B   #'F,D0
         BNE.S   .2
         MOVEQ   #1,D1
         BRA.S   .2
.3       MOVEQ   #0,D1
         BRA.S   .2
.4       TST.B   D1
         BMI     ASM2
         MOVE.B  D1,(A1)
         BRA.S   PSLI
*------------------------------
PSDO     BSR     EXPDFND
         ADDQ.W  #1,DOINDX(A5)
         BCC.S   .0
         MOVEQ   #QERDO2,D7
         BRA     FIRMERR
.0       TST.L   D1
         BEQ.S   .1
         MOVEQ   #1,D1
.1       MOVE.B  D1,DOSTAT(A5)
         RTS
PSEL     TST.W   DOINDX(A5)
         BEQ.S   ERRDO
         EOR.B   #1,DOSTAT(A5)
         RTS
ERRDO    MOVEQ   #QERDO,D7
         BRA     SOFTERR
PSFI     TST.W   DOINDX(A5)
         BEQ.S   ERRDO
         SUBQ.W  #1,DOINDX(A5)
         MOVE.B  #1,DOSTAT(A5)
         RTS
*------------------------------
PSAD     BSR     PRTLOC
PSAD0    MOVE.L  ORGN(A5),D0
         BTST    #0,D0
         BEQ.S   .0
         MOVEQ   #0,D0
         BSR     EMIT
.0       RTS
*--------------------------------
PSTR     BSR     GNNB
         BSR     BACKCHR
         CLR.L   D6
         BSR     GET1PAR
         MOVE.W  CHRPTR(A5),-(A7)
         MOVE.B  D6,D0
         SUBQ.B  #1,D0
         BSR     EMIT
         BSR     GNCSTART
.0       BCS.S   .1
         BSR     EMIT
         BSR     GNC
         BRA.S   .0
.1       MOVE.W  (A7)+,CHRPTR(A5)
         RTS
*--------------------------------
PSRS     TST.B   F.RS(A5)
         BNE     .4
         MOVE.B  #1,F.RS(A5)
         ADDQ.W  #1,RS.CNT(A5)
         BSR     EMRSRC
         CLR.L   D1
         TST.B   PASS(A5)
         BEQ.S   .0
         BSR     FORMRS
         BSR     STSRCH
         BCS     .5
.0       MOVEQ   #1,D0
         BSR     RSEMIT
         BSR     GNNB
         BSR     BACKCHR
         BSR     GST4
         BSR     GNC
         CMP.B   #',',D0
         BNE.S   .6
         BSR     EXPDFND
         CMP.L   #$FFFF8000,D1
         BHS.S   .12
         CMP.L   #$10000,D1
         BHS.S   .7
.12      MOVEQ   #0,D0
         BSR     RSEMIT
         BSR     GNC
         BEQ.S   .8
         CMP.B   #',',D0
         BNE.S   .6
         BSR     EXPDFND
         CMP.L   #$10000,D1
         BHS.S   .7
.9       MOVEQ   #0,D0
         BSR     RSEMIT
         BSR     GNC
         BEQ.S   .10
         CMP.B   #',',D0
         BNE.S   .6
         BSR     PSTR
.11      BSR     PSAD0
         MOVE.L  ORGN(A5),RS.ADD(A5)
         RTS
.8       BSR     BACKCHR
         CLR.L   D1
         BRA.S   .9
.10      MOVEQ   #0,D0
         BSR     EMIT
         BRA.S   .11
.4       MOVEQ   #QNRS,D7
         BRA     FIRMERR
.5       MOVEQ   #QNENR,D7
         BRA     FIRMERR
.6       MOVEQ   #QSYNX,D7
         BRA     FIRMERR
.7       MOVEQ   #QER10,D7
         BRA     FIRMERR
*--------------------------------
PSENR    TST.B   F.RS(A5)
         BEQ.S   .1
         TST.B   PASS(A5)
         BNE.S   .0
         BSR     RSYM
.0       BSR     PSAD0
         CLR.B   F.RS(A5)
         RTS
.1       MOVEQ   #QNORS,D7
         BRA     FIRMERR
*--------------------------------
PSNA     BSR     EMRSRC
         BSR     PSTR
         BSR     GST4
         BSR     GNC
         BEQ.S   .4
         CMP.B   #',',D0
         BNE.S   .6
.1       BSR     GST4
         BSR     GNC
         BEQ.S   .5
         CMP.B   #',',D0
         BNE.S   .6
         BSR     EXPDFND
         CMP.L   #$10000,D1
         BHS.S   .7
.2       MOVEQ   #0,D0
         BSR     RSEMIT
         BSR     PSAD0
         RTS
.4       BSR     BACKCHR
         BRA.S   .1
.5       MOVEQ   #0,D1
         BRA.S   .2
.6       MOVEQ   #QSYNX,D7
         BRA     FIRMERR
.7       MOVEQ   #QER10,D7
         BRA     FIRMERR
*--------------------------------
EMRSRC   MOVEQ   #'R,D0
         BSR     EMIT
         MOVEQ   #'S,D0
         BSR     EMIT
         MOVEQ   #'R,D0
         BSR     EMIT
         MOVEQ   #'C,D0
         BRA     EMIT
GST4     MOVE.B  #4,LAST(A5)
.1       BSR     GNC
         BEQ.S   .2
         CMP.B   #',',D0
         BNE.S   .3
.2       BSR     BACKCHR
         MOVEQ   #$20,D0
.3       BSR     EMIT
         SUBQ.B  #1,LAST(A5)
         BNE.S   .1
         RTS
FORMRS   LEA     SYMBOL(A5),A0
         MOVE.B  #'@,11(A0)
         MOVE.B  #'R,12(A0)
         MOVE.B  RS.CNT(A5),13(A0)
         MOVE.B  RS.CNT+1(A5),14(A0)
         MOVE.B  #4,10(A0)
         RTS
RSYM     BSR     FORMRS
         BSR     STSRCH
         BSR     STADD
         MOVE.L  ADDLBL(A5),A0
         MOVE.L  ORGN(A5),D1
         SUB.L   RS.ADD(A5),D1
         MOVE.L  D1,4(A0)
         RTS
RSEMIT   MOVE.L  D1,RS.ADD(A5)
         TST.B   D0
         BEQ.S   .0
         MOVE.B  RS.ADD(A5),D0
         BSR     EMIT
         MOVE.B  RS.ADD+1(A5),D0
         BSR     EMIT
.0       MOVE.B  RS.ADD+2(A5),D0
         BSR     EMIT
         MOVE.B  RS.ADD+3(A5),D0
         BRA     EMIT
*--------------------------------
PSTRAP   CLR     KEYADDR(A5)
.0       BSR     EXPDFND
         CMP.L   #$10000,D1
         BHS     RAER
         OR      D1,KEYADDR(A5)
         BSR     GNNB
         CMP.B   #',,D0
         BEQ.S   .0
         MOVE.B  KEYADDR+0(A5),D0
         BSR     EMIT
         MOVE.B  KEYADDR+1(A5),D0
         BSR     EMIT
         RTS
*--------------------------------
