;SAVE"Diskio.Asm"
*--------------------------------
DOS      TBX     ExitToShell
*--------------------------------
* Directory
*--------------------------------
DIRECT   CLR.W   PARAM0(A5)
         BSR     SCND
         TST.W   D1
         BEQ.S   .0
         MOVE.W  PARAM0(A5),D0
         BEQ     SYNX
         CMP.W   #8,D0
         BHI     SYNX
.0       BSR     HNDROP
         LEA     PARABLK(A5),A0
         CLR.L   12(A0)
         LEA     FILNAM(A5),A1
         MOVE.L  A1,18(A0)
         MOVE.W  PARAM0(A5),22(A0)
         CLR.W   28(A0)
         OST     GetVolInfo
         MOVE.W  16(A0),D7
         BNE     DOSERR
         BSR     DLINE
         MOVEQ   #QVOLNAM,D7
         BSR     QTO
         BSR     DISNAM
         MOVEQ   #$0D,D0
         BSR     CHO
         CLR.L   D1
         MOVE.W  40(A0),D1
         BSR     DISNUM
         MOVEQ   #QNFILES,D7
         BSR     QTO
         CLR.L   D1
         MOVE.W  62(A0),D1
         BSR     DISNUM
         MOVEQ   #QBFREE,D7
         BSR     QTO
LAB0     MOVEQ   #QFLNAM,D7
         BSR     QTO
         MOVEQ   #36,D1
         BSR     HTAB
         MOVEQ   #QTIT,D7
         BSR     QTO
         BSR     DLINE
         CLR.L   12(A0)
         LEA     FILNAM(A5),A1
         MOVE.L  A1,18(A0)
         MOVE    PARAM0(A5),22(A0)
         CLR.B   26(A0)
         CLR     28(A0)
.1       ADDQ    #1,28(A0)
         OST     GetFileInfo
         MOVE    16(A0),D7
         BNE     .3
         MOVE.L  A0,-(A7)
         BSR     CRLF
         MOVE.L  (A7)+,A0
         MOVEQ   #$20,D0
         BTST    #7,40(A0)
         BEQ.S   .2
         MOVEQ   #'*,D0
.2       BSR     CHO
         MOVEQ   #$20,D0
         BSR     CHO
         BSR     DISNAM
         MOVEQ   #36,D1
         BSR     HTAB
         MOVE.L  32(A0),D0
         BSR     DMES
         MOVEQ   #42,D1
         BSR     HTAB
         MOVE.L  36(A0),D0
         BSR     DMES
         MOVEQ   #50,D1
         BSR     HTAB
         MOVEQ   #'$,D0
         BSR     CHO
         MOVE.L  54(A0),D0
         BSR     PRNT.A
         MOVEQ   #60,D1
         BSR     HTAB
         MOVEQ   #'$,D0
         BSR     CHO
         MOVE.L  64(A0),D0
         BSR     PRNT.A
         MOVEQ   #70,D1
         BSR     HTAB
         MOVE.L  54(A0),D1
         ADD.L   64(A0),D1
         ADD.L   #$3FF,D1
         MOVEQ   #10,D0
         LSR.L   D0,D1
         MOVEQ   #3,D2
         BSR     CMMN
         MOVEQ   #'K,D0
         BSR     CHO
         BRA     .1
.3       CMP     #-43,D7
         BNE     DOSERR
         RTS
*--------------------------------
* Disk Ejection
*--------------------------------
EJECTD   CLR.W   PARAM0(A5)
         BSR     SCND
         TST.W   D1
         BEQ.S   .0
         MOVE.W  PARAM0(A5),D0
         BEQ     SYNX
         CMP.W   #8,D0
         BHI     SYNX
.0       LEA     PARABLK(A5),A0
         CLR.L   12(A0)
         CLR.L   18(A0)
         MOVE.W  PARAM0(A5),22(A0)
         OST     Eject
         MOVE.W  16(A0),D7
         BNE     DOSERR
         RTS
*--------------------------------
* Extract Filename
* YES  CC
* NO   CS
*--------------------------------
GETNAM   LEA     FILNAM(A5),A1
         CLR.B   (A1)+
         BSR     GNNB
         BCS.S   .2
         CMP.B   #'",D0
         BEQ.S   .0
         BSR     BACKCHR
.0       BSR     GNC
         BCS.S   .1
         CMP.B   #'",D0
         BEQ.S   .1
         MOVE.B  D0,(A1)+
         ADDQ.B  #1,FILNAM(A5)
         BRA.S   .0
.1       ANDI    #$FE,CCR
.2       RTS
*--------------------------------
* Disk Character OUT
*--------------------------------
DOUT     MOVEM.L D0/D7/A0,-(A7)
         LEA     PARABLK(A5),A0
         CLR.L   12(A0)
         MOVE.W  D5,24(A0)
         MOVE.B  D0,-(A7)
         MOVE.L  A7,32(A0)
         MOVE.L  #1,36(A0)
         CLR.W   44(A0)
         CLR.L   46(A0)
         OST     Write
         MOVE.W  16(A0),D7
         BNE     DOSERR
         MOVE.B  (A7)+,D0
         MOVEM.L (A7)+,D0/D7/A0
         RTS
*--------------------------------
* Disk Character IN
*--------------------------------
DIN      MOVEM.L A0,-(A7)
         LEA     PARABLK(A5),A0
         CLR.L   12(A0)
         MOVE.W  INCL.IO(A5),24(A0)
         SUBQ.L  #2,A7
         MOVE.L  A7,32(A0)
         MOVE.L  #1,36(A0)
         CLR.W   44(A0)
         CLR.L   46(A0)
         OST     Read
         MOVE.B  (A7)+,D0
         MOVE.W  16(A0),D7
         MOVEM.L (A7)+,A0
         RTS
*--------------------------------
* Setup Parablk
*--------------------------------
SETPAR   LEA     PARABLK(A5),A0
         CLR.L   12(A0)
         LEA     FILNAM(A5),A1
         MOVE.L  A1,18(A0)
         CLR.W   22(A0)
         CLR.B   26(A0)
         RTS
*--------------------------------
* Open text file
*--------------------------------
OPNTFIL  BSR     SETPAR
         MOVE.B  D0,27(A0)
         CLR.L   28(A0)
         OST     Open
         MOVE.W  24(A0),D0
         MOVE.W  16(A0),D7
         RTS
*--------------------------------
* Close File
*--------------------------------
CLOSEF   LEA     PARABLK(A5),A0
         CLR.L   12(A0)
         MOVE.W  D0,24(A0)
         OST     Close
         MOVE.W  16(A0),D7
         BNE     DOSERR
         CLR.L   18(A0)
         CLR.W   22(A0)
         OST     FlushVol
         MOVE.W  16(A0),D7
         BNE     DOSERR
         RTS
*--------------------------------
* Close All Files
*--------------------------------
CLOSFILE TST.B   F.ENTR(A5)
         BEQ.S   .0
         CLR.B   F.ENTR(A5)
         MOVE.W  ENTR.IO(A5),D0
         BSR.S   CLOSEF
.0       TST.B   F.TEXT(A5)
         BEQ.S   .1
         CLR.B   F.TEXT(A5)
         MOVE.W  TEXT.IO(A5),D0
         BSR.S   CLOSEF
.1       TST.B   F.SVLO(A5)
         BEQ.S   .2
         CLR.B   F.SVLO(A5)
         MOVE.W  SVLO.IO(A5),D0
         BSR.S   CLOSEF
.2       TST.B   F.INCL(A5)
         BEQ.S   .3
         CLR.B   F.INCL(A5)
         MOVE.W  INCL.IO(A5),D0
         BSR.S   CLOSEF
.3       TST.B   F.TFIO(A5)
         BEQ.S   .4
         CLR.B   F.TFIO(A5)
         MOVE.W  TF.IO(A5),D0
         BSR.S   CLOSEF
.4       RTS
*--------------------------------
* Create File
*--------------------------------
CREATEF  BSR     SETPAR
         OST     FileCreate
         MOVE.W  16(A0),D7
         BNE     DOSERR
*--------------------------------
* Get File Info
*--------------------------------
GETINF   BSR     SETPAR
         CLR.W   28(A0)
         OST     GetFileInfo
         MOVE.W  16(A0),D7
         BNE     DOSERR
         RTS
*--------------------------------
* Enter
*--------------------------------
ENTER    TST.B   F.ENTR(A5)
         BEQ.S   .0
         BSR     CLOSE.TXT
.0       BSR     GETNAM
         BCS     SYNX
ENTER0   BSR     GETINF
         MOVEQ   #QFTM,D7
         CMP.L   #TYPTXT,32(A0)
         BNE     HARDERR
         MOVEQ   #1,D0
         BSR     OPNTFIL
         MOVE.W  D0,ENTR.IO(A5)
         MOVE.B  #1,F.ENTR(A5)
         TST.W   D7
         BNE     DOSERR
         BRA     GNL
*--------------------------------
* Delete File
*--------------------------------
DELTF    BSR     SETPAR
         CLR.W   28(A0)
         OST     GetFileInfo
         MOVE.W  16(A0),D7
         BEQ.S   .0
         CMP.W   #-43,D7
         BEQ.S   .1
         BRA     DOSERR
.0       MOVE.W  #-45,D7
         BTST    #7,40(A0)
         BNE     DOSERR
         OST     FileDelete
         MOVE.W  16(A0),D7
         BNE     DOSERR
.1       RTS
*--------------------------------
* Text
*--------------------------------
TEXT     BSR     GETNAM
         BCS     SYNX
         CLR.B   AUTOFL(A5)
         BSR     GNNB
         CMP.B   #'#,D0
         BNE.S   .5
         MOVE.B  #1,AUTOFL(A5)
.5       BSR     DELTF
         BSR     CREATEF
         MOVE.L  #TYPTXT,32(A0)
         MOVE.L  #CREAT,36(A0)
         OST     SetFileInfo
         MOVE.W  16(A0),D7
         BNE     DOSERR
         MOVEQ   #2,D0
         BSR     OPNTFIL
         MOVE.W  D0,TEXT.IO(A5)
         MOVE.B  #1,F.TEXT(A5)
         TST.W   D7
         BNE     DOSERR
         BSR     SETUP
.1       MOVE.L  SRCP(A5),A3
         CMP.L   ENDP(A5),A3
         BHS.S   .4
         BSR     GETLN
         TST.B   AUTOFL(A5)
         BNE.S   .3
         CLR.L   D1
         MOVE.W  CURLNL(A5),D1
         BSR     CNVLP
         MOVEQ   #$20,D0
.2       BSR     CHO
.3       BSR     NTKN
         BNE.S   .2
         MOVEQ   #$0D,D0
         BSR     CHO
         BRA.S   .1
.4       MOVE.W  TEXT.IO(A5),D0
         BSR     CLOSEF
         CLR.B   F.TEXT(A5)
         BRA     SOFT
*--------------------------------
* Save Source
*--------------------------------
SAVE     BSR     GETNAM
         BCS     SYNX
         BSR     DELTF
         BSR     CREATEF
         MOVE.L  #TYPSRC,32(A0)
         MOVE.L  #CREAT,36(A0)
         OST     SetFileInfo
         MOVE.W  16(A0),D7
         BNE     DOSERR
         MOVE.L  EOS(A5),D1
         SUB.L   LOMEM(A5),D1
         BEQ.S   .0
         MOVEQ   #2,D0
         BSR     OPNTFIL
         MOVE.W  D0,SVLO.IO(A5)
         MOVE.B  #1,F.SVLO(A5)
         TST.W   D7
         BNE     DOSERR
         MOVE.L  D1,-(A7)
         MOVEQ   #4,D1
         MOVE.L  A7,A1
         MOVE.W  SVLO.IO(A5),D5
         BSR     WRTREC
         MOVE.L  (A7)+,D1
         MOVE.L  LOMEM(A5),A1
         BSR     WRTREC
         MOVE.W  SVLO.IO(A5),D0
         BSR     CLOSEF
         CLR.B   F.SVLO(A5)
.0       RTS
*--------------------------------
WRTREAD  LEA     PARABLK(A5),A0
         CLR.L   12(A0)
         MOVE.W  D5,24(A0)
         MOVE.L  A1,32(A0)
         MOVE.L  D1,36(A0)
         CLR.W   44(A0)
         CLR.L   46(A0)
         RTS
*--------------------------------
* Write Record
*--------------------------------
WRTREC   BSR     WRTREAD
         OST     Write
         MOVE.W  16(A0),D7
         BNE     DOSERR
         RTS
*--------------------------------
* Read Record
*--------------------------------
READREC  BSR     WRTREAD
         OST     Read
         MOVE.W  16(A0),D7
         BNE     DOSERR
         RTS
*--------------------------------
* Load File
*--------------------------------
LOAD     MOVE.L  LOMEM(A5),EOS(A5)
         MOVE.L  EOS(A5),EOT(A5)
         CLR.B   F.SYMTB(A5)
APPEND   BSR     GETNAM
         BCS     SYNX
LOAD0    BSR     GETINF
         MOVEQ   #QFTM,D7
         CMP.L   #TYPSRC,32(A0)
         BNE     HARDERR
         MOVEQ   #1,D0
         BSR     OPNTFIL
         MOVE.W  D0,SVLO.IO(A5)
         MOVE.B  #1,F.SVLO(A5)
         TST.W   D7
         BNE     DOSERR
         SUBQ.L  #4,A7
         MOVEQ   #4,D1
         MOVE.L  A7,A1
         MOVE.W  SVLO.IO(A5),D5
         BSR     READREC
         MOVE.L  (A7)+,D1
         MOVE.L  EOS(A5),D2
         ADD.L   D1,D2
         CMP.L   HIMEM(A5),D2
         BHS.S   .0
         MOVE.L  EOS(A5),EOT(A5)
         CLR.B   F.SYMTB(A5)
         MOVE.L  EOS(A5),A1
         BSR     READREC
         MOVE.W  SVLO.IO(A5),D0
         BSR     CLOSEF
         CLR.B   F.SVLO(A5)
         MOVE.L  D2,EOS(A5)
         MOVE.L  D2,EOT(A5)
         CLR.B   F.SYMTB(A5)
         RTS
.0       MOVEQ   #QMEMFL,D7
         BRA     HARDERR
*--------------------------------
* Auto Start
*--------------------------------
AUTOSTR  TST.B   ATSTR(A5)
         BNE.S   .1
         MOVE.B  #1,ATSTR(A5)
         MOVE.L  16(A5),A4
         MOVE.L  (A4),A4
         TST     2(A4)
         BEQ.S   .1
         LEA     PARABLK(A5),A0
         CLR.L   12(A0)
         CLR.L   18(A0)
         MOVE    4(A4),22(A0)
         OST     SetVol
         LEA     FILNAM(A5),A0
         LEA     12(A4),A1
         CLR     D0
         MOVE.B  (A1),D0
.0       MOVE.B  (A1)+,(A0)+
         DBRA    D0,.0
         CMP.L   #TYPSRC,6(A4)
         BEQ     LOAD0
         CMP.L   #TYPTXT,6(A4)
         BEQ     ENTER0
.1       RTS
*--------------------------------
* Binary File Load
*--------------------------------
BLOAD    BSR     GETNAM
         BCS     SYNX
         BSR     GETINF
         MOVEQ   #QFTM,D7
         CMP.L   #TYPBIN,32(A0)
         BNE     HARDERR
         MOVEQ   #1,D0
         BSR     OPNTFIL
         MOVE.W  D0,SVLO.IO(A5)
         MOVE.B  #1,F.SVLO(A5)
         TST.W   D7
         BNE     DOSERR
.0       SUBQ.L  #8,A7
         MOVEQ   #8,D1
         MOVE.L  A7,A1
         MOVE.W  SVLO.IO(A5),D5
         BSR     WRTREAD
         OST     Read
         MOVE.L  (A7)+,A1
         MOVE.L  (A7)+,D1
         MOVE.W  16(A0),D7
         BNE.S   .1
         SUB.L   A1,D1
         ADDQ.L  #1,D1
         BSR     READREC
         BRA.S   .0
.1       CMP.W   #-39,D7
         BNE     DOSERR
         MOVE.W  SVLO.IO(A5),D0
         BSR     CLOSEF
         CLR.B   F.SVLO(A5)
         RTS
*--------------------------------
* Binary File Save
*--------------------------------
BSAVE    BSR     GETNAM
         BCS     SYNX
         BSR     GNC
         CMP.B   #',',D0
         BNE     SYNX
         BSR     EXPDFND
         MOVE.L  D1,-(A7)
         BSR     GNC
         CMP.B   #',',D0
         BNE     SYNX
         BSR     EXPDFND
         MOVE.L  (A7)+,D0
         CMP.L   D0,D1
         BLO     RAER
         MOVE.L  D1,-(A7)
         MOVE.L  D0,-(A7)
         BSR     DELTF
         BSR     CREATEF
         MOVE.L  #TYPBIN,32(A0)
         MOVE.L  #CREAT,36(A0)
         OST     SetFileInfo
         MOVE.W  16(A0),D7
         BNE     DOSERR
         MOVEQ   #2,D0
         BSR     OPNTFIL
         MOVE.W  D0,SVLO.IO(A5)
         MOVE.B  #1,F.SVLO(A5)
         TST.W   D7
         BNE     DOSERR
         MOVEQ   #8,D1
         MOVE.L  A7,A1
         MOVE.W  SVLO.IO(A5),D5
         BSR     WRTREC
         MOVE.L  (A7)+,A1
         MOVE.L  (A7)+,D1
         SUB.L   A1,D1
         ADDQ.L  #1,D1
         BSR     WRTREC
         MOVE.W  SVLO.IO(A5),D0
         BSR     CLOSEF
         CLR.B   F.SVLO(A5)
         RTS
*--------------------------------
