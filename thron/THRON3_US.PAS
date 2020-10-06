PROGRAM Thron;

USES
  crt,graph,speaker,stuff,graphlab;

CONST
  MaxPl  =  6;           { Mitspieler }

TYPE
  Report = record
    Name: string;
    Score,Lost,Games: longint
  end;
  Status = record
    Score,Lost,Entry: integer;
    X,Y,Dir: real;
    Alive: boolean
  end;
  SetupRecord = record
    Players,Rounds,Border,Detonation,DirMode: integer;
    Chaos,Ignore,Noise,Tournament: boolean;
    SetSpeed,SetAccel,TimeLimit: integer;
    Entry: array[1..MaxPl] of integer
  end;
  Amorph = object
    x,y: integer;
    Color: byte;
    procedure Move;
    procedure Init;
  end;

CONST
  MaxThr    = 20;           { Eintr„ge }
  MaxRounds = 10;
  MaxX      = 639;          { Bildschirmbreite }
  MaxY      = 479;          { Bildschirmh”he }

  SpeedGrades =  5;
  AccelGrades =  4;
  DirModes    =  7;
  BorderNum   = 19;
  DetoNum     =  4;

  DelFac = 300;

  AbortKey  = #27;
  ResumeKey = #13;
  PauseKey  =  #8;

  NoName    = '---';        { Name fr unbenutzten Eintrag }
  CompuName = 'PC';         { Computerspieler }
  Version   = '07.01.98';

  Colors: array[1..MaxPl] of integer
    = (lightred,lightgreen,lightcyan,yellow,lightmagenta,lightblue);

  Left:   array[1..MaxPl] of char = ('z','n','[','1','q','6');
  Right:  array[1..MaxPl] of char = ('x','m',']','2','a','9');

  Speeds: array[1..SpeedGrades-1] of integer = (3800,2500,1100,500);
  Accels: array[1..AccelGrades] of real = (1,0.999,0.998,0.996);

  SpeedSign: array[1..SpeedGrades] of string[6]
    = ('slow  ','medium','fast  ','ultra ','random');

  AccelSign: array[1..AccelGrades] of string[6]
    = ('none  ','low   ','medium','high  ');

  DirModeSign: array[1..DirModes] of string[12]
    = ('Triangles   ','96ø Madness ','Classic     ','PentaThron  ',
       'HexaThron   ','OctoThron   ','Crash Cars  ');

  BorderSign: array[1..BorderNum] of string[10]
    = ('No border', 'Horizontal', 'Vertical',   'Complete',
       'Madness',   'Insane',     'Duble Plus', 'The Cave',
       'Shlalom',   'Great X',    'Brackets',   'I luv U',
       'Tubism',    'The Arena',  'The Maze',   'Amorphous',
       'Briggle',   'AcidMode',   'Swift');

  DetoSign: array[1..DetoNum] of string[8]
    = ('off     ','Nuke''em ','Kamikaze','Splatter');

  PlayerSign: array[2..MaxPl] of string
    = ('two  ','three','four ','five ','six  ');

  OnOff: array[0..1] of string = ('off','on ');

  DefaultSettings: SetupRecord
    = (Players:2;   Rounds:3;      Border:4;    Detonation:1;     DirMode:3;
       Chaos:false; Ignore: false; Noise:true;  Tournament:false;
       SetSpeed:2;  SetAccel:1;    TimeLimit:0; Entry:(1,2,3,4,5,6));

VAR
  gd,gm,i,j:   integer;
  PlayerFile:  file of Report;
  Thronner:    array[1..MaxThr] of Report;
  SetupFile:   file of SetupRecord;
  SetupData:   SetupRecord;
  Player:      array[1..MaxPl] of Status;

  Quit,Cancel,TimeOut: boolean;

  RoundCount,BodyCount,Speed: integer;
  Accel,DirFactor: real;
  Key: char;
  Time: longint;
  Amorphous: Amorph;


{---------------------------------------------------------------------------}

function Result(n: integer):integer;
begin
  with Thronner[n] do
    Result:=Score-Lost
end;

function Rating(n: integer):integer;
begin
  with Thronner[n] do
    if (Games*Lost)>0 then
      Rating:=round(((Score+Games-Lost)/(2*Games))*100)
    else
     if Name=NoName then
       Rating:=-1
     else Rating:=0
end;

function PluralS(n: integer): string;
begin
  if n<>1 then PluralS:='s'
  else PluralS:=''
end;


{---------------------------------------------------------------------------}

PROCEDURE Amorph.Init;
begin
  X:=random(getmaxx);
  Y:=random(getmaxy);
end;

PROCEDURE Amorph.Move;
begin
  inc(x,random(9)-4);
  inc(y,random(9)-4);
  if x>getmaxx then x:=0;
  if x<0 then x:=getmaxx;
  if y>getmaxy then y:=0;
  if y<0 then y:=getmaxy;
  case SetupData.Border of
    18: Color:=getpixel(x,y);
  end;
  setcolor(Color);
  line(x,y,x+random(9)-4,y+random(9)-4);
end;

{---------------------------------------------------------------------------}

procedure ThronError;
begin
  clrscr;
  writeln('Thron Disk Error No. ',ioresult);
  halt
end;

procedure Init;
begin
  initsnd;
  playsnd('*---<<');
  randomize;
  assign(PlayerFile,'players.dat');
  assign(SetupFile,'setup.dat');
  {$I-}
  reset(PlayerFile);
  if ioresult<>0 then begin
    rewrite(PlayerFile);
    if ioresult<>0 then ThronError;
    for i:=1 to MaxThr do with Thronner[i] do begin
      seek(PlayerFile,i);
      Name:=NoName;
      if i=1 then Name:='Lazarus';
      if i=2 then Name:='Halifax';
      Lost:=0;
      Score:=0;
      Games:=0;
      write(PlayerFile,Thronner[i])
    end
  end;
  close(PlayerFile);
  reset(SetupFile);
  if ioresult<>0 then
  begin
    rewrite(SetupFile);
    if ioresult<>0 then ThronError;
    seek(SetupFile,1);
    SetupData:=DefaultSettings;
    write(SetupFile,SetupData)
  end;
  {$I+}
  Quit:=false
end;

procedure DataIn;
begin
  {$I-}
  reset(PlayerFile);
  for i:=1 to MaxThr do
  begin
    seek(PlayerFile,i);
    read(PlayerFile,Thronner[i]);
    if ioresult<>0 then ThronError
  end;
  close(PlayerFile);
  reset(SetupFile);
  seek(SetupFile,1);
  read(SetupFile,SetupData);
  if ioresult<>0 then ThronError;
  close(SetupFile);
  {$I+}
  for i:=1 to MaxPl do
    Player[i].Entry:=SetupData.Entry[i];
  Speed:=Speeds[SetupData.SetSpeed];
  Accel:=Accels[SetupData.SetAccel]
end;

PROCEDURE DataOut;
begin
  for i:=1 to MaxPl do
    SetupData.Entry[i]:=Player[i].Entry;
  reset(PlayerFile);
  for i:=1 to MaxThr do begin
    seek(PlayerFile,i);
    write(PlayerFile,Thronner[i])
  end;
  close(PlayerFile);
  reset(SetupFile);
  seek(SetupFile,1);
  write(SetupFile,SetupData);
  close(SetupFile)
end;

PROCEDURE MakeNoise(n: integer);
begin
  if Setupdata.Noise then
    case n of
      1: if Time mod 6=0 then begin sound(100); delay(1); nosound end;
      2: playsnd('chcgcd<af>')
    end
end;

PROCEDURE OutBlueText(y: integer; s: string);
begin
  settextstyle(sansseriffont,0,4);
  setcolor(blue);
  outtextxy((MaxX-textwidth(s)) div 2-1,MaxY div 2+y+1,s);
  setcolor(lightblue);
  outtextxy((MaxX-textwidth(s)) div 2,MaxY div 2+y,s);
  setcolor(white);
  outtextxy((MaxX-textwidth(s)) div 2+1,MaxY div 2+y-1,s);
end;

PROCEDURE ShowList;
begin
  gotoxy(1,1);
  textcolor(white);
  writeln('       #  Name               Rating   Score  Crashes  Games  Result');
  textcolor(lightcyan);
  for i:=1 to MaxThr do with Thronner[i] do begin
    write('       ',chr(i+96),') ',Name);
    gotoxy(28,i+1);
    if Games>0 then writeln(Rating(i):7,Score:8,Lost:8,Games:8,Result(i):8)
      else writeln('-':7,'-':8,'-':8,'-':8,'-':8)
  end
end;

PROCEDURE SelectPlayer(n: integer);
begin
  clrscr;
  Cancel:=false;
  repeat
    ShowList;
    gotoxy(8,23);
    textcolor(white);
    write('Select entry or press escape');
    Key:=readkey;
    if Key in ['a'..'t'] then begin
      i:=ord(Key)-96;
      if Thronner[i].Name=NoName then with Thronner[i] do
      begin
        textcolor(Colors[n]);
        gotoxy(8,23);
        write('New player''s name? .................');
        gotoxy(27,23);
        readln(Name)
      end;
      with Player[n] do begin
        Entry:=i;
        Cancel:=true
      end
    end
  until Cancel or (Key=AbortKey);
  textcolor(black);
  clrscr
end;

PROCEDURE KillPlayer;
begin
  clrscr;
  ShowList;
  textcolor(lightred);
  gotoxy(8,23);
  writeln('Kill which player?');
  Cancel:=false;
  repeat
    Key:=readkey;
    if Key in ['a'..'t'] then begin
      i:=ord(Key)-96;
      if Thronner[i].Name<>NoName then begin
        gotoxy(8,23);
        textcolor(lightmagenta);
        writeln('Kill ',Thronner[i].Name,'? (Yes/No)  ');
        repeat Key:=readkey until Key in ['y','n'];
        if Key='y' then with Thronner[i] do begin
          Name:=NoName;
          Score:=0;
          Lost:=0;
          Games:=0
        end;
        Cancel:=true
      end
    end
  until Cancel or (Key=AbortKey);
  textcolor(black);
  clrscr
end;

PROCEDURE SortRoster;
var EntryMemo: array[1..MaxPl] of string;

procedure SwapThron(a,b: integer);
  var c: Report;
  begin
    c:=Thronner[a];
    Thronner[a]:=Thronner[b];
    Thronner[b]:=c
  end;

begin
  for i:=1 to MaxPl do
    EntryMemo[i]:=Thronner[Player[i].Entry].Name;
  for i:=1 to MaxThr-1 do
    for j:=1 to MaxThr-i do
      if Rating(j) < Rating(j+1) then
        SwapThron(j,j+1)
      else if Rating(j) = Rating(j+1) then
        if Result(j) < Result(j+1) then
          SwapThron(j,j+1);
  for i:=1 to MaxPl do
    for j:=1 to MaxThr do
      if Thronner[j].Name=EntryMemo[i] then
        Player[i].Entry:=j;
  textcolor(black);
  clrscr;
  ShowList;
  gotoxy(8,23);
  textcolor(white);
  write('Press Enter or Escape...');
  repeat until readkey in [AbortKey,ResumeKey];
  textcolor(black);
  clrscr
end;


{---------------------------------------------------------------------------}

PROCEDURE Setup;
begin
  textbackground(black);
  textcolor(black);
  clrscr;
  repeat
    gotoxy(1,1);
    textcolor(white);
    writeln('Welcome to THRON!               Version ',Version);
    writeln('~~~~~~~~~~~~~~~~~');
    writeln;
    textcolor(lightgray);
    with SetupData do begin
      write('Players = ',PlayerSign[Players]);
      gotoxy(25,wherey);
      writeln('Time Limit = ',TimeLimit:5);
      if Tournament then
        write('Rounds = ',BorderNum)
      else
        write('Rounds = ',Rounds:2);
      gotoxy(25,wherey); writeln('Detonation = ',DetoSign[Detonation]);

      write('Tournament = ',OnOff[ord(Tournament)]);
      gotoxy(25,wherey);  writeln('Noise = ',OnOff[ord(Noise)]);
      writeln;
      if Tournament then write('Border = All Levels')
      else write('Border = ',BorderSign[Border],'    ');
      gotoxy(25,wherey);  writeln('Chaos = ',OnOff[ord(Chaos)]);
      write('Speed = ',SpeedSign[SetSpeed]);        writeln('          Directions = ',DirModeSign[DirMode]);
      write('Acceleration = ',AccelSign[SetAccel]); writeln('   IgnoreMode = ',OnOff[ord(Ignore)]);
    end;
    writeln;
    writeln('Kill player');
    writeln('League table');
    writeln;
    writeln('1..',MaxPl,' to select player. Enter to start game!');
    writeln;
    for i:=1 to SetupData.Players do begin
      textcolor(Colors[i]);
      writeln('Player ',i,': [',Left[i],'] [',Right[i],'] - ',
        chr(Player[i].Entry+96),') ',Thronner[Player[i].Entry].Name)
    end;
    textcolor(black);
    for i:=1 to MaxPl-2 do
      delline;
    Colorize(1, 4,1,30); Colorize(27,4,1,30);
    Colorize(1, 5,1,30); Colorize(26,5,1,30);
    Colorize(1, 6,1,30); Colorize(25,6,1,30);
    Colorize(1, 8,1,30); Colorize(25,8,1,30);
    Colorize(1, 9,1,30); Colorize(25,9,1,30);
    Colorize(1,10,1,30); Colorize(25,10,1,30);
    Colorize(1,12,1,30);
    Colorize(1,13,1,30);
    Colorize(1,15,4,30); Colorize(24,15,5,30);
    Key:=readkey;
    with SetupData do begin
      case Key of
      '1'..chr(MaxPl+48):
           begin
             val(Key,j,j);
             SelectPlayer(j)
           end;
      'p': Players:=((Players+4) mod (MaxPl-1))+2;
      'r': Rounds:=Rounds mod MaxRounds+1;
      'n': Noise:=true>Noise;
      'm': TimeLimit:=(TimeLimit+4000) mod 16000;
      'i': Ignore:=true>Ignore;
      'd': DirMode:=DirMode mod DirModes+1;
      'c': Chaos:=true>Chaos;
      't': Tournament:=true>Tournament;
      'e': Detonation:=Detonation mod DetoNum+1;
      'b': Border:=Border mod BorderNum+1;
      's': SetSpeed:=SetSpeed mod SpeedGrades+1;
      'a': SetAccel:=SetAccel mod AccelGrades+1;
      'k': KillPlayer;
      'l': SortRoster;
      ResumeKey:
           for i:=1 to Players do
             if Thronner[Player[i].Entry].Name=NoName then Key:='*';
      AbortKey:
           Quit:=true
      end
    end
  until (Key=ResumeKey) or Quit;
  for i:=1 to SetupData.Players do with Player[i] do begin
    Score:=0;
    Lost:=0
  end
end;


{----------------------------------------------------------------------------}

PROCEDURE GetReady;
begin
  clearviewport;
  delay(DelFac);
  if SetupData.Tournament then
    OutBlueText(-60,BorderSign[RoundCount])
  else
  if SetupData.Rounds>1 then
    begin
      if RoundCount=1 then
        OutBlueText(-60,'First round')
      else if RoundCount=SetupData.Rounds then
        OutBlueText(-60,'Last round')
      else begin
        OutBlueText(-60,'Round '+Strg(RoundCount))
      end
    end
  else
    OutBlueText(-60,'Game start');
  delay(2*DelFac);
  OutBlueText(0,'Get Ready!');
  delay(4*DelFac)
end;

PROCEDURE Grafik;
begin
  clearviewport;
  setcolor(white);
  setfillstyle(solidfill,black);
  setlinestyle(0,0,1);
  case SetupData.Border of
     2: for i:=0 to 1 do line(0,i*MaxY,MaxX,i*MaxY);
     3: for i:=0 to 1 do line(i*MaxX,0,i*MaxX,MaxY);
     4: rectangle(0,0,MaxX,MaxY);
     5: begin
          line(0,MaxY div 2,MaxX,MaxY div 2);
          line(MaxX div 2,0,MaxX div 2,MaxY)
        end;
     6: begin
          Ellipse(MaxX,0,180,270,MaxX div 2,MaxY div 2);
          Ellipse(0,MaxY,0,90,MaxX div 2,MaxY div 2);
        end;
     7: begin
          line(3*MaxX div 4,0,3*MaxX div 4,MaxY div 2);
          line(MaxX div 2,MaxY div 4,MaxX,MaxY div 4);
          line(0,3*MaxY div 4,MaxX div 2,3*MaxY div 4);
          line(MaxX div 4,MaxY div 2,MaxX div 4,MaxY);
        end;
     8: begin
          for i:=0 to 1 do line(MaxX*i,0,MaxX*i,MaxY div 3);
          for i:=0 to 1 do line(0,MaxY*i,MaxX div 4,MaxY*i);
          for i:=0 to 1 do line(3*MaxX div 4,MaxY*i,MaxX,MaxY*i);
          line(MaxX div 4,MaxY,MaxX div 4,3*MaxY div 4);
          line(3*MaxX div 4,MaxY,3*MaxX div 4,3*MaxY div 4);
          ellipse(MaxX div 2,3*MaxY div 4,0,180,MaxX div 4,2*MaxY div 5);
        end;
     9: begin
          moveto(0,0);
          lineto(0,MaxY div 4);
          lineto(MaxX div 2,2*MaxY div 3);
          lineto(MaxX,MaxY div 4);
          lineto(MaxX,0);
          line(MaxX div 2,2*MaxY div 3,MaxX div 2,MaxY);
        end;
    10: begin
          line(0,MaxY div 4, MaxX,3*MaxY div 4);
          line(3*MaxX div 4,0, MaxX div 4,MaxY)
        end;
    11: begin
          ellipse(MaxX div 2,MaxY div 2,300,60,MaxX div 3,MaxY div 3);
          ellipse(MaxX div 2,MaxY div 2,120,240,MaxX div 3,MaxY div 3);
        end;
    12: begin
          line(MaxX div 6,MaxY div 5,MaxX div 6,2*MaxY div 3);
          line(5*MaxX div 6,2*MaxY div 3,5*MaxX div 6,MaxY div 5);
          line(MaxX div 12,MaxY div 5,MaxX div 4,MaxY div 5);
          line(3*MaxX div 4,MaxY div 5,11*MaxX div 12,MaxY div 5);
          ellipse(MaxX div 2,2*MaxY div 3,180,0,MaxX div 3,MaxY div 4);
        end;
    13: begin
          line(0,MaxY,MaxX div 4,0);
          line(MaxX div 4,MaxY,MaxX div 2,0);
          line(MaxX div 2,MaxY,3*MaxX div 4,0);
          line(3*MaxX div 4,MaxY,MaxX,0);
        end;
    14: begin
          rectangle(MaxX div 4,MaxY div 4,3*MaxX div 4,3*MaxY div 4);
          setfillstyle(widedotfill,lightblue);
          floodfill(1,1,white);
        end;
    15: begin
          Labyrinth(0,0,639,479,9,6);
          setcolor(black);
          line(0,159,0,236);
          line(639,159,639,236);
        end;
    16: begin
          Amorphous.Init;
          Amorphous.Color:=white
        end;
    17,18:
        begin
          Amorphous.Init;
          Amorphous.Color:=black
        end;
  end
end;

PROCEDURE Detonate(x,y,n: integer);
begin
  setcolor(black);
  setfillstyle(solidfill,black);
  case SetupData.Detonation of
    2: begin  {Nuke'em}
         PieSlice(x,y,0,360,15);
         setfillstyle(solidfill,white);
         setcolor(white);
         circle(x,y,15);
         floodfill(x,y,white);
         setcolor(black);
         circle(x,y,15);
         setfillstyle(solidfill,black);
         floodfill(x,y,black)
       end;
    3: begin  {Kamikaze}
         PieSlice(x,y,0,360,15);
         setfillstyle(closedotfill,Colors[n]);
         setcolor(white);
         circle(x,y,15);
         floodfill(x,y,white);
         setcolor(black);
         circle(x,y,15)
       end;
    4: begin  {Scatter}
         PieSlice(x,y,0,360,5);
         for j:=1 to 10 do
           putpixel(x+random(9)-4,y+random(9)-4,Colors[i]);
         for j:=1 to 15 do
           putpixel(x+random(19)-9,y+random(19)-9,Colors[i])
       end
  end
end;

PROCEDURE Swift;
begin
  setfillstyle(solidfill,black);
  bar(random(640),random(480),random(640),random(480))
end;

FUNCTION Blocked(n,PosX,PosY: integer): boolean;
begin
  Blocked:=false;
  if (getpixel(round(PosX),round(PosY))>0) then
    if SetupData.Ignore then
    begin
      if getpixel(round(PosX),round(PosY))<>Colors[n] then
        Blocked:=true
    end
    else
      Blocked:=true
end;

PROCEDURE CPlayer(n: integer);
var a,Fwd,Lft,Rgt,MinRange,MaxRange: integer;
begin
  MinRange := 8;
  MaxRange := 12;
  with Player[n] do
  begin
    Lft:=MaxRange;
    Rgt:=MaxRange;
    for Fwd:=4 to MaxRange do
      if Blocked(n,round(X+sin(Dir)*Fwd),round(Y+cos(Dir)*Fwd)) then
      begin
        for a:=1 to MinRange do
          if Blocked(n,round(X+sin(Dir+DirFactor)*a),round(Y+cos(Dir+DirFactor)*a)) then
          begin
            Lft:=a;
            a:=MinRange
          end;
        for a:=1 to MinRange do
          if Blocked(n,round(X+sin(Dir-DirFactor)*a),round(Y+cos(Dir-DirFactor)*a)) then
          begin
            Rgt:=a;
            a:=MinRange
          end;
        if (Fwd<Rgt) or (Fwd<Lft) then
        begin
          if Lft=Rgt then
            Lft:=Lft+2*Random(2)-1;
          if Lft>Rgt then
            Dir:=Dir+DirFactor
          else
            Dir:=Dir-DirFactor
        end;
        Fwd:=MaxRange
      end
  end
end;

PROCEDURE Game;
var NeuX,NeuY: real;
    CPlayers: set of byte;
begin
  CPlayers:=[];
  with SetupData do
  begin
    if SetSpeed=5 then Speed:=random(3500)+500
      else Speed:=Speeds[SetSpeed];
    Accel:=Accels[SetAccel];
    case DirMode of
      1: DirFactor:=pi/1.5;  { 120ø drei Richtungen  }
      2: DirFactor:=8*pi/15; { 96ø  etwas verrckt   }
      3: DirFactor:=pi/2;    { 90ø  vier Richtungen  }
      4: DirFactor:=pi/2.5;  { 72ø  fnf Richtungen  }
      5: DirFactor:=pi/3;    { 60ø  sechs Richtungen }
      6: DirFactor:=pi/4;    { 45ø  acht Richtungen  }
      7: DirFactor:=pi/6;    { 30ø  zw”lf Richtungen }
    end
  end;
  for i:=1 to SetupData.Players do with Player[i] do
  repeat
    if Thronner[Player[i].Entry].Name=CompuName then
      include(CPlayers,i);
    Alive:=true;
    X:=random(MaxX div 2)+MaxX div 4;
    Y:=random(MaxY div 2)+MaxY div 4;
    if SetupData.Chaos then
      Dir:=2*pi*random
    else
      Dir:=random(round(2*pi/DirFactor))*DirFactor;
    for j:=1 to 30 do
      if (getpixel(round(X+sin(Dir)*j),round(Y+cos(Dir)*j)) > 0) then
        Alive:=false
  until Alive;
  Cancel:=false;
  BodyCount:=0;
  Time:=0;
  repeat
    case SetupData.Border of
      16..18: Amorphous.Move;
      19: if time mod 500=0 then Swift;
    end;
    for i:=1 to SetupData.Players do with Player[i] do
      if Alive then begin
        NeuX:=X+sin(Dir);
        NeuY:=Y+cos(Dir);
        if not ((round(NeuX)=round(X)) and (round(NeuY)=round(Y))) then
        begin
          with SetupData do begin
            if round(NeuX)>MaxX then NeuX:=NeuX-MaxX;
            if round(NeuX)<0 then NeuX:=NeuX+MaxX;
            if round(NeuY)>MaxY then NeuY:=NeuY-MaxY;
            if round(NeuY)<0 then NeuY:=NeuY+MaxY
          end;
          if Blocked(i,round(NeuX),round(NeuY)) then
            begin
              Alive:=false;
              inc(BodyCount);
              inc(Player[i].Lost);
              if SetupData.Detonation>1 then Detonate(round(NeuX),round(NeuY),i);
              MakeNoise(2)
            end
        end;
        X:=NeuX;
        Y:=NeuY;
        if Alive then putpixel(round(X),round(Y),Colors[i])
      end;
    delay(Speed div 100);
    if random(10000)<Speed then Speed:=trunc(Speed*Accel);
    inc(Time);
    if (SetupData.TimeLimit>0) and (Time>SetupData.TimeLimit) then TimeOut:=true;
    MakeNoise(1);
    if Time mod SetupData.Players+1 in CPlayers
      then
        CPlayer(Time mod SetupData.Players+1);
    while keypressed do begin
      Key:=readkey;
      case Key of
        AbortKey:  Cancel:=true;
        PauseKey:  repeat until readkey=PauseKey;
        't': begin DirectVideo:=false; gotoxy(1,1); textcolor(white); write(Time); DirectVideo:=true end;
        #59..chr(58+MaxPl):
                   with Player[ord(Key)-58] do
                     if Thronner[Entry].Name=CompuName then
                       putpixel(round(X+sin(Dir)),round(Y+cos(Dir)),darkgray);
      end;
      for i:=1 to SetupData.Players do with Player[i] do begin
        if (Key=Right[i]) and (Thronner[Entry].Name<>CompuName) then
          Dir:=Dir-DirFactor;
        if (Key=Left[i]) and (Thronner[Entry].Name<>CompuName) then
          Dir:=Dir+DirFactor
      end
    end
  until (BodyCount>=SetupData.Players-1) or Cancel or TimeOut;
  if not (Cancel or TimeOut) then begin
    for i:=1 to SetupData.Players do with Player[i] do
      if Alive then inc(Score,SetupData.Players-1);
    delay(6*DelFac)
  end
end;

PROCEDURE Results;
var s: string;
begin
  cleardevice;
  s:='Standings after '+Strg(RoundCount)+' round'+PluralS(RoundCount);
  OutBlueText(-230,s);
  settextstyle(sansseriffont,0,3);
  for i:=1 to SetupData.Players do
    for j:=-1 to 0 do with Player[i] do begin
      setcolor(Colors[i]+j*8);
      s:=Thronner[Entry].Name+': '
        +Strg(Score-Lost)+' point'+PluralS(Score-Lost)+'. ('
        +Strg(Score)+'-'+Strg(Lost)+')';
      outtextxy((MaxX-textwidth(s)) div 2+j,i*50-j+25,s)
    end;
  settextstyle(sansseriffont,0,3);
  OutBlueText(160,'Results are transmitted to PlayerRoster.');
  OutBlueText(200,'Press Enter to return to game setup...');
  repeat Key:=readkey until Key in [AbortKey,ResumeKey];
  if Key=AbortKey then Quit:=true;
  for i:=1 to SetupData.Players do with Thronner[Player[i].Entry] do begin
    inc(Lost,Player[i].Lost);
    inc(Score,Player[i].Score);
    inc(Games,RoundCount)
  end;
end;


{---------------------------------------------------------------------------}

BEGIN
  Init;
  DataIn;
  repeat
    Setup;
    if not Quit then begin
      RoundCount:=0;
      gd:=detect;
      initgraph(gd,gm,'');
      moveto(0,0);
      setviewport(0,0,MaxX,MaxY,clipon);
      if SetupData.Tournament then
        repeat
          inc(RoundCount);
          SetupData.Border:=RoundCount;
          TimeOut:=false;
          GetReady;
          Grafik;
          Game
        until (RoundCount=BorderNum) or Cancel
      else
        repeat
          inc(RoundCount);
          TimeOut:=false;
          GetReady;
          Grafik;
          Game
        until (RoundCount=SetupData.Rounds) or Cancel;
      Results;
      closegraph
    end
  until Quit;
  DataOut;
  endsnd;
  textcolor(lightgray);
  clrscr;
  writeln('Bye!');
  writeln
END.
