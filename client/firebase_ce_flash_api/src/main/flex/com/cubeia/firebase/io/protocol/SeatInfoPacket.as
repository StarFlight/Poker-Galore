// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)
package com.cubeia.firebase.io.protocol {

    import com.cubeia.firebase.io.PacketInputStream;
    import com.cubeia.firebase.io.PacketOutputStream;
    import com.cubeia.firebase.io.ProtocolObject;
    
    import flash.utils.ByteArray;

    public class SeatInfoPacket implements ProtocolObject {
        public static const CLASSID:int = 15;

        public function classId():int {
            return SeatInfoPacket.CLASSID;
        }

        public var tableid:int;
        public var seat:int;
        public var status:uint;
        public var player:PlayerInfoPacket;

        public function save():ByteArray
        {
            var buffer:ByteArray = new ByteArray();
            var ps:PacketOutputStream = new PacketOutputStream(buffer);
            ps.saveInt(tableid);
            ps.saveByte(seat);
            ps.saveUnsignedByte(status);
            ps.saveArray(player.save());
            return buffer;
        }

        public function load(buffer:ByteArray):void 
        {
            var ps:PacketInputStream = new PacketInputStream(buffer);
            tableid = ps.loadInt();
            seat = ps.loadByte();
            status = PlayerStatusEnum.makePlayerStatusEnum(ps.loadUnsignedByte());
            player = new PlayerInfoPacket();
            player.load(buffer);
        }
        

        public function toString():String
        {
            var result:String = "SeatInfoPacket :";
            result += " tableid["+tableid+"]" ;
            result += " seat["+seat+"]" ;
            result += " status["+status+"]" ;
            result += " player["+player+"]" ;
            return result;
        }

    }
}

// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)

