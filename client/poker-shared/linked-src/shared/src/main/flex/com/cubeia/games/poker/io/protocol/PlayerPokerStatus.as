// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)
package com.cubeia.games.poker.io.protocol {

    import com.cubeia.firebase.io.PacketInputStream;
    import com.cubeia.firebase.io.PacketOutputStream;
    import com.cubeia.firebase.io.ProtocolObject;
    
    import flash.utils.ByteArray;

    public class PlayerPokerStatus implements ProtocolObject {
        public static const CLASSID:int = 19;

        public function classId():int {
            return PlayerPokerStatus.CLASSID;
        }

        public var player:int;
        public var status:uint;
		public var imageUrl:String;
		public var winnerFl:int;
		
        public function save():ByteArray
        {
            var buffer:ByteArray = new ByteArray();
            var ps:PacketOutputStream = new PacketOutputStream(buffer);
            ps.saveInt(player);
            ps.saveUnsignedByte(status);
			ps.saveString(imageUrl);
			ps.saveInt(winnerFl);
            return buffer;
        }

        public function load(buffer:ByteArray):void 
        {
            var ps:PacketInputStream = new PacketInputStream(buffer);
            player = ps.loadInt();
            status = PlayerTableStatusEnum.makePlayerTableStatusEnum(ps.loadUnsignedByte());
			imageUrl = ps.loadString();
			winnerFl = ps.loadInt();
			
        }
        

        public function toString():String
        {
            var result:String = "PlayerPokerStatus :";
            result += " player["+player+"]" ;
            result += " status["+status+"]" ;
			result += " imagerUrl["+imageUrl+"]" ;
			result += " winnerFl["+winnerFl+"]" ;
            return result;
        }

    }
}

// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)

