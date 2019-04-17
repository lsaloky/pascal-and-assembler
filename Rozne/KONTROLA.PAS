program Starostlivost_o_disk;
{$M $4000,0,0}
Uses Crt,Dos;
type diskstr=string;
var memo:diskstr;               {retazec v pamati}
    disk:file of diskstr;       {retazec na disku}
    x,rok,mesiac,den,denvtyzdni:word;
    pomstr,s:string;

procedure osetri;
begin
  writeln('Error pri Val. Nasleduje Exit.');
  exit;
end;

procedure Init;
begin
  ClrScr;
  writeln('Inicializujem d vkovy s£bor a nastavujem standardn£ konfigur ciu.');
  assign(disk,'c:\davky\nemaz_ma.dat');
  rewrite(disk);
  GetDate(rok,mesiac,den,denvtyzdni);
  for x:=0 to 255 do memo[x]:=' ';
  memo:='³Unfrag=0007,00.00.0000³FullOp=0028,00.00.0000³NDD /q=0014,00.00.0000³NDD /c=0040,00.00.0000³AntiVi=0010,00.00.0000'
  +'³BP_EXE=0007,00.00.0000³ÿTreeÿ=0005,00.00.0000³';
  memo[14]:=chr((den div 10)+48);
  memo[15]:=chr((den mod 10)+48);
  memo[17]:=chr((mesiac div 10)+48);
  memo[18]:=chr((mesiac mod 10)+48);
  if rok>1999 then begin
    memo[20]:=chr(50);
    memo[21]:=chr(48);
    memo[22]:=chr(((rok-1900) div 10)+48);
    memo[23]:=chr((rok mod 10)+48);
  end
  else begin
    memo[20]:=chr(49);
    memo[21]:=chr(57);
    memo[22]:=chr(57);
    memo[23]:=chr((rok mod 10)+48);
  end;
  for x:=0 to 5 do move(memo[14+x*23],memo[37+x*23],10);
  write(disk,memo);
  writeln;
  writeln('Hotovo. Stlac ak£kolvek kl vesu');
  repeat until keypressed;
end;

procedure Makaj;
const mesiace:array[1..12]of word=(0,31,59,90,120,151,181,212,243,273,304,334);
var err:integer;
    den2,mesiac2,rok2,denvtyzdni2,rozdiel,rozdiel2:word;
begin
  assign(disk,'c:\davky\nemaz_ma.dat');
  reset(disk);
  read(disk,memo);
  for x:=0 to 5 do begin
    pomstr:=Copy(memo,14+23*x,2);
    Val(pomstr,den,err);
    if err>0 then osetri;
    pomstr:=Copy(memo,17+23*x,2);
    Val(pomstr,mesiac,err);
    if err>0 then osetri;
    pomstr:=Copy(memo,20+23*x,4);
    Val(pomstr,rok,err);
    if err>0 then osetri;
    GetDate(rok2,mesiac2,den2,denvtyzdni2);
    den2:=29;
    writeln(den,' ',mesiac,' ',rok);
    writeln(den2,' ',mesiac2,' ',rok2);
    rozdiel:=(rok2-rok)*365+mesiace[mesiac2]+den2-mesiace[mesiac]-den;
    pomstr:=Copy(memo,9+23*x,4);
    Val(pomstr,rozdiel2,err);
    if err>0 then osetri;
    writeln(rozdiel,'-',pomstr,'-',rozdiel2);
    if rozdiel>rozdiel2 then begin
      SwapVectors;
      case x of
      0:exec('d:\nu\speedisk.exe','/u');
      1:exec('d:\nu\speedisk.exe','/f');
      2:exec('d:\nu\ndd.exe','/q');
      3:exec('d:\nu\ndd.exe','/c');
      4:exec('d:\antivirs\anti3544\virdetek.exe','c: d: /c');
      5:exec('del','c:\subory\bp_exe\*.exe');
      6:begin
          exec('c:','');
          exec('tree','/f >c:\c.txt');
          exec('d:','');
          exec('tree','/f >d:\d.txt');
        end;
      end;
      SwapVectors;
    end
    else writeln('Nic.');
  end;
  writeln('Z kladn  £drzba harddisku je ukoncen .');
  Delay(500);
end;

begin                                                   {hlavny program}
  writeln('Pravideln  kontrola harddisku.');
  writeln;
  if ParamCount=0 then Makaj;
  if ParamStr(1)='/?' then begin
    writeln('Program vykon va automaticky £drzbu harddisku v zvolenych casovych intervaloch');
    writeln('-----------------------------------------------------------');
    writeln('Parametre pr¡kazov‚ho riadka:');
    writeln('/i - Inicializ cia a nastavenie standardnych hodn“t');
    writeln('/k - zacatie kontroly');
  end;
  if ParamStr(1)='/i' then init;
  if ParamStr(1)='/k' then Makaj;
end.