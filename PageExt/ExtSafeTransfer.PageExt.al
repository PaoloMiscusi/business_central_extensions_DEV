pageextension 59101 ExtSafeTransfer extends "Safe Transfer"
{

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Bal. Account Type" := Rec."Bal. Account Type"::"G/L Account";
        Rec."Bal. Account No." := '1084005';
        Rec.Validate("Bal. Account No.");
    end;

    trigger OnAfterGetCurrRecord()
    begin
        if Rec."Bal. Account No." = '' then begin
            Rec."Bal. Account Type" := Rec."Bal. Account Type"::"G/L Account";
            Rec."Bal. Account No." := '1084005';
            Rec.Validate("Bal. Account No.");
        end;

    end;
}