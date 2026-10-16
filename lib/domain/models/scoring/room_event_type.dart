/// Roster/rules/order edit kinds. Every edit commits history and
/// acts as an undo barrier for turn undo.
enum RoomEventType { addPlayer, removePlayer, updateRules, reorderPlayers }
