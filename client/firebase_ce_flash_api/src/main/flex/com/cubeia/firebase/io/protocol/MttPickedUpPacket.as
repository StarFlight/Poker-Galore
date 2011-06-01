// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)
package com.cubeia.firebase.io.protocol {

    import com.cubeia.firebase.io.PacketInputStream;
    import com.cubeia.firebase.io.PacketOutputStream;
    import com.cubeia.firebase.io.ProtocolObject;
  
    import flash.utils.ByteArray;

    public class MttPickedUpPacket implements ProtocolObject {
        public static const CLASSID:int = 210;

        public function classId():int {
            return MttPickedUpPacket.CLASSID;
        }

        public var mttid:int;
        public var tableid:int;
        public var keepWatching:Boolean;

        public function save():ByteArray
        {
            var buffer:ByteArray = new ByteArray();
            var ps:PacketOutputStream = new PacketOutputStream(buffer);
            ps.saveInt(mttid);
            ps.saveInt(tableid);
            ps.saveBoolean(keepWatching);
            return buffer;
        }

        public function load(buffer:ByteArray):void 
        {
            var ps:PacketInputStream = new PacketInputStream(buffer);
            mttid = ps.loadInt();
            tableid = ps.loadInt();
            keepWatching = ps.loadBoolean();
        }
        

        public function toString():String
        {
            var result:String = "MttPickedUpPacket :";
            result += " mttid["+mttid+"]" ;
            result += " tableid["+tableid+"]" ;
            result += " keep_watching["+keepWatching+"]" ;
            return result;
        }

    }
}

// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)

