unit frmPrincipal ;

{$mode objfpc}{$H+}

interface

uses
    Classes , SysUtils , Forms , Controls , Graphics , Dialogs , ExtCtrls , StdCtrls , Buttons ;

type

    { TForm1 }

    TForm1 = class(TForm)
        Image1 : TImage ;
        ImageList1 : TImageList ;
        Label1 : TLabel ;
        Label2 : TLabel ;
        Label3 : TLabel ;
        Label4 : TLabel ;
        Label5 : TLabel ;
        Label6 : TLabel ;
        Label7 : TLabel ;
        lbEdgtin : TLabeledEdit ;
        lbEddescricao : TLabeledEdit ;
        lbEdNcn : TLabeledEdit ;
        lbEdCest : TLabeledEdit ;
        Panel1 : TPanel ;
        Panel10 : TPanel ;
        Panel2 : TPanel ;
        Panel3 : TPanel ;
        Panel4 : TPanel ;
        Panel5 : TPanel ;
        Panel6 : TPanel ;
        Panel7 : TPanel ;
        Panel8 : TPanel ;
        Panel9 : TPanel ;
        SpeedButton1 : TSpeedButton ;
        SpeedButton2 : TSpeedButton ;
        SpeedButton3 : TSpeedButton ;
        procedure SpeedButton2Click(Sender : TObject) ;
        procedure SpeedButton3Click(Sender : TObject) ;
    private

    public

    end ;

var
    Form1 : TForm1 ;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.SpeedButton2Click(Sender : TObject) ;
begin
    lbEdgtin.Clear;
    lbEddescricao.Clear;
    lbEdNcn.Clear;
    lbEdCest.Clear;
end;

procedure TForm1.SpeedButton3Click(Sender : TObject) ;
begin
    application.Terminate;
end;

end.

