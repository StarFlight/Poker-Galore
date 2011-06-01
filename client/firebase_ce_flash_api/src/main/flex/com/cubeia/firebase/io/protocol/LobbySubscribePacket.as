// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)
package com.cubeia.firebase.io.protocol {

    import com.cubeia.firebase.io.PacketInputStream;
    import com.cubeia.firebase.io.PacketOutputStream;
    import com.cubeia.firebase.io.ProtocolObject;
  
    import flash.utils.ByteArray;

    public class LobbySubscribePacket implements ProtocolObject {
        public static const CLASSID:int = 145;

        public function classId():int {
            return LobbySubscribePacket.CLASSID;
        }

        public var type:uint;
        public var gameid:int;
        public var address:String;

        public function save():ByteArray
        {
            var buffer:ByteArray = new ByteArray();
            var ps:PacketOutputStream = new PacketOutputStream(buffer);
            ps.saveUnsignedByte(type);
            ps.saveInt(gameid);
            ps.saveString(address);
            return buffer;
        }

        public function load(buffer:ByteArray):void 
        {
            var ps:PacketInputStream = new PacketInputStream(buffer);
            type = LobbyTypeEnum.makeLobbyTypeEnum(ps.loadUnsignedByte());
            gameid = ps.loadInt();
            address = ps.loadString();
        }
        

        public function toString():String
        {
            var result:String = "LobbySubscribePacket :";
            result += " type["+type+"]" ;
            result += " gameid["+gameid+"]" ;
            result += " address["+address+"]" ;
            return result;
        }

    }
}

// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)

