// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)
package com.cubeia.games.poker.io.protocol {

    import com.cubeia.firebase.io.PacketInputStream;
    import com.cubeia.firebase.io.PacketOutputStream;
    import com.cubeia.firebase.io.ProtocolObject;
  
    import flash.utils.ByteArray;

    public final class RankEnum
    {
        public static const TWO:int = 0;
        public static const THREE:int = 1;
        public static const FOUR:int = 2;
        public static const FIVE:int = 3;
        public static const SIX:int = 4;
        public static const SEVEN:int = 5;
        public static const EIGHT:int = 6;
        public static const NINE:int = 7;
        public static const TEN:int = 8;
        public static const JACK:int = 9;
        public static const QUEEN:int = 10;
        public static const KING:int = 11;
        public static const ACE:int = 12;

        public static function makeRankEnum(value:int):int  {
            switch(value) {
                case 0: return RankEnum.TWO;
                case 1: return RankEnum.THREE;
                case 2: return RankEnum.FOUR;
                case 3: return RankEnum.FIVE;
                case 4: return RankEnum.SIX;
                case 5: return RankEnum.SEVEN;
                case 6: return RankEnum.EIGHT;
                case 7: return RankEnum.NINE;
                case 8: return RankEnum.TEN;
                case 9: return RankEnum.JACK;
                case 10: return RankEnum.QUEEN;
                case 11: return RankEnum.KING;
                case 12: return RankEnum.ACE;
            }
            return -1;
        }

}

// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)

    }
