with Dds.Topic_Blackboard_Generic;
with DDS.Builtin_String_DataReader;
with DDS.Builtin_String_DataWriter;
with DDS.Builtin_String_TypeSupport;
package DDS.Builtin_String_Blackboard is new Dds.Topic_Blackboard_Generic
  (Treats      => DDS.Builtin_String_TypeSupport.Treats,
   Data_Writer => DDS.Builtin_String_DataWriter,
   Data_Reader => DDS.Builtin_String_DataReader,
   Default     => DDS.NULL_STRING'Access);
