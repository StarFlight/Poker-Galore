// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)
package com.cubeia.firebase.io.protocol {

    import com.cubeia.firebase.io.PacketInputStream;
    import com.cubeia.firebase.io.PacketOutputStream;
    import com.cubeia.firebase.io.ProtocolObject;
  
    import flash.utils.ByteArray;

    public class PlayerQueryResponsePacket implements ProtocolObject {
        public static const CLASSID:int = 17;

        public function classId():int {
            return PlayerQueryResponsePacket.CLASSID;
        }

        public var pid:int;
        public var nick:String;
        public var status:uint;
        public var data:ByteArray = new ByteArray();

        public function save():ByteArray
        {
            var buffer:ByteArray = new ByteArray();
            var ps:PacketOutputStream = new PacketOutputStream(buffer);
            ps.saveInt(pid);
            ps.saveString(nick);
            ps.saveUnsignedByte(status);
            ps.saveInt(data.length);
            ps.saveArray(data);
            return buffer;
        }

        public function load(buffer:ByteArray):void 
        {
            var ps:PacketInputStream = new PacketInputStream(buffer);
            pid = ps.loadInt();
            nick = ps.loadString();
            status = ResponseStatusEnum.makeResponseStatusEnum(ps.loadUnsignedByte());
            var dataCount:int = ps.loadInt();
            data = ps.loadByteArray(dataCount);
        }
        

        public function toString():String
        {
            var result:String = "PlayerQueryResponsePacket :";
            result += " pid["+pid+"]" ;
            result += " nick["+nick+"]" ;
            result += " status["+status+"]" ;
            result += " data["+data+"]" ;
            return result;
        }

    }
}

// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)

