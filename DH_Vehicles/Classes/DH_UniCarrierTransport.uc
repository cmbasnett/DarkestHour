//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_UniCarrierTransport extends DH_ROTransportCraft;

#exec OBJ LOAD FILE=..\Animations\DH_allies_carrier_anm.ukx
#exec OBJ LOAD FILE=..\Textures\allies_vehicles_tex2.utx
#exec OBJ LOAD FILE=..\Textures\DH_VehiclesUK_tex.utx
#exec OBJ LOAD FILE=..\Sounds\Vehicle_EnginesTwo.uax

simulated function SetupTreads()
{
    LeftTreadPanner = VariableTexPanner(Level.ObjectPool.AllocateObject(class'VariableTexPanner'));
    if (LeftTreadPanner != none)
    {
        LeftTreadPanner.Material = Skins[1];
        LeftTreadPanner.PanDirection = rot(0, 0, 16384);
        LeftTreadPanner.PanRate = 0.0;
        Skins[1] = LeftTreadPanner;
    }
    RightTreadPanner = VariableTexPanner(Level.ObjectPool.AllocateObject(class'VariableTexPanner'));
    if (RightTreadPanner != none)
    {
        RightTreadPanner.Material = Skins[2];
        RightTreadPanner.PanDirection = rot(0, 0, 16384);
        RightTreadPanner.PanRate = 0.0;
        Skins[2] = RightTreadPanner;
    }
}

static function StaticPrecache(LevelInfo L)
{
    super.StaticPrecache(L);

    //L.AddPrecacheMaterial(Material'DH_VehiclesUK_tex.ext_vehicles.7thUniversalCarrier_body_ext');
    L.AddPrecacheMaterial(Material'allies_vehicles_tex.Treads.T60_treads');
    L.AddPrecacheMaterial(Material'allies_vehicles_tex2.int_vehicles.Universal_Carrier_Int');
    L.AddPrecacheMaterial(Material'allies_vehicles_tex2.int_vehicles.Universal_Carrier_Int_S');
}

simulated function UpdatePrecacheMaterials()
{
    //Level.AddPrecacheMaterial(Material'DH_VehiclesUK_tex.ext_vehicles.7thUniversalCarrier_body_ext');
    Level.AddPrecacheMaterial(Material'allies_vehicles_tex.Treads.T60_treads');
    Level.AddPrecacheMaterial(Material'allies_vehicles_tex2.int_vehicles.Universal_Carrier_Int');
    Level.AddPrecacheMaterial(Material'allies_vehicles_tex2.int_vehicles.Universal_Carrier_Int_S');

    super.UpdatePrecacheMaterials();
}

// Overridden to handle the special driver animations for this vehicle
simulated state ViewTransition
{
    simulated function HandleTransition()
    {
        if (Role == ROLE_AutonomousProxy || Level.NetMode == NM_Standalone || Level.NetMode == NM_ListenServer)
        {
            if (DriverPositions[DriverPositionIndex].PositionMesh != none && !bDontUsePositionMesh)
            {
                LinkMesh(DriverPositions[DriverPositionIndex].PositionMesh);
            }
        }

        if (PreviousPositionIndex < DriverPositionIndex && HasAnim(DriverPositions[PreviousPositionIndex].TransitionUpAnim))
        {
            PlayAnim(DriverPositions[PreviousPositionIndex].TransitionUpAnim);
        }
        else if (HasAnim(DriverPositions[PreviousPositionIndex].TransitionDownAnim))
        {
            PlayAnim(DriverPositions[PreviousPositionIndex].TransitionDownAnim);
        }

        if (Level.NetMode != NM_DedicatedServer && Driver != none)
        {
            if (DriverPositionIndex == InitialPositionIndex && PreviousPositionIndex < DriverPositionIndex)
            {
                Driver.PlayAnim(DriveAnim);
            }
            else if (Driver.HasAnim(DriverPositions[DriverPositionIndex].DriverTransitionAnim))
            {
                Driver.PlayAnim(DriverPositions[DriverPositionIndex].DriverTransitionAnim);
            }
        }
    }
}

defaultproperties
{
    MaxPitchSpeed=125.0
    TreadVelocityScale=80.0
    LeftTreadSound=sound'Vehicle_EnginesTwo.UC.UC_tread_L'
    RightTreadSound=sound'Vehicle_EnginesTwo.UC.UC_tread_R'
    RumbleSound=sound'Vehicle_Engines.interior.tank_inside_rumble03'
    LeftTrackSoundBone="Wheel_T_L_3"
    RightTrackSoundBone="Wheel_T_R_3"
    RumbleSoundBone="body"
    MaxCriticalSpeed=875.0
    LeftWheelBones(0)="Wheel_T_L_1"
    LeftWheelBones(1)="Wheel_T_L_2"
    LeftWheelBones(2)="Wheel_T_L_3"
    LeftWheelBones(3)="Wheel_T_L_4"
    LeftWheelBones(4)="Wheel_T_L_5"
    RightWheelBones(0)="Wheel_T_R_1"
    RightWheelBones(1)="Wheel_T_R_2"
    RightWheelBones(2)="Wheel_T_R_3"
    RightWheelBones(3)="Wheel_T_R_4"
    RightWheelBones(4)="Wheel_T_R_5"
    WheelRotationScale=1600
    WheelSoftness=0.025
    WheelPenScale=2.0
    WheelPenOffset=0.01
    WheelRestitution=0.1
    WheelInertia=0.1
    WheelLongFrictionFunc=(Points=(,(InVal=100.0,OutVal=1.0),(InVal=200.0,OutVal=0.9),(InVal=10000000000.0,OutVal=0.9)))
    WheelLongSlip=0.001
    WheelLatSlipFunc=(Points=(,(InVal=30.0,OutVal=0.009),(InVal=10000000000.0)))
    WheelLongFrictionScale=1.5
    WheelLatFrictionScale=3.0
    WheelHandbrakeSlip=0.01
    WheelHandbrakeFriction=0.1
    WheelSuspensionTravel=15.0
    FTScale=0.03
    ChassisTorqueScale=0.25
    MinBrakeFriction=4.0
    MaxSteerAngleCurve=(Points=((OutVal=35.0),(InVal=1500.0,OutVal=20.0),(InVal=1000000000.0,OutVal=15.0)))
    TorqueCurve=(Points=((OutVal=11.0),(InVal=200.0,OutVal=1.25),(InVal=1500.0,OutVal=2.5),(InVal=2200.0)))
    GearRatios(0)=-0.2
    GearRatios(1)=0.2
    GearRatios(2)=0.35
    GearRatios(3)=0.55
    GearRatios(4)=0.6
    TransRatio=0.12
    ChangeUpPoint=2000.0
    ChangeDownPoint=1000.0
    LSDFactor=1.0
    EngineBrakeFactor=0.0001
    EngineBrakeRPMScale=0.1
    MaxBrakeTorque=20.0
    SteerSpeed=160.0
    TurnDamping=50.0
    StopThreshold=100.0
    HandbrakeThresh=200.0
    EngineInertia=0.1
    IdleRPM=500.0
    EngineRPMSoundRange=5000.0
    SteerBoneName="Steering"
    RevMeterScale=4000.0
    ExhaustEffectClass=class'ROEffects.ExhaustPetrolEffect'
    ExhaustEffectLowClass=class'ROEffects.ExhaustPetrolEffect_simple'
    ExhaustPipes(0)=(ExhaustPosition=(X=-105.0,Y=33.0,Z=13.0),ExhaustRotation=(Pitch=36000))
    ExhaustPipes(1)=(ExhaustPosition=(X=-105.0,Y=-33.0,Z=13.0),ExhaustRotation=(Pitch=36000))
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_UniCarrierGunPawn',WeaponBone="mg_base")
    PassengerWeapons(1)=(WeaponPawnClass=class'DH_Vehicles.DH_UniCarrierPassengerOne',WeaponBone="passenger_l_1")
    PassengerWeapons(2)=(WeaponPawnClass=class'DH_Vehicles.DH_UniCarrierPassengerTwo',WeaponBone="passenger_l_2")
    PassengerWeapons(3)=(WeaponPawnClass=class'DH_Vehicles.DH_UniCarrierPassengerThree',WeaponBone="passenger_r_1")
    PassengerWeapons(4)=(WeaponPawnClass=class'DH_Vehicles.DH_UniCarrierPassengerFour',WeaponBone="passenger_r_2")
    IdleSound=SoundGroup'Vehicle_EnginesTwo.UC.UC_engine_loop'
    StartUpSound=sound'Vehicle_EnginesTwo.UC.UC_engine_start'
    ShutDownSound=sound'Vehicle_EnginesTwo.UC.UC_engine_stop'
    DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc.Carrier.Carrier_destroyed'
    DisintegrationHealth=-1000.0
    DestructionLinearMomentum=(Min=100.0,Max=350.0)
    DestructionAngularMomentum=(Max=150.0)
    DamagedEffectScale=0.75
    DamagedEffectOffset=(X=-40.0,Y=10.0,Z=10.0)
    VehicleTeam=1
    SteeringScaleFactor=4.0
    BeginningIdleAnim="driver_hatch_idle_close"
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_allies_carrier_anm.Carrier_body_int',TransitionUpAnim="Overlay_Out",ViewPitchUpLimit=1,ViewPitchDownLimit=65535,bExposed=true,ViewFOV=90.0,bDrawOverlays=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_allies_carrier_anm.Carrier_body_int',TransitionUpAnim="driver_hatch_open",TransitionDownAnim="Overlay_In",DriverTransitionAnim="VUC_driver_close",ViewPitchUpLimit=14000,ViewPitchDownLimit=58000,ViewPositiveYawLimit=27000,ViewNegativeYawLimit=-27000,bExposed=true,ViewFOV=90.0)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_allies_carrier_anm.Carrier_body_int',TransitionDownAnim="driver_hatch_close",DriverTransitionAnim="VUC_driver_open",ViewPitchUpLimit=14000,ViewPitchDownLimit=62500,ViewPositiveYawLimit=27000,ViewNegativeYawLimit=-27000,bExposed=true,ViewFOV=90.0)
    VehicleHudImage=texture'InterfaceArt2_tex.Tank_Hud.Carrier_body'
    VehicleHudOccupantsX(0)=0.58
    VehicleHudOccupantsX(1)=0.46
    VehicleHudOccupantsX(2)=0.39
    VehicleHudOccupantsX(3)=0.39
    VehicleHudOccupantsX(4)=0.62
    VehicleHudOccupantsX(5)=0.62
    VehicleHudOccupantsY(0)=0.35
    VehicleHudOccupantsY(1)=0.3
    VehicleHudOccupantsY(2)=0.5
    VehicleHudOccupantsY(3)=0.65
    VehicleHudOccupantsY(4)=0.5
    VehicleHudOccupantsY(5)=0.65
    VehicleHudEngineY=0.75
    VehHitpoints(0)=(PointOffset=(X=-9.0,Y=3.0,Z=35.0),bPenetrationPoint=false)
    VehHitpoints(1)=(PointRadius=20.0,PointBone="Engine",PointOffset=(X=-15.0),DamageMultiplier=1.0)
    VehHitpoints(2)=(PointRadius=20.0,PointScale=1.0,PointBone="Engine",PointOffset=(X=22.0),DamageMultiplier=1.0,HitPointType=HP_Engine)
    VehHitpoints(3)=(PointRadius=15.0,PointScale=1.0,PointBone="Engine",PointOffset=(Z=30.0),DamageMultiplier=1.0,HitPointType=HP_Engine)
    VehHitpoints(4)=(PointRadius=15.0,PointScale=1.0,PointBone="Engine",PointOffset=(X=27.0,Z=30.0),DamageMultiplier=1.0,HitPointType=HP_Engine)
    VehHitpoints(5)=(PointRadius=15.0,PointHeight=15.0,PointScale=1.0,PointBone="body",PointOffset=(X=-83.0,Z=30.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    EngineHealth=125
    DriverAttachmentBone="driver_player"
    Begin Object Class=SVehicleWheel Name=LF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="steer_wheel_LF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Z=10.0)
        WheelRadius=33.0
    End Object
    Wheels(0)=SVehicleWheel'DH_Vehicles.DH_UniCarrierTransport.LF_Steering'
    Begin Object Class=SVehicleWheel Name=RF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="steer_wheel_RF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Z=10.0)
        WheelRadius=33.0
    End Object
    Wheels(1)=SVehicleWheel'DH_Vehicles.DH_UniCarrierTransport.RF_Steering'
    Begin Object Class=SVehicleWheel Name=LR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_LR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Z=10.0)
        WheelRadius=33.0
    End Object
    Wheels(2)=SVehicleWheel'DH_Vehicles.DH_UniCarrierTransport.LR_Steering'
    Begin Object Class=SVehicleWheel Name=RR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_RR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Z=10.0)
        WheelRadius=33.0
    End Object
    Wheels(3)=SVehicleWheel'DH_Vehicles.DH_UniCarrierTransport.RR_Steering'
    Begin Object Class=SVehicleWheel Name=Left_Drive_Wheel
        bPoweredWheel=true
        BoneName="Wheel_T_L_3"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Z=10.0)
        WheelRadius=33.0
    End Object
    Wheels(4)=SVehicleWheel'DH_Vehicles.DH_UniCarrierTransport.Left_Drive_Wheel'
    Begin Object Class=SVehicleWheel Name=Right_Drive_Wheel
        bPoweredWheel=true
        BoneName="Wheel_T_R_3"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Z=10.0)
        WheelRadius=33.0
    End Object
    Wheels(5)=SVehicleWheel'DH_Vehicles.DH_UniCarrierTransport.Right_Drive_Wheel'
    VehicleMass=5.0
    bHasHandbrake=true
    DriveAnim="VUC_driver_idle_close"
    ExitPositions(0)=(X=48.0,Y=117.0,Z=15.0)
    ExitPositions(1)=(X=48.0,Y=-107.0,Z=15.0)
    ExitPositions(2)=(X=52.0,Y=-119.0,Z=13.0)
    ExitPositions(3)=(X=-45.0,Y=-118.0,Z=15.0)
    ExitPositions(4)=(X=7.0,Y=110.0,Z=15.0)
    ExitPositions(5)=(X=-48.0,Y=111.0,Z=15.0)
    EntryRadius=375.0
    TPCamDistance=200.0
    TPCamLookat=(X=0.0,Z=0.0)
    TPCamWorldOffset=(Z=50.0)
    DriverDamageMult=1.0
    VehicleNameString="Mk.I Bren Carrier"
    MaxDesireability=0.1
    HUDOverlayClass=class'ROVehicles.UniCarrierDriverOverlay'
    HUDOverlayOffset=(Y=-0.8,Z=1.99)
    HUDOverlayFOV=81.0
    PitchUpLimit=500
    PitchDownLimit=49000
    HealthMax=275.0
    Health=275
    Mesh=SkeletalMesh'DH_allies_carrier_anm.Carrier_body_ext'
    Skins(0)=texture'DH_VehiclesUK_tex.ext_vehicles.7thUniversalCarrier_body_ext'
    Skins(1)=texture'allies_vehicles_tex.Treads.T60_treads'
    Skins(2)=texture'allies_vehicles_tex.Treads.T60_treads'
    Skins(3)=texture'allies_vehicles_tex2.int_vehicles.Universal_Carrier_Int'
    CollisionRadius=175.0
    CollisionHeight=40.0
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.0
        KInertiaTensor(3)=3.0
        KInertiaTensor(5)=3.0
        KCOMOffset=(Z=-0.5)
        KLinearDamping=0.05
        KAngularDamping=0.05
        KStartEnabled=true
        bKNonSphericalInertia=true
        KMaxAngularSpeed=2.0
        bHighDetailOnly=false
        bClientOnly=false
        bKDoubleTickRate=true
        bDestroyOnWorldPenetrate=true
        bDoSafetime=true
        KFriction=0.5
        KImpactThreshold=700.0
    End Object
    KParams=KarmaParamsRBFull'DH_Vehicles.DH_UniCarrierTransport.KParams0'
    HighDetailOverlay=Shader'allies_vehicles_tex2.int_vehicles.Universal_Carrier_Int_S'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=3
}
