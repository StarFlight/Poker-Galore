// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)
package com.cubeia.firebase.io.protocol {

    import com.cubeia.firebase.io.PacketInputStream;
    import com.cubeia.firebase.io.PacketOutputStream;
    import com.cubeia.firebase.io.ProtocolObject;
  
    import flash.utils.ByteArray;

    public class TournamentSnapshotListPacket implements ProtocolObject {
        public static const CLASSID:int = 155;

        public function classId():int {
            return TournamentSnapshotListPacket.CLASSID;
        }

        public var snapshots:Array = new Array();

        public function save():ByteArray
        {
            var buffer:ByteArray = new ByteArray();
            var ps:PacketOutputStream = new PacketOutputStream(buffer);
            ps.saveInt(snapshots.length);
            var i:int;
            for( i = 0; i != snapshots.length; i ++)
            {
                var _tmp_snapshots:ByteArray? = snapshots[i].save();
                ps.saveArray(_tmp_snapshots);
            }
            return buffer;
        }

        public function load(buffer:ByteArray):void 
        {
            var ps:PacketInputStream = new PacketInputStream(buffer);
            var i:int;
            var snapshotsCount:int = ps.loadInt();
            snapshots = new Array();
            for( i = 0; i < snapshotsCount; i ++) {
                var _tmp1:TournamentSnapshotPacket  = new TournamentSnapshotPacket();
                _tmp1.load(buffer);
                snapshots[i] = _tmp1;
            }
        }
        

        public function toString():String
        {
            var result:String = "TournamentSnapshotListPacket :";
            result += " snapshots["+snapshots+"]" ;
            return result;
        }

    }
}

// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)

