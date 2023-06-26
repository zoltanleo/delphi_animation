unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.ImageList, Vcl.ImgList, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.Imaging.GIFImg, Vcl.Imaging.pngimage;

type
  TForm1 = class(TForm)
    rgAnim: TRadioGroup;
    imgGif: TImage;
    imgFrames: TImage;
    imgList: TImageList;
    tmrFrame: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure rgAnimClick(Sender: TObject);
    procedure tmrFrameTimer(Sender: TObject);
  private
    FFrameCnt: Integer;
    { Private declarations }
  public
    { Public declarations }
    property FrameCnt: Integer read FFrameCnt;
  end;

const
  GifFN = 'c:\proj\test_delphi\delphi_animation\pict\medic_bgd.gif';
var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  Self.DoubleBuffered:= True;
  FFrameCnt:= 0;

  if FileExists(GifFN)
    then imgGif.Picture.LoadFromFile(GifFN)
    else ShowMessage(Format('"%s" file does not exist',[GifFN]));

  TGIFImage(imgGif.Picture.Graphic).Animate:= False;
  TGIFImage(imgGif.Picture.Graphic).AnimationSpeed:= 50;
  tmrFrame.Enabled:= False;
  tmrFrame.Interval:= 50;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  rgAnimClick(Sender);
end;

procedure TForm1.rgAnimClick(Sender: TObject);
begin
  case rgAnim.ItemIndex of
    0:
      try
        tmrFrame.Enabled:= False;
        if Assigned(imgGif.Picture.Graphic) then
          TGIFImage(imgGif.Picture.Graphic).Animate:= True;
      except
        on E: Exception do
          ShowMessage(e.Message);
      end;
    1:
      begin
        tmrFrame.Enabled:= True;
        if Assigned(imgGif.Picture.Graphic) then
          TGIFImage(imgGif.Picture.Graphic).Animate:= False;
      end;
  end;
  Self.Caption:= IntToStr(rgAnim.ItemIndex);
end;

procedure TForm1.tmrFrameTimer(Sender: TObject);
begin
  imgFrames.Picture.Bitmap:= nil;
  imgList.GetBitmap(FrameCnt,imgFrames.Picture.Bitmap);
  if (FrameCnt = imgList.Count)
    then FFrameCnt:= 0
    else Inc(FFrameCnt);
end;

end.
