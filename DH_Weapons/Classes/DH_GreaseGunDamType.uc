//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_GreaseGunDamType extends DHSmallCaliberDamageType
    abstract;

defaultproperties
{
    WeaponClass=class'DH_Weapons.DH_GreaseGunWeapon'
    HUDIcon=Texture'InterfaceArt_tex.deathicons.b762mm'
    KDamageImpulse=1000.0
    KDeathVel=100.0
    KDeathUpKick=0.0
}
