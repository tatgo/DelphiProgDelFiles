unit OpenDir;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, FileCtrl;

type
  TForm2 = class(TForm)
    DirListBox: TDirectoryListBox;
    Panel1: TPanel;
    DrComboBox: TDriveComboBox;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.DFM}
uses DeleteFiles;

procedure TForm2.Button1Click(Sender: TObject);
begin
 Form1.DirEdit.Text := DirListBox.Directory;
 Close;
end;

procedure TForm2.FormActivate(Sender: TObject);
 var drive_ : char;
     root_  : string;
begin
 if Form1.line_root <> '' then
    begin
     root_ := Form1.line_root;
     drive_ := root_[1];
     DrComboBox.Drive := drive_;
     DirListBox.Directory := root_;
    end 
end;

end.
