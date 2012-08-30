$optimize on
$apptype gui
$typecheck on
$include "rapidq.inc"
$resource head as "civ.bmp"
$resource backgr as "brick.bmp"
$resource ich as "ich.bmp"
$resource symbol as "symbol50.bmp"
$OPTION ICON "tests.ico"

Declare Function ShellExecute Lib "shell32.dll" Alias "ShellExecuteA" (hwnd As Long, lpOperation As String, lpFile As String, lpParameters As String, lpDirectory As String, nShowCmd As Long) As Long

' объявление процедур (declare sub) ###################################################################

declare sub frmStart_filesClick '(Sender: TObject)
declare sub frmStart_startClick '(Sender: TObject)
declare sub frmStart_btnExitClick '(Sender: TObject)
declare sub frmStart_FormClose(action as integer)
declare sub frmStart_FormShow '(Sender: TObject)
declare sub frmStart_btnInfoClick '(Sender: TObject);
declare sub frmStart_FormPaint '(Sender: TObject);
declare sub frmStart_ReadHead

declare sub frmTest_FormClose(action as integer)
declare sub frmTest_FormShow '(Sender: TObject)
declare sub frmTest_toEndTimer '(Sender: TObject)
declare sub frmTest_nextQClick '(Sender: TObject);
declare sub frmTest_okeyClick '(Sender: TObject);
declare sub frmTest_ReadAllQ '//чтение из файла в список
declare sub frmTest_ReadQ
declare sub frmTest_psiho
declare sub frmTest_selectQ
declare sub frmTest_orderQ
declare sub frmTest_sort(Button as integer,X as integer,Y as integer,Shift as integer,Sender as QLabel)
declare sub frmTest_inputQ
declare sub frmTest_freeEl

declare sub frmStat_FormHide '(Sender: TObject);
declare sub frmStat_FormShow '(Sender: TObject);
declare sub frmStat_stReturnClick '(Sender: TObject);
declare sub frmStat_stExitClick '(Sender: TObject);

declare sub frmHelp_FormClose(sender as qform, Action as integer)
declare sub frmHelp_emailClick '(Sender: TObject)
declare sub frmHelp_siteClick '(Sender: TObject)
declare sub frmHelp_ChangeTab

' создание типов ######################################################################################
' к сожалению, облом ...

'общ. инф-ия о тесте
dim qh_Name as string 'название
dim qh_Comment as string 'описание
dim qh_resD as string 'папка с ресурсами
dim qh_timer as string 'время на тест
dim qh_kolQ as integer 'кол-во вопросов
dim qh_propusk as integer 'наличие кнопки "пропустить"
dim qh_learn as integer 'доступность режима обучения
dim qh_statballs as integer 'вывод расчетной статистики
dim qh_balls as QStringList 'пределы + комментарии

'массив вопросов
dim q_text() as string 'текст вопроса
dim q_resF() as string 'файл с комментарием (графика)
dim q_tipQ() as string 'тип вопроса
dim q_count() as integer 'кол-во ответов
dim q_countV() as integer 'кол-во верных
dim q_variants() as qstringlist 'варианты ответов
dim q_ball() as integer 'балл за ответ

' объявление глобальных переменных и констант #########################################################

dim inbox as qedit 'поле ввода варианта ответа
dim varC() as qcheckbox 'массив checkbox (варианты ответов)
dim varCP() as qradiobutton 'массив переключателей
dim varC1(1 to 2,1) as integer 'массив с упорядоченными номерами элементов
dim varC2() as qlabel 'массив элем. для упорядочивания

dim TTh as integer 'время
dim TTm as integer 'на
dim TTs as integer 'тест
dim mmdir as string 'имя папки с картинками
dim filedir as string 'имя папки с программой

dim balls as integer 'суммарный балл
dim curQ as integer 'текущий вопрос

const clSkyBlue = rgb(200,200,250)
const clGrayBlue = rgb(120,120,200)
const clCream = rgb(255,215,160)
const clYellow = rgb(230,230,50)
const clLime = rgb(0,250,0)

' создание форм и элементов управления ################################################################

' создание шрифта =====================================================================================
create font as qfont
  color=clBlack
  name="Courier New Cyr"
  size=12
end create

' создание frmStart ===================================================================================
create frmStart as qform
  Left = 233
  Top = 157
'  AddBorderIcons(biSystemMenu, biMinimize)
  DelBorderIcons(biMaximize)
'  HideTitleBar = true
'  ShapeForm("image.bmp", &HFFFFFF)
  BorderStyle = bsSingle
  Caption = "Cercando il vero"
  ClientHeight = 453
  ClientWidth = 632
  Color = clSkyBlue
  Font=font
  Center
  OnClose = frmStart_FormClose
  OnPaint = frmStart_FormPaint
  OnShow = frmStart_FormShow
  create picHead as qimage
    Left = 82
    Top = 0
    Width = 468
    Height = 60
    AutoSize = True
    bmphandle = head
  end create
  create picBackgr as qimage
    Left = 0
    Top = 0
    Width = 64
    Height = 64
    AutoSize = True
    bmphandle = backgr
  end create
  create GrpInfo as QGroupBox
    Left = 8
    Top = 64
    Width = 617
    Height = 381
    Caption = ""
    TabOrder = 0
    create Label2 as QLabel
      Left = 16
      Top = 24
      Width = 169
      Height = 33
      AutoSize = False
      Caption = "Доступные тесты:"
      Color = clGrayBlue
      Transparent = False
    end create
    create Label4 as QLabel
      Left = 200
      Top = 267
      Width = 265
      Height = 30
      AutoSize = False
      Caption = "Время на тест:"
      Color = clGrayBlue
    end create
    create Label5 as QLabel
      Left = 200
      Top = 299
      Width = 265
      Height = 30
      AutoSize = False
      Caption = "Вопросов в тесте:"
      Color = clGrayBlue
    end create
    create picSymbol as QImage
      Left = 520
      Top = 265
      Width = 81
      Height = 64
      Center = True
      Stretch = True
      Transparent = True
    end create
    create files as QFileListBox
      Left = 16
      Top = 48
      Width = 169
      Height = 217
      ExtendedSelect = False
      AddFileTypes(ftReadOnly, ftNormal)
      ItemHeight = 16
      Mask = "*.tst"
      ShowHint = False
      TabOrder = 0
      OnClick = frmStart_filesClick
    end create
    create Panel1 as QPanel
      Left = 200
      Top = 24
      Width = 401
      Height = 241
      Color = clSkyBlue
      TabOrder = 1
      create Label1 as QLabel
        Left = 8
        Top = 8
        Width = 120
        Height = 16
        Caption = "Название"
      end create
      create Label3 as QLabel
        Left = 8
        Top = 72
        Width = 160
        Height = 16
        Caption = "Описание"
      end create
      create tstName as QRichEdit
        Left = 8
        Top = 24
        Width = 385
        Height = 49
        Color = clWhite
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 0
      end create
      create tstComment as QRichEdit
        Left = 8
        Top = 88
        Width = 385
        Height = 135
        Color = clWhite
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 1
      end create
    end create
    create Panel2 as QPanel
      Left = 8
      Top = 332
      Width = 601
      Height = 41
      Color = rgb(30,30,30)
      TabOrder = 2
      create start as QButton
        Left = 8
        Top = 8
        Width = 187
        Height = 25
        Caption = "Начать!"
        Default = True
        TabOrder = 0
        OnClick = frmStart_startClick
      end create
      create btnExit as QButton
        Left = 512
        Top = 8
        Width = 81
        Height = 25
        Cancel = True
        Caption = "Выход"
        TabOrder = 1
        OnClick = frmStart_btnExitClick
      end create
      create btnInfo as QButton
        Left = 392
        Top = 8
        Width = 105
        Height = 25
        Caption = "Справка"
        OnClick = frmStart_btnInfoClick
        TabOrder = 2
      end create
    end create
    create tstTime as QRichEdit
      Left = 360
      Top = 270
      Width = 102
      Height = 25
      Alignment = taCenter
      Enabled = False
'      Lines.Strings = (#1063#1063':'#1052#1052':'#1057#1057)
      ReadOnly = True
      TabOrder = 3
    end create
    create KolQ as QRichEdit
      Left = 416
      Top = 302
      Width = 46
      Height = 25
      Alignment = taCenter
      Enabled = False
      Text = "***"
      ReadOnly = True
      TabOrder = 4
    end create
    create Learn as QCheckBox
      Left = 16
      Top = 280
      Width = 169
      Height = 33
      Caption = "Режим обучения"
      TabOrder = 5
    end create
  end create
  end create

' создание frmTest ====================================================================================
create frmTest as qform
  Left = 213
  Top = 106
  BorderStyle = bsSingle
  Caption = "Тестрование"
  ClientHeight = 453
  ClientWidth = 632
  Color = clSkyBlue
  Center
  OnClose = frmTest_FormClose
'  OnCreate = FormCreate
  OnShow = frmTest_FormShow
    create lcurQ as qlabel
    Left = 320
    Top = 0
    Width = 305
    Height = 17
    AutoSize = False
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
    create panel3 as qpanel
    Left = 0
    Top = 412
    Width = 632
    Height = 41
    Align = alBottom
'    Color = clGray
    TabOrder = 1
        create okey as qbutton
        Left = 8
        Top = 8
        Width = 137
        Height = 25
        Caption = "Готово"
        Default = True
        TabOrder = 0
        OnClick = frmTest_okeyClick
        end create
        create nextQ as qbutton
        Left = 160
        Top = 8
        Width = 137
        Height = 25
        Caption = "Пропустить"
        TabOrder = 1
        OnClick = frmTest_nextQClick
        end create
    end create
    create pVariants as qpanel
    Left = 8
    Top = 0
    Width = 305
    Height = 393
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
OnTimer = frmTest_toEndTimer
end create

' создание frmStat ====================================================================================
create frmStat as qform
  Left = 192
  Top = 108
  AddBorderIcons biSystemMenu
  BorderStyle = bsSingle
  Caption = "Статистика"
  ClientHeight = 275
  ClientWidth = 488
  Color = clSkyBlue
  Center
  OnClose = frmStat_FormHide
  OnShow = frmStat_FormShow
  create Image4 as qimage
    Left = 136
    Top = 0
    Width = 353
    Height = 105
    Transparent = True
  end create
  create RxLabel1 as qlabel
    Left = 280
    Top = 16
    Width = 172
    Height = 18
    Caption = "Вопросы: "
    Transparent = True
  end create
  create RxLabel2 as qlabel
    Left = 280
    Top = 48
    Width = 152
    Height = 18
    Caption = "Баллы: "
    Transparent = True
    end create
  create stKolQ as qlabel
    Left = 456
    Top = 16
    Width = 12
    Height = 18
    Caption = "0"
    Transparent = True
  end create
  create stBalls as qlabel
    Left = 456
    Top = 48
    Width = 12
    Height = 18
    Caption = "0"
    Transparent = True
  end create
  create vivod as qrichedit
    Left = 0
    Top = 104
    Width = 488
    Height = 171
    Align = alBottom
    Color = clCream
    ReadOnly = True
    TabOrder = 0
  end create
  create stReturn as qbutton
    Left = 8
    Top = 8
    Width = 121
    Height = 33
    Caption = "Вернуться"
    Default = True
    TabOrder = 1
    OnClick = frmStat_stReturnClick
  end create
  create stExit as qbutton
    Left = 8
    Top = 56
    Width = 121
    Height = 33
    Cancel = True
    Caption = "Выход"
    TabOrder = 2
    OnClick = frmStat_stExitClick
  end create
end create

' создание frmHelp ====================================================================================
create fnt as qfont
  color=clYellow
end create
create fntG as qfont
  color=clLime
  addstyles(fsbold,fsunderline)
end create
create fntG2 as qfont
  color=clLime
end create
create fntB as qfont
  color=clLime
  size=14
end create

create frmHelp as qform
  BorderStyle = bsToolWindow
  Width = 320
  Height = 260
  Caption = "Справка"
  Color = clBlack
  FormStyle = fsStayOnTop
  Center
  OnClose = frmHelp_FormClose
  create pages as qtabcontrol
    Font = fnt
    AddTabs "Помощь","О программе"
    TabIndex=1
    Left = 0
    Top = 0
    Align = alClient
    FlatButtons = true
    FlatSeperators = true
    FocusButtons = true
    TabOrder = 0
    OnChange = frmHelp_ChangeTab
    create pgHelp as qpanel
      Color=clBlack
      left = 5
      top = 25
      width = pages.clientwidth-10
      height = pages.clientheight-30
      Visible = false
    end create
    create pgInfo as qpanel
      Color = clBlack
      left = 5
      top = 25
      width = pages.clientwidth-10
      height = pages.clientheight-30
      Visible = true
      ShowHint=true
      create Image5 as qimage
        bmphandle=symbol
        Left = 5
        Top = 100
        AutoSize = True
      end create
      create email as qovalbtn
        Hint="Написать письмо"
        Font=fntG
        Flat=true
        Cursor=crHandPoint
        ColorShadow=clWhite
        Left = 10
        Top = 30
        Width = 180
        Height = 25
        Caption = "shurik83@mail.ru"
        OnClick = frmHelp_emailClick
      end create
      create site as qovalbtn
        Hint="Посетить сайт"
        Font=fntG
        Flat=true
        Cursor=crHandPoint
        ColorShadow=clWhite
        Left = 10
        Top = 60
        Width = 180
        Height = 25
        Caption = "www.shurik83.narod.ru"
        OnClick = frmHelp_siteClick
      end create
      create Image6 as qimage
        BMPHandle=ich
        Left = 240
        Top = 5
        AutoSize = True
      end create
      create StaticText1 as qlabel
        Left = 10
        Top = 8
        Width = 196
        Height = 20
        Caption = "Автор: @ Вавилов Александр"
      end create
      create StaticText2 as qlabel
        Font=fntG2
        Left = 160
        Top = 115
        Autosize=true
        Caption = "Система тестирования"
      end create
      create StaticText3 as qlabel
        Font=fntB
        Left = 145
        Top = 140
        Autosize=true
        Caption = "'Cercando il vero'"
      end create
      create StaticText4 as qlabel
        Left = 250
        Top = 190
        Width = 100
        Height = 20
        Caption = "(c) 2 0 0 4"
       end create
    end create
  end create
end create

frmStart.showmodal
'######################################################################################################
'###### процедуры и функции ###########################################################################
'######################################################################################################

' frmStart ############################################################################################

'//================================================================
sub frmStart_filesClick
call frmStart_ReadHead 'чтение инф-ии о тесте
end sub

'//================================================================
sub frmStart_startClick
if (files.FileName="") then
  showmessage "Тест не выбран!"
  exit sub
end if
frmStart.visible=false
frmTest.Show
end sub

'//================================================================
sub frmStart_btnExitClick
frmstart.Close
end sub

'//================================================================
sub frmStart_FormClose(action as integer)
frmHelp.Close
'if messagedlg("Выйти из программы?",mtConfirmation,mbYes+mbNo,0)=mrNo then action=false
end sub

'//================================================================
sub frmstart_ReadHead 'чтение начальной инф-ии о тесте
dim tstFile as qfilestream
dim s as string

if files.FileName="" then exit sub
tstfile.open(files.FileName,fmOpenRead)
s=tstfile.Readline 'название
tstName.Text=s
qh_Name=s
s=tstfile.Readline 'комментарий
tstComment.text=s
qh_Comment=s
s=tstfile.Readline 'имя папки с картинками
if s<>"" then s=s+"\"
qh_resD=filedir+"\tests\"+s
s=tstfile.Readline 'время на тест
tstTime.Text=s
qh_timer=s
if s<>"" then
  TTh=val(mid$(s,1,2))
  TTm=val(mid$(s,4,2))
  TTs=val(mid$(s,7,2))
  else
  TTh=0
  TTm=0
  TTs=0
end if  
s=tstfile.Readline 'наличие кнопки "пропустить"
nextQ.Visible=val(s)
qh_propusk=s
s=tstfile.Readline 'доступность режима обучения
Learn.Visible=val(s)
qh_learn=val(s)
s=tstfile.Readline 'количество вопросов в тесте
KolQ.Text=s
qh_kolQ=val(s)
tstfile.close
if learn.Visible=false then learn.Checked=false
end sub

'//================================================================
sub frmStart_FormShow '(Sender: TObject)
filedir = curdir$
if DirExists(filedir+"\tests") then
  files.Directory=filedir+"\tests"
  files.update
  else
  showmessage("Не найден каталог с тестами - 'tests'")
end if

'создание элементов
inbox.Left=20
inbox.Top=20
inbox.Width=pVariants.Width-40
inbox.AutoSize=false
inbox.Parent=pVariants
inbox.visible=false

end sub

'//================================================================
sub frmStart_btnInfoClick '(Sender: TObject)
frmStart.Enabled=false
frmHelp.Show
end sub

'//================================================================
sub frmStart_FormPaint '(Sender: TObject)
dim i as integer
'перерисовывать

for i=0 to 9
  frmStart.Draw(i*64,0,picBackgr.bmp)
  frmStart.Draw(i*64,64,picBackgr.bmp)
  frmStart.Draw(i*64,416,picBackgr.bmp)
  frmStart.Draw(0,i*64,picBackgr.bmp)
  frmStart.Draw(576,i*64,picBackgr.bmp)
next i

end sub

' frmTest #############################################################################################

'//================================================================
sub frmTest_FormShow
dim i as integer
'{начало}
if (TTh<>0) or (TTm<>0) or (TTs<>0) then toEnd.Enabled=true
frmTest.caption="Тестирование"
'if pVariants.ControlCount<>0 then
'  for i:=0 to pVariants.ControlCount-1 do
'    pVariants.Controls[0].Destroy;
curQ=0
'//Qok:=0;
balls=0
'задаем размер массива вопросов
redim q_text(qh_kolQ-1) as string 'текст вопроса
redim q_resF(qh_kolQ-1) as string 'файл с комментарием (графика)
redim q_tipQ(qh_kolQ-1) as string 'тип вопроса
redim q_count(qh_kolQ-1) as integer 'кол-во ответов
redim q_countV(qh_kolQ-1) as integer 'кол-во верных
redim q_variants(qh_kolQ-1) as qstringlist 'варианты ответов
redim q_ball(qh_kolQ-1) as integer 'балл за ответ
'//kolQ:=strtoint(frmStart.KolQ.Text);
'//SetLength(Qs,kolQ);
'//for i:=0 to qh.kolQ-1 do Qs[i]:=false;
call frmTest_readAllQ
call frmTest_ReadQ
end sub

'//================================================================
sub frmTest_FormClose(action as integer)
'if messagedlg("Тестирование еще не закончено."+chr$(10)+"Прервать тест?", _
'    mtConfirmation,mbYes+mbNo,0)=mrNo then action=0 else frmStart.Show
  application.terminate
'-очищать все ненужные переменные и массивы
'  pic.Picture:=nil; pic.Refresh
'  frmStart.Show

end sub

'//================================================================
sub frmTest_toEndTimer
dim i as integer, j as integer
TTs=TTs-1
if TTs<0 then
  TTs=59
  TTm=TTm-1
  end if
if TTm<0 then
  TTm=59
  TTh=TTh-1
  end if
if (TTh<0) then '{and (TTm<0) and (TTs<0)} then
  'время вышло
  toEnd.Enabled=false
  showmessage "Время тестирования истекло!"
  for i=0 to qh_kolQ-1
    q_text(i)=""
  next i 'помечаем все вопросы, как отвеченные
  call frmTest_freeEl
  call frmTest_ReadQ
  end if
frmTest.caption=right$("0"+str$(TTh),2)+":"+right$("0"+str$(TTm),2)+":"+right$("0"+str$(TTs),2)

end sub

'//================================================================
sub frmTest_freeEl
dim i as integer
if q_tipQ(curQ)="select" then 
for i=0 to q_count(curQ)-1
varC(i).visible=false
next i
exit sub
end if
if q_tipQ(curQ)="order" then 
for i=0 to q_count(curQ)-1
varC2(i).visible=false
next i
exit sub
end if
if q_tipQ(curQ)="input" then 
inbox.visible=false
exit sub
end if
if q_tipQ(curQ)="" then 
for i=0 to q_count(curQ)-1
varCP(i).visible=false
next i
exit sub
end if

end sub

'//================================================================
sub frmTest_ReadQ
dim fileext as string
dim i as integer
dim reslt as integer
nach:
if curQ>(qh_kolQ-1) then
  reslt=true
  for i=0 to qh_kolQ-1
     if q_text(i)<>"" then reslt=reslt and false
  next i
  if reslt then
    'вопросы кончились
    'выключение, обнуление, сброс всего лишнего
    pic.visible=false
    toEnd.Enabled=false
    frmTest.visible = false
    frmStat.Show
    exit sub
    else
    'есть еще вопросы
    curQ=0
    end if
    'Все вопросы пройдены. Возвращаемся к пропущенным вопросам.
  end if
'//ответ на вопрос дан, значит пропускаем его...
if q_text(curQ)="" then
  inc(curQ)
  goto nach
  end if
lcurQ.Caption="Вопрос: "+str$(curQ+1)+" из "+str$(qh_kolQ)
Query.Text=q_text(curQ)
fileext=""
'if q_resF(curQ)<>"" then pic.bmp = qh_resD+q_resF(curQ)

if q_tipQ(curQ)="select" then
  call frmTest_selectQ
  exit sub
  end if

if q_tipQ(curQ)="order" then
  call frmTest_orderQ
  exit sub
  end if

if q_tipQ(curQ)="input" then
  call frmTest_inputQ
  exit sub
  end if

if q_tipQ(curQ)="" then
  call frmTest_psiho
  exit sub
  end if

end sub

'//================================================================
sub frmTest_nextQClick
dim i as integer
pic.visible = false
Query.Text=""
call frmTest_freeEl

inc(curQ)

call frmTest_readQ

end sub

'//================================================================
sub frmTest_inputQ

inbox.text=""
inbox.visible=true

end sub

'//===============================================================
sub frmTest_orderQ
dim d as integer, ic as integer
dim vibr as string
dim kolEl as integer
dim i as integer
'перемещать варианты прямо по списку
  kolEl=q_count(curQ)
  redim varC2(kolEl) as qlabel
  for i=0 to kolEl-1
  vibr=vibr+Right$("0"+Str$(i),2)
  next i  
  Randomize
  redim varC1(1 to 2,kolEl) as integer
  for i=0 to kolEl-1
    d=rnd(Len(vibr)\2)
    ic=val(Mid$(vibr,d*2+1,2))
    vibr=delete$(vibr,d*2+1,2)
    varC1(1,ic)=i 'вход-координата,выход-номер
    varC1(2,i)=ic 'вход-номер,выход-координата
    varC2(i).Top=ic*40+20
    varC2(i).Left=70
    varC2(i).Caption=q_variants(curQ).item(i)
    varC2(i).AutoSize=false
    varC2(i).Width=pVariants.Width-90
    varC2(i).Tag=i 'индекс элем. = его номер по порядку
    varC2(i).color=clCream
    varC2(i).WordWrap=true
  next i
  for i=0 to kolEl-1
'    varC2(i).OnClick=frmTest_sort
    varC2(i).OnMouseDown=frmTest_sort
    varC2(i).visible=true
    varC2(i).Parent=pVariants
  next i

end sub

'//================================================================
sub frmTest_sort(Button as integer,X as integer,Y as integer,Shift as integer,Sender as QLabel)
dim kolEl as integer
dim is as integer, ics as integer
dim id as integer, icd as integer
kolEl=q_count(curQ)
is=sender.tag
ics=varC1(2,is)
select case Button
case 0
if ics>0 then
 icd=ics-1
 id=varC1(1,icd)
 swap varC1(1,ics),varC1(1,icd)
 swap varC1(2,is),varC1(2,id)
 swap varC2(is).top,varC2(id).top
end if
case 1
if ics<kolEl-1 then
 icd=ics+1
 id=varC1(1,icd)
 swap varC1(1,ics),varC1(1,icd)
 swap varC1(2,is),varC1(2,id)
 swap varC2(is).top,varC2(id).top
end if
end select

end sub

'//================================================================
sub frmTest_selectQ
dim d as integer, ic as integer
dim vibr as string
dim kolV as integer
dim kolVV as integer
dim i as integer
kolV=q_count(curQ)
kolVV=q_countV(curQ)
redim varC(kolV-1) as qcheckbox
for i=1 to kolV
vibr=vibr+Right$("0"+Str$(i),2)
next i
Randomize
for i=0 to kolV-1
  d=rnd(Len(vibr)\2)
  'showmessage(inttostr(d)+'/'+inttostr(length(vibr)div 2)+' - '+vibr);
  ic=val(Mid$(vibr,d*2+1,2))
  vibr=delete$(vibr,d*2+1,2)
  varC(i).Top=ic*40-20
  varC(i).Left=20
  varC(i).Caption=q_variants(curQ).item(i)
  varC(i).Width=pVariants.Width-40
  if i<kolVV then
    varC(i).Tag=1
    else
    varC(i).Tag=0
    end if
  next i  
for i=0 to kolV-1
varC(i).taborder=i
varC(i).checked=false
varC(i).Parent=pVariants
varC(i).visible=true
next i

end sub

'//================================================================
sub frmTest_okeyClick
dim i as integer, j as integer
dim rs as integer

rs=true
if q_tipQ(curQ)="" then
  for i=0 to q_count(curQ)-1
    rs=rs and not(varCP(i).Checked)
  next i
  if rs then
  showmessage("Ничего не выбрано!")
  exit sub
  end if
end if

call frmTest_freeEl

pic.visible=false
Query.Text=""

if q_tipQ(curQ)="select" then
  for i=0 to q_count(curQ)-1
  if varC(i).checked<>varC(i).Tag then q_ball(curQ)=0
  next i
  balls=balls+q_ball(curQ)
end if

if q_tipQ(curQ)="order" then
  for i=0 to q_count(curQ)-1
  if varC1(2,i)<>varC2(i).tag then q_ball(curQ)=0
  next i
  balls=balls+q_ball(curQ)
end if

if q_tipQ(curQ)="input" then
  for j=0 to q_variants(curQ).ItemCount-1
  if lcase$(inbox.Text)=lcase$(q_variants(curQ).item(j)) then balls=balls+q_ball(curQ)
  next j
end if

if q_tipQ(curQ)="" then
  for i=0 to q_count(curQ)-1
    if varCP(i).Checked then
    balls=balls+varCP(i).Tag
    exit for
    end if
  next i
end if

q_text(curQ)="" 'помечаем вопрос как отвеченный
'//Qok:=Qok+1;//дано ответов
'showmessage str$(balls)

inc(curQ)

call frmTest_readQ

end sub

'//================================================================
sub frmTest_psiho
dim kolV as integer
dim i as integer
kolV=q_count(curQ)
redim varCP(kolV-1) as qradiobutton
for i=0 to kolV-1
  varCP(i).Top=i*40+20
  varCP(i).Left=20
  varCP(i).Caption=q_variants(curQ).item(i*2)
  varCP(i).Width=pVariants.Width-40
'  varCP(i).Color=clCream
  varCP(i).Checked=false
  varCP(i).Tag=val(q_variants(curQ).item(i*2+1))
next i
for i=0 to kolV-1
  varCP(i).Visible=true
  varCP(i).Parent=pVariants
  next i
end sub

'//================================================================
sub frmTest_ReadAllQ
dim tstFile as qfilestream
dim s as string
dim i as integer, j as integer
'пропуск первых строк файла теста (они уже считаны):
if tstfile.open(files.filename,fmopenread)=false then showmessage "Файл не открыт!"
for i=1 to 7
s=tstfile.Readline 'пропуск заголовка
next i
for i=0 to qh_kolQ-1
  s=tstfile.readline
  q_text(i)=s 'текст вопроса
  s=tstfile.readline
  q_resF(i)=s 'файл графики
  s=tstfile.readline
  q_tipQ(i)=s 'тип вопроса
  if s="select" then
    s=tstfile.readline
    q_count(i)=val(s)
    s=tstfile.readline
    q_countV(i)=val(s)
  elseif s="" then
    s=tstfile.readline
    q_count(i)=val(s)
    q_countV(i)=0
  else
    s=tstfile.readline
    q_count(i)=val(s)
    q_countV(i)=0
  end if
  j=0
  q_variants(i).clear
  while j<q_count(i)
  s=tstfile.readline
  q_variants(i).additems(s)
  if q_tipQ(i)="" then
    s=tstfile.readline
    q_variants(i).additems(s) 'балл за вариант ответа (психотест)
    q_ball(i)=0
    end if
  j=j+1
  wend
  if q_tipQ(i)<>"" then
    s=tstfile.readline
    q_ball(i)=val(s) 'балл за правильный ответ
    end if
next i
s=tstfile.readline
qh_statballs=val(s)
qh_balls.clear
while (tstFile.position<tstFile.size)
  s=tstfile.readline
  qh_balls.AddItems(s)
wend
tstfile.close

end sub

' frmStat #############################################################################################

'//================================================================
sub frmStat_FormHide 
frmStart.Show
end sub

'//================================================================
sub frmStat_FormShow
dim i as integer, j as integer
showmessage("Тестирование окончено."+chr$(13)+"Всего баллов: "+str$(balls)+chr$(13)+ _
                "из "+str$(qh_kolQ)+" вопросов.")
vivod.visible = false
stKolQ.Caption=str$(qh_kolQ)
'stQok.Caption=str$(Qok)
stBalls.Caption=str$(balls)
j=0
for i=0 to (qh_balls.ItemCount-1)\2
  vivod.Text=qh_balls.item(i*2)
  if i=(qh_balls.ItemCount-1)\2 then
    vivod.visible=true
    exit sub
    end if

  'верхняя граница включительно
  if balls<=val(qh_balls.item(i*2+1)) then
    vivod.visible=true
    exit sub
    end if
  next i

end sub

'//================================================================
sub frmStat_stReturnClick '(Sender: TObject);
frmStat.Close
'frmStat.Hide
'frmStart.Show
end sub

'//================================================================
sub frmStat_stExitClick '(Sender: TObject);
frmStart.Close
end sub

' frmHelp #############################################################################################

'//================================================================
sub frmHelp_ChangeTab
select case pages.TabIndex
    case 0
    pgInfo.Visible = false
    pgHelp.Visible = true
    case 1
    pgHelp.Visible = false
    pgInfo.Visible = true
end select
end sub

'//================================================================
sub frmHelp_FormClose(sender as qform, Action as integer)
frmStart.Enabled=true
'image2.Visible=false
end sub

'//================================================================
sub frmHelp_emailClick '(Sender: TObject)
shellexecute(0,"","mailto:shurik83@mail.ru","","",0)
end sub

'//================================================================
sub frmHelp_siteClick '(Sender: TObject)
shellexecute(0,"","http://www.shurik83.narod.ru","","",0)
end sub
