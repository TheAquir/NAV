table 50100 "Azure Service Bus Queue"
{
    DataClassification = ToBeClassified;
    //TODO Add CaptionMLs
    fields
    {
        field(1;"Code";Code[20]){
            NotBlank = true;
        }
        field(2;Namespace;Text[250]){}
        field(3;URL;Text[250]){}
        field(10;"Key Name";Text[100]){}
        field(11;"Key";Text[100]){}
        field(20;Token;Text[100]){}
        field(21;"Token Expiry";DateTime){}
        field(30;"Delete Messages";Boolean){}
    }

    keys
    {
        key("Primary Key";Code)
        {
            Clustered = true;
        }
    }
}