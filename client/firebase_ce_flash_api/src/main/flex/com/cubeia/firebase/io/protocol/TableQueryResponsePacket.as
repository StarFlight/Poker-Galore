// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)
package com.cubeia.firebase.io.protocol {

    import com.cubeia.firebase.io.PacketInputStream;
    import com.cubeia.firebase.io.PacketOutputStream;
    import com.cubeia.firebase.io.ProtocolObject;
  
    import flash.utils.ByteArray;

    public class TableQueryResponsePacket implements ProtocolObject {
        public static const CLASSID:int = 39;

        public function classId():int {
            return TableQueryResponsePacket.CLASSID;
        }

        public var tableid:int;
        public var status:uint;
        public var seats:Array = new Array();

        public function save():ByteArray
        {
            var buffer:ByteArray = new ByteArray();
            var ps:PacketOutputStream = new PacketOutputStream(buffer);
            ps.saveInt(tableid);
            ps.saveUnsignedByte(status);
            ps.saveInt(seats.length);
            var i:int;
            for( i = 0; i != seats.length; i ++)
            {
                var _tmp_seats:ByteArray? = seats[i].save();
                ps.saveArray(_tmp_seats);
            }
            return buffer;
        }

        public function load(buffer:ByteArray):void 
        {
            var ps:PacketInputStream = new PacketInputStream(buffer);
            tableid = ps.loadInt();
            status = ResponseStatusEnum.makeResponseStatusEnum(ps.loadUnsignedByte());
            var i:int;
            var seatsCount:int = ps.loadInt();
            seats = new Array();
            for( i = 0; i < seatsCount; i ++) {
                var _tmp1:SeatInfoPacket  = new SeatInfoPacket();
                _tmp1.load(buffer);
                seats[i] = _tmp1;
            }
        }
        

        public function toString():String
        {
            var result:String = "TableQueryResponsePacket :";
            result += " tableid["+tableid+"]" ;
            result += " status["+status+"]" ;
            result += " seats["+seats+"]" ;
            return result;
        }

    }
}

// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)

