// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)
package com.cubeia.firebase.io.protocol {

    import com.cubeia.firebase.io.PacketInputStream;
    import com.cubeia.firebase.io.PacketOutputStream;
    import com.cubeia.firebase.io.ProtocolObject;
  
    import flash.utils.ByteArray;

    public class LocalServiceTransportPacket implements ProtocolObject {
        public static const CLASSID:int = 103;

        public function classId():int {
            return LocalServiceTransportPacket.CLASSID;
        }

        public var seq:int;
        public var servicedata:ByteArray = new ByteArray();

        public function save():ByteArray
        {
            var buffer:ByteArray = new ByteArray();
            var ps:PacketOutputStream = new PacketOutputStream(buffer);
            ps.saveInt(seq);
            ps.saveInt(servicedata.length);
            ps.saveArray(servicedata);
            return buffer;
        }

        public function load(buffer:ByteArray):void 
        {
            var ps:PacketInputStream = new PacketInputStream(buffer);
            seq = ps.loadInt();
            var servicedataCount:int = ps.loadInt();
            servicedata = ps.loadByteArray(servicedataCount);
        }
        

        public function toString():String
        {
            var result:String = "LocalServiceTransportPacket :";
            result += " seq["+seq+"]" ;
            result += " servicedata["+servicedata+"]" ;
            return result;
        }

    }
}

// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)

