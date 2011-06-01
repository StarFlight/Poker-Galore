// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)
package com.cubeia.firebase.io.protocol {

    import com.cubeia.firebase.io.PacketInputStream;
    import com.cubeia.firebase.io.PacketOutputStream;
    import com.cubeia.firebase.io.ProtocolObject;
  
    import flash.utils.ByteArray;

    public class UnwatchResponsePacket implements ProtocolObject {
        public static const CLASSID:int = 35;

        public function classId():int {
            return UnwatchResponsePacket.CLASSID;
        }

        public var tableid:int;
        public var status:uint;

        public function save():ByteArray
        {
            var buffer:ByteArray = new ByteArray();
            var ps:PacketOutputStream = new PacketOutputStream(buffer);
            ps.saveInt(tableid);
            ps.saveUnsignedByte(status);
            return buffer;
        }

        public function load(buffer:ByteArray):void 
        {
            var ps:PacketInputStream = new PacketInputStream(buffer);
            tableid = ps.loadInt();
            status = ResponseStatusEnum.makeResponseStatusEnum(ps.loadUnsignedByte());
        }
        

        public function toString():String
        {
            var result:String = "UnwatchResponsePacket :";
            result += " tableid["+tableid+"]" ;
            result += " status["+status+"]" ;
            return result;
        }

    }
}

// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)

