unit FCharAttrib;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, A2Form, StdCtrls, ExtCtrls, deftype;

type
  TfrmCharAttrib = class(TForm)
    lblEnergy: TA2Label;
    lblEnergyName: TA2Label;
    lblAttackSpeed: TA2Label;
    lblAvoid: TA2Label;
    lblAccuracy: TA2Label;
    lblRecovery: TA2Label;
    lblKeepRecovery: TA2Label;
    lblDamageBody: TA2Label;
    lblDamageHead: TA2Label;
    lblDamageArm: TA2Label;
    lblDamageLeg: TA2Label;
    lblArmorBody: TA2Label;
    lblArmorHead: TA2Label;
    lblArmorArm: TA2Label;
    lblArmorLeg: TA2Label;
    lblInPower: TA2Label;
    lblOutPower: TA2Label;
    lblMagic: TA2Label;
    lblLife: TA2Label;
    lblDefaultValue: TA2Label;
    lblAttribTotal: TA2Label;
    lblShoutLevel: TA2Label;
    btnClose: TA2Button;
    A2Form: TA2Form;
    Image1: TImage;
    lblLover: TA2Label;
    procedure btnCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    procedure MessageProcess(var Code: TWordComData);
  end;

var
  frmCharAttrib: TfrmCharAttrib;

implementation

{$R *.dfm}

uses
   FAttrib, FLogon, FBottom, FMain;
   
procedure TfrmCharAttrib.MessageProcess(var Code: TWordComData);
var
   psAttribBase : PTSAttribBase;
   psAbilityAttrib : PTSAbilityAttrib;
   iDefaultValue, iDefaultLife, iTotal: integer;
begin
   case Code.Data[0] of
   SM_ATTRIBBASE:
      begin
         psAttribBase := @Code.Data;

         with psAttribBase^ do begin
            iDefaultValue := 600 + (rAge div 2);
            iDefaultLife := rAge + 2100;
            iTotal := rInPower + rOutPower + rMagic + iDefaultValue + iDefaultLife;

            lblInPower.Caption      := Get10000to100(rInPower);      //郴傍
            lblOutPower.Caption     := Get10000to100(rOutPower);     //寇傍
            lblMagic.Caption        := Get10000to100(rMagic);        //公傍
            lblLife.Caption         := Get10000to100(iDefaultLife);  //扁夯劝仿
            lblDefaultValue.Caption := Get10000to100(iDefaultValue); //扁夯蔼
            lblAttribTotal.Caption  := Get10000to100(iTotal);        //醚钦
            lblEnergy.Caption       := Get10000to100(rEnergy);       //盔扁
            lblLover.Caption := StrPas(@rLover);
         end;

         case iTotal of
         0..32999:     lblShoutLevel.Caption := '1' + Conv('境界');
         33000..36999: lblShoutLevel.Caption := '2' + Conv('境界');
         37000..40999: lblShoutLevel.Caption := '3' + Conv('境界');
         41000..44999: lblShoutLevel.Caption := '4' + Conv('境界');
         45000..48999: lblShoutLevel.Caption := '5' + Conv('境界');
         49000..99999: lblShoutLevel.Caption := '6' + Conv('境界');
         else          lblShoutLevel.Caption := '';
         end;

         case psAttribBase.rEnergy of
         4000..7999:    lblEnergyName.Caption := Conv('出入境');
         8000..11999:   lblEnergyName.Caption := Conv('造化境');
         12000..17999:  lblEnergyName.Caption := Conv('玄妙境');
         18000..25999:  lblEnergyName.Caption := Conv('生死境');
         26000..35999:  lblEnergyName.Caption := Conv('解脱境');
         36000..47999:  lblEnergyName.Caption := Conv('无为境');
         48000..61999:  lblEnergyName.Caption := Conv('神话境');
         62000..77999:  lblEnergyName.Caption := Conv('无上武念');
         78000..95999:  lblEnergyName.Caption := Conv('天人合一');
         96000..115999: lblEnergyName.Caption := Conv('至尊无上');
         116000..137999:lblEnergyName.Caption := Conv('一念通天');
         138000..161999:lblEnergyName.Caption := Conv('空前绝后');
         162000..300000:lblEnergyName.Caption := Conv('泰山北斗');
         else           lblEnergyName.Caption := '';
         end;
      end;
   SM_ABILITYATTRIB:
      begin
         psAbilityAttrib := @Code.Data;
         with psAbilityAttrib^ do begin
            lblAttackSpeed.Caption  := IntToStr(rAttackSpeed);
            lblAvoid.Caption        := IntToStr(rAvoid);
            lblRecovery.Caption     := IntToStr(rRecovery);
            lblAccuracy.Caption     := IntToStr(rAccuracy);
            lblKeepRecovery.Caption := IntToStr(rKeepRecovery);

            lblDamageBody.Caption   := IntToStr(rDamageBody);
            lblDamageHead.Caption   := IntToStr(rDamageHead);
            lblDamageArm.Caption    := IntToStr(rDamageArm);
            lblDamageLeg.Caption    := IntToStr(rDamageLeg);

            lblArmorBody.Caption   := IntToStr(rArmorBody);
            lblArmorHead.Caption   := IntToStr(rArmorHead);
            lblArmorArm.Caption    := IntToStr(rArmorArm);
            lblArmorLeg.Caption    := IntToStr(rArmorLeg);
         end;
      end;
   end;
end;

procedure TfrmCharAttrib.btnCloseClick(Sender: TObject);
begin
   //frmBottom.FocusControl(frmBottom.EdChat);
   FrmBottom.EdChat.SetFocus; 
   Visible := False;
end;

procedure TfrmCharAttrib.FormCreate(Sender: TObject);
begin
   FrmM.AddA2Form(self, A2Form);
   Left := 10;
   Top := 10;
   Visible := False;
end;

end.
