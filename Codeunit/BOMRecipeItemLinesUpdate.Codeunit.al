codeunit 59104 BOMRecipeItemLinesUpdate
{
    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Table, Database::Item, 'OnAfterModifyEvent', '', true, true)]
    local procedure UpdateBOMDescription(Rec: Record Item; xRec: Record Item; RunTrigger: Boolean)
    var
        Ingredients: Record "BOM Component";
    begin
        if Rec.Description <> xRec.Description then begin
            Ingredients.Reset();
            Ingredients.SetFilter("No.", Rec."No.");
            if Ingredients.FindSet() then
                repeat
                    Ingredients.Description := Rec.Description;
                    Ingredients.Modify(true);
                until Ingredients.Next() <= 0;
        end;
    end;
}