//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================
// TODO
//==============================================================================
// [ ] Rename Shells & Set up Classes/loadout
// [ ] Gunner animations
// [ ] Destroyed mesh (get rid of a few 1000 tris on this cause it's way too heavy atm)
// [ ] Add to maps
// [ ] Fix handling to be less bouncy
// [ ] Fix muzzle smoke to use sideways smoke
// [ ] Hit points
// [ ] Damage effect positions
// [ ] Factory classes
// [ ] Destroyed track statics
//==============================================================================
// BUGS
//==============================================================================
// [ ] water hit sound on the 105 shell can be heard from infinity
//==============================================================================

class DH_WespeTank extends DHArmoredVehicle;

// TODO: can't we move this check to the base class?
simulated function ClientKDriverEnter(PlayerController PC)
{
    local DHPlayer DHP;

    super.ClientKDriverEnter(PC);

    DHP = DHPlayer(PC);

    if (DHP != none && DHP.IsArtilleryOperator())
    {
        DHP.QueueHint(50, false);
    }
}

public function SpawnVehicleAttachments()
{
    local int i;
    local DHIdentifierAttachment IdentifierAttachment;

    super.SpawnVehicleAttachments();

    for (i = 0; i < VehicleAttachments.Length; i++)
    {
        if (VehicleAttachments[i].Actor != none && VehicleAttachments[i].Actor.IsA('DHIdentifierAttachment'))
        {
            IdentifierAttachment = DHIdentifierAttachment(VehicleAttachments[i].Actor);
            IdentifierAttachment.SetIdentiferByType(ID_UserNumber, "123");
        }
    }
}

exec function SetId(string NewId)
{
    local int i;
    local DHIdentifierAttachment IdentifierAttachment;

    for (i = 0; i < VehicleAttachments.Length; i++)
    {
        if (VehicleAttachments[i].Actor.IsA('DHIdentifierAttachment'))
        {
            IdentifierAttachment = DHIdentifierAttachment(VehicleAttachments[i].Actor);
            IdentifierAttachment.SetIdentiferByType(ID_UserNumber, NewId);
        }
    }
}

defaultproperties
{
    // Vehicle properties
    VehicleNameString="Sd.Kfz. 124 Wespe"
    VehicleTeam=0
    VehicleMass=11.5
    ReinforcementCost=5

    MapIconMaterial=Texture'DH_InterfaceArt2_tex.tank_artillery_topdown'

    // Artillery
    bIsArtilleryVehicle=true

    // Hull mesh
    Mesh=SkeletalMesh'DH_Wespe_anm.WESPE_BODY_EXT'
    Skins(0)=Texture'DH_Wespe_tex.wespe.wespe_body_ext_camo'
    Skins(1)=Texture'DH_Wespe_tex.wespe.wespe_treads'
    Skins(2)=Texture'DH_Wespe_tex.wespe.wespe_treads'
    Skins(3)=Texture'DH_Wespe_tex.wespe.wespe_body_int'
    // CollisionAttachments(0)=(StaticMesh=StaticMesh'DH_allies_vehicles_stc2.priest.priest_visor_coll',AttachBone="driver_hatch") // collision attachment for driver's armoured visor

    // Vehicle weapons & passengers
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_WespeCannonPawn',WeaponBone="turret_placement")

    LeftTrackSoundBone=

    // Driver
    UnbuttonedPositionIndex=3
    InitialPositionIndex=2
    PeriscopePositionIndex=1
    PeriscopeCameraBone="PERISCOPE_CAMERA"

    bLockCameraDuringTransition=true

    BeginningIdleAnim="idle"

    // open front hatch
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Wespe_anm.wespe_body_int',TransitionUpAnim="hatch_close",ViewPitchUpLimit=4096,ViewPitchDownLimit=61440,ViewPositiveYawLimit=8192,ViewNegativeYawLimit=-8192,bExposed=true)
    // periscope
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Wespe_anm.wespe_body_int',TransitionUpAnim="overlay_out",TransitionDownAnim="hatch_open",ViewPitchUpLimit=1,ViewPitchDownLimit=65536,ViewPositiveYawLimit=0,ViewNegativeYawLimit=-1,bDrawOverlays=true)
    // neutral
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_Wespe_anm.wespe_body_int',TransitionUpAnim="raise",TransitionDownAnim="overlay_in",ViewPitchUpLimit=8192,ViewPitchDownLimit=56000,ViewPositiveYawLimit=22000,ViewNegativeYawLimit=-22000)
    // turned out
    DriverPositions(3)=(PositionMesh=SkeletalMesh'DH_Wespe_anm.wespe_body_int',TransitionDownAnim="lower",ViewPitchUpLimit=8192,ViewPitchDownLimit=56000,ViewPositiveYawLimit=22000,ViewNegativeYawLimit=-22000,bExposed=true)

    // Hull armor
    FrontArmor(0)=(Thickness=5.08,Slope=-45.0,MaxRelativeHeight=-47.6,LocationName="lower nose")
    FrontArmor(1)=(Thickness=5.08,MaxRelativeHeight=-32.2,LocationName="mid nose") // represents flattest, front facing part of rounded nose plate
    FrontArmor(2)=(Thickness=5.08,Slope=45.0,MaxRelativeHeight=-6.4,LocationName="upper nose")
    FrontArmor(3)=(Thickness=1.27,Slope=70.0,MaxRelativeHeight=8.0,LocationName="upper")
    FrontArmor(4)=(Thickness=1.27,Slope=30.0,LocationName="superstructure")
    RightArmor(0)=(Thickness=3.81,MaxRelativeHeight=-16.0,LocationName="lower") // TODO: query AFV database notes this 1.5" lower side armour is "soft"?
    RightArmor(1)=(Thickness=1.27,LocationName="superstructure")
    LeftArmor(0)=(Thickness=3.81,MaxRelativeHeight=-16.0,LocationName="lower")
    LeftArmor(1)=(Thickness=1.27,LocationName="superstructure")
    RearArmor(0)=(Thickness=3.81,Slope=-23.0,MaxRelativeHeight=-9.0,LocationName="lower")
    RearArmor(1)=(Thickness=1.27,LocationName="upper/super") // rear upper hull & superstructure are same, so no point splitting

    FrontLeftAngle=335.0
    FrontRightAngle=25.0
    RearRightAngle=155.0
    RearLeftAngle=205.0

    // Movement
    GearRatios(4)=0.72
    TransRatio=0.1

    // Damage
    // pros: 7 men crew;
    // cons: 105mm ammorack is more likely to explode; petrol fuel
    Health=620
    HealthMax=620.0
    EngineHealth=300
    EngineToHullFireChance=0.1  //increased from 0.05 for all petrol engines
    DisintegrationHealth=-800.0 //petrol
    VehHitpoints(0)=(PointRadius=30.0,PointBone="hp_engine")
    VehHitpoints(1)=(PointRadius=15.0,PointBone="hp_ammo_l",DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    VehHitpoints(2)=(PointRadius=15.0,PointBone="hp_ammo_r",DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    TreadHitMaxHeight=-30.0
    DamagedEffectScale=0.9
    DamagedEffectOffset=(X=-85.0,Y=0.0,Z=40.0)
    FireAttachBone="Body"
    FireEffectOffset=(X=105.0,Y=-35.0,Z=50.0)
    DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc2.priest.priest_destro'

    // Exit
    ExitPositions(0)=(X=50.0,Y=-140.0,Z=58.0)
    ExitPositions(1)=(X=-50.0,Y=-140.0,Z=58.0)
    ExitPositions(2)=(X=0.0,Y=140.0,Z=58.0)
    ExitPositions(3)=(X=15.0,Y=-140.0,Z=58.0)
    ExitPositions(4)=(X=-52.0,Y=140.0,Z=58.0)
    ExitPositions(5)=(X=-120.0,Y=-140.0,Z=58.0)
    ExitPositions(6)=(X=-255.0,Y=0.0,Z=58.0)
    ExitPositions(7)=(X=-120.0,Y=140.0,Z=58.0)

    // Sounds
    IdleSound=SoundGroup'Vehicle_Engines.Kv1s.KV1s_engine_loop'
    StartUpSound=Sound'Vehicle_Engines.Kv1s.KV1s_engine_start'
    ShutDownSound=Sound'Vehicle_Engines.Kv1s.KV1s_engine_stop'
    LeftTreadSound=Sound'Vehicle_Engines.tracks.track_squeak_L03'
    RightTreadSound=Sound'Vehicle_Engines.tracks.track_squeak_R03'
    RumbleSound=Sound'DH_AlliedVehicleSounds.Sherman.inside_rumble01'
    RumbleSoundBone="DRIVER_CAMERA"
    PlayerCameraBone="DRIVER_CAMERA"

    // Visual effects
    LeftTreadIndex=1
    RightTreadIndex=2
    LeftTreadPanDirection=(Pitch=0,Yaw=0,Roll=0)
    RightTreadPanDirection=(Pitch=0,Yaw=0,Roll=0)
    TreadVelocityScale=110.0
    WheelRotationScale=42250.0
    ExhaustPipes(0)=(ExhaustPosition=(X=-140.30823,Y=37.3244,Z=60.6315),ExhaustRotation=(Pitch=0,Yaw=16384))
    LeftLeverBoneName=LEVER_L
    LeftLeverAxis=AXIS_Z
    RightLeverBoneName=LEVER_R
    RightLeverAxis=AXIS_Z

    // HUD
    VehicleHudImage=Texture'DH_Wespe_tex.interface.wespe_body_icon'
    VehicleHudTurret=TexRotator'DH_Wespe_tex.interface.wespe_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_Wespe_tex.interface.wespe_turret_look'
    VehicleHudTreadsPosX(0)=0.325
    VehicleHudTreadsPosX(1)=0.675
    VehicleHudTreadsPosY=0.5
    VehicleHudTreadsScale=0.725
    VehicleHudOccupantsX(0)=0.455
    VehicleHudOccupantsY(0)=0.3
    VehicleHudOccupantsX(1)=0.4
    VehicleHudOccupantsY(1)=0.7
    SpawnOverlay(0)=Material'DH_Wespe_tex.interface.wespe_profile_icon'
    VehicleHudEngineX=0.5
    VehicleHudEngineY=0.75

    // Visible wheels
    LeftWheelBones(0)="WHEEL_01_L"
    LeftWheelBones(1)="WHEEL_02_L"
    LeftWheelBones(2)="WHEEL_03_L"
    LeftWheelBones(3)="WHEEL_04_L"
    LeftWheelBones(4)="WHEEL_05_L"
    LeftWheelBones(5)="WHEEL_06_L"
    LeftWheelBones(6)="WHEEL_07_L"
    LeftWheelBones(7)="WHEEL_08_L"
    LeftWheelBones(8)="WHEEL_09_L"
    LeftWheelBones(9)="WHEEL_10_L"
    RightWheelBones(0)="WHEEL_01_R"
    RightWheelBones(1)="WHEEL_02_R"
    RightWheelBones(2)="WHEEL_03_R"
    RightWheelBones(3)="WHEEL_04_R"
    RightWheelBones(4)="WHEEL_05_R"
    RightWheelBones(5)="WHEEL_06_R"
    RightWheelBones(6)="WHEEL_07_R"
    RightWheelBones(7)="WHEEL_08_R"
    RightWheelBones(8)="WHEEL_09_R"
    RightWheelBones(9)="WHEEL_10_R"

    ShadowZOffset=40.0

    VehicleAttachments(0)=(AttachClass=class'DH_WespeIdentifierAttachment',AttachBone="BODY")

    // Physics wheels
    Begin Object Class=SVehicleWheel Name=STEER_WHEEL_F_L
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="STEER_WHEEL_F_L"
        BoneRollAxis=AXIS_Y
        WheelRadius=24.0
        bLeftTrack=true
    End Object
    Wheels(0)=STEER_WHEEL_F_L
    Begin Object Class=SVehicleWheel Name=STEER_WHEEL_F_R
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="STEER_WHEEL_F_R"
        BoneRollAxis=AXIS_Y
        WheelRadius=24.0
    End Object
    Wheels(1)=STEER_WHEEL_F_R
    Begin Object Class=SVehicleWheel Name=STEER_WHEEL_B_L
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="STEER_WHEEL_B_L"
        BoneRollAxis=AXIS_Y
        WheelRadius=24.0
        bLeftTrack=true
    End Object
    Wheels(2)=STEER_WHEEL_B_L
    Begin Object Class=SVehicleWheel Name=STEER_WHEEL_B_R
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="STEER_WHEEL_B_R"
        BoneRollAxis=AXIS_Y
        WheelRadius=24.0
    End Object
    Wheels(3)=STEER_WHEEL_B_R
    Begin Object Class=SVehicleWheel Name=DRIVE_WHEEL_L
        bPoweredWheel=true
        BoneName="DRIVE_WHEEL_L"
        BoneRollAxis=AXIS_Y
        WheelRadius=24.0
        bLeftTrack=true
    End Object
    Wheels(4)=DRIVE_WHEEL_L
    Begin Object Class=SVehicleWheel Name=DRIVE_WHEEL_R
        bPoweredWheel=true
        BoneName="DRIVE_WHEEL_R"
        BoneRollAxis=AXIS_Y
        WheelRadius=24.0
    End Object
    Wheels(5)=DRIVE_WHEEL_R

    // Karma
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.0
        KInertiaTensor(3)=3.0
        KInertiaTensor(5)=3.0
        KCOMOffset=(Z=-1.7) // default is -0.5
        KLinearDamping=0.05
        KAngularDamping=0.05
        KStartEnabled=true
        bKNonSphericalInertia=true
        KMaxAngularSpeed=0.9 // default is 1.0
        bHighDetailOnly=false
        bClientOnly=false
        bKDoubleTickRate=true
        bDestroyOnWorldPenetrate=true
        bDoSafetime=true
        KFriction=0.5
        KImpactThreshold=700.0
    End Object
    KParams=KParams0
}
