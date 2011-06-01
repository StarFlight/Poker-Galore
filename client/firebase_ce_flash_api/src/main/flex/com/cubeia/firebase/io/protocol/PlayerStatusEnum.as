// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)
package com.cubeia.firebase.io.protocol {

    import com.cubeia.firebase.io.PacketInputStream;
    import com.cubeia.firebase.io.PacketOutputStream;
    import com.cubeia.firebase.io.ProtocolObject;
  
    import flash.utils.ByteArray;

    public final class PlayerStatusEnum
    {
        public static const CONNECTED:int = 0;
        public static const WAITING_REJOIN:int = 1;
        public static const DISCONNECTED:int = 2;
        public static const LEAVING:int = 3;
        public static const TABLE_LOCAL:int = 4;
        public static const RESERVATION:int = 5;

        public static function makePlayerStatusEnum(value:int):int  {
            switch(value) {
                case 0: return PlayerStatusEnum.CONNECTED;
                case 1: return PlayerStatusEnum.WAITING_REJOIN;
                case 2: return PlayerStatusEnum.DISCONNECTED;
                case 3: return PlayerStatusEnum.LEAVING;
                case 4: return PlayerStatusEnum.TABLE_LOCAL;
                case 5: return PlayerStatusEnum.RESERVATION;
            }
            return -1;
        }

}

// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)

    }
