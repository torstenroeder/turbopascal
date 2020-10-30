PROGRAM BioEvolution;

USES mouse,crt,mathe,Stuff;

CONST maxx  = 40;
      maxy  = 40;
      grafx =  4;
      grafy =  2;
      leer  =  0;
      gruen =  1;
      rot   =  2;

      hintergrund =  0;
      rahmenfarbe =  1;
      textfarbe   = 15;
      sterbfarbe  =  8;
      geburtfarbe =  6;
      buttons     =  3;

      Beding_A: set of 0..8 = [3];
      { neue Zelle }

      Beding_B: set of 0..8 = [2,3];
      { öberleben }

      symbol = #254;
      anzahl: longint = 10;
      ende:   boolean = false;

VAR   feld,neufeld,savefeld:
        array[0..maxx+1] of array[0..maxy+1] of integer;

      x,y,kox,koy,i: integer;

      mloc:     locrec;
      origmode: integer;
      c:        char;


FUNCTION Umgebung(farbe: integer): integer;
var a,b,wert: integer;
begin
  if feld[x,y]=farbe then wert:=-1 else wert:=0;
  for a:=x-1 to x+1 do
    for b:=y-1 to y+1 do
      if feld[a,b]=farbe then
        inc(wert);
  Umgebung:=wert;
end;

PROCEDURE Zyklus;
var g,r: integer;
begin
  G:=0; R:=0;
  for x:=1 to maxx do
    for y:=1 to maxy do begin
      G:=Umgebung(gruen);
      R:=Umgebung(rot);
      case feld[x,y] of
        LEER:
          if G+R in Beding_A then
          begin
            if G>R then
              neufeld[x,y]:=gruen
            else neufeld[x,y]:=rot
          end
          else neufeld[x,y]:=leer;
        GRUEN:
          if G+R in Beding_B then
          begin
            if G>=R then
              neufeld[x,y]:=gruen
            else neufeld[x,y]:=rot
          end
          else neufeld[x,y]:=leer;
        ROT:
          if G+R in Beding_B then
          begin
            if R>=G then
              neufeld[x,y]:=rot
            else neufeld[x,y]:=gruen
          end
          else neufeld[x,y]:=leer;
      end
    end;
  for x:=1 to maxx do
    for y:=1 to maxy do
      feld[x,y]:=neufeld[x,y];
end;

PROCEDURE Neues_Feld;
begin
  for x:=0 to maxx+1 do
    for y:=0 to maxy+1 do begin
      feld[x,y]:=leer;
      neufeld[x,y]:=leer
    end;
end;

PROCEDURE Blau;
begin
  textbackground(rahmenfarbe);
  clrscr;
  textcolor(textfarbe);
  gotoxy(grafx,grafy+maxy+2); write('Zyklen: ',anzahl);
  textbackground(buttons); textcolor(rahmenfarbe);
  gotoxy(grafx,grafy+maxy+4);
  writeln('ﬂﬂﬂﬂﬂﬂ€ﬂﬂﬂﬂﬂﬂ€ﬂﬂﬂﬂﬂﬂ€ﬂﬂﬂﬂﬂﬂ€ﬂﬂﬂﬂﬂﬂ€ﬂﬂﬂﬂﬂﬂ€ﬂﬂﬂﬂﬂﬂ');
  gotoxy(grafx,grafy+maxy+5);
  writeln(' RUN! € Zykl € Save € Load € Undo € Kill € Quit ');
  gotoxy(grafx,grafy+maxy+6);
  writeln('‹‹‹‹‹‹€‹‹‹‹‹‹€‹‹‹‹‹‹€‹‹‹‹‹‹€‹‹‹‹‹‹€‹‹‹‹‹‹€‹‹‹‹‹‹');
  for y:=grafy+1 to grafy+maxy do
  begin
    for x:=1 to maxx do
      WriteXY(grafx+x,y,symbol);
    Colorize(grafx+1,y,maxx,hintergrund);
  end;
end;

PROCEDURE Grafik;
begin
  for x:=1 to maxx do
    for y:=1 to maxy do
      if feld[x,y]<>leer then begin
        Colorize(grafx+x,grafy+y,1,feld[x,y]*2);
      end
      else
        Colorize(grafx+x,grafy+y,1,hintergrund);
end;

BEGIN
  origmode:=lastmode;
  textmode(lo(lastmode)+font8x8);
  randomize;
  Neues_Feld;
  Blau;
  Grafik;
  HideCursor;
  mshow;
  repeat
    repeat mpos(mloc) until mloc.buttonstatus<>0;
    kox:=mloc.column div 8-grafx+1;
    koy:=mloc.row div 8-grafy+1;
    if (kox in [1..maxx]) and (koy in [1..maxy]) then
      case mloc.buttonstatus of
        1: begin
             mhide;
             feld[kox,koy]:=gruen;
             Colorize(grafx+kox,grafy+koy,1,2);
             mshow
           end;
        2: begin
             mhide;
             feld[kox,koy]:=rot;
             Colorize(grafx+kox,grafy+koy,1,4);
             mshow
           end;
        3: begin
             feld[kox,koy]:=leer;
             Colorize(grafx+kox,grafy+koy,1,hintergrund);
             delay(100);
           end
      end
    else if (koy in [grafy+maxy+2..grafy+maxy+4])
         and ((kox+8) mod 7<>0)
         and (mloc.buttonstatus=1) then
      case (kox+8) div 7 of
        1: for i:=1 to anzahl do begin
             Zyklus;
             Grafik;
           end;
        2: begin
             window(grafx+8,grafy+maxy+2,grafx+11,grafy+maxy+2);
             textcolor(textfarbe);
             textbackground(hintergrund);
             clrscr;
             BlockCursor;
             readln(anzahl);
             HideCursor;
             if anzahl>100 then anzahl:=100;
             write(anzahl);
             window(1,1,80,50);
           end;
        3: for x:=1 to maxx do
             for y:=1 to maxy do
               savefeld[x,y]:=feld[x,y];
        4: begin
             for x:=1 to maxx do
               for y:=1 to maxy do
                 feld[x,y]:=savefeld[x,y];
             Grafik;
           end;
        5: begin
             for x:=1 to maxx do
               for y:=1 to maxy do
                 feld[x,y]:=neufeld[x,y];
             Grafik;
           end;
        6: begin
             Neues_Feld;
             Grafik;
           end;
        7: ende:=true;
      end;
  until ende;
  textmode(origmode);
  clrscr;
  NormalCursor
END.
