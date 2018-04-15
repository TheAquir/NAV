page 50100 "Azure Service Bus Queue"
{
    PageType = List;
    SourceTable = "Azure Service Bus Queue";

    layout
    {
        area(content) //TODO Repeater????
        {
            group(GroupName)
            {
                field("Code";Code){}
                field(Namespace;Namespace){}
                field(URL;URL){}
                field("Key Name";"Key Name"){}
                field("Key";"Key"){}
                field(Token;Token){}
                field("Token Expiry";"Token Expiry"){}
                field("Delete Messages";"Delete Messages"){}
            }
        }
    }
}