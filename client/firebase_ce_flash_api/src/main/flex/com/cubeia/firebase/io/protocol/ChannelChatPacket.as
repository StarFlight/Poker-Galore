// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)
package com.cubeia.firebase.io.protocol {

    import com.cubeia.firebase.io.PacketInputStream;
    import com.cubeia.firebase.io.PacketOutputStream;
    import com.cubeia.firebase.io.ProtocolObject;
  
    import flash.utils.ByteArray;

    public class ChannelChatPacket implements ProtocolObject {
        public static const CLASSID:int = 124;

        public function classId():int {
            return ChannelChatPacket.CLASSID;
        }

        public var channelid:int;
        public var targetid:int;
        public var message:String;

        public function save():ByteArray
        {
            var buffer:ByteArray = new ByteArray();
            var ps:PacketOutputStream = new PacketOutputStream(buffer);
            ps.saveInt(channelid);
            ps.saveInt(targetid);
            ps.saveString(message);
            return buffer;
        }

        public function load(buffer:ByteArray):void 
        {
            var ps:PacketInputStream = new PacketInputStream(buffer);
            channelid = ps.loadInt();
            targetid = ps.loadInt();
            message = ps.loadString();
        }
        

        public function toString():String
        {
            var result:String = "ChannelChatPacket :";
            result += " channelid["+channelid+"]" ;
            result += " targetid["+targetid+"]" ;
            result += " message["+message+"]" ;
            return result;
        }

    }
}

// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)

