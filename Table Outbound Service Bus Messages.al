table 50102 "Outbound Service Bus Messages"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1;"Entry No.";Integer){}
        field(2;"Queue Code";Code[20])
        {
//            TableRelation = "Table Azure Service Bus Queue"
        }
        field(3;"Date and Time";DateTime){}
        field(4;UserId;Code[50]){}
        field(10;Message;Text[250]){}
        field(11;"Message Data";BLOB){}
        field(12;"Message Size";Integer){}
        field(13;"Message Uri";Text[250]){}
        field(14;"Message Id";Text[50]){}
        field(15;"Message Deleted";Boolean){}
        field(20;Processed;Boolean){}
        field(21;"Processed At";DateTime){}
        field(22;"Processed By";Code[50]){}
    }

    keys
    {
        key("Primary Key";"Entry No."){}
        key("Process Queue";"Queue Code",Processed){}
    }
    procedure SaveMessage();
    var
        FileManagement : Codeunit "File Management";
        TempBlob : Record TempBlob; //TODO Temporary???
        FileName : TextConst ENU='Message_%1.json';
    begin
        CalcFields("Message Data");

        if not "Message Data".HasValue then
            exit;
        
        //TempBlob.Blob := "Message Data";
        //FileManagement.DownloadHandler()
        
    end;   
}