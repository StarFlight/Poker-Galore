// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)
package com.cubeia.firebase.io.protocol {

    import com.cubeia.firebase.io.PacketInputStream;
    import com.cubeia.firebase.io.PacketOutputStream;
    import com.cubeia.firebase.io.ProtocolObject;
  
    import flash.utils.ByteArray;

    public class TableSnapshotPacket implements ProtocolObject {
        public static const CLASSID:int = 143;

        public function classId():int {
            return TableSnapshotPacket.CLASSID;
        }

        public var tableid:int;
        public var address:String;
        public var name:String;
        public var capacity:int;
        public var seated:int;
        public var params:Array = new Array();

        public function save():ByteArray
        {
            var buffer:ByteArray = new ByteArray();
            var ps:PacketOutputStream = new PacketOutputStream(buffer);
            ps.saveInt(tableid);
            ps.saveString(address);
            ps.saveString(name);
            ps.saveShort(capacity);
            ps.saveShort(seated);
            ps.saveInt(params.length);
            var i:int;
            for( i = 0; i != params.length; i ++)
            {
                var _tmp_params:ByteArray? = params[i].save();
                ps.saveArray(_tmp_params);
            }
            return buffer;
        }

        public function load(buffer:ByteArray):void 
        {
            var ps:PacketInputStream = new PacketInputStream(buffer);
            tableid = ps.loadInt();
            address = ps.loadString();
            name = ps.loadString();
            capacity = ps.loadShort();
            seated = ps.loadShort();
            var i:int;
            var paramsCount:int = ps.loadInt();
            params = new Array();
            for( i = 0; i < paramsCount; i ++) {
                var _tmp1:Param  = new Param();
                _tmp1.load(buffer);
                params[i] = _tmp1;
            }
        }
        

        public function toString():String
        {
            var result:String = "TableSnapshotPacket :";
            result += " tableid["+tableid+"]" ;
            result += " address["+address+"]" ;
            result += " name["+name+"]" ;
            result += " capacity["+capacity+"]" ;
            result += " seated["+seated+"]" ;
            result += " params["+params+"]" ;
            return result;
        }

    }
}

// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)

