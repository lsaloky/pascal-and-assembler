program Praca_so_sietou;
const Meno1:array[1..16] of char=('l','u','b','o','s','_','s','a','l','o','k','y','_','_','_','1');
      Meno2:array[1..16] of char=('l','u','b','o','s','_','s','a','l','o','k','y','_','_','_','2');
      Data:string='Toto je prve pokusne vysielanie';
type TNCB=record { Network Control Block }
       Prikaz,NavratovyKod,CisloSekcie,Num:byte;
       Buffer:pointer;
       Dlzka:word;
       MenoVolaneho,Meno:array[1..16] of char;
       TimeOutPrijem,TimeOutVysielanie:byte;
       Post:pointer;
       Lana_num,Cmd_cplt:byte;
       Rezerva:array[1..14] of byte;
     end;
var NCB:TNCB;
    i,j:integer;
    Buffer:string;
function VolajNetBios:byte;assembler;
asm
             mov ax,seg ncb
             mov es,ax
             mov bx,offset ncb
             mov ah,byte ptr [es:bx]  {alebo al?}
             int 5Ch
end;
function PridajMeno(Meno:array of char):byte;
begin
  NCB.Prikaz:=$30;
  for i:=1 to 16 do NCB.Meno[i]:=Meno[i];
  VolajNetBios;
  PridajMeno:=NCB.NavratovyKod;
end;
function VytvorSpojenie(Meno:array of char):byte;
begin
  NCB.Prikaz:=$10;
  for i:=1 to 16 do NCB.MenoVolaneho[i]:=Meno[i];
  NCB.TimeOutPrijem:=100;
  NCB.TimeOutVysielanie:=100;          { !!!!!!!!!!!!!!! }
  VolajNetBios;
  { malo by sa vratit CisloSekcie}
  VytvorSpojenie:=NCB.NavratovyKod;
end;
function Vysielanie:byte;
begin
  NCB.Prikaz:=$14;
  NCB.Buffer:=@Data;
  NCB.Dlzka:=256;
  VolajNetBios;
  Vysielanie:=NCB.NavratovyKod;
end;
function Prijem:byte;
begin
  NCB.Prikaz:=$15;
  NCB.Buffer:=@Buffer;
  NCB.Dlzka:=256;
  VolajNetBios;
  Prijem:=NCB.NavratovyKod;
end;
BEGIN
  Buffer:='';
  WriteLn(PridajMeno(Meno1));    { Meno2 na druhom }
  ReadLn;                        { asi treba pockat pred vytvaranim spojenia }
  WriteLn(VytvorSpojenie(Meno2));{ Meno1 na druhom }
  ReadLn;                        { odstran na druhom }
  WriteLn(Vysielanie);           { Prijem na druhom }
END.