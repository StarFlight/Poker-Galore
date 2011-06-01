// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)
package com.cubeia.firebase.io.protocol {

    import com.cubeia.firebase.io.PacketInputStream;
    import com.cubeia.firebase.io.PacketOutputStream;
    import com.cubeia.firebase.io.ProtocolObject;
  
    import flash.utils.ByteArray;

    public final class ParameterFilterEnum
    {
        public static const EQUALS:int = 0;
        public static const GREATER_THAN:int = 1;
        public static const SMALLER_THAN:int = 2;
        public static const EQUALS_OR_GREATER_THAN:int = 3;
        public static const EQUALS_OR_SMALLER_THAN:int = 4;

        public static function makeParameterFilterEnum(value:int):int  {
            switch(value) {
                case 0: return ParameterFilterEnum.EQUALS;
                case 1: return ParameterFilterEnum.GREATER_THAN;
                case 2: return ParameterFilterEnum.SMALLER_THAN;
                case 3: return ParameterFilterEnum.EQUALS_OR_GREATER_THAN;
                case 4: return ParameterFilterEnum.EQUALS_OR_SMALLER_THAN;
            }
            return -1;
        }

}

// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)

    }
