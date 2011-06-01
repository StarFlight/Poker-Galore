// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)
package com.cubeia.firebase.io.protocol {

    import com.cubeia.firebase.io.PacketInputStream;
    import com.cubeia.firebase.io.PacketOutputStream;
    import com.cubeia.firebase.io.ProtocolObject;
  
    import flash.utils.ByteArray;

    public class GameTransportPacket implements ProtocolObject {
        public static const CLASSID:int = 100;

        public function classId():int {
            return GameTransportPacket.CLASSID;
        }

        public var tableid:int;
        public var pid:int;
        public var gamedata:ByteArray = new ByteArray();

        public function save():ByteArray
        {
            var buffer:ByteArray = new ByteArray();
            var ps:PacketOutputStream = new PacketOutputStream(buffer);
            ps.saveInt(tableid);
            ps.saveInt(pid);
            ps.saveInt(gamedata.length);
            ps.saveArray(gamedata);
            return buffer;
        }

        public function load(buffer:ByteArray):void 
        {
            var ps:PacketInputStream = new PacketInputStream(buffer);
            tableid = ps.loadInt();
            pid = ps.loadInt();
            var gamedataCount:int = ps.loadInt();
            gamedata = ps.loadByteArray(gamedataCount);
        }
        

        public function toString():String
        {
            var result:String = "GameTransportPacket :";
            result += " tableid["+tableid+"]" ;
            result += " pid["+pid+"]" ;
            result += " gamedata["+gamedata+"]" ;
            return result;
        }

    }
}

// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)

