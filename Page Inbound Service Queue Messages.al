page 50101 "Inbound Service Queue Messages"
{
    PageType = List;
    SourceTable = "Inbound Service Bus Messages";
    Editable = false;

    layout
    {
        area(content) //TODO Repeater????
        {
            group(GroupName)
            {
                field("Entry No.";"Entry No."){}
                field("Queue Code";"Queue Code"){}
                field("Date and Time";"Date and Time"){}
                field(UserId;UserId){}
                field(Message;Message){}
                field("Message Size";"Message Size"){}
                field(Processed;Processed){}
                field("Processed At";"Processed At"){}
                field("Processed By";"Processed By"){}
            }
        }
    }

    actions
    {
        // Save Message
        area(Processing)
        {
            action("Save Message")
            {
                Promoted = true;
                PromotedIsBig = true;
                Image = "Save";
                PromotedCategory = Process;
                
                trigger
                OnAction();
                begin
                    SaveMessage();
                end;
            }
        }
    }
}