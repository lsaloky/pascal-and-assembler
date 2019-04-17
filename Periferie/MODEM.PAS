{$R Modem}
uses WinTypes, WinProcs, WObjects, Strings;
type
  TEditLine = array[0..50] of Char;
const
  idEdit      = 100;
  idDial      = 201;
  idDialStart = 101;
  idPhoneNum  = 102;
  idConfigure = 202;
  id1200      = 101;
  id2400      = 102;
  id4800      = 103;
  id9600      = 104;
  idOdd       = 105;
  idEven      = 106;
  idNone      = 107;
  idComm1     = 108;
  idComm2     = 109;
  id1Stop     = 110;
  id2Stop     = 111;
  id7Data     = 112;
  id8Data     = 113;

  LineWidth   = 80;  { Width of each line displayed.                 }
  LineHeight  = 60;  { Number of line that are held in memory.       }

  { The configuration string bellow is used to configure the modem.  }
  { It is set for communication port 2, 2400 baud, No parity, 8 data }
  { bits, 1 stop bit.                                                }

  Comm  : Char = '2';
  Baud  : Word = 24;
  Parity: Char = 'n';
  Stop  : Char = '1';
  Data  : Char = '8';

  DialStart: TEditLine = 'ATDT';
  PhoneNumber: TEditLine = '';


type
  TApp = object(TApplication)
    procedure Idle; virtual;
    procedure InitMainWindow; virtual;
    procedure MessageLoop; virtual;
  end;

  PBuffer = ^TBuffer;
  TBuffer = object(TCollection)
    Pos: Integer;
    constructor Init(AParent: PWindow);
    procedure FreeItem(Item: Pointer); virtual;
    function PutChar(C: Char): Boolean;
  end;

  PCommWindow = ^TCommWindow;
  TCommWindow = object(TWindow)
    Cid: Integer;
    Buffer: PBuffer;
    FontRec: TLogFont;
    CharHeight: Integer;
    constructor Init(AParent: PWindowsObject; ATitle: PChar);
    destructor Done; virtual;
    procedure Configure(var Message: TMessage);
      virtual cm_First + idConfigure;
    procedure Dial(var Message: TMessage);
      virtual cm_First + idDial;
    procedure Error(E: Integer; C: PChar);
    procedure Paint(PaintDC: HDC; var PaintInfo: TPaintStruct); virtual;
    procedure ReadChar; virtual;
    procedure SetConfigure;
    procedure SetHeight;
    procedure SetUpWindow; virtual;
    procedure wmChar(var Message: TMessage);
      virtual wm_Char;
    procedure wmSize(var Message: TMessage);
      virtual wm_Size;
    procedure WriteChar;
  end;

{ TBuffer }
{ The Buffer is use to hold each line that is displayed in the main    }
{ window.  The constance LineHeight determines the number of line that }
{ are stored.  The Buffer is prefilled with the LineHeight worth of    }
{ lines.                                                               }
constructor TBuffer.Init(AParent: PWindow);
var
  P: PChar;
  I: Integer;
begin
  TCollection.Init(LineHeight + 1, 10);
  GetMem(P, LineWidth + 1);
  P[0] := #0;
  Pos := 0;
  Insert(P);
  for I := 1 to LineHeight do
  begin
    GetMem(P, LineWidth + 1);
    P[0] := #0;
    Insert(P);
  end;
end;

procedure TBuffer.FreeItem(Item: Pointer);
begin
  FreeMem(Item, LineWidth + 1);
end;

{ This procedure is process all incomming in formation from the com  }
{ port.  This procedure is called by TCommWindow.ReadChar.           }

function TBuffer.PutChar(C: Char): Boolean;
var
  Width: Integer;
  P: PChar;
begin
  PutChar := False;
  Case C of
    #13: Pos := 0;                          { if a Carriage Return.  }
    #10:                                    { if a Line Feed.        }
      begin
        GetMem(P, LineWidth + 1);
        FillChar(P^, LineWidth + 1, ' ');
        P[Pos] := #0;
        Insert(P);
      end;
    #8:
      if Pos > 0 then                       { if a Delete.           }
      begin
        Dec(Pos);
        P := At(Count - 1);
        P[Pos] := ' ';
      end;
   #32..#128:                               { else handle all other  }
    begin                                   { displayable characters.}
      P := At(Count - 1);
      Width := StrLen(P);
      if Width > LineWidth then             { if line is to wide     }
      begin                                 { create a new line.     }
        Pos := 1;
        GetMem(P, LineWidth + 1);
        P[0] := C;
        P[1] := #0;
        Insert(P);
      end
      else                                   { else add character    }
      begin                                  { to current line.      }
        P[Pos] := C;
        Inc(Pos);
        P[Pos] := #0;
      end;
    end;
  end;
  if Count > LineHeight then                 { if more to many lines }
  begin                                      { have been added delete}
    AtFree(0);                               { current line and let  }
    PutChar := True;                         { the call procedure    }
  end;                                       { know to scroll up.    }
end;

{ TCommWindow }
{ The CommWindow displays the incoming and out goinging text.  There  }
{ should be mention that the text type by the use is displayed by     }
{ being echo back to the ReadChar procedure.  So there is no need for }
{ wmChar to write a character to the screen.                          }
constructor TCommWindow.Init(AParent: PWindowsObject; ATitle: PChar);
begin
  TWindow.Init(AParent, ATitle);
  Attr.Style := Attr.Style or ws_VScroll;
  Attr.Menu := LoadMenu(HInstance, 'Menu_1');
  Scroller := New(PScroller, Init(@Self, 1, 1, 100, 100));
  Buffer := New(PBuffer, Init(@Self));
end;

{ Close the Comm port and deallocate the Buffer.                      }
destructor TCommWindow.Done;
begin
  Error(CloseComm(Cid), 'Close');
  Dispose(Buffer, Done);
  TWindow.Done;
end;

procedure TCommWindow.Configure(var Message: TMessage);
var
  Trans: record
    R1200,
    R2400,
    R4800,
    R9600,
    ROdd,
    REven,
    RNone,
    RComm1,
    RComm2,
    R1Stop,
    R2Stop,
    R7Data,
    R8Data: Word;
  end;
  D: TDialog;
  P: PWindowsObject;
  I: Integer;
begin
  D.Init(@Self, 'Configure');
  For I := id1200 to id8Data do
    P := New(PRadioButton, InitResource(@D, I));
  With Trans do
  begin
    R1200 := Byte(Baud = 12);
    R2400 := Byte(Baud = 24);
    R4800 := Byte(Baud = 48);
    R9600 := Byte(Baud = 96);

    ROdd  := Byte(Parity = 'o');
    REven := Byte(Parity = 'e');
    RNone := Byte(Parity = 'n');

    RComm1 := Byte(Comm = '1');
    RComm2 := Byte(Comm = '2');

    R1Stop := Byte(Stop = '1');
    R2Stop := Byte(Stop = '2');

    R7Data := Byte(Data = '7');
    R8Data := Byte(Data = '8');
  end;
  D.TransferBuffer := @Trans;
  if D.Execute = id_Ok then
  begin
    with Trans do
    begin
      Baud := (R1200 * 12) + (R2400 * 24) + (R4800 * 48) + (R9600 * 96);
      if ROdd = bf_Checked then
        Parity := 'o';
      if REven = bf_Checked then
        Parity := 'e';
      if RNone = bf_Checked then
        Parity := 'n';
      if R1Stop = bf_Checked then
        Stop := '1'
      else
        Stop := '2';
      if RComm1 = bf_Checked then
        Comm := '1'
      else
        Comm := '2';
      if R7Data = bf_Checked then
        Data := '7'
      else
        Data := '8';
      SetConfigure;
    end;
  end;
  D.Done;
end;


procedure TCommWindow.Dial(var Message: TMessage);
var
  Trans: record
    Start: TEditLine;
    Phone: TEditLine;
  end;
  D: TDialog;
  P: PWindowsObject;
begin
  D.Init(@Self, 'Dial');
  P := New(PEdit, InitResource(@D, idDialStart, SizeOf(TEditLine)));
  P := New(PEdit, InitResource(@D, idPhoneNum, SizeOf(TEditLine)));
  StrCopy(Trans.Start, DialStart);
  StrCopy(Trans.Phone, PhoneNumber);
  D.TransferBuffer := @Trans;
  if D.Execute = id_Ok then
  begin
    StrCopy(DialStart, Trans.Start);
    StrCopy(PhoneNumber, Trans.Phone);
    StrCat(PhoneNumber, #13);
    StrCat(PhoneNumber, #10);
    if CID <> 0 then
    begin
      Error(WriteComm(CId, DialStart, StrLen(DialStart)), 'Writing');
      Error(WriteComm(CId, PhoneNumber, StrLen(PhoneNumber)), 'Writing');
    end;
    PhoneNumber[StrLen(PhoneNumber) - 2] := #0;
  end;
  D.Done;
end;


{ Checks for comm errors and writes any errors.                       }
procedure TCommWindow.Error(E: Integer; C: PChar);
var
  S: array[0..100] of Char;
begin
  if E >= 0 then exit;
  Str(E, S);
  MessageBox(GetFocus, S, C, mb_Ok);
end;

{ Redraw all the lines in the buffer by using ForEach.                }
procedure TCommWindow.Paint(PaintDC: HDC; var PaintInfo: TPaintStruct);
var
  I: Integer;
  Font: HFont;

  procedure WriteOut(Item: PChar); far;
  begin
    TextOut(PaintDC, 0, CharHeight * I, Item, StrLen(Item));
    inc(I);
  end;

begin
  I := 0;
  Font := SelectObject(PaintDC, CreateFontIndirect(FontRec));
  Buffer^.ForEach(@WriteOut);
  DeleteObject(SelectObject(PaintDC, Font));
end;

{ Read a charecter from the comm port, if there is no error then call }
{ Buffer^.PutChar to add it to the buffer and write it to the screen. }
procedure TCommWindow.ReadChar;
var
  Stat: TComStat;
  I, Size: Integer;
  C: Char;
begin
  GetCommError(CID, Stat);
  for I := 1 to Stat.cbInQue do
  begin
    Size := ReadComm(CId, @C, 1);
    Error(Size, 'Read Comm');
    if C <> #0 then
    begin
      if Buffer^.PutChar(C) then
      begin
        ScrollWindow(HWindow, 0, -CharHeight, Nil, Nil);
        UpDateWindow(HWindow);
      end;
      WriteChar;
    end;
  end;
end;

procedure TCommWindow.SetConfigure;
var
  Config: array[0..20] of Char;
  S: array[0..5] of Char;
  DCB: TDCB;
begin
  StrCopy(Config, 'com?:??,?,?,?');
  Config[3] := Comm;
  Config[8] := Parity;
  Config[10] := Data;
  Config[12] := Stop;
  Str(Baud, S);
  Config[5] := S[0];
  Config[6] := S[1];
  BuildCommDCB(Config, DCB);
  DCB.ID := CID;
  Error(SetCommState(DCB), 'Set Comm State');
end;

procedure TCommWindow.SetUpWindow;
var
  DCB: TDCB;
begin
  TWindow.SetUpWindow;
  SetHeight;

{ Open for Comm2 2400 Baud, No Parity, 8 Data Bits, 1 Stop Bit }

  Cid := OpenComm('COM2', 1024, 1024);
  Error(Cid, 'Open');
  SetConfigure;
  WriteComm(Cid, 'ATZ'#13#10, 5);  { Send a reset to Modem. }
end;

{ Call back function used only in to get record structure for fixed   }
{ width font.                                                         }
function GetFont(LogFont: PLogFont; TM: PTextMetric; FontType: Word;
  P: PCommWindow): Integer; export;
begin
  if P^.CharHeight = 0 then
  begin
    P^.FontRec := LogFont^;
    P^.CharHeight := P^.FontRec.lfHeight;
  end;
end;

{ Get the a fix width font to use in the TCommWindow.  Use EnumFonts  }
{ to save work of create the FontRec by hand.                         }
{ The TScroller of the main window is also updated know that the font }
{ height is known.                                                    }
procedure TCommWindow.SetHeight;
var
  DC: HDC;
  ProcInst: Pointer;
begin
  DC := GetDC(HWindow);
  CharHeight := 0;
  ProcInst := MakeProcInstance(@GetFont, HInstance);
  EnumFonts(DC, 'Courier', ProcInst, @Self);
  FreeProcInstance(ProcInst);
  ReleaseDC(HWindow, DC);

  Scroller^.SetUnits(CharHeight, CharHeight);
  Scroller^.SetRange(LineWidth, LineHeight);
  Scroller^.ScrollTo(0, LineHeight);
end;


{ Write the character from the pressed key to the Comuniction Port.   }
procedure TCommWindow.wmChar(var Message: TMessage);
begin
  if CID <> 0 then
    Error(WriteComm(CId, @Message.wParam, 1), 'Writing');
end;

procedure TCommWindow.wmSize(var Message: TMessage);
begin
  TWindow.wmSize(Message);
  Scroller^.SetRange(LineWidth, LineHeight - (Message.lParamhi div CharHeight));
end;

procedure TCommWindow.WriteChar;
var
  DC: HDC;
  Font: HFont;
  S: PChar;
  APos: Integer;
begin
  APos := Buffer^.Count - 1;
  S := Buffer^.AT(APos);
  APos := (APos - Scroller^.YPos) * CharHeight;
  if APos < 0 then exit;
  if Hwindow <> 0 then
  begin
    DC := GetDC(HWindow);
    Font := SelectObject(DC, CreateFontIndirect(FontRec));
    TextOut(DC, 0, APos, S, StrLen(S));
    DeleteObject(SelectObject(DC, Font));
    ReleaseDC(HWindow, DC);
  end;
end;

{ TApp }
procedure TApp.Idle;
var
  Stat: TComStat;
  I, Size: Integer;
  C: Char;
begin
  if MainWindow <> Nil then
    if MainWindow^.HWindow <> 0 then
      PCommWindow(MainWindow)^.ReadChar;
end;

procedure TApp.InitMainWindow;
begin
  MainWindow := New(PCommWindow, Init(Nil, 'Comm Test'));
end;

{ Add Idle loop to main message loop.                                 }
procedure TApp.MessageLoop;
var
  Message: TMsg;
begin
  while True do
  begin
    if PeekMessage(Message, 0, 0, 0, pm_Remove) then
    begin
      if Message.Message = wm_Quit then Exit;
      if not ProcessAppMsg(Message) then
      begin
        TranslateMessage(Message);
        DispatchMessage(Message);
      end;
    end
    else
      Idle;
  end;
  Status := Message.WParam;
end;

var
  App: TApp;
begin
  App.Init('Comm');
  App.Run;
  App.Done;
end.