// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)
package com.cubeia.games.poker.io.protocol {

    import com.cubeia.firebase.io.PacketInputStream;
    import com.cubeia.firebase.io.PacketOutputStream;
    import com.cubeia.firebase.io.ProtocolObject;
  
    import flash.utils.ByteArray;

    public final class ActionTypeEnum
    {
        public static const SMALL_BLIND:int = 0;
        public static const BIG_BLIND:int = 1;
        public static const CALL:int = 2;
        public static const CHECK:int = 3;
        public static const BET:int = 4;
        public static const RAISE:int = 5;
        public static const FOLD:int = 6;
        public static const DECLINE_ENTRY_BET:int = 7;

        public static function makeActionTypeEnum(value:int):int  {
            switch(value) {
                case 0: return ActionTypeEnum.SMALL_BLIND;
                case 1: return ActionTypeEnum.BIG_BLIND;
                case 2: return ActionTypeEnum.CALL;
                case 3: return ActionTypeEnum.CHECK;
                case 4: return ActionTypeEnum.BET;
                case 5: return ActionTypeEnum.RAISE;
                case 6: return ActionTypeEnum.FOLD;
                case 7: return ActionTypeEnum.DECLINE_ENTRY_BET;
            }
            return -1;
        }

}

// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)

    }
