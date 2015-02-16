//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_G43ScopedAttachment extends DHWeaponAttachment;

defaultproperties
{
    mMuzFlashClass=class'ROEffects.MuzzleFlash3rdSVT'
    ROShellCaseClass=class'ROAmmo.RO3rdShellEject762x54mm'
    PA_MovementAnims(0)="stand_jogF_kar"
    PA_MovementAnims(1)="stand_jogB_kar"
    PA_MovementAnims(2)="stand_jogL_kar"
    PA_MovementAnims(3)="stand_jogR_kar"
    PA_MovementAnims(4)="stand_jogFL_kar"
    PA_MovementAnims(5)="stand_jogFR_kar"
    PA_MovementAnims(6)="stand_jogBL_kar"
    PA_MovementAnims(7)="stand_jogBR_kar"
    PA_CrouchAnims(0)="crouch_walkF_scope"
    PA_CrouchAnims(1)="crouch_walkB_scope"
    PA_CrouchAnims(2)="crouch_walkL_scope"
    PA_CrouchAnims(3)="crouch_walkR_scope"
    PA_CrouchAnims(4)="crouch_walkFL_scope"
    PA_CrouchAnims(5)="crouch_walkFR_scope"
    PA_CrouchAnims(6)="crouch_walkBL_scope"
    PA_CrouchAnims(7)="crouch_walkBR_scope"
    PA_WalkAnims(0)="stand_walkFhip_kar"
    PA_WalkAnims(1)="stand_walkBhip_kar"
    PA_WalkAnims(2)="stand_walkLhip_kar"
    PA_WalkAnims(3)="stand_walkRhip_kar"
    PA_WalkAnims(4)="stand_walkFLhip_kar"
    PA_WalkAnims(5)="stand_walkFRhip_kar"
    PA_WalkAnims(6)="stand_walkBLhip_kar"
    PA_WalkAnims(7)="stand_walkBRhip_kar"
    PA_WalkIronAnims(0)="stand_walkFiron_scope"
    PA_WalkIronAnims(1)="stand_walkBiron_scope"
    PA_WalkIronAnims(2)="stand_walkLiron_scope"
    PA_WalkIronAnims(3)="stand_walkRiron_scope"
    PA_WalkIronAnims(4)="stand_walkFLiron_scope"
    PA_WalkIronAnims(5)="stand_walkFRiron_scope"
    PA_WalkIronAnims(6)="stand_walkBLiron_scope"
    PA_WalkIronAnims(7)="stand_walkBRiron_scope"
    PA_SprintAnims(0)="stand_sprintF_kar"
    PA_SprintAnims(1)="stand_sprintB_kar"
    PA_SprintAnims(2)="stand_sprintL_kar"
    PA_SprintAnims(3)="stand_sprintR_kar"
    PA_SprintAnims(4)="stand_sprintFL_kar"
    PA_SprintAnims(5)="stand_sprintFR_kar"
    PA_SprintAnims(6)="stand_sprintBL_kar"
    PA_SprintAnims(7)="stand_sprintBR_kar"
    PA_SprintCrouchAnims(0)="crouch_sprintF_kar"
    PA_SprintCrouchAnims(1)="crouch_sprintB_kar"
    PA_SprintCrouchAnims(2)="crouch_sprintL_kar"
    PA_SprintCrouchAnims(3)="crouch_sprintR_kar"
    PA_SprintCrouchAnims(4)="crouch_sprintFL_kar"
    PA_SprintCrouchAnims(5)="crouch_sprintFR_kar"
    PA_SprintCrouchAnims(6)="crouch_sprintBL_kar"
    PA_SprintCrouchAnims(7)="crouch_sprintBR_kar"
    PA_LimpIronAnims(0)="stand_limpFiron_scope"
    PA_LimpIronAnims(1)="stand_limpBiron_scope"
    PA_LimpIronAnims(2)="stand_limpLiron_scope"
    PA_LimpIronAnims(3)="stand_limpRiron_scope"
    PA_LimpIronAnims(4)="stand_limpFLiron_scope"
    PA_LimpIronAnims(5)="stand_limpFRiron_scope"
    PA_LimpIronAnims(6)="stand_limpBLiron_scope"
    PA_LimpIronAnims(7)="stand_limpBRiron_scope"
    PA_TurnRightAnim="stand_turnRhip_kar"
    PA_TurnLeftAnim="stand_turnLhip_kar"
    PA_TurnIronRightAnim="stand_turnRiron_scope"
    PA_TurnIronLeftAnim="stand_turnLiron_scope"
    PA_CrouchTurnIronRightAnim="crouch_turnRiron_scope"
    PA_CrouchTurnIronLeftAnim="crouch_turnRiron_scope"
    PA_StandToProneAnim="StandtoProne_kar"
    PA_CrouchToProneAnim="CrouchtoProne_kar"
    PA_ProneToStandAnim="PronetoStand_kar"
    PA_ProneToCrouchAnim="PronetoCrouch_kar"
    PA_DiveToProneStartAnim="prone_diveF_kar"
    PA_DiveToProneEndAnim="prone_diveend_kar"
    PA_CrouchTurnRightAnim="crouch_turnR_scope"
    PA_CrouchTurnLeftAnim="crouch_turnL_scope"
    PA_CrouchIdleRestAnim="crouch_idle_scope"
    PA_IdleCrouchAnim="crouch_idle_scope"
    PA_IdleRestAnim="stand_idlehip_kar"
    PA_IdleWeaponAnim="stand_idlehip_kar"
    PA_IdleIronRestAnim="stand_idleiron_scope"
    PA_IdleIronWeaponAnim="stand_idleiron_scope"
    PA_IdleCrouchIronWeaponAnim="crouch_idleiron_scope"
    PA_ReloadAnim="stand_reloadhalf_svt40"
    PA_ProneReloadAnim="prone_reloadhalf_svt40"
    PA_ReloadEmptyAnim="stand_reloadempty_svt40"
    PA_ProneReloadEmptyAnim="prone_reloadempty_svt40"
    PA_ProneIdleRestAnim="prone_idle_kar"
    PA_Fire="stand_shoothip_kar"
    PA_IronFire="stand_shootiron_scope"
    PA_CrouchFire="crouch_shoot_scope"
    PA_CrouchIronFire="crouch_shootiron_scope"
    PA_ProneFire="prone_shoot_kar"
    PA_MoveStandFire(0)="stand_shootFhip_kar"
    PA_MoveStandFire(1)="stand_shootFhip_kar"
    PA_MoveStandFire(2)="stand_shootLRhip_kar"
    PA_MoveStandFire(3)="stand_shootLRhip_kar"
    PA_MoveStandFire(4)="stand_shootFLhip_kar"
    PA_MoveStandFire(5)="stand_shootFRhip_kar"
    PA_MoveStandFire(6)="stand_shootFRhip_kar"
    PA_MoveStandFire(7)="stand_shootFLhip_kar"
    PA_MoveCrouchFire(0)="crouch_shootF_scope"
    PA_MoveCrouchFire(1)="crouch_shootF_scope"
    PA_MoveCrouchFire(2)="crouch_shootLR_scope"
    PA_MoveCrouchFire(3)="crouch_shootLR_scope"
    PA_MoveCrouchFire(4)="crouch_shootF_scope"
    PA_MoveCrouchFire(5)="crouch_shootF_scope"
    PA_MoveCrouchFire(6)="crouch_shootF_scope"
    PA_MoveCrouchFire(7)="crouch_shootF_scope"
    PA_MoveWalkFire(0)="stand_shootFwalk_kar"
    PA_MoveWalkFire(1)="stand_shootFwalk_kar"
    PA_MoveWalkFire(2)="stand_shootLRwalk_kar"
    PA_MoveWalkFire(3)="stand_shootLRwalk_kar"
    PA_MoveWalkFire(4)="stand_shootFLwalk_kar"
    PA_MoveWalkFire(5)="stand_shootFRwalk_kar"
    PA_MoveWalkFire(6)="stand_shootFRwalk_kar"
    PA_MoveWalkFire(7)="stand_shootFLwalk_kar"
    PA_MoveStandIronFire(0)="stand_shootiron_scope"
    PA_MoveStandIronFire(1)="stand_shootiron_scope"
    PA_MoveStandIronFire(2)="stand_shootLRiron_scope"
    PA_MoveStandIronFire(3)="stand_shootLRiron_scope"
    PA_MoveStandIronFire(4)="stand_shootFLiron_scope"
    PA_MoveStandIronFire(5)="stand_shootFRiron_scope"
    PA_MoveStandIronFire(6)="stand_shootFRiron_scope"
    PA_MoveStandIronFire(7)="stand_shootFLiron_scope"
    PA_AltFire="stand_idlestrike_kar"
    PA_CrouchAltFire="stand_idlestrike_kar"
    PA_ProneAltFire="prone_idlestrike_bayo"
    PA_FireLastShot="stand_shoothip_kar"
    PA_IronFireLastShot="stand_shootiron_scope"
    PA_CrouchFireLastShot="crouch_shoot_scope"
    PA_ProneFireLastShot="prone_shoot_kar"
    WA_Idle="Idle_g43"
    WA_IdleEmpty="Idle_g43"
    WA_Fire="shoot_g43"
    WA_Reload="reloadhalf_g43"
    WA_ReloadEmpty="reloadempty_g43"
    WA_ProneReload="prone_reloadhalf_g43"
    WA_ProneReloadEmpty="prone_reloadempty_g43"
    MenuImage=texture'InterfaceArt_tex.Menu_weapons.g43scope'
    MenuMagizineImage=texture'InterfaceArt_tex.HUD.G43_ammo'
    MenuDescription="Semi-automatic rifle, used a 10-round mag with good accuracy and stopping power. Many fitted with a 4x ZF4 sniper scope as factory-standard."
    bRapidFire=false
    Mesh=SkeletalMesh'Weapons3rd_anm.g43scope'
}
