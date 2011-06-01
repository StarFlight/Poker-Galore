// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)
package com.cubeia.firebase.io.protocol {

    import com.cubeia.firebase.io.PacketInputStream;
    import com.cubeia.firebase.io.PacketOutputStream;
    import com.cubeia.firebase.io.ProtocolObject;
  
    import flash.utils.ByteArray;

    public class ForcedLogoutPacket implements ProtocolObject {
        public static const CLASSID:int = 14;

        public function classId():int {
            return ForcedLogoutPacket.CLASSID;
        }

        public var code:int;
        public var message:String;

        public function save():ByteArray
        {
            var buffer:ByteArray = new ByteArray();
            var ps:PacketOutputStream = new PacketOutputStream(buffer);
            ps.saveInt(code);
            ps.saveString(message);
            return buffer;
        }

        public function load(buffer:ByteArray):void 
        {
            var ps:PacketInputStream = new PacketInputStream(buffer);
            code = ps.loadInt();
            message = ps.loadString();
        }
        

        public function toString():String
        {
            var result:String = "ForcedLogoutPacket :";
            result += " code["+code+"]" ;
            result += " message["+message+"]" ;
            return result;
        }

    }
}

// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)

