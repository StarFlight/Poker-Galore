// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)
package com.cubeia.firebase.io.protocol {

    import com.cubeia.firebase.io.PacketInputStream;
    import com.cubeia.firebase.io.PacketOutputStream;
    import com.cubeia.firebase.io.ProtocolObject;
  
    import flash.utils.ByteArray;

    public class CreateTableResponsePacket implements ProtocolObject {
        public static const CLASSID:int = 41;

        public function classId():int {
            return CreateTableResponsePacket.CLASSID;
        }

        public var seq:int;
        public var tableid:int;
        public var seat:int;
        public var status:uint;
        public var code:int;

        public function save():ByteArray
        {
            var buffer:ByteArray = new ByteArray();
            var ps:PacketOutputStream = new PacketOutputStream(buffer);
            ps.saveInt(seq);
            ps.saveInt(tableid);
            ps.saveByte(seat);
            ps.saveUnsignedByte(status);
            ps.saveInt(code);
            return buffer;
        }

        public function load(buffer:ByteArray):void 
        {
            var ps:PacketInputStream = new PacketInputStream(buffer);
            seq = ps.loadInt();
            tableid = ps.loadInt();
            seat = ps.loadByte();
            status = ResponseStatusEnum.makeResponseStatusEnum(ps.loadUnsignedByte());
            code = ps.loadInt();
        }
        

        public function toString():String
        {
            var result:String = "CreateTableResponsePacket :";
            result += " seq["+seq+"]" ;
            result += " tableid["+tableid+"]" ;
            result += " seat["+seat+"]" ;
            result += " status["+status+"]" ;
            result += " code["+code+"]" ;
            return result;
        }

    }
}

// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)

