unit UnitItemEditWin;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, StdCtrls, ExtCtrls, deftype;

type
    TfrmItemEdit = class(TForm)
        Panel_item_edit: TPanel;
        Label15: TLabel;
        Label16: TLabel;
        Label17: TLabel;
        Label18: TLabel;
        Label19: TLabel;
        Label20: TLabel;
        Label21: TLabel;
        Label22: TLabel;
        Label23: TLabel;
        Label24: TLabel;
        Label25: TLabel;
        Panel4: TPanel;
        Label31: TLabel;
        Button_windows_item_close: TButton;
        Button_windows_item_save: TButton;
        Edit_item_id: TEdit;
        Edit_item_name: TEdit;
        Edit_item_count: TEdit;
        Edit_item_color: TEdit;
        Edit_item_durability: TEdit;
        Edit_item_durabilitymax: TEdit;
        Edit_item_smithingLevel: TEdit;
        Edit_item_Additional: TEdit;
        edit_item_LockState: TEdit;
        Edit_item_Locktime: TEdit;
        Edit_item_DataTime: TEdit;
        GroupBox1: TGroupBox;
        Label26: TLabel;
        Label27: TLabel;
        Label28: TLabel;
        Label29: TLabel;
        Label30: TLabel;
        Edit_item_SettingCount: TEdit;
        Edit_item_Setting1: TEdit;
        Edit_item_Setting2: TEdit;
        Edit_item_Setting3: TEdit;
        Edit_item_Setting4: TEdit;
        GroupBox2: TGroupBox;
        Label79: TLabel;
        Label94: TLabel;
        Label114: TLabel;
        Label115: TLabel;
        Label116: TLabel;
        Label117: TLabel;
        Label123: TLabel;
        Label126: TLabel;
        Label128: TLabel;
        Label129: TLabel;
        Label130: TLabel;
        Label131: TLabel;
        Edit_item_damageBody: TEdit;
        Edit_item_damageHead: TEdit;
        Edit_item_damageArm: TEdit;
        Edit_item_damageLeg: TEdit;
        Edit_item_AttackSpeed: TEdit;
        Edit_item_avoid: TEdit;
        Edit_item_armorBody: TEdit;
        Edit_item_armorHead: TEdit;
        Edit_item_armorArm: TEdit;
        Edit_item_armorLeg: TEdit;
        Edit_item_recovery: TEdit;
        Edit_item_accuracy: TEdit;
        procedure Button_windows_item_saveClick(Sender: TObject);
        procedure Button_windows_item_closeClick(Sender: TObject);
    private

    { Private declarations }
    public
    { Public declarations }
        tempitem: TDBItemData;
        procedure itemtowindows(aitem: TDBItemData);
    end;


implementation

{$R *.dfm}

procedure TfrmItemEdit.itemtowindows(aitem: TDBItemData);
begin
    tempitem := aitem;

    Edit_item_id.Text := IntToStr(tempitem.rID);
    Edit_item_name.Text := tempitem.rName;
    Edit_item_count.Text := IntToStr(tempitem.rCount);
    Edit_item_color.Text := IntToStr(tempitem.rColor);
    Edit_item_durability.Text := IntToStr(tempitem.rDurability);
    Edit_item_durabilitymax.Text := IntToStr(tempitem.rDurabilityMAX);
    Edit_item_smithingLevel.Text := IntToStr(tempitem.rSmithingLevel);
    Edit_item_Additional.Text := IntToStr(tempitem.rAttach);
    edit_item_LockState.Text := IntToStr(tempitem.rlockState);
    Edit_item_Locktime.Text := IntToStr(tempitem.rlocktime);
    Edit_item_DataTime.Text := DateTimeToStr(tempitem.rDateTime);
    Edit_item_SettingCount.Text := IntToStr(tempitem.rSetting.rsettingcount);
    Edit_item_Setting1.Text := tempitem.rSetting.rsetting1;
    Edit_item_Setting2.Text := tempitem.rSetting.rsetting2;
    Edit_item_Setting3.Text := tempitem.rSetting.rsetting3;
    Edit_item_Setting4.Text := tempitem.rSetting.rsetting4;

{    Edit_item_damageBody.Text := inttostr(tempitem.rLifeDataLevel.damageBody);
    Edit_item_damageHead.Text := inttostr(tempitem.rLifeDataLevel.damageHead);
    Edit_item_damageArm.Text := inttostr(tempitem.rLifeDataLevel.damageArm);
    Edit_item_damageLeg.Text := inttostr(tempitem.rLifeDataLevel.damageLeg);

    Edit_item_armorBody.Text := inttostr(tempitem.rLifeDataLevel.armorBody);
    Edit_item_armorHead.Text := inttostr(tempitem.rLifeDataLevel.armorHead);
    Edit_item_armorArm.Text := inttostr(tempitem.rLifeDataLevel.armorArm);
    Edit_item_armorLeg.Text := inttostr(tempitem.rLifeDataLevel.armorLeg);

    Edit_item_AttackSpeed.Text := inttostr(tempitem.rLifeDataLevel.AttackSpeed);
    Edit_item_avoid.Text := inttostr(tempitem.rLifeDataLevel.avoid);
    Edit_item_recovery.Text := inttostr(tempitem.rLifeDataLevel.recovery);
    Edit_item_accuracy.Text := inttostr(tempitem.rLifeDataLevel.accuracy);
 }
end;

procedure TfrmItemEdit.Button_windows_item_saveClick(Sender: TObject);
begin

    tempitem.rID := StrToInt(Edit_item_id.Text);
    tempitem.rname := Edit_item_name.Text;
    tempitem.rCount := StrToInt(Edit_item_count.Text);
    tempitem.rColor := StrToInt(Edit_item_color.Text);
    tempitem.rDurability := StrToInt(Edit_item_durability.Text);
    tempitem.rDurabilityMAX := StrToInt(Edit_item_durabilitymax.Text);
    tempitem.rSmithingLevel := StrToInt(Edit_item_smithingLevel.Text);
    tempitem.rAttach := StrToInt(Edit_item_Additional.Text);
    tempitem.rlockState := StrToInt(edit_item_LockState.Text);
    tempitem.rlocktime := StrToInt(Edit_item_Locktime.Text);
    tempitem.rDateTime := StrToDateTime(Edit_item_DataTime.Text);

    tempitem.rSetting.rsettingcount := StrToInt(Edit_item_SettingCount.Text);
    tempitem.rSetting.rsetting1 := Edit_item_Setting1.Text;
    tempitem.rSetting.rsetting2 := Edit_item_Setting2.Text;
    tempitem.rSetting.rsetting3 := Edit_item_Setting3.Text;
    tempitem.rSetting.rsetting4 := Edit_item_Setting4.Text;

{    tempitem.rLifeDataLevel.damageBody := strtoint(Edit_item_damageBody.Text);
    tempitem.rLifeDataLevel.damageHead := strtoint(Edit_item_damageHead.Text);
    tempitem.rLifeDataLevel.damageArm := strtoint(Edit_item_damageArm.Text);
    tempitem.rLifeDataLevel.damageLeg := strtoint(Edit_item_damageLeg.Text);

    tempitem.rLifeDataLevel.armorBody := strtoint(Edit_item_armorBody.Text);
    tempitem.rLifeDataLevel.armorHead := strtoint(Edit_item_armorHead.Text);
    tempitem.rLifeDataLevel.armorArm := strtoint(Edit_item_armorArm.Text);
    tempitem.rLifeDataLevel.armorLeg := strtoint(Edit_item_armorLeg.Text);

    tempitem.rLifeDataLevel.AttackSpeed := strtoint(Edit_item_AttackSpeed.Text);
    tempitem.rLifeDataLevel.avoid := strtoint(Edit_item_avoid.Text);
    tempitem.rLifeDataLevel.recovery := strtoint(Edit_item_recovery.Text);
    tempitem.rLifeDataLevel.accuracy := strtoint(Edit_item_accuracy.Text);
    }
    Button_windows_item_closeClick(Sender);
end;

procedure TfrmItemEdit.Button_windows_item_closeClick(Sender: TObject);
begin
 Close;
end;

end.

