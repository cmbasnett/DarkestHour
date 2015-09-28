//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_AchillesCannon extends DHVehicleCannon;

defaultproperties
{
    InitialTertiaryAmmo=15
    TertiaryProjectileClass=class'DH_Vehicles.DH_AchillesCannonShellHE'
    SecondarySpread=0.006
    TertiarySpread=0.00156
    ManualRotationsPerSecond=0.011111
    FrontArmorFactor=5.0
    RightArmorFactor=2.5
    LeftArmorFactor=2.5
    RearArmorFactor=2.5
    FrontArmorSlope=45.0
    RightArmorSlope=15.0
    LeftArmorSlope=15.0
    FrontLeftAngle=332.0
    FrontRightAngle=28.0
    RearRightAngle=152.0
    RearLeftAngle=208.0
    ReloadSoundOne=sound'Vehicle_reloads.Reloads.SU_76_Reload_01'
    ReloadSoundTwo=sound'Vehicle_reloads.Reloads.SU_76_Reload_02'
    ReloadSoundThree=sound'Vehicle_reloads.Reloads.SU_76_Reload_03'
    ReloadSoundFour=sound'Vehicle_reloads.Reloads.SU_76_Reload_04'
    CannonFireSound(0)=SoundGroup'DH_AlliedVehicleSounds.17pounder.DH17pounder'
    CannonFireSound(1)=SoundGroup'DH_AlliedVehicleSounds.17pounder.DH17pounder'
    CannonFireSound(2)=SoundGroup'DH_AlliedVehicleSounds.17pounder.DH17pounder'
    ProjectileDescriptions(0)="APCBC"
    ProjectileDescriptions(1)="APDS"
    ProjectileDescriptions(2)="HE"
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
    YawBone="Turret"
    PitchBone="Gun"
    PitchUpLimit=15000
    PitchDownLimit=45000
    WeaponFireAttachmentBone="Barrel"
    GunnerAttachmentBone="com_attachment"
    WeaponFireOffset=5.5
    FireInterval=6.0
    FireSoundVolume=512.0
    FireForce="Explosion05"
    ProjectileClass=class'DH_Vehicles.DH_AchillesCannonShell'
    ShakeRotMag=(Z=50.0)
    ShakeRotRate=(Z=1000.0)
    ShakeRotTime=4.0
    ShakeOffsetMag=(Z=1.0)
    ShakeOffsetRate=(Z=100.0)
    ShakeOffsetTime=10.0
    AIInfo(0)=(bLeadTarget=true,WarnTargetPct=0.75,RefireRate=0.5)
    AIInfo(1)=(bLeadTarget=true,WarnTargetPct=0.75,RefireRate=0.015)
    CustomPitchUpLimit=3641
    CustomPitchDownLimit=64653
    BeginningIdleAnim="com_idle_close"
    InitialPrimaryAmmo=32
    InitialSecondaryAmmo=4
    PrimaryProjectileClass=class'DH_Vehicles.DH_AchillesCannonShell'
    SecondaryProjectileClass=class'DH_Vehicles.DH_AchillesCannonShellAPDS'
    Mesh=SkeletalMesh'DH_Wolverine_anm.Achilles_turret_ext'
    Skins(0)=texture'DH_VehiclesUK_tex.ext_vehicles.Achilles_turret_ext'
    Skins(1)=texture'DH_VehiclesUK_tex.int_vehicles.Achilles_turret_int'
    Skins(2)=texture'DH_VehiclesUK_tex.int_vehicles.Achilles_turret_int'
    CollisionStaticMesh=StaticMesh'DH_allies_vehicles_stc.M10.Achilles_turret_coll'
    SoundVolume=130
    SoundRadius=300.0
}
