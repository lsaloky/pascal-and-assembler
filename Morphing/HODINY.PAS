program Hodiny_s_morphujucimi_cislicami;
uses Graph,Crt,Dos;
const gd:integer=1;
      gm:integer=2;
      cesta='d:\bp\bgi';
      pomer=5;                                          {velkost cislic}
      kroky=45;                                         {pocet snimkov animacie}
      posunx:array[1..6] of byte=(0,45,105,150,210,255);{x-ova suradnica jednotlivych cislic}
      posuny=40;                                        {y-ova suradnica}
      {pozicia zaciatkov jednotlivych animacii}
      indexcisla:array[1..11] of word=(1,28,54,88,122,148,184,218,252,291,326);
type ciara=record
             x1z,y1z,x2z,y2z,x1k,y1k,x2k,y2k:integer;
           end;
var f:file;                                      {HODINY.DAT}
    pciar:array[1..255] of byte;                 {pocet ciar animacie jednotlivych cislic}
    c:array[1..326] of Ciara;                    {tu je vychodzia poloha animacie}
    Cis:array[1..6,1..326] of Ciara;             {v tomto poli sa animuja}
    x,y,z:integer;                               {cykly}
    hod,min,sec,s100,hodn,minn,secn,s100n:word;  {zistovanie casu}
    cifry:array[1..6] of byte;                   {aktualnie cifry}
    ZmenaCifry:array[1..6] of boolean;           {ci sa ma morfovat cislica}
    MCifry:array[1..6] of byte;                  {pomocne pole pre cifry}
BEGIN
{ ----- inicializacia ----- }
  Assign(f,'hodiny.dat');
  reset(f,1);
  BlockRead(f,x,1);
  BlockRead(f,pciar,255);
  BlockRead(f,c,5216);
  Close(f);
  GetTime(hod,min,sec,s100);
  cifry[1]:=hod div 10;      {vypocet cifier}
  cifry[2]:=hod mod 10;
  cifry[3]:=min div 10;
  cifry[4]:=min mod 10;
  cifry[5]:=sec div 10;
  cifry[6]:=sec mod 10;
  InitGraph(gd,gm,cesta);
  SetColor(white);
  Circle(97,80,5);           {dvojbodky}
  Circle(202,80,5);
  Circle(97,60,5);
  Circle(202,60,5);
  for x:=1 to 6 do           {pociatocne vykreslenie}
    for y:=indexcisla[Cifry[x]+1] to indexcisla[Cifry[x]+2]-1 do
      line(c[y].x1z div pomer+posunx[x],
        c[y].y1z div pomer+posuny,
        c[y].x2z div pomer+posunx[x],
        c[y].y2z div pomer+posuny);
  for x:=1 to 6 do ZmenaCifry[x]:=False;
  repeat
{ ----- inicializacia pola Cis. Prepisuje sa morphingom, preto ho treba vzdy inicializovat ----- }
    for z:=1 to 6 do
      for x:=1 to 326 do begin
        Cis[z,x].x1z:=c[x].x1z div pomer+posunx[z];
        Cis[z,x].y1z:=c[x].y1z div pomer+posuny;
        Cis[z,x].x2z:=c[x].x2z div pomer+posunx[z];
        Cis[z,x].y2z:=c[x].y2z div pomer+posuny;
        Cis[z,x].x1k:=c[x].x1k div pomer+posunx[z];
        Cis[z,x].y1k:=c[x].y1k div pomer+posuny;
        Cis[z,x].x2k:=c[x].x2k div pomer+posunx[z];
        Cis[z,x].y2k:=c[x].y2k div pomer+posuny;
      end;
{ ----- morphing ----- }
    for x:=1 to kroky+1 do begin               {x - cislo snimky}
      SetColor(0);
      for z:=1 to 6 do                         {z - index spracuvanej cislice}
        if Cifry[z]<>0 then MCifry[z]:=Cifry[z]-1
        else MCifry[z]:=9;
      for z:=1 to 6 do  {mazanie}
        if ZmenaCifry[z] then                  {y - prejde vsetky ciary}
          for y:=indexcisla[MCifry[z]+1] to indexcisla[MCifry[z]+2]-1 do
            Line(Cis[z,y].x1k,Cis[z,y].y1k,Cis[z,y].x2k,Cis[z,y].y2k);
      SetColor(white);
      for z:=1 to 6 do  {znovuvykreslovanie}
        if ZmenaCifry[z] then
          for y:=indexcisla[MCifry[z]+1] to indexcisla[MCifry[z]+2]-1 do begin
            Line(Cis[z,y].x1z,Cis[z,y].y1z,Cis[z,y].x2z,Cis[z,y].y2z);
            Cis[z,y].x1k:=Cis[z,y].x1z;               {posun ciar}
            Cis[z,y].y1k:=Cis[z,y].y1z;
            Cis[z,y].x2k:=Cis[z,y].x2z;
            Cis[z,y].y2k:=Cis[z,y].y2z;
            Cis[z,y].x1z:=(c[y].x1z+((c[y].x1k-c[y].x1z)*x) div kroky)div pomer+posunx[z];
            Cis[z,y].y1z:=(c[y].y1z+((c[y].y1k-c[y].y1z)*x) div kroky)div pomer+posuny;
            Cis[z,y].x2z:=(c[y].x2z+((c[y].x2k-c[y].x2z)*x) div kroky)div pomer+posunx[z];
            Cis[z,y].y2z:=(c[y].y2z+((c[y].y2k-c[y].y2z)*x) div kroky)div pomer+posuny;
      end;
      asm                                              {cakanie na VOI}
                 mov dx,03DAh
      @vz1:      in al,dx
                 and al,08h
                 jnz @vz1
      @vz2:      in al,dx
                 and al,08h
                 jz @vz2
      end;
    end;
    repeat                                             {cakanie na zmenu casu}
      GetTime(hodn,minn,secn,s100n);
    until cifry[6]<>secn mod 10;
{ ----- zistenie, ktore cislice sa maju morfovat ----- }
    if cifry[1]<>hodn div 10 then begin
      cifry[1]:=hodn div 10;
      ZmenaCifry[1]:=True;
    end else ZmenaCifry[1]:=False;
    if cifry[2]<>hodn mod 10 then begin
      cifry[2]:=hodn mod 10;
      ZmenaCifry[2]:=True;
    end else ZmenaCifry[2]:=False;
    if cifry[3]<>minn div 10 then begin
      cifry[3]:=minn div 10;
      ZmenaCifry[3]:=True;
    end else ZmenaCifry[3]:=False;
    if cifry[4]<>minn mod 10 then begin
      cifry[4]:=minn mod 10;
      ZmenaCifry[4]:=True;
    end else ZmenaCifry[4]:=False;
    if cifry[5]<>secn div 10 then begin
      cifry[5]:=secn div 10;
      ZmenaCifry[5]:=True;
    end else ZmenaCifry[5]:=False;
    Cifry[6]:=secn mod 10;
    ZmenaCifry[6]:=True;
  until KeyPressed;
  CloseGraph;
  WriteLn('MukoSoft hodinky s morfuj£cimi c¡slicami.'#13#10'Lubos Saloky, 1997');
END.