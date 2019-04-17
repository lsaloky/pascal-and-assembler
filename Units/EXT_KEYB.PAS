unit Ext_Keyb;
                                INTERFACE
const KbEsc=1;KbBkSp=2;KbTab=3;KbEnter=4;
      KbHome=5;KbEnd=6;KbPgUp=7;KbPgDn=8;KbIns=9;KbDel=10;
      KbSHore=11;KbSVlavo=12;KbSVpravo=13;KbSDole=14;
      KbNKrat=15;KbNMinus=16;KbNPlus=17;KbNDeleno=18;KbNEnter=19;
      KbNHome=20;KbNEnd=21;KbNPgUp=22;KbNPgDn=23;KbNIns=24;KbNDel=25;
      KbNSHore=26;KbNSVlavo=27;KbNSVpravo=28;KbNSDole=29;
      KbF1=30;KbF2=31;KbF3=32;KbF4=33;KbF5=34;KbF6=35;KbF7=36;
      KbF8=37;KbF9=38;KbF10=39;KbF11=40;KbF12=41;
      KbCenterKey=42;{asi 5 pri zapnutom NumLock na NumPad-e}
      KbN5=43;       {asi 5 pri vypnutom NumLock na NumPad-e}
      KbPrtSc=44;
      KbShift=64;KbAlt=128;KbCtrl=256;
      InsOn=128;CapsOn=64;NumOn=32;ScrollOn=16;
procedure CitajZnak(var Znak:char;var ExtZnak:word);
                             IMPLEMENTATION
procedure CitajZnak(var Znak:char;var ExtZnak:word);
var x:word;
begin
  asm
             mov ax,10h
             int 16h
             mov x,ax
  end;
  Znak:=#0;ExtZnak:=0;StavLock:=0;
  case x of
    $0231,$7800,$4F31:Znak:='1';
    $0332,$0300,$7900,$5032:Znak:='2';{dalsie su pre Ctrl - niektore;Alt,NumPad}
    $0433,$7A00,$5133:Znak:='3';
    $0534,$7B00,$4B34:Znak:='4';
    $0635,$7C00,$4C35:Znak:='5';
    $0736,$071E,$7D00,$4D36:Znak:='6';
    $0837,$7E00,$4737,$4737:Znak:='7';
    $0938,$7F00,$4838:Znak:='8';
    $0A39,$8000,$4939:Znak:='9';
    $0B30,$8100,$5230:Znak:='0';
    $0C2D,$0C1F,$8200:Znak:='-';
    $0D3D,$8300:Znak:='=';
    $1071,$1011,$1000:Znak:='q';
    $1177,$1117,$1100:Znak:='w';
    $1265,$1205,$1200:Znak:='e';
    $1372,$1312,$1300:Znak:='r';
    $1474,$1414,$1400:Znak:='t';
    $1579,$1519,$1500:Znak:='y';
    $1675,$1615,$1600:Znak:='u';
    $1769,$1709,$1700:Znak:='i';
    $186F,$180F,$1800:Znak:='o';
    $1970,$1910,$1900:Znak:='p';
    $1A5B,$1A1B,$1A00:Znak:='[';
    $1B5D,$1B1D,$1B00:Znak:=']';
    $1E61,$1E01,$1E00:Znak:='a';
    $1F73,$1F13,$1F00:Znak:='s';
    $2064,$2004,$2000:Znak:='d';
    $2166,$2106,$2100:Znak:='f';
    $2267,$2207,$2200:Znak:='g';
    $2368,$2308,$2300:Znak:='h';
    $246A,$240A,$2400:Znak:='j';
    $256B,$250B,$2500:Znak:='k';
    $266C,$260C,$2600:Znak:='l';
    $273B,$2700:Znak:=';';
    $2827,$2800:Znak:=#39;{tu ma byt ta uvodzovka}
    $2960,$2900:Znak:='`';
    $2B5C,$2B1C,$2B00:Znak:='\';
    $2C7A,$2C1A,$2C00:Znak:='z';
    $2D78,$2D18,$2D00:Znak:='x';
    $2E63,$2E03,$2E00:Znak:='c';
    $2F76,$2F16,$2F00:Znak:='v';
    $3062,$3002,$3000:Znak:='b';
    $316E,$310E,$3100:Znak:='n';
    $326D,$320D,$3200:Znak:='m';
    $332C,$3300:Znak:=',';
    $342E,$3400,$532E:Znak:='.';{posledne pre NumPad}
    $352F,$3500:Znak:='/';
    $3920:Znak:=' ';
    $0221:Znak:='!';
    $0340:Znak:='@';
    $0423:Znak:='#';
    $0524:Znak:='$';
    $0625:Znak:='%';
    $075E:Znak:='^';
    $0826:Znak:='&';
    $092A:Znak:='*';
    $0A28:Znak:='(';
    $0B29:Znak:=')';
    $0C5F:Znak:='_';
    $0D2B:Znak:='+';
    $1051:Znak:='Q';
    $1157:Znak:='W';
    $1245:Znak:='E';
    $1352:Znak:='R';
    $1454:Znak:='T';
    $1559:Znak:='Y';
    $1655:Znak:='U';
    $1749:Znak:='I';
    $184F:Znak:='O';
    $1950:Znak:='P';
    $1A7B:Znak:='{';
    $1B7D:Znak:='}';
    $1E41:Znak:='A';
    $1F53:Znak:='S';
    $2044:Znak:='D';
    $2146:Znak:='F';
    $2247:Znak:='G';
    $2348:Znak:='H';
    $244A:Znak:='J';
    $254B:Znak:='K';
    $264C:Znak:='L';
    $273A:Znak:=':';
    $2822:Znak:='"';
    $297E:Znak:='~';
    $2B7C:Znak:='|';
    $2C5A:Znak:='Z';
    $2D58:Znak:='X';
    $2E43:Znak:='C';
    $2F56:Znak:='V';
    $3042:Znak:='B';
    $314E:Znak:='N';
    $324D:Znak:='M';
    $333C:Znak:='<';
    $343E:Znak:='>';
    $353F:Znak:='?';
    $011B,$0100:ExtZnak:=KbEsc;
    $0E08,$0E7F,$0E00:ExtZnak:=KbBkSp;
    $0F09,$0F00,$9400,$A500:ExtZnak:=KbTab;{Shift,Ctrl,Alt - nefunguje s preradovacmi}
    $1C0D,$1C0A,$1C00:ExtZnak:=KbEnter;
    $372A,$9600,$3700:ExtZnak:=KbNKrat;
    $3B00,$5400,$5E00,$6800:ExtZnak:=KbF1;{dalsie hodnoty su s preradovacmi, ktore su spracovane osobitne}
    $3C00,$5500,$5F00,$6900:ExtZnak:=KbF2;
    $3D00,$5600,$6000,$6A00:ExtZnak:=KbF3;
    $3E00,$5700,$6100,$6B00:ExtZnak:=KbF4;
    $3F00,$5800,$6200,$6C00:ExtZnak:=KbF5;
    $4000,$5900,$6300,$6D00:ExtZnak:=KbF6;
    $4100,$5A00,$6400,$6E00:ExtZnak:=KbF7;
    $4200,$5B00,$6500,$6F00:ExtZnak:=KbF8;
    $4300,$5C00,$6600,$7000:ExtZnak:=KbF9;
    $4400,$5D00,$6700,$7100:ExtZnak:=KbF10;
    $8500,$8700,$8900,$8B00:ExtZnak:=KbF11;
    $8600,$8800,$8A00,$8C00:ExtZnak:=KbF12;
    $4700,$7700:ExtZnak:=KbNHome;
    $4800,$8D00:ExtZnak:=KbNSHore;
    $4900,$8400:ExtZnak:=KbNPgUp;
    $4A2D,$4A2D,$8E00,$4A00:ExtZnak:=KbNMinus;
    $4B00,$7300:ExtZnak:=KbNSVlavo;
    $4C00,$8F00:ExtZnak:=KbCenterKey;
    $4D00,$7400:ExtZnak:=KbNSVpravo;
    $4E2B,$9000,$4E00:ExtZnak:=KbNPlus;
    $4F00,$7500:ExtZnak:=KbNEnd;
    $5000,$9100:ExtZnak:=KbNSDole;
    $5100,$7600:ExtZnak:=KbNPgDn;
    $5200,$9200:ExtZnak:=KbNIns;
    $5300,$9300:ExtZnak:=KbNDel;
    $565C,$567C:ExtZnak:=KbN5;
    $E00D,$E00A,$A600:ExtZnak:=KbNEnter;
    $7200:ExtZnak:=KbPrtSc;{len pre Ctrl}
    $47E0,$77E0,$9700:ExtZnak:=KbHome;
    $48E0,$8DE0,$9800:ExtZnak:=KBSHore;
    $49E0,$84E0,$9900:ExtZnak:=KbPgUp;
    $4BE0,$73E0,$9B00:ExtZnak:=KbSVlavo;
    $4DE0,$74E0,$9D00:ExtZnak:=KbSVpravo;
    $4FE0,$75E0,$9F00:ExtZnak:=KbEnd;
    $50E0,$91E0,$A000:ExtZnak:=KbSDole;
    $51E0,$76E0,$A100:ExtZnak:=KbPgDn;
    $52E0,$92E0,$A200:ExtZnak:=KbIns;
    $53E0,$93E0,$A300:ExtZnak:=KbDel;
  end;
{ ----- spracovanie preradovacov a Lock-ov ----- }
  asm
             mov al,$FF
             mov ah,$02
             int 16h
             mov x,ax
  end;
  if (x and InsOn)=1 then StavLock:=StavLock+InsOn;
  if (x and CapsOn)=1 then StavLock:=StavLock+CapsOn;
  if (x and NumOn)=1 then StavLock:=StavLock+NumOn;
  if (x and ScrollOn)=1 then StavLock:=StavLock+ScrollOn;
  if (x and $08)>0 then ExtZnak:=ExtZnak+KbAlt;
  if (x and $04)>0 then ExtZnak:=ExtZnak+KbCtrl;
  if (x and $03)>0 then ExtZnak:=ExtZnak+KbShift;
{ ----- tieto prikazy su tu kv“li sp„tnej kompatibilite s ReadKey ----- }
  case ExtZnak of
    KbNKrat:    Znak:='*';
    KbNDeleno:  Znak:='/';
    KbNPlus:    Znak:='+';
    KbNMinus:   Znak:='-';
  end;
  If (StavLock and NumOn)>0
    then case ExtZnak of
      KbNHome:    Znak:='7';
      KbNSHore:   Znak:='8';
      KbNPgUp:    Znak:='9';
      KbNSVlavo:  Znak:='4';
      KbCenterKey:Znak:='5';
      KbNSVpravo: Znak:='6';
      KbNEnd:     Znak:='1';
      KbNSDole:   Znak:='2';
      KbNPgDn:    Znak:='3';
      KbNIns:     Znak:='0';
      KbNDel:     Znak:='.';
    end;
end;
