// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)
package com.cubeia.firebase.io.protocol {

    import com.cubeia.firebase.io.PacketInputStream;
    import com.cubeia.firebase.io.PacketOutputStream;
    import com.cubeia.firebase.io.ProtocolObject;
  
    import flash.utils.ByteArray;

    public final class ServiceIdentifierEnum
    {
        public static const NAMESPACE:int = 0;
        public static const CONTRACT:int = 1;

        public static function makeServiceIdentifierEnum(value:int):int  {
            switch(value) {
                case 0: return ServiceIdentifierEnum.NAMESPACE;
                case 1: return ServiceIdentifierEnum.CONTRACT;
            }
            return -1;
        }

}

// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)

    }
