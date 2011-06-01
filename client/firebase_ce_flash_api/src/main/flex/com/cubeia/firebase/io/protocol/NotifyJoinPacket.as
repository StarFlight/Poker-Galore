
// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)
package com.cubeia.firebase.io.protocol {

    import com.cubeia.firebase.io.PacketInputStream;
    import com.cubeia.firebase.io.PacketOutputStream;
    import com.cubeia.firebase.io.ProtocolObject;
  
    import flash.utils.ByteArray;

    public class NotifyJoinPacket implements ProtocolObject {
        public static const CLASSID:int = 60;

        public function classId():int {
            return NotifyJoinPacket.CLASSID;
        }

        public var tableid:int;
        public var pid:int;
        public var nick:String;
        public var seat:int;
		

        public function save():ByteArray
        {
            var buffer:ByteArray = new ByteArray();
            var ps:PacketOutputStream = new PacketOutputStream(buffer);
            ps.saveInt(tableid);
            ps.saveInt(pid);
            ps.saveString(nick);
            ps.saveByte(seat);
            return buffer;
        }

        public function load(buffer:ByteArray):void 
        {
            var ps:PacketInputStream = new PacketInputStream(buffer);
            tableid = ps.loadInt();
            pid = ps.loadInt();
            nick = ps.loadString();
            seat = ps.loadByte();
        }
        

        public function toString():String
        {
            var result:String = "NotifyJoinPacket :";
            result += " tableid["+tableid+"]" ;
            result += " pid["+pid+"]" ;
            result += " nick["+nick+"]" ;
            result += " seat["+seat+"]" ;
            return result;
        }

    }
}

// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)

