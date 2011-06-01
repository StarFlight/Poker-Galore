// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)
package com.cubeia.firebase.io.protocol {

    import com.cubeia.firebase.io.PacketInputStream;
    import com.cubeia.firebase.io.PacketOutputStream;
    import com.cubeia.firebase.io.ProtocolObject;
  
    import flash.utils.ByteArray;

    public class JoinResponsePacket implements ProtocolObject {
        public static const CLASSID:int = 31;

        public function classId():int {
            return JoinResponsePacket.CLASSID;
        }

        public var tableid:int;
        public var seat:int;
        public var status:uint;
        public var code:int;

        public function save():ByteArray
        {
            var buffer:ByteArray = new ByteArray();
            var ps:PacketOutputStream = new PacketOutputStream(buffer);
            ps.saveInt(tableid);
            ps.saveByte(seat);
            ps.saveUnsignedByte(status);
            ps.saveInt(code);
            return buffer;
        }

        public function load(buffer:ByteArray):void 
        {
            var ps:PacketInputStream = new PacketInputStream(buffer);
            tableid = ps.loadInt();
            seat = ps.loadByte();
            status = JoinResponseStatusEnum.makeJoinResponseStatusEnum(ps.loadUnsignedByte());
            code = ps.loadInt();
        }
        

        public function toString():String
        {
            var result:String = "JoinResponsePacket :";
            result += " tableid["+tableid+"]" ;
            result += " seat["+seat+"]" ;
            result += " status["+status+"]" ;
            result += " code["+code+"]" ;
            return result;
        }

    }
}

// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)

