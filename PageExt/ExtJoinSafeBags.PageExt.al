pageextension 59102 ExtJoinSafeBags extends "Join Safe Bags"
{

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Bag Type" := Rec."Bag Type"::Safe;
        Rec."Tender Type" := '1';
    end;
}