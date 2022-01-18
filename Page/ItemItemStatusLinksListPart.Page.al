page 59118 ItemItemStatusLinksListPart
{
    Caption = 'Item/Item Status Links';
    DataCaptionFields = "Item No.";
    DelayedInsert = true;
    PageType = ListPart;
    PopulateAllFields = true;
    SourceTable = "Item Status Link";

    layout
    {
        area(content)
        {
            repeater(Control1100409000)
            {
                ShowCaption = false;
                field("Item No."; "Item No.")
                {
                    ApplicationArea = All;
                }
                field("Location Code"; "Location Code")
                {
                    ApplicationArea = All;
                }
                field("Starting Date"; "Starting Date")
                {
                    ApplicationArea = All;
                }
                field("Status Code"; "Status Code")
                {
                    ApplicationArea = All;
                }
                field("Status Description"; "Status Description")
                {
                    ApplicationArea = All;
                }
                field("Block Sale on POS"; "Block Sale on POS")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Block Purchasing"; "Block Purchasing")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Block Purchase Return"; "Block Purchase Return")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Block Transferring"; "Block Transferring")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Block Discount"; "Block Discount")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Block Promotion Price"; "Block Promotion Price")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Block Periodic Discount"; "Block Periodic Discount")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Block Manual Price Change"; "Block Manual Price Change")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Block Sale in Sales Order"; "Block Sale in Sales Order")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Block Sales Return"; "Block Sales Return")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Block Negative Adjustment"; "Block Negative Adjustment")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Block Positive Adjustment"; "Block Positive Adjustment")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Block From Recommendation"; "Block From Recommendation")
                {
                    ApplicationArea = All;
                }
                field("Blocked on eCommerce"; "Blocked on eCommerce")
                {
                    ApplicationArea = All;
                }
                field(Comment; Comment)
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
            action("Generate Default Status")
            {
                ApplicationArea = All;
                Caption = 'Generate Default Status';
                Image = ChangeBatch;

                trigger OnAction()
                begin
                    GenerateActiveStatusLinkForAllStores();
                end;
            }
        }
    }

    local procedure GenerateActiveStatusLinkForAllStores()
    var
        ItemStatusLink: Record "Item Status Link";
        Stores: Record Store;
    begin
        Stores.SetFilter("Location Code", '%1&<>%2', 'I*', 'IWRS');
        if Stores.FindSet() then
            repeat
                ItemStatusLink.Init();
                ItemStatusLink."Item No." := Rec."Item No.";
                ItemStatusLink."Location Code" := Stores."Location Code";
                ItemStatusLink."Starting Date" := System.Today;
                ItemStatusLink."Status Code" := 'NUOVO';
                ItemStatusLink.Validate("Status Code");
                ItemStatusLink.Insert(true);
            Until Stores.Next() = 0;
    end;
}

