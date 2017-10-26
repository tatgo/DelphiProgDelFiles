unit DeleteFiles;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, FileCtrl, OpenDir;

const types_ = '   *.txt, *.dfm  ';
      dir_   = '*.';
      ini_file_name = 'options.ini';

type
  TForm1 = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    LType : TLabel;
    TypeEdit : TEdit;
    LDir  : TLabel;
    BrButton: TButton;
    startButton : TButton;
    exitButton : TButton;
    procedure On_Click(Sender:TObject);
    procedure On_Start(Sender:TObject);
    procedure On_Close(Sender:TObject);
  public
    { Public declarations }
    DirEdit   : TEdit;
    line_root : string;
  end;

var
  Form1        : TForm1;
  CurentDir    : string;
  //LastFolder   : string;
  ListTypes    : TStrings;
  ListFolders  : TStrings;
  FinishedMess : TStrings;

implementation

{$R *.DFM}

function DeleteSpace(s : string):string;
begin
 Result := StringReplace(s, ' ', '', [rfReplaceAll]);      
end;

function Split(s : string; ch : char):TStrings;
 var List: TStrings;
begin
 List := TStringList.Create;
  try
    ExtractStrings([ch], [], PChar(s), List);
    Result := List;
  finally
    //List.Free;
  end;
end;

procedure ListSubFolders(folder_i : string);
 var searchResult : TSearchRec;
begin
 if FindFirst(folder_i + '\' + dir_, faAnyFile, searchResult) = 0 then
    begin
     repeat
      if (searchResult.Name <> '.') and (searchResult.Name <> '..') then
                       ListFolders.Add(folder_i+'\'+searchResult.Name);
     until FindNext(searchResult) <> 0;

     FindClose(searchResult);
    end
end;

procedure Change_Dir(folder_name : string);
begin
 ChDir('\');
 Delete(folder_name,1,2);
 ChDir(folder_name);
end;

procedure ListDelFiles(folder_x : string);
 var i            : integer;
     searchResult : TSearchRec;
begin
 For i:=0 to ListTypes.Count - 1 do
          begin
           Change_Dir(folder_x);
           if FindFirst(folder_x + '\' + ListTypes.Strings[i], faAnyFile, searchResult) = 0 then
                  begin
                   repeat
                    FinishedMess.Add(folder_x + '\' + searchResult.Name);
                    DeleteFile(searchResult.Name);
                   until FindNext(searchResult) <> 0;
                  end
          end
end;

procedure Delete_From_AllFolders();
begin
 ListSubFolders(ListFolders.Strings[0]);
 ListDelFiles(ListFolders.Strings[0]);
 ListFolders.Delete(0);
 if ListFolders.Count > 0 then Delete_From_AllFolders;
end;

procedure TForm1.On_Click(Sender:TObject);
begin
 Form2.DrComboBox.Drive := CurentDir[1];
 Form2.Show;
end;

procedure TForm1.On_Start(Sender:TObject);
 var rec        : tsearchrec;
     all_types  : string;
     i          : integer;
     buttonSel  : Integer;
begin
 if (DirEdit.Text <> '') and (TypeEdit.Text <> '') then
    begin
     ListTypes := TStringList.Create;
     all_types := '';

     all_types := DeleteSpace (TypeEdit.Text);
     if Pos(',',all_types) > 0 then ListTypes := Split(all_types,',')
       else ListTypes.Add(all_types);

     //LastFolder := DirEdit.Text;
     ListFolders.Add(DirEdit.Text);
     FinishedMess := TStringList.Create;
     FinishedMess.Add('Deleted files are :');
     Delete_From_AllFolders;
     FinishedMess.Add('The process is over !');
     buttonSel := messagedlg(FinishedMess.Text,mtInformation, mbOKCancel, 0);
     if (buttonSel = mrOK) or (buttonSel = mrCancel) then FinishedMess.Free;
    end
   else ShowMessage('Enter correct data for types or root directory');
end;

procedure TForm1.On_Close(Sender:TObject);
 var INIFile : TextFile;
begin
 Change_Dir(CurentDir);
 AssignFile(INIFile,CurentDir+'\'+ini_file_name);
 Rewrite(INIFile);
 Writeln(INIFile,'[last_types]');
 Writeln(INIFile,TypeEdit.Text);
 Writeln(INIFile,'[last_root]');
 Writeln(INIFile,DirEdit.Text);
 CloseFile(INIFile);
 Close;
end;

procedure Read_iniFile(var t,r : string);
 var INIFile        : TextFile;
     Line_from_file : string;
     i              : byte;
begin
 If FileExists(CurentDir+'\'+ini_file_name) then
        begin
         AssignFile(INIFile,CurentDir+'\'+ini_file_name);
         Reset(INIFile);
         i:=0;
         while not Eof(INIFile) do
                begin
                 Inc(i);
                 ReadLn(INIFile,Line_from_file);
                 if i = 2 then t := Line_from_file
                   else
                 if i = 4 then r := Line_from_file;  
                end;
         CloseFile(INIFile);
        end
end;

procedure TForm1.FormCreate(Sender: TObject);
 var line_types : string;
begin
 GetDir(0,CurentDir);
 ListFolders := TStringList.Create;
 //LastFolder := '';
 line_types := '';
 line_root := '';

 Read_iniFile(line_types,line_root);

 LType := TLabel.Create(self);
 LType.Parent := self;
 LType.Left := 30;
 LType.Top := 30;
 LType.Caption := 'Type of files :';

 TypeEdit := TEdit.Create(self);
 TypeEdit.Parent := self;
 TypeEdit.Top := LType.Top;
 TypeEdit.Left := LType.Left + LType.Width + 30;
 TypeEdit.Width := 300;
 TypeEdit.Hint := ' - format for types : "*. + extension"'+#13+' - separator for more than one type : ","';
 TypeEdit.ShowHint := true;
 if line_types <> '' then TypeEdit.Text := line_types
   else TypeEdit.Text := types_;

 LDir := TLabel.Create(self);
 LDir.Parent := self;
 LDir.Left := LType.Left;
 LDir.Top := LType.Top + LType.Height + 30;
 LDir.Caption := 'Root directory :';

 DirEdit := TEdit.Create(self);
 DirEdit.Parent := self;
 DirEdit.Top := LDir.Top;
 DirEdit.Left := TypeEdit.Left;
 DirEdit.Width := 300;
 if line_root <> '' then DirEdit.Text := line_root
   else DirEdit.Text := '';

 BrButton := TButton.Create(self);
 BrButton.Parent := self;
 BrButton.Top := DirEdit.Top + 2;
 BrButton.Width := 20;
 BrButton.Left := DirEdit.Left + DirEdit.Width - (BrButton.Width +2);
 BrButton.Height := 20;
 BrButton.Caption := '...';
 BrButton.OnClick := On_Click;

 startButton := TButton.Create(self);
 startButton.Parent := self;
 startButton.Top := DirEdit.Top + 70;
 startButton.Left := DirEdit.Left;
 startButton.Width := 80;
 startButton.Caption := 'Start';
 startButton.OnClick := On_Start;

 exitButton := TButton.Create(self);
 exitButton.Parent := self;
 exitButton.Top := DirEdit.Top + 70;
 exitButton.Width := 80;
 exitButton.Left := DirEdit.Left  + DirEdit.Width - exitButton.Width;
 exitButton.Caption := 'Exit';
 exitButton.OnClick := On_Close;

 Form1.Width := 500;
 Form1.Height := 230;
 Form1.Caption := 'Delete files';

end;

end.
