// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)
package com.cubeia.games.poker.io.protocol {

    import com.cubeia.firebase.io.PacketInputStream;
    import com.cubeia.firebase.io.PacketOutputStream;
    import com.cubeia.firebase.io.ProtocolObject;
  
    import flash.utils.ByteArray;

    public class PlayerBalance implements ProtocolObject {
        public static const CLASSID:int = 17;

        public function classId():int {
            return PlayerBalance.CLASSID;
        }

        public var balance:int;
        public var player:int;

        public function save():ByteArray
        {
            var buffer:ByteArray = new ByteArray();
            var ps:PacketOutputStream = new PacketOutputStream(buffer);
            ps.saveInt(balance);
            ps.saveInt(player);
            return buffer;
        }

        public function load(buffer:ByteArray):void 
        {
            var ps:PacketInputStream = new PacketInputStream(buffer);
            balance = ps.loadInt();
            player = ps.loadInt();
        }
        

        public function toString():String
        {
            var result:String = "PlayerBalance :";
            result += " balance["+balance+"]" ;
            result += " player["+player+"]" ;
            return result;
        }

    }
}

// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)

