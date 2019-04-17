program Test_klavesnice;
uses Crt,KeyBoard;
type Prvok=record
       x,y,Dlzka:word;
     end;
const PocR=12;
      Klav:array[1..PocR] of string=(
        '          Esc     F.1 F.2 F.3 F.4   F.5 F.6 F.7 F.8   F.9 F10 F11 F12',
        '          .`. .1. .2. .3. .4. .5. .6. .7. .8. .9. .0. .-. .=. .\. ..',
        '          .Tab. .q. .w. .e. .r. .t. .y. .u. .i. .o. .p. .[. .]. .....',
        '          .Caps. .a. .s. .d. .f. .g. .h. .j. .k. .l. .;. .'#39'. ..Enter.',
        '          .Shift.. .z. .x. .c. .v. .b. .n. .m. .,. ... ./. ..Shift...',
        '          .Ctrl.    .Alt. ........................... .Alt.    .Ctrl.',
        '                          PSc ScL Pau',
        '                          Ins Hom PUp    Num ./. .*. .-.',
        '                          Del End PDn    .7. .8. .9. ...',
        '                                         .4. .5. .6. ...',
        '                              ..        .1. .2. .3. ...',
        '                          .. .. ...    ...0... ... ...');
      Poz:array[1..44] of Prvok=(
        (x:10; y:0;  Dlzka:3),(x:66; y:2 ; Dlzka:3),(x:10; y:4;  Dlzka:5),
        (x:0 ; y:0;  Dlzka:0),(x:30; y:14; Dlzka:3),(x:30; y:16; Dlzka:3),
        (x:34; y:14; Dlzka:3),(x:34; y:16; Dlzka:3),(x:26; y:14; Dlzka:3),
        (x:26; y:16; Dlzka:3),(x:30; y:20; Dlzka:3),(x:26; y:22; Dlzka:3),
        (x:34; y:22; Dlzka:3),(x:30; y:22; Dlzka:3),(x:49; y:12; Dlzka:3),
        (x:53; y:12; Dlzka:3),(x:53; y:14; Dlzka:3),(x:45; y:12; Dlzka:3),
        (x:53; y:20; Dlzka:3),(x:0 ; y:0 ; Dlzka:0),(x:0 ; y:0 ; Dlzka:0),
        (x:0 ; y:0 ; Dlzka:0),(x:0 ; y:0 ; Dlzka:0),(x:0 ; y:0 ; Dlzka:0),
        (x:0 ; y:0 ; Dlzka:0),(x:0 ; y:0 ; Dlzka:0),(x:0 ; y:0 ; Dlzka:0),
        (x:0 ; y:0 ; Dlzka:0),(x:0 ; y:0 ; Dlzka:0),(x:0 ; y:0 ; Dlzka:0),
        (x:0 ; y:0 ; Dlzka:0),(x:0 ; y:0 ; Dlzka:0),(x:0 ; y:0 ; Dlzka:0),
        (x:0 ; y:0 ; Dlzka:0),(x:0 ; y:0 ; Dlzka:0),(x:0 ; y:0 ; Dlzka:0),
        (x:0 ; y:0 ; Dlzka:0),(x:0 ; y:0 ; Dlzka:0),(x:0 ; y:0 ; Dlzka:0),
        (x:0 ; y:0 ; Dlzka:0),(x:0 ; y:0 ; Dlzka:0),(x:0 ; y:0 ; Dlzka:0),
        (x:0 ; y:0 ; Dlzka:0),(x:0 ; y:0 ; Dlzka:0));
var x,y:word;
    Znak:char;ExtZnak:word;
BEGIN
{ ----- kreslenie obrazovky ----- }
  TextBackGround(0);TextColor(15);ClrScr;
  for x:=1 to PocR do begin
    for y:=1 to Length(Klav[x]) do begin
      TextBackGround(3);
      if Klav[x,y]=' ' then TextBackGround(0);
      if Klav[x,y]='.' then write(' ')
      else write(Klav[x,y]);
    end;
    writeln;writeln;
  end;
  TextBackGround(3);
  GotoXY(65,6);write('     ');
  GotoXY(53,9);write('.');
  GotoXY(51,23);write('.');
  GotoXY(54,18);write(' + ');
  GotoXY(54,22);write(' <¾');
  GotoXY(36,23);write(#26);
  GotoXY(1,24);TextBackGround(0);write('q - quit');
  repeat
    CitajZnak(Znak,ExtZnak);
    if ExtZnak>0 then
      for x:=1 to Poz[ExtZnak].Dlzka do
        Mem[$B800:Poz[ExtZnak].x*2+1+Poz[ExtZnak].y*160+(x-1)*2]:=15+2*16;
  until UpCase(Znak)='Q';
END.

