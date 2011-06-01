// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)
package com.cubeia.firebase.io.protocol {

    import com.cubeia.firebase.io.PacketInputStream;
    import com.cubeia.firebase.io.PacketOutputStream;
    import com.cubeia.firebase.io.ProtocolObject;
  
    import flash.utils.ByteArray;

    public class KickPlayerPacket implements ProtocolObject {
        public static const CLASSID:int = 64;

        public function classId():int {
            return KickPlayerPacket.CLASSID;
        }

        public var tableid:int;
        public var reasonCode:int;

        public function save():ByteArray
        {
            var buffer:ByteArray = new ByteArray();
            var ps:PacketOutputStream = new PacketOutputStream(buffer);
            ps.saveInt(tableid);
            ps.saveShort(reasonCode);
            return buffer;
        }

        public function load(buffer:ByteArray):void 
        {
            var ps:PacketInputStream = new PacketInputStream(buffer);
            tableid = ps.loadInt();
            reasonCode = ps.loadShort();
        }
        

        public function toString():String
        {
            var result:String = "KickPlayerPacket :";
            result += " tableid["+tableid+"]" ;
            result += " reasonCode["+reasonCode+"]" ;
            return result;
        }

    }
}

// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)

