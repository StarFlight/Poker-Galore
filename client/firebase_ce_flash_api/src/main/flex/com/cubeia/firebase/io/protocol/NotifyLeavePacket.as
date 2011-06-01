// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)
package com.cubeia.firebase.io.protocol {

    import com.cubeia.firebase.io.PacketInputStream;
    import com.cubeia.firebase.io.PacketOutputStream;
    import com.cubeia.firebase.io.ProtocolObject;
  
    import flash.utils.ByteArray;

    public class NotifyLeavePacket implements ProtocolObject {
        public static const CLASSID:int = 61;

        public function classId():int {
            return NotifyLeavePacket.CLASSID;
        }

        public var tableid:int;
        public var pid:int;

        public function save():ByteArray
        {
            var buffer:ByteArray = new ByteArray();
            var ps:PacketOutputStream = new PacketOutputStream(buffer);
            ps.saveInt(tableid);
            ps.saveInt(pid);
            return buffer;
        }

        public function load(buffer:ByteArray):void 
        {
            var ps:PacketInputStream = new PacketInputStream(buffer);
            tableid = ps.loadInt();
            pid = ps.loadInt();
        }
        

        public function toString():String
        {
            var result:String = "NotifyLeavePacket :";
            result += " tableid["+tableid+"]" ;
            result += " pid["+pid+"]" ;
            return result;
        }

    }
}

// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)

