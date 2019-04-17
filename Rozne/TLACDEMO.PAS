program TlaciarenskeDemo;
uses Printer;
const draft:string[6]=#40#40#70#41#41#57;
      cour:string[6]=#40#40#70#41#41#48;
      sans:string[6]=#40#40#70#41#41#49;
      oras:string[6]=#40#40#70#41#41#55; {mal‚ p¡smen }
      orav:string[6]=#40#40#70#41#41#56; {zn¡zen‚ velk‚ p¡smen }
      data:array[1..319]of byte=(139,124,0,66,4,64,36,16,2,16,12,0,
                               128,14,16,38,1,70,1,70,0,126,0,0,
                               70,0,38,0,22,9,6,9,6,8,6,0,
                               28,62,14,64,14,0,14,0,124,0,0,12,
                               64,12,32,14,16,14,0,14,0,12,0,
                               0,0,0,0,1,3,7,7,7,15,14,14,
                               14,14,14,7,7,3,3,15,15,15,0,0,
                               0,0,6,7,7,7,7,7,7,7,7,6,
                               6,0,0,7,7,7,7,7,7,7,7,7,
                               7,7,0,0,7,7,7,7,7,7,7,7,
                               7,7,0,0,0,
                               0,0,60,255,255,255,255,255,143,15,7,7,
                               7,7,3,3,3,131,193,241,240,240,0,0,
                               0,0,0,0,224,255,255,255,255,255,31,0,
                               0,0,1,3,31,255,255,255,255,255,255,1,
                               0,0,0,1,7,31,255,252,240,192,128,0,
                               0,0,0,0,0,
                               0,31,31,3,129,128,192,192,192,192,192,224,
                               224,224,224,240,255,255,255,255,255,127,0,0,
                               0,0,0,0,0,192,255,255,255,255,255,15,
                               15,63,252,240,192,0,240,255,255,255,255,255,
                               7,15,127,252,240,192,0,0,0,0,0,0,
                               0,0,0,0,0,
                               0,248,248,240,224,224,112,112,56,56,56,56,
                               56,120,120,240,240,224,224,192,128,0,0,0,
                               0,0,0,0,0,0,128,248,248,248,248,240,
                               192,0,0,0,0,0,240,248,248,248,248,240,
                               192,0,0,0,0,0,0,0,0,0,0,0,
                               0,0,0,0,0);
var x:byte;
    y,z:word;
begin
  writeln(lst,#27,'D',#3#13#0);
  writeln(lst,cour,'Druhy p¡sma:');
  writeln(lst,#9,draft,'P¡smo Draft');
  writeln(lst,#9,cour,'P¡smo Courier');
  writeln(lst,#9,sans,'P¡smo SansSerif');
  writeln(lst,#9,oras,'Orator s malymi p¡smenkami');
  writeln(lst,#9,oras,'       so Znizenymi Velkymi Pismenkami');
  write(#27,'4');
  writeln(lst,oras,'a kurz¡va  ',orav,'pre  ',draft,'vsetky  ',sans,'typy  ',cour,'fontov');
  write(#27,'5');
  writeln(lst,cour,'Mozn‚ hustoty p¡sma:');
  writeln(lst,#9#27,'PPica - 10 znakov na palec');
  writeln(lst,#9#27,'MElite - 12 znakov na palec');
  writeln(lst,#9#15#27,'PZhusten  Pica - 17 znakov na palec');
  writeln(lst,#9#27,'MZhusten  Elite - 20 znakov na palec',#18);
  writeln(lst,#9#27,'p1alebo proporcion lne p¡smo',#27,'p0');
  writeln(lst,#9#27,'W1Sirok‚   ',#27,'W0',#27,'w1Vysok‚',#27,'w0');
  writeln(lst,#9#27,'h',#1,'Dvojit  velkost');
  writeln(lst,#9,#27,'h',#2,'Stvorn sobn  velkost');
  writeln(lst,#27,'h',#0#10#27,'Q',#47);
  writeln(lst,sans,'Zmena riadkovania a hustoty znakov:',#27,'a1');
  for x:=1 to 7 do writeln(lst,#27,'A',Chr(x),#27,' ',Chr(x),'MEDZERY SA MENIA');
  for x:=7 downto 1 do writeln(lst,#27,'A',Chr(x),#27,' ',Chr(x),'MEDZERY SA MENIA');
  writeln(lst,#27,'a0',#27,'3',#36,#27,' ',#0#10);
  writeln(lst,oras,'Dalsie funkcie:');
  writeln(lst,#9#27,'ETucn‚',#27,'F, ',#27,'GDouble - strike',#27,'H, ',#27,'-1Podciarknut‚',#27,'-0, ');
  writeln(lst,#9#27,'S0Horny index',#27,'T a ',#27,'S1Dolny index',#27,'T');
  write(lst,draft,#27#61#0#60#20#0#0#3#3#3#3#3#3#3#3#3#3#3#3);
  for x:=0 to 11 do write(lst,Chr(data[x]));
  writeln(lst,cour,#9,'Znaky novozadefinovan‚ho p¡sma pre Draft:');
  writeln(lst,draft,#27,'%1',#60#60#60#60#60);
end.