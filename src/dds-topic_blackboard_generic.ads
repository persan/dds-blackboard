--  ----------------------------------------------------------------------------
--
--  This blackboard is intended to be used with unkeyd topics.
--
--  ----------------------------------------------------------------------------
with DDS.Treats_Generic;
with DDS.Typed_DataReader_Generic;
with DDS.Typed_DataWriter_Generic;
with DDS.Publisher;
with DDS.Subscriber;
with Dds.DomainParticipant;
with DDS.Topic;

private with Ada.Unchecked_Deallocation;
private with GNAT.Semaphores;

generic

   with package Treats is new DDS.Treats_Generic (<>);
   with package Data_Writer is new Dds.Typed_DataWriter_Generic (Treats);
   with package Data_Reader is new Dds.Typed_DataReader_Generic (Treats);
   Default : not null access constant Treats.Data_Type;

package Dds.Topic_Blackboard_Generic is

   type Blackboard is tagged limited private;
   type Blackboard_Access is access all Blackboard'Class;

   function Create (Publisher   : not null Dds.Publisher.Ref_Access;
                    Subscriber  : not null Dds.Subscriber.Ref_Access;
                    Topic_Name  : DDS.String;
                    Reader_QoS  : DDS.DataReaderQoS := DDS.Subscriber.DATAREADER_QOS_DEFAULT;
                    Writer_QoS  : DDS.DataWriterQoS := DDS.Publisher.DATAWRITER_QOS_DEFAULT;
                    Topic_QoS   : DDS.TopicQos := DDS.DomainParticipant.TOPIC_QOS_DEFAULT)
                    return Blackboard_Access;

   function Create (Publisher   : not null Dds.Publisher.Ref_Access;
                    Subscriber  : not null Dds.Subscriber.Ref_Access;
                    Topic_Name  : DDS.String;
                    QoS_Library : DDS.String;
                    QoS_Profile : DDS.String) return Blackboard_Access;

   function Create (Participant : not null Dds.DomainParticipant.Ref_Access;
                    Topic_Name  : DDS.String;
                    Reader_QoS  : DDS.DataReaderQoS := DDS.Subscriber.DATAREADER_QOS_DEFAULT;
                    Writer_QoS  : DDS.DataWriterQoS := DDS.Publisher.DATAWRITER_QOS_DEFAULT;
                    Topic_QoS   : DDS.TopicQos := DDS.DomainParticipant.TOPIC_QOS_DEFAULT) return Blackboard_Access;

   function Create (Publisher   : not null Dds.Publisher.Ref_Access;
                    Subscriber  : not null Dds.Subscriber.Ref_Access;
                    Topic_Name  : Standard.String;
                    Reader_QoS  : DDS.DataReaderQoS := DDS.Subscriber.DATAREADER_QOS_DEFAULT;
                    Writer_QoS  : DDS.DataWriterQoS := DDS.Publisher.DATAWRITER_QOS_DEFAULT;
                    Topic_QoS   : DDS.TopicQos := DDS.DomainParticipant.TOPIC_QOS_DEFAULT)
                    return Blackboard_Access;

   function Create (Publisher   : not null Dds.Publisher.Ref_Access;
                    Subscriber  : not null Dds.Subscriber.Ref_Access;
                    Topic_Name  : Standard.String;
                    QoS_Library : Standard.String;
                    QoS_Profile : Standard.String) return Blackboard_Access;



   function Create (Publisher   : not null Dds.DomainParticipant.Ref_Access;
                    Topic_Name  : Standard.String;
                    Reader_QoS  : DDS.DataReaderQoS := DDS.Subscriber.DATAREADER_QOS_DEFAULT;
                    Writer_QoS  : DDS.DataWriterQoS := DDS.Publisher.DATAWRITER_QOS_DEFAULT;
                    Topic_QoS   : DDS.TopicQos := DDS.DomainParticipant.TOPIC_QOS_DEFAULT) return Blackboard_Access;

   function Create (Publisher   : not null Dds.DomainParticipant.Ref_Access;
                    Topic       : not null DDS.Topic.Ref_Access;
                    Reader_QoS  : DDS.DataReaderQoS := DDS.Subscriber.DATAREADER_QOS_DEFAULT;
                    Writer_QoS  : DDS.DataWriterQoS := DDS.Publisher.DATAWRITER_QOS_DEFAULT;
                    Topic_QoS   : DDS.TopicQos := DDS.DomainParticipant.TOPIC_QOS_DEFAULT) return Blackboard_Access;

   procedure Write (Self : not null access Blackboard; Data : Treats.Data_Type_Access);
   procedure Write (Self : not null access Blackboard; Data : Treats.Data_Type);
   -- Publish data on the global blackboard.

   procedure Read  (Self          : not null access Blackboard;
                    Data          : out Treats.Data_Type);

private
   type Blackboard is tagged limited record
      Reader : Data_Reader.Ref_Access;
      Writer : Data_Writer.Ref_Access;
      Topic  : DDS.Topic.Ref_Access;
   end record;
   procedure Free is new Ada.Unchecked_Deallocation (Blackboard'Class, Blackboard_Access);
end DDS.Topic_Blackboard_Generic;
