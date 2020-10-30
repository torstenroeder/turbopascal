PROGRAM The_Bio_Engine;

{  torsten 1995  }

USES  crt;
TYPE  rekord=record
        score: longint;
        name:  string[15]
      end;
CONST weltx = 16;
      welty = 16;
      welts:  array[-1..3] of char='˙ ˛xo';
      weltf:  array[-1..3] of shortint=(2,2,10,9,6);
      bewert: array[0..8] of string=('Volltrottel','Dummbrot','Peter Pan',
                                     'Manfred','Keksman','KÑptn Novell',
                                     'Jim Beam','Chopin','Herrgott');
      progon: boolean=true;
      schulz: boolean=false;
VAR   welt:   array[0..weltx+1] of array[0..welty+1] of shortint;
      neu:    array[0..weltx+1] of array[0..welty+1] of shortint;
      high:   rekord;
      datei:  file of rekord;
      kox,koy,life,zyklus:  integer;
      sett,murd,born,kill:  integer;
      zykmax,submax,bonus:  integer;
      i,j,eff,score,punkte: longint;
      a:      char;
      laenge: string;


{---------- INITIALISIERUNG / SPIELMODUS ----------}

PROCEDURE initscores;
begin
  assign(datei,'biohigh.dat');
  {$I-}
  reset(datei);
  if ioresult <> 0 then
  begin
    rewrite(datei);
    if ioresult <> 0 then
    begin
      clrscr;
      write('Fehler beim Anlegen von "Biohigh.dat".');
      halt
    end;
    for i:=0 to 9 do
    begin
      seek(datei,i);
      high.score:=sqr(10-i)*10000;
      high.name:='Peter Pan';
      write(datei,high)
    end
  end;
  close(datei)
  {$I+}
end;

PROCEDURE init;
begin
  textbackground(1); textcolor(15); clrscr;
  for i:=0 to weltx+1 do
    for j:=0 to welty+1 do
      begin welt[i,j]:=0; neu[i,j]:=0 end;
  kox:=8; koy:=8;
  born:=0; kill:=0; sett:=0; murd:=0;
  zyklus:=0; score:=0; eff:=0;
  zykmax:=80; submax:=40
end;

PROCEDURE menu;
begin
  clrscr;
  writeln;
  writeln('  Spielmodus:');
  writeln('  ~~~~~~~~~~~');
  writeln('   f1  -   80 Zyklen      f5  -   40 Substrate');
  writeln('   f2  -  150 Zyklen      f6  -   55 Substrate');
  writeln('   f3  -  300 Zyklen      f7  -   80 Substrate');
  writeln('   f4  -  500 Zyklen      f8  -  100 Substrate');
  writeln; writeln('   Aktuelle Einstellung:');
  i:=4; j:=4;
  repeat
    bonus:=i*j;
    gotoxy(1,11);
    writeln('    Zyklen:    ',zykmax,' ');
    writeln('    Substrate: ',submax,' ');
    writeln('    Bonus:     x ',bonus,' ');
    a:=readkey;
    case a of
      chr(59): begin zykmax:=80; i:=4 end;
      chr(60): begin zykmax:=150; i:=3 end;
      chr(61): begin zykmax:=300; i:=2 end;
      chr(62): begin zykmax:=500; i:=1 end;
      chr(63): begin submax:=40; j:=4 end;
      chr(64): begin submax:=55; j:=3 end;
      chr(65): begin submax:=80; j:=2 end;
      chr(66): begin submax:=100; j:=1 end
    end
  until a=chr(13)
end;


{---------------  DAS GAME  ---------------}

PROCEDURE game;

    procedure screen;
    begin
      clrscr; textcolor(10);
      gotoxy(10,3); writeln('-=THE BIO-ENGINE=-');
      gotoxy(15,5); writeln('(c) 1995');
      textcolor(3);
      gotoxy(44,19); write('csr  Biodetektor bewegen');
      gotoxy(44,20); write('cr   Biosubstrat kreieren');
      gotoxy(44,21); write('spc  Biotop aktivieren (1 Zyklus)');
      gotoxy(44,22); write('p    Prognose an/aus');
      gotoxy(44,23); write('f10  Armageddon');
      gotoxy(44,24); write('esc  Exitus');
      textcolor(9); gotoxy(42,1);
      write('⁄'); for i:=1 to 35 do write('ƒ'); write('ø');
      for i:=2 to 17 do
      begin gotoxy(42,i); write('≥'); gotoxy(78,i); write('≥') end;
      gotoxy(42,18);
      write('¿'); for i:=1 to 35 do write('ƒ'); write('Ÿ');
      textbackground(0);
    end;

    procedure zeigwelt;
    begin
      textbackground(0);
      for i:=1 to weltx do for j:=1 to welty do
      begin
        textcolor(weltf[welt[i,j]]);
        gotoxy(i*2+42,j+1);
        write(' ',welts[welt[i,j]],' ')
      end
    end;

    procedure cursor;
    begin
      textbackground(0);
      gotoxy(kox*2+42,koy+1);
      textcolor(2); write('[');
      textcolor(weltf[welt[kox,koy]]); write(welts[welt[kox,koy]]);
      textcolor(2); write(']');
      gotoxy(kox*2+43,koy+1)
    end;

    procedure prognose;
    begin
      for i:=1 to weltx do
        for j:=1 to welty do
        begin
          life:=welt[i-1,j-1]+welt[i-1,j]+welt[i-1,j+1]+welt[i,j-1]
               +welt[i,j+1]+welt[i+1,j-1]+welt[i+1,j]+welt[i+1,j+1];
          case welt[i,j] of
            0: if life>2 then neu[i,j]:=-1
               else neu[i,j]:=0;
            1: case life of
                 0..1: neu[i,j]:=2;
                 2:    neu[i,j]:=1;
                 3..8: neu[i,j]:=3
               end
          end
        end;
      for i:=1 to weltx do
      for j:=1 to welty do
      welt[i,j]:=neu[i,j];
    end;

    procedure bio;
    begin
      for i:=1 to weltx do
        for j:=1 to welty do
          if welt[i,j]>0 then welt[i,j]:=1 else welt[i,j]:=0;
      for i:=1 to weltx do
        for j:=1 to welty do
        begin
          life:=welt[i-1,j-1]+welt[i-1,j]+welt[i-1,j+1]+welt[i,j-1]
               +welt[i,j+1]+welt[i+1,j-1]+welt[i+1,j]+welt[i+1,j+1];
          if a=chr(68) then
            begin if welt[i,j]=1 then murd:=murd+1; life:=0 end;
          if welt[i,j]=0 then
            if life>2 then
              begin neu[i,j]:=1; born:=born+1 end
            else neu[i,j]:=0
          else if welt[i,j]=1 then
            if life<>2 then
              begin neu[i,j]:=0; kill:=kill+1 end
            else neu[i,j]:=1
        end;
      for i:=1 to weltx do for j:=1 to welty do
      begin
        gotoxy(i*2+43,j+1);
        textcolor(weltf[neu[i,j]]);
        if welt[i,j]-neu[i,j]<>0 then write('˘')
        else write(welts[neu[i,j]])
      end;
      for i:=1 to weltx do
        for j:=1 to welty do
          welt[i,j]:=neu[i,j];
      if progon then prognose;
      delay(50);
      zyklus:=zyklus+1
    end;

    procedure report;
    begin
      if kill<>0 then eff:=trunc(born/(kill+sett+murd)*100)
      else eff:=0;
      score:=born-sett-murd*3-(kill div 2);
      if score<0 then score:=0;
      gotoxy(1,10); textcolor(15); textbackground(1);
      writeln('      Zyklus:     ',zyklus,'/',zykmax);
      writeln('      Prognose:   ',copy('inaktiv  ',3*ord(progon),7));
      writeln;
      writeln('      Biologische Effizienz');
      writeln('      relativ:    ',eff,' %  ');
      writeln('      absolut:    ',score,'    ');
      writeln;
      writeln('      Kreiert:    ',sett,'/',submax);
      writeln('      Getîtet:    ',murd);
      writeln('      Entstanden: ',born);
      writeln('      Gestorben:  ',kill)
    end;

begin
  screen;
  repeat
    for i:=1 to weltx do
      for j:=1 to welty do
        if welt[i,j]>0 then welt[i,j]:=1
        else welt[i,j]:=0;
    if progon then prognose;
    zeigwelt;
    report;
    cursor;
    a:=readkey;
    case a of
      chr(13): case welt[kox,koy] of
                 -1..0: if sett<submax then
                          begin sett:=sett+1; welt[kox,koy]:=1 end;
                  1..3: begin murd:=murd+1; welt[kox,koy]:=0 end
               end;
      chr(72): if koy>1 then koy:=koy-1 else koy:=welty;
      chr(75): if kox>1 then kox:=kox-1 else kox:=weltx;
      chr(77): if kox<weltx then kox:=kox+1 else kox:=1;
      chr(80): if koy<welty then koy:=koy+1 else koy:=1;
      chr(71): begin kox:=1; koy:=1 end;
      'p'    : progon:=true>progon;
      chr(68): bio;
      ' '    : bio
    end
  until (a=chr(27)) or (zyklus>zykmax);
  zeigwelt
end;


{------------- AUSWERTUNG / HISCORES / QUIT ----------------}

PROCEDURE ende;
begin
  textcolor(15); textbackground(1);
  for i:=1 to 24 do
  begin
    gotoxy(1,i);
    write('                              ')
  end;
  punkte:=eff*score*bonus;
  gotoxy(1,3);
  writeln('            Spielende');
  writeln('            ~~~~~~~~~');
  writeln;
  writeln('        Effekt:    ',eff*score);
  writeln;
  writeln('        Bonus:   x ',bonus);
  writeln('        ------------------');
  writeln('        Punkte:  = ',punkte);
  gotoxy(9,12);
  write('Niveau: ',bewert[trunc(sqrt(punkte/50000))]);
  gotoxy(9,15);
  write('Weiter mit <Enter>');
  repeat until readkey=chr(13)
end;

PROCEDURE highscores;
var   rekordler: string[15];
      eintrag:   integer;
begin
  reset(datei);
  for i:=0 to 9 do
  begin
    seek(datei,i);
    read(datei,high);
    if punkte > high.score then
    begin
      gotoxy(1,15);
      writeln('   Es wurde ein Rekord erzielt !');
      writeln('       Du bist auf Platz ',i+1,'.');
      writeln;
      writeln('   Gib Deinen Namen ein:');
      write('   > ...............');
      gotoxy(6,19);
      readln(rekordler);
      for j:=8 downto i do
      begin
        seek(datei,j);
        read(datei,high);
        seek(datei,j+1);
        write(datei,high)
      end;
      seek(datei,i);
      high.score:=punkte;
      high.name:=rekordler;
      write(datei,high);
      i:=9
    end
  end;
  for i:=1 to 24 do
  begin
    gotoxy(1,i);
    write('                                ')
  end;
  gotoxy(16,3); write('Highscores');
  gotoxy(16,4); write('~~~~~~~~~~');
  for i:=0 to 9 do
  begin
    seek(datei,i);
    read(datei,high);
    str(i+1,laenge);
    gotoxy(8-length(laenge),i+7);
    write(i+1,'. ....................');
    gotoxy(10,i+7);
    write(high.name);
    str(high.score,laenge);
    gotoxy(35-length(laenge),i+7);
    write(high.score)
  end;
  close(datei);
  gotoxy(7,20);
  writeln('Willst Du nochmal spielen ?');
  gotoxy(13,21);
  writeln('(j)a / (n)ein');
  repeat a:=readkey until (a='n') or (a='j');
  if a='n' then schulz:=true
end;

PROCEDURE quit;
begin
  textbackground(0);
  clrscr; textcolor(7);
  writeln('TschÅ· !')
end;


{----- ENGINE -----}

BEGIN
  initscores;
  repeat
    init;
    menu;
    game;
    ende;
    highscores
  until schulz;
  quit
END.
