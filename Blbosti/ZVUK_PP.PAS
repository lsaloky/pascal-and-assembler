program Praca_so_SB;
uses Detect,Smix;
var BaseIO:word;
    IRQ,DMA,DMA16:byte;
    Zvuk:PSound;
BEGIN
  GetSettings(BaseIO,IRQ,DMA,DMA16);
  InitSB(BaseIO,IRQ,DMA,0);
  InitMixing;
  InitXMS;
  InitSharing;
  OpenSoundResourceFile('blb1.snd');
  LoadSound(Zvuk,'HOVOR');
  StartSound(Zvuk,17,True);
  readln;
  FreeSound(Zvuk);
  CloseSoundResourceFile;
  ShutDownSharing;
  ShutDownMixing;
  ShutDownSB;
END.