program FloydVAssembleri;{omyl v implementacii Floyd-Steinbergovho algoritmu}
var x,y:word;
    xNa2,yNa2,BodL:longint;
BEGIN
  BodL:=0;xNa2:=1;yNa2:=1;x:=1;y:=1;
  asm
             cld
             mov ax,12h      {inicializacia grafiky}
{             int 10h}
             mov ax,0A000h
             mov es,ax
             mov dx,03C4h    {  PortW[$3C4]:=$0F02 - do vsetkych bitovych rovin}
             mov ax,0102h
{             out dx,ax}
@DalsiBod:   {mov ax,word ptr BodL
             mov dx,word ptr BodL+2}

             mov ax,word ptr xNa2
             mov dx,word ptr xNa2+2
             add ax,word ptr yNa2
             adc dx,word ptr yNa2+2

             mov ax,3        {iniclializacia textoveho rezimu}
             int 10h
  end;
END.
