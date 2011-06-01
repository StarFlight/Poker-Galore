// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)
package com.cubeia.firebase.io.protocol {

    import com.cubeia.firebase.io.PacketInputStream;
    import com.cubeia.firebase.io.PacketOutputStream;
    import com.cubeia.firebase.io.ProtocolObject;
  
    import flash.utils.ByteArray;

    public final class JoinResponseStatusEnum
    {
        public static const OK:int = 0;
        public static const FAILED:int = 1;
        public static const DENIED:int = 2;

        public static function makeJoinResponseStatusEnum(value:int):int  {
            switch(value) {
                case 0: return JoinResponseStatusEnum.OK;
                case 1: return JoinResponseStatusEnum.FAILED;
                case 2: return JoinResponseStatusEnum.DENIED;
            }
            return -1;
        }

}

// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)

    }
