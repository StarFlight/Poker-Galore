// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)
package com.cubeia.firebase.io.protocol {

    import com.cubeia.firebase.io.PacketInputStream;
    import com.cubeia.firebase.io.PacketOutputStream;
    import com.cubeia.firebase.io.ProtocolObject;
  
    import flash.utils.ByteArray;

    public class NotifySeatedPacket implements ProtocolObject {
        public static const CLASSID:int = 62;

        public function classId():int {
            return NotifySeatedPacket.CLASSID;
        }

        public var tableid:int;
        public var seat:int;
        public var mttid:int;
        public var snapshot:TableSnapshotPacket;

        public function save():ByteArray
        {
            var buffer:ByteArray = new ByteArray();
            var ps:PacketOutputStream = new PacketOutputStream(buffer);
            ps.saveInt(tableid);
            ps.saveByte(seat);
            ps.saveInt(mttid);
            ps.saveArray(snapshot.save());
            return buffer;
        }

        public function load(buffer:ByteArray):void 
        {
            var ps:PacketInputStream = new PacketInputStream(buffer);
            tableid = ps.loadInt();
            seat = ps.loadByte();
            mttid = ps.loadInt();
            snapshot = new TableSnapshotPacket();
            snapshot.load(buffer);
        }
        

        public function toString():String
        {
            var result:String = "NotifySeatedPacket :";
            result += " tableid["+tableid+"]" ;
            result += " seat["+seat+"]" ;
            result += " mttid["+mttid+"]" ;
            result += " snapshot["+snapshot+"]" ;
            return result;
        }

    }
}

// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)

