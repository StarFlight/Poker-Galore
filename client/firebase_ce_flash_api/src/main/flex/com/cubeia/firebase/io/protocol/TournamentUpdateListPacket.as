// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)
package com.cubeia.firebase.io.protocol {

    import com.cubeia.firebase.io.PacketInputStream;
    import com.cubeia.firebase.io.PacketOutputStream;
    import com.cubeia.firebase.io.ProtocolObject;
  
    import flash.utils.ByteArray;

    public class TournamentUpdateListPacket implements ProtocolObject {
        public static const CLASSID:int = 156;

        public function classId():int {
            return TournamentUpdateListPacket.CLASSID;
        }

        public var updates:Array = new Array();

        public function save():ByteArray
        {
            var buffer:ByteArray = new ByteArray();
            var ps:PacketOutputStream = new PacketOutputStream(buffer);
            ps.saveInt(updates.length);
            var i:int;
            for( i = 0; i != updates.length; i ++)
            {
                var _tmp_updates:ByteArray? = updates[i].save();
                ps.saveArray(_tmp_updates);
            }
            return buffer;
        }

        public function load(buffer:ByteArray):void 
        {
            var ps:PacketInputStream = new PacketInputStream(buffer);
            var i:int;
            var updatesCount:int = ps.loadInt();
            updates = new Array();
            for( i = 0; i < updatesCount; i ++) {
                var _tmp1:TournamentUpdatePacket  = new TournamentUpdatePacket();
                _tmp1.load(buffer);
                updates[i] = _tmp1;
            }
        }
        

        public function toString():String
        {
            var result:String = "TournamentUpdateListPacket :";
            result += " updates["+updates+"]" ;
            return result;
        }

    }
}

// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)

