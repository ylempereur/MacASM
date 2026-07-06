;SAVE"Lib.Asm"
*--------------------------------
* Segments Definition
*--------------------------------
SEG      MACRO
         DO      ]#=1
         RSRC    CODE,]1
         ELSE
         RSRC    CODE,]1,]2
         FIN
         DO      ]1≠0
         DATA    /SEG_]1-SEG0
         DATA    /(END_]1-SEG_]1)/8
SEG.]1
         ELSE
JP_OFF   EQU     ]4
         DATA    JP_OFF+END0-SEG0
         DATA    ]3
         DATA    END0-SEG0
         DATA    JP_OFF
         FIN
         ENDM
SJMP     MACRO
         JMP     J_]1-SEG0+JP_OFF+2(A5)
         ENDM
SJSR     MACRO
         JSR     J_]1-SEG0+JP_OFF+2(A5)
         ENDM
JP       MACRO
J_]1     DATA    /]1-SEG.]2,/$3F3C,/]2,/$A9F0
         ENDM
*--------------------------------
* ROM Calls
*--------------------------------
OST      MACRO
         DO      ]#=1
         DATA    /]1
         ELSE
         DATA    /(]1)!(]2)
         FIN
         ENDM
TBX      MACRO
         DO      ]#=1
         DATA    /]1
         ELSE
         DATA    /(]1)!(]2)
         FIN
         ENDM
AutoPop  EQU     $0400
ASYNC    EQU     $0400
IMMED    EQU     $0200
*--------------------------------
* Global Variables Definition
*--------------------------------
GLOBAL   MACRO
VAR.ULN  EQU     ]1
VAR.SLN  EQU     ]2
VAR.LEN  EQU     VAR.ULN+VAR.SLN
         ORG     0
         ENDM
ENDG     MACRO
         DEFS    VAR.SLN
VAR.RLN  EQU     *-VAR.SLN
         DO      VAR.RLN>VAR.ULN
 *** Global variable allocation not sufficient; Type "VAL VAR.RLN"
         FIN
         ORG     0
         ENDM
B        EQU     1
W        EQU     2
L        EQU     4
DEFV     MACRO
]2 EQU *-VAR.LEN
         DEFS    ]1
         ENDM
*--------------------------------
* Opcode Table Definition
*--------------------------------
ADJSTV   MACRO
         DO      *&1
         DEFS    B
         FIN
         ENDM
*--------------------------------
DIR      MACRO
         STR     "]1"
         DATA    /]2-ASM
         ENDM
REG      MACRO
         STR     "]1"
         DATA    /]2
         ENDM
*--------------------------------
ENTRY1   MACRO
         DATA    #]1-*
         AST     "]2"
         DATA    /]3,#]4,#]5
         HEX     ]6
         ENDM
*--------------------------------
ENTRY2   MACRO
         DATA    /]1,#]2,#]3
         HEX     ]4
         ENDM
*--------------------------------
ENTRY3   MACRO
         DATA    #]1-*
         ASC     "]2"
         HEX     00
         DATA    /]3,#]4,#]5
         HEX     ]6
         ENDM
*--------------------------------
* Resource Attributes
*--------------------------------
resSysRef        EQU  128
resSysHeap       EQU  64
resPurgeable     EQU  32
resLocked        EQU  16
resProtected     EQU  8
resPreLoad       EQU  4
resChanged       EQU  2
*--------------------------------
* ROM Equates
*--------------------------------
AddResource      EQU  $A9AB
ChangedResData   EQU  $A9AA
Close            EQU  $A001
CloseDialog      EQU  $A982
CloseResFile     EQU  $A99A
CreateResFile    EQU  $A9B1
DisposWindow     EQU  $A914
DrawChar         EQU  $A883
DrawString       EQU  $A884
Eject            EQU  $A017
EventAvail       EQU  $A971
ExitToShell      EQU  $A9F4
FileCreate       EQU  $A008
FileDelete       EQU  $A009
FlushEvents      EQU  $A032
FlushVol         EQU  $A013
FreeMem          EQU  $A01C
GetFileInfo      EQU  $A00C
GetNewDialog     EQU  $A97C
GetNewWindow     EQU  $A9BD
GetNextEvent     EQU  $A970
GetResource      EQU  $A9A0
GetVolInfo       EQU  $A007
HideCursor       EQU  $A852
InitCursor       EQU  $A850
InitDialogs      EQU  $A97B
InitFonts        EQU  $A8FE
InitGraf         EQU  $A86E
InitMenus        EQU  $A930
InitWindows      EQU  $A912
MaxMem           EQU  $A11D
ModalDialog      EQU  $A991
MoveTo           EQU  $A893
NewPtr           EQU  $A11E
NWHandle         EQU  $A122
Open             EQU  $A000
OpenResFile      EQU  $A997
ParamText        EQU  $A98B
Read             EQU  $A002
resErr           EQU  $0A60
Write            EQU  $A003
Control          EQU  $A004
KillIO           EQU  $A006
SetEOF           EQU  $A012
SetFileInfo      EQU  $A00D
SetPort          EQU  $A873
SetResAttrs      EQU  $A9A7
SetVol           EQU  $A015
StopAlert        EQU  $A986
SysBeep          EQU  $A9C8
TEInit           EQU  $A9CC
TextFace         EQU  $A888
TextFont         EQU  $A887
TextMode         EQU  $A889
TextSize         EQU  $A88A
*--------------------------------
         END
