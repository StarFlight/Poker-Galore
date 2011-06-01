// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)
package com.cubeia.games.poker.io.protocol {

    import com.cubeia.firebase.io.PacketInputStream;
    import com.cubeia.firebase.io.PacketOutputStream;
    import com.cubeia.firebase.io.ProtocolObject;
  
    import flash.utils.ByteArray;

    public final class HandTypeEnum
    {
        public static const UNKNOWN:int = 0;
        public static const HIGH_CARD:int = 1;
        public static const PAIR:int = 2;
        public static const TWO_PAIR:int = 3;
        public static const THREE_OF_A_KIND:int = 4;
        public static const STRAIGHT:int = 5;
        public static const FLUSH:int = 6;
        public static const FULL_HOUSE:int = 7;
        public static const FOUR_OF_A_KIND:int = 8;
        public static const STRAIGHT_FLUSH:int = 9;

        public static function makeHandTypeEnum(value:int):int  {
            switch(value) {
                case 0: return HandTypeEnum.UNKNOWN;
                case 1: return HandTypeEnum.HIGH_CARD;
                case 2: return HandTypeEnum.PAIR;
                case 3: return HandTypeEnum.TWO_PAIR;
                case 4: return HandTypeEnum.THREE_OF_A_KIND;
                case 5: return HandTypeEnum.STRAIGHT;
                case 6: return HandTypeEnum.FLUSH;
                case 7: return HandTypeEnum.FULL_HOUSE;
                case 8: return HandTypeEnum.FOUR_OF_A_KIND;
                case 9: return HandTypeEnum.STRAIGHT_FLUSH;
            }
            return -1;
        }

}

// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)

    }
