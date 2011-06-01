// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)
package com.cubeia.games.poker.io.protocol {

    import com.cubeia.firebase.io.PacketInputStream;
    import com.cubeia.firebase.io.PacketOutputStream;
    import com.cubeia.firebase.io.ProtocolObject;
  
    import flash.utils.ByteArray;

    public class DealHiddenCards implements ProtocolObject {
        public static const CLASSID:int = 10;

        public function classId():int {
            return DealHiddenCards.CLASSID;
        }

        public var player:int;
        public var count:int;

        public function save():ByteArray
        {
            var buffer:ByteArray = new ByteArray();
            var ps:PacketOutputStream = new PacketOutputStream(buffer);
            ps.saveInt(player);
            ps.saveByte(count);
            return buffer;
        }

        public function load(buffer:ByteArray):void 
        {
            var ps:PacketInputStream = new PacketInputStream(buffer);
            player = ps.loadInt();
            count = ps.loadByte();
        }
        

        public function toString():String
        {
            var result:String = "DealHiddenCards :";
            result += " player["+player+"]" ;
            result += " count["+count+"]" ;
            return result;
        }

    }
}

// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)

