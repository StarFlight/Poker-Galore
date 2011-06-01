// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)
package com.cubeia.firebase.io.protocol {

    import com.cubeia.firebase.io.PacketInputStream;
    import com.cubeia.firebase.io.PacketOutputStream;
    import com.cubeia.firebase.io.ProtocolObject;
  
    import flash.utils.ByteArray;

    public class LobbyQueryPacket implements ProtocolObject {
        public static const CLASSID:int = 142;

        public function classId():int {
            return LobbyQueryPacket.CLASSID;
        }

        public var gameid:int;
        public var address:String;
        public var type:uint;

        public function save():ByteArray
        {
            var buffer:ByteArray = new ByteArray();
            var ps:PacketOutputStream = new PacketOutputStream(buffer);
            ps.saveInt(gameid);
            ps.saveString(address);
            ps.saveUnsignedByte(type);
            return buffer;
        }

        public function load(buffer:ByteArray):void 
        {
            var ps:PacketInputStream = new PacketInputStream(buffer);
            gameid = ps.loadInt();
            address = ps.loadString();
            type = LobbyTypeEnum.makeLobbyTypeEnum(ps.loadUnsignedByte());
        }
        

        public function toString():String
        {
            var result:String = "LobbyQueryPacket :";
            result += " gameid["+gameid+"]" ;
            result += " address["+address+"]" ;
            result += " type["+type+"]" ;
            return result;
        }

    }
}

// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)

