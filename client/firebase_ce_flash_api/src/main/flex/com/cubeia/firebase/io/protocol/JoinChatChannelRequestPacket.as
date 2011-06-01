// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)
package com.cubeia.firebase.io.protocol {

    import com.cubeia.firebase.io.PacketInputStream;
    import com.cubeia.firebase.io.PacketOutputStream;
    import com.cubeia.firebase.io.ProtocolObject;
  
    import flash.utils.ByteArray;

    public class JoinChatChannelRequestPacket implements ProtocolObject {
        public static const CLASSID:int = 120;

        public function classId():int {
            return JoinChatChannelRequestPacket.CLASSID;
        }

        public var channelid:int;

        public function save():ByteArray
        {
            var buffer:ByteArray = new ByteArray();
            var ps:PacketOutputStream = new PacketOutputStream(buffer);
            ps.saveInt(channelid);
            return buffer;
        }

        public function load(buffer:ByteArray):void 
        {
            var ps:PacketInputStream = new PacketInputStream(buffer);
            channelid = ps.loadInt();
        }
        

        public function toString():String
        {
            var result:String = "JoinChatChannelRequestPacket :";
            result += " channelid["+channelid+"]" ;
            return result;
        }

    }
}

// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)

