// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)
package com.cubeia.games.poker.io.protocol {

    import com.cubeia.firebase.io.PacketInputStream;
    import com.cubeia.firebase.io.PacketOutputStream;
    import com.cubeia.firebase.io.ProtocolObject;
  
    import flash.utils.ByteArray;

    public final class PlayerTableStatusEnum
    {
        public static const NORMAL:int = 0;
        public static const SITOUT:int = 1;
        public static const ALLIN:int = 2;

        public static function makePlayerTableStatusEnum(value:int):int  {
            switch(value) {
                case 0: return PlayerTableStatusEnum.NORMAL;
                case 1: return PlayerTableStatusEnum.SITOUT;
                case 2: return PlayerTableStatusEnum.ALLIN;
            }
            return -1;
        }

}

// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)

    }
