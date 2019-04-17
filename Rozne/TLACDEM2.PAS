program Demo_pre_LC20;
const Demo1:String=
#27'D'#3#13#0#27#107#48#27#120#49'P¡sma k dispoz¡cii:'#13#10#9#27#120#48+
'P¡smo Draft'#13#10#9#27#107#48#27#120#49'P¡smo Courier'#13#10#9#27#107#49+
#27#120#49'P¡smo Sanserif'#13#10#9#27#107#55#27#120#49'P¡smo Orator s '+
'kapit lkami'#13#10#9#27#107#56#27#120#49'             s malymi p¡smenkami'+
#13#10#27#52#9#27#107#56#27#120#49'a samozrejme '#27#107#55#27#120#49+
'kurz¡va '#27#107#49#27#120#49'pre '#27#107#48#27#120#49'vsetky '#27#120#48+
'p¡sma.'#13#10#27#53#13#10;
      Demo2:String=
#27#107#48#27#120#49'Hustoty p¡smen:'#13#10#9#27#80'Pica - 10 znakov na palec,'+
#13#10#9#27#77'Elite - 12 znakov na palec,'#13#10#9#15#27#80'Zhusten  Pica - 17 '+
'znakov na palec,'#13#10#9#27#77'Zhusten  Elite - 20 znakov na palec,'#13#10+
#27#80#18#9#27'p1a proporcion lne p¡smo.'#27'p0'#13#10#13#10#9#27'W1Sirok‚,'#27'W0'+
#27'w1Vysok‚'#27'w0'#13#10#9#27'h'#1'2 x zv„csen‚'#13#10;
      Demo3:String=
#9#27'h'#2'4x zv„csen‚'#13#10#27'h'#0#13#10#13#10#13#10#27'Q'#47'R“zne'+
' velkosti riadkov a medzier:'#13#10#27'a1'#13#10 ;
      PomStr:String=#27#65#255#27#32#255'MEDZERY SA MENIA'#13#10;
      Demo4:String=
#13#10#27'a0'#27#51#36#27#32#0#13#10'Dalsie vlastnosti:'#13#10#9#27'ETucn‚'+
#27'F, '#27'GDvakr t bodkovan‚'#27'H, '#27'-1Podciarknut‚'#27'-0, '#13#10+
#9#27'S0HORNY INDEX'#27'T a '#27'S1DOLNY INDEX'#27'T'#13#10#13#10;
var i:integer;
procedure PrintStr;assembler;
asm
             xor ch,ch
             mov cl,byte[si]
             inc si
@DalsiZnak:  mov ah,5
             mov dl,byte[si]
             inc si
             int 21h
             loop @DalsiZnak
end;
BEGIN
  asm
             lea si,Demo1
             call PrintStr
             lea si,Demo2
             call PrintStr
             lea si,Demo3
             call PrintStr
             mov i,1
@DalsiR1:    lea si,PomStr
             mov cx,i
             mov byte[si+3],cl
             mov byte[si+6],cl
             call PrintStr
             inc i
             cmp i,7
             jbe @DalsiR1
             mov i,7
@DalsiR2:    lea si,PomStr
             mov cx,i
             mov byte[si+3],cl
             mov byte[si+6],cl
             call PrintStr
             dec i
             cmp i,1
             jae @DalsiR2
             lea si,Demo4
             call PrintStr
end;
END.