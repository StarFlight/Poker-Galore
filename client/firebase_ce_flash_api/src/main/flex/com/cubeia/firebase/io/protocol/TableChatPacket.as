// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)
package com.cubeia.firebase.io.protocol {

    import com.cubeia.firebase.io.PacketInputStream;
    import com.cubeia.firebase.io.PacketOutputStream;
    import com.cubeia.firebase.io.ProtocolObject;
  
    import flash.utils.ByteArray;

    public class TableChatPacket implements ProtocolObject {
        public static const CLASSID:int = 80;

        public function classId():int {
            return TableChatPacket.CLASSID;
        }

        public var tableid:int;
        public var pid:int;
        public var message:String;

        public function save():ByteArray
        {
            var buffer:ByteArray = new ByteArray();
            var ps:PacketOutputStream = new PacketOutputStream(buffer);
            ps.saveInt(tableid);
            ps.saveInt(pid);
            ps.saveString(message);
            return buffer;
        }

        public function load(buffer:ByteArray):void 
        {
            var ps:PacketInputStream = new PacketInputStream(buffer);
            tableid = ps.loadInt();
            pid = ps.loadInt();
            message = ps.loadString();
        }
        

        public function toString():String
        {
            var result:String = "TableChatPacket :";
            result += " tableid["+tableid+"]" ;
            result += " pid["+pid+"]" ;
            result += " message["+message+"]" ;
            return result;
        }

    }
}

// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)

