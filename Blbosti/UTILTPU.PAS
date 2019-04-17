unit okienka;
interface
procedure KurzorOn;
procedure KurzorOff;

implementation
  procedure KurzorOn; 		{Zaciatok KurzorOn}
  var __CX__:word;
  begin
    asm
      mov cx,__cx__;
      mov ah,1;
      int $10;
    end
  end;
  procedure KurzorOff;            {Zaciatok KurzorOff}
  var __cx__:word;
  begin
    asm
      mov ah,3;
      mov bh,0;
      int $10;
      mov __cx__,cx;
      mov ch,1;
      mov cl,0;
      mov ah,1;
      int $10;
    end
  end;                             {koniec KurzorOff}
end.                               {koniec Implementation}