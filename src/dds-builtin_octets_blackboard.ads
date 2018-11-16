with Dds.Topic_Blackboard_Generic;
with DDS.Builtin_Octets_DataReader;
with DDS.Builtin_Octets_DataWriter;
with DDS.Builtin_Octets_TypeSupport;
package DDS.Builtin_Octets_Blackboard is new Dds.Topic_Blackboard_Generic
  (Treats      => DDS.Builtin_Octets_TypeSupport.Treats,
   Data_Writer => DDS.Builtin_Octets_DataWriter,
   Data_Reader => DDS.Builtin_Octets_DataReader,
   Default     => DDS.NULL_Octets'Access);
