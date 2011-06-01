// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)
package com.cubeia.firebase.io.protocol {

    import com.cubeia.firebase.io.PacketInputStream;
    import com.cubeia.firebase.io.PacketOutputStream;
    import com.cubeia.firebase.io.ProtocolObject;
  
    import flash.utils.ByteArray;

    public class GoodPacket implements ProtocolObject {
        public static const CLASSID:int = 2;

        public function classId():int {
            return GoodPacket.CLASSID;
        }

        public var cmd:int;
        public var extra:int;

        public function save():ByteArray
        {
            var buffer:ByteArray = new ByteArray();
            var ps:PacketOutputStream = new PacketOutputStream(buffer);
            ps.saveByte(cmd);
            ps.saveInt(extra);
            return buffer;
        }

        public function load(buffer:ByteArray):void 
        {
            var ps:PacketInputStream = new PacketInputStream(buffer);
            cmd = ps.loadByte();
            extra = ps.loadInt();
        }
        

        public function toString():String
        {
            var result:String = "GoodPacket :";
            result += " cmd["+cmd+"]" ;
            result += " extra["+extra+"]" ;
            return result;
        }

    }
}

// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)

