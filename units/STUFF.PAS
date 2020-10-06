UNIT Stuff;

INTERFACE

var
  Cancelled: boolean;  { TRUE, falls das letzte ReadStr/ReadInt/ReadLongInt abgebrochen wurde }
  NoValue:   boolean;  { TRUE, falls das letzte Value(s) keinen Wert liefern konnte }

{ String-Funktionen }
function Grossschreib  (s: string):          string;     { Konvertiert alle Buchstaben eines Strings zu Gro·buchstaben }
function Kleinschreib  (s: string):          string;     { Konvertiert alle Buchstaben eines Strings zu Kleinbuchstaben }
function Rechtsbuendig (s: string; n: byte): string;     { Stellt s in eine rechtsbÅndigen Zeichenkette zu n Zeichen }
function Linksbuendig  (s: string; n: byte): string;     { Stellt s in eine linksbÅndigen Zeichenkette zu n Zeichen }
function Zentriert     (s: string; n: byte): string;     { Zentriert s in einer Zeichenkette zu n Zeichen }

function Strg(Zahl: longint): string;                    { Konvertiert eine Zahl in einen String }
function Value(Text: string): integer;                   { Liefert den Zahlenwert eines Strings (Fehler=0) }

function LeftEnd(Text: string; Chars: byte): string;     { Liefert die ersten n Zeichen eines Strings }
function RightEnd(Text: string; Chars: byte): string;    { Liefert die letzten n Zeichen eines Strings }
function Spc(n: byte): string;                           { Liefert einen String bestehend aus n Leerzeichen }
function Gliederzahl(z: longint): string;                { Schreibt 4- oder mehrstellige Zahlen mit Trennpunkten }

function CharInString(c: char; s: string): boolean;      { Liefert TRUE, wenn c in s vorkommt }

{ Kalender-Funktionen }
function Datum: string;                                  { Liefert das Systemdatum in einem String }
function Zeit: string;                                   { Liefert die Systemzeit in einem String }
function Schaltjahr(Jahr: integer): boolean;             { Liefert TRUE, wenn "Jahr" ein Schaltjahr ist }

{ Crt-Operationen }
function GetChar(x,y: byte): byte;                       { Liefert das Zeichen von Position (x,y) }
function GetColor(x,y: byte): byte;                      { Liefert die Farbe von Position (x,y) }
procedure WriteXY(x,y: byte; text: string);              { Schreibt einen String auf Position (x,y) }
procedure Colorize(x,y,Zeichen,Farbe: byte);             { FÑrbt n Zeichen ab Position (x,y) }
procedure NormalCursor;                                  { Cursor wird normal }
procedure BlockCursor;                                   { Cursor wird gro· }
procedure HideCursor;                                    { Cursor verschwindet }

procedure ReadStr(var StrVar: string; MaxLength: byte; break: boolean);       { Liest einen String ein }
procedure ReadLongInt(var IntVar: longint; Min,Max: longint; break: boolean); { Liest eine LongInt-Variable ein }
procedure ReadInt(var IntVar: integer; Min,Max: integer; break: boolean);     { Liest eine Integer-Variable ein }

{ Tauschoperationen: vertauschen jeweils die Inhalte zweier Variablen des angegebenen Typs }
procedure SwapByte(var a,b: byte);
procedure SwapInt(var a,b: integer);
procedure SwapShortInt(var a,b: shortint);
procedure SwapWord(var a,b: word);
procedure SwapLongInt(var a,b: longint);
procedure SwapReal(var a,b: real);
procedure SwapChar(var a,b: char);
procedure SwapStr(var a,b: string);
procedure SwapBoolean(var a,b: boolean);

{ Sonstiges }
function Inside(x,y,x1,y1,x2,y2: integer): boolean;      { PrÅft, ob der Punkt (x,y) im Rechteck (x1..x2,y1..y2) liegt }
function Wuerfel(Anzahl,Seiten: integer): integer;       { Liefert ein WÅrfelergebnis mit n WÅrfeln von jeweils m Seiten }
function Zufall(Min,Max: integer): integer;              { Liefert eine Zufallszahl zwischen Min und Max }
function Roemisch(x: integer): string;                   { Konvertiert eine Integer-Zahl in eine rîmische Zahl }
function Arabisch(s: string): integer;                   { Konvertiert eine rîmische Zahl in eine Integer-Zahl }
{----------------------------------------------------------------------------}

IMPLEMENTATION

uses
  crt,dos,Mathe;

var LastTime,SystemTime: record Hour,Min,Sec,Sec100: word end;
    TimerRuns: boolean;

const
  Buchstaben = 56;

  KleineBuchstaben: string[Buchstaben]
  = 'abcdefghijklmnopqrstuvwxyzÑÉ†ÖÜ∆âàÇäãå°çîì¢ï‰Åñ£óëá–§õËÏ';

  GrosseBuchstaben: string[Buchstaben]
  = 'ABCDEFGHIJKLMNOPQRSTUVWXYZé∂µ∑è«”“ê‘ÿ◊÷ﬁô‚‡„ÂöÍÈÎíÄ—•ùÁÌ';

  RoemischeZiffern: array[1..7] of char
  = ('M','D','C','L','X','V','I');
  RoemischeWerte: array[1..7] of integer
  = (1000,500,100,50,10,5,1);

{-- String-Funktionen -------------------------------------------------------}

function Kleinschreib(s: string): string;
var Position,BuchstabeNr: byte;
begin
  for Position:=1 to length(s) do
    begin
      for BuchstabeNr:=1 to Buchstaben+1 do
        if s[Position]=GrosseBuchstaben[BuchstabeNr] then break;
      if BuchstabeNr<=Buchstaben then
        s[Position]:=KleineBuchstaben[BuchstabeNr]
    end;
  Kleinschreib:=s;
end;

function Grossschreib(s: string): string;
var Position,BuchstabeNr: byte;
begin
  for Position:=1 to length(s) do
    begin
      for BuchstabeNr:=1 to Buchstaben+1 do
        if s[Position]=KleineBuchstaben[BuchstabeNr] then break;
      if BuchstabeNr<=Buchstaben then
        s[Position]:=GrosseBuchstaben[BuchstabeNr]
    end;
  Grossschreib:=s;
end;

function Strg(Zahl: longint): string;
var Text: string;
begin
  str(Zahl,Text);
  Strg:=Text
end;

function Value(Text: string): integer;
var Wert,Fehler: integer;
begin
  val(Text,Wert,Fehler);
  NoValue:=Fehler>0;
  if Fehler>0 then Wert:=0;
  Value:=Wert
end;

function LeftEnd(Text: string; Chars: byte): string;
begin
  Leftend:=copy(Text,1,Chars)
end;

function RightEnd(Text: string; Chars: byte): string;
begin
  RightEnd:=copy(Text,length(Text)-Chars+1,Chars)
end;

function Spc(n: byte): string;
var i: byte; Space: string;
begin
  Space:='';
  for i:=1 to n do
    Space:=Space+' ';
  Spc:=Space
end;

function CharInString(c: char; s: string): boolean;
var z: integer;
begin
  CharInString:=false;
  for z:=1 to length(s) do
    if c=s[z] then CharInString:=true
end;

function Rechtsbuendig(s: string; n: byte): string;
begin
  if n>=length(s) then
    Rechtsbuendig:=Spc(n-length(s))+s
  else Rechtsbuendig:=RightEnd(s,n)
end;

function Linksbuendig(s: string; n: byte): string;
begin
  if n>=length(s) then
    Linksbuendig:=s+Spc(n-length(s))
  else Linksbuendig:=LeftEnd(s,n)
end;

function Zentriert(s: string; n: byte): string;
begin
  if n>=length(s) then
    Zentriert:=Spc((n-length(s)) div 2)+s+Spc((n-length(s)) div 2)+
               Spc((n+length(s)) mod 2)
  else Zentriert:=copy(s,n-length(s),n)
end;

function Gliederzahl(z: longint): string;
begin
  if z<0 then
    Gliederzahl:='-'+Gliederzahl(-z)
  else
    if (z<1000) then
      Gliederzahl:=Strg(z mod 1000)
    else
      Gliederzahl:=Gliederzahl(z div 1000)+'.'+copy('000',1,3-length(Strg(z mod 1000)))+Strg(z mod 1000)
end;


{-- Kalender-Funktionen -----------------------------------------------------}

function Datum: string;
const
  Tage: array[0..6] of string
    = ('Sonntag','Montag','Dienstag','Mittwoch',
       'Donnerstag','Freitag','Samstag');
  Monate: array[1..12] of string
    = ('Januar','Februar','MÑrz','April','Mai','Juni','Juli',
       'August','September','Oktober','November','Dezember');
var Jahr,Monat,Tag,Wochentag: word;
begin
  getdate(Jahr,Monat,Tag,Wochentag);
  Datum:=Tage[Wochentag]+', der '+Strg(Tag)+'. '
    +Monate[Monat]+' '+Strg(Jahr);
end;

function Zeit: string;
var Stunde,Minute,Sekunde,HSekunde: word;
begin
  gettime(Stunde,Minute,Sekunde,HSekunde);
  Zeit:=Strg(Stunde)+':'+Strg(Minute)+' Uhr'
end;

function Schaltjahr(Jahr: integer): boolean;
begin
  Schaltjahr:= (Jahr mod 4=0) and (Jahr mod 100<>0)
end;


{-- Dos-Video Operationen ---------------------------------------------------}

function GetChar(x,y: byte): byte;
begin
  inc(x,WindMin mod 256);
  inc(y,WindMin div 256);
  GetChar:=mem[$B800:2*(x-1)+160*(y-1)]
end;

function GetColor(x,y: byte): byte;
begin
  inc(x,WindMin mod 256);
  inc(y,WindMin div 256);
  GetColor:=mem[$B800:2*(x-1)+160*(y-1)+1]
end;

procedure WriteXY(x,y: byte; Text: string);
var i,Startpos: integer;
begin
  inc(x,WindMin mod 256);
  inc(y,WindMin div 256);
  Startpos:=2*(x-2)+160*(y-1);
  for i:=1 to length(Text) do
    mem[$B800:Startpos+2*i]:=ord(Text[i]);
end;

procedure Colorize(x,y,Zeichen,Farbe: byte);
var i,Startpos: integer;
begin
  inc(x,WindMin mod 256);
  inc(y,WindMin div 256);
  Startpos:=2*(x-2)+160*(y-1)+1;
  for i:=1 to Zeichen do
    mem[$B800:Startpos+2*i]:=Farbe
end;

procedure CursorSize(High,Low: byte);
var R: registers;
begin
  R.AH:=$01;
  R.AL:=$00;
  R.CH:=High;
  R.CL:=Low;
  intr($10,R)
end;

procedure NormalCursor;
begin
  CursorSize(11,12);
end;

procedure HideCursor;
begin
  CursorSize($ff,$ff);
end;

procedure BlockCursor;
begin
  CursorSize(0,13);
end;

procedure ReadStr(var StrVar: string; MaxLength: byte; Break: boolean);
var Eingabe: char;
    Einfg: boolean;
    CursorX,PosX: byte;
    Text: string;
begin
  Cancelled:=false;
  Einfg:=true;
  Text:='';
  PosX:=wherex;
  CursorX:=1;
  repeat
    WriteXY(PosX,wherey,Spc(MaxLength+1));
    WriteXY(PosX,wherey,Text);
    gotoxy(CursorX+PosX-1,wherey);
    Eingabe:=readkey;
    case Eingabe of
      #0: {Scancode}
          begin
            Eingabe:=readkey;
            case Eingabe of
              {links}  #75: if CursorX>1 then dec(CursorX);
              {rechts} #77: if (CursorX<=MaxLength) and (CursorX<length(Text)) then inc(CursorX);
              {Entf}   #83: if CursorX<=MaxLength then delete(Text,CursorX,1);
              {Ende}   #79: CursorX:=length(Text)+1;
              {Pos1}   #71: CursorX:=1;
              {Einfg}  #82: begin
                              Einfg:=true>Einfg;
                              if Einfg then NormalCursor else BlockCursor
                            end
            end;
          end;
      #8: {Backspace}
          if CursorX>1 then
            begin
              dec(CursorX);
              delete(Text,CursorX,1);
            end;
      #32..#254:
          if Einfg then
            begin
              if length(Text)<MaxLength then insert(Eingabe,Text,CursorX)
                else
                  Text[CursorX]:=Eingabe;
              if CursorX<=MaxLength then inc(CursorX);
            end
          else
            begin
              if length(Text)<MaxLength then
                begin
                  delete(Text,CursorX,1);
                  insert(Eingabe,Text,CursorX)
                end
              else
                Text[CursorX]:=Eingabe;
              if CursorX<=MaxLength then inc(CursorX);
            end;
      #27: if Break then Cancelled:=true;
    end
  until (Eingabe=#13) or Cancelled;
  if not Einfg then NormalCursor;
  if not Cancelled then StrVar:=Text
end;

procedure ReadLongInt(var IntVar: longint; Min,Max: longint; break: boolean);
var Eingabe: char;
    Digits,PosX,MaxDigits: byte;
    Minus: boolean;
    Zahl: longint;
begin
  Cancelled:=false;
  if Min>Max then SwapLongInt(Max,Min);
  if Max>200000000 then Max:=200000000;
  if Min<-200000000 then Min:=-200000000;
  if abs(Max)>=abs(Min) then MaxDigits:=length(Strg(abs(Max)))
                        else MaxDigits:=length(Strg(abs(Min)));
  PosX:=wherex;
  gotoxy(PosX+MaxDigits,wherey);
  repeat
    Digits:=0;
    Zahl:=0;
    Minus:=false;
    repeat
      WriteXY(PosX,wherey,Spc(MaxDigits+1));
      if Minus then WriteXY(PosX,wherey,'-');
      if Digits>0 then
        WriteXY(PosX+MaxDigits-Digits+1,wherey,Strg(abs(Zahl)))
        else WriteXY(PosX+MaxDigits,wherey,'0');
      Eingabe:=readkey;
      case Eingabe of
        #0:  Eingabe:=readkey;
        #8:  begin
               if Zahl<>0 then dec(Digits);
               Zahl:=Zahl div 10
             end;
        '+': begin Zahl:=abs(Zahl); if Minus then Minus:=false end;
        '-': if Min<0 then begin Zahl:=-Zahl; Minus:=Minus<true end;
        '0'..'9': if (Digits<MaxDigits) then
                    if abs(Zahl)*10+Value(Eingabe)<=200000000 then
                    begin
                      if Minus then Zahl:=Zahl*10-Value(Eingabe)
                               else Zahl:=Zahl*10+Value(Eingabe);
                      Digits:=length(Strg(abs(Zahl)))
                    end;
        #27: if Break then Cancelled:=true
      end
    until (Eingabe=#13) or Cancelled;
  until ((Zahl>=Min) and (Zahl<=Max)) or Cancelled;
  if not Cancelled then IntVar:=Zahl
end;

procedure ReadInt(var IntVar: integer; Min,Max: integer; break: boolean);
var IntVar2: longint;
begin
  IntVar2:=IntVar;
  ReadLongInt(IntVar2,Min,Max,break);
  IntVar:=IntVar2;
end;

{-- Sonstiges ---------------------------------------------------------------}

function Inside(x,y,x1,y1,x2,y2: integer): boolean;
begin
  Inside:=(x>x1) and (x<x2) and (y>y1) and (y<y2)
end;

function Wuerfel(Anzahl,Seiten:integer): integer;
var i,Summe: integer;
begin
  Summe:=0;
  for i:=1 to anzahl do
    inc(Summe,random(Seiten)+1);
  Wuerfel:=Summe
end;

function Zufall(Min,Max: integer): integer;
begin
  Zufall:=random(Max-Min+1) + Min
end;

function Roemisch(x: integer): string;
var s: string;
    i,j: integer;
begin
  s:='';
  for i:=1 to 7 do begin
    while x>=RoemischeWerte[i] do begin
      dec(x,RoemischeWerte[i]);
      s:=s+RoemischeZiffern[i]
    end;
    for j:=7 downto i+1+ord(odd(i)) do
      if x-(x mod RoemischeWerte[j])=RoemischeWerte[i]-RoemischeWerte[j] then
      begin
        dec(x,RoemischeWerte[i]-RoemischeWerte[j]);
        s:=s+RoemischeZiffern[j]+RoemischeZiffern[i]
      end;
  end;
  Roemisch:=s;
end;

function Arabisch(s: string): integer;
var i, Wert, Wert_davor, Summe: integer;
begin
  Wert:=0;
  Wert_davor:=0;
  Summe:=0;
  for i:=1 to length(s) do begin
    case upcase(s[i]) of
      'M': Wert:=1000;
      'D': Wert:=500;
      'C': Wert:=100;
      'L': Wert:=50;
      'X': Wert:=10;
      'V': Wert:=5;
      'I': Wert:=1;
    else
      begin
        Arabisch:=0; exit
      end
    end;
    if Wert_davor<Wert
      then dec(Summe,Wert_davor)
      else inc(Summe,Wert_davor);
    Wert_davor:=Wert;
  end;
  inc(Summe,Wert_davor);
  Arabisch:=Summe
end;

{-- Tauschoperationen -------------------------------------------------------}

procedure SwapByte(var a,b: byte);
var c: byte;
begin
  c:=a; a:=b; b:=c;
end;

procedure SwapShortInt(var a,b: shortint);
var c: shortint;
begin
  c:=a; a:=b; b:=c;
end;

procedure SwapInt(var a,b: integer);
var c: integer;
begin
  c:=a; a:=b; b:=c;
end;

procedure SwapWord(var a,b: word);
var c: word;
begin
  c:=a; a:=b; b:=c;
end;

procedure SwapLongInt(var a,b: longint);
var c: longint;
begin
  c:=a; a:=b; b:=c;
end;

procedure SwapReal(var a,b: real);
var c: real;
begin
  c:=a; a:=b; b:=c;
end;

procedure SwapChar(var a,b: char);
var c: char;
begin
  c:=a; a:=b; b:=c;
end;

procedure SwapStr(var a,b: string);
var c: string;
begin
  c:=a; a:=b; b:=c;
end;

procedure SwapBoolean(var a,b: boolean);
var c: boolean;
begin
  c:=a; a:=b; b:=c;
end;


{-- Init --------------------------------------------------------------------}

BEGIN
  NoValue:=true;
  Cancelled:=false
END.