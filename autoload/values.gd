extends Node


#region Z Index
const BULLET_Z: int = 25
const POPUP_Z: int =  100
#endregion

#region Hero
const BASE_LIFE: int = 200
#endregion

#region Shop
const REROLL_COST: int = 1
const SELL: Array[int] = [0, 1, 2, 3]
const SHOP_LEVEL_MAX: int = 4
const UPGRADE_COST: Array[int] = [2, 4, 6]
const UNLOCK_COST: int = 2
const MOVE_COST: int = 1
var LEVEL_1_RANGES: Array[Array] = [range(0, 100), range(0, 0), range(0, 0), range(0, 0)]
var LEVEL_2_RANGES: Array[Array] = [range(0, 40), range(40, 100), range(0, 0), range(0, 0)]
var LEVEL_3_RANGES: Array[Array] = [range(0, 20), range(20, 65), range(65, 100), range(0, 0)]
var LEVEL_4_RANGES: Array[Array] = [range(0, 05), range(05, 20), range(20, 70), range(70, 100)]
#endregion

#region Fight - General
const FIGHT_REVEAL_DELAY: float = 1.2
const FIGHT_DESTROY_BULLETS_DELAY: float = 0
const FIGHT_START_DELAY: float = 1
const FIGHT_END_DELAY: float = 1.0
const FIGHT_TURN_DELAY: float = 2.25
const VIBRATION_DURATION: int = 150
const GAME_OVER_DELAY: float = 2
#endregion

#region Bullets
const BULLET_SPEED: int = 80
const ARROW_SPEED: int = 160
#endregion

#region Fight - Towers
const TOWER_SHOOT_FRAME_DURATION: float = 0.35
const PUMPKIN_DELAY: float =              0.25
const REACTION: float =                   1.0
#endregion

#region Towers Levels
const T1: Array[Tower.Type] = [Tower.Type.S1_1, Tower.Type.S1_2,
								Tower.Type.K1_1, Tower.Type.K1_2,
								Tower.Type.G1_1, Tower.Type.G1_2,
								Tower.Type.P1_1, Tower.Type.P1_2,
								Tower.Type.COIN]

const T2: Array[Tower.Type] = [Tower.Type.S2_1, Tower.Type.S2_2,
								Tower.Type.K2_1, Tower.Type.K2_2,
								Tower.Type.G2_1, Tower.Type.G2_2,
								Tower.Type.P2_1, Tower.Type.P2_2,
								Tower.Type.COIN]

const T3: Array[Tower.Type] = [Tower.Type.S3_1, Tower.Type.S3_2,
								Tower.Type.K3_1, Tower.Type.K3_2,
								Tower.Type.G3_1, Tower.Type.G3_2,
								Tower.Type.P3_1, Tower.Type.P3_2,
								Tower.Type.BOMB]

const T4: Array[Tower.Type] = [Tower.Type.S4_1, Tower.Type.S4_2,
								Tower.Type.K4_1, Tower.Type.K4_2,
								Tower.Type.G4_1, Tower.Type.G4_2,
								Tower.Type.P4_1, Tower.Type.P4_2,
								Tower.Type.MIRROR]
#endregion

#region Board
const LOCKS: Array[int] = [5, 1, 1, 5, 7, 3, 3, 7]
#endregion

#region Misc
const DEBUG: bool = false
#endregion
