;SAVE"Init.Asm"
*--------------------------------
INIT     TBX     InitCursor
         BSR     SERNCHK
         CLR.L   -(A7)
         MOVE.W  #128,-(A7)
         CLR.L   -(A7)
         MOVE.L  #-1,-(A7)
         TBX     GetNewWindow
         TBX     SetPort
         TBX     HideCursor
         LEA     VARB(A5),A0
         MOVE.W  #VAR.RLN,D0
         BRA.S   .1
.0       CLR.B   (A0)+
.1       DBRA    D0,.0
         BSR     INITSC
INIT0
         BSR     OPNPRT
         MOVE.L  A7,SAVESP(A5)
         OST     MaxMem
         ADD.L   A0,D0
         CMP.L   #RESHEAP,D0
         BLO     SYSERR
         SUB.L   #RESHEAP,D0
         MOVE.L  D0,-(A7)
         OST     NewPtr
         BNE     SYSERR
         MOVE.L  A0,LOMEM(A5)
         ADDA.L  (A7)+,A0
         SUBQ.L  #1,A0
         MOVE.L  A0,HIMEM(A5)
         BRA     HARD
OPNPRT   LEA     PARPRT(A5),A0
         LEA     BIN(PC),A1
         MOVE.L  A1,18(A0)
         CLR.B   27(A0)
         OST     Open
         MOVE.W  16(A0),D7
         BNE     PRTERR
         LEA     BOUT(PC),A1
         MOVE.L  A1,18(A0)
         OST     Open
         MOVE.W  16(A0),D7
         BNE     PRTERR
         MOVE.W  24(A0),REFPRT(A5)
         MOVE.W  #8,26(A0)
         MOVE.W  #$CC0A,28(A0)
         OST     Control
         MOVE    #$0A,26(A0)
         MOVE.L  #$FFFF1113,28(A0)
         CLR.L   32(A0)
         OST     Control
         OST     KillIO
         RTS
INIPRT   LEA     PARPRT(A5),A0
         LEA     PRTAB(PC),A1
         MOVE.L  A1,32(A0)
         MOVE.L  #14,36(A0)
         MOVE.W  REFPRT(A5),24(A0)
         CLR.W   44(A0)
         CLR.L   46(A0)
         OST     Write
         MOVE.W  16(A0),D0
         RTS
PRTBYT   CMP.B   #$09,D0
         BNE.S   .0
         MOVEQ   #$20,D0
.0       LEA     PARPRT(A5),A0
         MOVE.B  D0,-(A7)
         MOVE.L  A7,32(A0)
         MOVE.L  #1,36(A0)
         MOVE.W  REFPRT(A5),24(A0)
         CLR.W   44(A0)
         CLR.L   46(A0)
         OST     Write
         ADDQ.L  #2,A7
         MOVE.W  16(A0),D0
         RTS
PRTERR   MOVEQ   #QD33-33,D0
         SUB.W   D7,D0
         MOVE.W  D0,D7
         CMP.W   #QD33,D7
         BLO.S   .0
         CMP.W   #QD61,D7
         BLS.S   .1
.0       MOVEQ   #QDOSERR,D7
.1       BSR     PRTERRM
         BRA     SYSERR
PRTAB    HEX     1B448000 ; Auto Line Feed
         HEX     1B42     ; 8 LPI
         HEX     1B5A0700 ; American
         HEX     1B440001 ; Slashed zeros
BIN      STR     ".BIn"
BOUT     STR     ".BOut"
         ADJST
KGETCH   SUBQ.L  #2,A7
         MOVE.W  #$00A9,-(A7)
         PEA     EVNTRC(A5)
         TBX     GetNextEvent
         MOVE.B  (A7)+,D0
         BEQ.S   KGETCH
         MOVE.W  WHAT(A5),D0
         CMP.W   #7,D0
         BEQ.S   .1
         CMP.W   #3,D0
         BEQ.S   .0
         CMP.W   #5,D0
         BNE.S   KGETCH
.0       MOVE.L  MESS(A5),D0
         BSR.S   CMND
         LEA     ATACHR(A5),A0
         MOVE.B  D0,(A0)
         RTS
.1       MOVE.W  MESS(A5),D0
         BNE.S   .2
         LEA     PARABLK(A5),A0
         CLR.L   12(A0)
         CLR.L   18(A0)
         MOVE.W  MESS+2(A5),22(A0)
         OST     SetVol
         MOVE.W  16(A0),D0
         BEQ.S   KGETCH
.2       MOVE.W  D0,D7
         BRA     DOSERR
CMND     CMP.B   #$03,D0
         BNE.S   .5
         MOVE.B  #$0D,D0
.5       CMP.B   #$1B,D0
         BNE.S   .0
         MOVE.B  #$0C,D0
.0       MOVE.W  MODIF(A5),D1
         BTST    #8,D1
         BEQ.S   .4
         BTST    #9,D1
         BNE.S   .1
         LEA     TBKEY(PC),A0
         BRA.S   .2
.1       LEA     TBKEYS(PC),A0
.2       CMP.B   #$FF,(A0)
         BEQ.S   .4
         CMP.B   (A0)+,D0
         BEQ.S   .3
         ADDQ.L  #1,A0
         BRA.S   .2
.3       MOVE.B  (A0),D0
.4       RTS
TBKEY    HEX     300C880C8E0C            ;Clear
         HEX     2D1767174717            ;Delete
         HEX     3D1868184818            ;Insert
         HEX     2C1C691C491C            ;Left
         HEX     2E1D6F1D4F1D            ;Right
         HEX     6B1E4B1E                ;Up
         HEX     6C1F4C1F                ;Down
         HEX     381670165016            ;Rem
         HEX     FF
TBKEYS   HEX     2D1967194719            ;Delete
         HEX     3D1A681A481A            ;Insert
         HEX     2C1C691C491C            ;Left
         HEX     2E1D6F1D4F1D            ;Right
         HEX     6B1E4B1E                ;Up
         HEX     6C1F4C1F                ;Down
         HEX     FF
*--------------------------------
