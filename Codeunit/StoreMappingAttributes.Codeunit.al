Codeunit 59138 StoreMappingAttributes
{
    local procedure InsertStoreMappingAttribute(StatusLink: Record "Item Status Link")
    var
        NewAttribute: Record "Attribute Value";
        AttributeList: Record "Attribute Value";
    begin
        NewAttribute.Init();
        NewAttribute."Link Field 1" := StatusLink."Item No.";
        NewAttribute."Link Type" := NewAttribute."Link Type"::Item;
        NewAttribute."Attribute Value" := StatusLink."Location Code";
        NewAttribute."Numeric Value" := 0;
        NewAttribute."Attribute Code" := 'STORE_MAPPING';
        AttributeList.SetFilter("Attribute Code", 'STORE_MAPPING');
        AttributeList.SetFilter("Link Field 1", NewAttribute."Link Field 1");
        AttributeList.SetAscending("Sequence", false);
        if AttributeList.FindFirst() then NewAttribute.Sequence := AttributeList.Sequence + 1;
        NewAttribute.Validate("Link Field 1");
        NewAttribute.Insert();
    end;

    local procedure DeleteStoreMappingAttribute(StatusLink: Record "Item Status Link")
    var
        AttributeList: Record "Attribute Value";
    begin
        AttributeList.SetFilter("Attribute Code", 'STORE_MAPPING');
        AttributeList.SetFilter("Link Field 1", StatusLink."Item No.");
        AttributeList.SetFilter("Attribute Value", StatusLink."Location Code");
        if AttributeList.FindFirst() then AttributeList.Delete();
    end;


    [EventSubscriber(ObjectType::Table, Database::"Item Status Link", 'OnAfterInsertEvent', '', true, true)]
    local procedure InsertSM(Rec: Record "Item Status Link"; RunTrigger: Boolean)
    begin
        if Rec."Status Code" in ['ATTIVO', 'NOACQ'] then
            InsertStoreMappingAttribute(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Status Link", 'OnAfterModifyEvent', '', true, true)]
    local procedure ModifySM(Rec: Record "Item Status Link"; xRec: Record "Item Status Link"; RunTrigger: Boolean)
    begin
        if xRec."Status Code" in ['ATTIVO', 'NOACQ'] then
            DeleteStoreMappingAttribute(Rec);
        if Rec."Status Code" in ['ATTIVO', 'NOACQ'] then
            InsertStoreMappingAttribute(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Status Link", 'OnAfterDeleteEvent', '', true, true)]
    local procedure DeleteSM(Rec: Record "Item Status Link"; RunTrigger: Boolean)
    begin
        DeleteStoreMappingAttribute(Rec);
    end;



}