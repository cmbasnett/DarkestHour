//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_SatchelCharge10lb10sProjectile extends DHThrowableExplosiveProjectile; // incorporating SatchelCharge10lb10sProjectile & ROSatchelChargeProjectile

var float           ConstructionDamageRadius;   // A radius that will damage Contructions
var float           ConstructionDamageMax;

var float           ObstacleDamageRadius;       // A radius that will damage Obstacles
var float           ObstacleDamageMax;

var float           EngineDamageMassThreshold;  // A mass threshold at which a vehicle will take min damage instead of setting the engine on fire
var float           EngineDamageRadius;         // A radius that will damage Vehicle Engines
var float           EngineDamageMax;

var float           TreadDamageMassThreshold;   // A mass threshold at which a vehicle will take min damage instead of destroying the tread outright
var float           TreadDamageRadius;          // A radius that will damage Vehicle Treads
var float           TreadDamageMax;

//var float           ComponentDamageStrength;    // If this is > the vehicle's mass, it will automatically affect the component instead of just doing damage
//var float           ComponentDamageMin;         // How much to damage component if vehicle's mass > ComponentDamageStrength

// Modified to record SavedInstigator & SavedPRI
// RODemolitionChargePlacedMsg from ROSatchelChargeProjectile is omitted
simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    if (Instigator != none)
    {
        SavedInstigator = Instigator;
        SavedPRI = Instigator.PlayerReplicationInfo;
    }
}

// Modified to check whether satchel blew up in a special Volume that needs to be triggered
simulated function BlowUp(vector HitLocation)
{
    local Actor         A;
    local vector        HitLoc, HitNorm;

    local DHVehicle     Veh;
    local DH_ObjSatchel SatchelObjActor;
    local Volume        V;
    local int           TrackNum;
    local float         Distance;
    local bool          bExplodedOnVehicle, bExplodedUnderVehicle;

    if (Instigator != none)
    {
        SavedInstigator = Instigator;
        SavedPRI = Instigator.PlayerReplicationInfo;
    }

    if (Role == ROLE_Authority)
    {
        if (bBounce)
        {
            // If the grenade hasn't landed, do 1/3 less damage
            // This isn't supposed to be realistic, its supposed to make airbursts less effective so players are more apt to throw grenades more authentically
            DelayedHurtRadius(Damage * 0.75, DamageRadius, MyDamageType, MomentumTransfer, HitLocation);
        }
        else
        {
            DelayedHurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation);
        }

        // Handle triggering DH_ObjSatchels
        foreach TouchingActors(class'Volume', V)
        {
            if (DH_ObjSatchel(V.AssociatedActor) != none)
            {
                SatchelObjActor = DH_ObjSatchel(V.AssociatedActor);

                if (SatchelObjActor.WithinArea(self))
                {
                    SatchelObjActor.Trigger(self, SavedInstigator);
                }
            }

            if (V.IsA('RODemolitionVolume'))
            {
                RODemolitionVolume(V).Trigger(self, SavedInstigator);
            }
        }

        // Find out if we are on a vehicle
        A = Trace(HitLoc, HitNorm, Location - vect(0.0, 0.0, 16.0), Location, true);
        bExplodedOnVehicle = DHVehicle(A) != none;

        if (!bExplodedOnVehicle)
        {
            A = Trace(HitLoc, HitNorm, Location + vect(0.0, 0.0, 16.0), Location, true);
            bExplodedUnderVehicle = DHVehicle(A) != none;
        }

        // Handle vehicle component damage
        foreach RadiusActors(class'DHVehicle', Veh, DamageRadius)
        {
            // Handle engine damage
            if (bExplodedOnVehicle && !Veh.IsVehicleBurning())
            {
                Distance = VSize(Location - Veh.GetEngineLocation());

                if (Distance < EngineDamageRadius)
                {
                    // If enough strength, set the engine on fire
                    if (EngineDamageMassThreshold > Veh.VehicleMass * Veh.SatchelResistance)
                    {
                        Veh.StartEngineFire(SavedInstigator);
                    }
                    else // Otherwise do minor damage to the engine
                    {
                        Veh.DamageEngine(EngineDamageMax * (Distance / EngineDamageRadius), SavedInstigator, vect(0,0,0), vect(0,0,0), MyDamageType);
                    }
                }
            }
            else if (bExplodedUnderVehicle)
            {
                Veh.TakeDamage(Damage * 4, SavedInstigator, vect(0,0,0), vect(0,0,0), MyDamageType);
            }

            // Set Distance to TreadDamageRadius, we don't want TreadDamageRadius to change, but want Distance to be changed in IsTreadInRadius()
            Distance = TreadDamageRadius;

            // Handle destroying the treads
            if (Veh.bHasTreads && Veh.IsTreadInRadius(Location, Distance, TrackNum))
            {
                // If enough strength we can detrack the vehicle instantly
                if (TreadDamageMassThreshold > Veh.VehicleMass * Veh.SatchelResistance)
                {
                    Veh.DestroyTrack(bool(TrackNum));
                }
                else // Otherwise do minor damge to the tracks
                {
                    Veh.DamageTrack(TreadDamageMax * (Distance / TreadDamageRadius), bool(TrackNum));
                }
            }
        }

        MakeNoise(1.0);
    }
}

// Implemented here to go to dynamic lighting for a split second, when satchel blows up // TODO: doesn't appear to do anything noticeable?
simulated function WeaponLight()
{
    if (!Level.bDropDetail)
    {
        bDynamicLight = true;
        SetTimer(0.15, false);
    }
}

simulated function Timer()
{
    bDynamicLight = false;
}

defaultproperties
{
    bAlwaysRelevant=true
    StaticMesh=StaticMesh'WeaponPickupSM.Projectile.Satchel_throw'
    CollisionRadius=4.0
    CollisionHeight=4.0

    Speed=300.0
    Damage=750.0
    DamageRadius=750.0

    ConstructionDamageRadius=256
    ConstructionDamageMax=300

    ObstacleDamageRadius=256
    ObstacleDamageMax=300

    EngineDamageMassThreshold=20.0
    EngineDamageRadius=200.0
    EngineDamageMax=150.0

    TreadDamageMassThreshold=20.0
    TreadDamageRadius=80.0
    TreadDamageMax=100.0

    MyDamageType=class'DH_Weapons.DH_SatchelDamType'

    ExplosionSoundRadius=4000.0
    ExplosionSound(0)=Sound'Inf_Weapons.satchel.satchel_explode01'
    ExplosionSound(1)=Sound'Inf_Weapons.satchel.satchel_explode02'
    ExplosionSound(2)=Sound'Inf_Weapons.satchel.satchel_explode03'
    ExplodeDirtEffectClass=class'ROEffects.ROSatchelExplosion'
    ExplodeSnowEffectClass=class'ROEffects.ROSatchelExplosion'
    ExplodeMidAirEffectClass=class'ROEffects.ROSatchelExplosion'

    BlurTime=6.0
    BlurEffectScalar=2.1
    ShakeRotMag=(X=0.0,Y=0.0,Z=300.0)
    ShakeRotRate=(Z=2500.0)
    ShakeRotTime=3.0
    ShakeOffsetMag=(Z=10.0)
    ShakeOffsetRate=(Z=200.0)
    ShakeOffsetTime=5.0
    ShakeScale=2.5
}
