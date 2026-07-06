;SAVE"Acf.Asm"
*--------------------------------
;   MACRO ASSEMBLER 68000
VERS.HI  EQU 1   VERSION 1.4
VERS.LO  EQU 4   NOV 10, 1986
*--------------------------------
         LIST    OFF
*--------------------------------
         INCLUDE "Lib.Asm"
         INCLUDE "Data.Asm"
*--------------------------------
         TFILE   "Buffer.Bin"
*--------------------------------
         RFILE   "MacASM.0",APPL,MASM,$2000
*================================
         SEG     0,resPurgeable!resPreLoad,Var.Len,32
SEG0
SEG_1    JP      START,1
END_1
SEG_2    JP      INIT,2
END_2
SEG_3    JP      RCOMP,3
END_3
END0
         ENDR
*================================
         SEG     1,resLocked!resPreLoad
         INCLUDE "Loader.Asm"
         ENDR
*================================
         SEG     2,resLocked
         INCLUDE "Edit.Asm"
         INCLUDE "Command.Asm"
         INCLUDE "Outrout.Asm"
         INCLUDE "Codec.Asm"
         INCLUDE "Diskio.Asm"
         INCLUDE "Asmgen.Asm"
         INCLUDE "Expcrack.Asm"
         INCLUDE "Getaddr.Asm"
         INCLUDE "Symtbl.Asm"
         INCLUDE "Macro.Asm"
         INCLUDE "Directv.Asm"
         INCLUDE "Quotes.Asm"
         INCLUDE "Asm68.Asm"
         INCLUDE "Opcdtab.Asm"
         INCLUDE "Init.Asm"
         INCLUDE "Scredit.Asm"
         ENDR
*================================
         SEG     3,resLocked
         INCLUDE "Rcmplr.Asm"
         ENDR
*================================
         INCLUDE "Resrc.Asm"
*================================
         END
