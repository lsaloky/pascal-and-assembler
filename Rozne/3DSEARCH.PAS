program Prehladavanie_kniznic_materialov_3D_Studia;
{ze ktore bitmapy su zbytocne a ktore chybaju}
uses Dos;
const MLIPath='D:\3DSTUDIO\MATLIBS';
      MapPath= 'D:\3DSTUDIO\MAPS1';
      TempPath='C:\TEMP';
      MaxPocetBitmap=500;
      PocetTypov=4;
      Pripustne:array[1..PocetTypov] of string[4]=('.CEL','.GIF','.JPG','.TGA');
      ZnakyNazvu=['a'..'z','A'..'Z','0'..'9','_'];
var DirInfoMli,DirInfoMap:SearchRec;
    Bitmapy:array[1..MaxPocetBitmap] of record
      Nazov:string[12];
      Bolo:boolean;
    end;
    Aktual,AktPocet,x,y,z,Vysl:word;
    Pouzite:boolean;
    f:file;
    s,t:string;{v tomto retazci bude prehladavanie,"t" pomocny}
    fOut:text;
BEGIN
  Assign(fOut,TempPath+'\3dsearch.txt');
  Rewrite(fOut);
  writeln(fOut,'Bitmapy, ktor‚ MatLib-y potrebuju a nemaju ich:');
  writeln(fOut,'------------------------------------------');
{ ----- nacitanie adresara do pola "Bitmapy" ----- }
  ChDir(MapPath);
  FindFirst('*.*',AnyFile,DirInfoMap);
  AktPocet:=1;
  while DosError=0 do begin
    with Bitmapy[AktPocet] do begin
      Nazov:=DirInfoMap.Name;
      Bolo:=False;
      if Nazov[1]<>'.' then Inc(AktPocet);
      for x:=1 to Length(Nazov) do Nazov[x]:=UpCase(Nazov[x]);
    end;
    FindNext(DirInfoMap);
  end;
  Dec(AktPocet);{v AktPocet je posledny aktualny nazov bitmapy}
{ ----- spracovanie matlibov ----- }
  ChDir(MliPath);
  FindFirst('*.MLI',AnyFile,DirInfoMLI);
  while DosError=0 do begin
    Assign(f,DirInfoMLI.Name);
    Reset(f,1);
    s[0]:=#140;
    for x:=1 to 140 do s[x]:=#0;
    BlockRead(f,s,140,Vysl);
    while Vysl>=128 do begin
      for y:=1 to PocetTypov do begin
        x:=Pos(Pripustne[y],s);
        if x>0 then begin {m me pr¡ponu}
          z:=x-1;
          while s[z] in ZnakyNazvu do Dec(z);
          Inc(z);         {z ukazuje na zaciatok mena}
          t:=Copy(s,z,x-z+4);
          Pouzite:=False;
          for Aktual:=1 to AktPocet do
            if t=Bitmapy[Aktual].Nazov then begin
              Bitmapy[Aktual].Bolo:=True;
              Pouzite:=True;
            end;
          if not Pouzite then begin
            writeln(fOut,t,' ');
          end;
        end;
      end;
      Move(s[128],s[1],12);
{      for x:=13 to 140 do s[x]:=#0;}
      BlockRead(f,s[13],128,Vysl);
    end;
    Close(f);
    FindNext(DirInfoMLI);
  end;
  writeln(fOut);
  writeln(fOut,'Bitmapy, ktor‚ nie s£ pouz¡van‚ MatLib-mi:');
  writeln(fOut,'------------------------------------------');
  for Aktual:=1 to AktPocet do
    if not Bitmapy[Aktual].Bolo then writeln(fOut,Bitmapy[Aktual].Nazov,' ');
  writeln;
  Close(fOut);
END.