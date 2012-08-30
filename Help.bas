declare sub frmHelp_FormClose(sender as qform, Action as integer)
declare sub frmHelp_emailClick '(Sender: TObject)
declare sub frmHelp_siteClick '(Sender: TObject)
declare sub frmHelp_Image1DblClick '(Sender: TObject)
declare sub frmHelp_ChangeTab

create frmHelp as qform
  Left = 199
  Top = 111
  BorderStyle = bsToolWindow
  Caption = #1057#1087#1088#1072#1074#1082#1072
  Color = clBlack
  FormStyle = fsStayOnTop
  Center
  OnClose = frmHelp_FormClose
  create pages as qtabcontrol
    Left = 0
    Top = 0
    Width = 392
    Height = 373
'    ActivePage = pgInfo
    Align = alClient
    FlatButtons = true
    FlatSeperators = true
    FocusButtons = true
    TabOrder = 0
    OnChange = frmHelp_ChangeTab
    create pgHelp as qpanel
      Caption = #1057#1087#1088#1072#1074#1082#1072
      Visible = false
    end create
    create pgInfo as qpanel
      Caption = #1054' '#1087#1088#1086#1075#1088#1072#1084#1084#1077
      create email as qbutton
        Left = 0
        Top = 40
        Width = 193
        Height = 17
        Caption = "shurik83@mail.ru"
        OnClick = frmHelp_emailClick
      end create
      create site as qbutton
        Left = 0
        Top = 72
        Width = 193
        Height = 17
        Caption = "www.shurik83.narod.ru"
        OnClick = frmHelp_siteClick
      end create
      create Image1 as qimage
        Left = 104
        Top = 144
        Width = 300
        Height = 200
        AutoSize = True
        OnDblClick = frmHelp_Image1DblClick
      end create
      create Image2 as qimage
        Left = 216
        Top = 208
        Width = 80
        Height = 80
        AutoSize = True
        Visible = False
      end create
      create StaticText1 as qedit
        Left = 0
        Top = 8
        Width = 196
        Height = 20
        ReadOnly = true
        Text = '#1040#1074#1090#1086#1088': '#1042#1072#1074#1080#1083#1086#1074' '#1040#1083#1077#1082#1089#1072#1085#1076#1088
        TabOrder = 0
      end create
      create StaticText2 as qedit
        Left = 0
        Top = 104
        Width = 276
        Height = 20
        ReadOnly = true
        Text = #1042#1077#1088#1089#1080#1103' '#1087#1088#1086#1075#1088#1072#1084#1084#1099': 1.0 ('#1074#1077#1089#1085#1072' 2004)'
        TabOrder = 1
      end create
    end create
  end create
end create


'//================================================================
sub frmHelp_ChangeTab
select case pages
    case 0
    pgInfo.Visible = false
    pgHelp.Visible = true
    image2.Visible=false
    case 1
    pgHelp.Visible = false
    pgInfo.Visible = true
end select
end sub

'//================================================================
sub frmHelp_FormClose(sender as qform, Action as integer)
frmStart.Visible = false
frmStart.Show
frmStart.Enabled:=true
image2.Visible=false
end sub

'//================================================================
sub frmHelp_emailClick '(Sender: TObject)
shellexecute(0,nil,"mailto:shurik83@mail.ru",nil,nil,0)
'shell (см. справку)
end sub

'//================================================================
sub frmHelp_siteClick '(Sender: TObject)
shellexecute(0,nil,"http://www.shurik83.narod.ru",nil,nil,0)
'shell (см. справку)
end sub

'//================================================================
sub frmHelp_Image1DblClick '(Sender: TObject)
image2.Visible=true
end sub
