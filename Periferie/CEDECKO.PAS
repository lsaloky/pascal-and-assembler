program Ovladanie_CD;
const RequestHeader:record
        Dlzka,SubUnit,Prikaz:byte;
        Status:word;
        Rezerva:array[1..8] of byte;
      end=(Dlzka:13;SubUnit:0;Prikaz:$88);
{Prikaz:   $85: pri hrajucom CD je to PAUSE
                v stave PAUSE je to STOP
           $88  RESUME AUDIO - to iste ako $85 }
var DriveLetters:array[1..8] of char;
BEGIN
  asm
{ ----- zistenie poctu CD-ROMiek v BX ----- }
             mov ax,1500h
             mov bx,0000h
             int 2Fh  {BX - pocet CD-rom, CX - 1. CD-ROM (0=A)}
{ ----- zistenie pismena, za ktorym sa skryva CD-ROM ---- }
             mov ax,ds
             mov es,ax
             lea bx,DriveLetters    {ES:BX je adresa buffra, kde sa ulozia pismena CD-ROMiek}
             mov ax,150Dh
             int 2Fh                {0 = 'A'}
{ ----- Pause Audio ----- }
             mov ax,ds
             mov es,ax
             mov ax,1510h
             mov cl,byte ptr DriveLetters
             xor ch,ch
             lea bx,RequestHeader
             int 2Fh
  end;
END.