page 59107 ItemDefaultMenuTypesListPart
{
    Caption = 'Item Default Menu Types';
    DataCaptionExpression = Format(Rec.Type) + ' - ' + Rec."No." + ' - ' + Rec."Restaurant No.";
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = "Default Restaurant Menu Type";
    SourceTableView = SORTING(Type, "No.", "Restaurant No.")
                      WHERE(Type = CONST(Item));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Restaurant No."; "Restaurant No.")
                {
                    ApplicationArea = All;
                }
                field("Menu Type Order"; "Menu Type Order")
                {
                    ApplicationArea = All;
                }
                field("Item Description"; "Item Description")
                {
                    ApplicationArea = All;
                }
                field("Menu Type Description"; "Menu Type Description")
                {
                    ApplicationArea = All;
                }
                field("Code on POS"; "Code on POS")
                {
                    ApplicationArea = All;
                }
                field("Compress Menu Type"; "Compress Menu Type")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Generate Default Menu Types")
            {
                ApplicationArea = All;
                Caption = 'Generate Default Menu Types';
                Image = ChangeBatch;

                trigger OnAction()
                var
                    RetailItemUtils: Codeunit RetailItemUtils;
                    Item: Record Item;
                begin
                    Item.Get(Rec."No.");
                    RetailItemUtils.GenerateDefaultMenuTypes(Item);
                end;
            }
        }
    }


}