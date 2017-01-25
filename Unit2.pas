unit Unit2; 

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  LCLIntf;

type

  { TForm2 }

  TForm2 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    CheckBox1: TCheckBox;
    ComboBox1: TComboBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Memo1: TMemo;
    procedure CheckBox1Change(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  Form2: TForm2;


implementation
uses Unit1;
{$R *.lfm}

{ TForm2 }


procedure TForm2.CheckBox1Change(Sender: TObject);
begin
  if CheckBox1.Checked then minintray:='minimizedintray'
                       else minintray:='normal';
end;

procedure TForm2.ComboBox1Change(Sender: TObject);
begin
  case ComboBox1.ItemIndex of
      0 : nFontSize:=9;
      1 : nFontSize:=10;
      2 : nFontSize:=11;
      3 : nFontSize:=12;
      4 : nFontSize:=13;
      5 : nFontSize:=14;
      6 : nFontSize:=15;
      7 : nFontSize:=16;
      8 : nFontSize:=17;
      9 : nFontSize:=18;
      10 : nFontSize:=19;
      11 : nFontSize:=20;
  end; // case
  Form1.SynEdit1.Font.Size:=nFontSize;
  Combo1II:=ComboBox1.ItemIndex;
end;


end.

