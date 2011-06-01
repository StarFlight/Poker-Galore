// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)
package com.cubeia.firebase.io.protocol {

    import com.cubeia.firebase.io.PacketInputStream;
    import com.cubeia.firebase.io.PacketOutputStream;
    import com.cubeia.firebase.io.ProtocolObject;
  
    import flash.utils.ByteArray;

    public final class TournamentRegisterResponseStatusEnum
    {
        public static const OK:int = 0;
        public static const FAILED:int = 1;
        public static const DENIED:int = 2;
        public static const DENIED_LOW_FUNDS:int = 3;
        public static const DENIED_MTT_FULL:int = 4;
        public static const DENIED_NO_ACCESS:int = 5;
        public static const DENIED_ALREADY_REGISTERED:int = 6;
        public static const DENIED_TOURNAMENT_RUNNING:int = 7;

        public static function makeTournamentRegisterResponseStatusEnum(value:int):int  {
            switch(value) {
                case 0: return TournamentRegisterResponseStatusEnum.OK;
                case 1: return TournamentRegisterResponseStatusEnum.FAILED;
                case 2: return TournamentRegisterResponseStatusEnum.DENIED;
                case 3: return TournamentRegisterResponseStatusEnum.DENIED_LOW_FUNDS;
                case 4: return TournamentRegisterResponseStatusEnum.DENIED_MTT_FULL;
                case 5: return TournamentRegisterResponseStatusEnum.DENIED_NO_ACCESS;
                case 6: return TournamentRegisterResponseStatusEnum.DENIED_ALREADY_REGISTERED;
                case 7: return TournamentRegisterResponseStatusEnum.DENIED_TOURNAMENT_RUNNING;
            }
            return -1;
        }

}

// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)

    }
