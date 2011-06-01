// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)
package com.cubeia.firebase.io.protocol {

    import com.cubeia.firebase.io.PacketInputStream;
    import com.cubeia.firebase.io.PacketOutputStream;
    import com.cubeia.firebase.io.ProtocolObject;
  
    import flash.utils.ByteArray;

    public final class LobbyTypeEnum
    {
        public static const REGULAR:int = 0;
        public static const MTT:int = 1;

        public static function makeLobbyTypeEnum(value:int):int  {
            switch(value) {
                case 0: return LobbyTypeEnum.REGULAR;
                case 1: return LobbyTypeEnum.MTT;
            }
            return -1;
        }

}

// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)

    }
