// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)
package com.cubeia.firebase.io.protocol {

    import com.cubeia.firebase.io.PacketInputStream;
    import com.cubeia.firebase.io.PacketOutputStream;
    import com.cubeia.firebase.io.ProtocolObject;
  
    import flash.utils.ByteArray;

    public class EncryptedTransportPacket implements ProtocolObject {
        public static const CLASSID:int = 105;

        public function classId():int {
            return EncryptedTransportPacket.CLASSID;
        }

        public var func:int;
        public var payload:ByteArray = new ByteArray();

        public function save():ByteArray
        {
            var buffer:ByteArray = new ByteArray();
            var ps:PacketOutputStream = new PacketOutputStream(buffer);
            ps.saveByte(func);
            ps.saveInt(payload.length);
            ps.saveArray(payload);
            return buffer;
        }

        public function load(buffer:ByteArray):void 
        {
            var ps:PacketInputStream = new PacketInputStream(buffer);
            func = ps.loadByte();
            var payloadCount:int = ps.loadInt();
            payload = ps.loadByteArray(payloadCount);
        }
        

        public function toString():String
        {
            var result:String = "EncryptedTransportPacket :";
            result += " func["+func+"]" ;
            result += " payload["+payload+"]" ;
            return result;
        }

    }
}

// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)

