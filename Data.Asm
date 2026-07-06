;SAVE"Data.Asm"
*--------------------------------
TYPAPL   EQU     $4150504C
TYPSRC   EQU     $5941534D
TYPBIN   EQU     $5942494E
TYPTXT   EQU     $54455854
CREAT    EQU     $4D41534D
*--------------------------------
         GLOBAL  1258,$CE
*--------------------------------
         DEFV    0,VARB          ; Start of Variable Area
         DEFV    L,SAVESP        ; Initial SP
         DEFV    L,LOMEM         ; Low MEM Bound
         DEFV    L,HIMEM         ; High MEM Bound
         DEFV    L,EOS           ; End of Source
         DEFV    L,EOT           ; End of Symbol Table
         DEFV    L,MJRLBL        ; Major Label Pointer
         DEFV    L,ADDLBL        ; Address of last Label
         DEFV    L,MACSTK        ; Macro Stack pointer
         DEFV    L,SRCP          ; Start of block
         DEFV    L,ENDP          ; End of block
         DEFV    L,KEYADDR       ; Key Buffer selection
         DEFV    L,ORGN          ; Origin
         DEFV    L,TRGT          ;
         DEFV    L,INSAVE        ;
         DEFV    L,SRCPSAV       ;
         DEFV    L,OPTPTR        ;
         DEFV    L,DISP          ;
         DEFV    L,EXTSAVE       ;
         DEFV    L,PATHBUF       ;
         DEFV    L,RS.ADD        ;
         DEFV    W,CURLNI        ; Curr. Line # Input
         DEFV    W,CURLNL        ; Curr. Line # List
         DEFV    W,CHRPTR        ; Char Ptr in INBUF
         DEFV    W,SVCHPTR       ;
         DEFV    W,INCREM        ; Increment
         DEFV    W,ENTR.IO       ; "Enter" ioRefNum
         DEFV    W,PARAM0        ; Parameter stack
         DEFV    W,PARAM1        ;    "        "
         DEFV    W,PARAM2        ;    "        "
         DEFV    W,PNTR          ; Key pointer
         DEFV    W,KYPNTR        ; Key pointer
         DEFV    W,BFPNTR        ; Buffer pointer
         DEFV    W,MTHEND        ; Match End
         DEFV    W,REPLEN        ; Replace Length
         DEFV    W,SRCLEN        ; Source Length
         DEFV    W,INBLEN        ; INBUF Length
         DEFV    W,CHACNT        ; Change count
         DEFV    W,REFPRT        ;
         DEFV    W,TEXT.IO       ; "Text" IORefNum
         DEFV    W,SVLO.IO       ; Save/Load IORefNum
         DEFV    W,PARLVL        ; Parent. Level
         DEFV    W,CALCNT        ;
         DEFV    W,CALNUM        ; Call Number
         DEFV    W,PARPTR        ;
         DEFV    W,INCL.IO       ; Include IORefNum
         DEFV    W,BCNT          ;
         DEFV    W,ERRCNT        ;
         DEFV    W,PGLEN         ;
         DEFV    W,PGNUM         ;
         DEFV    W,LINCNT        ;
         DEFV    W,DOINDX        ;
         DEFV    W,SKPCNT        ;
         DEFV    W,TF.IO         ;
         DEFV    W,OPCODE        ;
         DEFV    W,SAM           ;
         DEFV    W,DAM           ;
         DEFV    W,TYPE          ;
         DEFV    W,REGLST        ;
         DEFV    W,RS.CNT        ;
         DEFV    B,ATSTR         ; Auto start flag
         DEFV    B,F.ENTR        ; Flag "Enter" Mode
         DEFV    B,CURCHR        ; Current Char read in INBUF
         DEFV    B,RPTCNT        ; Repeat counter
         DEFV    B,RPTCHR        ; Repeat Character
         DEFV    B,AUTOFL        ; Auto replace flag
         DEFV    B,PRTFL         ; Printer flag
         DEFV    B,LCFL          ; Lower-case flag
         DEFV    B,MOVFLG        ; Move/Copy Flag
         DEFV    B,F.TEXT        ; Flag "Text" Mode
         DEFV    B,F.SVLO        ; Flag "Save/Load" Mode
         DEFV    B,LAST          ; Last Atom type
         DEFV    B,F.SYMTB       ; Symbol Table Flag
         DEFV    B,EXPFWD        ; Forward ref. flag
         DEFV    B,EXPUDF        ; Undefined label flag
         DEFV    B,PASS          ;
         DEFV    B,F.MACRO       ;
         DEFV    B,MACLVL        ;
         DEFV    B,F.INCL        ; Flag "Include" Mode
         DEFV    B,F.LIST        ;
         DEFV    B,F.MLIST       ;
         DEFV    B,F.ERR         ;
         DEFV    B,DOSTAT        ;
         DEFV    B,F.TF          ;
         DEFV    B,F.TFIO        ;
         DEFV    B,OBJBYTE       ;
         DEFV    B,DLIM          ;
         DEFV    B,ATHIBIT       ;
         DEFV    B,ASHIBIT       ;
         DEFV    B,PARCNT        ;
         DEFV    B,TF.CNT        ;
         DEFV    B,SIZE          ;
         DEFV    B,EXTSZ         ;
         DEFV    B,EXTSZSRC      ;
         DEFV    B,FLAG1         ;
         DEFV    B,FLAG2         ;
         DEFV    B,FLAG3         ;
         DEFV    B,MODEREG       ;
         DEFV    B,RAERFL        ;
         DEFV    B,UNDFL         ;
         DEFV    B,F.RS          ;
         ADJSTV
*--------------------------------
         DEFV    0,EVNTRC
         DEFV    W,WHAT
         DEFV    L,MESS
         DEFV    L,WHEN
         DEFV    L,WHERE
         DEFV    W,MODIF
*--------------------------------
         DEFV    W,STPTR1
         DEFV    W,STPTR2
         DEFV    16*4,STACK1
         DEFV    16*2,STACK2
         DEFV    44,SYMBOL
         DEFV    28*4,HSHTBL     ; Hash Table
         DEFV    128,INBUF       ; Input Buffer
         DEFV    130,INCLBUF     ; Include Buffer
         DEFV    80,KBUF         ; Replace buffer
         DEFV    80,PARABLK      ; Disk I/O Entry
         DEFV    128,FILNAM      ; File name buffer
         DEFV    50,PARPRT
         DEFV    2*11,BUFF
         DEFV    4*25,TSCR
*--------------------------------
         DEFV    W,CONST4
         DEFV    W,CONST11
         DEFV    L,SCR50
         DEFV    W,ROWCRS
         DEFV    W,COLCRS
         DEFV    L,TMPROW
         DEFV    W,BUFCNT
         DEFV    W,MASK
         DEFV    B,ATACHR
         DEFV    B,CHAR
         DEFV    B,CURS
         ADJSTV
*--------------------------------
         DEFV    L,RCWindow      ;
         DEFV    L,Hndl          ;
         DEFV    L,TotLen        ;
         DEFV    L,Len           ;
         DEFV    L,ResType       ;
         DEFV    W,ID            ;
         DEFV    W,Attrs         ;
         DEFV    L,fdType        ;
         DEFV    L,fdCreator     ;
         DEFV    W,fdFlags       ;
         DEFV    W,ioRefNum.Src  ;
         DEFV    W,ioRefNum.Dst  ;
         DEFV    W,ioVRefNum     ;
         DEFV    B,ioVersNum     ;
         DEFV    B,F.Src         ;
         DEFV    B,F.Dst         ;
         ADJSTV
*--------------------------------
         ENDG
*--------------------------------
RESHEAP  EQU     5*1024
*--------------------------------
