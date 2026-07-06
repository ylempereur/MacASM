;SAVE"Edit.Asm"
*--------------------------------
HARD     BSR     HDINIT
         BSR     AUTOSTR
SOFT     CLR.B   F.LIST(A5)
         BSR     CLOSFILE
GNL0     BSR     DPROMPT
GNL      MOVE.L  SAVESP(A5),A7
         MOVE.B  #$FF,PASS(A5)
         CLR.B   RPTCNT(A5)
         CLR.B   MACLVL(A5)
         CLR.W   PARPTR(A5)
         CLR.W   CHRPTR(A5)
         CLR.W   PGLEN(A5)
         BSR     READLINE
         BSR     GNCUCSTR
         BEQ.S   GNL
         BSR     CHL
         BCC.S   .0
         BSR     SCMTBL
         BSR     DPROMPT
         BRA.S   GNL
.0       BSR     NML
         BRA.S   GNL
SYNX     MOVEQ   #QSYNX,D7
         BRA     HARDERR
*--------------------------------
* Insert Line in Buffer from INBUF
*--------------------------------
NML      BSR     GNCSTART
         BSR     DECN
         TST.B   D2
         BEQ.S   SYNX
         CMP.B   #6,D2
         BHS.S   SYNX
         MOVE.W  D1,-(A7)
         CLR.B   D2
         CLR.B   D1
         CLR.W   D6
         LEA     INBUF(A5),A0
.0       MOVE.B  0(A0,D7.W),D0
         BEQ.S   .3
         CMP.B   D2,D0
         BNE.S   .2
.1       ADDQ.B  #1,D1
         ADDQ.W  #1,D7
         BRA.S   .0
.2       BSR     PRORPC
         MOVE.B  0(A0,D7.W),D2
         BRA.S   .1
.3       BSR     PRORPC
         CLR.B   0(A0,D6.W)
         MOVE.W  D6,D7
.4       MOVE.B  0(A0,D7.W),3(A0,D7.W)
         DBRA    D7,.4
         ADDQ.W  #4,D6
         CMP.W   #5,D6
         BHS.S   .5
         CLR.W   D6
.5       MOVE.B  D6,(A0)
         MOVE.W  (A7)+,D0
         MOVE.W  D0,CURLNI(A5)
         MOVE.W  D0,CURLNL(A5)
         MOVE.W  D0,D1
         MOVE.B  D1,2(A0)
         LSR.W   #8,D1
         MOVE.B  D1,1(A0)
         MOVE.W  #-1,D1
         BSR     SERTXT
         MOVE.L  A2,D0
         SUB.L   A1,D0
         CLR.L   D1
         MOVE.B  INBUF(A5),D1
         SUB.L   D0,D1
         BEQ.S   .6
         BSR     MVTEXT
.6       MOVE.L  A1,A3
         LEA     INBUF(A5),A0
         MOVE.B  (A0),D0
         BEQ.S   .8
.7       MOVE.B  (A0)+,(A1)+
         SUBQ.B  #1,D0
         BNE.S   .7
         ANDI    #$FB,CCR
.8       RTS
*--------------------------------
* Process repeat count
* D1 = Counter
* D2 = Character
* A2 = Pointer to Inbuf
*--------------------------------
PRORPC   TST.B   D1
         BEQ.S   .2
         CMP.B   #$20,D2
         BEQ.S   .4
         MOVE.B  D2,2(A0,D6.W)
         CMP.B   #4,D1
         BLO.S   .3
         MOVE.B  D1,1(A0,D6.W)
         MOVE.B  #$E0,0(A0,D6.W)
         ADDQ.W  #2,D6
.1       CLR.B   D1
         ADDQ.W  #1,D6
.2       RTS
.3       MOVE.B  D2,0(A0,D6.W)
         ADDQ.W  #1,D6
         SUBQ.B  #1,D1
         BNE.S   .3
         RTS
.4       CMP.B   #$20,D1
         BLO.S   .5
         SUB.B   #$1F,D1
         MOVE.B  #$FF,0(A0,D6.W)
         ADDQ.W  #1,D6
         BRA.S   .4
.5       OR.B    #$E0,D1
         MOVE.B  D1,0(A0,D6.W)
         BRA.S   .1
*--------------------------------
* Get 1 line from Keyboard or Disk
*--------------------------------
DPROMPT  BSR     CRLF
         CLR.B   PRTFL(A5)
         MOVEQ   #QPROMPT,D7
         BRA     QTO
READLINE CLR.W   CHRPTR(A5)
         CLR.B   INBUF(A5)
         TST.B   F.ENTR(A5)
         BNE.S   .1
.0       BSR     EGETCH
         LEA     INBUF(A5),A0
         MOVE.W  CHRPTR(A5),D7
         MOVE.B  D0,0(A0,D7.W)
         ADDQ.W  #1,CHRPTR(A5)
         CMP.B   #$0D,D0
         BNE.S   .0
         CLR.B   0(A0,D7.W)
         SUBQ.W  #1,CHRPTR(A5)
         RTS
.1       LEA     PARABLK(A5),A0
         CLR.L   12(A0)
         MOVE.W  ENTR.IO(A5),24(A0)
         LEA     INBUF(A5),A1
         MOVE.L  A1,32(A0)
         MOVE.L  #121,36(A0)
         MOVE.W  #$0D80,44(A0)
         CLR.L   46(A0)
         OST     Read
         MOVE.W  16(A0),D7
         BEQ.S   .2
         CMP.W   #-39,D7
         BNE     DOSERR
         TST.L   40(A0)
         BNE.S   .2
         BSR     CLOSE.TXT
         BRA     DPROMPT
.2       MOVE.L  40(A0),D7
         SUBQ.W  #1,D7
         LEA     INBUF(A5),A0
         CLR.B   0(A0,D7.W)
         MOVE.W  D7,CHRPTR(A5)
         MOVE.B  (A0),D0
         BSR     CHD
         BCS.S   .4
.3       MOVE.B  0(A0,D7.W),6(A0,D7.W)
         DBRA    D7,.3
         ADDQ.W  #6,CHRPTR(A5)
         CLR.L   D1
         MOVE.W  CURLNI(A5),D1
         ADD.W   INCREM(A5),D1
         CLR.W   D7
         BSR     CNVLNP
         MOVE.B  #$20,0(A0,D7.W)
.4       RTS
CLOSE.TXT
         MOVE.W  ENTR.IO(A5),D0
         BSR     CLOSEF
         CLR.B   F.ENTR(A5)
         RTS
*--------------------------------
* Commands
*--------------------------------
NEW      BRA     HARD
MEMORY   MOVEQ   #QMEMO0,D7
         BSR     QTO
         MOVE.L  LOMEM(A5),D0
         BSR     PRNT.A
         BSR.S   DASH
         MOVE.L  EOS(A5),D0
         BSR     PRNT.A
         MOVEQ   #QMEMO1,D7
         BSR     QTO
         MOVE.L  EOS(A5),D0
         BSR     PRNT.A
         BSR.S   DASH
         MOVE.L  EOT(A5),D0
         BSR     PRNT.A
         MOVEQ   #QMEMO2,D7
         BSR     QTO
         MOVE.L  EOT(A5),D0
         BSR     PRNT.A
         BSR     DASH
         MOVE.L  HIMEM(A5),D0
         BSR     PRNT.A
         BRA     CRLF
DASH     MOVEQ   #'-,D0
         BRA     CHO
*--------------------------------
* INBUF Handling routines
* Char   NE CC
* Space  EQ CC
* Eol    EQ CS
*--------------------------------
GNNB     BSR.S   GNC.UC
         BCS.S   .1
         BEQ.S   GNNB
.1       RTS
GNCUCSTR CLR.W   CHRPTR(A5)
GNC.UC   BSR.S   GNC
         BEQ.S   .1
         BSR.S   LCUC
         MOVE.B  D0,CURCHR(A5)
         CMP.B   #0,D0
.1       RTS
GNCSTART CLR.W   CHRPTR(A5)
GNC      MOVE.W  CHRPTR(A5),D7
GNC2     LEA     INBUF(A5),A0
         MOVE.B  0(A0,D7.W),D0
         MOVE.B  D0,CURCHR(A5)
         BEQ.S   .1
         ADDQ.W  #1,D7
         MOVE.W  D7,CHRPTR(A5)
         CMP.B   #$20,D0
         ANDI    #$FE,CCR
         RTS
.1       MOVEQ   #$20,D0
         ORI     #5,CCR
         RTS
BACKCHR  TST.B   CURCHR(A5)
         BEQ.S   .1
         TST.W   CHRPTR(A5)
         BEQ.S   .1
         SUBQ.W  #1,CHRPTR(A5)
.1       RTS
LCUCF    TST.B   LCFL(A5)
         BEQ.S   LCUCR
LCUC     CMP.B   #'a,D0
         BLO.S   LCUCR
         CMP.B   #'z,D0
         BHI.S   LCUCR
         AND.B   #$5F,D0
LCUCR    RTS
*--------------------------------
* Get next Chr from memory
*--------------------------------
NTKN     TST.B   RPTCNT(A5)
         BNE.S   .3
         MOVE.L  SRCP(A5),A0
         MOVE.B  (A0),D0
         CMP.B   #$E0,D0
         BLO.S   GNBI
         BNE.S   .1
         BSR.S   GNBI
         BSR.S   GNB
         MOVE.B  D0,RPTCNT(A5)
         MOVE.L  SRCP(A5),A0
         MOVE.B  (A0),D0
         BRA.S   .2
.1       AND.B   #$1F,D0
         MOVE.B  D0,RPTCNT(A5)
         MOVEQ   #$20,D0
.2       MOVE.B  D0,RPTCHR(A5)
         BSR.S   GNBI
.3       SUBQ.B  #1,RPTCNT(A5)
         MOVE.B  RPTCHR(A5),D0
         RTS
GNB      MOVE.L  SRCP(A5),A0
         MOVE.B  (A0),D0
GNBI     ADDQ.L  #1,SRCP(A5)
         TST.B   D0
         RTS
*--------------------------------
* Check Character
* Ok      CS
* Not Ok  CC
*--------------------------------
CHDDL    CMP.B   #'.,D0
         BEQ.S   CHOK
         CMP.B   #'_,D0
         BEQ.S   CHOK
CHDL     BSR.S   CHD
         BCS.S   CHOK
CHL      CMP.B   #'A,D0
         BLO.S   CHNOTOK
         CMP.B   #'Z,D0
         BLS.S   CHOK
CHNOTOK  AND     #$FE,CCR
         RTS
CHD      CMP.B   #'0,D0
         BLO.S   CHNOTOK
         CMP.B   #'9,D0
         BHI.S   CHNOTOK
CHOK     OR      #1,CCR
         RTS
CHCC     CMP.B   #'*,D0
         BEQ.S   .1
         CMP.B   #';,D0
.1       RTS
*--------------------------------
* Hard init
*--------------------------------
HDINIT   CLR.B   F.INCL(A5)
         MOVE.W  #10,INCREM(A5)
         CLR.W   CURLNI(A5)
         CLR.W   CURLNL(A5)
         MOVE.L  LOMEM(A5),EOS(A5)
         BSR     STINIT
         MOVEQ   #QTITLE,D7
         BRA     QTO
*--------------------------------
* Search Line in Buffer
* D0 = Line Number
* D1 = Decount
* D2 = Counter of skipped Lines
* A1 = Address of Line
* A2 = Address of Next Line
* A3 = Address of previous Line
* If Decount = -1 search Line Number
* If Decount <> -1 search N-th Line
* Found     CS  A1=Line A2=Next
* Not Found CC  A1=A2=Next
*--------------------------------
SERTXT   MOVE.L  LOMEM(A5),A2
         MOVE.L  A2,A1
SERNXT   CLR.L   D2
.0       MOVE.L  A1,A3
         MOVE.L  A2,A1
         CMP.L   EOS(A5),A1
         BHS.S   .1
         CLR.W   D3
         MOVE.B  (A1),D3
         ADD.W   D3,A2
         MOVE.B  1(A1),D3
         LSL.W   #8,D3
         MOVE.B  2(A1),D3
         CMP.W   #-1,D1
         BNE.S   .2
         CMP.W   D0,D3
         BLO.S   .4
         BEQ.S   .3
         MOVE.L  A1,A2
.1       AND     #$FE,CCR
         RTS
.2       DBRA    D1,.4
.3       OR      #1,CCR
         RTS
.4       ADDQ.L  #1,D2
         BRA.S   .0
*--------------------------------
* Delete lines
*--------------------------------
DELETE   BSR     RANGE
         BCC.S   DEL0
DELSY    BRA     SYNX
DEL0     MOVE.L  SRCP(A5),A1
         MOVE.L  ENDP(A5),A2
         CMP.L   A1,A2
         BLO.S   DELSY
         MOVE.L  A1,D1
         SUB.L   A2,D1
*--------------------------------
* Move Text in Buffer
* A1 = Line
* A2 = Next
* D1 = Displacement
*--------------------------------
MVTEXT   MOVE.L  EOS(A5),D2
         SUB.L   A2,D2
         TST.L   D1
         BPL.S   MTXTUP
MTXTDN   MOVE.L  A2,A3
         ADD.L   D1,A3
         ADD.L   D1,EOS(A5)
         BRA.S   .1
.0       MOVE.B  (A2)+,(A3)+
.1       SUBQ.L  #1,D2
         BPL.S   .0
         BRA.S   MTXTEX
MTXTUP   MOVE.L  EOS(A5),A3
         ADD.L   D1,A3
         CMP.L   HIMEM(A5),A3
         BHI.S   MFER
         MOVE.L  EOS(A5),A2
         MOVE.L  A3,EOS(A5)
         BRA.S   .1
.0       MOVE.B  -(A2),-(A3)
.1       SUBQ.L  #1,D2
         BPL.S   .0
MTXTEX   MOVE.L  EOS(A5),EOT(A5)
         CLR.B   F.SYMTB(A5)
         RTS
MFER     MOVEQ   #QMEMFL,D7
         BRA     HARDERR
*--------------------------------
