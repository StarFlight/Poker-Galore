// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)
package com.cubeia.firebase.io.protocol {

    import com.cubeia.firebase.io.PacketInputStream;
    import com.cubeia.firebase.io.PacketOutputStream;
    import com.cubeia.firebase.io.ProtocolObject;
  
    import flash.utils.ByteArray;

    public final class ParameterTypeEnum
    {
        public static const STRING:int = 0;
        public static const INT:int = 1;
        public static const DATE:int = 2;

        public static function makeParameterTypeEnum(value:int):int  {
            switch(value) {
                case 0: return ParameterTypeEnum.STRING;
                case 1: return ParameterTypeEnum.INT;
                case 2: return ParameterTypeEnum.DATE;
            }
            return -1;
        }

}

// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)

    }
