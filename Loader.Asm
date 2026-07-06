;SAVE"Loader.asm"
*--------------------------------
Start    PEA     -4(A5)
         TBX     InitGraf
         TBX     InitFonts
         TBX     InitWindows
         TBX     InitMenus
         TBX     TEInit
         CLR.L   -(SP)
         TBX     InitDialogs
         MOVE.L  #$0000FFFF,D0
         OST     FlushEvents
         MOVE.L  16(A5),A0
         MOVE.L  (A0),A0
         TST.W   2(A0)
         BEQ.S   .0
         CMP.L   #TYPBIN,6(A0)
         BEQ.S   .1
.0       SJMP    INIT
.1       SJMP    RCOMP
*--------------------------------
         END
