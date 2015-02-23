//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_Sdkfz2342Cannon extends DH_ROTankCannon;

defaultproperties
{
    SecondarySpread=0.0013
    ManualRotationsPerSecond=0.04
    FrontArmorFactor=3.0
    RightArmorFactor=1.0
    LeftArmorFactor=1.0
    RearArmorFactor=1.0
    FrontArmorSlope=40.0
    RightArmorSlope=25.0
    LeftArmorSlope=25.0
    RearArmorSlope=25.0
    FrontLeftAngle=331.0
    FrontRightAngle=29.0
    RearRightAngle=151.0
    RearLeftAngle=209.0
    ReloadSoundOne=sound'DH_Vehicle_Reloads.Reloads.reload_01s_01'
    ReloadSoundTwo=sound'DH_Vehicle_Reloads.Reloads.reload_01s_02'
    ReloadSoundThree=sound'DH_Vehicle_Reloads.Reloads.reload_01s_03'
    ReloadSoundFour=sound'DH_Vehicle_Reloads.Reloads.reload_01s_04'
    CannonFireSound(0)=SoundGroup'Vehicle_Weapons.Panzeriii.50mm_fire01'
    CannonFireSound(1)=SoundGroup'Vehicle_Weapons.Panzeriii.50mm_fire02'
    CannonFireSound(2)=SoundGroup'Vehicle_Weapons.Panzeriii.50mm_fire03'
    ProjectileDescriptions(0)="APCBC"
    RangeSettings(1)=100
    RangeSettings(2)=200
    RangeSettings(3)=300
    RangeSettings(4)=400
    RangeSettings(5)=500
    RangeSettings(6)=600
    RangeSettings(7)=700
    RangeSettings(8)=800
    RangeSettings(9)=900
    RangeSettings(10)=1000
    RangeSettings(11)=1100
    RangeSettings(12)=1200
    RangeSettings(13)=1300
    RangeSettings(14)=1400
    RangeSettings(15)=1500
    RangeSettings(16)=1600
    RangeSettings(17)=1700
    RangeSettings(18)=1800
    RangeSettings(19)=1900
    RangeSettings(20)=2000
    ReloadSound=sound'Vehicle_reloads.Reloads.MG34_ReloadHidden'
    NumAltMags=10
    AltTracerProjectileClass=class'DH_MG42VehicleTracerBullet'
    AltFireTracerFrequency=7
    bUsesTracers=true
    bAltFireTracersOnly=true
    MinCommanderHitHeight=37.0
    VehHitpoints(0)=(PointRadius=14.0,PointScale=1.0,PointBone="com_player",PointOffset=(X=4.0,Z=-14.0))
    hudAltAmmoIcon=texture'InterfaceArt_tex.HUD.mg42_ammo'
    YawBone="Turret"
    PitchBone="Gun"
    PitchUpLimit=15000
    PitchDownLimit=45000
    WeaponFireAttachmentBone="Gun"
    GunnerAttachmentBone="com_attachment"
    WeaponFireOffset=175.0
    AltFireOffset=(X=21.0,Y=14.5,Z=1.5)
    bAmbientAltFireSound=true
    FireInterval=4.0
    AltFireInterval=0.05
    EffectEmitterClass=class'ROEffects.TankCannonFireEffect'
    AmbientEffectEmitterClass=class'ROVehicles.TankMGEmitter'
    bAmbientEmitterAltFireOnly=true
    FireSoundVolume=512.0
    AltFireSoundClass=SoundGroup'DH_WeaponSounds.mg42.Mg42_FireLoop01'
    AltFireSoundScaling=3.0
    AltFireEndSound=SoundGroup'DH_WeaponSounds.mg42.Mg42_FireEnd01'
    FireForce="Explosion05"
    ProjectileClass=class'DH_Vehicles.DH_Sdkfz2342CannonShell'
    AltFireProjectileClass=class'DH_Vehicles.DH_MG42VehicleBullet'
    ShakeRotMag=(Z=50.0)
    ShakeRotRate=(Z=1000.0)
    ShakeRotTime=4.0
    ShakeOffsetMag=(Z=1.0)
    ShakeOffsetRate=(Z=100.0)
    ShakeOffsetTime=10.0
    AltShakeRotMag=(X=1.0,Y=1.0,Z=1.0)
    AltShakeRotRate=(X=10000.0,Y=10000.0,Z=10000.0)
    AltShakeRotTime=2.0
    AltShakeOffsetMag=(X=0.1,Y=0.1,Z=0.1)
    AltShakeOffsetRate=(X=1000.0,Y=1000.0,Z=1000.0)
    AltShakeOffsetTime=2.0
    AIInfo(0)=(bLeadTarget=true,WarnTargetPct=0.75,RefireRate=0.5)
    AIInfo(1)=(bLeadTarget=true,WarnTargetPct=0.75,RefireRate=0.015)
    CustomPitchUpLimit=3640
    CustomPitchDownLimit=63715
    BeginningIdleAnim="com_idle_close"
    InitialPrimaryAmmo=35
    InitialSecondaryAmmo=20
    InitialAltAmmo=150
    PrimaryProjectileClass=class'DH_Vehicles.DH_Sdkfz2342CannonShell'
    SecondaryProjectileClass=class'DH_Vehicles.DH_Sdkfz2342CannonShellHE'
    Mesh=SkeletalMesh'DH_Sdkfz234ArmoredCar_anm.Puma_turret_ext'
    Skins(0)=texture'DH_VehiclesGE_tex6.ext_vehicles.Puma_turret_dunk'
    SoundVolume=130
    SoundRadius=200.0
}
