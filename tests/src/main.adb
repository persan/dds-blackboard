with Ada.Text_IO;
with DDS.Builtin_String_Blackboard;
with DDS.DomainParticipantFactory;
with DDS.DomainParticipant;
procedure Main is
   Factory     : DDS.DomainParticipantFactory.Ref_Access := DDS.DomainParticipantFactory.Get_Instance;
   Participant : DDS.DomainParticipant.Ref_Access := Factory.Create_Participant (1);
   BB          : DDS.Builtin_String_Blackboard.Blackboard_Access := DDS.Builtin_String_Blackboard.Create (Participant, "TESTTOPIC");
   Data        : DDS.String;
begin
   Ada.Text_IO.Put_Line ("GO");
   BB.Read (Data);
   Ada.Text_IO.Put_Line (DDS.To_Standard_String (Data));
   BB.Write (DDS.To_DDS_String ("FOPPA"));
   Ada.Text_IO.Put_Line (DDS.To_Standard_String (Data));
   delay 1.0;
   Ada.Text_IO.Put_Line ("Done");
end Main;
