;SAVE"Quotes.Asm"
*--------------------------------
QUOTES
QTITLE   EQU     0
         HEX     0C
         ASC     "+--------------------------+"
         HEX     0D
         ASC     "|    -- MacASM  v"
         DATA    #VERS.HI+'0,#'.,#VERS.LO+'0
         ASC     " --    |"
         HEX     0D
         ASC     "| Copyright, 1984 MAINSTAY |"
         HEX     0D
         ASC     "|   All Rights Reserved    |"
         HEX     0D
         ASC     "+--------------------------+"
         HEX     8D
QPROMPT  EQU     1
         ASC     'Ok.'
         HEX     8D
QSTARS   EQU     2
         HEX     0D072A2A2AA0
QERROR   EQU     3
         AST     ' error.'
QSYNX    EQU     4
         AST     'Syntax'
QMEMO0   EQU     5
         HEX     0D
         AST     'Source Program: $'
QMEMO1   EQU     6
         HEX     0D
         AST     '  Symbol Table: $'
QMEMO2   EQU     7
         HEX     0D
         AST     '   Free Memory: $'
QMEMFL   EQU     8
         AST     'Memory full'
QSTRLNG  EQU     9
         AST     'String too long'
QREPRMT  EQU     10
         HEX     0D
         AST     'Replace?'
QREPLNG  EQU     11
         AST     'Replace too long'
QER3     EQU     12
         AST     'Range'
QDOSERR  EQU     13
         AST     'DOS'
QVOLNAM  EQU     14
         HEX     0D
         AST     'Volume Name: '
QNFILES  EQU     15
         AST     ' Files, '
QBFREE   EQU     16
         AST     ' Free Blocks.'
QFLNAM   EQU     17
         HEX     0D
         AST     'L File Name'
QTIT     EQU     18
         ASC     'Type  Creator   Data    Resource  Size'
         HEX     8D
QFTM     EQU     19
         AST     'File type mismatch'
QD33     EQU     20
         AST     'Directory full (DirFulErr)'
QD34     EQU     21
         AST     'Disk full (DskFulErr)'
QD35     EQU     22
         AST     'No such volume (NSVErr)'
QD36     EQU     23
         AST     'Disk I/O (IOErr)'
QD37     EQU     24
         AST     'Bad name (bdNamErr)'
QD38     EQU     25
         AST     'File not open (FNOpnErr)'
QD39     EQU     26
         AST     'End-of-file (EOFErr)'
QD40     EQU     27
         AST     'Bad position (PosErr)'
QD41     EQU     28
         AST     'Memory full (MFulErr)'
QD42     EQU     29
         AST     'Too many files open (TMFOErr)'
QD43     EQU     30
         AST     'File not found (FNFErr)'
QD44     EQU     31
         AST     'Disk write protected (WPrErr)'
QD45     EQU     32
         AST     'File locked (FLckdErr)'
QD46     EQU     33
         AST     'Volume locked (VLckdErr)'
QD47     EQU     34
         AST     'File busy (FBsyErr)'
QD48     EQU     35
         AST     'Duplicate filename (DupFNErr)'
QD49     EQU     36
         AST     'File already open for writing (OpWrErr)'
QD50     EQU     37
         AST     'User parameter list (ParamErr)'
QD51     EQU     38
         AST     'Bad reference number (RFNumErr)'
QD52     EQU     39
         AST     'Get file position (GFPErr)'
QD53     EQU     40
         AST     'Volume not on-line (VolOffLinErr)'
QD54     EQU     41
         AST     'Permissions (PermErr)'
QD55     EQU     42
         AST     'Volume already on-line (VolOnLinErr)'
QD56     EQU     43
         AST     'No such drive (NSDrvErr)'
QD57     EQU     44
         AST     'Not a Mac volume (NoMacDskErr)'
QD58     EQU     45
         AST     'External file system (ExtFSErr)'
QD59     EQU     46
         AST     'File system (FSDSErr)'
QD60     EQU     47
         AST     'Bad master directory block (BadMDBErr)'
QD61     EQU     48
         AST     'Write permissions (WrPermErr)'
QBDEXP   EQU     49
         AST     'Expression'
QER9     EQU     50
         AST     'No normal label'
QER6     EQU     51
         AST     'Undefined label'
QER10    EQU     52
         AST     'Value > 65535'
QER4     EQU     53
         AST     'Extra definition'
QER7     EQU     54
         AST     'Bad label'
QST      EQU     55
         AST     '    --- Symbol Table ---'
QNONAM   EQU     56
         AST     'No MACRO name'
QER2     EQU     57
         AST     'Bad mnemonic'
QERPARA  EQU     58
         AST     'Bad MACRO parameter'
QER1     EQU     59
         AST     'No label'
QNIN     EQU     60
         AST     'Nested INCLUDE'
PAGEQT   EQU     61
         AST     ' Page '
QERDO    EQU     62
         AST     'Missing DO'
QERDO2   EQU     63
         AST     'DO nest too deep'
QERRCNT  EQU     64
         AST     ' Errors in Assembly'
QMEMPRO  EQU     65
         AST     'Memory protect'
QER5     EQU     66
         AST     'Bad address'
QERRMAC  EQU     67
         AST     'Undefined MACRO'
QMACLVL  EQU     68
         AST     'MACRO nest too deep'
QERWORD  EQU     69
         AST     'Opcode not on WORD boundary'
QNRS     EQU     70
         AST     'Nested RSRC'
QNENR    EQU     71
         AST     'Missing ENDR'
QNORS    EQU     72
         AST     'Missing RSRC'
QSERU    EQU     73
         HEX     0D
         ASC     'Serial  Number'
         HEX     0D
         ASC     '+------------+'
         HEX     0D
         AST     '| '
QSERD    EQU     74
         ASC     ' |'
         HEX     0D
         AST     '+------------+'
*--------------------------------
         ADJST
