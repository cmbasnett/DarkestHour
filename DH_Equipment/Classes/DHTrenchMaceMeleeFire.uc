//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHTrenchMaceMeleeFire extends DHMeleeFire;

var Sound TearDownSound;

function Sound GetGroundBashSound(Actor HitActor, Material HitMaterial)
{
    local DHConstruction C;

    C = DHConstruction(HitActor);

    if (C != none)
    {
        if (C.CanTakeTearDownDamageFromPawn(Instigator))
        {
            return TearDownSound;
        }
        else
        {
            return super.GetGroundBashSound(HitActor, HitMaterial);
        }
    }
    else
    {
        return super.GetGroundBashSound(HitActor, HitMaterial);
    }
}

defaultproperties
{
    DamageType=class'DH_Equipment.DHTrenchMaceBashDamageType'
    DamageMin=70
    DamageMax=150
    TraceRange=120.0
    FireRate=0.21
    BashBackAnim="bash_pullback"
    BashHoldAnim="bash_hold"
    BashAnim="bash_attack"
    BashFinishAnim="bash_return"
    TearDownSound=SoundGroup'DH_WeaponSounds.Shovel.shovel_hit'
    PlayerStabSound=SoundGroup'DH_WeaponSounds.Halloween.ZombieBash'
    PlayerBashSound=SoundGroup'DH_WeaponSounds.Halloween.ZombieBash'
}
