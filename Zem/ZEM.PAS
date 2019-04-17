Program O_Zemi;
Uses MainGr,Mys;
Const PocetMB=5;PocetMP=6;PocetMGP=27;
      HMenu:array[1..9,1..4] of word=(
            (163,75,307,88),(163,88,307,101),(163,101,307,114),(163,114,307,127),
            (163,127,307,140),(163,140,307,153),(163,153,307,166),(163,166,307,179),(400,0,0,0));
      HMenuKlav:array[1..9]of char=('z','a','h','l','v','m','g','k',#255);
      PociatocneMGP:array[1..6] of byte=(2,5,11,14,21,28);
Var MBP:array[1..PocetMB] of ^BMPStruc;
    MPP:array[1..PocetMP] of pointer;
    MSFP:array[1..3] of ^FontStruc;
    MGPP:array[1..PocetMGP] of pointer;
    TestMGPP:array[1..24] of pointer;
    AktOtazka,StaraOtazka,Body:integer;
    Udalost:word;
    Odpovede:array[1..24,1..6] of byte;
    Penale:array[1..24] of byte;
{ ----- pomocne premenne ----- }
    f:file;
    i,j:integer;
    b,c:byte;
    s:string;
    ch:char;
function CitajKlaves:char;assembler;
asm
             mov ah,0
             int 16h
end;
Procedure CakajNaUdalost;
var x,y:word;
    Tlacidla:byte;
begin
  repeat
    ZistiPoziciu(x,y,Tlacidla);
    asm
             mov ah,1
             int 16h
             jz @Nic
             mov ah,0
             int 16h
             mov Tlacidla,al
@Nic:
    end;
  until Tlacidla>0;
  CakajNaPustenie;
end;
BEGIN

{ ----- inicializacia ----- }
  NacitajFont('Hlavny5.MSF',pointer(MSFP[1]));   {FONTY}
  NacitajFont('Matem8.MSF',pointer(MSFP[2]));
  NacitajFont('Hlavny11.MSF',pointer(MSFP[3]));
  InicializujGrafiku;
  Assign(f,'Velke.MB');
  Reset(f,1);
  Seek(f,769);
  for i:=1 to PocetMB do begin
    GetMem(MBP[i],64004);
    BlockRead(f,b,1);
    BlockRead(f,c,1);
    with MBP[i]^ do begin
      RozX:=b;RozY:=c;
      if b=64 then Inc(RozX,256);
      BlockRead(f,BMP,RozX*RozY);
    end;
  end;
  Assign(f,'Palety.DAT');
  Reset(f,768);
  for i:=1 to PocetMP do begin
    GetMem(MPP[i],768);
    BlockRead(f,MPP[i]^,1);
  end;
  Close(f);
  Assign(f,'Zem.MGP');
  Reset(f,1);
  Seek(f,16);
  for i:=1 to PocetMGP do NacitajMGP(f,MGPP[i]);
  Close(f);
  NastavPaletu(MPP[2]);
  PrilepBMP(0,0,MBP[1]);
  VykresliMGP(MGPP[1],@MBP,@MSFP);
  ZM;
  VypinajMys:=True;
{ ----- hlavny program ----- }
  repeat
    Udalost:=ObsluzUdalost(@HMenu,@HMenuKlav);
    CakajNaPustenie;
    case Udalost of
      1..5:begin { encyklopedia }
        for i:=PociatocneMGP[Udalost] to PociatocneMGP[Udalost+1]-1 do begin
          NastavPaletu(MPP[Udalost+1]);
          PrilepBMP(0,0,MBP[Udalost]);
          VykresliMGP(MGPP[i],@MBP,@MSFP);
          CakajNaUdalost;
        end;
      end;
      6:begin { minitest }
        Assign(f,'geotest.MGP');
        Reset(f,1);
        Seek(f,16);
        for i:=1 to 24 do NacitajMGP(f,TestMGPP[i]);
        BlockRead(f,Odpovede,6*24);
        BlockRead(f,Penale,24);
        Close(f);
        AktOtazka:=1;Body:=0;
        repeat
          ZmazObrazovku;
          VykresliMGP(TestMGPP[AktOtazka],@MBP,@MSFP[2]);
          Inc(Body,Penale[AktOtazka]);
          If Odpovede[AktOtazka,6]=255 then begin {vypis skore, je koniec testu}
            Str(Body,s);
            VypisPO(105,101,MSFP[2],s,Oranzova);
          end;
          StaraOtazka:=AktOtazka;
          repeat {nedovol stlacit nemoznu odpoved 1..5}
            ch:=CitajKlaves;
            if (ch in ['1'..'5']) and (Odpovede[AktOtazka,byte(ch)-48]>0) then AktOtazka:=Odpovede[AktOtazka,byte(ch)-48];
            if not (ch in ['1'..'5']) and (Odpovede[AktOtazka,6]>0) then AktOtazka:=Odpovede[AktOtazka,6];
            if ch=#27 then AktOtazka:=255;
          until AktOtazka<>StaraOtazka;
        until AktOtazka=255;
      end;
      7:begin { galeria obrazkov }
        for i:=5 downto 1 do begin
          NastavPaletu(MPP[i+1]);
          PrilepBMP(0,0,MBP[i]);
          CakajNaUdalost;
        end;
      end;
    end;
    NastavPaletu(MPP[2]);
    PrilepBMP(0,0,MBP[1]);
    VykresliMGP(MGPP[1],@MBP,@MSFP);
  until Udalost=8;
  ZavriGrafiku;
  WriteLn('MukoSoft mini encyklop‚dia'#13#10'Lubos Saloky, 1997'#13#10'Obr zky: CD Vrtuln¡k.'#13#10+
          'Text: Encyklop‚dia astron¢mie.');
END.
