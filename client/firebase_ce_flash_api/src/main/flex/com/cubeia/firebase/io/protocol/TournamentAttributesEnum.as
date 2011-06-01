// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)
package com.cubeia.firebase.io.protocol {

    import com.cubeia.firebase.io.PacketInputStream;
    import com.cubeia.firebase.io.PacketOutputStream;
    import com.cubeia.firebase.io.ProtocolObject;
  
    import flash.utils.ByteArray;

    public final class TournamentAttributesEnum
    {
        public static const NAME:int = 0;
        public static const CAPACITY:int = 1;
        public static const REGISTERED:int = 2;
        public static const ACTIVE_PLAYERS:int = 3;
        public static const STATUS:int = 4;

        public static function makeTournamentAttributesEnum(value:int):int  {
            switch(value) {
                case 0: return TournamentAttributesEnum.NAME;
                case 1: return TournamentAttributesEnum.CAPACITY;
                case 2: return TournamentAttributesEnum.REGISTERED;
                case 3: return TournamentAttributesEnum.ACTIVE_PLAYERS;
                case 4: return TournamentAttributesEnum.STATUS;
            }
            return -1;
        }

}

// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)

    }
