//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================
// [1] https://en.wikipedia.org/wiki/Breda_38
//==============================================================================

class DH_Breda38Bullet extends DHBullet;

defaultproperties
{
    Speed=46471 // 770 m/s [1]
    BallisticCoefficient=0.515
    Damage=120.0
    MyDamageType=class'DH_Weapons.DH_Breda38DamType'
}