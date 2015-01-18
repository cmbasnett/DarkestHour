//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_ShermanCannonPawn extends DH_AmericanTankCannonPawn;

defaultproperties
{
    OverlayCenterSize=0.542000
    DestroyedScopeOverlay=texture'DH_VehicleOpticsDestroyed_tex.Allied.Sherman_sight_destroyed'
    PoweredRotateSound=sound'DH_AlliedVehicleSounds.Sherman.ShermanTurretTraverse'
    PoweredPitchSound=sound'Vehicle_Weapons.Turret.manual_turret_elevate'
    PoweredRotateAndPitchSound=sound'DH_AlliedVehicleSounds.Sherman.ShermanTurretTraverse'
    CannonScopeOverlay=texture'DH_VehicleOptics_tex.Allied.Sherman_sight_background'
    bLockCameraDuringTransition=true
    WeaponFOV=24.000000
    AmmoShellTexture=texture'DH_InterfaceArt_tex.Tank_Hud.ShermanShell'
    AmmoShellReloadTexture=texture'DH_InterfaceArt_tex.Tank_Hud.ShermanShell_reload'
    DriverPositions(0)=(ViewLocation=(X=21.000000,Y=19.000000,Z=4.000000),ViewFOV=24.000000,PositionMesh=SkeletalMesh'DH_Sherman_anm.ShermanM4A1_turret_int',TransitionUpAnim="Periscope_in",ViewPitchUpLimit=4551,ViewPitchDownLimit=64079,ViewPositiveYawLimit=19000,ViewNegativeYawLimit=-20000,bDrawOverlays=true)
    DriverPositions(1)=(ViewFOV=90.000000,PositionMesh=SkeletalMesh'DH_Sherman_anm.ShermanM4A1_turret_int',TransitionUpAnim="com_open",ViewPitchUpLimit=1,ViewPitchDownLimit=65535,ViewPositiveYawLimit=65536,ViewNegativeYawLimit=-65536,bDrawOverlays=true)
    DriverPositions(2)=(ViewLocation=(X=-5.000000,Z=14.000000),ViewFOV=90.000000,PositionMesh=SkeletalMesh'DH_Sherman_anm.ShermanM4A1_turret_int',TransitionDownAnim="com_close",DriverTransitionAnim="stand_idlehip_binoc",ViewPitchUpLimit=10000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=65536,ViewNegativeYawLimit=-65536,bExposed=true)
    DriverPositions(3)=(ViewLocation=(X=-5.000000,Z=14.000000),ViewFOV=12.000000,PositionMesh=SkeletalMesh'DH_Sherman_anm.ShermanM4A1_turret_int',DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=10000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=65536,ViewNegativeYawLimit=-65536,bDrawOverlays=true,bExposed=true)
    GunClass=class'DH_Vehicles.DH_ShermanCannon'
    CameraBone="Gun"
    DrivePos=(X=3.000000,Z=-5.000000)
    DriveAnim="stand_idlehip_binoc"
    EntryRadius=130.000000
    TPCamDistance=300.000000
    TPCamLookat=(X=-25.000000,Z=0.000000)
    TPCamWorldOffset=(Z=120.000000)
    PitchUpLimit=6000
    PitchDownLimit=64000
    SoundVolume=130
    PeriscopePositionIndex=1
}
