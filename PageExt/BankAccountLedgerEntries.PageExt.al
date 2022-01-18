pageextension 59106 BankAccountLedgerEntries extends "Bank Account Ledger Entries"
{
    layout
    {
        addafter("Posting Date")
        {
            field("Document Date"; Rec."Document Date")
            {
                ApplicationArea = All;
            }
        }
    }
}
