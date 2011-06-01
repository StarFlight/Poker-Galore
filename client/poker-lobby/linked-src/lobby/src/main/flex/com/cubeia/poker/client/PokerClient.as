package com.cubeia.poker.client
{
	import com.cubeia.firebase.connector.FirebaseClient;
	import com.cubeia.firebase.io.protocol.JoinRequestPacket;
	import com.cubeia.firebase.io.protocol.WatchRequestPacket;
	import com.cubeia.firebase.io.protocol.UnwatchRequestPacket;
	import com.cubeia.firebase.io.protocol.TableQueryRequestPacket;
	import com.cubeia.firebase.io.ProtocolObject;
	import com.cubeia.firebase.io.protocol.GameTransportPacket;

	public class PokerClient extends FirebaseClient
	{
		public function PokerClient(id:String, connectorName:String = "_fb_connector", encrypt:Boolean = false) {
			trace("Connector name:" + connectorName);
			//super(id, encrypt, connectorName);
		}
		
		public function joinTable(tableId:int, seat:int = -1):void
		{
			var jrp:JoinRequestPacket = new JoinRequestPacket();
			jrp.tableid = tableId;
			jrp.seat = seat;
			send(jrp);

		}

		public function watchTable(tableId:int):void
		{
			var wrp:WatchRequestPacket = new WatchRequestPacket();
			wrp.tableid = tableId;
			send(wrp);
		}

		public function unwatchTable(tableId:int):void
		{
			var urp:UnwatchRequestPacket = new UnwatchRequestPacket();
			urp.tableid = tableId;
			send(urp);
		}

		public function queryTable(tableId:int):void
		{
			var tqp:TableQueryRequestPacket = new TableQueryRequestPacket();
			tqp.tableid = tableId;
			send(tqp);
		}
		
				/**
		 * Send a game transport packet to the firebase server
		 * 
		 * @param protocolObject - object to embed in a GameTransportPacket
		 */
		public function sendGameTransportPacket(playerId:int, tableId:int, protocolObject:ProtocolObject):void
		{
			var gameTransportPacket:GameTransportPacket = new GameTransportPacket();
			gameTransportPacket.pid = playerId;
			gameTransportPacket.tableid = tableId;
			gameTransportPacket.gamedata = Serializer.pack(protocolObject);
			gameTransportPacket.gamedata.position = 0;
			send(gameTransportPacket);
		}


	}
	
	
}