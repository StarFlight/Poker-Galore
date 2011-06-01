// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)
package com.cubeia.firebase.io.protocol {

    import com.cubeia.firebase.io.PacketInputStream;
    import com.cubeia.firebase.io.PacketOutputStream;
    import com.cubeia.firebase.io.ProtocolObject;
  
    import flash.utils.ByteArray;

    public class LeaveResponsePacket implements ProtocolObject {
        public static const CLASSID:int = 37;

        public function classId():int {
            return LeaveResponsePacket.CLASSID;
        }

        public var tableid:int;
        public var status:uint;
        public var code:int;

        public function save():ByteArray
        {
            var buffer:ByteArray = new ByteArray();
            var ps:PacketOutputStream = new PacketOutputStream(buffer);
            ps.saveInt(tableid);
            ps.saveUnsignedByte(status);
            ps.saveInt(code);
            return buffer;
        }

        public function load(buffer:ByteArray):void 
        {
            var ps:PacketInputStream = new PacketInputStream(buffer);
            tableid = ps.loadInt();
            status = ResponseStatusEnum.makeResponseStatusEnum(ps.loadUnsignedByte());
            code = ps.loadInt();
        }
        

        public function toString():String
        {
            var result:String = "LeaveResponsePacket :";
            result += " tableid["+tableid+"]" ;
            result += " status["+status+"]" ;
            result += " code["+code+"]" ;
            return result;
        }

    }
}

// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)

