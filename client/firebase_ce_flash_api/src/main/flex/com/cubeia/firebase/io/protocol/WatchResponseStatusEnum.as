// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)
package com.cubeia.firebase.io.protocol {

    import com.cubeia.firebase.io.PacketInputStream;
    import com.cubeia.firebase.io.PacketOutputStream;
    import com.cubeia.firebase.io.ProtocolObject;
  
    import flash.utils.ByteArray;

    public final class WatchResponseStatusEnum
    {
        public static const OK:int = 0;
        public static const FAILED:int = 1;
        public static const DENIED:int = 2;
        public static const DENIED_ALREADY_SEATED:int = 3;

        public static function makeWatchResponseStatusEnum(value:int):int  {
            switch(value) {
                case 0: return WatchResponseStatusEnum.OK;
                case 1: return WatchResponseStatusEnum.FAILED;
                case 2: return WatchResponseStatusEnum.DENIED;
                case 3: return WatchResponseStatusEnum.DENIED_ALREADY_SEATED;
            }
            return -1;
        }

}

// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)

    }
