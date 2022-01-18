pageextension 59114 MFRetailPurchaseOrder extends "Retail Purchase Order"
{
    layout
    {
        modify("Vendor Shipment No.")
        {
            ShowMandatory = true;
        }
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean;
    begin
        Rec.TestField("Vendor Shipment No.");
    end;
}
