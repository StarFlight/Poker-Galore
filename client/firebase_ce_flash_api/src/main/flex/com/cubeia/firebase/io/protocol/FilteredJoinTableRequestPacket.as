// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)
package com.cubeia.firebase.io.protocol {

    import com.cubeia.firebase.io.PacketInputStream;
    import com.cubeia.firebase.io.PacketOutputStream;
    import com.cubeia.firebase.io.ProtocolObject;
  
    import flash.utils.ByteArray;

    public class FilteredJoinTableRequestPacket implements ProtocolObject {
        public static const CLASSID:int = 170;

        public function classId():int {
            return FilteredJoinTableRequestPacket.CLASSID;
        }

        public var seq:int;
        public var gameid:int;
        public var address:String;
        public var params:Array = new Array();

        public function save():ByteArray
        {
            var buffer:ByteArray = new ByteArray();
            var ps:PacketOutputStream = new PacketOutputStream(buffer);
            ps.saveInt(seq);
            ps.saveInt(gameid);
            ps.saveString(address);
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
            seq = ps.loadInt();
            gameid = ps.loadInt();
            address = ps.loadString();
            var i:int;
            var paramsCount:int = ps.loadInt();
            params = new Array();
            for( i = 0; i < paramsCount; i ++) {
                var _tmp1:ParamFilter  = new ParamFilter();
                _tmp1.load(buffer);
                params[i] = _tmp1;
            }
        }
        

        public function toString():String
        {
            var result:String = "FilteredJoinTableRequestPacket :";
            result += " seq["+seq+"]" ;
            result += " gameid["+gameid+"]" ;
            result += " address["+address+"]" ;
            result += " params["+params+"]" ;
            return result;
        }

    }
}

// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)

