// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)
package com.cubeia.firebase.io.protocol {

    import com.cubeia.firebase.io.PacketInputStream;
    import com.cubeia.firebase.io.PacketOutputStream;
    import com.cubeia.firebase.io.ProtocolObject;
  
    import flash.utils.ByteArray;

    public class InvitePlayersRequestPacket implements ProtocolObject {
        public static const CLASSID:int = 42;

        public function classId():int {
            return InvitePlayersRequestPacket.CLASSID;
        }

        public var tableid:int;
        public var invitees:Array = new Array();

        public function save():ByteArray
        {
            var buffer:ByteArray = new ByteArray();
            var ps:PacketOutputStream = new PacketOutputStream(buffer);
            ps.saveInt(tableid);
            ps.saveInt(invitees.length);
            var i:int;
            for( i = 0; i != invitees.length; i ++)
            {
                ps.saveInt(invitees[i]);
            }
            return buffer;
        }

        public function load(buffer:ByteArray):void 
        {
            var ps:PacketInputStream = new PacketInputStream(buffer);
            tableid = ps.loadInt();
            var i:int;
            var inviteesCount:int = ps.loadInt();
            invitees = new Array();
            for (i = 0; i < inviteesCount; i ++)
            {
                invitees[i] = ps.loadInt();
            }
        }
        

        public function toString():String
        {
            var result:String = "InvitePlayersRequestPacket :";
            result += " tableid["+tableid+"]" ;
            result += " invitees["+invitees+"]" ;
            return result;
        }

    }
}

// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)

