//  ABSTRACT:
//      GameState represents the states that the game has. An enum was chosen instead of a boolean because it would be possible,
//      in the future, that more states are used, e.g., "paused".

enum GameState {
    case notStarted
    case playing
}
