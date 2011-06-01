// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)
package com.cubeia.games.poker.io.protocol {

    import com.cubeia.firebase.io.PacketInputStream;
    import com.cubeia.firebase.io.PacketOutputStream;
    import com.cubeia.firebase.io.ProtocolObject;
  
    import flash.utils.ByteArray;

    public final class SuitEnum
    {
        public static const CLUBS:int = 0;
        public static const DIAMONDS:int = 1;
        public static const HEARTS:int = 2;
        public static const SPADES:int = 3;

        public static function makeSuitEnum(value:int):int  {
            switch(value) {
                case 0: return SuitEnum.CLUBS;
                case 1: return SuitEnum.DIAMONDS;
                case 2: return SuitEnum.HEARTS;
                case 3: return SuitEnum.SPADES;
            }
            return -1;
        }

}

// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)

    }
