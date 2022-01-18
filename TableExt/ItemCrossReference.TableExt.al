tableextension 59200 ItemCrossReference extends "Item Cross Reference"
{
    fields
    {
        field(10; SupplierPriority; Integer)
        {
            trigger OnValidate();
            begin
                if (Rec.SupplierPriority < 0) then
                    message('Priority should be an integer greater or equal to 0');
            end;
        }
    }

    trigger OnBeforeInsert()
    begin
        Rec.Validate(SupplierPriority);
    end;

    trigger OnBeforeModify()
    begin
        Rec.Validate(SupplierPriority);
    end;

    trigger OnAfterInsert()
    var
        RetailItemUtils: Codeunit RetailItemUtils;
    begin
        if Rec.SupplierPriority = 1 then
            RetailItemUtils.SetPreferredSupplier(Rec."Item No.");
    end;

    trigger OnAfterModify()
    var
        RetailItemUtils: Codeunit RetailItemUtils;
    begin
        if Rec.SupplierPriority = 1 then
            RetailItemUtils.SetPreferredSupplier(Rec."Item No.");
    end;
}