program Zvuk;
uses Crt;
const BaseIO=$220;
      IRQ=5;
     ResetPort=BaseIO+$6;
     ReadPort=BaseIO+$A;
     WritePort=BaseIO+$C;
     PollPort=BaseIO+$E;
var AutoInit:boolean;
    DSPVersion:real;
    i,PICMaskPort:word;
    IRQIntVector:byte;
    IRQStopMask,IRQStartMask:byte;
    procedure WriteDSP(Value:byte);
begin
  repeat until (Port[WritePort] and $80) = 0;
  Port[WritePort]:=Value;
end;
function ReadDSP: byte;
begin
  repeat until (Port[PollPort] and $80) <> 0;
  ReadDSP:=Port[ReadPort];
end;
BEGIN
{ ----- Reset DSP ----- }
  Port[ResetPort]:=1;
  Delay(1);
  Port[ResetPort]:=0;
  i:=100;
  while (ReadDSP<>$AA) and (i>0) do Dec(i);
{ ----- zisti verziu DSP ----- }
  WriteDSP($E1);
  DSPVersion:=ReadDSP;
  DSPVersion:=DSPVersion+ReadDSP/100;
  AutoInit:=DSPVersion>2.0;
  if IRQ<=7 then begin
    IRQIntVector  := $08+IRQ;
    PICMaskPort   := $21;
  end else begin
    IRQIntVector  := $70+IRQ-8;
    PICMaskPort   := $A1;
  end;
  IRQStopMask  := 1 shl (IRQ mod 8);
  IRQStartMask := not(IRQStopMask);
{ ----- Compute DMA ports and parameters ----- }
  (*DMAMaskPort     := $0A;
  DMAClrPtrPort   := $0C;
  DMAModePort     := $0B;
  DMABaseAddrPort := $00 + 2*DMA;
  DMACountPort    := $01 + 2*DMA;
  case DMA
    of
      0:  DMAPagePort := $87;
      1:  DMAPagePort := $83;
      2:  DMAPagePort := $81;
      3:  DMAPagePort := $82;
    end;
  DMAStopMask  := DMA + $04;       {000001xx}
  DMAStartMask := DMA + $00;       {000000xx}
  if AutoInit
    then DMAMode := DMA + $58      {010110xx}
    else DMAMode := DMA + $48;     {010010xx}
  AckPort := BaseIO + $E;
  if AutoInit
    then DMALength := BufferLength
    else DMALength := BlockLength;
  InstallHandler;*)


END.