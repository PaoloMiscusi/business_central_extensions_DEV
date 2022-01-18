codeunit 59002 "MSC Create Purchase Order"
{
    trigger OnRun()
    var
        varTest: Text;
        XMLvar: Text;
        FileName: text;
        InS: InStream;
    begin
        XMLvar := '';
        if UploadIntoStream('Upload XML', '', '', FileName, InS) then begin
            while not (InS.EOS) do begin
                InS.ReadText(varTest);
                XMLvar += varTest;
            end;
            CreatePurchaseOrder(XMLvar);
        end else
            error('Cannot parse XML');
    end;

    procedure CreatePurchaseOrder(XMLvar: text)
    var
        XmlDoc: XmlDocument;
        FileName: text;
        InS: InStream;
        TempBlob: Codeunit "Temp Blob";
        TempBlobTable: Record TempBlob;
        OutS: OutStream;
    begin
        TempBlobTable.WriteAsText(XMLvar, TextEncoding::UTF8);
        TempBlobTable.Blob.CreateInStream(InS, TextEncoding::UTF8);

        if XmlDocument.ReadFrom(ins, XmlDoc) then begin
            TempBlob.CreateOutStream(OutS);
            XmlDoc.WriteTo(OutS);
            TempBlob.CreateInStream(InS);
            XMLBuffer.LoadFromStream(InS);

            ReadData();
        end;
    end;

    local procedure ReadData()
    var
        PurchHeader: record "Purchase Header";
        PurchLine: Record "Purchase Line";
        LineNo: Integer;
        decimalVar: Decimal;
        dateVar: Date;
    begin
        repeat
            case xmlbuffer.name of
                'VendorNo':
                    begin
                        PurchHeader.init;
                        PurchHeader.Validate("Document Type", PurchHeader."Document Type"::Order);
                        PurchHeader.Validate(Status, PurchHeader.Status::Open);
                        PurchHeader.Validate("Buy-from Vendor No.", XMLBuffer.value);
                        PurchHeader.Insert(true);
                    end;
                'DocumentDate':
                    begin
                        Evaluate(dateVar, XMLBuffer.Value);
                        PurchHeader.Validate("Document Date", dateVar);
                        PurchHeader.Modify(true);
                    end;
                'PostingDate':
                    begin
                        Evaluate(dateVar, XMLBuffer.Value);
                        PurchHeader.Validate("Posting Date", dateVar);
                        PurchHeader.Modify(true);
                    end;
                'No':
                    begin
                        PurchLine.init;
                        LineNo += 10000;
                        PurchLine.Validate("Document Type", PurchHeader."Document Type");
                        PurchLine.validate("Document No.", PurchHeader."No.");
                        PurchLine.Validate(Type, PurchLine.Type::Item);
                        PurchLine."Line No." := LineNo;
                        PurchLine.Insert(true);

                        PurchLine.Validate("No.", xmlbuffer.Value);
                        PurchLine.Modify(true);
                    end;
                'Quantity':
                    begin
                        Evaluate(decimalVar, XMLBuffer.Value);
                        PurchLine.Validate(Quantity, decimalVar);
                        PurchLine.Modify(true);
                    end;
            end;
        until XMLBuffer.Next() = 0;
    end;

    var
        XMLBuffer: record "XML Buffer" temporary;
}