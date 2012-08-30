$typecheck on
$include "rapidq.inc"
application.icon = "tests.ico"

declare sub FormClose(action as integer)
declare sub FormShow '(Sender: TObject)
declare sub toEndTimer '(Sender: TObject)
declare sub nextQClick '(Sender: TObject);
declare sub okeyClick '(Sender: TObject);
declare sub FormCreate '(Sender: TObject);
declare sub ReadAllQ '//чтение из файла в список
declare sub ReadQ
declare sub psiho
declare sub selectQ
declare sub orderQ 'есть процедура сортирующа€ массив (см. справку)
declare sub inputQ
declare sub propusk

create frmTest as qform
  Left = 213
  Top = 106
  BorderStyle = bsSingle
  Caption = #1058#1077#1089#1090#1080#1088#1086#1074#1072#1085#1080#1077
  ClientHeight = 453
  ClientWidth = 632
  Color = clBlue
  Center
  OnClose = FormClose
'  OnCreate = FormCreate
  OnShow = FormShow
    create lcurQ as qlabel
    Left = 320
    Top = 0
    Width = 305
    Height = 17
    AutoSize = False
    Caption = #1058#1077#1082#1091#1097#1080#1081' '#1074#1086#1087#1088#1086#1089
    end create
    create pic as qimage
    Left = 320
    Top = 88
    Width = 305
    Height = 305
    Center = True
    Stretch = True
    Transparent = True
    end create
    create panel1 as qpanel
    Left = 0
    Top = 412
    Width = 632
    Height = 41
    Align = alBottom
    BevelInner = bvLowered
'    Color = clGray
    TabOrder = 1
        create okey as qbutton
        Left = 8
        Top = 8
        Width = 137
        Height = 25
        Caption = #1043#1086#1090#1086#1074#1086
        Default = True
        TabOrder = 0
        OnClick = okeyClick
        end create
        create nextQ as qbutton
        Left = 160
        Top = 8
        Width = 137
        Height = 25
        Caption = #1055#1088#1086#1087#1091#1089#1090#1080#1090#1100
        TabOrder = 1
        OnClick = nextQClick
        end create
    end create
    create pVariants as qpanel
    Left = 8
    Top = 0
    Width = 305
    Height = 393
    BevelInner = bvLowered
    BorderStyle = bsSingle
    Color = clWhite
    TabOrder = 0
    end create
    create query as qrichedit 'qedit
    Left = 320
    Top = 16
    Width = 305
    Height = 65
'    Color = clCream
    ReadOnly = True
    TabOrder = 2
    end create
end create

create toEnd as qtimer
Enabled = False
OnTimer = toEndTimer
end create

type TQ  'массив вопросов
    text as string*255 'текст вопроса
    resF as string*255 'файл с комментарием (графика)
    tipQ as string*6 'тип вопроса
    count as integer 'кол-во ответов
    countV as integer 'кол-во верных
'    variants as qstringlist 'варианты ответов
    ball as integer 'балл за ответ
end type

dim q as TQ
dim tst as qstringlist
dim balls as integer 'суммарный балл
dim curQ as integer 'текущий вопрос

'//================================================================
sub FormShow
dim i as integer
'{начало}
if (TTh<>0) or (TTm<>0) or (TTs<>0) then toEnd.Enabled:=true;
frmTest.caption:="“естирование";
if pVariants.ControlCount<>0 then
  for i:=0 to pVariants.ControlCount-1 do
    pVariants.Controls[0].Destroy;
curQ:=0;
'//Qok:=0;
balls:=0;
setlength(q,qh.kolQ);//задаем размер массива вопросов
'//kolQ:=strtoint(frmStart.KolQ.Text);
'//SetLength(Qs,kolQ);
'//for i:=0 to qh.kolQ-1 do Qs[i]:=false;
readAllQ;
ReadQ;
end sub

'//================================================================
sub FormClose(action as integer)
if messagedlg("“естирование еще не закончено."+chr$(10)+"ѕрервать тест?", _
    mtConfirmation,mbYes+mbNo,0)=mrNo then action=0 else frmStart.Show
'-очищать все ненужные переменные и массивы
'  pic.Picture:=nil; pic.Refresh
'  frmStart.Show

end sub

'//================================================================
sub toEndTimer
var i: integer;
begin
TTs:=TTs-1;
if TTs<0 then
  begin
  TTs:=59;
  TTm:=TTm-1;
  end;
if TTm<0 then
  begin
  TTm:=59;
  TTh:=TTh-1;
  end;
if (TTh<0) {and (TTm<0) and (TTs<0)} then
  begin
  //врем€ вышло
  toEnd.Enabled:=false;
  messagebox(0,'¬рем€ тестировани€ истекло',' онец теста',mb_ok+mb_iconinformation);
  for i:=0 to qh.kolQ-1 do q[i].text:='';//помечаем все вопросы,
                                    //как отвеченные
  ReadQ;
  end;
frmTest.caption:=rightstr('0'+inttostr(TTh),2)+':'+
rightstr('0'+inttostr(TTm),2)+':'+rightstr('0'+inttostr(TTs),2);

end sub

'//================================================================
sub ReadQ
var
fileext: string;
i: integer;
reslt: boolean;
label nach;
begin
nach:
if curQ>(qh.kolQ-1) then
  begin
    reslt:=true;
    for i:=0 to qh.kolQ-1 do
      if q[i].text<>'' then reslt:=reslt and false;
    if reslt then
      begin
      //вопросы кончились
      { - выключение, обнуление, сброс всего лишнего}
      pic.Picture:=nil; pic.Refresh;
      toEnd.Enabled:=false;
      frmTest.Hide;
      frmStat.Show;
      exit;
      end
      else
      begin
      //есть еще вопросы
      curQ:=0;
      end;
'  //¬се вопросы пройдены. ¬озвращаемс€ к пропущенным вопросам.
'//  goto nach;
  //exit;
  end;
//ответ на вопрос дан, значит пропускаем его...
if q[curQ].text='' then
  begin
  inc(curQ);
  goto nach;
  end;

lcurQ.Caption:='¬опрос: '+inttostr(curQ+1)+' из '+inttostr(qh.kolQ);
Query.Text:=q[curQ].text;
fileext:='';
if q[curQ].resF<>'' then
  fileext:=lowercase(ExtractFileExt(q[curQ].resF));
//поддерживаемые графические форматы:
if (fileext='.jpg') or (fileext='.bmp') or (fileext='.wmf')
  or (fileext='.ico') or (fileext='.jpeg') then
  begin
  pic.Picture.LoadFromFile(qh.resD+q[curQ].resF);
  end;

//Readln(tstFile,S);//тип вопроса

if q[curQ].tipQ='select' then
  begin
  selectQ;
  exit;
  end;

if q[curQ].tipQ='order' then
  begin
  orderQ;
  exit;
  end;

if q[curQ].tipQ='input' then
  begin
  inputQ;
  exit;
  end;

if q[curQ].tipQ='' then
  begin
  psiho;
  exit;
  end;

end sub

//================================================================
procedure TfrmTest.nextQClick(Sender: TObject);
var i: integer;
cc: integer;
begin
pic.Picture:=nil; pic.Refresh;
cc:=pVariants.ControlCount;
Query.Text:='';
for i:=0 to cc-1 do pVariants.Controls[0].Destroy;

inc(curQ);

readQ;

end;

//================================================================
procedure TfrmTest.inputQ;
var
inbox: tedit;
i: integer;
begin
//Readln(tstFile,S);
inbox:=tedit.Create(self);
inbox.Left:=20;
inbox.Top:=20;
inbox.Width:=pVariants.Width-40;
inbox.AutoSize:=false;
inbox.Parent:=frmTest.pVariants;

end;

//================================================================
procedure TfrmTest.orderQ;
var
d, ic: integer;
vibr: string;
kolEl: integer;
i: integer;
//varC1: array of tspinedit;//массив счетчиков
varC1: array of trxspinedit;
varC2: array of tstatictext;//массив элем. дл€ упор€дочивани€
begin
{при щелчке по варианту ответа измен€ть его счетчик
  - лева€ кнопка - увел.
  - права€ кнонка - уменьш.}

  kolEl:=q[curQ].count;
  SetLength(varC1,kolEl);
  SetLength(varC2,kolEl);
  for i:=1 to kolEl do vibr:=vibr+RightStr('0'+IntToStr(i),2);
  Randomize;
  for i:=0 to kolEl-1 do
    begin
    d:=random(Length(vibr)div 2);
    //showmessage(inttostr(d)+'/'+inttostr(length(vibr)div 2)+' - '+vibr);
    ic:=StrToInt(MidStr(vibr,d*2+1,2));
    delete(vibr,d*2+1,2);
//    varC1[i]:=tspinedit.Create(self);
    varC1[i]:=trxspinedit.Create(self);
    varC2[i]:=tstatictext.Create(self);
    varC1[i].Top:=ic*40-20;
    varC2[i].Top:=ic*40-20;
    varC1[i].Left:=20;
    varC2[i].Left:=70;
    varC1[i].MinValue:=1;
    varC1[i].MaxValue:=kolEl;
    varC1[i].MaxLength:=2;
    varC2[i].Caption:=q[curQ].variants.Strings[i];
    varC1[i].Width:=45;
    varC2[i].AutoSize:=false;
    varC2[i].Width:=pVariants.Width-90;
    varC1[i].Tag:=i;//индекс элем. = его номер по пор€дку
    varC2[i].Color:=clCream;
    end;
    for i:=0 to kolEl-1 do
      begin
      varC1[i].Parent:=frmTest.pVariants;
      varC2[i].Parent:=frmTest.pVariants;
      end;
pVariants.SetFocus;

end;

//================================================================
procedure TfrmTest.selectQ;
var
d, ic: integer;
vibr: string;
kolV: integer;
kolVV: integer;
i: integer;
varC: array of tcheckbox;//массив checkbox'ов (варианты ответов)
begin
kolV:=q[curQ].count;
kolVV:=q[curQ].countV;
SetLength(varC,kolV);
for i:=1 to kolV do vibr:=vibr+RightStr('0'+IntToStr(i),2);
Randomize;
for i:=0 to kolV-1 do
  begin
  d:=random(Length(vibr)div 2);
  //showmessage(inttostr(d)+'/'+inttostr(length(vibr)div 2)+' - '+vibr);
  ic:=StrToInt(MidStr(vibr,d*2+1,2));
  delete(vibr,d*2+1,2);
  varC[i]:=tcheckbox.Create(self);
  varC[i].Top:=ic*40-20;
  varC[i].Left:=20;
//  Readln(tstFile,S);//чтение варианта ответа
  varC[i].Caption:=q[curQ].variants.Strings[i];
  varC[i].WordWrap:=true;
  varC[i].Width:=pVariants.Width-40;
  varC[i].Color:=clCream;
  if i<kolVV then
    varC[i].Tag:=1
    else
    varC[i].Tag:=0;
  end;
for i:=0 to kolV-1 do varC[i].Parent:=frmTest.pVariants;
pVariants.SetFocus;

end;

//================================================================
procedure TfrmTest.okeyClick(Sender: TObject);
var i, j: integer;
cc: integer;
rs: boolean;
begin
cc:=pVariants.ControlCount;

rs:=true;
if q[curQ].tipQ='' then
  begin
  for i:=0 to cc-1 do
    rs:=rs and not(pVariants.Controls[i] as tradiobutton).Checked;
  if rs then exit;
  end;

pic.Picture:=nil; pic.Refresh;
Query.Text:='';

if q[curQ].tipQ='select' then
  begin
  for i:=0 to cc-1 do
    if ord((pVariants.Controls[i] as tcheckbox).Checked)<>
        ((pVariants.Controls[i] as tcheckbox).Tag) then q[curQ].ball:=0;
  balls:=balls+q[curQ].ball;
  end;

if q[curQ].tipQ='order' then
  begin
  for i:=0 to (cc div 2)-1 do
    if (pVariants.Controls[i*2] as trxspinedit).Value<>
        ((pVariants.Controls[i*2] as trxspinedit).Tag+1) then q[curQ].ball:=0;
  balls:=balls+q[curQ].ball;
  end;

if q[curQ].tipQ='input' then
  begin
    for j:=0 to q[curQ].variants.Count-1 do
      if lowercase((pVariants.Controls[0] as tedit).Text)=lowercase(q[curQ].variants.Strings[j]) then
        begin
        balls:=balls+q[curQ].ball;
//        ballQ:=0;
        end;
  end;

if q[curQ].tipQ='' then
  for i:=0 to cc-1 do
    if (pVariants.Controls[i] as tradiobutton).Checked then
      balls:=balls+(pVariants.Controls[i] as tradiobutton).Tag;

for i:=0 to cc-1 do pVariants.Controls[0].Destroy;

q[curQ].text:='';//помечаем вопрос как отвеченный
//Qok:=Qok+1;//дано ответов
//showmessage(inttostr(balls));

inc(curQ);

readQ;

end;

//================================================================
procedure TfrmTest.propusk;
var i, i2: integer;
tipQ: string;
begin
{Readln(tstFile,S);//пропуск вопроса
Readln(tstFile,S);//пропуск файла мультимедиа
Readln(tstFile,S);//тип вопроса
tipQ:=S;
  Readln(tstFile,S);//кол-во вариантов
  i2:=strtoint(s);
if tipQ='select' then Readln(tstFile,S);//кол-во верных вариантов
for i:=0 to i2 do
  Readln(tstFile,S);//пропуск всех вариантов и балла за ответ
//ReadQ;}
end;

//================================================================
procedure TfrmTest.psiho;
var
kolV: integer;
i: integer;
//varC: array of tcheckbox;//массив checkbox'ов (варианты ответов)
varC: array of tradiobutton;
begin
{Readln(tstFile,S);//кол-во вариантов ответов
kolV:=strtoint(s);
SetLength(varC,kolV);
Randomize;
for i:=0 to kolV-1 do
  begin
//  varC[i]:=tcheckbox.Create(self);
varC[i]:=tradiobutton.Create(self);
  varC[i].Top:=i*40+20;
  varC[i].Left:=20;
  Readln(tstFile,S);//чтение варианта ответа
  varC[i].Caption:=s;
  varC[i].WordWrap:=true;
  varC[i].Width:=pVariants.Width-40;
  varC[i].Color:=clCream;
  Readln(tstFile,S);//балл за вариант ответа
  varC[i].Tag:=strtoint(S);
  end;
for i:=0 to kolV-1 do varC[i].Parent:=frmTest.pVariants;
pVariants.SetFocus;}

end;

//================================================================
procedure TfrmTest.ReadAllQ;
var tstFile: textfile;
s: string;
i, j: integer;
begin
//пропуск первых строк файла теста (они уже считаны):
AssignFile(tstFile, frmStart.files.FileName);
Reset(tstFile);
for i:=1 to 7 do Readln(tstFile, S);
for i:=0 to qh.kolQ-1 do
  begin
  readln(tstFile,s);
  q[i].text:=s;
  readln(tstFile,s);
  q[i].resF:=s;
  readln(tstFile,s);
  q[i].tipQ:=s;
  if s='select' then
    begin
    readln(tstFile,s);
    q[i].count:=strtoint(s);
    readln(tstFile,s);
    q[i].countV:=strtoint(s);
    end
    else
    begin
    readln(tstFile,s);
    q[i].count:=strtoint(s);
    q[i].countV:=0;
    end;
  q[i].variants:=TStringList.Create;
  for j:=0 to q[i].count-1 do
    begin
    readln(tstFile,s);
    q[i].variants.Add(s);
    end;
  readln(tstFile,s);
  q[i].ball:=strtoint(s);
  end;
readln(tstFile,s);
qh.statballs:=strtobool(s);
qh.balls:=TStringList.Create;
while not(eof(tstFile)) do
  begin
  readln(tstFile,s);
  qh.balls.Add(s);
  end;

closefile(tstFile);

end;

//================================================================
procedure TfrmTest.FormCreate(Sender: TObject);
begin
//tst:=TStringList.Create;

end;

end.

