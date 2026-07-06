;SAVE"Asmgen.asm"
*------------------------------
ASM      BSR     HNDROP
         CLR.B   PASS(A5)
         CLR.W   ERRCNT(A5)
         CLR.W   PGNUM(A5)
         BSR     STINIT
         BSR     RSTORE
ASM1     TST.W   ERRCNT(A5)
         BNE     ASMEND
         MOVE.L  LOMEM(A5),SRCP(A5)
         MOVE.L  HIMEM(A5),A0
         ADDQ.L  #1,A0
         MOVE.L  A0,MACSTK(A5)
         MOVE.B  #1,DOSTAT(A5)
         CLR.W   DOINDX(A5)
         CLR.B   F.LIST(A5)
         CLR.B   F.MLIST(A5)
         CLR.B   F.TF(A5)
         CLR.B   TF.CNT(A5)
         CLR.B   F.RS(A5)
         CLR.W   RS.CNT(A5)
         CLR.W   SKPCNT(A5)
         CLR.B   F.MACRO(A5)
         CLR.B   MACLVL(A5)
         CLR.W   CALCNT(A5)
         CLR.W   CALNUM(A5)
         CLR.L   ORGN(A5)
         CLR.L   TRGT(A5)
ASM2     BSR     ABORT0
         BCC.S   .1
         BNE.S   .1
         BSR     ABORT
         BRA     SOFT
.1       MOVE.L  SAVESP(A5),A7
         CLR.W   BCNT(A5)
         CLR.B   EXPUDF(A5)
         BSR     SETUPNL
         BCS     ENDM
         TST.B   DOSTAT(A5)
         BNE.S   ASM1LN
SKPTFN   BSR     SCANOPC
         BCS.S   ASM2
         BSR     BACKCHR
         LEA     DIR.DO(PC),A1
         BSR     SCANFL
         BCC.S   .1
         ADDQ.W  #1,SKPCNT(A5)
         BRA.S   ASM2
.1       TST.W   SKPCNT(A5)
         BNE.S   .2
         BSR     SCANFL
         BCS.S   ASM1LN
.2       LEA     DIR.FI(PC),A1
         BSR     SCANFL
         BCC.S   ASM2
         TST.W   SKPCNT(A5)
         BEQ.S   ASM1LN
         SUBQ.W  #1,SKPCNT(A5)
         BRA     ASM2
ASM1LN   BSR     CRLFIL
         BSR     PACKML
         BCS.S   CMNT
         BSR     GNCUCSTR
         BCS.S   CMNT
         BEQ.S   .3
         BSR     CHCC
         BEQ.S   CMNT
         BSR     LABL
.3       BSR     GNNB
         BCS.S   CMNT
         CMP.B   #'.,D0
         BEQ.S   .4
         BSR     BACKCHR
         BSR     MACALL
.4       LEA     OPTBLDIR(PC),A1
         BSR     SRCHDIR
         BCC.S   .5
         LEA     ASM(PC),A0
         JSR     0(A0,D1.W)
         BRA.S   CMNT
.5       BSR     OPTSCH
         BCS     MACER2
         BSR     ASM68
CMNT     TST.B   EXPUDF(A5)
         BEQ.S   .1
         TST.B   PASS(A5)
         BNE     UNDF
.1       BSR     LSTSRCIL
         BRA     ASM2
OPERR    MOVEQ   #QER2,D7
ABRT     BRA     SOFTERR
*------------------------------
EMIT0    MOVEQ   #0,D0
EMIT     TST.B   PASS(A5)
         BEQ.S   .6
         MOVE.B  D0,OBJBYTE(A5)
         TST.B   F.LIST(A5)
         BNE.S   .4
         MOVE.W  BCNT(A5),D0
         BEQ.S   .1
         CMP.W   #5,D0
         BNE.S   .2
         CLR.W   BCNT(A5)
         BSR     CRLFWP
.1       BSR     PRTLOC
.2       MOVE.W  BCNT(A5),D0
         LSR.W   #1,D0
         BCC.S   .3
         BSR     SPC
.3       ADDQ.W  #1,BCNT(A5)
         MOVE.B  OBJBYTE(A5),D0
         BSR     PRNT.B
.4       TST.B   F.TF(A5)
         BNE.S   .5
         BSR     CHKMEM
         MOVE.L  TRGT(A5),A0
         MOVE.B  OBJBYTE(A5),(A0)
         BRA.S   .6
.5       MOVE.W  TF.IO(A5),D5
         MOVE.B  OBJBYTE(A5),D0
         BSR     DOUT
.6       ADDQ.L  #1,TRGT(A5)
         ADDQ.L  #1,ORGN(A5)
         RTS
CHKMEM   MOVE.L  EOT(A5),A0
         CMP.L   TRGT(A5),A0
         BHS.S   .0
         MOVE.L  TRGT(A5),A0
         CMP.L   MACSTK(A5),A0
         BHS.S   .0
         RTS
.0       MOVEQ   #QMEMPRO,D7
         BRA     FIRMERR
*------------------------------
* Print Location Counter
*------------------------------
PRTLOC   MOVE.L  ORGN(A5),D0
PRTAX    TST.B   PASS(A5)
         BEQ.S   .0
         TST.B   F.LIST(A5)
         BNE.S   .0
         BSR     PRNT.L
         MOVEQ   #':,D0
         BSR     CHO
         ADDQ.W  #1,BCNT(A5)
.0       CLR.L   D6
         RTS
*------------------------------
* List Source if Listing
*------------------------------
LSTSRCIL TST.B   F.LIST(A5)
         BNE.S   LSTX
LSTSRC   TST.B   PASS(A5)
         BEQ.S   LSTX
         MOVE.W  BCNT(A5),D7
         MOVE.B  NBTBL(PC,D7.W),D6
.0       BSR     SPC
         SUBQ.B  #1,D6
         BNE.S   .0
LSTSRC1  MOVE.L  SRCPSAV(A5),SRCP(A5)
         BSR     LSTA
LSTX     RTS
NBTBL    HEX     14.0B.08.06.03.01
*------------------------------
* CRLF if Listing
*------------------------------
CRLFIL   TST.B   PASS(A5)
         BEQ.S   CRLFX
         TST.B   F.LIST(A5)
         BEQ.S   CRLFWP
CRLFX    RTS
CRLFWP   MOVEM.L D0-D7/A0-A3,-(A7)
.0       BSR     CRLF
         ADDQ.W  #1,LINCNT(A5)
         MOVE.W  PGLEN(A5),D0
         BEQ.S   .1
         CMP.W   LINCNT(A5),D0
         BHS.S   .1
         BSR     FEED
         BRA     .0
.1       MOVEM.L (A7)+,D0-D7/A0-A3
         BRA.S   CRLFX
*------------------------------
* Process Label Definition
*------------------------------
LABL     BSR     PACK
         BEQ     ERRBS
         BSR     STSRCH
         BCS     STADD
ERRDD    TST.B   PASS(A5)
         BEQ.S   ERDBLDF
         BSET    #7,(A2)
         MOVE.B  INBUF(A5),D0
         CMP.B   #'.,D0
         BEQ.S   .2
         CMP.B   #':,D0
         BEQ.S   .2
         MOVE.L  A2,MJRLBL(A5)
.2       RTS
ERDBLDF  MOVEQ   #QER4,D7
         BRA     SOFTERR
ERRBS    MOVEQ   #QER7,D7
         BRA     SOFTERR
*------------------------------
* Check keyboard for Abort
* No Key   CC ??
*    Key   CS NE
* RETURN   CS EQ
*------------------------------
ABORT0   SUBQ.L  #2,A7
         MOVE.W  #$29,-(A7)
         PEA     EVNTRC(A5)
         TBX     EventAvail
         TST.B   (A7)+
         BEQ.S   .1
         MOVE.W  WHAT(A5),D0
         CMP.W   #3,D0
         BEQ.S   .0
         CMP.W   #5,D0
         ANDI    #$FE,CCR
         BNE.S   .1
.0       MOVE.L  MESS(A5),D0
         BSR     CMND
         CMP.B   #$0D,D0
         ORI     #1,CCR
.1       RTS
*------------------------------
* Search Opcode Table
*------------------------------
OPTSCH   MOVE.W  CHRPTR(A5),D2
         LEA     INBUF(A5),A2
         CLR.W   D0
         MOVE.B  0(A2,D2.W),D0
         BSR     LCUC
         BSR     CHL
         BCC     OPERR
         SUB.W   #'A,D0
         LSL.W   #1,D0
         LEA     OPADD(PC),A1
         MOVE.W  0(A1,D0.W),D0
         BEQ.S   .8
         LEA     0(A1,D0.W),A1
.0       MOVE.W  D2,D6
         MOVEQ   #1,D7
.1       MOVE.B  0(A1,D7.W),D1
         BEQ.S   .6
         BMI.S   .4
         MOVE.B  0(A2,D6.W),D0
         BSR     LCUC
         CMP.B   D0,D1
         BNE.S   .2
         ADDQ.W  #1,D6
         ADDQ.W  #1,D7
         BRA.S   .1
.2       CLR.W   D0
         MOVE.B  (A1),D0
         BNE.S   .3
.8       MOVE.W  D2,CHRPTR(A5)
         ORI     #1,CCR
         RTS
.3       ADD.W   D0,A1
         BRA.S   .0
.4       AND.B   #$7F,D1
         MOVE.B  0(A2,D6.W),D0
         BSR     LCUC
         CMP.B   D0,D1
         BNE.S   .2
         ADDQ.W  #1,D6
         MOVE.W  D6,CHRPTR(A5)
         MOVE.W  D7,D5
         BSR     GNC
         BEQ.S   .5
         CMP.B   #'.,D0
         BNE.S   .2
.5       BSR     BACKCHR
         MOVE.W  D5,D7
         BRA.S   .7
.6       MOVE.W  D6,CHRPTR(A5)
.7       LEA     1(A1,D7.W),A1
         ANDI    #$FE,CCR
         RTS
*------------------------------
