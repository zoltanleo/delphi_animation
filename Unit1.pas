unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.ImageList, Vcl.ImgList, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.Imaging.GIFImg, Vcl.Imaging.pngimage, Vcl.ComCtrls;

type
  TForm1 = class(TForm)
    rgAnim: TRadioGroup;
    imgGif: TImage;
    imgFrames: TImage;
    imgList: TImageList;
    tmrFrame: TTimer;
    tbFrame: TTrackBar;
    tbGif: TTrackBar;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure rgAnimClick(Sender: TObject);
    procedure tmrFrameTimer(Sender: TObject);
    procedure tbGifChange(Sender: TObject);
    procedure tbFrameChange(Sender: TObject);
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

  with tbGif do
  begin
    Min:= 10;
    Max:= 200;
    Frequency:= 5;
    LineSize:= Frequency;
    Position:= 50;
  end;

  TGIFImage(imgGif.Picture.Graphic).Animate:= False;
//  TGIFImage(imgGif.Picture.Graphic).AnimationSpeed:= tbGif.Position;

  with tbFrame do
  begin
    Min:= 10;
    Max:= 200;
    Frequency:= 5;
    LineSize:= Frequency;
    Position:= 60;
  end;
  tmrFrame.Enabled:= False;
//  tmrFrame.Interval:= tbFrame.Position;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  tbGifChange(Sender);
  tbFrameChange(Sender);
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

procedure TForm1.tbFrameChange(Sender: TObject);
begin
  Label2.Caption:= Format('fps: %d',[tbFrame.Position]);
  tmrFrame.Interval:= tbFrame.Position;
end;

procedure TForm1.tbGifChange(Sender: TObject);
begin
  Label1.Caption:= Format('fps: %d',[tbGif.Position]);
  TGIFImage(imgGif.Picture.Graphic).Animate:= False;
  TGIFImage(imgGif.Picture.Graphic).AnimationSpeed:= tbGif.Position;
  TGIFImage(imgGif.Picture.Graphic).Animate:= True;
end;

procedure TForm1.tmrFrameTimer(Sender: TObject);
begin
  imgList.GetBitmap(FrameCnt,imgFrames.Picture.Bitmap);
  imgFrames.Repaint;
  if (FrameCnt = imgList.Count)
    then FFrameCnt:= 0
    else Inc(FFrameCnt);
end;

end.
