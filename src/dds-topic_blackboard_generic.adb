pragma Ada_2012;
with DDS.DataWriter;
with DDS.DataReader;
with Ada.Exceptions;
package body Dds.Topic_Blackboard_Generic is
   use type Dds.Topic.Ref_Access;
   ------------
   -- Create --
   ------------
   function Create
     (Publisher   : not null Dds.Publisher.Ref_Access;
      Subscriber  : not null Dds.Subscriber.Ref_Access;
      Topic_Name  : DDS.String;
      Reader_QoS  : DDS.DataReaderQoS := DDS.Subscriber.DATAREADER_QOS_DEFAULT;
      Writer_QoS  : DDS.DataWriterQoS := DDS.Publisher.DATAWRITER_QOS_DEFAULT;
      Topic_QoS   : DDS.TopicQos := DDS.DomainParticipant.TOPIC_QOS_DEFAULT)
      return Blackboard_Access
   is
      Ret           : Blackboard_Access := new Blackboard;
      Created_Topic : Boolean := False;
      L_Reader_QoS  : DDS.DataReaderQoS;

   begin
      Dds.Copy (L_Reader_QoS, Reader_QoS);
      if Publisher.Get_Participant /= Subscriber.Get_Participant then
         raise Program_Error with "Publisher and Subscriber belongs to defferent participants";
      end if;
      Ret.Topic := Publisher.Get_Participant.Find_Topic (Topic_Name, Timeout => To_Duration_T (0.01));
      if Ret.Topic = null then
         Ret.Topic := Publisher.Get_Participant.Create_Topic (Topic_Name, Treats.Get_Type_Name, Topic_QoS);
         Created_Topic := True;
      end if;

      L_Reader_QoS.Resource_Limits.Max_Samples_Per_Instance := 1;
      L_Reader_QoS.History.Depth := 1;
      L_Reader_QoS.Resource_Limits.Max_Instances := 1;
      L_Reader_QoS.History.Kind := DDS.KEEP_LAST_HISTORY_QOS;

      Ret.Reader := Data_Reader.Ref_Access (Subscriber.Create_DataReader (Ret.Topic.As_TopicDescription, L_Reader_QoS));
      Ret.Writer := Data_Writer.Ref_Access (Publisher.Create_DataWriter (Ret.Topic, Writer_QoS));
      return Ret;
   exception
      when others =>
         if Created_Topic then
            Publisher.Get_Participant.Delete_Topic (Ret.Topic);
         end if;
         Publisher.Delete_DataWriter (DDS.DataWriter.Ref_Access (Ret.Writer));
         Subscriber.Delete_DataReader (DDS.DataReader.Ref_Access (Ret.Reader));
         Free (Ret);
         raise;
   end Create;

   ------------
   -- Create --
   ------------

   function Create
     (Publisher   : not null Dds.Publisher.Ref_Access;
      Subscriber  : not null Dds.Subscriber.Ref_Access;
      Topic_Name  : DDS.String;
      QoS_Library : DDS.String;
      QoS_Profile : DDS.String)
      return Blackboard_Access
   is
      Ret           : Blackboard_Access := new Blackboard;
      Created_Topic : Boolean := False;
   begin
      if Publisher.Get_Participant /= Subscriber.Get_Participant then
         raise Program_Error with "Publisher and Subscriber belongs to defferent participants";
      end if;

      Ret.Topic := Publisher.Get_Participant.Find_Topic (Topic_Name, Timeout => To_Duration_T (0.01));
      if Ret.Topic = null then
         Ret.Topic := Publisher.Get_Participant.Create_Topic_With_Profile (Topic_Name, Treats.Get_Type_Name, QoS_Library, QoS_Profile);
         Created_Topic := True;
      end if;
      Ret.Reader := Data_Reader.Ref_Access (Subscriber.Create_DataReader_With_Profile (Ret.Topic.As_TopicDescription, QoS_Library, QoS_Profile));
      Ret.Writer := Data_Writer.Ref_Access (Publisher.Create_DataWriter_With_Profile (Ret.Topic, QoS_Library, QoS_Profile));
      return Ret;
   exception
      when others =>
         if Created_Topic then
            Publisher.Get_Participant.Delete_Topic (Ret.Topic);
         end if;
         Publisher.Delete_DataWriter (DDS.DataWriter.Ref_Access (Ret.Writer));
         Subscriber.Delete_DataReader (DDS.DataReader.Ref_Access (Ret.Reader));
         Free (Ret);
         raise;
   end Create;

   ------------
   -- Create --
   ------------

   function Create
     (Participant   : not null Dds.DomainParticipant.Ref_Access;
      Topic_Name    : DDS.String;
      Reader_QoS    : DDS.DataReaderQoS := DDS.Subscriber.DATAREADER_QOS_DEFAULT;
      Writer_QoS    : DDS.DataWriterQoS := DDS.Publisher.DATAWRITER_QOS_DEFAULT;
      Topic_QoS     : DDS.TopicQos := DDS.DomainParticipant.TOPIC_QOS_DEFAULT)
      return Blackboard_Access
   is
      Ret           : Blackboard_Access := new Blackboard;
      Created_Topic : Boolean := False;
   begin
      return Create (Participant.Get_Implicit_Publisher,
                     Participant.Get_Implicit_Subscriber,
                     Topic_Name,
                     Reader_QoS,
                     Writer_QoS,
                     Topic_QoS);
   end Create;

   ------------
   -- Create --
   ------------

   function Create
     (Publisher   : not null Dds.Publisher.Ref_Access;
      Subscriber  : not null Dds.Subscriber.Ref_Access;
      Topic_Name  : Standard.String;
      Reader_QoS  : DDS.DataReaderQoS := DDS.Subscriber.DATAREADER_QOS_DEFAULT;
      Writer_QoS  : DDS.DataWriterQoS := DDS.Publisher.DATAWRITER_QOS_DEFAULT;
      Topic_QoS   : DDS.TopicQos := DDS.DomainParticipant.TOPIC_QOS_DEFAULT)
      return Blackboard_Access
   is
      Name : Dds.String := To_DDS_String (Topic_Name);
   begin
      return Ret : constant Blackboard_Access := Create (Publisher, Subscriber, Name, Reader_QoS, Writer_QoS, Topic_QoS) do
         Finalize (Name);
      end return;
   exception
      when E : others =>
         Finalize (Name);
         raise;
   end Create;


   ------------
   -- Create --
   ------------

   function Create
     (Publisher   : not null Dds.DomainParticipant.Ref_Access;
      Topic       : not null DDS.Topic.Ref_Access;
      Reader_QoS  : DDS.DataReaderQoS := DDS.Subscriber.DATAREADER_QOS_DEFAULT;
      Writer_QoS  : DDS.DataWriterQoS := DDS.Publisher.DATAWRITER_QOS_DEFAULT;
      Topic_QoS   : DDS.TopicQos := DDS.DomainParticipant.TOPIC_QOS_DEFAULT) return Blackboard_Access
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "Create unimplemented");
      return raise Program_Error with "Unimplemented function Create";
   end Create;


   -----------
   -- Write --
   -----------

   procedure Write
     (Self : not null access Blackboard;
      Data : Treats.Data_Type_Access)
   is
   begin
      Self.Write (Data.all);
   end Write;

   -----------
   -- Write --
   -----------

   procedure Write
     (Self : not null access Blackboard;
      Data : Treats.Data_Type)
   is
   begin
      Self.Writer.Write (Data, DDS.Null_InstanceHandle_T);
   end Write;

   ----------
   -- Read --
   ----------

   procedure Read
     (Self : not null access Blackboard;
      Data : out Treats.Data_Type)
   is
   begin
      for Sample of Self.Reader.Read (Max_Samples => 1) loop
         Treats.Copy (Data, Sample.Data.all);
      end loop;
   exception when others =>
         Treats.Copy (Data, Default.all);
   end Read;

end Dds.Topic_Blackboard_Generic;
