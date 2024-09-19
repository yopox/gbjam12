extends Node


#region Z Index
const BULLET_Z: int = 25
const POPUP_Z: int =  100
#endregion

#region Shop
const REROLL_COST: int = 1
const SHOP_LEVEL_MAX: int = 4
const UPGRADE_COST: Array[int] = [2, 4, 6]
const UNLOCK_COST: int = 2
var LEVEL_1_RANGES: Array[Array] = [range(0, 100), range(0, 0), range(0, 0), range(0, 0)]
var LEVEL_2_RANGES: Array[Array] = [range(0, 50), range(50, 100), range(0, 0), range(0, 0)]
var LEVEL_3_RANGES: Array[Array] = [range(0, 30), range(30, 70), range(70, 100), range(0, 0)]
var LEVEL_4_RANGES: Array[Array] = [range(0, 10), range(10, 30), range(30, 75), range(75, 100)]
#endregion

#region Fight - General
const FIGHT_START_DELAY: float = 0.5
const FIGHT_END_DELAY: float = 0.5
const TURN_DELAY: float = 1.5
#endregion

#region Bullets
const BULLET_SPEED: int = 60
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
								Tower.Type.ROCK]

const T2: Array[Tower.Type] = [Tower.Type.S2_1, Tower.Type.S2_2,
								Tower.Type.K2_1, Tower.Type.K2_2,
								Tower.Type.G2_1, Tower.Type.G2_2,
								Tower.Type.P2_1, Tower.Type.P2_2]

const T3: Array[Tower.Type] = [Tower.Type.S3_1, Tower.Type.S3_2,
								Tower.Type.K3_1, Tower.Type.K3_2,
								Tower.Type.G3_1, Tower.Type.G3_2,
								Tower.Type.P3_1, Tower.Type.P3_2,
								Tower.Type.MIRROR]

const T4: Array[Tower.Type] = [Tower.Type.S4_1, Tower.Type.S4_2,
								Tower.Type.K4_1, Tower.Type.K4_2,
								Tower.Type.G4_1, Tower.Type.G4_2,
								Tower.Type.P4_1, Tower.Type.P4_2]
#endregion

#region Board
const LOCKS: Array[int] = [5, 1, 1, 5, 7, 3, 3, 7]
#endregion
