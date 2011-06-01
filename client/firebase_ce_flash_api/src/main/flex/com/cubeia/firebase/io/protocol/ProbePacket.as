// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)
package com.cubeia.firebase.io.protocol {

    import com.cubeia.firebase.io.PacketInputStream;
    import com.cubeia.firebase.io.PacketOutputStream;
    import com.cubeia.firebase.io.ProtocolObject;
  
    import flash.utils.ByteArray;

    public class ProbePacket implements ProtocolObject {
        public static const CLASSID:int = 201;

        public function classId():int {
            return ProbePacket.CLASSID;
        }

        public var id:int;
        public var tableid:int;
        public var stamps:Array = new Array();

        public function save():ByteArray
        {
            var buffer:ByteArray = new ByteArray();
            var ps:PacketOutputStream = new PacketOutputStream(buffer);
            ps.saveInt(id);
            ps.saveInt(tableid);
            ps.saveInt(stamps.length);
            var i:int;
            for( i = 0; i != stamps.length; i ++)
            {
                var _tmp_stamps:ByteArray? = stamps[i].save();
                ps.saveArray(_tmp_stamps);
            }
            return buffer;
        }

        public function load(buffer:ByteArray):void 
        {
            var ps:PacketInputStream = new PacketInputStream(buffer);
            id = ps.loadInt();
            tableid = ps.loadInt();
            var i:int;
            var stampsCount:int = ps.loadInt();
            stamps = new Array();
            for( i = 0; i < stampsCount; i ++) {
                var _tmp1:ProbeStamp  = new ProbeStamp();
                _tmp1.load(buffer);
                stamps[i] = _tmp1;
            }
        }
        

        public function toString():String
        {
            var result:String = "ProbePacket :";
            result += " id["+id+"]" ;
            result += " tableid["+tableid+"]" ;
            result += " stamps["+stamps+"]" ;
            return result;
        }

    }
}

// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)

