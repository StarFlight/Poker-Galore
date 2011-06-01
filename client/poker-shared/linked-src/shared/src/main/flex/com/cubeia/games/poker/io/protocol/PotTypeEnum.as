// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)
package com.cubeia.games.poker.io.protocol {

    import com.cubeia.firebase.io.PacketInputStream;
    import com.cubeia.firebase.io.PacketOutputStream;
    import com.cubeia.firebase.io.ProtocolObject;
  
    import flash.utils.ByteArray;

    public final class PotTypeEnum
    {
        public static const MAIN:int = 0;
        public static const SIDE:int = 1;

        public static function makePotTypeEnum(value:int):int  {
            switch(value) {
                case 0: return PotTypeEnum.MAIN;
                case 1: return PotTypeEnum.SIDE;
            }
            return -1;
        }

}

// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)

    }
