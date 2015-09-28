//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_6PounderGunCannon extends DHATGunCannon;

#exec OBJ LOAD FILE=..\Sounds\DH_ArtillerySounds.uax

defaultproperties
{
    InitialTertiaryAmmo=20
    TertiaryProjectileClass=class'DH_Guns.DH_6PounderCannonShellHE'
    SecondarySpread=0.0048
    TertiarySpread=0.00125
    ReloadSoundOne=sound'DH_Vehicle_Reloads.Reloads.reload_01s_01'
    ReloadSoundTwo=sound'DH_Vehicle_Reloads.Reloads.reload_01s_03'
    ReloadSoundThree=sound'DH_Vehicle_Reloads.Reloads.reload_01s_04'
    CannonFireSound(0)=SoundGroup'DH_ArtillerySounds.ATGun.57mm_fire01'
    CannonFireSound(1)=SoundGroup'DH_ArtillerySounds.ATGun.57mm_fire02'
    CannonFireSound(2)=SoundGroup'DH_ArtillerySounds.ATGun.57mm_fire03'
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
    AddedPitch=50
    YawBone="Turret"
    YawStartConstraint=-7000.0
    YawEndConstraint=7000.0
    PitchBone="Gun"
    PitchUpLimit=15000
    PitchDownLimit=45000
    WeaponFireAttachmentBone="Barrel"
    GunnerAttachmentBone="com_player"
    WeaponFireOffset=19.0
    RotationsPerSecond=0.025
    FireInterval=3.0
    FireSoundVolume=512.0
    FireForce="Explosion05"
    ProjectileClass=class'DH_Guns.DH_6PounderCannonShell'
    ShakeRotMag=(Z=110.0)
    ShakeRotRate=(Z=1000.0)
    ShakeRotTime=2.0
    ShakeOffsetMag=(Z=5.0)
    ShakeOffsetRate=(Z=100.0)
    ShakeOffsetTime=2.0
    AIInfo(0)=(bLeadTarget=true,WarnTargetPct=0.75,RefireRate=0.5)
    AIInfo(1)=(bLeadTarget=true,WarnTargetPct=0.75,RefireRate=0.015)
    CustomPitchUpLimit=2731
    CustomPitchDownLimit=64626
    MaxPositiveYaw=6000
    MaxNegativeYaw=-6000
    bLimitYaw=true
    BeginningIdleAnim="com_idle_close"
    InitialPrimaryAmmo=66
    InitialSecondaryAmmo=10
    PrimaryProjectileClass=class'DH_Guns.DH_6PounderCannonShell'
    SecondaryProjectileClass=class'DH_Guns.DH_6PounderCannonShellAPDS'
    Mesh=SkeletalMesh'DH_6PounderGun_anm.6pounder_turret'
    Skins(0)=texture'DH_Artillery_Tex.6pounder.6pounder'
    Skins(1)=texture'DH_Artillery_Tex.6pounder.6pounder' // muzzle brake
    Skins(2)=texture'Weapons1st_tex.Bullets.Bullet_Shell_Rifle_MN'
    SoundVolume=130
    SoundRadius=200.0
}
