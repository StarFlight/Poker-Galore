// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)
package com.cubeia.firebase.io.protocol {

    import com.cubeia.firebase.io.PacketInputStream;
    import com.cubeia.firebase.io.PacketOutputStream;
    import com.cubeia.firebase.io.ProtocolObject;
  
    import flash.utils.ByteArray;

    public class NotifyRegisteredPacket implements ProtocolObject {
        public static const CLASSID:int = 211;

        public function classId():int {
            return NotifyRegisteredPacket.CLASSID;
        }

        public var tournaments:Array = new Array();

        public function save():ByteArray
        {
            var buffer:ByteArray = new ByteArray();
            var ps:PacketOutputStream = new PacketOutputStream(buffer);
            ps.saveInt(tournaments.length);
            var i:int;
            for( i = 0; i != tournaments.length; i ++)
            {
                ps.saveInt(tournaments[i]);
            }
            return buffer;
        }

        public function load(buffer:ByteArray):void 
        {
            var ps:PacketInputStream = new PacketInputStream(buffer);
            var i:int;
            var tournamentsCount:int = ps.loadInt();
            tournaments = new Array();
            for (i = 0; i < tournamentsCount; i ++)
            {
                tournaments[i] = ps.loadInt();
            }
        }
        

        public function toString():String
        {
            var result:String = "NotifyRegisteredPacket :";
            result += " tournaments["+tournaments+"]" ;
            return result;
        }

    }
}

// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)

