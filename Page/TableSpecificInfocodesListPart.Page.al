page 59103 TableSpecificInfocodesListPart
{
    Caption = 'Table Specific Infocodes';
    DataCaptionExpression = Caption();
    PageType = ListPart;
    PromotedActionCategories = 'New,Process,Reports,View';
    SourceTable = "Table Specific Infocode";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Item No."; Rec.Value)
                {
                    ApplicationArea = All;
                    Caption = 'Item No.';
                    Editable = false;
                    AssistEdit = false;
                    DrillDown = false;
                    Lookup = false;
                }
                field("Infocode Code"; "Infocode Code")
                {
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        Infocode: Record Infocode;
                    begin
                        Infocode.Reset;
                        Infocode.SetFilter("Usage Category", GetFilter("Usage Category"));
                        Infocode.SetFilter("Usage Sub-Category", GetFilter("Usage Sub-Category"));
                        Infocode.Code := "Infocode Code";
                        if PAGE.RunModal(99001507, Infocode) = ACTION::LookupOK then begin
                            Text := Infocode.Code;
                            exit(true);
                        end else
                            exit(false);
                    end;
                }
                field(Prompt; Prompt)
                {
                    ApplicationArea = All;
                    AssistEdit = false;
                    DrillDown = false;
                    Lookup = false;
                }
                field("When Required"; "When Required")
                {
                    ApplicationArea = All;
                }
                field(Sequence; Sequence)
                {
                    ApplicationArea = All;
                }
                field("Unit of Measure"; "Unit of Measure")
                {
                    ApplicationArea = All;
                }
                field(SalesTypeFilter; SalesTypeFilter)
                {
                    ApplicationArea = All;
                    Caption = 'Sales Type Filter';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        SalesTypeList: Page "Sales Type List";
                        SalesType: Record "Sales Type";
                    begin
                        SalesTypeList.SetTableView(SalesType);
                        SalesTypeList.LookupMode := true;
                        if SalesTypeList.RunModal = ACTION::LookupOK then begin
                            SalesTypeList.GetRecord(SalesType);
                            Text := SalesType.Code;
                            exit(true);
                        end else
                            exit(false);
                    end;

                    trigger OnValidate()
                    begin
                        "Sales Type Filter" := SalesTypeFilter;
                    end;
                }
                field("Quantity Handling"; "Quantity Handling")
                {
                    ApplicationArea = All;
                }
                field(Triggering; Triggering)
                {
                    ApplicationArea = All;
                }
                field("Min. Selection"; "Min. Selection")
                {
                    ApplicationArea = All;
                }
                field("Max. Selection"; "Max. Selection")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SalesTypeFilter := "Sales Type Filter";
        if not Infocode.Get("Infocode Code") then
            Clear(Infocode);
    end;

    trigger OnClosePage()
    begin
        Reset;
        if FindSet then
            repeat
                if "Table Name" = 0 then begin
                    "Table Name" := SetTableName("Table ID");
                    if Modify(true) then;
                end;
            until Next = 0;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        if not Infocode.Get("Infocode Code") then
            Clear(Infocode);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Clear(Infocode);
    end;



    var
        Text000: Label 'Infocodes';
        AllObj: Record AllObj;
        SalesTypeFilter: Code[250];
        TableNo: Integer;
        Text001: Label 'All Usage Types';
        Infocode: Record Infocode;
        AllInfocodesAndModifiersEnabled: Boolean;


}

