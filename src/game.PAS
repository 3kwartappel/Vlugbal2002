{David Smit 12A5}
{Worcester Gimnasium (SA)}
{diE pRoJek nl. >>>>>  VLUGBAL 2002}
program dieProjek;
uses crt,graph;
type dataleer =record
       naam1:string[15];
       naam2:string[15];
       punte:integer;
       end;
     str15 = string[15];
     leer=file of dataleer;
var  n1 : array[1..11] of string[15];
     n2 : array[1..11] of string[15];
     p  : array[1..11] of integer;
     keuse:char;
     eenvraag:dataleer;
{p1 staan vir player 1}
{p2 staan vir player 2}
{================GRAPH==========================GRAPH========================}
{stel nodige goed in vir pascal se grafieka}
procedure stel;
var Gd, Gm: Integer;
begin
 Gd := Detect;
 InitGraph(Gd, Gm, ' ');
 if GraphResult <> grOk then
   begin
     clrscr;
     writeln('Daar is iets groot fout, format jou rekenaar');
     readkey;
     Halt(1);
   end;
end;
{========================================================================}
{sluit nuwe highscore by oues in}
procedure berekenhighscore(var puntverskil:integer;var p1naam,p2naam:str15;
                           var wen:integer);
var tydelikp,i:integer;
    tydelikn1,tydelikn2:string;
    high:leer;
    ja:boolean;
begin
    assign(high,'high.dat');
    reset(high);
    if wen = 1 then      {as player 1 gewen het}
    begin
      n1[11]:=p1naam;        {stel naam wenner in skikking in}
      n2[11]:=p2naam;
    end;
    if wen = 2 then      {as player 2 gewen het}
    begin
      n1[11]:=p2naam;        {stel wenner in skikking in}
      n2[11]:=p1naam;
    end;
    p[11]:=puntverskil;  {stel punteverskil in skikking in}
    i:=0;
    reset(high);
    while not eof(high) do   {hierdie while lees data uit high.dat- }
     begin                   {in skikkings in}
      read(high,eenvraag);
      inc(i);
      with eenvraag do
       begin
        n1[i]:=naam1;
        n2[i]:=naam2;
        p[i] :=punte;
      end;
     end;
  repeat
  ja:=true;
   for i:= 1 to 10 do               {borrel sortering}
      begin                         {sorteer vir beste tien punte}
       if p[i] < p[i+1] then
        begin
         tydelikp:=p[i];
         p[i]:=p[i+1];
         p[i+1]:=tydelikp;
         tydelikn1:=n1[i];
         n1[i]:=n1[i+1];
         n1[i+1]:=tydelikn1;
         tydelikn2:=n2[i];
         n2[i]:=n2[i+1];
         n2[i+1]:=tydelikn2;
         ja:= false;
        end;
      end;
   until ja;

 rewrite(high);
 for i:= 1 to 10 do
  begin
  with eenvraag do               {stel in record in}
    begin
      naam1:=n1[i];
      naam2:=n2[i];
      punte:=p[i];
    end;
  write(high,eenvraag);          {skryf hom}
  end;
 close(high);
end;
{-------------------------------------------------------------------------}
{vertoon die highscores}
procedure vertoonhighscores;
var high:leer;
    af,i:integer;
    jan:string;
begin
  cleardevice;
  settextstyle(1,horizdir,1);
  setcolor(red);
  outtextxy(200,20,'GROOTSTE OORWINNINGS');
  assign(high,'high.dat');                 {maak highscore-leer oop}
  reset(high);
  af:=100;
  i:=0;
 while not eof(high) do                    {lees name en punte in}
   begin
    settextstyle(1,horizdir,1);
    setcolor(green);
    read(high,eenvraag);
    with eenvraag do
     begin
       inc(i);
       str(i,jan);
       outtextxy(30,af,jan);               {skryf hoeveelste}
       outtextxy(70,af,naam1);             {skryf naam1}
       outtextxy(230,af,'klop');
       outtextxy(280,af,naam2);            {skryf naam2}
       outtextxy(440,af,'met');
       str(punte,jan);
       outtextxy(490,af,jan);              {skryf met hoeveel punte gewen is}
       outtextxy(520,af,'punt(e)');
     end;
    inc(af,20);
   end;
 setcolor(red);
 outtextxy(10,getmaxy-40,'Druk enige knop om terug te gaan...');
 sound(600);delay(200);nosound;delay(200);
 sound(600);delay(200);nosound;delay(200);
 sound(800);delay(100);nosound;delay(200);
 sound(1000);delay(100);nosound;delay(200);
 sound(400);delay(200);nosound;delay(200);
 sound(400);delay(200);nosound;delay(200);
 sound(200);delay(200);nosound;delay(200);
 nosound;
 readkey;
 close(high);
end;
{----------------------------------------------------------------------}
{kyk vir kleinste punt in highscorelys}
procedure klein(var kleinste:integer);
var  high:leer;
begin
  kleinste := 20;
  assign(high,'high.dat');
  reset(high);
  while not eof(high) do
   begin
     read(high,eenvraag);
     if eenvraag.punte < kleinste then
       kleinste:=eenvraag.punte;
   end;
  close(high);
end;
{-------------------------------------------------------------------------}
{---------------------------GAME PROCEDURE--------------------------------}
{-------------------------------------------------------------------------}
{die game procedure bevat die vlugbal spel en roep nodige procedures}
procedure GAME(var spoed:integer;var p1naam,p2naam:str15;
               var wen:integer;var p1kleur,p2kleur:integer);
var jump1,jump2,nextround,tref1,tref2,trailjanee,gras:boolean;
    center,yteller,xteller,kt,grond,spring1,spring2,b1,b2,x,y,x1,y1,grasx,
    xx1,yy1,xs,ys,kragy,kragx,lkp,rkp,bkp,x2,y2,xx2,yy2,links,regs,
    tr,i,punt1,punt2,serve,puntverskil,groot,pot,kleinste,e,r
    ,graslinksregs,grasx2:integer;
    k:char;
    druk:char;
    jan:string;
    stop:char;
    trailx:array[1..10] of integer;
    traily:array[1..10] of integer;
begin
 pot:=5;             {hoeveel punte gespeel word vir 'n wen}
 gras:=true;         {gras teller}
 serve:= random(2)+1;{'n random speler word gekies om te begin}
 links:=0;
 regs:=0;
 kt:=10;             {hoe vinnig spelers kant toe beweeg}
 grond:= 475;        {bodem van skerm}
 x:=getmaxx;
 y:=getmaxy;
 center:=getmaxx div 2;

 {p1}
 x1:=100;            {koordinate van p1 vir begin}
 y1:=425;            {"}
 xx1:=125;           {"}
 yy1:=grond;         {"}
 punt1:=0;           {puntetelling van p1}
 jump1:=false;       {toets of p1 spring}
 b1:= -12;           {hoe vinnig jump1 ge-inc word}
 spring1:=0;         {hou telling van b1}

 {p2}
 x2:=500;            {koordinate van p2 vir begin}
 y2:=425;            {"}
 xx2:=525;           {"}
 yy2:=grond;         {"}
 punt2:=0;           {puntetelling van p2}
 jump2:=false;       {toets of p2 spring}
 b2:= -12;           {hoe vinnig jump1 ge-inc word}
 spring2:=0;         {hou telling van b2}

 {bal}
 if serve = 1 then   {bal se koordinate vir begin}
  xs :=100;
 if serve = 2 then
  xs :=530;
 ys :=1;
 kragy:= -4;         {spoed waarteen bal val agv. aantrekkingskrag}
 kragx:=0;           {spoed waarteen bal links of regs beweeg}
 yteller:=0;         {hou telling van kragy}
 xteller:=0;         {hou telling van kragyx}

 {paal}
 lkp:=x div 2 -5;    {linkerkant van paal}
 rkp:=x div 2 +5;    {regterkant van paal}
 bkp:=y div 2;       {bokant van paal}

 {trail van bal}
 trailjanee:=false;{trail maak spel stadig}
                   {stel dit aan deur trailjanee true te maak}
 if trailjanee= true then
 for i:= 1 to 10 do
   begin
     trailx[i]:=-30; {maak trail waardes skoon}
     traily[i]:=-30; {maak trail waardes skoon}
   end;

  cleardevice;
  setcolor(green);
repeat
  stop:='N';
  nextround:= false;

  setfillstyle(7,green);
  bar(lkp,bkp,rkp,bkp+50);      {teken boonste deel van paal}
  setfillstyle(1,green);
  bar(lkp,bkp+50,rkp,y);        {teken onderste deel van paal}

  setfillstyle(1,brown);
  bar(0,grond+1,getmaxx,getmaxy); {teken 'n bruin vloer}

  setfillstyle(1,green);
  bar(0,grond+1,getmaxx,grond); {teken 'n groen vloer}

  setcolor(green);
  if gras = true then
  for i:= 1 to 200 do                      {maak baie grassies}
    begin
     grasx:= random(getmaxx);              {graskoordinate}
     graslinksregs:=random(2);             {besluit of grassie links/regs}
     if graslinksregs = 1 then
        grasx2:= grasx - random(3)
     else
        grasx2:= grasx + random(3);
     Line(grasx, grond+1, grasx2, grond-5-random(3));{teken grassie}
    end;
  gras :=false;{maak gras false sodat gras nie elke siklus geteken word nie-}
               {gras word doodgetrap deur spelers}
  settextstyle(1,horizdir,1);
  setcolor(p1kleur);
  str(punt1,jan);               {verander integer na string}
  outtextxy(300,20,jan);        {skryf p1 se puntetelling}

  setcolor(white);
  outtextxy(320,20,':');        {skryf ":"}

  setcolor(p2kleur);
  str(punt2,jan);
  outtextxy(336,20,jan);        {skryf p2 se puntetelling}

  settextstyle(2,horizdir,5);
  If serve=1 then               {as p1 serve}
  begin
    setcolor(p1kleur);
    outtextxy(260,22,'dien');
  end;
  If serve=2 then               {as p2 serve}
  begin
    setcolor(p2kleur);
    outtextxy(355,22,'dien');
  end;

  repeat
{p1}setfillstyle(1,p1kleur);
    bar(x1, y1, xx1, yy1);      {p1 word geteken}
{p2}setfillstyle(1,p2kleur);
    bar(x2, y2, xx2, yy2);      {p2 word geteken}

    {trail I}
    trailx[1]:= xs;             {trailwaarde is agter bal}
    traily[1]:= ys;             {trailwaarde is agter bal}
    for r:= 10 downto 2 do
       begin
         trailx[r]:=trailx[r-1];{stel waarde in vorige waarde}
         traily[r]:=traily[r-1];{stel waarde in vorige waarde}
       end;

    if trailjanee= true then
    for i:= 4 to 10 do          {trail II}
       begin
        case i of
          4 : tr:=4;
          6 : tr:=12;
          8 : tr:=6;
          10: tr:=14;
        end;
        tr:=red;
        setcolor(tr);
        circle(trailx[i],traily[i],10);
        setfillstyle(1,tr);                  {teken trail}
        floodfill(trailx[i],traily[i],tr);   {kleur hom in}
       end;

    setcolor(white);
    circle(xs,ys,10);       {teken die balletjie}
    setfillstyle(1,white);
    floodfill(xs,ys,white); {kleur hom in}

    if ys < 0 then
     begin
       setfillstyle(1,3);
       bar(xs-1,1,xs+1,5);  {teken blokkie wat aandui waar bal buite skerm is}
     end;

    delay(spoed);           {delay van spoed}

    if trailjanee= true then
    begin
    tr:=black;              {trail III}
    for i:= 4 to 10 do
       begin
        setcolor(tr);
        circle(trailx[i],traily[i],10);   {teken swart trail oor ander}
        setfillstyle(1,tr);
        floodfill(trailx[i],traily[i],tr);{kleur hom in}
       end;
    end;


{p1}setfillstyle(1,black);
    bar(x1, y1, xx1, yy1);     {p1 word swart oorgeteken}
{p2}setfillstyle(1,black);
    bar(x2, y2, xx2, yy2);     {p2 word swart oorgeteken}

    setcolor(black);
    circle(xs,ys,10);          {die ballietjie word swart oorgeteken}
    setfillstyle(1,black);
    floodfill(xs,ys,black);    {kleur hom in}

    if ys < 0 then
     begin
       setfillstyle(1,black);
       bar(xs-1,1,xs+1,5);     {blokkie wat aandui waar bal is word swart}
     end;

{p1}if xx1 >= lkp then    {as speler paal tref}
      begin               {kan hy nie verder as paal beweeg nie}
        xx1 := lkp;
        x1:= lkp-25;
      end;
{p2}if x2 <= rkp then     {as speler paal tref}
      begin               {kan hy nie verder as paal beweeg nie}
        x2 := rkp;
        xx2:= rkp+25;
      end;
{p1}if x1 <= 0 then       {as speler kant van skerm tref}
      begin               {kan hy nie uit skerm beweeg nie}
        x1 := 0;
        xx1:= 25;
      end;
{p2}if xx2 >= getmaxx then{as speler kant van skerm tref}
      begin               {kan hy nie uit skerm beweeg nie}
        x2 := getmaxx-25;
        xx2:= getmaxx;
      end;

    xs:= xs + kragx;   {bal se x koordinate word bereken deur spoed}
    ys:= ys + kragy;   {bal se y koordinate word bereken deur spoed}

    inc(yteller);
    if (kragy <= 0) and (yteller > 4) then{as bal opwaarts beweeg}
     begin
       kragy:= kragy + 1;        {hoe bal spoed verloor opwaarts}
       yteller := 0;
     end;
    if (kragy > 0) and (yteller > 20) then{as bal afwaarts beweeg}
     begin
       kragy:= kragy + 1;        {hoeveel bal spoed optel afwaarts}
       yteller:= 0;
     end;

{spring waardes}
{p1}inc(spring1);                {hou telling van b1}
    if spring1 = 4 then
     begin
          b1:= b1 + 1;           {as 4 loops verby is word b1 ge-inc}
          spring1:=0;
     end;
{p2}inc(spring2);                {hou telling van b2}
    if spring2 = 4 then
     begin
          b2:= b2 + 1;           {as 4 loops verby is word b2 ge-inc}
          spring2:=0;
     end;
{p1}if jump1= true then          {terwyl p1 in lug is}
     begin
          inc(y1,b1);            {gaan p1 op of af}
          inc(yy1,b1);           {gaan p1 op of af}
     end;
{p2}if jump2= true then          {terwyl p1 in lug is}
     begin
          inc(y2,b2);            {gaan p1 op of af}
          inc(yy2,b2);           {gaan p1 op of af}
     end;
{p1} if yy1 = grond then         {as p1 grond tref dan bly hy daar}
      begin
          jump1 := false;
          b1:=-12;
       end;
{p2} if yy2 = grond then         {as p1 grond tref dan bly hy daar}
      begin
          jump2 := false;
          b2:=-12;
       end;

{as die bal die volgende voorwerpe tref dan}
{p1} if ((ys+15 >= y1) and (ys-5 <= y1) and {links bo van persoon tref}
        (xs+5 >= x1) and (xs-5 <= x1) and (kragy>0))then
          begin
          if kragx <=0 then               {as bal reeds linkswaarts oppad is}
           kragx:=kragx - 4               {tel bal spoed op in linkswaarts}
          else
           kragx:=kragx *-1 +2;           {beweeg bal in teenoorgestelde rigt}
           if jump1= true then            {as speler spring}
            kragy:= kragy*-1-5+ (b1 div 4){beweeg bal sterk boontoe}
           else
            kragy:= kragy*-1-5;           {beweeg bal medium boontoe}
          inc(links);                     {tel hoeveel keer geslaan word}
          tref1:=true;
          tref2:=false;
          end;
{p2} if ((ys+15 >= y2) and (ys-5 <= y2) and{links bo van persoon tref}
        (xs+5 >= x2) and (xs-5 <= x2) and (kragy>0))then
          begin
          if kragx <=0 then               {as bal reeds linkswaarts oppad is}
           kragx:=kragx - 4               {tel bal spoed op in linkswaarts}
          else
           kragx:=kragx *-1 +2;           {beweeg bal in teenoorgestelde rigt}
          if jump1= true then             {as speler spring}
             kragy:= (kragy*-1-5) + (b2 div 4){beweeg bal sterk boontoe}
          else
             kragy:= kragy*-1-5;          {beweeg bal medium spoed boontoe}
          inc(regs);                      {tel hoeveel keer geslaan word}
          tref2:=true;
          tref1:=false;
          end;

{p1} if ((ys+15 >= y1) and (ys-5 <= y1) and{regs bo van persoon tref}
        (xs+5 >= xx1) and (xs-5 <= xx1) and (kragy>0))then
          begin
          if kragx >=0 then               {as bal reeds regwaarts oppad is}
           kragx:=kragx + 4               {tel bal spoed op regwaarts}
          else
           kragx:=kragx *-1 -2;           {beweeg bal in teenoorgesteld rigt}
          if jump1= true then             {as speler spring}
             kragy:= (kragy*-1-5)+ b1 div 4{beweeg bal sterk boontoe}
          else
             kragy:= kragy*-1-5;          {beweeg bal medium spoed boontoe}
          inc(links);                     {tel hoeveel keer geslaan word}
          tref1:=true;
          tref2:=false;
          end;
{p2} if ((ys+15 >= y2) and (ys-5 <= y2) and{regs bo van persoon tref}
        (xs+5 >= xx2) and (xs-5 <= xx2) and (kragy>0))then
          begin
          if kragx >=0 then                {as bal reeds regwaarts opppad is}
           kragx:=kragx + 4                {tel bal spoed op regwaarts}
          else
           kragx:=kragx *-1 -2;            {beweeg bal in teenoorgesteld rigt}
          if jump1= true then              {as speler spring}
             kragy:= (kragy*-1-5)+ (b2 div 4){beweeg bal sterk boontoe}
          else
             kragy:= kragy*-1-5;           {beweeg bal medium spoed boontoe}
          inc(regs);                       {tel hoeveel keer geslaan word}
          tref2:=true;
          tref1:=false;
          end;

{p1} if ((ys >= y1-13) and (ys <= y1+13) and (xs >= x1)
        and (xs <= xx1) and (kragy>0)) then{middel bokant van persoon tref}
          begin
          if jump1= true then              {as speler spring}
             kragy:=(kragy*-1-5)+(b1 div 4){beweeg bal sterk boontoe}
          else
             kragy:= kragy*-1-5;           {beweeg bal mediumn spoed boontoe}
          inc(links);                      {tel hoeveel keer geslaan word}
          tref1:=true;
          tref2:=false;
          end;
{p2} if ((ys >= y2-13) and (ys <= y2+13) and (xs >= x2)
        and (xs <= xx2) and (kragy>0)) then{Bokant van persoon tref}
          begin
          if jump1= true then              {as speler spring}
             kragy:=(kragy*-1-5)+(b2 div 4){beweeg bal sterk boontoe}
          else
             kragy:= kragy*-1-5;           {beweeg bal mediumn spoed boontoe}
          inc(regs);                       {tel hoeveel keer geslaan word}
          tref2:=true;
          tref1:=false;
          end;

{p1} if ((xs+10 >= x1) and (xs-10 <= x1)and{linkerkant van persoon tref}
        (ys+5 <= yy1) and (ys-5 > y1)) then
       begin
          if kragx <=0 then                {as bal reeds links beweeg}
           kragx:=kragx - 4                {tel bal spoed links op}
          else
           kragx:=kragx *-1 +2;            {beweeg bal in teenoorg. rigting}
          inc(links);                      {tel hoeveel keer geslaan word}
          tref1:=true;
          tref2:=false;
        end;
{p2} if ((xs+10 >= x2) and (xs-10 <= x2)and{linkerkant van persoon tref}
 (ys+5 <= yy2) and (ys-5 > y2)) then
       begin
          if kragx <=0 then                {as bal reeds links beweeg}
           kragx:=kragx - 4                {tel bal spoed links op}
          else
           kragx:=kragx *-1 +2;            {beweeg bal in teenoorg. rigting}
          inc(regs);                       {tel hoeveel keer geslaan word}
          tref2:=true;
          tref1:=false;
        end;

{p1} if ((xs-10 <= xx1)and(xs+10 >= xx1)and{regterkant van persoon tref}
        (ys+5 <= yy1) and (ys-5 > y1)) then
        begin
          if kragx >=0 then                {as bal reed regs beweeg}
            kragx:= kragx + 4              {tel bal speod regs op}
            else
             kragx:=kragx *-1 -2;          {beweeg bal in teenoorg.rigting}
          inc(links);                      {tel hoeveel keer geslaan word}
          tref1:=true;
          tref2:=false;
        end;
{p2} if ((xs-10 <= xx2)and(xs+10 >= xx2)and{regterkant van persoon tref}
        (ys+5 <= yy2) and (ys-5 > y2)) then
        begin
          if kragx >=0 then                {as bal reed regs beweeg}
            kragx:= kragx + 4              {tel bal speod regs op}
            else
             kragx:=kragx *-1 -2;          {beweeg bal in teenoorg.rigting}
          inc(regs);                       {tel hoeveel keer geslaan word}
          tref2:=true;
          tref1:=false;
        end;

      if ((xs+8 >= rkp-8) and (xs-8 <= rkp+8) and{regterkant van paal tref}
       (ys+5 <= y) and (ys-5 > y div 2) and (kragx <=0))then
         begin
            kragx:= kragx * -1-2           {beweeg bal in teenoorg. rigting}
                                           {spoed verminder bietjie}
         end;

      if ((xs+8 >= lkp-8) and (xs-8 <= lkp+8) and{linkerkant van paal tref}
       (ys+5 <= y) and (ys-5 > y div 2) and (kragx >=0))then
         begin
           kragx:= kragx * -1+2;           {beweeg bal in teenoorg. rigting}
                                           {spoed verminder bietjie}
         end;

      if ((xs >= lkp) and (xs <= rkp) and  {bokant van paal tref}
       (ys+5 >= bkp) and (ys-5 <= bkp) and (kragy >= 0))then
         begin
           kragy:= kragy*-1-5;             {beweeg bal vinnig opwaarts}
         end;

    if ((kragx <= 0) and (xs-5 <= 0)) then{as bal linkerkant van skerm tref}
     begin
       kragx:= -kragx;           {beweeg bal in teenoorgestelde rigting}
       if tref2 = true then
         kragx:= kragx div 2;    {beweeg bal teen die helfte van sy spoed-}
                                 {indien bal van die ander kant af kom}
     end;
    if ((kragx >= 0) and (xs+5 >= x)) then{as bal regterkant van skerm tref}
     begin
       kragx:= -kragx;           {beweeg bal in teenoorgestelde rigting}
       if tref1 = true then
         kragx:= kragx div 2;    {beweeg bal teen die helfte van sy spoed-}
                                 {indien bal van die ander kant af kom}
     end;

{die rondte is om as}
{p1}  if links=4 then             {as die bal vir 'n 4de keer persoon tref}
         begin
           nextround := true;     {is rondte om}
           if serve=2 then        {as p2 serve}
             inc(punt2);          {word sy punte meer}
           serve:=2;              {p2 serve}
           sound(500);delay(50);nosound;
         end;
{p2}  if regs=4 then              {as die bal vir 'n 4de keer persoon tref}
         begin
           nextround := true;     {is rondte om}
           if serve=1 then        {as p2 serve}
             inc(punt1);          {word sy punte meer}
           serve:=1;              {p2 serve}
           sound(1000);delay(50);nosound;
         end;

    if ys >= (grond-7) then       {bal grond tref}
     begin
       if xs<center then          {p1 se kant}
       begin
         if serve=2 then          {as p2 serve}
           inc(punt2);            {kry p2 punt by}
         serve:=2;                {p2 serve}
         nextround := true;       {rondte is om}
         sound(500);delay(50);nosound;delay(100);
       end;

       if xs>center then          {p2 se kant}
       begin
         if serve=1 then          {as p1 serve}
           inc(punt1);            {kry p1 punt by}
         serve:=1;                {p1 serve}
         nextround := true;       {rondte is om}
         sound(1000);delay(50);nosound;delay(100);
       end;
      end;

    if xs > center then           {as bal verby middel}
         links:=0;                {verval kere geslaan}
    if xs < center then           {as bal verby middel}
         regs:=0;                 {verval kere geslaan}

  until keypressed or nextround;
 druk := upcase(readkey);
 case druk of
{p1}'A':begin                      {knoppie links}
        dec(x1,kt);                {beweeg speler links}
        dec(xx1,kt);               {beweeg speler links}
      end;
{p1}'D':begin                      {knoppie regs}
        inc(x1,kt);                {beweeg speler regs}
        inc(xx1,kt);               {beweeg speler regs}
      end;
{p1}'W':begin                      {knoppie op}
        jump1:= true;              {gaan nou begin spring}
      end;
{p2}#75:begin                      {knoppie links}
        dec(x2,kt);                {beweeg speler links}
        dec(xx2,kt);               {beweeg speler links}
      end;
{p2}#77:begin                      {knoppie regs}
        inc(x2,kt);                {beweeg speler regs}
        inc(xx2,kt);               {beweeg speler regs}
      end;
{p2}#72:begin                      {knoppie op}
        jump2:= true;              {gaan nou begin spring}
      end;
 end;
 if nextround then       {reset al die waardes vir volgende rondte}
 begin
    kragx:=0;{bal}
    kragy:=0;
    ys :=1;
    if serve = 1 then    {as p1 serve}
      xs :=100;          {begin bal by hom}
    if serve = 2 then    {as p2 serve}
      xs :=530;          {begin bal by hom}

    x1:=100;    {p1}
    y1:=425;
    xx1:=125;
    yy1:=grond;
    links:=0;

    x2:=500;    {p2}
    y2:=425;
    xx2:=525;
    yy2:=grond;
    jump1:=false;
    jump2:=false;
    regs:=0;

    if trailjanee= true then
    for i:= 1 to 10 do   {maak skoon trail waardes}
     begin
       trailx[i]:=-30;
       traily[i]:=-30;
     end;

    gras:=true;          {gras sal weer geteken word volgende siklus}
    cleardevice;
 end;
if druk = #27 then       {as escape gedruk word}
  begin
    cleardevice;
    setcolor(red);
    settextstyle(1,horizdir,1);
    outtextxy(getmaxx div 2-120,getmaxy div 2-40,'Is jy seker jy wil quit Y/N');
    stop:=upcase(readkey);{vra of u wil quit}
    gras:=true;          {gras sal weer geteken word volgende siklus}
    cleardevice;
  end;
until (stop='Y') or (punt1=pot) or (punt2=pot);{as game klaar is}

cleardevice;
klein(kleinste);          {kry kleinste waarde van highscorelys}
if punt1 = pot then       {as p1 wen}
   begin
    settextstyle(defaultfont,horizdir,3);
    setcolor(p1kleur);
    outtextxy(230,y div 2 -70,p1naam);
    outtextxy(270,y div 2 +10,'WEN');
    setcolor(red);
    settextstyle(defaultfont,horizdir,1);
    outtextxy(10,getmaxy-40,'Druk enter om voort te gaan');
    sound(200);delay(200);nosound;delay(200);
    sound(400);delay(200);nosound;delay(200);
    sound(600);delay(100);nosound;delay(200);
    sound(800);delay(100);nosound;delay(200);
    sound(200);delay(200);nosound;delay(200);
    sound(200);delay(200);nosound;delay(200);
    sound(800);delay(200);nosound;delay(200);
    nosound;
    readln;
    puntverskil:=punt1-punt2;       {werk punteverskil uit}
    if (puntverskil) > kleinste then{as dit 'n highscore is}
      begin
       wen:=1;
       berekenhighscore(puntverskil,p1naam,p2naam,wen);
      end;
   end;
if punt2 = pot then            {as p2 wen}
   begin
    settextstyle(defaultfont,horizdir,3);
    setcolor(p2kleur);
    outtextxy(230,y div 2 -70,p2naam);
    outtextxy(270,y div 2 +10,'WEN');
    settextstyle(defaultfont,horizdir,1);
    setcolor(red);
    settextstyle(defaultfont,horizdir,1);
    outtextxy(10,getmaxy-40,'Druk enter om voort te gaan');
    sound(200);delay(200);nosound;delay(200);
    sound(400);delay(200);nosound;delay(200);
    sound(600);delay(100);nosound;delay(200);
    sound(800);delay(100);nosound;delay(200);
    sound(200);delay(200);nosound;delay(200);
    sound(200);delay(200);nosound;delay(200);
    sound(800);delay(200);nosound;delay(200);
    nosound;
    readln;
    puntverskil:=punt2-punt1;       {werk punteverskil uit}
    if (puntverskil) > kleinste then{as dit 'n highscore is}
      begin
       wen:=2;
       berekenhighscore(puntverskil,p1naam,p2naam,wen);
      end;
   end;
end;
{-------------------------------------------------------------------------}
{-------------------------------------------------------------------------}
{-------------------------------------------------------------------------}
{spelers menu, verander name en kleure van spelers}
procedure players(var p1naam:str15; var p2naam:str15; var p1kleur:integer;
                  var p2kleur:integer;var spoed:integer);
var aantal,x1,x2,y : integer;
    druk,druk2 : char;
begin
  cleardevice;
  x1:=100;    {koordinate van "cursor"}
  x2:=550;    {koordinate van "cursor"}
  y:=132;     {koordinate van "cursor"}
  repeat
    settextstyle(defaultfont,horizdir,3);
    setcolor(red);
    outtextxy(230,50,'SPELERS');
    settextstyle(1,horizdir,1);
    setfillstyle(1,p1kleur);
    bar(400, 120, 415, 140);
    setcolor(green);
    outtextxy(150,120,'Speler een se kleur');
    outtextxy(150,220,'Speler een se naam >');
    setcolor(p1kleur);
    outtextxy(400,220,p1naam);
    setfillstyle(1,p2kleur);
    bar(400, 170, 415, 190);
    setcolor(green);
    outtextxy(150,170,'Speler twee se kleur');
    outtextxy(150,270,'Speler twee se naam >');
    setcolor(p2kleur);
    outtextxy(400,270,p2naam);
    setcolor(red);
    outtextxy(10,getmaxy-40,'Escape vir vorige menu');
    setfillstyle(1,black);
    repeat
     setfillstyle(1,red);
     setcolor(red);
     circle(x1,y,8);
     floodfill(x1,y,red);
     circle(x2,y,8);
     floodfill(x2,y,red);
     druk:=upcase(readkey);
     setfillstyle(1,black);
     setcolor(black);
     circle(x1,y,8);
     floodfill(x1,y,black);
     circle(x2,y,8);
     floodfill(x2,y,black);
     if druk=#80 then
      begin
        inc(y,50);
      end;
    if druk=#72 then
      begin
        dec(y,50);
      end;
    if y > 282 then
      y:=132;
    if y < 132 then
      y:=282;
  until (druk=#13) or (druk = #27);{totdat enter or escape gedruk word}
    textbackground(black);
    textcolor(white);
    if druk<>#27 then
              case y of
                  132 : begin    {kies kleur van p1}
                         repeat
                            inc(p1kleur);
                         until (p1kleur <> p2kleur) and
                               (p1kleur <> ord(black));
                          end;
                  182 : begin    {kies kleur van p2}
                         repeat
                             inc(p2kleur);
                         until (p2kleur <> p1kleur) and
                               (p2kleur <> ord(black));
                         end;
                  232 : begin    {verander naam van p1}
                         setfillstyle(1,black);
                         bar(400,220,600,250);
                         settextstyle(1,horizdir,1);
                         p1naam := '';
                         aantal := 0;
                         setcolor(p1kleur);
                         druk := readkey;
                      while druk <> #13 do
                        begin
                          p1naam := p1naam + druk;
                          outtextxy(400+(aantal*9),220,druk);
                          druk := readkey;
                          inc(aantal);
                        end;
                        end;
                  282 : begin     {verander naam van p2}
                        setfillstyle(1,black);
                        bar(400,270,600,300);
                        settextstyle(1,horizdir,1);
                        p2naam := '';
                        aantal := 0;
                        setcolor(p2kleur);
                        druk := readkey;
                        while druk <> #13 do
                        begin
                          p2naam := p2naam + druk;
                          outtextxy(400+(aantal*9),270,druk);
                          druk := readkey;
                          inc(aantal);
                        end;
                       end;
              end;
              cleardevice;
    if p1kleur < 1 then  {skakel verbode kleure uit}
      p1kleur := 15;
    if p1kleur > 15 then {skakel verbode kleure uit}
      p1kleur := 1;
    if p2kleur < 1 then  {skakel verbode kleure uit}
      p2kleur := 15;
    if p2kleur > 15 then {skakel verbode kleure uit}
      p2kleur := 1;
  until druk = #27;      {totdat escape gedruk word}
  cleardevice;
end;
{-------------------------------------------------------------------------}
{die spoed menu, verander spoed van spel}
procedure speed(var spoed:integer);
var janee:boolean;
    x1,x2,y:integer;
    druk:char;
begin
 x1:=150;              {koordinate van "cursor"}
 x2:=400;              {koordinate van "cursor"}
 y:= 162;              {koordinate van "cursor"}
 cleardevice;
 settextstyle(defaultfont,horizdir,3);
 setcolor(red);
 outtextxy(230,20,'SPOED');
 setcolor(green);
 settextstyle(1,horizdir,1);
 outtextxy(240,150,'Stadig');
 outtextxy(240,200,'Normaal');
 outtextxy(240,250,'Vinnig');
 outtextxy(240,300,'Te vinnig');
 setcolor(red);
 outtextxy(10,getmaxy-40,'Druk Escape vir vorige menu');
   repeat
     setfillstyle(1,red);
     setcolor(red);
     circle(x1,y,8);
     floodfill(x1,y,red);
     circle(x2,y,8);
     floodfill(x2,y,red);
     druk:=upcase(readkey);
     setfillstyle(1,black);
     setcolor(black);
     circle(x1,y,8);
     floodfill(x1,y,black);
     circle(x2,y,8);
     floodfill(x2,y,black);
     if druk=#80 then
      begin
        inc(y,50);
      end;
    if druk=#72 then
      begin
        dec(y,50);
      end;
    if y > 312 then
      y:=162;
    if y < 162 then
      y:=312;
  until (druk=#13) or (druk = #27);{totdat enter or escape gedruk word}
    if druk = #27 then
      keuse := 'Q';
    textbackground(black);
    textcolor(white);
    if druk<>#27 then              {as knop gedruk nie escape is nie}
    case y of                      {stel spoed in}
      162 : spoed:= 30;
      212 : spoed:= 16;
      362 : spoed:= 10;
      412 : spoed:= 0;
    end;
keuse:='8';                 {maak keuse iets wat nie gebruik word nie}
end;
{-------------------------------------------------------------------------}
{die kontrole menu, dit vertoon slegs die kontroles vir p1 en p2 vir die spel}
procedure kontroles(p1naam,p2naam:str15);
begin
    cleardevice;

{p2}settextstyle(defaultfont,horizdir,3);
    setcolor(red);
    outtextxy(100,20,'SPELERS SE KONTROLES');
    settextstyle(1,horizdir,2);
    setcolor(green);
    outtextxy(100,80,'Knoppies van');
    outtextxy(250,80,p2naam);
    outtextxy(250,120,'Op    :  ');
    outtextxy(250,150,'Links :  ');
    outtextxy(250,180,'Regs  :  ');
    settextstyle(defaultfont,horizdir,2);
    outtextxy(350,125,char(24));
    outtextxy(350,155,char(26));
    outtextxy(350,185,char(27));

{p1}settextstyle(1,horizdir,2);
    outtextxy(100,240,'Knoppies van');
    outtextxy(250,240,p1naam);
    outtextxy(250,270,'Op    :   W');
    outtextxy(250,300,'Links :   A');
    outtextxy(250,330,'Regs  :   S');

    setcolor(red);
    outtextxy(10,getmaxy-40,'Druk enige knop vir vorige menu');
    readkey;
end;
{-------------------------------------------------------------------------}
{konfigureer menu, dit is slegs 'n "link" tot volgende menu's}
procedure konfigureer(var p1naam:str15; var p2naam:str15; var p1kleur:integer;
                      var p2kleur:integer;var spoed:integer);
var janee:boolean;
    x1,x2,y:integer;
    druk:char;
begin
    x1:= 160;
    x2:= 420;
    y:=162;
    cleardevice;
    settextstyle(defaultfont,horizdir,3);
    setcolor(red);
    outtextxy(120,20,'KONFIGUREER SPEL');
    settextstyle(1,horizdir,2);
    setcolor(green);
    outtextxy(getmaxx div 2-120,150,'Speler konfigurasie');
    outtextxy(getmaxx div 2-120,200,'Spoed');
    outtextxy(getmaxx div 2-120,250,'Spelers se Kontroles');
    setcolor(red);
    outtextxy(10,getmaxy-40,'Druk Escape vir vorige menu');
    janee:=false;
    repeat
     setfillstyle(1,red);
     setcolor(red);
     circle(x1,y,8);
     floodfill(x1,y,red);
     circle(x2,y,8);
     floodfill(x2,y,red);
     druk:=upcase(readkey);
     setfillstyle(1,black);
     setcolor(black);
     circle(x1,y,8);
     floodfill(x1,y,black);
     circle(x2,y,8);
     floodfill(x2,y,black);
     if druk=#80 then
      begin
        inc(y,50);
      end;
    if druk=#72 then
      begin
        dec(y,50);
      end;
    if y > 262 then
      y:=162;
    if y < 162 then
      y:=262;
  until (druk=#13) or (druk = #27);
    if druk = #27 then
      keuse := 'Q';
    textbackground(black);
    textcolor(white);
    if druk<>#27 then
    case y of
      162 : players(p1naam,p2naam,p1kleur,p2kleur,spoed);
      212 : speed(spoed);
      262 : kontroles(p1naam,p2naam);
     end;
end;
{-------------------------------------------------------------------------}
{hierdie procedure vertoon die bedankings}
procedure credits;
var akere,x1,x2,y1,y2:integer;
    woord1,woord2:string;
    stop:boolean;
begin
  SetBkColor(blue);
  akere:=0;
  repeat
    cleardevice;
    setcolor(red);
    settextstyle(1,0,5);
    outtextxy(200,1,'BEDANKINGS');

    SetLineStyle(0, 0, 3);
    setcolor(red);
    circle(550,440,15);
    setfillstyle(1,red);
    floodfill(550,440,red);
    setcolor(brown);        {hierdie stuk vertoon die 3/4appel}
    setfillstyle(1,brown);
    line(550,425,560,410);
    setcolor(green);
    setfillstyle(1,green);
    PieSlice(544, 417, 0, 120, 10);
    PieSlice(548, 411, 140, 300, 8);
    settextstyle(11,0,1);
    outtextxy(508, 440, '3/4');
    outtextxy(550, 458, 'sagteware');
    x1:=-50;
    y1:=200;
    x2:=getmaxx;
    y2:=230;
    inc(akere);
      case akere of                         {gaan deur al die bedankings}
        1: begin
             woord1:='Ontwerp deur';
             woord2:='David Smit';
           end;
        2: begin
             woord1:='Geprogrammeerd deur';
             woord2:='David Smit';
           end;
        3: begin
             woord1:='Getoets deur';
             woord2:='David Smit';
           end;
        4: begin
             woord1:='Alle klanke deur';
             woord2:='David Smit';
           end;
        5: begin
             woord1:='Intro deur';
             woord2:='David Smit';
           end;
        6: begin
             woord1:='David Smit is';
             woord2:='3/4appel sagteware';
           end;
        7: begin
             woord1:='Dankie aan almal';
             woord2:='wat my spel geniet het';
           end;
      end;
      settextstyle(3,0,3);
    repeat
       setcolor(blue);
       outtextxy(x1,y1,woord1);
       setcolor(green);
       inc(x1);
       outtextxy(x1,y1,woord1);
       delay(2);
    until x1=200;
    repeat
       setcolor(blue);
       outtextxy(x2,y2,woord2);
       dec(x2);
       setcolor(green);
       outtextxy(x2,y2,woord2);
       delay(2);
    until x2<250;
    delay(2000);
  if keypressed then stop :=true;
  until (akere=7) or (stop=true);
  SetBkColor(black);
  SetLineStyle(0, 0, normwidth);
  cleardevice;
  readkey;
end;
{-------------------------------------------------------------------------}
{die kreatiewe menu, veskaf "shortcuts" tot ander procedures}
procedure menu(var p1naam,p2naam:str15; var p1kleur,p2kleur,spoed,wen:integer);
var
 x1,y,x2:integer;
 Radius: Integer;
 janee:boolean;
 druk:char;
begin
  x1:=190; {koordinate van "cursor"}
  x2:=450; {koordinate van "cursor"}
  y:=150;  {koordinate van "cursor"}
  cleardevice;
 for Radius := 1 to 215 do
   begin
    setcolor(random(getmaxcolor));
    Circle(getmaxx div 2, getmaxy div 2, Radius * 2);
   end;
 for Radius := 1 to 85 do
   begin
    setcolor(black);
    Circle(getmaxx div 2, getmaxy div 2, Radius * 2);
   end;
  {vertoon nodige inligting}
  settextstyle(1,horizdir,3);
  setcolor(100);
  outtextxy(getmaxx div 2-82,getmaxy div 2-150,'VLUGBAL 2002');
  settextstyle(1,horizdir,1);
  setcolor(green);
  outtextxy(getmaxx div 2-50,getmaxy div 2-100,'SPEEL NOU');
  settextstyle(1,horizdir,1);
  outtextxy(getmaxx div 2-70,getmaxy div 2-60,'Konfigureer Spel');
  outtextxy(getmaxx div 2-90,getmaxy div 2-20 ,'Grootste Oorwinning');
  outtextxy(getmaxx div 2-50,getmaxy div 2+20,'Bedankings');
  setcolor(red);
  outtextxy(getmaxx div 2-70,getmaxy div 2+60,'Verlaat Program');
  settextstyle(defaultfont,horizdir,1);
  setcolor(red);
  outtextxy(getmaxx div 2-66,getmaxy div 2+137,'3/4appel sagteware');
  setcolor(green);
  outtextxy(getmaxx div 2-68,getmaxy div 2+140,'3/4appel sagteware');
  repeat {"cursor"}
    setfillstyle(1,red);
    setcolor(red);
    circle(x1,y,8);
    floodfill(x1,y,red);
    circle(x2,y,8);
    floodfill(x2,y,red);
    druk:=upcase(readkey);
    setfillstyle(1,black);
    setcolor(black);
    circle(x1,y,8);
    floodfill(x1,y,black);
    circle(x2,y,8);
    floodfill(x2,y,black);
    if druk=#80 then{af pyltjie}
      begin
        inc(y,40);
      end;
    if druk=#72 then{op pyltjie}
      begin
        dec(y,40);
      end;
    if y > 310 then
      y:=150;
    if y < 150 then
      y:=310;
  until (druk=#13) or (druk=#27);{enter of escape}
  if druk =#27 then     {escape}
   keuse:= 'Q';
  textbackground(black);
  textcolor(white);
    if druk<>#27 then    {nie escape}
    case y of            {roep gekiesde procedure}
     150 : begin
             game(spoed,p1naam,p2naam,wen,p1kleur,p2kleur);
          end;
     190 :begin
           repeat
             konfigureer(p1naam,p2naam,p1kleur,p2kleur,spoed);
           until keuse='Q';
           keuse:='2';
          end;
     230 : vertoonhighscores;
     270 : credits;
     310 : keuse:='Q';
    end;
    cleardevice;
end;
{-------------------------------------------------------------------------}
{hoofdeel, stel nodige waardes in en roep menu}
var spoed,wen:integer;
    p1naam,p2naam:str15;
    p1kleur,p2kleur:integer;
begin
  randomize;
  stel;
  p1naam:='Speler1';
  p2naam:='Speler2';
  p1kleur:=blue;
  p2kleur:=yellow;
  spoed:= 16;
repeat
  MENU(p1naam,p2naam,p1kleur,p2kleur,spoed,wen);
until keuse = 'Q'
{{{ThE}end.