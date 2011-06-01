// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)
package com.cubeia.firebase.io.protocol {

    import com.cubeia.firebase.io.PacketInputStream;
    import com.cubeia.firebase.io.PacketOutputStream;
    import com.cubeia.firebase.io.ProtocolObject;
  
    import flash.utils.ByteArray;

    public class BadPacket implements ProtocolObject {
        public static const CLASSID:int = 3;

        public function classId():int {
            return BadPacket.CLASSID;
        }

        public var cmd:int;
        public var error:int;

        public function save():ByteArray
        {
            var buffer:ByteArray = new ByteArray();
            var ps:PacketOutputStream = new PacketOutputStream(buffer);
            ps.saveByte(cmd);
            ps.saveByte(error);
            return buffer;
        }

        public function load(buffer:ByteArray):void 
        {
            var ps:PacketInputStream = new PacketInputStream(buffer);
            cmd = ps.loadByte();
            error = ps.loadByte();
        }
        

        public function toString():String
        {
            var result:String = "BadPacket :";
            result += " cmd["+cmd+"]" ;
            result += " error["+error+"]" ;
            return result;
        }

    }
}

// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)

