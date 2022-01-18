Codeunit 59139 SetBirthday
{
    procedure SetBirthdayWeek(Contact: Code[20]; Account: Code[20]; AttributeValue: Text[20]);
    var
        NewAttribute: Record "Member Attribute Value";
        Attributes: Record "Member Attribute Value";
    begin
        if Attributes.Get('LOYALTY', Account, Contact, 'WEEK_BD') then begin
            Attributes."Attribute Value" := AttributeValue;
            Attributes.Modify(true);
        end
        else begin
            NewAttribute.Init();
            NewAttribute."Account No." := Account;
            NewAttribute."Contact No." := Contact;
            NewAttribute."Attribute Code" := 'WEEK_BD';
            NewAttribute."Attribute Value" := AttributeValue;
            NewAttribute."Club Code" := 'LOYALTY';
            NewAttribute.Insert(true);
        end;


    end;
}