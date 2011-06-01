// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)
package com.cubeia.firebase.io.protocol {

    import com.cubeia.firebase.io.PacketInputStream;
    import com.cubeia.firebase.io.PacketOutputStream;
    import com.cubeia.firebase.io.ProtocolObject;
  
    import flash.utils.ByteArray;

    public class FilteredJoinTableAvailablePacket implements ProtocolObject {
        public static const CLASSID:int = 174;

        public function classId():int {
            return FilteredJoinTableAvailablePacket.CLASSID;
        }

        public var seq:int;
        public var tableid:int;
        public var seat:int;

        public function save():ByteArray
        {
            var buffer:ByteArray = new ByteArray();
            var ps:PacketOutputStream = new PacketOutputStream(buffer);
            ps.saveInt(seq);
            ps.saveInt(tableid);
            ps.saveByte(seat);
            return buffer;
        }

        public function load(buffer:ByteArray):void 
        {
            var ps:PacketInputStream = new PacketInputStream(buffer);
            seq = ps.loadInt();
            tableid = ps.loadInt();
            seat = ps.loadByte();
        }
        

        public function toString():String
        {
            var result:String = "FilteredJoinTableAvailablePacket :";
            result += " seq["+seq+"]" ;
            result += " tableid["+tableid+"]" ;
            result += " seat["+seat+"]" ;
            return result;
        }

    }
}

// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)

