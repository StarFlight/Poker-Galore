/**
 * Copyright (C) 2010 Cubeia Ltd <info@cubeia.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

package com.cubeia.games.poker.client;

import java.io.IOException;
import java.nio.ByteBuffer;

import org.apache.log4j.Logger;

import com.cubeia.firebase.clients.java.connector.text.AbstractClientPacketHandler;
import com.cubeia.firebase.clients.java.connector.text.IOContext;
import com.cubeia.firebase.io.ProtocolObject;
import com.cubeia.firebase.io.StyxSerializer;
import com.cubeia.firebase.io.protocol.CreateTableResponsePacket;
import com.cubeia.firebase.io.protocol.EncryptedTransportPacket;
import com.cubeia.firebase.io.protocol.FilteredJoinCancelResponsePacket;
import com.cubeia.firebase.io.protocol.FilteredJoinTableAvailablePacket;
import com.cubeia.firebase.io.protocol.FilteredJoinTableResponsePacket;
import com.cubeia.firebase.io.protocol.ForcedLogoutPacket;
import com.cubeia.firebase.io.protocol.GameTransportPacket;
import com.cubeia.firebase.io.protocol.GameVersionPacket;
import com.cubeia.firebase.io.protocol.JoinChatChannelResponsePacket;
import com.cubeia.firebase.io.protocol.JoinResponsePacket;
import com.cubeia.firebase.io.protocol.KickPlayerPacket;
import com.cubeia.firebase.io.protocol.LeaveResponsePacket;
import com.cubeia.firebase.io.protocol.LocalServiceTransportPacket;
import com.cubeia.firebase.io.protocol.LoginResponsePacket;
import com.cubeia.firebase.io.protocol.MttPickedUpPacket;
import com.cubeia.firebase.io.protocol.MttRegisterResponsePacket;
import com.cubeia.firebase.io.protocol.MttSeatedPacket;
import com.cubeia.firebase.io.protocol.MttTransportPacket;
import com.cubeia.firebase.io.protocol.MttUnregisterResponsePacket;
import com.cubeia.firebase.io.protocol.NotifyChannelChatPacket;
import com.cubeia.firebase.io.protocol.NotifyInvitedPacket;
import com.cubeia.firebase.io.protocol.NotifyJoinPacket;
import com.cubeia.firebase.io.protocol.NotifyLeavePacket;
import com.cubeia.firebase.io.protocol.NotifyRegisteredPacket;
import com.cubeia.firebase.io.protocol.NotifySeatedPacket;
import com.cubeia.firebase.io.protocol.NotifyWatchingPacket;
import com.cubeia.firebase.io.protocol.PingPacket;
import com.cubeia.firebase.io.protocol.PlayerQueryResponsePacket;
import com.cubeia.firebase.io.protocol.ProbePacket;
import com.cubeia.firebase.io.protocol.SeatInfoPacket;
import com.cubeia.firebase.io.protocol.ServiceTransportPacket;
import com.cubeia.firebase.io.protocol.SystemInfoResponsePacket;
import com.cubeia.firebase.io.protocol.SystemMessagePacket;
import com.cubeia.firebase.io.protocol.TableQueryResponsePacket;
import com.cubeia.firebase.io.protocol.TableRemovedPacket;
import com.cubeia.firebase.io.protocol.TableSnapshotListPacket;
import com.cubeia.firebase.io.protocol.TableSnapshotPacket;
import com.cubeia.firebase.io.protocol.TableUpdateListPacket;
import com.cubeia.firebase.io.protocol.TableUpdatePacket;
import com.cubeia.firebase.io.protocol.TournamentRemovedPacket;
import com.cubeia.firebase.io.protocol.TournamentSnapshotListPacket;
import com.cubeia.firebase.io.protocol.TournamentSnapshotPacket;
import com.cubeia.firebase.io.protocol.TournamentUpdateListPacket;
import com.cubeia.firebase.io.protocol.TournamentUpdatePacket;
import com.cubeia.firebase.io.protocol.UnwatchResponsePacket;
import com.cubeia.firebase.io.protocol.VersionPacket;
import com.cubeia.firebase.io.protocol.WatchResponsePacket;
import com.cubeia.games.poker.io.protocol.ProtocolObjectFactory;

/**
 * 
 * Created on 2006-sep-19
 * @author Fredrik Johansson
 *
 * $RCSFile: $
 * $Revision: $
 * $Author: $
 * $Date: $
 */
public class ManualPacketHandler extends AbstractClientPacketHandler {
    
    @SuppressWarnings("unused")
	private Logger log = Logger.getLogger(ManualPacketHandler.class);
    
    @SuppressWarnings("unused")
	private IOContext context;
    
    /**
     * Handles the test game specific actions.
     * You need to inject an implementation before
     * using testgame packets, or they wont be handled!
     */
    private ManualGameHandler gameHandler;
    
    private StyxSerializer styxDecoder = new StyxSerializer(new ProtocolObjectFactory());
    
    public ManualPacketHandler(IOContext context) {
    	this.context = context;
    }
    
	public ManualGameHandler getTestHandler() {
		return gameHandler;
	}

	/**
	 * IOC injection.
	 * 
	 * @param testHandler
	 */
	public void setTestHandler(ManualGameHandler testHandler) {
		this.gameHandler = testHandler;
	}

	public void visit(GameTransportPacket packet) {
		ProtocolObject data;
		try {
			data = styxDecoder.unpack(ByteBuffer.wrap(packet.gamedata));
			if (data != null) {
				data.accept(gameHandler);
			}
		} catch (IOException e) {
			System.out.println("Can't create packet: "+packet);
			return;
		}
	}

	@Override
	public void visit(VersionPacket packet) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void visit(GameVersionPacket packet) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void visit(SystemMessagePacket packet) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void visit(PingPacket packet) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void visit(LoginResponsePacket packet) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void visit(ForcedLogoutPacket packet) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void visit(SeatInfoPacket packet) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void visit(PlayerQueryResponsePacket packet) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void visit(SystemInfoResponsePacket packet) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void visit(JoinResponsePacket packet) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void visit(WatchResponsePacket packet) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void visit(UnwatchResponsePacket packet) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void visit(LeaveResponsePacket packet) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void visit(TableQueryResponsePacket packet) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void visit(CreateTableResponsePacket packet) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void visit(NotifyInvitedPacket packet) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void visit(NotifyJoinPacket packet) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void visit(NotifyLeavePacket packet) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void visit(NotifyRegisteredPacket packet) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void visit(NotifyWatchingPacket packet) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void visit(KickPlayerPacket packet) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void visit(ServiceTransportPacket packet) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void visit(LocalServiceTransportPacket packet) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void visit(MttTransportPacket packet) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void visit(EncryptedTransportPacket packet) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void visit(JoinChatChannelResponsePacket packet) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void visit(NotifyChannelChatPacket packet) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void visit(TableSnapshotPacket packet) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void visit(TableUpdatePacket packet) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void visit(TableRemovedPacket packet) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void visit(TournamentSnapshotPacket packet) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void visit(TournamentUpdatePacket packet) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void visit(TournamentRemovedPacket packet) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void visit(TableSnapshotListPacket packet) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void visit(TableUpdateListPacket packet) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void visit(TournamentSnapshotListPacket packet) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void visit(TournamentUpdateListPacket packet) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void visit(FilteredJoinTableResponsePacket packet) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void visit(FilteredJoinCancelResponsePacket packet) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void visit(FilteredJoinTableAvailablePacket packet) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void visit(ProbePacket packet) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void visit(MttRegisterResponsePacket packet) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void visit(MttUnregisterResponsePacket packet) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void visit(MttSeatedPacket packet) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void visit(MttPickedUpPacket packet) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void visit(NotifySeatedPacket packet) {
		// TODO Auto-generated method stub
		
	}
	
}

