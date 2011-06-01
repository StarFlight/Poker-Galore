// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)
package com.cubeia.firebase.io.protocol {

    import com.cubeia.firebase.io.PacketInputStream;
    import com.cubeia.firebase.io.PacketOutputStream;
    import com.cubeia.firebase.io.ProtocolObject;
  
    import flash.utils.ByteArray;

    public class FilteredJoinCancelRequestPacket implements ProtocolObject {
        public static const CLASSID:int = 172;

        public function classId():int {
            return FilteredJoinCancelRequestPacket.CLASSID;
        }

        public var seq:int;

        public function save():ByteArray
        {
            var buffer:ByteArray = new ByteArray();
            var ps:PacketOutputStream = new PacketOutputStream(buffer);
            ps.saveInt(seq);
            return buffer;
        }

        public function load(buffer:ByteArray):void 
        {
            var ps:PacketInputStream = new PacketInputStream(buffer);
            seq = ps.loadInt();
        }
        

        public function toString():String
        {
            var result:String = "FilteredJoinCancelRequestPacket :";
            result += " seq["+seq+"]" ;
            return result;
        }

    }
}

// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)

