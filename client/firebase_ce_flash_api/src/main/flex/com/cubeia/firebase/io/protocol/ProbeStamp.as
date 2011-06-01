// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)
package com.cubeia.firebase.io.protocol {

    import com.cubeia.firebase.io.PacketInputStream;
    import com.cubeia.firebase.io.PacketOutputStream;
    import com.cubeia.firebase.io.ProtocolObject;
  
    import flash.utils.ByteArray;

    public class ProbeStamp implements ProtocolObject {
        public static const CLASSID:int = 200;

        public function classId():int {
            return ProbeStamp.CLASSID;
        }

        public var clazz:String;
        public var timestamp:int;

        public function save():ByteArray
        {
            var buffer:ByteArray = new ByteArray();
            var ps:PacketOutputStream = new PacketOutputStream(buffer);
            ps.saveString(clazz);
            ps.saveLong(timestamp);
            return buffer;
        }

        public function load(buffer:ByteArray):void 
        {
            var ps:PacketInputStream = new PacketInputStream(buffer);
            clazz = ps.loadString();
            timestamp = ps.loadLong();
        }
        

        public function toString():String
        {
            var result:String = "ProbeStamp :";
            result += " clazz["+clazz+"]" ;
            result += " timestamp["+timestamp+"]" ;
            return result;
        }

    }
}

// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)

