// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)
package com.cubeia.firebase.io.protocol {

    import com.cubeia.firebase.io.PacketInputStream;
    import com.cubeia.firebase.io.PacketOutputStream;
    import com.cubeia.firebase.io.ProtocolObject;
  
    import flash.utils.ByteArray;

    public final class ResponseStatusEnum
    {
        public static const OK:int = 0;
        public static const FAILED:int = 1;
        public static const DENIED:int = 2;

        public static function makeResponseStatusEnum(value:int):int  {
            switch(value) {
                case 0: return ResponseStatusEnum.OK;
                case 1: return ResponseStatusEnum.FAILED;
                case 2: return ResponseStatusEnum.DENIED;
            }
            return -1;
        }

}

// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)

    }
