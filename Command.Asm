;SAVE"Command.Asm"
*--------------------------------
* Scan Command Table & Jump
*--------------------------------
SCMTBL   LEA     CMDTBL(PC),A1
         LEA     CMDADR(PC),A2
.0       CLR.W   CHRPTR(A5)
.1       BSR     GNC.UC
         BCS.S   .4
         BSR     CHL
         BCC.S   .3
         MOVE.B  (A1)+,D1
         BEQ.S   .7
         BMI.S   .2
         CMP.B   D0,D1
         BNE.S   .6
         BRA.S   .1
.2       AND.B   #$7F,D1
         CMP.B   D0,D1
         BNE.S   .6
         BRA.S   .5
.3       SUBQ.W  #1,D7
.4       CMP.W   #3,D7
         BLO.S   .6
         MOVE.W  D7,CHRPTR(A5)
.5       LEA     HARD(PC),A0
         ADDA.W  (A2),A0
         MOVEQ   #0,D1
         JMP     (A0)
.6       TST.B   (A1)+
         BPL.S   .6
         ADDQ.L  #2,A2
         BRA.S   .0
.7       BRA     SYNX
*--------------------------------
* Command Table
*--------------------------------
CMDTBL   AST     'APPEND'
         AST     'ASM'
         AST     'BLOAD'
         AST     'BSAVE'
         AST     'COPY'
         AST     'DELETE'
         AST     'DIRECTORY'
         AST     'DOS'
         AST     'EJECT'
         AST     'ENTER'
         AST     'FIND'
         AST     'INCREMENT'
         AST     'LIST'
         AST     'LOAD'
         AST     'MEMORY'
         AST     'MOVE'
         AST     'NEW'
         AST     'QUIT'
         AST     'RENUMBER'
         AST     'REPLACE'
         AST     'RUN'
         AST     'SAVE'
         AST     'SERIAL'
         AST     'SETLABEL'
         AST     'SYMBOLS'
         AST     'TYPE'
         AST     'VALUE'
         HEX     00
         ADJST
*--------------------------------
* Command Address
*--------------------------------
CMDADR   DATA    /APPEND-HARD
         DATA    /ASM-HARD
         DATA    /BLOAD-HARD
         DATA    /BSAVE-HARD
         DATA    /COPY-HARD
         DATA    /DELETE-HARD
         DATA    /DIRECT-HARD
         DATA    /DOS-HARD
         DATA    /EJECTD-HARD
         DATA    /ENTER-HARD
         DATA    /FIND-HARD
         DATA    /INCREMENT-HARD
         DATA    /FIND-HARD
         DATA    /LOAD-HARD
         DATA    /MEMORY-HARD
         DATA    /MOVE-HARD
         DATA    /NEW-HARD
         DATA    /DOS-HARD
         DATA    /REN-HARD
         DATA    /REPLACE-HARD
         DATA    /RUN-HARD
         DATA    /SAVE-HARD
         DATA    /SERIAL-HARD
         DATA    /SETLBL-HARD
         DATA    /SYMB-HARD
         DATA    /TEXT-HARD
         DATA    /VAL-HARD
*--------------------------------
* Increment
*--------------------------------
INCREMENT
         BSR     SCND
         CMP.B   #2,D1
         BNE     SYNX
         MOVE.W  PARAM0(A5),INCREM(A5)
         RTS
*--------------------------------
* LIST & FIND
*--------------------------------
FIND     BSR     GTKYSTR
         BSR     RANGE
         BSR     HNDROP
.0       BSR     GTLNBUF
         BCC.S   .1
         RTS
.1       BSR     FKYINB
         BCC.S   .0
         BSR     LSTLA3
         BRA.S   .0
*--------------------------------
* Get key string
*--------------------------------
GTKYSTR  LEA     KBUF(A5),A0
         MOVE.L  A0,KEYADDR(A5)
GETKY2   BSR     GNNB
         BCS.S   .4
         MOVE.B  D0,D5
         CMP.B   #',,D0
         BEQ.S   .4
         CMP.B   #'#,D0
         BEQ.S   .4
         CMP.B   #'.,D0
         BEQ.S   .4
         CMP.B   #'*,D0
         BEQ.S   .4
         CMP.B   #'P,D0
         BEQ.S   .4
         EOR.B   #$30,D0
         CMP.B   #10,D0
         BLO.S   .4
         CLR.W   D7
.1       MOVE.W  D7,PNTR(A5)
         BSR     GNC
         BCS.S   .2
         CMP.B   D5,D0
         BEQ.S   .2
         MOVE.W  PNTR(A5),D7
         MOVE.L  KEYADDR(A5),A0
         MOVE.B  D0,0(A0,D7.W)
         ADDQ.W  #1,D7
         CMP.W   #40,D7
         BLO.S   .1
         MOVEQ   #QSTRLNG,D7
         BRA     HARDERR
.2       MOVE.W  PNTR(A5),D7
         MOVE.L  KEYADDR(A5),A0
         CLR.B   0(A0,D7.W)
         ORI     #1,CCR
         RTS
.4       CLR.W   PNTR(A5)
         BSR     BACKCHR
         AND     #$FE,CCR
         RTS
*--------------------------------
* Get line to INBUF
*--------------------------------
GTLNBUF  MOVE.L  SRCP(A5),A3
         CMP.L   ENDP(A5),A3
         BHS.S   .2
         BSR     GETLN
         CLR.L   D1
         MOVE.W  CURLNL(A5),D1
         CLR.W   D7
         BSR     CNVLNP
         LEA     INBUF(A5),A1
         MOVE.B  #$20,0(A1,D7.W)
         ADDQ.W  #1,D7
         MOVE.W  D7,D6
.1       BSR     NTKN
         MOVE.B  D0,0(A1,D6.W)
         ADDQ.W  #1,D6
         TST.B   D0
         BNE.S   .1
         ANDI    #$FE,CCR
         RTS
.2       ORI     #1,CCR
         RTS
*--------------------------------
* List the line pointed by SRCP
*--------------------------------
LSTLA3   MOVE.L  A3,SRCP(A5)
LSTCLN   BSR     CRLF
LSTA     TST.B   MACLVL(A5)
         BNE.S   .0
         BSR     GETLN
.0       CLR.L   D1
         MOVE.W  CURLNL(A5),D1
         BSR     CNVLP
         MOVE.B  MACLVL(A5),D7
         BEQ.S   .2
         MOVEQ   #'>,D0
.1       BSR     CHO
         SUBQ.B  #1,D7
         BNE.S   .1
.2       MOVEQ   #$20,D0
.3       BSR     CHO
         BSR     GNSRCHR
         BNE.S   .3
         RTS
*--------------------------------
* Find key in INBUF
*--------------------------------
FKYINB   TST.W   PNTR(A5)
         BNE.S   .1
         ORI     #1,CCR
         RTS
.1       MOVE.L  KEYADDR(A5),A0
         MOVEQ   #39,D7
.2       MOVE.B  0(A0,D7.W),D0
         BSR     LCUCF
         MOVE.B  D0,0(A0,D7.W)
         DBRA    D7,.2
         BSR     FSLINB
FKYINB2  MOVE.L  KEYADDR(A5),A0
         LEA     INBUF(A5),A1
         CLR.W   D7
.1       MOVE.W  D7,KYPNTR(A5)
.2       MOVE.W  D6,BFPNTR(A5)
.3       MOVE.B  0(A0,D7.W),D1
         BEQ.S   .6
         CMP.B   #'?,D1
         BEQ.S   .8
         MOVE.B  0(A1,D6.W),D0
         BEQ.S   .5
         BSR     LCUCF
         CMP.B   D0,D1
         BNE.S   .4
         ADDQ.W  #1,D7
         ADDQ.W  #1,D6
         BRA.S   .3
.4       MOVE.W  KYPNTR(A5),D7
         MOVE.W  BFPNTR(A5),D6
         ADDQ.W  #1,D6
         BRA.S   .2
.5       AND     #$FE,CCR
         RTS
.6       TST.W   KYPNTR(A5)
         BNE.S   .7
         MOVE.W  BFPNTR(A5),PNTR(A5)
.7       ORI     #1,CCR
         RTS
.8       TST.W   KYPNTR(A5)
         BNE.S   .9
         MOVE.W  BFPNTR(A5),PNTR(A5)
.9       ADDQ.W  #1,D7
         MOVE.B  0(A0,D7.W),D0
         BNE.S   .1
.10      TST.B   0(A1,D6.W)
         BEQ.S   .6
         ADDQ.W  #1,D6
         BRA.S   .10
*--------------------------------
* Replace
*--------------------------------
REPLACE  BSR     GTKYSTR
         BCC     SYNX
         TST.W   PNTR(A5)
         BEQ     SYNX
         BSR     BACKCHR
         LEA     KBUF+40(A5),A0
         MOVE.L  A0,KEYADDR(A5)
         BSR     GETKY2
         BCC     SYNX
         MOVE.W  D7,REPLEN(A5)
         BSR     RANGE
         BSR     HNDROP
         LEA     KBUF(A5),A0
         MOVE.L  A0,KEYADDR(A5)
         MOVE.W  #1,PNTR(A5)
.1       BSR     GTLNBUF
         BCS.S   .5
         MOVE.W  D6,INBLEN(A5)
         BSR     FKYINB
         BCC.S   .1
         CLR.W   CHACNT(A5)
.2       MOVE.W  D6,D0
         SUB.W   PNTR(A5),D0
         MOVE.W  D0,SRCLEN(A5)
         MOVE.W  D6,MTHEND(A5)
         BSR     DOREP
         BCS.S   .5
         BNE.S   .3
         ADDQ.W  #1,CHACNT(A5)
         MOVE.W  MTHEND(A5),D6
         BRA.S   .4
.3       MOVE.W  PNTR(A5),D6
         ADDQ.W  #1,D6
.4       BSR     FKYINB2
         BCS.S   .2
         TST.W   CHACNT(A5)
         BEQ.S   .1
         MOVE.L  SRCP(A5),-(A7)
         BSR     NML
         BEQ.S   .6
         BSR     LSTLA3
         MOVE.L  SRCP(A5),A3
.6       MOVE.L  A3,SRCP(A5)
         SUB.L   (A7)+,A3
         ADD.L   ENDP(A5),A3
         MOVE.L  A3,ENDP(A5)
         BRA.S   .1
.5       RTS
*--------------------------------
* Do Replace
*--------------------------------
DOREP    TST.B   AUTOFL(A5)
         BNE.S   .0
         BSR     PRAPRO
         BNE.S   .7
.0       MOVE.W  REPLEN(A5),D6
         SUB.W   SRCLEN(A5),D6
         BCS.S   .8
         BEQ.S   .4
         ADD.W   INBLEN(A5),D6
         BCS.S   .1
         CMP.W   #128,D6
         BLO.S   .2
.1       MOVEQ   #QREPLNG,D7
         BRA     HARDERR
.2       MOVE.W  INBLEN(A5),D7
         MOVE.W  D6,INBLEN(A5)
         LEA     INBUF(A5),A0
.3       MOVE.B  0(A0,D7.W),0(A0,D6.W)
         SUBQ.W  #1,D6
         SUBQ.W  #1,D7
         CMP.W   MTHEND(A5),D7
         BHS.S   .3
         ADDQ.W  #1,D6
         MOVE.W  D6,MTHEND(A5)
.4       MOVE.W  PNTR(A5),D6
         LEA     INBUF(A5),A0
         CLR.W   D7
         LEA     KBUF+40(A5),A1
.5       MOVE.B  0(A1,D7.W),D0
         BEQ.S   .6
         MOVE.B  D0,0(A0,D6.W)
         ADDQ.W  #1,D6
         ADDQ.W  #1,D7
         BRA.S   .5
.6       MOVEQ   #0,D0
.7       RTS
.8       MOVE.W  PNTR(A5),D6
         ADD.W   REPLEN(A5),D6
         MOVE.W  MTHEND(A5),D7
         MOVE.W  D6,MTHEND(A5)
         LEA     INBUF(A5),A0
.9       MOVE.B  0(A0,D7.W),0(A0,D6.W)
         ADDQ.W  #1,D7
         ADDQ.W  #1,D6
         CMP.W   INBLEN(A5),D6
         BLO.S   .9
         MOVE.W  D6,INBLEN(A5)
         BRA.S   .4
*--------------------------------
* Print and prompt
*--------------------------------
PRAPRO   MOVEQ   #$0D,D0
         BSR     CHO
         LEA     INBUF(A5),A1
         MOVEQ   #0,D6
.0       MOVE.B  0(A1,D6.W),D0
         BEQ.S   .4
         CMP.B   #$20,D0
         BLO.S   .3
         CMP.W   PNTR(A5),D6
         BLO.S   .2
         CMP.W   MTHEND(A5),D6
         BHS.S   .2
.1       MOVE.B  #1,CURS(A5)
.2       BSR     CHO
         CLR.B   CURS(A5)
.3       ADDQ.W  #1,D6
         BRA.S   .0
.4       MOVEQ   #QREPRMT,D7
         BSR     QTO
         MOVEQ   #$20,D0
         BSR     EOUTCH
         BSR     RDKEY
         BSR     CHO
         CMP.B   #'N,D0
         BEQ.S   .5
         CMP.B   #'Y,D0
         ORI     #1,CCR
         RTS
.5       LSR.B   #1,D0
         RTS
*--------------------------------
* Handle replace options
*--------------------------------
HNDROP   CLR.B   AUTOFL(A5)
         CLR.B   PRTFL(A5)
         CLR.B   LCFL(A5)
.1       BSR     GNNB
         BCS.S   .4
         CMP.B   #'A,D0
         BNE.S   .2
         MOVE.B  #1,AUTOFL(A5)
.2       CMP.B   #'P,D0
         BNE.S   .3
         MOVE.B  #1,PRTFL(A5)
.3       CMP.B   #'U,D0
         BNE.S   .1
         MOVE.B  #1,LCFL(A5)
         BRA.S   .1
.4       TST.B   PRTFL(A5)
         BEQ.S   .5
         BSR     INIPRT
.5       RTS
GETLN    BSR     GNB
         BSR     GNB
         MOVE.B  D0,CURLNL(A5)
         BSR     GNB
         MOVE.B  D0,CURLNL+1(A5)
         RTS
*--------------------------------
* Find start of line in INBUF
*--------------------------------
FSLINB   CLR.W   D7
.1       BSR     GNC2
         BCS.S   .2
         BSR     CHD
         BCS.S   .1
.2       MOVE.W  D7,D6
         RTS
*--------------------------------
* Move / Copy Lines
*--------------------------------
MOVE     MOVEQ   #1,D0
         BRA.S   MOVCOP
COPY     CLR.L   D0
MOVCOP   MOVE.B  D0,MOVFLG(A5)
         BSR     RANGE
.3       BSR     GNNB
         CMP.B   #',,D0
         BEQ.S   .3
         BSR     SCANLN
         BCS     SYNX
         MOVE.L  ENDP(A5),D1
         SUB.L   SRCP(A5),D1
         BCS     SYNX
         CMP.L   ENDP(A5),A2
         BHS.S   .0
         CMP.L   SRCP(A5),A2
         BHS     SYNX
         ADD.L   D1,SRCP(A5)
         ADD.L   D1,ENDP(A5)
.0       MOVE.L  A2,A1
         BSR     MVTEXT
         TST.L   D1
         BEQ.S   .2
         MOVE.L  SRCP(A5),A3
.1       MOVE.B  (A3)+,(A1)+
         SUBQ.L  #1,D1
         BNE.S   .1
.2       TST.B   MOVFLG(A5)
         BNE     DEL0
         RTS
*--------------------------------
* Renumber Lines
*--------------------------------
REN      MOVE.W  #10,PARAM0(A5)
         MOVE.W  #10,PARAM1(A5)
         MOVE.W  #0,PARAM2(A5)
         BSR     SCND
         BSR     SCND
         BSR     SCND
         MOVE.W  PARAM2(A5),D0
         MOVE.W  #-1,D1
         BSR     SERTXT
.0       CMP.L   EOS(A5),A1
         BHS.S   .1
         MOVE.B  PARAM0(A5),1(A1)
         MOVE.B  PARAM0+1(A5),2(A1)
         MOVE.W  PARAM1(A5),D0
         ADD.W   D0,PARAM0(A5)
         BCS.S   .2
         CLR.W   D0
         MOVE.B  (A1),D0
         ADD.W   D0,A1
         BRA.S   .0
.1       RTS
.2       MOVEQ   #QER3,D7
         BRA     HARDERR
*--------------------------------
SERIAL   MOVEQ   #QSERU,D7
         BSR     QTO
         MOVE.L  HSERN(PC),A0
         MOVE.L  (A0),A0
         MOVE.B  (A0)+,D0
         BSR     CHO
         MOVE.B  (A0)+,D0
         BSR     CHO
         MOVEQ   #'/,D0
         BSR     CHO
         MOVE.W  (A0)+,D0
         BSR     PRNT.W
         MOVEQ   #'-,D0
         BSR     CHO
         MOVE.B  (A0)+,D0
         BSR     PRNT.B
         MOVEQ   #QSERD,D7
         BSR     QTO
         BRA     CRLF
HSERN    DATA    0
*--------------------------------
