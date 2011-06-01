// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)
package com.cubeia.firebase.io.protocol {

    import com.cubeia.firebase.io.PacketInputStream;
    import com.cubeia.firebase.io.PacketOutputStream;
    import com.cubeia.firebase.io.ProtocolObject;
  
    import flash.utils.ByteArray;

    public class NotifyChannelChatPacket implements ProtocolObject {
        public static const CLASSID:int = 123;

        public function classId():int {
            return NotifyChannelChatPacket.CLASSID;
        }

        public var pid:int;
        public var channelid:int;
        public var targetid:int;
        public var nick:String;
        public var message:String;

        public function save():ByteArray
        {
            var buffer:ByteArray = new ByteArray();
            var ps:PacketOutputStream = new PacketOutputStream(buffer);
            ps.saveInt(pid);
            ps.saveInt(channelid);
            ps.saveInt(targetid);
            ps.saveString(nick);
            ps.saveString(message);
            return buffer;
        }

        public function load(buffer:ByteArray):void 
        {
            var ps:PacketInputStream = new PacketInputStream(buffer);
            pid = ps.loadInt();
            channelid = ps.loadInt();
            targetid = ps.loadInt();
            nick = ps.loadString();
            message = ps.loadString();
        }
        

        public function toString():String
        {
            var result:String = "NotifyChannelChatPacket :";
            result += " pid["+pid+"]" ;
            result += " channelid["+channelid+"]" ;
            result += " targetid["+targetid+"]" ;
            result += " nick["+nick+"]" ;
            result += " message["+message+"]" ;
            return result;
        }

    }
}

// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)

