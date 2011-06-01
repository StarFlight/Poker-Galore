// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)
package com.cubeia.firebase.io.protocol {

    import com.cubeia.firebase.io.PacketInputStream;
    import com.cubeia.firebase.io.PacketOutputStream;
    import com.cubeia.firebase.io.ProtocolObject;
  
    import flash.utils.ByteArray;

    public class NotifyInvitedPacket implements ProtocolObject {
        public static const CLASSID:int = 43;

        public function classId():int {
            return NotifyInvitedPacket.CLASSID;
        }

        public var inviter:int;
        public var screenname:String;
        public var tableid:int;
        public var seat:int;

        public function save():ByteArray
        {
            var buffer:ByteArray = new ByteArray();
            var ps:PacketOutputStream = new PacketOutputStream(buffer);
            ps.saveInt(inviter);
            ps.saveString(screenname);
            ps.saveInt(tableid);
            ps.saveByte(seat);
            return buffer;
        }

        public function load(buffer:ByteArray):void 
        {
            var ps:PacketInputStream = new PacketInputStream(buffer);
            inviter = ps.loadInt();
            screenname = ps.loadString();
            tableid = ps.loadInt();
            seat = ps.loadByte();
        }
        

        public function toString():String
        {
            var result:String = "NotifyInvitedPacket :";
            result += " inviter["+inviter+"]" ;
            result += " screenname["+screenname+"]" ;
            result += " tableid["+tableid+"]" ;
            result += " seat["+seat+"]" ;
            return result;
        }

    }
}

// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)

