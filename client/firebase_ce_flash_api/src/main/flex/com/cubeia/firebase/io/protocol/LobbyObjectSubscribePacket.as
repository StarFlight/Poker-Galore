// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)
package com.cubeia.firebase.io.protocol {

    import com.cubeia.firebase.io.PacketInputStream;
    import com.cubeia.firebase.io.PacketOutputStream;
    import com.cubeia.firebase.io.ProtocolObject;
  
    import flash.utils.ByteArray;

    public class LobbyObjectSubscribePacket implements ProtocolObject {
        public static const CLASSID:int = 151;

        public function classId():int {
            return LobbyObjectSubscribePacket.CLASSID;
        }

        public var type:uint;
        public var gameid:int;
        public var address:String;
        public var objectid:int;

        public function save():ByteArray
        {
            var buffer:ByteArray = new ByteArray();
            var ps:PacketOutputStream = new PacketOutputStream(buffer);
            ps.saveUnsignedByte(type);
            ps.saveInt(gameid);
            ps.saveString(address);
            ps.saveInt(objectid);
            return buffer;
        }

        public function load(buffer:ByteArray):void 
        {
            var ps:PacketInputStream = new PacketInputStream(buffer);
            type = LobbyTypeEnum.makeLobbyTypeEnum(ps.loadUnsignedByte());
            gameid = ps.loadInt();
            address = ps.loadString();
            objectid = ps.loadInt();
        }
        

        public function toString():String
        {
            var result:String = "LobbyObjectSubscribePacket :";
            result += " type["+type+"]" ;
            result += " gameid["+gameid+"]" ;
            result += " address["+address+"]" ;
            result += " objectid["+objectid+"]" ;
            return result;
        }

    }
}

// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)

