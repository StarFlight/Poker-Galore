// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)
package com.cubeia.games.poker.io.protocol {

    import com.cubeia.firebase.io.PacketInputStream;
    import com.cubeia.firebase.io.PacketOutputStream;
    import com.cubeia.firebase.io.ProtocolObject;
  
    import flash.utils.ByteArray;

    public final class HandPhaseEnum
    {
        public static const PREFLOP:int = 0;
        public static const FLOP:int = 1;
        public static const TURN:int = 2;
        public static const RIVER:int = 3;

        public static function makeHandPhaseEnum(value:int):int  {
            switch(value) {
                case 0: return HandPhaseEnum.PREFLOP;
                case 1: return HandPhaseEnum.FLOP;
                case 2: return HandPhaseEnum.TURN;
                case 3: return HandPhaseEnum.RIVER;
            }
            return -1;
        }

}

// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)

    }
