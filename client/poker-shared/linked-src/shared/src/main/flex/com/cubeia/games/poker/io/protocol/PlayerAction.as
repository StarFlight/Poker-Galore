// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)
package com.cubeia.games.poker.io.protocol {

    import com.cubeia.firebase.io.PacketInputStream;
    import com.cubeia.firebase.io.PacketOutputStream;
    import com.cubeia.firebase.io.ProtocolObject;
  
    import flash.utils.ByteArray;

    public class PlayerAction implements ProtocolObject {
        public static const CLASSID:int = 1;

        public function classId():int {
            return PlayerAction.CLASSID;
        }

        public var type:uint;
        public var minAmount:int;
        public var maxAmount:int;

        public function save():ByteArray
        {
            var buffer:ByteArray = new ByteArray();
            var ps:PacketOutputStream = new PacketOutputStream(buffer);
            ps.saveUnsignedByte(type);
            ps.saveInt(minAmount);
            ps.saveInt(maxAmount);
            return buffer;
        }

        public function load(buffer:ByteArray):void 
        {
            var ps:PacketInputStream = new PacketInputStream(buffer);
            type = ActionTypeEnum.makeActionTypeEnum(ps.loadUnsignedByte());
            minAmount = ps.loadInt();
            maxAmount = ps.loadInt();
        }
        

        public function toString():String
        {
            var result:String = "PlayerAction :";
            result += " type["+type+"]" ;
            result += " min_amount["+minAmount+"]" ;
            result += " max_amount["+maxAmount+"]" ;
            return result;
        }

    }
}

// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)

