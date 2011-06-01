// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)
package com.cubeia.games.poker.io.protocol {

    import com.cubeia.firebase.io.PacketInputStream;
    import com.cubeia.firebase.io.PacketOutputStream;
    import com.cubeia.firebase.io.ProtocolObject;
  
    import flash.utils.ByteArray;

    public class BestHand implements ProtocolObject {
        public static const CLASSID:int = 3;

        public function classId():int {
            return BestHand.CLASSID;
        }

        public var player:int;
        public var rank:int;
        public var name:String;

        public function save():ByteArray
        {
            var buffer:ByteArray = new ByteArray();
            var ps:PacketOutputStream = new PacketOutputStream(buffer);
            ps.saveInt(player);
            ps.saveInt(rank);
            ps.saveString(name);
            return buffer;
        }

        public function load(buffer:ByteArray):void 
        {
            var ps:PacketInputStream = new PacketInputStream(buffer);
            player = ps.loadInt();
            rank = ps.loadInt();
            name = ps.loadString();
        }
        

        public function toString():String
        {
            var result:String = "BestHand :";
            result += " player["+player+"]" ;
            result += " rank["+rank+"]" ;
            result += " name["+name+"]" ;
            return result;
        }

    }
}

// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)

