program Piskvorky;
uses MainGr,Mys;
const PocetMB=4;
      PocetMGP=1;
      VelkostPlanu=16;
      PlanX=10;PlanY=10;
      AktivGam:array[1..4,1..4] of word = (
        (PlanX+1,PlanY+1,PlanX+11*VelkostPlanu,PlanY+11*VelkostPlanu),
        (216,13,302,29),(216,34,302,50),(400,0,0,0));
      Klav:array[1..1] of char=#255;
      Smer:array[1..8,1..2] of shortint=((-1,-1),(0,-1),(1,-1),(1,0),(1,1),(0,1),(-1,1),(-1,0));
var MSFP,PalP:pointer;
    MBP:array[1..PocetMB] of pointer;
    MGPP:array[1..PocetMGP] of pointer;
    Udalost,PosX,PosY,AktHrac:integer;
    Plan:array[-3..VelkostPlanu+4,-3..VelkostPlanu+4] of byte;
    Volne:array[2..3] of integer;{pocet volnych dvojic,trojic}
    Zablok:array[2..4] of integer;{pocet na jednej strane zablokovanych dvojic az stvoric}
{ ----- pomocne premenne ----- }
    i:integer;
    f:file;
function StrI(x:integer):string;
var Pom:string;
begin
  Str(x,Pom);
  StrI:=Pom;
end;
procedure VypisVolne;
begin
  Color:=6;VyplnPlochu(210,84,98,23);
  VypisPo(214,85,MSFP,StrI(Volne[2]),Hneda);
  VypisPo(244,85,MSFP,StrI(Volne[3]),Hneda);
  VypisPo(214,97,MSFP,StrI(Zablok[2]),Hneda);
  VypisPo(244,97,MSFP,StrI(Zablok[3]),Hneda);
  VypisPo(274,97,MSFP,StrI(Zablok[4]),Hneda);
end;
procedure InicializujHraciPlan;
begin
  FillChar(Plan,SizeOf(Plan),#0);
  FillChar(Volne,SizeOf(Volne),#0);
  FillChar(Zablok,SizeOf(Zablok),#0);
  ZmazObrazovku;
  VykresliMGP(MGPP[1],@MBP,@MSFP);
  Color:=15;
  for i:=0 to VelkostPlanu do CiaraVodorovna(PlanX,PlanY+11*i,11*VelkostPlanu+1);
  for i:=0 to VelkostPlanu do CiaraZvisla(PlanX+11*i,PlanY,11*VelkostPlanu+1);
  VypisVolne;
  for i:=1 to 10 do CakajNaVOI;
  AktHrac:=1;
end;
begin
{ ----- inicializacia ----- }
  NacitajFont('Hlavny8.MSF',MSFP);
  NacitajPaletu('Prechody.MP',PalP);
  Assign(f,'MukoPisk.MB');
  Reset(f,1);
  Seek(f,769);
  for i:=1 to PocetMB do NacitajBMP(f,MBP[i]);
  Close(f);
  Assign(f,'MukoPisk.MGP');
  Reset(f,1);
  Seek(f,16);
  for i:=1 to PocetMGP do NacitajMGP(f,MGPP[i]);
  Close(f);
  InicializujGrafiku;
  NastavPaletu(PalP);
  ZM;
  VypinajMys:=True;
{ ----- hlavny program ----- }
  InicializujHraciPlan;
{  NastavTvarKurzora(Ofs(Ruka));}
  repeat
    Udalost:=ObsluzUdalost(@AktivGam,@Klav);
    case Udalost of
      1:begin
        PosX:=(MysX-PlanX-1) div 11+1;
        PosY:=(MysY-PlanY-1) div 11+1;
        if Plan[PosX,PosY]=0 then begin
          Plan[PosX,PosY]:=AktHrac;
          PrilepBMPPO((PosX-1)*11+2+PlanX,(PosY-1)*11+2+PlanY,MBP[AktHrac]);
          for i:=1 to 8 do begin
            if (Plan[PosX-Smer[i,1]  ,PosY-Smer[i,2]  ]=0      ) and
               (Plan[PosX+Smer[i,1]  ,PosY+Smer[i,2]  ]=AktHrac) and
               (Plan[PosX+Smer[i,1]*2,PosY+Smer[i,2]*2]=0      )
               then Dec(Volne[2],2*AktHrac-3);
            if (Plan[PosX-Smer[i,1]  ,PosY-Smer[i,2]  ]=0      ) and
               (Plan[PosX+Smer[i,1]  ,PosY+Smer[i,2]  ]=AktHrac) and
               (Plan[PosX+Smer[i,1]*2,PosY+Smer[i,2]*2]=AktHrac) and
               (Plan[PosX+Smer[i,1]*3,PosY+Smer[i,2]*3]=0      )
               then Dec(Volne[3],2*AktHrac-3);
            end;
          VypisVolne;
          if AktHrac=1 then AktHrac:=2 else AktHrac:=1;
        end;
      end;
      2:InicializujHraciPlan;
    end;
  until Udalost=3;
  ZavriGrafiku;
  Writeln('MukoSoft piskvorky'#13#10'Lubos Saloky, 1997');
END.
