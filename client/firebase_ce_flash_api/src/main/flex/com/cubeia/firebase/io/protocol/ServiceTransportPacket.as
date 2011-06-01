// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)
package com.cubeia.firebase.io.protocol {

    import com.cubeia.firebase.io.PacketInputStream;
    import com.cubeia.firebase.io.PacketOutputStream;
    import com.cubeia.firebase.io.ProtocolObject;
  
    import flash.utils.ByteArray;

    public class ServiceTransportPacket implements ProtocolObject {
        public static const CLASSID:int = 101;

        public function classId():int {
            return ServiceTransportPacket.CLASSID;
        }

        public var pid:int;
        public var seq:int;
        public var service:String;
        public var idtype:int;
        public var servicedata:ByteArray = new ByteArray();

        public function save():ByteArray
        {
            var buffer:ByteArray = new ByteArray();
            var ps:PacketOutputStream = new PacketOutputStream(buffer);
            ps.saveInt(pid);
            ps.saveInt(seq);
            ps.saveString(service);
            ps.saveByte(idtype);
            ps.saveInt(servicedata.length);
            ps.saveArray(servicedata);
            return buffer;
        }

        public function load(buffer:ByteArray):void 
        {
            var ps:PacketInputStream = new PacketInputStream(buffer);
            pid = ps.loadInt();
            seq = ps.loadInt();
            service = ps.loadString();
            idtype = ps.loadByte();
            var servicedataCount:int = ps.loadInt();
            servicedata = ps.loadByteArray(servicedataCount);
        }
        

        public function toString():String
        {
            var result:String = "ServiceTransportPacket :";
            result += " pid["+pid+"]" ;
            result += " seq["+seq+"]" ;
            result += " service["+service+"]" ;
            result += " idtype["+idtype+"]" ;
            result += " servicedata["+servicedata+"]" ;
            return result;
        }

    }
}

// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)

