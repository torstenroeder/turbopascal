{ ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
  บ                               - ATTACKS -                19.10-2.11.94 บ
  บ                                                                        บ
  บ                                                                        บ
  บ             programmed by Torsten Roeder & Thomas Klingberg            บ
  บ                                                                        บ
  บ                  Attacks Sourcecode (c) 1994 by TNT                    บ
  บ                    Attacks.EXE v 1.58 is Freeware                      บ
  บ                                                                        บ
  บ                    this program includes parts of                      บ
  บ               Boxsys v 1.2 (c) 1994 by Thomas Klingberg                บ
  ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}

 program  Attacks;
 {$R-}
   uses crt,graph,mouse,speaker;
   const gd : integer = detect;
         gm : integer = 0;
   var   mo : resetrec;
         mouseloc : locrec;
         schiff,schiffanz,versuch,treffer,ende,soundon : integer;
         i,j,x,y,korx,kory : integer;
         position : array[1..5] of array[1..5] of array[1..2] of integer;
         feld : array[0..9] of array[0..9] of integer;
         laenge,schifftreff : array[1..5] of integer;
         kuerzel : string[3];
         a : char;


  function Inside(x1,y1,x2,y2,x,y : integer) : boolean;
    begin
      inside := (x >= x1) and (x <= x2) and
                (y >= y1) and (y <= y2)
    end;

  procedure Box(x1,x2,y1,y2,xteiler,yteiler,fill : integer);
    var l,teil,stueck : integer;
     begin
       setcolor(4);
       line(x1,y1,x2,y1); line(x2,y1,x2,y2);
       line(x2,y2,x1,y2); line(x1,y2,x1,y1);
       setcolor(11);
       line(x1-1,y1-1,x2+1,y1-1); line(x2+1,y1-1,x2+1,y2+1);
       line(x2+1,y2+1,x1-1,y2+1); line(x1-1,y2+1,x1-1,y1-1);
       setcolor(4);
       line(x1-2,y1-2,x2+2,y1-2); line(x2+2,y1-2,x2+2,y2+2);
       line(x2+2,y2+2,x1-2,y2+2); line(x1-2,y2+2,x1-2,y1-2);
       setcolor(1);
       if fill = 0 then
         begin
           j := x1;
           for l := x1+1 to x2-1 do
             begin
               j := j+1;
               line(j,y1+1,j,y2-1)
             end
         end;
       if fill = 1 then
         begin
           setfillstyle(solidfill,1); floodfill(x1+1,y1+1,4)
         end;
       if xteiler > 0 then
         begin
           teil := (y2-y1) div xteiler; stueck := 0; setcolor(11);
           for l := 1 to xteiler-1 do
             begin
               stueck := stueck+teil;
               line(x1,y1+stueck,x2,y1+stueck)
             end
         end;
       if yteiler > 0 then
         begin
           teil := (x2-x1) div yteiler; stueck := 0; setcolor(11);
           for l := 1 to  yteiler-1 do
             begin
               stueck := stueck+teil;
               line(x1+stueck,y1,x1+stueck,y2)
             end
         end
     end;

  procedure Ausgabe;
    var ausschiff,ausversuch,austreff : string[3];
        g,h : integer;
     begin
       mhide;
       g := 0; h := 0;
       box(543,614,228,277,0,0,0);
       box(543,614,295,342,0,0,0);
       box(543,614,362,411,0,0,0);
       str(schiffanz,ausschiff);
       str(versuch,ausversuch);
       str(treffer,austreff);
       if versuch > 9 then g := 18;
       if treffer > 9 then h := 18;
       settextstyle(1,0,6);
       setcolor(11); outtextxy(568,219,ausschiff);
       setcolor(10); outtextxy(568-g,285,ausversuch);
       setcolor(12); outtextxy(568-h,353,austreff);
       delay(100);
       mshow
     end;

  procedure Intro;
    begin
      initsnd;
      if soundon = 1 then
        playsnd('pppppppppppp<-c+c-e+e-e+e-g+g-g+g>-c+c-c+c<-f++f');
      if soundon = 1 then
        playsnd('--a+g-e+e-g+f-d+d-e+c<-a+a-g>++c');
      for i := 1 to 80 do putpixel(random(640),random(480),8);
      for i := 1 to 50 do putpixel(random(640),random(480),7);
      for i := 1 to 25 do putpixel(random(640),random(480),15);
      settextstyle(1,0,3); setcolor(15);
      outtextxy(55,205,'A long time ago in a galaxy far, far away ...');
      delay(4500); setcolor(0);
      outtextxy(55,205,'A long time ago in a galaxy far, far away ...');
      setbkcolor(15); delay(10); setbkcolor(0);
      settextstyle(1,0,8);
      setcolor(4); outtextxy(161,176,'ATTACKS');
      setcolor(15); outtextxy(155,170,'ATTACKS');
      delay(3500);
      for i := 1 to 4 do
        begin
          settextstyle(1,0,4);
          case i of
            1 : begin
                  outtextxy(265,300,'V 1.58 ')
                end;
            2 : begin
                  setcolor(0); outtextxy(265,300,'V 1.58');
                  settextstyle(1,0,3); setcolor(4);
                  outtextxy(225,290,'programmed by');
                  setcolor(15);
                  outtextxy(115,330,'Torsten Roeder & Thomas Klingberg')
                end;
            3 : begin
                  settextstyle(1,0,3); setcolor(0);
                  outtextxy(225,290,'programmed by');
                  outtextxy(115,330,'Torsten Roeder & Thomas Klingberg');
                  setcolor(4);
                  outtextxy(265,290,'tested by');
                  setcolor(15);
                  outtextxy(185,330,'Tester1,Tester2,Tester3')
                end;
            4 : begin
                  settextstyle(1,0,3); setcolor(0);
                  outtextxy(265,290,'tested by');
                  outtextxy(185,330,'Tester1,Tester2,Tester3')
                end
           end;
          for j := 1 to 3000 do
            begin
              mpos(mouseloc);
              if (mouseloc.buttonstatus <> 0) then
                begin
                  i := 4; j := 3000;
                end;
              delay(1)
            end
        end;
      endsnd;
    end;

  procedure Verteilen;
    var schiffx,schiffy,schiffz,fehler : integer;
     begin
       randomize;
       versuch := 0; treffer := 0; schiffanz := 5;
       ausgabe; 
       for i := 0 to 9 do
         for j := 0 to 9 do feld[i,j] := 0;
       for i := 1 to 5 do schifftreff[i] := 0;
       for schiff := 5 downto 1  do
         begin
           repeat
             repeat
               fehler := 0;
               laenge[schiff] := trunc(0.8*(schiff+3)-1);
               schiffx := random(10);
               schiffy := random(10);
               schiffz := random(2);
               if schiffz = 0 then
                 if (schiffx+laenge[schiff]-1) > 9 then fehler := 1;
               if schiffz = 1 then
                 if (schiffy+laenge[schiff]-1) > 9 then fehler := 1
             until fehler = 0;
             if schiffz = 0 then
               begin
                 if schiffx > 0 then
                   begin
                     if (feld[schiffx-1,schiffy] > 0) then fehler := 1;
                     if (feld[schiffx-1,schiffy-1] > 0) then fehler := 1;
                     if (feld[schiffx-1,schiffy+1] > 0) then fehler := 1
                   end;
                 if ((schiffx+laenge[schiff]-1) < 9) then
                   begin
                     if (feld[schiffx+laenge[schiff],schiffy] > 0) then
                       fehler := 1;
                     if (feld[schiffx+laenge[schiff],schiffy-1] > 0) then
                       fehler := 1;
                     if (feld[schiffx+laenge[schiff],schiffy+1] > 0) then
                       fehler := 1
                   end;
                 for i := 1 to laenge[schiff] do
                   begin
                     if (feld[schiffx+i-1,schiffy] > 0) then fehler := 1;
                     if (feld[schiffx+i-1,schiffy-1] > 0) then fehler := 1;
                     if (feld[schiffx+i-1,schiffy+1] > 0) then fehler := 1
                   end
               end;
             if schiffz = 1 then
               begin
                 if schiffy > 0 then
                   begin
                     if (feld[schiffx,schiffy-1] > 0) then fehler := 1;
                     if (feld[schiffx-1,schiffy-1] > 0) then fehler := 1;
                     if (feld[schiffx+1,schiffy-1] > 0) then fehler := 1
                   end;
                 if ((schiffy+laenge[schiff]-1) < 9) then
                   begin
                     if (feld[schiffx,schiffy+laenge[schiff]] > 0) then
                       fehler := 1;
                     if (feld[schiffx-1,schiffy+laenge[schiff]] > 0) then
                       fehler := 1;
                     if (feld[schiffx+1,schiffy+laenge[schiff]] > 0) then
                       fehler := 1
                   end;
                 for i := 1 to laenge[schiff] do
                   begin
                     if (feld[schiffx,schiffy+i-1] > 0) then fehler := 1;
                     if (feld[schiffx-1,schiffy+i-1] > 0) then fehler := 1;
                     if (feld[schiffx+1,schiffy+i-1] > 0) then fehler := 1
                   end
               end
           until fehler = 0;
           if schiffz = 0 then
             for i := 1 to laenge[schiff] do
               begin
                 feld[schiffx+i-1,schiffy] := schiff;
                 position[schiff,i,1] := (schiffx+i-1);
                 position[schiff,i,2] := schiffy
               end;
           if schiffz = 1 then
             for i := 1 to laenge[schiff] do
               begin
                 feld[schiffx,schiffy+i-1] := schiff;
                 position[schiff,i,1] := schiffx;
                 position[schiff,i,2] := (schiffy+i-1)
               end
         end
     end;

  procedure Spielen;

    procedure Meldung(z : integer);
      begin
        mhide;
        x := korx*40+20; y := kory*40+20;
        case z of
          0 : begin
                setcolor(10);
                x := korx*40+20; y := kory*40+20;
                circle(x+20,y+20,15)
              end;
          1 : begin
                settextstyle(1,0,6); setcolor(12);
                x := korx*40+20; y := kory*40+20;
                outtextxy(x+7,y-19,'x')
              end;
          2 : begin
                settextstyle(1,0,6); setcolor(9);
                for i := 1 to laenge[schiff] do
                  begin
                    x := (position[schiff,i,1]*40+20)+7;
                    y := (position[schiff,i,2]*40+20)-19;
                    outtextxy(x,y,'x')
                  end
              end
         end;
        box(20,420,430,465,0,0,0);
        settextstyle(1,0,3); setcolor(15);
        case z of
          0 : outtextxy(30,430,'Platsch !');
          1 : outtextxy(30,430,'Treffer !');
          2 : outtextxy(30,430,'Schiff versenkt !');
          3 : outtextxy(30,430,'Das war doch schon, Du Idiot !')
         end;
        delay(100);
        mshow
      end;

    procedure Sound(z : integer);
      begin
        initsnd;
        case z of
          0 : for i := 1 to 3 do
                freqsnd(340-(i*60),1);
          1 : for i := 1 to 3 do
                freqsnd(400+i*290,1);
          2 : playsnd('--ccc+f');
          3 : freqsnd(30,4);
          4 : playsnd('c-cdeceg>+c')
         end;
        repeat until v=0;
        endsnd
      end;

    procedure Highscore;
      type beste = record
                     score : integer;
                     name : string[3]
                    end;
      var best : beste;
          datei : file of beste;
          scorestr : string[3];
          eintrag : integer;

       procedure Blink(k : integer);
         begin
           setcolor(14); line(k,270,k+23,270); delay(5);
           setcolor(1); line(k,270,k+23,270); delay(5)
         end;

       begin
         mhide;
         assign(datei,'Score.dat');
         {$I-}
         reset(datei);
         if ioresult <> 0 then
           begin
             rewrite(datei);
             if ioresult <> 0 then
               begin
                 closegraph;
                 write('Fehler beim Anlegen von "Score.dat".');
                 halt
               end;
             for i := 0 to 9 do
               begin
                 seek(datei,i);
                 best.score := 40+(i*5);
                 best.name := chr(65+i)+chr(65+i)+chr(65+i);
                 write(datei,best)
              end
           end;
         {$I+}
         i := -1; eintrag := 0;
         repeat
           i := i+1;
           seek(datei,i);
           read(datei,best);
           if versuch < best.score then
             begin
               eintrag := 1;
               cleardevice;
               for j := 1 to 100 do putpixel(random(640),random(480),8);
               for j := 1 to 70 do putpixel(random(640),random(480),7);
               for j := 1 to 25 do putpixel(random(640),random(480),15);
               box(20,620,100,300,0,0,1); box(480,620,430,460,0,2,0);
               settextstyle(1,0,2); setcolor(8);
               outtextxy(496,432,'Neu'); outtextxy(555,432,'Weiter');
               settextstyle(1,0,3); setcolor(14);
               outtextxy(170,140,'Sie haben einen Highscore !');
               outtextxy(50,190,'Bitte Namenskrzel (3 Buchstaben) eingeben :');
               repeat
                 x := 265;
                 settextstyle(1,0,3);
                 for j := 1 to 3 do
                   begin
                     x := x+24;
                     repeat blink(x) until keypressed;
                     setcolor(15);
                     a := readkey;
                     a := upcase(a);
                     outtextxy(x,245,a);
                     insert(a,kuerzel,j)
                   end;
                 settextstyle(1,0,2); setcolor(14);
                 outtextxy(496,432,'Neu'); outtextxy(555,432,'Weiter');
                 mshow;
                 repeat
                   mpos(mouseloc);
                   x := mouseloc.column; y := mouseloc.row
                 until (mouseloc.buttonstatus <> 0)
                           and inside(480,430,620,460,x,y);
                 mhide;
                 if inside(480,430,550,460,x,y) then
                   begin
                     x := 265;
                     settextstyle(1,0,2); setcolor(8);
                     outtextxy(496,432,'Neu'); outtextxy(555,432,'Weiter');
                     settextstyle(1,0,3); setcolor(1);
                     for j := 1 to 3 do
                       begin
                         x := x+24;
                         a := kuerzel[j];
                         outtextxy(x,245,a)
                       end
                   end
               until inside(550,430,620,460,x,y);
               for j := 8 downto i do
                 begin
                   seek(datei,j);
                   read(datei,best);
                   seek(datei,j+1);
                   write(datei,best)
                 end;
               seek(datei,i);
               best.score := versuch;
               best.name := kuerzel;
               write(datei,best);
             end
         until (eintrag = 1) or (i = 9);
         cleardevice;
         for i := 1 to 90 do putpixel(random(640),random(480),8);
         for i := 1 to 60 do putpixel(random(640),random(480),7);
         for i := 1 to 25 do putpixel(random(640),random(480),15);
         settextstyle(1,0,3); setcolor(15);
         for i := 1 to 4 do
           begin
             case i of
               1   : setcolor(4);
               2   : setcolor(7);
               3   : setcolor(15)
              end;
             outtextxy(255-i,50-i,'Highscores');
             line(250-i,80-i,377-i,80-i)
           end;
         for i := 0 to 9 do
           begin
             seek(datei,i);
             read(datei,best);
             str(best.score,scorestr);
             for j := 1 to 3 do
               begin
                 case j of
                   1 : setcolor(8);
                   2 : setcolor(7);
                   3 : setcolor(15)
                  end;
                 outtextxy(190-j,110+(i*30)-j,best.name);
                 outtextxy(290-j,110+(i*30)-j,scorestr);
                 outtextxy(340-j,110+(i*30)-j,'Versuche');
               end;
           end;
         settextstyle(1,0,1); setcolor(8);
         repeat
           mpos(mouseloc)
         until (mouseloc.buttonstatus <> 0);
         close(datei)
       end;

    procedure Wertung;
      var versuchstr,quote : string[3];
       begin
         mhide;
         str(versuch,versuchstr);
         str(trunc(100/versuch*treffer),quote);
         cleardevice;
         for i := 1 to 200 do putpixel(random(640),random(480),8);
         for i := 1 to 140 do putpixel(random(640),random(480),7);
         for i := 1 to 50 do putpixel(random(640),random(480),15);
         box(20,620,50,435,0,0,1); 
         settextstyle(1,0,7);
         setcolor(9); outtextxy(136,96,'VICTORY !');
         setcolor(15); outtextxy(130,90,'VICTORY !');
         settextstyle(1,0,3);
         setcolor(14); outtextxy(60,260,'Sie haben');
         setcolor(12); outtextxy(190,260,versuchstr);
         setcolor(14); outtextxy(220,260,' Versuche gebraucht,');
         outtextxy(60,300,'um die Flotte zu versenken !');
         outtextxy(60,340,'Trefferquote :');
         setcolor(12); outtextxy(225,340,quote);
         setcolor(14); outtextxy(255,340,'%');
         if soundon = 1 then sound(4);
         box(540,610,400,425,0,0,1);
         settextstyle(1,0,2); setcolor(15);
         outtextxy(545,400,'Weiter');
         mshow;
         repeat
           mpos(mouseloc); x := mouseloc.column; y := mouseloc.row
         until (mouseloc.buttonstatus <> 0) and (inside(540,400,610,425,x,y));
         highscore
       end;

    procedure Schuss;
      begin
        korx := trunc((x-20)/40);
        kory := trunc((y-20)/40);
        if feld[korx,kory] = 0 then
          begin
            versuch := versuch+1;
            meldung(0);
            if soundon = 1 then sound(0)
          end;
        if (feld[korx,kory] > 0) and (feld[korx,kory] < 6) then
          begin
            versuch := versuch+1; treffer := treffer+1;
            schiff := feld[korx,kory];
            schifftreff[feld[korx,kory]] := schifftreff[feld[korx,kory]]+1;
            meldung(1);
            if soundon = 1 then sound(1);
            if schifftreff[feld[korx,kory]] = laenge[feld[korx,kory]] then
              begin
                schiffanz := schiffanz-1;
                meldung(2);
                if soundon = 1 then sound(2)
              end
          end;
        if feld[korx,kory] = 6 then
          begin
            meldung(3);
            if soundon = 1 then sound(3)
          end;
        feld[korx,kory] := 6;
        ausgabe
      end;

    begin
      mshow;
      repeat
        mpos(mouseloc); x := mouseloc.column; y := mouseloc.row;
        if (mouseloc.buttonstatus <> 0) then
          begin
            if inside(545,430,620,465,x,y) then ende := 1;
            if inside(20,20,419,419,x,y) then schuss
          end;
        if ende = 1 then
          begin
            mhide;
            box(20,420,430,465,0,0,0); box(325,415,435,460,0,2,1);
            settextstyle(1,0,3); setcolor(15);
            outtextxy(30,430,'Spiel wirklich verlassen ?');
            settextstyle(1,0,2);
            setcolor(12); outtextxy(339,435,'Ja');
            setcolor(10); outtextxy(372,435,'Nein');
            mshow;
            repeat
              mpos(mouseloc); x := mouseloc.column; y := mouseloc.row
            until (mouseloc.buttonstatus <> 0) and
                          (inside(325,435,415,460,x,y));
            if inside(325,435,370,460,x,y) then ende := 1
            else
              begin
                mhide;
                box(20,420,430,465,0,0,0);
                settextstyle(1,0,3); setcolor(15);
                outtextxy(30,430,'Whle Dein Ziel !');
                mshow;
                ende := 0
              end
          end;
      until (treffer = 17) or (ende = 1);
      if treffer = 17 then wertung
    end;

  procedure Screen;
    begin
      mhide;
      cleardevice;
      for i := 1 to 200 do putpixel(random(640),random(480),15);
      for i := 1 to 400 do putpixel(random(640),random(480),8);
      for i := 1 to 300 do putpixel(random(640),random(480),7);
      box(20,420,20,420,10,10,1);
      box(450,620,20,200,0,0,1);
      box(460,610,30,90,0,0,1);
      box(450,620,220,420,3,0,1);
      box(20,420,430,465,0,0,1);
      box(545,620,430,465,0,0,1);
      box(450,620,220,420,3,0,0);
      settextstyle(1,0,4);
      setcolor(9); outtextxy(473,43,'ATTACKS');
      setcolor(15); outtextxy(470,40,'ATTACKS');
      settextstyle(3,0,1);
      setcolor(14); outtextxy(478,110,'(c) 1994 by ');
      outtextxy(460,133,'Thomas Klingberg');
      outtextxy(470,155,'Torsten Roeder');
      settextstyle(3,0,1); setcolor(15);
      outtextxy(460,220,'Schiffe');
      outtextxy(460,285,'Versuch');
      outtextxy(460,350,'Treffer');
      settextstyle(3,0,3);
      setcolor(4); outtextxy(564,430,'Exit');
      settextstyle(1,0,3); setcolor(15);
      outtextxy(30,430,'Er”ffne das Spiel !');
      mshow
    end;

 procedure Init;
   begin
     clrscr;
     soundon := 0;
     gotoxy(6,11);
     write('Wollen Sie einen Joystick benutzen (j/n) ?');
     repeat
       a := readkey
     until (a = 'j') or (a = 'n');
     if a = 'j' then writeln('   Gibt`s aber nicht !');
     gotoxy(6,13);
     write('Wollen Sie den atemberaubenden Sound geniessen (j/n) ?');
     repeat
       a := readkey
     until (a = 'j') or (a = 'n');
     if a = 'j' then soundon := 1;
     initgraph(gd,gm,'..\..\BGI');
     moveto(0,0);
     setviewport(0,0,639,479,true);
     ende := 0;
     for i := 1 to 3 do
       kuerzel[i] := ' '
   end;

 begin
   init;
   intro;
   repeat
     mreset(mo);
     screen;
     verteilen;
     spielen
   until ende = 1;
   closegraph;
   write('Thanks for playing Attacks.')
 end.
