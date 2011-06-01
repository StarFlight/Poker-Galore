// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)
package com.cubeia.firebase.io.protocol {

    import com.cubeia.firebase.io.PacketInputStream;
    import com.cubeia.firebase.io.PacketOutputStream;
    import com.cubeia.firebase.io.ProtocolObject;
  
    import flash.utils.ByteArray;

    public final class FilteredJoinResponseStatusEnum
    {
        public static const OK:int = 0;
        public static const FAILED:int = 1;
        public static const DENIED:int = 2;
        public static const SEATING:int = 3;
        public static const WAIT_LIST:int = 4;

        public static function makeFilteredJoinResponseStatusEnum(value:int):int  {
            switch(value) {
                case 0: return FilteredJoinResponseStatusEnum.OK;
                case 1: return FilteredJoinResponseStatusEnum.FAILED;
                case 2: return FilteredJoinResponseStatusEnum.DENIED;
                case 3: return FilteredJoinResponseStatusEnum.SEATING;
                case 4: return FilteredJoinResponseStatusEnum.WAIT_LIST;
            }
            return -1;
        }

}

// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)

    }
