// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)
package com.cubeia.firebase.io.protocol {

    import com.cubeia.firebase.io.PacketInputStream;
    import com.cubeia.firebase.io.PacketOutputStream;
    import com.cubeia.firebase.io.ProtocolObject;
  
    import flash.utils.ByteArray;

import com.cubeia.firebase.io.ObjectFactory;

public class ProtocolObjectFactory implements com.cubeia.firebase.io.ObjectFactory {
    public static function version():int {
        return 6523;
    }

    public function create(classId:int):ProtocolObject {
        switch(classId) {
            case 0:
                return new VersionPacket();
            case 1:
                return new GameVersionPacket();
            case 2:
                return new GoodPacket();
            case 3:
                return new BadPacket();
            case 4:
                return new SystemMessagePacket();
            case 5:
                return new Param();
            case 6:
                return new ParamFilter();
            case 7:
                return new PingPacket();
            case 10:
                return new LoginRequestPacket();
            case 11:
                return new LoginResponsePacket();
            case 12:
                return new LogoutPacket();
            case 13:
                return new PlayerInfoPacket();
            case 14:
                return new ForcedLogoutPacket();
            case 15:
                return new SeatInfoPacket();
            case 16:
                return new PlayerQueryRequestPacket();
            case 17:
                return new PlayerQueryResponsePacket();
            case 18:
                return new SystemInfoRequestPacket();
            case 19:
                return new SystemInfoResponsePacket();
            case 30:
                return new JoinRequestPacket();
            case 31:
                return new JoinResponsePacket();
            case 32:
                return new WatchRequestPacket();
            case 33:
                return new WatchResponsePacket();
            case 34:
                return new UnwatchRequestPacket();
            case 35:
                return new UnwatchResponsePacket();
            case 36:
                return new LeaveRequestPacket();
            case 37:
                return new LeaveResponsePacket();
            case 38:
                return new TableQueryRequestPacket();
            case 39:
                return new TableQueryResponsePacket();
            case 40:
                return new CreateTableRequestPacket();
            case 41:
                return new CreateTableResponsePacket();
            case 42:
                return new InvitePlayersRequestPacket();
            case 43:
                return new NotifyInvitedPacket();
            case 60:
                return new NotifyJoinPacket();
            case 61:
                return new NotifyLeavePacket();
            case 211:
                return new NotifyRegisteredPacket();
            case 63:
                return new NotifyWatchingPacket();
            case 64:
                return new KickPlayerPacket();
            case 80:
                return new TableChatPacket();
            case 100:
                return new GameTransportPacket();
            case 101:
                return new ServiceTransportPacket();
            case 103:
                return new LocalServiceTransportPacket();
            case 104:
                return new MttTransportPacket();
            case 105:
                return new EncryptedTransportPacket();
            case 120:
                return new JoinChatChannelRequestPacket();
            case 121:
                return new JoinChatChannelResponsePacket();
            case 122:
                return new LeaveChatChannelPacket();
            case 123:
                return new NotifyChannelChatPacket();
            case 124:
                return new ChannelChatPacket();
            case 142:
                return new LobbyQueryPacket();
            case 143:
                return new TableSnapshotPacket();
            case 144:
                return new TableUpdatePacket();
            case 145:
                return new LobbySubscribePacket();
            case 146:
                return new LobbyUnsubscribePacket();
            case 147:
                return new TableRemovedPacket();
            case 148:
                return new TournamentSnapshotPacket();
            case 149:
                return new TournamentUpdatePacket();
            case 150:
                return new TournamentRemovedPacket();
            case 151:
                return new LobbyObjectSubscribePacket();
            case 152:
                return new LobbyObjectUnsubscribePacket();
            case 153:
                return new TableSnapshotListPacket();
            case 154:
                return new TableUpdateListPacket();
            case 155:
                return new TournamentSnapshotListPacket();
            case 156:
                return new TournamentUpdateListPacket();
            case 170:
                return new FilteredJoinTableRequestPacket();
            case 171:
                return new FilteredJoinTableResponsePacket();
            case 172:
                return new FilteredJoinCancelRequestPacket();
            case 173:
                return new FilteredJoinCancelResponsePacket();
            case 174:
                return new FilteredJoinTableAvailablePacket();
            case 200:
                return new ProbeStamp();
            case 201:
                return new ProbePacket();
            case 205:
                return new MttRegisterRequestPacket();
            case 206:
                return new MttRegisterResponsePacket();
            case 207:
                return new MttUnregisterRequestPacket();
            case 208:
                return new MttUnregisterResponsePacket();
            case 209:
                return new MttSeatedPacket();
            case 210:
                return new MttPickedUpPacket();
            case 62:
                return new NotifySeatedPacket();
        }
        return null;
    }
}
}

// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)

