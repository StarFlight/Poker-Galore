// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)
package com.cubeia.firebase.io.protocol {

    import com.cubeia.firebase.io.PacketInputStream;
    import com.cubeia.firebase.io.PacketOutputStream;
    import com.cubeia.firebase.io.ProtocolObject;
  
    import flash.utils.ByteArray;

    public class VersionPacket implements ProtocolObject {
        public static const CLASSID:int = 0;

        public function classId():int {
            return VersionPacket.CLASSID;
        }

        public var game:int;
        public var operatorid:int;
        public var protocol:int;

        public function save():ByteArray
        {
            var buffer:ByteArray = new ByteArray();
            var ps:PacketOutputStream = new PacketOutputStream(buffer);
            ps.saveInt(game);
            ps.saveInt(operatorid);
            ps.saveInt(protocol);
            return buffer;
        }

        public function load(buffer:ByteArray):void 
        {
            var ps:PacketInputStream = new PacketInputStream(buffer);
            game = ps.loadInt();
            operatorid = ps.loadInt();
            protocol = ps.loadInt();
        }
        

        public function toString():String
        {
            var result:String = "VersionPacket :";
            result += " game["+game+"]" ;
            result += " operatorid["+operatorid+"]" ;
            result += " protocol["+protocol+"]" ;
            return result;
        }

    }
}

// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)

