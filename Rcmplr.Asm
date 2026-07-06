;SAVE"Rcmplr.Asm"
*--------------------------------
*  Mac Resource Compiler
* Version 1.2    Nov 10, 1986
*--------------------------------
RCOMP    BSR     ClrVar
         CLR.L   -(SP)
         MOVE    #129,-(SP)
         CLR.L   -(SP)
         MOVE.L  #-1,-(SP)
         TBX     GetNewWindow
         MOVE.L  (SP),RCWindow(A5)
         TBX     SetPort
         CLR     -(SP)
         TBX     TextFont
         MOVE    #12,-(SP)
         TBX     TextSize
         CLR     -(SP)
         TBX     TextFace
         CLR     -(SP)
         TBX     TextMode
         MOVE    #10,-(SP)
         MOVE    #20,-(SP)
         TBX     MoveTo
         PEA     Line0(PC)
         TBX     DrawString
         MOVE    #10,-(SP)
         MOVE    #36,-(SP)
         TBX     MoveTo
         PEA     Line1(PC)
         TBX     DrawString
         MOVE    #10,-(SP)
         MOVE    #52,-(SP)
         TBX     MoveTo
         PEA     Line2(PC)
         TBX     DrawString
         TBX     InitCursor
         BSR     OpenSrc
         MOVEQ   #8,D1
         SUB.L   D1,A7
         MOVE.L  A7,A1
         BSR     GetB
         BNE     DosEro
         ADD.L   D1,A7
         BSR     ChkRSRC
         BNE     FatEro
         LEA     FILNAM(A5),A1
         BSR     GetStr
         LEA     fdType(A5),A1
         MOVEQ   #10,D1
         BSR     GetB
         BNE     DosEro
         BSR     Bound
         PEA     FILNAM(A5)
         TBX     DrawString
         BSR     OpenDst
Loop     BSR     ChkRSRC
         BNE     .0
         LEA     Len(A5),A1
         MOVEQ   #12,D1
         BSR     GetB
         BNE     DosEro
         LEA     FILNAM(A5),A1
         BSR     GetStr
         BSR     Bound
         BSR     DISPIT
         MOVE.L  Len(A5),D0
         OST     NWHandle
         MOVE    D0,D7
         BNE     DosEro
         MOVE.L  A0,Hndl(A5)
         MOVE.L  (A0),A1
         MOVE.L  Len(A5),D1
         BSR     GetB
         BNE     DosEro
         BSR     Bound
         MOVE.L  Hndl(A5),-(SP)
         MOVE.L  ResType(A5),-(SP)
         MOVE    ID(A5),-(SP)
         PEA     FILNAM(A5)
         TBX     AddResource
         MOVE    resErr,D7
         BNE     DosEro
         MOVE.L  Hndl(A5),-(SP)
         MOVE    Attrs(A5),-(SP)
         TBX     SetResAttrs
         MOVE    resErr,D7
         BNE     DosEro
         MOVE.L  Hndl(A5),-(SP)
         TBX     ChangedResData
         MOVE    resErr,D7
         BNE.S   DosEro
         BRA     Loop
.0       BSR     ClosFil
         MOVE.L  RCWindow(A5),-(SP)
         TBX     DisposWindow
         TBX     ExitToShell
*--------------------------------
* Display the error Box
*--------------------------------
FatEro   MOVEQ   #1,D7
DosEro   MOVE    D7,-(SP)
         BSR     ClosFil
         MOVE    (SP)+,D7
         BSR     IniErr
         CLR     -(SP)
         MOVE    #1,-(SP)
         CLR.L   -(SP)
         TBX     StopAlert
         TST     (SP)+
         TBX     ExitToShell
IniErr   LEA     TERR(PC),A0
         CLR     D0
.0       MOVE.B  (A0)+,D0
         BEQ.S   .2
         CMP.B   D0,D7
         BEQ.S   .1
         MOVE.B  (A0)+,D0
         ADD     D0,A0
         BRA.S   .0
.1       MOVE.L  A0,-(SP)
         CLR.L   -(SP)
         CLR.L   -(SP)
         CLR.L   -(SP)
         TBX     ParamText
         RTS
.2       MOVE    D7,D1
         NEG     D1
         BRA     DID
ESTR     MACRO
         DATA    #]1
         STR     "]2"
         ENDM
TERR     ESTR      1,"Fatal"
         ESTR    -33,"Directory full"
         ESTR    -34,"Disk full"
         ESTR    -36,"Disk I/O"
         ESTR    -43,"File not found"
         ESTR    -44,"Write protected disk"
         ESTR    -45,"File locked"
         ESTR    -46,"Volume locked"
         ESTR    -47,"File busy"
         ESTR   -108,"Memory full"
         ESTR      0,"File system"
         ADJST
*--------------------------------
* Clear Variable Area
*--------------------------------
ClrVar   LEA     VARB(A5),A0
         MOVE    #VAR.RLN,D0
         BRA.S   .1
.0       CLR.B   (A0)+
.1       DBRA    D0,.0
         RTS
*--------------------------------
* Open Source File
*--------------------------------
OpenSrc  MOVE.L  16(A5),A1
         MOVE.L  (A1),A1
         TST     2(A1)
         BEQ     FatEro
         CMP.L   #TYPBIN,6(A1)
         BNE     FatEro
         MOVE    4(A1),ioVRefNum(A5)
         MOVE.B  10(A1),ioVersNum(A5)
         LEA     12(A1),A1
         LEA     PARABLK(A5),A0
         CLR.L   12(A0)
         CLR.L   18(A0)
         MOVE    ioVRefNum(A5),22(A0)
         OST     SetVol
         MOVE    16(A0),D7
         BNE     DosEro
         MOVEQ   #1,D0
         BSR     OpnFil
         MOVE    D0,ioRefNum.Src(A5)
         MOVE.B  #1,F.Src(A5)
         TST     D7
         BNE     DosEro
         RTS
*--------------------------------
* Open Destination File
*--------------------------------
OpenDst  LEA     FILNAM(A5),A1
         BSR     DelTFl
         PEA     FILNAM(A5)
         TBX     CreateResFile
         MOVE    resErr,D7
         BEQ.S   .0
         CMP     #-43,D7
         BNE     DosEro
         SUBQ    #1,D7
         BRA     DosEro
.0       LEA     FILNAM(A5),A1
         BSR     GetInfo
         MOVE.L  fdType(A5),32(A0)
         MOVE.L  fdCreator(A5),36(A0)
         MOVE    fdFlags(A5),D0
         OR      D0,40(A0)
         OST     SetFileInfo
         MOVE    16(A0),D7
         BNE     DosEro
         CLR     -(SP)
         PEA     FILNAM(A5)
         TBX     OpenResFile
         MOVE    (SP)+,ioRefNum.Dst(A5)
         MOVE.B  #1,F.Dst(A5)
         MOVE    resErr,D7
         BNE     DosEro
         RTS
*--------------------------------
* Get Block from Source File
* A1=Address  D1=Length
*--------------------------------
GetB     LEA     PARABLK(A5),A0
         CLR.L   12(A0)
         MOVE    ioRefNum.Src(A5),24(A0)
         MOVE.L  A1,32(A0)
         MOVE.L  D1,36(A0)
         CLR     44(A0)
         CLR.L   46(A0)
         OST     Read
         ADD.L   D1,TotLen(A5)
         MOVE    16(A0),D7
         RTS
*--------------------------------
* Check for "RSRC"
*--------------------------------
ChkRSRC  MOVEQ   #4,D1
         CLR.L   -(SP)
         MOVE.L  A7,A1
         BSR     GETB
         CMP.L   #$52535243,(SP)+
         RTS
*--------------------------------
* Get String
*--------------------------------
GetStr   MOVEQ   #1,D1
         BSR     GetB
         BNE     DosEro
         MOVE.B  (A1)+,D1
         BEQ.S   .0
         BSR     GetB
         BNE     DosEro
.0       RTS
*--------------------------------
* Make the Address Even
*--------------------------------
Bound    MOVE.L  TotLen(A5),D0
         BTST    #0,D0
         BEQ.S   .0
         MOVEQ   #1,D1
         SUBQ.L  #2,A7
         MOVE.L  A7,A1
         BSR     GetB
         BNE     DosEro
         ADDQ.L  #2,A7
.0       RTS
*--------------------------------
* Setup Parablk
*--------------------------------
StPar    LEA     PARABLK(A5),A0
         CLR.L   12(A0)
         MOVE.L  A1,18(A0)
         MOVE    ioVRefNum(A5),22(A0)
         MOVE.B  ioVersNum(A5),26(A0)
         RTS
*--------------------------------
* Open text file
*--------------------------------
OpnFil   BSR     StPar
         MOVE.B  D0,27(A0)
         CLR.L   28(A0)
         OST     Open
         MOVE    24(A0),D0
         MOVE    16(A0),D7
         RTS
*--------------------------------
* Close File
*--------------------------------
CloseFl  LEA     PARABLK(A5),A0
         CLR.L   12(A0)
         MOVE    D0,24(A0)
         OST     Close
         MOVE    16(A0),D7
         BNE     DosEro
         CLR.L   18(A0)
         MOVE    ioVRefNum(A5),22(A0)
         OST     FlushVol
         MOVE    16(A0),D7
         BNE     DosEro
         RTS
*--------------------------------
* Close All Files
*--------------------------------
ClosFil  TST.B   F.Dst(A5)
         BEQ.S   .0
         CLR.B   F.Dst(A5)
         MOVE    ioRefNum.Dst(A5),-(SP)
         TBX     CloseResFile
         MOVE    resErr,D7
         BNE     DosEro
.0       TST.B   F.Src(A5)
         BEQ.S   .1
         CLR.B   F.Src(A5)
         MOVE    ioRefNum.Src(A5),D0
         BSR.S   CloseFl
.1       RTS
*--------------------------------
* Get File Info
*--------------------------------
GetInfo  BSR     StPar
         CLR     28(A0)
         OST     GetFileInfo
         MOVE    16(A0),D7
         BNE     DosEro
         RTS
*--------------------------------
* Delete File
*--------------------------------
DelTFl   BSR     StPar
         CLR     28(A0)
         OST     GetFileInfo
         MOVE    16(A0),D7
         BEQ.S   .0
         CMP     #-43,D7
         BEQ.S   .1
         BRA     DosEro
.0       MOVE    #-45,D7
         BTST    #7,40(A0)
         BNE     DosEro
         OST     FileDelete
         MOVE    16(A0),D7
         BNE     DosEro
.1       RTS
*--------------------------------
DTYPE    MOVEQ   #4-1,D1
.0       ROL.L   #8,D0
         CMP.B   #$20,D0
         BHS.S   .1
         MOVE.B  #$20,D0
.1       BSR     CHOUT
         DBRA    D1,.0
         RTS
DID      MOVEQ   #1,D2
         MOVE.W  D1,D3
         MOVEQ   #5,D5
         LEA     PLNTBL(PC),A0
.0       MOVEQ   #'0,D0
.1       MOVE.W  D3,D4
         SUB.W   (A0),D4
         BCS.S   .2
         MOVE.W  D4,D3
         ADDQ.B  #1,D0
         BRA.S   .1
.2       CMP.B   #'0,D0
         BNE.S   .3
         CMP.B   D5,D2
         BLO.S   .4
.3       MOVEQ   #5,D2
         BSR     CHOUT
.4       ADDQ.L  #2,A0
         SUBQ.B  #1,D5
         BNE.S   .0
         RTS
PLNTBL   DATA    /10000
         DATA    /1000
         DATA    /100
         DATA    /10
         DATA    /1
CHOUT    MOVEM.L D0-D5/A0,-(A7)
         MOVE.W  D0,-(A7)
         TBX     DrawChar
         MOVEM.L (A7)+,D0-D5/A0
         RTS
DISPIT   MOVE    #10,-(SP)
         MOVE    #68,-(SP)
         TBX     MoveTo
         MOVE.L  ResType(A5),D0
         BSR     DTYPE
         MOVEQ   #$20,D0
         BSR     CHOUT
         MOVE    ID(A5),D1
         BPL.S   .0
         MOVEQ   #'-,D0
         BSR     CHOUT
         NEG     D1
.0       BSR     DID
         MOVEQ   #5,D1
         MOVEQ   #$20,D0
.1       BSR     CHOUT
         DBRA    D1,.1
         RTS
*--------------------------------
Line0    STR     "Resource Compiler   V1.2"
Line1    STR     "By  Y. Lempereur"
Line2    STR     "Name: "
*--------------------------------
         END
