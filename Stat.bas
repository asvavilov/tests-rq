declare sub frmStat_FormHide '(Sender: TObject);
declare sub frmStat_FormShow '(Sender: TObject);
declare sub frmStat_stReturnClick '(Sender: TObject);
declare sub frmStat_stExitClick '(Sender: TObject);

create frmStat as qform
  Left = 192
  Top = 108
  AddBorderIcons biSystemMenu
  BorderStyle = bsSingle
  Caption = #1057#1090#1072#1090#1080#1089#1090#1080#1082#1072
  ClientHeight = 275
  ClientWidth = 488
  Color = clSkyBlue
  Center
'  OnHide = frmStat_FormHide
  OnClose = frmStat_FormHide
  OnShow = frmStat_FormShow
  create Image1 as qimage
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
    Caption = #1042#1086#1087#1088#1086#1089#1086#1074' '#1074' '#1090#1077#1089#1090#1077':'
    Transparent = True
  end create
  create RxLabel2 as qlabel
    Left = 280
    Top = 48
    Width = 152
    Height = 18
    Caption = #1053#1072#1073#1088#1072#1085#1086' '#1073#1072#1083#1083#1086#1074':'
    Transparent = True
    end create
  create stKolQ as qlabel
    Left = 456
    Top = 16
    Width = 12
    Height = 18
    Caption = '0'
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
    Color = 10930928
    ReadOnly = True
    TabOrder = 0
  end create
  create stReturn as qbutton
    Left = 8
    Top = 8
    Width = 121
    Height = 33
    Caption = #1042' '#1085#1072#1095#1072#1083#1086
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
    Caption = #1042#1099#1093#1086#1076
    TabOrder = 2
    OnClick = frmStat_stExitClick
  end create
end create


'//================================================================
sub frmStat_FormHide '(Sender: TObject);
frmStart.Show
end sub

'//================================================================
sub frmStat_FormShow '(Sender: TObject);
dim i as integer, j as integer
messagedlg("Тестирование окончено."+chr$(13)+"Всего баллов: "+str$(balls)+chr$(13)+ _
                "из "+str$(qh.kolQ)+" вопросов.")
vivod.visible = false
stKolQ.Caption=str$(qh.kolQ)
'stQok.Caption=str$(Qok)
stBalls.Caption=str$(balls)
j=0
for i=0 to (qh.balls.Count-1)\2
  vivod.Text=qh.balls.Strings[i*2]
  if i=(qh.balls.Count-1)\2 then
    vivod.Show
    exit sub
    end if

  //верхняя граница включительно
  if balls<=val(qh.balls.Strings[i*2+1]) then
    vivod.Show
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
