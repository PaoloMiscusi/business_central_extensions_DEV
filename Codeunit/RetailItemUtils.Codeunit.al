codeunit 59101 RetailItemUtils
{
    procedure GenerateDefaultMenuTypes(ItemRec: Record Item)
    var
        ItemDefaultMenuTypesRec: Record "Default Restaurant Menu Type";
        ItemDefaultMenuTypesCheckRec: Record "Default Restaurant Menu Type";
        Stores: Record Store;
    begin
        Stores.SetFilter("Location Code", '%1&<>%2', 'I*', 'IWRS');
        ItemDefaultMenuTypesCheckRec.SetRange("No.", ItemRec."No.");
        ItemDefaultMenuTypesCheckRec.SetRange(Type, ItemDefaultMenuTypesCheckRec.Type::Item);
        if Stores.FindSet() then
            repeat
                ItemDefaultMenuTypesCheckRec.SetRange("Restaurant No.", Stores."Location Code");
                if ItemDefaultMenuTypesCheckRec.IsEmpty() then begin
                    ItemDefaultMenuTypesRec.Init();
                    ItemDefaultMenuTypesRec."No." := ItemRec."No.";
                    ItemDefaultMenuTypesRec."Restaurant No." := Stores."Location Code";
                    ItemDefaultMenuTypesRec."Menu Type Order" := 1;
                    ItemDefaultMenuTypesRec.Type := ItemDefaultMenuTypesRec.Type::Item;
                    ItemDefaultMenuTypesRec.Insert(true);
                end;
            Until Stores.Next() = 0;
    end;

    procedure SetDefaultPrice(Rec: Record "Sales Price")
    var
        Item: Record Item;
    begin
        if Rec."Sales Code" = 'ALL' then begin
            Item.Get(Rec."Item No.");
            if (Item."Price Includes VAT" = false) or (Item."Unit Price Including VAT" <> Rec."Unit Price Including VAT") then begin
                Item."Price Includes VAT" := true;
                Item."Unit Price Including VAT" := Rec."Unit Price Including VAT";
                Item.Modify(true);
            end;
        end;
    end;

    procedure SetDefaultDimesions(ItemNo: Code[20])
    var
        DefaultDimension: Record "Default Dimension";
    begin
        DefaultDimension.Init();
        DefaultDimension."Table ID" := 27;
        DefaultDimension."No." := ItemNo;
        DefaultDimension."Dimension Code" := 'CANALE';
        DefaultDimension."Dimension Value Code" := 'RISTORANTE';
        DefaultDimension.Insert(true);
        DefaultDimension.Init();
        DefaultDimension."Table ID" := 27;
        DefaultDimension."No." := ItemNo;
        DefaultDimension."Dimension Code" := 'SOTTOCATEGORIA';
        DefaultDimension."Dimension Value Code" := '';
        DefaultDimension.Insert(true);


    end;

    procedure SetPreferredSupplier(ItemNo: Code[20])
    var
        ItemCrossReference: Record "Item Cross Reference";
        Item: Record Item;
    begin
        if Item.Get(ItemNo) then
            ItemCrossReference.SetRange("Item No.", Item."No.");
        ItemCrossReference.SetRange(SupplierPriority, 1);
        ItemCrossReference.SetRange("Cross-Reference Type", ItemCrossReference."Cross-Reference Type"::Vendor);
        if ItemCrossReference.FindFirst() then
            if StrLen(ItemCrossReference."Cross-Reference Type No.") > 20 then
                Message('Cannot set preferred supplier, field size is 20 instead Cross-Reference Type No. length is %1 ', StrLen(ItemCrossReference."Cross-Reference Type No."))
            else begin
                Item."Vendor No." := ItemCrossReference."Cross-Reference Type No.";
                Item."Vendor Item No." := ItemCrossReference."Cross-Reference No.";
                Item."Purch. Unit of Measure" := ItemCrossReference."Unit of Measure";
                Item.Modify(true);
            end;
    end;

    procedure UpdateSignatureDishAttribute(RecItem: Record Item)
    var
        Attribute: Record Attribute;
        AttributeValue: Record "Attribute Value";
    begin
        Attribute.Get('SIGNATURE');
        if (RecItem."Item Category Code" = 'CONSIGLIATO') and (RecItem."Retail Product Code" = 'C. ORIGINALE') then begin
            AttributeValue.Init();
            AttributeValue."Link Field 1" := RecItem."No.";
            AttributeValue."Link Type" := AttributeValue."Link Type"::Item;
            AttributeValue."Attribute Value" := 'Si';
            AttributeValue."Attribute Code" := Attribute.Code;
            AttributeValue.Insert(true);
        end
        else begin
            AttributeValue.SetRange("Link Field 1", RecItem."No.");
            AttributeValue.SetRange("Attribute Code", Attribute.Code);
            AttributeValue.SetRange("Link Type", AttributeValue."Link Type"::Item);
            AttributeValue.SetRange("Attribute Value", 'Si');
            if AttributeValue.FindFirst() then begin
                AttributeValue."Attribute Value" := 'No';
                AttributeValue.Modify(true);
            end;

        end;
    end;


    [EventSubscriber(ObjectType::Table, Database::"Sales Price", 'OnAfterInsertEvent', '', true, true)]
    local procedure InsertSetDefaultPrice(Rec: Record "Sales Price"; RunTrigger: Boolean)
    begin
        if RunTrigger then
            SetDefaultPrice(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Price", 'OnAfterModifyEvent', '', true, true)]
    local procedure ModifySetDefaultPrice(Rec: Record "Sales Price"; xRec: Record "Sales Price"; RunTrigger: Boolean)
    begin
        if RunTrigger then
            SetDefaultPrice(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::Item, 'OnAfterInsertEvent', '', true, true)]
    local procedure InsertSetDefaultDimesions(Rec: Record Item; RunTrigger: Boolean)
    begin
        if RunTrigger then
            SetDefaultDimesions(Rec."No.");
    end;

    [EventSubscriber(ObjectType::Table, Database::Item, 'OnAfterModifyEvent', '', true, true)]
    local procedure InsertSignatureDishAttribute(Rec: Record Item; RunTrigger: Boolean)
    begin
        if RunTrigger then
            UpdateSignatureDishAttribute(Rec);
    end;
}