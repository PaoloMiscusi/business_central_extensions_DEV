page 59100 AttributeListItemRetailPage
{
    AutoSplitKey = true;
    Caption = 'Attributes Catalog';
    DataCaptionExpression = GetFormCaption();
    DelayedInsert = true;
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = "Attribute Value";

    layout
    {
        area(content)
        {

            repeater(Control1200070000)
            {
                ShowCaption = false;
                field("Attribute Code"; "Attribute Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Lookup = false;
                }
                field("Attribute Value"; "Attribute Value")
                {
                    ApplicationArea = All;
                    Editable = ValueEditable;
                    Enabled = ValueEditable;
                }
                field("Numeric Value"; "Numeric Value")
                {
                    ApplicationArea = All;
                }
                field("Value Calculated"; "Value Calculated")
                {
                    ApplicationArea = All;
                }
                field("Hard Attribute"; "Hard Attribute")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group(Attributes)
            {
                Caption = 'Attributes';
                action("Link Attribute")
                {
                    ApplicationArea = All;
                    Caption = 'Link Attribute';
                    Image = CreateDocument;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        AttributeValue: Record "Attribute Value";
                        AttributeUtils: Codeunit "Attribute Utils";
                        LinkField1: Code[20];
                        LinkField2: Code[20];
                        LinkField3: Code[20];
                    begin
                        LinkField1 := rec."Link Field 1";
                        LinkField2 := '';
                        LinkField3 := '';
                        if GetFilter("Link Field 2") = '''''' then
                            LinkField2 := '';

                        if AttributeUtils.CreateAttributeValues("Link Type", LinkField1, LinkField2, LinkField3, AttributeValue) then
                            Get(
                              AttributeValue."Link Type", AttributeValue."Link Field 1", AttributeValue."Link Field 2", AttributeValue."Link Field 3",
                              AttributeValue."Attribute Code", AttributeValue.Sequence);
                    end;
                }
                action("Remove Attribute")
                {
                    ApplicationArea = All;
                    Caption = 'Remove Attribute';
                    Image = Delete;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        if "Hard Attribute" then
                            Error(ErrorOnDelete, TableCaption, FieldCaption("Hard Attribute"));
                        if Rec."Attribute Code" <> '' then
                            if Confirm(isText001, false) then
                                Delete(true);
                    end;
                }
                action("Refresh Autom. Linked Attributes")
                {
                    trigger OnAction()
                    var
                        AttributeUtils: Codeunit "Attribute Utils";
                    begin
                        AttributeUtils.RefreshItemVariantAttributes(Rec."Link Field 1", '', true, false, Rec."Link Type"::Item);
                    end;
                }

                action("Calculate Attribute Values")
                {
                    ApplicationArea = All;
                    Caption = 'Calculate Attribute Values';
                    Image = CalculateLines;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        AttributeValue: Record "Attribute Value";
                        AttributeUtils: Codeunit "Attribute Utils";
                        Counter: Integer;
                    begin
                        Counter := 0;
                        if (GetFilter("Link Type") <> '') and (GetFilter("Link Field 1") <> '') then begin
                            Evaluate(AttributeValue."Link Type", GetFilter("Link Type"));
                            if AttributeValue."Link Type" = AttributeValue."Link Type"::Item then
                                Counter := AttributeUtils.CalculateRecipeAttributes(GetFilter("Link Field 1"));
                        end;

                        if Counter = 0 then
                            Message(MsgCalcNone)
                        else
                            Message(MsgCalcCounter, Format(Counter));
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetEditable;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        SetEditable;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        CheckAttributes(Rec);
    end;

    var
        isText001: Label 'Do you want to remove the attribute?';
        NegativeRefreshTxt: Label '%1 for %2 cannot be refreshed. You need to manually link attributes.';
        ErrorOnDelete: Label 'You cannot delete a %1 that is marked as %2.';
        ValueEditable: Boolean;
        MsgCalcCounter: Label '%1 values were changed.';
        MsgCalcNone: Label 'No values were changed.';

    [Scope('OnPrem')]
    procedure GetFormCaption(): Text[250]
    var
        lText001: Label '%1 %2 %3 %4';
    begin
        //GetFormCaption
        exit(StrSubstNo(lText001, Rec."Link Type", Rec."Link Field 1", Rec."Link Field 2", Rec."Link Field 3"));
    end;



    local procedure SetEditable()
    begin
        ValueEditable := ("Value Calculated" = "Value Calculated"::No);
    end;
}

