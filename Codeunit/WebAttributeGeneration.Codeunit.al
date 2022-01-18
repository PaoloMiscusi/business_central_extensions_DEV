Codeunit 59117 WebAttributeGeneration
{
    trigger OnRun()
    begin

    end;

    local procedure InsertDeleteUpdateWebAttribute(Rec: Record "Attribute Value"; ActionToDo: Text)

    var
        Attribute: Record Attribute;
        NewAttribute: Record "Attribute Value";
        AttributeType: Record "Attribute Type";
        AttributeList: Record "Attribute Value";
        WebAttributeCode: Code[20];

    begin
        Attribute.Get(rec."Attribute Code");
        AttributeType.Get(Attribute."Attribute Type ID");
        if rec."Numeric Value" = 3 then WebAttributeCode := 'WEB_ALLERGENI';
        if rec."Numeric Value" = 2 then WebAttributeCode := 'WEB_TRACCE_ALLERGENI';
        if WebAttributeCode = '' then exit;
        if ActionToDo = 'Insert' then begin
            NewAttribute.Init();
            NewAttribute."Link Field 1" := rec."Link Field 1";
            NewAttribute."Link Type" := rec."Link Type";
            NewAttribute."Attribute Value" := Attribute.Description;
            NewAttribute."Numeric Value" := 0;
            NewAttribute."Attribute Code" := WebAttributeCode;
            AttributeList.SetFilter("Attribute Code", WebAttributeCode);
            AttributeList.SetFilter("Link Field 1", NewAttribute."Link Field 1");
            AttributeList.SetAscending("Sequence", false);
            if AttributeList.FindFirst() then NewAttribute.Sequence := AttributeList.Sequence + 1;
            NewAttribute.Validate("Link Field 1");
            NewAttribute.Insert();
        end;

        if ActionToDo = 'Delete' then begin
            AttributeList.SetFilter("Attribute Code", WebAttributeCode);
            AttributeList.SetFilter("Link Field 1", rec."Link Field 1");
            AttributeList.SetFilter("Attribute Value", Attribute.Description);
            if AttributeList.FindFirst() then AttributeList.Delete();

        end;
        exit
    end;


    [EventSubscriber(ObjectType::Table, Database::"Attribute Value", 'OnAfterInsertEvent', '', true, true)]
    local procedure InsertWA(Rec: Record "Attribute Value"; RunTrigger: Boolean)

    var
        Attribute: Record Attribute;
        AttributeType: Record "Attribute Type";
    begin

        Attribute.Get(rec."Attribute Code");
        AttributeType.Get(Attribute."Attribute Type ID");

        if rec."Link Type" = rec."Link Type"::Item then
            if AttributeType.ID = 'ALLERGENI' then begin
                if rec."Numeric Value" <= 1 then exit;
                InsertDeleteUpdateWebAttribute(Rec, 'Insert');
            end;

    end;

    [EventSubscriber(ObjectType::Table, Database::"Attribute Value", 'OnAfterModifyEvent', '', true, true)]
    local procedure ModifyWA(Rec: Record "Attribute Value"; xRec: Record "Attribute Value"; RunTrigger: Boolean)

    var
        Attribute: Record Attribute;
        AttributeType: Record "Attribute Type";
    begin

        Attribute.Get(rec."Attribute Code");
        AttributeType.Get(Attribute."Attribute Type ID");
        if rec."Link Type" = rec."Link Type"::Item then
            if AttributeType.ID = 'ALLERGENI' then begin
                InsertDeleteUpdateWebAttribute(xRec, 'Delete');
                if Rec."Numeric Value" <> 1 then
                    InsertDeleteUpdateWebAttribute(Rec, 'Insert');
            end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Attribute Value", 'OnAfterDeleteEvent', '', true, true)]
    local procedure DeleteWA(Rec: Record "Attribute Value"; RunTrigger: Boolean)

    var
        Attribute: Record Attribute;
        AttributeType: Record "Attribute Type";
    begin

        Attribute.Get(rec."Attribute Code");
        AttributeType.Get(Attribute."Attribute Type ID");

        if rec."Link Type" = rec."Link Type"::Item then
            if AttributeType.ID = 'ALLERGENI' then
                InsertDeleteUpdateWebAttribute(Rec, 'Delete');

    end;


}