program Zabrate_miesto_na_diskoch;
uses Dos;
const ClusterNaHost:word=8192;
      KomprPomerVolneho:real=2.0;
      Host=6;				{F:\}
var Sucet,SucHost,Pom:LongInt;
    Pocet:word;
    Info:record
                DiskJednotka:byte;
                VolneClustre:word;
                CelkomClustrov:word;
                ByteNaSektor:word;
                SektorovNaCluster:word;
              end;
{ ----- procedura zisti udaje o disku ----- }
Procedure InfoDisk(Disk:char);assembler;
asm
             mov dl,Disk
             sub dl,64
             mov Info.DiskJednotka,dl
             mov ah,$36
             int 21h
             mov Info.VolneClustre,bx
             mov Info.CelkomClustrov,dx
             mov Info.ByteNaSektor,cx
             mov Info.SektorovNaCluster,ax
end;
{ ----- procedura prejde strukturu adresarov a zapise ju do suboru vo vlastnom formate ----- }
procedure Adresar(s:string);
var sr:SearchRec;
begin
  FindFirst(s+'\*.*',$37,sr);
  repeat
    if sr.Name[1]<>'.' then begin
      Inc(Sucet,sr.Size);
      Inc(SucHost,(1+sr.Size div ClusterNaHost)*ClusterNaHost);
      if (sr.Attr and Directory) >0 then Adresar(s+'\'+sr.Name);
    end;
    FindNext(sr);
  until DosError>0;
end;
{ ----- funkcia vypise cislo pomocou trojcisli oddelenych bodkami ----- }
Function Form(l:longint):string;
var p3,d3,t3:string;
begin
  Str(l div 1000000:3,p3);
  Str((l mod 1000000) div 1000:3,d3);
  Str(l mod 1000:3,t3);
  if d3[1]=' ' then d3[1]:='0';
  if d3[2]=' ' then d3[2]:='0';
  if t3[1]=' ' then t3[1]:='0';
  if t3[2]=' ' then t3[2]:='0';
  if d3<>'0' then Insert(d3+'.',t3,1);
  if p3<>'0' then Insert(p3+'.',t3,1);
  Form:=t3;
end;

BEGIN
  Sucet:=0;SucHost:=0;
  Adresar('C:');
  Pom:=Round(DiskSize(Host)-DiskFree(3)/KomprPomerVolneho);
  WriteLn(#13#10'Disk C:\ (DriveSpace) '#13#10);
  WriteLn('  Zabrate miesto na disku, ak by nebola kompresia: ',Form(SucHost));
  WriteLn('- Pocet bajtov vsetkych suborov, bez kompresie:    ',Form(Sucet),#13#10);
  WriteLn('  Stracalo by sa:                                  ',Form(SucHost-Sucet),#13#10);
  WriteLn('  Zabrate miesto s DriveSpace (na host. jednotke): ',Form(Pom));
  WriteLn('  Teda DriveSpace ziskava:                         ',Form(SucHost-Pom),#13#10);
  WriteLn('Volne miesto: ',Form(DiskFree(3)));
  WriteLn('Z celkovych:  ',Form(DiskSize(3)));
  Sucet:=0;SucHost:=0;
  Adresar('D:');
  WriteLn('-----------------------------------'#13#10'Disk D:\'#13#10);
  WriteLn('  Zabrate miesto na disku:       ',Form(DiskSize(4)-DiskFree(4)));
  WriteLn('- Pocet bajtov vsetkych suborov: ',Form(Sucet),#13#10);
  WriteLn('  Straca sa:                     ',Form(DiskSize(4)-DiskFree(4)-Sucet),#13#10);
  WriteLn('Volne miesto: ',Form(DiskFree(4)));
  WriteLn('Z celkovych:  ',Form(DiskSize(4)));
  WriteLn(#13#10'Stlac Enter');
  ReadLn;
END.