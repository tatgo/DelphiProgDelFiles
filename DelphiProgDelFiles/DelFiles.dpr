program DelFiles;

uses
  Forms,
  DeleteFiles in 'DeleteFiles.pas' {Form1},
  OpenDir in 'OpenDir.pas' {Form2};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
