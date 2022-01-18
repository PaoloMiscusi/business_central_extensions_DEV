pageextension 59105 ExtItemJournal extends "Item Journal"
{

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Entry Type" := Rec."Entry Type"::"Negative Adjmt.";
        //Rec."Location Code" := CopyStr(Rec."Document No.", 1, 4);
    end;

}