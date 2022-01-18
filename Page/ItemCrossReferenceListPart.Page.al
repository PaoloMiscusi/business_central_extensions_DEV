page 59106 ItemCrossReferenceListPart
{
    Caption = 'Item Cross Reference Entries';
    DataCaptionFields = "Item No.";
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = "Item Cross Reference";
    ObsoleteState = Pending;
    ObsoleteReason = 'Replaced by Item Reference feature.';
    ObsoleteTag = '17.0';

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Item No."; "Item No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the type of the cross-reference entry.';
                }
                field("Cross-Reference Type"; "Cross-Reference Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the type of the cross-reference entry.';
                }
                field("Cross-Reference Type No."; "Cross-Reference Type No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a customer number, a vendor number, or a bar code, depending on what you have selected in the Type field.';
                }
                field("Cross-Reference No."; "Cross-Reference No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the cross-referenced item number. If you enter a cross reference between yours and your vendor''s or customer''s item number, then this number will override the standard item number when you enter the cross-reference number on a sales or purchase document.';
                }
                field("Unit of Measure"; "Unit of Measure")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the name of the item or resource''s unit of measure, such as piece or hour.';
                }
                field("QSL Category"; Rec."QSL Category")
                {
                }
                field("Shelf life in stock"; Rec."Shelf life in stock")
                {
                }
                field("Durabilità alla produzione"; Rec."Durabilità alla produzione")
                {
                    Caption = 'Shelf life at production';
                }
                field("Country of origin"; Rec."Country of origin")
                {
                }
                field("Storage temperature"; Rec."Storage temperature")
                {
                }
                field(Description; Description)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a description of the item linked to this cross reference. It will override the standard description when entered on an order.';
                }
                field("Description 2"; "Description 2")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies an additional description of the item linked to this cross reference.';
                    Visible = false;
                }
                field("Supplier Priority"; "SupplierPriority")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Supplier Priority';
                    ToolTip = 'Specifies the preferred supplier when purchasing this item, priority 1 means that this is the main supplier';
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Cross-Reference Type" := Rec."Cross-Reference Type"::Vendor;
    end;

}

