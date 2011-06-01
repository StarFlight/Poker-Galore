// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)
package com.cubeia.firebase.io.protocol {

    import com.cubeia.firebase.io.PacketInputStream;
    import com.cubeia.firebase.io.PacketOutputStream;
    import com.cubeia.firebase.io.ProtocolObject;
  
    import flash.utils.ByteArray;

    public class LogoutPacket implements ProtocolObject {
        public static const CLASSID:int = 12;

        public function classId():int {
            return LogoutPacket.CLASSID;
        }

        public var leaveTables:Boolean;

        public function save():ByteArray
        {
            var buffer:ByteArray = new ByteArray();
            var ps:PacketOutputStream = new PacketOutputStream(buffer);
            ps.saveBoolean(leaveTables);
            return buffer;
        }

        public function load(buffer:ByteArray):void 
        {
            var ps:PacketInputStream = new PacketInputStream(buffer);
            leaveTables = ps.loadBoolean();
        }
        

        public function toString():String
        {
            var result:String = "LogoutPacket :";
            result += " leave_tables["+leaveTables+"]" ;
            return result;
        }

    }
}

// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)

