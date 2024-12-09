//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2024
//==============================================================================
// Client-side only "spoon" projectile for the US M1 Grenade. Spawned on the client
// when a real grenade projectile is created, inheriting the a portion of the velocity
// and direction of the real projectile.
//==============================================================================

class DH_M1GrenadeSpoonProjectile extends Projectile;

simulated event Landed(Vector HitNormal)
{
    super.Landed(HitNormal);

    SetPhysics(PHYS_None);
}

defaultproperties
{
    Physics=PHYS_Falling
    DrawType=DT_StaticMesh
    bFixedRotationDir=true
    StaticMesh=StaticMesh'DH_WeaponPickups.Ammo.M1GrenadeSpoon'
    RemoteRole=ROLE_None
    LifeSpan=10.0
    bBlockProjectiles=false
    bBlockZeroExtentTraces=false
    bCollideActors=false
    bCollideWorld=true
}