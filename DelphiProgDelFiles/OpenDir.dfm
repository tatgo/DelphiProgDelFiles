object Form2: TForm2
  Left = 870
  Top = 174
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'List Folders'
  ClientHeight = 275
  ClientWidth = 314
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Arial'
  Font.Style = [fsBold]
  OldCreateOrder = False
  Position = poDesktopCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 16
  object DirListBox: TDirectoryListBox
    Left = 0
    Top = 0
    Width = 314
    Height = 225
    Align = alTop
    ItemHeight = 16
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 225
    Width = 314
    Height = 50
    Align = alBottom
    Caption = ' '
    TabOrder = 1
    object DrComboBox: TDriveComboBox
      Left = 20
      Top = 14
      Width = 145
      Height = 22
      DirList = DirListBox
      TabOrder = 0
    end
    object Button1: TButton
      Left = 210
      Top = 14
      Width = 75
      Height = 25
      Caption = 'Choice'
      TabOrder = 1
      OnClick = Button1Click
    end
  end
end
