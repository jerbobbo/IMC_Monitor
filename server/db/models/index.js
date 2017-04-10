const PlaylistGraph = require('./playlist_graph');
const Playlist = require('./playlist');
const User = require('./user');

Playlist.belongsTo(User, { foreignKey: 'user_id' });
PlaylistGraph.belongsTo(Playlist, { foreignKey: 'playlist_id' });
Playlist.hasMany(PlaylistGraph, { foreignKey: 'playlist_id' });


module.exports = {
  User: User,
  AccountingGateway: require('./accounting_gateway'),
  AccountingMembersName: require('./accounting_members_name'),
  AccountingRegionName: require('./accounting_region_name'),
  AccountingRegion: require('./accounting_region'),
  AccountingSummary: require('./accounting_summary'),
  CountryPrefix: require('./country_prefix'),
  CountryDistinct: require('./country_distinct'),
  PlaylistGraph: PlaylistGraph,
  Playlist: Playlist
};
