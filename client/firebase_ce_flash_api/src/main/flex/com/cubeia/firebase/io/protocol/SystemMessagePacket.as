// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)
package com.cubeia.firebase.io.protocol {

    import com.cubeia.firebase.io.PacketInputStream;
    import com.cubeia.firebase.io.PacketOutputStream;
    import com.cubeia.firebase.io.ProtocolObject;
  
    import flash.utils.ByteArray;

    public class SystemMessagePacket implements ProtocolObject {
        public static const CLASSID:int = 4;

        public function classId():int {
            return SystemMessagePacket.CLASSID;
        }

        public var type:int;
        public var level:int;
        public var message:String;
        public var pids:Array = new Array();

        public function save():ByteArray
        {
            var buffer:ByteArray = new ByteArray();
            var ps:PacketOutputStream = new PacketOutputStream(buffer);
            ps.saveInt(type);
            ps.saveInt(level);
            ps.saveString(message);
            ps.saveInt(pids.length);
            var i:int;
            for( i = 0; i != pids.length; i ++)
            {
                ps.saveInt(pids[i]);
            }
            return buffer;
        }

        public function load(buffer:ByteArray):void 
        {
            var ps:PacketInputStream = new PacketInputStream(buffer);
            type = ps.loadInt();
            level = ps.loadInt();
            message = ps.loadString();
            var i:int;
            var pidsCount:int = ps.loadInt();
            pids = new Array();
            for (i = 0; i < pidsCount; i ++)
            {
                pids[i] = ps.loadInt();
            }
        }
        

        public function toString():String
        {
            var result:String = "SystemMessagePacket :";
            result += " type["+type+"]" ;
            result += " level["+level+"]" ;
            result += " message["+message+"]" ;
            result += " pids["+pids+"]" ;
            return result;
        }

    }
}

// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)

