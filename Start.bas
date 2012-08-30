declare sub frmStart_filesClick '(Sender: TObject)
declare sub frmStart_startClick '(Sender: TObject)
declare sub frmStart_btnExitClick '(Sender: TObject)
declare sub frmStart_FormClose '(Sender: TObject; var CanClose: Boolean)
declare sub frmStart_FormShow '(Sender: TObject)
declare sub frmStart_btnInfoClick '(Sender: TObject);
declare sub frmStart_FormPaint '(Sender: TObject);
declare sub frmStart_ReadHead

create frmStart as qform
  Left = 233
  Top = 157
  AddBorderIcons(biSystemMenu, biMinimize)
'  HideTitleBar = true
  BorderStyle = bsSingle
  Caption = "Cercando il vero"
  ClientHeight = 453
  ClientWidth = 632
  Color = clSkyBlue
  Center
  OnClose = frmStart_FormClose
  OnPaint = frmStart_FormPaint
  OnShow = frmStart_FormShow
  create Image2 as qimage
    Left = 82
    Top = 0
    Width = 468
    Height = 60
    AutoSize = True
  end create
  create Image3 as qimage
    Left = 0
    Top = 0
    Width = 64
    Height = 64
    AutoSize = True
  end create
  create GrpInfo as QGroupBox
    Left = 8
    Top = 64
    Width = 617
    Height = 381
    Caption = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1086' '#1090#1077#1089#1090#1077':'
    TabOrder = 0
    create Label2 as QLabel
      Left = 16
      Top = 24
      Width = 169
      Height = 33
      AutoSize = False
      Caption = #1057#1087#1080#1089#1086#1082' '#1090#1077#1089#1090#1086#1074':'
      Color = clPurple
      Transparent = False
    end create
    create Label4 as QLabel
      Left = 200
      Top = 267
      Width = 265
      Height = 30
      AutoSize = False
      Caption = #1042#1088#1077#1084#1103' '#1085#1072' '#1090#1077#1089#1090':'
      Color = clPurple
    end create
    create Label5 as QLabel
      Left = 200
      Top = 299
      Width = 265
      Height = 30
      AutoSize = False
      Caption = #1042#1086#1087#1088#1086#1089#1086#1074' '#1074' '#1090#1077#1089#1090#1077':'
      Color = clPurple
    end create
    create Image1 as QImage
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
      Color = clWhite
      ExtendedSelect = False
      AddFileTypes(ftReadOnly, ftNormal)
      ItemHeight = 16
      Mask = '*.tst'
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
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1090#1077#1089#1090#1072':'
      end create
      create Label3 as QLabel
        Left = 8
        Top = 72
        Width = 160
        Height = 16
        Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081' '#1082' '#1090#1077#1089#1090#1091':'
      end create
      create tstName as QRichEdit
        Left = 8
        Top = 24
        Width = 385
        Height = 49
        Color = clCream
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 0
      end create
      create tstComment as QRichEdit
        Left = 8
        Top = 88
        Width = 385
        Height = 145
        Color = clCream
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
      Color = clGray
      TabOrder = 2
      create start as QButton
        Left = 8
        Top = 8
        Width = 187
        Height = 25
        Caption = #1053#1072#1095#1072#1090#1100' '#1090#1077#1089#1090#1080#1088#1086#1074#1072#1085#1080#1077
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
        Caption = #1042#1099#1093#1086#1076
        TabOrder = 1
        OnClick = frmStart_btnExitClick
      end create
      create btnInfo as QButton
        Left = 392
        Top = 8
        Width = 105
        Height = 25
        Caption = #1057#1087#1088#1072#1074#1082#1072
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
'      Lines.Strings = ('***')
      ReadOnly = True
      TabOrder = 4
    end create
    create Learn as QCheckBox
      Left = 16
      Top = 280
      Width = 169
      Height = 33
      Caption = #1056#1077#1078#1080#1084' '#1086#1073#1091#1095#1077#1085#1080#1103
'      Color = clSkyBlue
      TabOrder = 5
    end create
  end create
  end create

type TQH 'общ. инф-ия о тесте
    Name as string*255 'название
    Comment as string*255 'описание
    resD as string*255 'папка с ресурсами
    timer as string*255 'время на тест
    kolQ as integer 'кол-во вопросов
    propusk as integer 'наличие кнопки "пропустить"
    learn as integer 'доступность режима обучения
    statballs as integer 'вывод расчетной статистики
'    balls as QStringList 'пределы + комментарии
end type

dim qh as TQH
dim TTh as integer 'время
dim TTm as integer 'на
dim TTs as integer 'тест
dim mmdir as string 'имя папки с картинками
dim filedir as string 'имя папки с программой

'//================================================================
sub frmStart_FormCreate '(Sender: TObject)
filedir=ExtractFileDir(application.ExeName)
if DirectoryExists(filedir+"\tests") then
    files.Directory=filedir+"\tests" 
    else
    showmessage("Не найден каталог с тестами - 'tests'")
end if
end sub

'//================================================================
sub frmStart_filesClick '(Sender: TObject);
call frmStart_ReadHead 'чтение инф-ии о тесте
end sub

'//================================================================
sub frmStart_startClick '(Sender: TObject);
if (files.FileName="") then
  showmessage "Тест не выбран!"
  exit sub
end if
frmStart.Visible = false
frmTest.show
end sub

'//================================================================
sub frmStart_btnExitClick '(Sender: TObject);
frmstart.Close
end sub

'//================================================================
sub frmStart_FormClose(Sender as qform, action as integer)
frmHelp.Close
if messagedlg("Выйти из программы?",mtConfirmation, _
    mbYes+mbNo)=mrNo then action=false
end sub

'//================================================================
sub frmstart_ReadHead 'чтение начальной инф-ии о тесте
dim tstFile as qfilestream
dim s as string

if files.FileName="" then exit
tstfile.open(files.FileName,fmOpenRead)
s=tstfile.Readline 'название
tstName.Text=s
qh.Name=s
s=tstfile.Readline 'комментарий
tstComment.text=s
qh.Comment=s
s=tstfile.Readline 'имя папки с картинками
if s<>"" then s=s+"\"
qh.resD=filedir+"\tests\"+s
s=tstfile.Readline 'время на тест
tstTime.Text=s
qh.timer=s
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
frmTest.nextQ.Visible=s
qh.propusk=s
s=tsfile.Readln 'доступность режима обучения
Learn.Visible=s
qh.learn=s
s=tstfile.Readln 'количество вопросов в тесте
KolQ.Text=s
qh.kolQ=val(s)
tstfile.close
if learn.Visible=false then learn.Checked=false
end sub

'//================================================================
sub frmStart_FormShow '(Sender: TObject)
ReadHead()
end sub

'//================================================================
sub frmStart_btnInfoClick '(Sender: TObject)
frmStart.Enabled=false
frmHelp.Show
end sub

//================================================================
sub frmStart_FormPaint '(Sender: TObject)
dim i as integer

for i=0 to 9
  frmStart.Canvas.Draw(i*64,0,image3.Picture.Graphic);
  frmStart.Canvas.Draw(i*64,64,image3.Picture.Graphic);
  frmStart.Canvas.Draw(i*64,416,image3.Picture.Graphic);
  frmStart.Canvas.Draw(0,i*64,image3.Picture.Graphic);
  frmStart.Canvas.Draw(576,i*64,image3.Picture.Graphic);
next i

end sub
