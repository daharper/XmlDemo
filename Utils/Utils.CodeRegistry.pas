unit Utils.CodeRegistry;

interface

uses
  System.Generics.Collections;

type
  TXmlDemo = (
    xdCar = 0,
    xdCar2,
    xdCar3,
    xdCustomer,
    xdCustomer2,
    xdUsers,
    xdMessageStanza,
    xdPresenceStanza,
    xdIqStanza,
    xdConfigFile,
    xdCustomerOrder,
    xdDelphiAST,
    xdPom,
    xdIsapi
  );

  TCodeRegistry = class
  strict private
    fPath: string;
    fXml:  TDictionary<TXmlDemo, string>;
    fCode: TDictionary<TXmlDemo, string>;
  private
    class var fInstance: TCodeRegistry;

    function GetPath(const aName: string): string;
    function GetCode(const aDemo: TXmlDemo): string;
    function GetXml(const aDemo: TXmlDemo): string;

    procedure SetCode(const aDemo: TXmlDemo; const aValue: string);
    procedure SetXml(const aDemo: TXmlDemo; const aValue: string);

    procedure BuildCar;
    procedure BuildCar2;
    procedure BuildCar3;
    procedure BuildCustomer;
    procedure BuildCustomer2;
    procedure BuildUsers;
    procedure BuildMessageStanza;
    procedure BuildPresenceStanza;
    procedure BuildIqStanza;
    procedure BuildConfigFile;
    procedure BuildCustomerOrder;
    procedure BuildFromFile(const aDescription: string; const aFilename: string; const aDemo: TXmlDemo);
  public
    property Xml[const aDemo:TXmlDemo]:   string read GetXml write SetXml;
    property Code[const aDemo: TXmlDemo]: string read GetCode write SetCode;

    constructor Create;
    destructor Destroy; override;

    class constructor Create;
    class destructor Destroy;
  end;

  TSysUser = record
    Id: Integer;
    Name: string;
    IsActive: Boolean;
  end;

  function CodeRegistry: TCodeRegistry;

var
  SysUsers: array[0..4] of TSysUser = (
    (Id: 1; Name: 'Alice'; IsActive: True),
    (Id: 2; Name: 'Bob'; IsActive: False),
    (Id: 3; Name: 'Charlie'; IsActive: True),
    (Id: 4; Name: 'Diana'; IsActive: True),
    (Id: 5; Name: 'Ethan'; IsActive: False)
  );

implementation

uses
  System.SysUtils,
  System.IOUtils,
  Base.Integrity,
  Base.XML;

{----------------------------------------------------------------------------------------------------------------------}
function CodeRegistry: TCodeRegistry;
begin
  Result := TCodeRegistry.fInstance;
end;

{ TCodeRegistry }

{----------------------------------------------------------------------------------------------------------------------}
procedure TCodeRegistry.BuildCar;
const
  CODE = '''
         { simple case }

         var car := TXml.New('car');

         car.id    := 'CAR-1001';
         car.make  := 'Toyota';
         car.model := 'Corolla';
         car.year  := 2022;
         car.color := 'Blue';
         car.reg   := 'AB12 CDE';

         var xml := car.AsPrettyXml;
         ''';
begin
  var car := TXml.New('car');

  car.id    := 'CAR-1001';
  car.make  := 'Toyota';
  car.model := 'Corolla';
  car.year  := 2022;
  car.color := 'Blue';
  car.reg   := 'AB12 CDE';

  var xml := car.AsPrettyXml;

  fXml.Add(xdCar, xml);
  fCode.Add(xdCar, CODE);
end;

{----------------------------------------------------------------------------------------------------------------------}
procedure TCodeRegistry.BuildCar2;
const
  CODE = '''
         { simple case with an attribute, option 1 - push an attribute }

         var car := TXml.New('car');

         car.A('id', 'CAR-1001');

         car.make  := 'Toyota';
         car.model := 'Corolla';
         car.year  := 2022;
         car.color := 'Blue';
         car.reg   := 'AB12 CDE';

         var xml := car.AsPrettyXml;
         ''';
begin
  var car := TXml.New('car');

  car.A('id', 'CAR-1001');

  car.make  := 'Toyota';
  car.model := 'Corolla';
  car.year  := 2022;
  car.color := 'Blue';
  car.reg   := 'AB12 CDE';

  var xml := car.AsPrettyXml;

  fXml.Add(xdCar2, xml);
  fCode.Add(xdCar2, CODE);
end;

{----------------------------------------------------------------------------------------------------------------------}
procedure TCodeRegistry.BuildCar3;
const
  CODE = '''
         { simple case with an attribute, option 2 - use an "envelope" element }

         var _ := TXml.New;

         _.car['id'] := 'CAR-1001';

         _.car.make  := 'Toyota';
         _.car.model := 'Corolla';
         _.car.year  := 2022;
         _.car.color := 'Blue';
         _.car.reg   := 'AB12 CDE';

         var xml := _.car.AsPrettyXml;
         ''';
begin
  var _ := TXml.New;

  _.car['id'] := 'CAR-1001';

  _.car.make  := 'Toyota';
  _.car.model := 'Corolla';
  _.car.year  := 2022;
  _.car.color := 'Blue';
  _.car.reg   := 'AB12 CDE';

  var xml := _.car.AsPrettyXml;

  fXml.Add(xdCar3, xml);
  fCode.Add(xdCar3, CODE);
end;

{----------------------------------------------------------------------------------------------------------------------}
procedure TCodeRegistry.BuildCustomer;
const
  CODE = '''
         { simple case with an attribute, option 3 - use an envelope with variable }

         var _ := TXml.New;

         _.customer['id']     := 'CUST-10482';
         _.customer['status'] := 'active';

         var c := _.customer;

         c.FirstName := 'Jane';
         c.LastName  := 'Doe';
         c.Email     := 'jane.doe@example.com';
         c.Phone     := '+44-20-7946-0958';
         c.Company   := 'Acme Industries Ltd';
         c.Tier      := 'gold';

         var xml := c.AsPrettyXml;
         ''';
begin
  var _ := TXml.New;

  _.customer['id']     := 'CUST-10482';
  _.customer['status'] := 'active';

  var c := _.customer;

  c.FirstName := 'Jane';
  c.LastName  := 'Doe';
  c.Email     := 'jane.doe@example.com';
  c.Phone     := '+44-20-7946-0958';
  c.Company   := 'Acme Industries Ltd';
  c.Tier      := 'gold';

  var xml := c.AsPrettyXml;

  fXml.Add(xdCustomer, xml);
  fCode.Add(xdCustomer, CODE);
end;

{----------------------------------------------------------------------------------------------------------------------}
procedure TCodeRegistry.BuildCustomer2;
const
  CODE = '''
         { simple case with an attribute, option 4 - push attributes with variable }

         var c := TXml.New('customer');

         c.A('id','CUST-10482').A('status', 'active');

         c.FirstName := 'Jane';
         c.LastName  := 'Doe';
         c.Email     := 'jane.doe@example.com';
         c.Phone     := '+44-20-7946-0958';
         c.Company   := 'Acme Industries Ltd';
         c.Tier      := 'gold';

         var xml := c.AsPrettyXml;
         ''';
begin
  var c := TXml.New('customer');

  c.A('id','CUST-10482').A('status', 'active');

  c.FirstName := 'Jane';
  c.LastName  := 'Doe';
  c.Email     := 'jane.doe@example.com';
  c.Phone     := '+44-20-7946-0958';
  c.Company   := 'Acme Industries Ltd';
  c.Tier      := 'gold';

  var xml := c.AsPrettyXml;

  fXml.Add(xdCustomer2, xml);
  fCode.Add(xdCustomer2, CODE);
end;

{----------------------------------------------------------------------------------------------------------------------}
procedure TCodeRegistry.BuildUsers;
const
  CODE = '''
         { Building a list of users }

         var users := TXml.New('Users');

         for var SysUser in SysUsers do
         begin
           var user := TXml.New('User');

           user.Id       := SysUser.Id;
           user.UserName := SysUser.Name;
           user.Active   := SysUser.IsActive;

           users.Add(user);
         end;

         var xml := users.AsPrettyXml;
         ''';
begin
  var users := TXml.New('Users');

  for var SysUser in SysUsers do
  begin
    var user := TXml.New('User');

    user.Id       := SysUser.Id;
    user.UserName := SysUser.Name;
    user.Active   := SysUser.IsActive;

    users.Add(user);
  end;

  var xml := users.AsPrettyXml;

  fXml.Add(xdUsers, xml);
  fCode.Add(xdUsers, CODE);
end;

{----------------------------------------------------------------------------------------------------------------------}
procedure TCodeRegistry.BuildMessageStanza;
const
  CODE = '''
         { XMPP Message Stanza }

         var _ := TXml.New;

         _.message['from'] := 'juliet@capulet.lit/laptop';
         _.message['to']   := 'romeo@montague.lit/phone';
         _.message['type'] := 'chat';
         _.message['id']   := 'msg-1234';

         _.message.body    := 'Running a little late - meet me at the cafe?';
         _.message.thread  := 'chat-9fbb7c';

         var xml := _.message.AsPrettyXml;
         ''';
begin
  var _ := TXml.New;

  _.message['from'] := 'juliet@capulet.lit/laptop';
  _.message['to']   := 'romeo@montague.lit/phone';
  _.message['type'] := 'chat';
  _.message['id']   := 'msg-1234';

  _.message.body    := 'Running a little late - meet me at the cafe?';
  _.message.thread  := 'chat-9fbb7c';

  var xml := _.message.AsPrettyXml;

  fXml.Add(xdMessageStanza, xml);
  fCode.Add(xdMessageStanza, CODE);
end;

{----------------------------------------------------------------------------------------------------------------------}
procedure TCodeRegistry.BuildPresenceStanza;
const
  CODE = '''
         { XMPP Presence Stanza }

         var p := TXml.New('presence');

         p.A('xlmns', 'jabber:client')
          .A('from',  'juliet@capulet.lit/laptop')
          .A('id',    'p-73ab92f1');

         p.show        := 'chat';
         p.status      := 'At the cafe, available to chat.';
         p.priority    := 10;

         p.c['xmlns']  := 'http://jabber.org/protocol/caps';
         p.c['hash']   := 'sha-1';
         p.c['node']   := 'https://example.com/client';
         p.c['ver']    := 'QgayPKawpkPSDYmwT/WM94uAlu0=';

         var xml := p.AsPrettyXml;
         ''';
begin
  var p := TXml.New('presence');

  p.A('xlmns', 'jabber:client')
   .A('from',  'juliet@capulet.lit/laptop')
   .A('id',    'p-73ab92f1');

  p.show        := 'chat';
  p.status      := 'At the cafe, available to chat.';
  p.priority    := 10;

  p.c['xmlns']  := 'http://jabber.org/protocol/caps';
  p.c['hash']   := 'sha-1';
  p.c['node']   := 'https://example.com/client';
  p.c['ver']    := 'QgayPKawpkPSDYmwT/WM94uAlu0=';

  var xml := p.AsPrettyXml;

  fXml.Add(xdPresenceStanza, xml);
  fCode.Add(xdPresenceStanza, CODE);
end;

{----------------------------------------------------------------------------------------------------------------------}
procedure TCodeRegistry.BuildIqStanza;
const
  CODE = '''
         { XMPP IQ Stanza }

         var iq := TXml.New('iq');

         iq.A('from', 'crm.example.com')
           .A('to',   'agent@example.com/console')
           .A('type', 'result')
           .A('id',   'cust-001');

         iq.query['xmlns'] := 'urn:example:crm:customer';

         var cust := iq.query.customer;

         cust.A('id',     'CUST-10482')
             .A('status', 'active')
             .A('tier',   'gold');

         cust.company := 'Acme Industries Ltd';

         var contact := cust.contact;

         contact.first := 'Jane';
         contact.last := 'Doe';
         contact.email := 'jane.doe@acme.example';
         contact.phone := '+44-20-7946-0958';

         var address := cust.address;

         address.street   := '42 Market Street';
         address.locality := 'London';
         address.region   := 'Greater London';
         address.postcode := 'EC1A 1AA';
         address.country  := 'GB';

         cust.manager  := 'Sophie Smith';
         cust.created  := Now;
         cust.currency := 'GBP';
         cust.sales    := 18420.75;
         cust.notes    := 'Prefers invoice by email. Priority support enabled.';

         var xml := iq.AsPrettyXml;
         ''';
begin
  var iq := TXml.New('iq');

  iq.A('from', 'crm.example.com')
    .A('to',   'agent@example.com/console')
    .A('type', 'result')
    .A('id',   'cust-001');

  iq.query['xmlns'] := 'urn:example:crm:customer';

  var cust := iq.query.customer;

  cust.A('id',     'CUST-10482')
      .A('status', 'active')
      .A('tier',   'gold');

  cust.company := 'Acme Industries Ltd';

  var contact := cust.contact;

  contact.first := 'Jane';
  contact.last := 'Doe';
  contact.email := 'jane.doe@acme.example';
  contact.phone := '+44-20-7946-0958';

  var address := cust.address;

  address.street   := '42 Market Street';
  address.locality := 'London';
  address.region   := 'Greater London';
  address.postcode := 'EC1A 1AA';
  address.country  := 'GB';

  cust.manager  := 'Sophie Smith';
  cust.created  := Now;
  cust.currency := 'GBP';
  cust.sales    := 18420.75;
  cust.notes    := 'Prefers invoice by email. Priority support enabled.';

  var xml := iq.AsPrettyXml;

  fXml.Add(xdIqStanza, xml);
  fCode.Add(xdIqStanza, CODE);
end;

{----------------------------------------------------------------------------------------------------------------------}
procedure TCodeRegistry.BuildConfigFile;
const
  CODE = '''
         { C# App.config via DSL and Fluent Builder mixed approach }

         var _ := TXml.New;

         var config := _.configuration;

         config.appSettings
                 .E('add')
                   .A('key', 'Environment')
                   .A('value', 'Production').Up
                 .E('add')
                   .A('key', 'ApiBaseUrl')
                   .A('value', 'https://api.example.com/').Up
                 .E('add')
                   .A('key', 'EnableVerboseLogging')
                   .A('value', 'false');

         config.connectionStrings
               .E('add')
                 .A('name', 'customerDb')
                 .A('connectionString', 'Server=sql01.example.com;Database=CustomerDb;Integrated Security=True;')
                 .A('providerName', 'System.Data.SqlClient');

         config.E('system.net')
                 .E('mailSettings')
                   .E('smtp').A('from','noreply@example.com')
                     .E('network')
                       .A('host', 'smtp.example.com')
                       .A('port', '587')
                       .A('userName', 'smtp-user')
                       .A('password', 'smtp-password')
                       .A('enableSsl', 'true');

         config.runtime.assemblyBinding
                         .A('xmlns', 'urn:schemas-microsoft-com:asm.v1')
                         .probing
                           .A('privatePath', 'bin;plugins');

         config.startup.supportedRuntime
                         .A('version', '4.0')
                         .A('sku', '.NETFramework,Version=v4.8');

         var xml := config.AsPrettyXml;
         ''';
begin
  var _ := TXml.New;

  var config := _.configuration;

  config.appSettings
          .E('add')
            .A('key', 'Environment')
            .A('value', 'Production').Up
          .E('add')
            .A('key', 'ApiBaseUrl')
            .A('value', 'https://api.example.com/').Up
          .E('add')
            .A('key', 'EnableVerboseLogging')
            .A('value', 'false');

  config.connectionStrings
        .E('add')
          .A('name', 'customerDb')
          .A('connectionString', 'Server=sql01.example.com;Database=CustomerDb;Integrated Security=True;')
          .A('providerName', 'System.Data.SqlClient');

  config.E('system.net')
          .E('mailSettings')
            .E('smtp').A('from','noreply@example.com')
              .E('network')
                .A('host', 'smtp.example.com')
                .A('port', '587')
                .A('userName', 'smtp-user')
                .A('password', 'smtp-password')
                .A('enableSsl', 'true');

  config.runtime.assemblyBinding
                  .A('xmlns', 'urn:schemas-microsoft-com:asm.v1')
                  .probing
                    .A('privatePath', 'bin;plugins');

  config.startup.supportedRuntime
                  .A('version', '4.0')
                  .A('sku', '.NETFramework,Version=v4.8');

  var xml := config.AsPrettyXml;

  fXml.Add(xdConfigFile, xml);
  fCode.Add(xdConfigFile, CODE);
end;

{----------------------------------------------------------------------------------------------------------------------}
procedure TCodeRegistry.BuildCustomerOrder;
const
  CODE = '''
         { Customer Order via a Fluent Builder only approach }

         var _ := TXml.New;

         _.E('customerOrder').A('orderId', 'ORD-2026-00421').A('status', 'confirmed')
            .E('customer').A('customerId', 'CUST-10482')
              .Pe('name', 'Jane Doe')
              .Pe('email', 'jane.doe@example.com')
              .Pe('phone', '+44-20-7946-0958').Up
            .E('billingAddress')
              .Pe('line1', '42 Market Street')
              .Pe('city', 'London')
              .Pe('postCode', 'EC1A 1AA')
              .Pe('country', 'GB').Up
            .E('items')
              .E('item').A('sku','SKU-1001').A('quantity', '2')
                .Pe('description', 'Wireless Headset')
                .E('unitPrice', '79.99').A('currency', 'GBP').Up.Up
              .E('item').A('sku','SKU-2040').A('quantity', '1')
                .Pe('description', 'USB-C Dock')
                .E('unitPrice', '129.50').A('currency', 'GBP').Up.Up
            .E('totals')
              .E('subtotal', '289.48').A('currency', 'GBP').Up
              .E('tax', '57.90').A('currency', 'GBP').Up
              .E('total', '347.38').A('currency', 'GBP').Up.Up
            .E('createdAt', DateTimeToStr(Now));

         var xml := _.customerOrder.AsPrettyXml;
         ''';
begin
  var _ := TXml.New;

  _.E('customerOrder').A('orderId', 'ORD-2026-00421').A('status', 'confirmed')
     .E('customer').A('customerId', 'CUST-10482')
       .Pe('name', 'Jane Doe')
       .Pe('email', 'jane.doe@example.com')
       .Pe('phone', '+44-20-7946-0958').Up
     .E('billingAddress')
       .Pe('line1', '42 Market Street')
       .Pe('city', 'London')
       .Pe('postCode', 'EC1A 1AA')
       .Pe('country', 'GB').Up
     .E('items')
       .E('item').A('sku','SKU-1001').A('quantity', '2')
         .Pe('description', 'Wireless Headset')
         .E('unitPrice', '79.99').A('currency', 'GBP').Up.Up
       .E('item').A('sku','SKU-2040').A('quantity', '1')
         .Pe('description', 'USB-C Dock')
         .E('unitPrice', '129.50').A('currency', 'GBP').Up.Up
     .E('totals')
       .E('subtotal', '289.48').A('currency', 'GBP').Up
       .E('tax', '57.90').A('currency', 'GBP').Up
       .E('total', '347.38').A('currency', 'GBP').Up.Up
     .E('createdAt', DateTimeToStr(Now));

  var xml := _.customerOrder.AsPrettyXml;

  fXml.Add(xdCustomerOrder, xml);
  fCode.Add(xdCustomerOrder, CODE);
end;

{----------------------------------------------------------------------------------------------------------------------}
procedure TCodeRegistry.BuildFromFile(const aDescription: string; const aFilename: string; const aDemo: TXmlDemo);
const
  CODE = '''
         { Loading %s file into an IBvElement }

          var load := TXml.Load('%s');

          Ensure.True(load.IsOk, load.Error);

          var e := load.Value;

          var xml := e.AsPrettyXml;
         ''';
var
  xml: string;
begin
  var path := GetPath(aFilename);
  var load := TXml.Load(path);

  if load.IsErr then
    xml := load.Error
  else
    xml := TFile.ReadAllText(path);

  fXml.Add(aDemo, xml);
  fCode.Add(aDemo, Format(CODE, [aDescription, path]));
end;


{----------------------------------------------------------------------------------------------------------------------}
function TCodeRegistry.GetCode(const aDemo: TXmlDemo): string;
begin
  fCode.TryGetValue(aDemo, Result);
end;

{----------------------------------------------------------------------------------------------------------------------}
procedure TCodeRegistry.SetCode(const aDemo: TXmlDemo; const aValue: string);
begin
  fCode[aDemo] := aValue;
end;

{----------------------------------------------------------------------------------------------------------------------}
function TCodeRegistry.GetPath(const aName: string): string;
begin
  Result := TPath.Combine(fPath, aName);
end;

{----------------------------------------------------------------------------------------------------------------------}
function TCodeRegistry.GetXml(const aDemo: TXmlDemo): string;
begin
  fXml.TryGetValue(aDemo, Result);
end;

{----------------------------------------------------------------------------------------------------------------------}
procedure TCodeRegistry.SetXml(const aDemo: TXmlDemo; const aValue: string);
begin
  fXml[aDemo] := aValue;
end;

{----------------------------------------------------------------------------------------------------------------------}
constructor TCodeRegistry.Create;
begin
  fPath := TPath.Combine(ExtractFileDir(ParamStr(0)), 'Xml');

  fXml  := TDictionary<TXmlDemo, string>.Create;
  fCode := TDictionary<TXmlDemo, string>.Create;

  BuildCar;
  BuildCar2;
  BuildCar3;
  BuildCustomer;
  BuildCustomer2;
  BuildUsers;
  BuildMessageStanza;
  BuildPresenceStanza;
  BuildIqStanza;
  BuildConfigFile;
  BuildCustomerOrder;

  BuildFromFile('a DelphiAST XML', 'DelphiAST.Xml', xdDelphiAST);
  BuildFromFile('a Spring Cloud maven', 'pom.xml', xdPom);
  BuildFromFile('a Visual C++ ATL ISAPI project', 'VsIsapiProjectFile.xml', xdIsapi);
end;

{----------------------------------------------------------------------------------------------------------------------}
destructor TCodeRegistry.Destroy;
begin
  fXml.Free;
  fCode.Free;
end;

{----------------------------------------------------------------------------------------------------------------------}
class constructor TCodeRegistry.Create;
begin
  fInstance := TCodeRegistry.Create;
end;

{----------------------------------------------------------------------------------------------------------------------}
class destructor TCodeRegistry.Destroy;
begin
  FreeAndNil(fInstance);
end;

end.
