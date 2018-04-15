codeunit 50100 "Azure Service Bus Queue"
{
    trigger OnRun();
    begin
    end;

    procedure
    ReadQueue(QueueCode : Code[20]);
    var
        RequestUri : Text;
        Client : HttpClient;
        Request : HttpRequestMessage;
        Response : HttpResponseMessage;
        Headers : HttpHeaders;
        Content : HttpContent;
        ResponseStream : InStream;
        ResponseMessage : Text;
        ResponseObject : JsonObject;
        BrokerPropertiesObject : JsonObject;
        BrokerPropertiesToken : JsonToken;
        AzureServiceBusQueue : Record "Azure Service Bus Queue";
        InboundServiceQueueMessages : Record "Inbound Service Bus Messages";
        OutStream : OutStream;
        MessageUri : array[1] of Text;
        EntryNo : Integer;
        BrokerProperties : array[1] of Text;
        MessageId : Text;
        LockToken : Text;
    begin
        // https://docs.microsoft.com/en-us/rest/api/servicebus/peek-lock-message-non-destructive-read
        // https://docs.microsoft.com/en-us/rest/api/servicebus/delete-message

        if not AzureServiceBusQueue.Get(QueueCode) then
            exit;

        RequestUri := AzureServiceBusQueue.URL + '/messages/head';
        Headers.Add('ContentType','application/atom+xml;type=entry;charset=utf-8');
        Headers.Add('ContentLength','0');
        Headers.Add('Authorization',GenerateSasToken(QueueCode));
        Content.GetHeaders(Headers);
        Client.Post(RequestUri,Content,Response);

        if Response.HttpStatusCode = 200 then
        begin
            Content.Clear;
            Content := Response.Content;
            Content.ReadAs(ResponseStream);
            ResponseStream.ReadText(ResponseMessage);
            if ResponseObject.ReadFrom(ResponseMessage) then
            begin
                EntryNo := GetNextEntryNo(false);
                with InboundServiceQueueMessages do begin
                    Init;
                    "Entry No." := EntryNo;
                    "Queue Code" := QueueCode;
                    "Date and Time" := CurrentDateTime;
                    // UserId := UserSecurityId; //TODO Change UserId to UserSecurityId
                    Message := CopyStr(ResponseMessage,1,MaxStrLen(Message));
                    "Message Data".CreateOutStream(OutStream,TextEncoding::UTF8);
                    "Message Size" := StrLen(ResponseMessage);
                    Response.Headers.GetValues('Location',MessageUri);
                    "Message Uri" := MessageUri[1]; 
                    OutStream.Write(ResponseMessage,"Message Size");
                    Insert;
                end
            end
        end;

        if AzureServiceBusQueue."Delete Messages" then begin
            Response.Headers.GetValues('BrokerProperties',BrokerProperties);
            BrokerPropertiesObject.ReadFrom(BrokerProperties[1]);
            BrokerPropertiesObject.Get('LockToken',BrokerPropertiesToken);
            BrokerPropertiesToken.WriteTo(LockToken);
            BrokerPropertiesObject.Get('MessageId',BrokerPropertiesToken);
            BrokerPropertiesToken.WriteTo(MessageId);
            if ( LockToken <> '' ) and ( MessageId <> '' ) then begin
                MessageUri[1] := AzureServiceBusQueue.URL + '/messages/' + MessageId + '/' + LockToken;
            end;
            if DeleteMessage(QueueCode,MessageUri[1]) then
                if InboundServiceQueueMessages.Get(EntryNo) then
                begin
                    InboundServiceQueueMessages."Message Deleted" := true;
                    InboundServiceQueueMessages."Message Id" := MessageId;
                    InboundServiceQueueMessages.Modify;
                end
        end
    end;

    procedure
    GenerateSasToken(QueueCode : Code[20]) : Text
    begin
    end;
    
    procedure
    GetNextEntryNo(Outbound : Boolean) : Integer
    begin
    end;

    procedure
    DeleteMessage(QueueCode : Code[20];MessageUri : Text) : Boolean
    begin
    end;
}