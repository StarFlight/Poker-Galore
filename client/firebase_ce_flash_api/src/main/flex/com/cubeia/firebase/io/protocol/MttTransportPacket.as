// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)
package com.cubeia.firebase.io.protocol {

    import com.cubeia.firebase.io.PacketInputStream;
    import com.cubeia.firebase.io.PacketOutputStream;
    import com.cubeia.firebase.io.ProtocolObject;
  
    import flash.utils.ByteArray;

    public class MttTransportPacket implements ProtocolObject {
        public static const CLASSID:int = 104;

        public function classId():int {
            return MttTransportPacket.CLASSID;
        }

        public var mttid:int;
        public var pid:int;
        public var mttdata:ByteArray = new ByteArray();

        public function save():ByteArray
        {
            var buffer:ByteArray = new ByteArray();
            var ps:PacketOutputStream = new PacketOutputStream(buffer);
            ps.saveInt(mttid);
            ps.saveInt(pid);
            ps.saveInt(mttdata.length);
            ps.saveArray(mttdata);
            return buffer;
        }

        public function load(buffer:ByteArray):void 
        {
            var ps:PacketInputStream = new PacketInputStream(buffer);
            mttid = ps.loadInt();
            pid = ps.loadInt();
            var mttdataCount:int = ps.loadInt();
            mttdata = ps.loadByteArray(mttdataCount);
        }
        

        public function toString():String
        {
            var result:String = "MttTransportPacket :";
            result += " mttid["+mttid+"]" ;
            result += " pid["+pid+"]" ;
            result += " mttdata["+mttdata+"]" ;
            return result;
        }

    }
}

// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)

