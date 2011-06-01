// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)
package com.cubeia.firebase.io.protocol {

    import com.cubeia.firebase.io.PacketInputStream;
    import com.cubeia.firebase.io.PacketOutputStream;
    import com.cubeia.firebase.io.ProtocolObject;
  
    import flash.utils.ByteArray;

    public class GameVersionPacket implements ProtocolObject {
        public static const CLASSID:int = 1;

        public function classId():int {
            return GameVersionPacket.CLASSID;
        }

        public var game:int;
        public var operatorid:int;
        public var version:String;

        public function save():ByteArray
        {
            var buffer:ByteArray = new ByteArray();
            var ps:PacketOutputStream = new PacketOutputStream(buffer);
            ps.saveInt(game);
            ps.saveInt(operatorid);
            ps.saveString(version);
            return buffer;
        }

        public function load(buffer:ByteArray):void 
        {
            var ps:PacketInputStream = new PacketInputStream(buffer);
            game = ps.loadInt();
            operatorid = ps.loadInt();
            version = ps.loadString();
        }
        

        public function toString():String
        {
            var result:String = "GameVersionPacket :";
            result += " game["+game+"]" ;
            result += " operatorid["+operatorid+"]" ;
            result += " version["+version+"]" ;
            return result;
        }

    }
}

// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)

