//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_ShermanCannon extends DH_ROTankCannon;

defaultproperties
{
    InitialTertiaryAmmo=5
    TertiaryProjectileClass=class'DH_Vehicles.DH_ShermanCannonShellSmoke'
    SecondarySpread=0.00175
    TertiarySpread=0.0036
    ManualRotationsPerSecond=0.02
    PoweredRotationsPerSecond=0.0625
    FrontArmorFactor=7.6
    RightArmorFactor=5.1
    LeftArmorFactor=5.1
    RearArmorFactor=5.1
    RightArmorSlope=5.0
    LeftArmorSlope=5.0
    FrontLeftAngle=316.0
    FrontRightAngle=44.0
    RearRightAngle=136.0
    RearLeftAngle=224.0
    ReloadSoundOne=sound'DH_Vehicle_Reloads.Reloads.reload_01s_01'
    ReloadSoundTwo=sound'DH_Vehicle_Reloads.Reloads.reload_01s_02'
    ReloadSoundThree=sound'DH_Vehicle_Reloads.Reloads.reload_01s_03'
    ReloadSoundFour=sound'DH_Vehicle_Reloads.Reloads.reload_01s_04'
    CannonFireSound(0)=SoundGroup'DH_AlliedVehicleSounds.75mm.DHM3-75mm'
    CannonFireSound(1)=SoundGroup'DH_AlliedVehicleSounds.75mm.DHM3-75mm'
    CannonFireSound(2)=SoundGroup'DH_AlliedVehicleSounds.75mm.DHM3-75mm'
    ProjectileDescriptions(0)="APCBC"
    ProjectileDescriptions(2)="Smoke"
    AddedPitch=68
    ReloadSound=sound'Vehicle_reloads.Reloads.MG34_ReloadHidden'
    NumAltMags=5
    AltTracerProjectileClass=class'DH_30CalVehicleTracerBullet'
    AltFireTracerFrequency=5
    bUsesTracers=true
    bAltFireTracersOnly=true
    MinCommanderHitHeight=46.0;
    VehHitpoints(0)=(PointRadius=9.0,PointScale=1.0,PointBone="com_player",PointOffset=(Z=10.0))
    VehHitpoints(1)=(PointRadius=16.0,PointScale=1.0,PointBone="com_player",PointOffset=(Z=-12.0))
    hudAltAmmoIcon=texture'InterfaceArt_tex.HUD.mg42_ammo'
    YawBone="Turret"
    PitchBone="Gun"
    PitchUpLimit=15000
    PitchDownLimit=45000
    WeaponFireAttachmentBone="Barrel"
    GunnerAttachmentBone="com_attachment"
    WeaponFireOffset=12.0
    AltFireOffset=(X=-85.0,Y=-25.0)
    bAmbientAltFireSound=true
    FireInterval=4.0
    AltFireInterval=0.12
    EffectEmitterClass=class'ROEffects.TankCannonFireEffect'
    AmbientEffectEmitterClass=class'ROVehicles.TankMGEmitter'
    bAmbientEmitterAltFireOnly=true
    FireSoundVolume=512.0
    AltFireSoundClass=SoundGroup'DH_AlliedVehicleSounds2.3Cal.V30cal_loop01'
    AltFireSoundScaling=3.0
    AltFireEndSound=SoundGroup'DH_AlliedVehicleSounds2.3Cal.V30cal_end01'
    FireForce="Explosion05"
    ProjectileClass=class'DH_Vehicles.DH_ShermanCannonShell'
    AltFireProjectileClass=class'DH_Vehicles.DH_30CalVehicleBullet'
    ShakeRotMag=(Z=50.0)
    ShakeRotRate=(Z=1000.0)
    ShakeRotTime=4.0
    ShakeOffsetMag=(Z=1.0)
    ShakeOffsetRate=(Z=100.0)
    ShakeOffsetTime=10.0
    AltShakeRotMag=(X=0.01,Y=0.01,Z=0.01)
    AltShakeRotRate=(X=1000.0,Y=1000.0,Z=1000.0)
    AltShakeRotTime=2.0
    AltShakeOffsetMag=(X=0.01,Y=0.01,Z=0.01)
    AltShakeOffsetRate=(X=1000.0,Y=1000.0,Z=1000.0)
    AltShakeOffsetTime=2.0
    AIInfo(0)=(bLeadTarget=true,WarnTargetPct=0.75,RefireRate=0.5)
    AIInfo(1)=(bLeadTarget=true,WarnTargetPct=0.75,RefireRate=0.015)
    CustomPitchUpLimit=4551
    CustomPitchDownLimit=64079
    BeginningIdleAnim="com_idle_close"
    InitialPrimaryAmmo=45
    InitialSecondaryAmmo=40
    InitialAltAmmo=200
    PrimaryProjectileClass=class'DH_Vehicles.DH_ShermanCannonShell'
    SecondaryProjectileClass=class'DH_Vehicles.DH_ShermanCannonShellHE'
    Mesh=SkeletalMesh'DH_Sherman_anm.ShermanM4A1_turret_ext'
    Skins(0)=texture'DH_VehiclesUS_tex.ext_vehicles.Sherman_body_ext'
    Skins(1)=texture'DH_VehiclesUS_tex.ext_vehicles.Sherman_scoop_ext'
    Skins(2)=texture'DH_VehiclesUS_tex.int_vehicles.Sherman_turret_int'
    Skins(3)=texture'DH_VehiclesUS_tex.int_vehicles.Sherman_body_int2'
    SoundVolume=130
    SoundRadius=200.0
}
