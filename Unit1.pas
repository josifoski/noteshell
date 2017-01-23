unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  StdCtrls, ExtCtrls, LCLType, Menus, Unit2, LCLProc, LazUTF8, SynEdit;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    CheckBox1: TCheckBox;
    CheckBox3: TCheckBox;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    MenuItem1: TMenuItem;
    Panel1: TPanel;
    PopupMenu1: TPopupMenu;
    Splitter1: TSplitter;
    noteshell_TrayIcon1: TTrayIcon;
    SynEdit1: TSynEdit;
    TreeView1: TTreeView;
    procedure Button1Click(Sender: TObject);
    procedure Button1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure Button2Click(Sender: TObject);
    procedure Button2KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure Button3Click(Sender: TObject);
    procedure Button3KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure Button4Click(Sender: TObject);
    procedure Button4KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure Button5Click(Sender: TObject);
    procedure CheckBox1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure CheckBox3Change(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox1Click(Sender: TObject);
    procedure ComboBox1CloseUp(Sender: TObject);
    procedure ComboBox1DropDown(Sender: TObject);
    procedure ComboBox1EditingDone(Sender: TObject);
    procedure ComboBox1Enter(Sender: TObject);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FindDialog1Find(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure noteshell_TrayIcon1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PopupMenu1Close(Sender: TObject);
    procedure SynEdit1Change(Sender: TObject);
    procedure SynEdit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure TreeView1Changing(Sender: TObject; Node: TTreeNode;
      var AllowChange: Boolean);
    procedure TreeView1DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure TreeView1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure TreeView1EditingEnd(Sender: TObject; Node: TTreeNode;
      Cancel: Boolean);
    procedure TreeView1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TreeView1SelectionChanged(Sender: TObject);
    procedure RefreshCombo1(Sender: TObject);

  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  Form1 : TForm1;
  f , ftree, wf , fi, fo: Text;
  PreserveName , minintray, FPath, sf, st, filteron: String;
  CudnoNoMoze , SynEditPromena, ShowLineNumbers: Boolean;
  TargetPlatform : Char;
  nFontSize, Combo1II, p, gp, nprev, pamtisplit1: Integer;
  pamtibgboja, pamtifnboja : longint;


implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.RefreshCombo1(Sender: TObject);
var i, pozicija: Integer;
    s: String;
begin
  s := TreeView1.Selected.text;
  ComboBox1.Clear;
  for i:=0 to TreeView1.Items.Count-1 do begin
   ComboBox1.Items.AddText(trim(TreeView1.Items.Item[i].Text));
   if s = TreeView1.Items.Item[i].Text then pozicija:= i;
  end;
  ComboBox1.ItemIndex:=  pozicija;
end;

procedure TForm1.FormCreate(Sender: TObject);
var state, linija , F1Width, F1Height, S1L, spozicija: String;
    i : integer;
begin
  {$IFDEF LCLcarbon} TargetPlatform:='m'; {$ENDIF}
  {$IFDEF UNIX} TargetPlatform:='l'; {$ENDIF}
  {$IFDEF Linux} TargetPlatform:='l'; {$ENDIF}
  {$IFDEF WINDOWS} TargetPlatform:='w'; {$ENDIF}

  // ShowMessage(TargetPlatform);
  SynEdit1.RightGutter.Visible:= False;
  SynEdit1.RightEdge:= 10000;
  ShowLineNumbers:= False;
  SynEdit1.Gutter.Visible:=False;
  TreeView1.HideSelection:=False;
  SynEditPromena:=False;
  AssignFile(fi, 'noteshell_settings.txt');
  if FileExists('noteshell_settings.txt') then begin
                                        reset(fi);
                                        readln(fi, minintray);
                                        readln(fi, FPath);
                                        readln(fi, F1Width);
                                        readln(fi, F1Height);
                                        readln(fi, S1L);
                                        pamtisplit1:= StrToInt(S1L);
                                        readln(fi, spozicija);
                                        readln(fi, linija);
                                        nFontSize:=StrToInt(linija);
                                        readln(fi, linija);
                                        Combo1II:=StrToInt(linija);
                                        CloseFile(fi);
                                 end
                                 else begin
                                        minintray:='normal';
                                        FPath:='noteshell_files/';
                                        F1Width:='500';
                                        F1Height:='300';
                                        S1L:='150';
                                        pamtisplit1:= 150;
                                        spozicija:='0';
                                        nFontSize:=11;
                                        Combo1II:=2;
                                      end;

  if not(DirectoryExists(FPath)) then CreateDir(Fpath);

  AssignFile(f, FPath + '000noteshelltreestate.txt');
  AssignFile(ftree, FPath + '000noteshelltree.txt');
  if FileExists(FPath + '000noteshelltree.txt') and FileExists(FPath+'000noteshelltreestate.txt') then begin
  TreeView1.LoadFromFile(FPath + '000noteshelltree.txt');
  reset(ftree);
  while not(eof(ftree)) do begin
    readln(ftree, linija);
    linija:= trim(linija);
    ComboBox1.Items.AddText(linija);
  end;
  if TreeView1.Items.Count  > StrToInt(spozicija) then begin
     ComboBox1.ItemIndex:= StrToInt(spozicija);
     nprev:= StrToInt(spozicija);
  end
  else begin
   ComboBox1.ItemIndex:= 0;
   nprev:= 0;
   spozicija:= '0';
  end;
  CloseFile(ftree);
  reset(f);
  for i:=0 to TreeView1.Items.Count-1 do begin
   readln(f, state);
   if state='T' then TreeView1.Items.Item[i].Expanded:=True
  end;
  CloseFile(f);
  end // if FileExists
  else
  begin
   TreeView1.SaveToFile(FPath+'000noteshelltree.txt');
   rewrite(f);
   writeln(f, 'T');
   closeFile(f);
   spozicija:= '0';
  end;
  CudnoNoMoze:=True;
  TreeView1.Items.Item[StrToInt(spozicija)].Selected:=True;
  Form1.TreeView1.OnSelectionChanged(TreeView1);
  Randomize;

  noteshell_TrayIcon1.Icon.LoadFromFile('noteshell.ico');
  noteshell_TrayIcon1.Show;
  if minintray='minimizedintray' then begin
      form1.WindowState := wsNormal;
      form1.Hide;
      Form1.ShowInTaskBar := stNever;
    end // if minintray
    else begin
              Form1.Show;
              minintray:='normal';
     end;
    Form1.Width:=StrToInt(F1Width);
    Form1.Height:=StrToInt(F1Height);
    Splitter1.Left:=StrToInt(S1L);
    SynEdit1.Font.Size:=nFontSize;
end;

procedure TForm1.FormResize(Sender: TObject);
begin
  Button3.Left:=Form1.Width-91;
  Button2.Left:=Form1.Width-153;
  Button5.Left:=Form1.Width-255;
  Edit1.Left:=Form1.Width-417;

  Panel1.Width:=Form1.Width-18;
  Panel1.Height:=Form1.Height-39;
  if Form1.Width < 900 then Form1.Width:= 900;

end;


procedure TForm1.MenuItem1Click(Sender: TObject);
var i,  pozicija : integer;
    s : String;
    dadada : Boolean;
begin
  Button3Click(Button3);
  s := TreeView1.Selected.text;
  for i:=0 to TreeView1.Items.Count-1 do
   if s = TreeView1.Items.Item[i].Text then pozicija:=i;
  dadada:=true;
  TreeView1.OnChanging(TreeView1, TreeView1.Selected, dadada);
  AssignFile(fo, 'noteshell_settings.txt');
  rewrite(fo);
  writeln(fo, minintray);
  writeln(fo, FPath);
  Writeln(fo, IntToStr(Form1.Width));
  Writeln(fo, IntToStr(Form1.Height));
  Writeln(fo, IntToStr(Splitter1.Left));
  Writeln(fo, IntToStr(pozicija));
  Writeln(fo, IntToStr(nFontSize));
  Writeln(fo, IntToStr(Combo1II));
  closeFile(fo);
  Halt;
end;


procedure TForm1.noteshell_TrayIcon1MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  // this is for left click
 if Button=mbLeft then
  if not(form1.Showing) then
    Form1.Show
   else begin
    form1.WindowState := wsNormal;
    form1.Hide;
    Form1.ShowInTaskBar := stNever;
  end;
 // this is for right click
 if Button=mbRight then PopUpMenu1.PopUp;
end;

procedure TForm1.PopupMenu1Close(Sender: TObject);
begin

end;

procedure TForm1.SynEdit1Change(Sender: TObject);
begin
  SynEditPromena:=True;
  Button3.Font.Color:=clRed;
end;

procedure TForm1.SynEdit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if Shift=[ssCtrl] then begin
 // M=77
 if Key=77 then begin
  form1.WindowState := wsNormal;
  form1.Hide;
  form1.ShowInTaskBar := stNever;
  Key:=0;
 end;
 // S=83
 if Key=83 then begin
   Form1.Button3Click(Button3);
   Key:=0;
 end;
 // L=76
  if Key= 76 then begin
   ShowLineNumbers:=not(ShowLineNumbers);
   if ShowLineNumbers then
     SynEdit1.Gutter.Visible:=True
   else
     SynEdit1.Gutter.Visible:=False;
  end;
  // E= 69 Exapand all
  if Key = 69 then Form1.TreeView1.FullExpand;
  // O= 79 Collapse all
  if Key = 79 then Form1.TreeView1.FullCollapse;

end; // if Shift

end;


procedure TForm1.TreeView1Changing(Sender: TObject; Node: TTreeNode;
  var AllowChange: Boolean);
begin
    if SynEditPromena then begin
                             Form1.Button3Click(Button3);
                             SynEditPromena:=False;
                        end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var rnum : integer;
    snum: String;
begin
  rnum:=100+random(900);
  snum:=IntToStr(rnum);
  if CheckBox1.Checked then TreeView1.Items.AddChild(TreeView1.Selected  , 'new_node_random_'+snum)
                       else TreeView1.Items.Add(TreeView1.Selected, 'new_node_random_'+snum);
  TreeView1.Selected.Expand(true);
  RefreshCombo1(ComboBox1);
end;

procedure TForm1.Button1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Form1.SynEdit1.OnKeyDown(SynEdit1, Key, Shift);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Form2.Show;
  Form2.ComboBox1.ItemIndex:=Combo1II;

  if minintray='minimizedintray' then Form2.CheckBox1.Checked:=True
                                 else Form2.CheckBox1.Checked:=False;
end;

procedure TForm1.Button2KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Form1.SynEdit1.OnKeyDown(SynEdit1, Key, Shift);
end;

procedure TForm1.Button3Click(Sender: TObject);      // Save
var s , ssmeni: String;
    i : integer;
    Moze : Boolean;
begin
  s := TreeView1.Selected.text;
  Moze:=True;
  for i:=1 to length(s) do
   if not(s[i] in ['a'..'z','A'..'Z','0'..'9','_']) then Moze:=False;
  if not(Moze) then showmessage('Only can use letters(latin) and numbers and _ for node names. Rename the node');

  if Moze then begin
                      ssmeni := SynEdit1.Text;
                      if TargetPlatform='l' then begin
                      for i:=length(ssmeni) downto 1 do
                        if (ssmeni[i]=#10) and (ssmeni[i-1] <> #13) then insert(#13, ssmeni, i);
                      end;
                      if TargetPlatform='m' then begin
                      for i:=length(ssmeni) downto 1 do
                        if (ssmeni[i]=#13) and (ssmeni[i+1] <> #10) then insert(#10, ssmeni, i+1);
                      end;
                      AssignFile(wf, FPath+s+'.txt');
                      rewrite(wf);
                      writeln(wf, ssmeni);
                      CloseFile(wf);
                      Button3.Font.Color:= clDefault;

                      AssignFile(f, FPath+'000noteshelltreestate.txt');
                      rewrite(f);
                      for i:=0 to TreeView1.Items.Count-1 do
                      if TreeView1.Items.Item[i].Expanded then
                         writeln(f, 'T')
                         else
                         writeln(f, 'F');
                      closeFile(f);
                      TreeView1.SaveToFile(FPath+'000noteshelltree.txt');
               end;
end;

procedure TForm1.Button3KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Form1.SynEdit1.OnKeyDown(SynEdit1, Key, Shift);
end;


procedure TForm1.Button4Click(Sender: TObject);

  //A procedure to recursively delete nodes
  Procedure DeleteNode(Node:TTreeNode);
  var ime : String;
  begin
    while Node.HasChildren do begin
                                   DeleteNode(node.GetLastChild);
                              end;
    if FileExists(FPath+Node.Text+'.txt') then begin
     CopyFile(FPath+Node.Text+'.txt', FPath+'Trash/'+ Node.Text+'.txt');
     DeleteFile(FPath+Node.Text+'.txt');
    end;
    TreeView1.Items.Delete(Node);
  end;

var i, pozicija : integer;
    s : String;
begin
  if not(DirectoryExists(FPath+'Trash')) then CreateDir(FPath+'Trash');
  s:=TreeView1.Selected.Text;
  for i:=0 to TreeView1.Items.Count-1 do
   if s = TreeView1.Items.Item[i].Text then pozicija:=i;
  CudnoNoMoze:=False;
  if (TreeView1.Selected = nil) OR (TreeView1.Selected = TreeView1.Items.Item[0]) then exit;
  if messagedlg('Are you sure ??',mtConfirmation,
                  [mbYes,mbNo],0) <> mrYes then exit;
  DeleteNode(TreeView1.Selected);
  CudnoNoMoze:=True;
  TreeView1.Items.Item[pozicija-1].Selected:=True;
  Button3.Font.Color:= clRed;
  RefreshCombo1(ComboBox1);
end;

procedure TForm1.Button4KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Form1.SynEdit1.OnKeyDown(SynEdit1, Key, Shift);
end;

procedure TForm1.Button5Click(Sender: TObject);
var
    j: Integer;
begin
  j:= SynEdit1.SearchReplace(Edit1.Text, '', []);
  if j = 0 then ShowMessage('End');
 { sf:=trim(Edit1.Text);
  p:=UTF8Pos(UTF8UpperCase(sf), UTF8UpperCase(st));
  gp:=gp+p+UTF8Length(sf)-1;
  if p > 0 then begin
    //SynEdit1.SelStart:=gp-UTF8Length(sf);
    //SynEdit1.SelLength:=UTF8Length(sf);
    SynEdit1.SetFocus;
    UTF8Delete(st, 1, p+UTF8Length(sf)-1);
  end else begin
              gp:=0;
              st:=SynEdit1.Text;
              ShowMessage('End');
           end; }
end;

procedure TForm1.CheckBox1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Form1.SynEdit1.OnKeyDown(SynEdit1, Key, Shift);
end;

procedure TForm1.CheckBox3Change(Sender: TObject);
begin
  if CheckBox3.Checked then Splitter1.Left:= pamtisplit1
  else begin
   pamtisplit1:= Splitter1.Left;
   Splitter1.Left:= 0
  end;
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
begin
  filteron:= ComboBox1.Text;
end;

procedure TForm1.ComboBox1Click(Sender: TObject);
begin

end;

procedure TForm1.ComboBox1CloseUp(Sender: TObject);
begin

end;

// filtering Combo1
procedure TForm1.ComboBox1DropDown(Sender: TObject);
var
  i, j: Integer;
begin
    ComboBox1.Clear;
    for i:=0 To TreeView1.Items.Count - 1 do
     if (Pos(UTF8UpperCase(trim(filteron)), UTF8UpperCase(trim(TreeView1.Items.Item[i].Text))) > 0)
       or (trim(filteron) = '') then begin
         ComboBox1.Items.AddText(TreeView1.Items.Item[i].Text);
      end;
    filteron:='';
end;

procedure TForm1.ComboBox1EditingDone(Sender: TObject);
var
  i, pozicija: Integer;
  s: String;
begin
  if ComboBox1.ItemIndex = -1 then begin
   try
    ComboBox1.ItemIndex:= nprev;
   {except
    on E: Exception do
     ComboBox1.ItemIndex:= 0; }
   finally
   end;
  end
  else begin
    // find real position
     s:= ComboBox1.Items.ValueFromIndex[ComboBox1.ItemIndex];
     for i:=0 to TreeView1.Items.Count-1 do
       if trim(s) = trim(TreeView1.Items.Item[i].Text) then pozicija:=i;

    TreeView1.Items.Item[pozicija].Selected:=True;
    nprev:= pozicija;
  end;
end;

procedure TForm1.ComboBox1Enter(Sender: TObject);
begin

end;

procedure TForm1.Edit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
  );
begin
  if Key=VK_RETURN then begin
                             Key:=0;
                             Button5Click(Button5);
                        end;
  if Shift=[ssCtrl] then Form1.SynEdit1.OnKeyDown(SynEdit1, Key, Shift);
end;

procedure TForm1.FindDialog1Find(Sender: TObject);
begin

end;


procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
var i,  pozicija : integer;
    s : String;
    dadada : Boolean;
begin
  Button3Click(Button3);
  s := TreeView1.Selected.text;
  for i:=0 to TreeView1.Items.Count-1 do
   if s = TreeView1.Items.Item[i].Text then pozicija:=i;
  dadada:=true;
  TreeView1.OnChanging(TreeView1, TreeView1.Selected, dadada);
  AssignFile(fo, 'noteshell_settings.txt');
  rewrite(fo);
  writeln(fo, minintray);
  writeln(fo, FPath);
  Writeln(fo, IntToStr(Form1.Width));
  Writeln(fo, IntToStr(Form1.Height));
  Writeln(fo, IntToStr(Splitter1.Left));
  Writeln(fo, IntToStr(pozicija));
  Writeln(fo, IntToStr(nFontSize));
  Writeln(fo, IntToStr(Combo1II));
  closeFile(fo);
  Halt;
end;

procedure TForm1.TreeView1DragDrop(Sender, Source: TObject; X, Y: Integer);
var
  tv     : TTreeView;
  iNode  : TTreeNode;
  i : integer;
  Nachin : TNodeAttachMode;
begin
  tv := TTreeView(Sender);
  iNode := tv.GetNodeAt(x,y);


  if CheckBox1.Checked then Nachin:=naAddChild
                       else Nachin:=naInsert;

  if Source = Sender then begin
   if  Assigned(tv.Selected) and (iNode <> tv.Selected) then
    if iNode <> nil then begin
      tv.Selected.MoveTo(iNode, Nachin);
      RefreshCombo1(ComboBox1);
    end;
  end;
  Button3.Font.Color:= clRed;
end;

procedure TForm1.TreeView1DragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  Accept:=True;
end;

procedure TForm1.TreeView1EditingEnd(Sender: TObject; Node: TTreeNode;
  Cancel: Boolean);
var s : String;
    i, pozicija : integer;
    Moze : Boolean;
begin
  Moze:=True;
  CudnoNoMoze:=True;
  s := TreeView1.Selected.text;
  for i:=0 to TreeView1.Items.Count-1 do
   if s = TreeView1.Items.Item[i].Text then pozicija:=i;

  for i:=0 to TreeView1.Items.Count-1 do
    if i <> pozicija then
     if s=TreeView1.Items.Item[i].Text then begin
                                                 Moze:=False;
                                                 TreeView1.Items.Item[pozicija].Text:=PreserveName;
                                                 showmessage('every node must have unique name, '+s+' already exists');
                                                 break;
                                            end;
  for i:=1 to length(s) do
   if not(s[i] in ['a'..'z','A'..'Z','0'..'9','_']) then begin
                                                          Moze:=False;
                                                          TreeView1.Selected.Text:=PreserveName;
                                                          showmessage('Only can use letters(latin) and numbers and _ for node names. Instead of space use _');
                                                          break;
                                                        end;
  if Moze then
    if FileExists(FPath+PreserveName+'.txt') then begin
                                              DeleteFile(FPath+PreserveName+'.txt');
                                              SynEdit1.Lines.SaveToFile(FPath+s+'.txt');
                                            end;
  RefreshCombo1(ComboBox1);
end;

procedure TForm1.TreeView1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key=VK_UP) or (Key=VK_DOWN) or (Key=VK_RIGHT) or (Key=VK_LEFT) then CudnoNoMoze:=True;
  Form1.SynEdit1.OnKeyDown(SynEdit1, Key, Shift);
end;

procedure TForm1.TreeView1SelectionChanged(Sender: TObject);
var
    i, pozicija : Integer;
begin
  if CudnoNoMoze then begin
    PreserveName:=TreeView1.Selected.Text;
    for i:=0 to TreeView1.Items.Count-1 do
     if PreserveName = TreeView1.Items.Item[i].Text then pozicija:=i;
    RefreshCombo1(ComboBox1);
    ComboBox1.ItemIndex:= pozicija;
    SynEdit1.Clear;
    if FileExists(FPath + PreserveName +'.txt') then
     SynEdit1.Lines.LoadFromFile(FPath + PreserveName +'.txt');
  end;
end;


end.

