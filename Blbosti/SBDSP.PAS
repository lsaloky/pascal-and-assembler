{1) Load the sound data into memory
2) Set up the DMA chip for the tranfer
3) Set the DSP TIME_CONSTANT to the sampling rate
4) Write DMA_TYPE_VALUE value to the DSP
5) Write DATA_LENGTH to the DSP (2 bytes, LSB first) where
   DATA_LENGTH = number of bytes to send - 1
}
Unit sbDSP;

Interface

{ ResetDSP returns true if reset was successful
  base should be 1 for base address 210h, 2 for 220h etc... }
function ResetDSP(base : word) : boolean;

{ Write DAC sets the speaker output level }
procedure WriteDAC(level : byte);

{ ReadDAC reads the microphone input level }
function ReadDAC : byte;

{ SpeakerOn connects the DAC to the speaker }
function SpeakerOn: byte;

{ SpeakerOff disconnects the DAC from the speaker,
  but does not affect the DAC operation }
function SpeakerOff: byte;

{ Functions to pause DMA playback }
procedure DMAStop;
procedure DMAContinue;

{ Playback plays a sample of a given size back at a given frequency using
  DMA channel 1. The sample must not cross a page boundry }
procedure Playback(sound : Pointer; size : word; frequency : word);

Implementation

Uses Crt;

var      DSP_RESET : word;
     DSP_READ_DATA : word;
    DSP_WRITE_DATA : word;
  DSP_WRITE_STATUS : word;
    DSP_DATA_AVAIL : word;

function ResetDSP(base : word) : boolean;
begin

  base := base * $10;

  { Calculate the port addresses }
  DSP_RESET := base + $206;
  DSP_READ_DATA := base + $20A;
  DSP_WRITE_DATA := base + $20C;
  DSP_WRITE_STATUS := base + $20C;
  DSP_DATA_AVAIL := base + $20E;

  { Reset the DSP, and give some nice long delays just to be safe }
  Port[DSP_RESET] := 1;
  Delay(10);
  Port[DSP_RESET] := 0;
  Delay(10);
  if (Port[DSP_DATA_AVAIL] And $80 = $80) And
     (Port[DSP_READ_DATA] = $AA) then
    ResetDSP := true
  else
    ResetDSP := false;
end;

procedure WriteDSP(value : byte);
begin
  while Port[DSP_WRITE_STATUS] And $80 <> 0 do;
  Port[DSP_WRITE_DATA] := value;
end;

function ReadDSP : byte;
begin
  while Port[DSP_DATA_AVAIL] and $80 = 0 do;
  ReadDSP := Port[DSP_READ_DATA];
end;

procedure WriteDAC(level : byte);
begin
  WriteDSP($10);
  WriteDSP(level);
end;

function ReadDAC : byte;
begin
  WriteDSP($20);
  ReadDAC := ReadDSP;
end;

function SpeakerOn: byte;
begin
  WriteDSP($D1);
end;

function SpeakerOff: byte;
begin
  WriteDSP($D3);
end;

procedure DMAContinue;
begin
  WriteDSP($D4);
end;

procedure DMAStop;
begin
  WriteDSP($D0);
end;

procedure Playback(sound : Pointer; size : word; frequency : word);
var time_constant : word;
     page, offset : word;
begin

  SpeakerOn;

  size := size - 1;

  { Set up the DMA chip }

  offset := Seg(sound^) Shl 4 + Ofs(sound^);

  page := (Seg(sound^) + Ofs(sound^) shr 4) shr 12;

  Port[$0A] := 5;
  Port[$0C] := 0;
  Port[$0B] := $49;
  Port[$02] := Lo(offset);
  Port[$02] := Hi(offset);
  Port[$83] := page;
  Port[$03] := Lo(size);
  Port[$03] := Hi(size);
  Port[$0A] := 1;

  { Set the playback frequency }
  time_constant := 256 - 1000000 div frequency;
  WriteDSP($40);
  WriteDSP(time_constant);

  { Set the playback type (8-bit) }
  WriteDSP($14);
  WriteDSP(Lo(size));
  WriteDSP(Hi(size));
end;

end.

{
旼컴컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
� References �
읕컴컴컴컴컴켸

Title : The SoundBlaster Developpers Kit
Publishers : Creative Labs Inc
             Creative Technology PTE LTD

Title : Sound Blaster - The Official Book
Authors : Richard Heimlich, David M. Golden, Ivan Luk, Peter M. Ridge
Publishers : Osborne/McGraw Hill
ISBN : 0-07-881907-5

Some of the information in this file was either obtained from or verified
by the source code in a public domain library called SOUNDX by Peter
Sprenger. I haven't tried using his library yet (I don't have a C compiler
at the moment) but it looks very well done and contains numerous sound card
detection routines. Says Peter : "It would be nice, that when you make
something commercial with my routines, that you send me a copy of your
project or send me some bucks, just enough for pizza and coke to support my
night programming sessions. If you send me nothing, ok. But USE the stuff,
if you can need it!". Heh...a REAL programmer!

ftpsite: ftp.uwp.edu
directory: /pub/msdos/demos/programming/game-dev/source
filename: soundx.zip

旼컴컴컴컴컴컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
� Sound Familiar? �
읕컴컴컴컴컴컴컴컴�

What the...why is there a faint glimmer of sunlight outside? HOLY $#!^!! It's
5:30am! I'm goin' to bed!}

