//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHROMAntiTankRoles extends DHAxisAntiTankRoles
    abstract;

defaultproperties
{
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_Vz24Weapon',AssociatedAttachment=class'ROInventory.ROKar98AmmoPouch')
    Grenades(0)=(Item=class'DH_Weapons.DH_M34GrenadeWeapon')
    Grenades(1)=(Item=class'DH_Equipment.DH_NebelGranate39Weapon') //?
    GivenItems(0)="DH_Weapons.DH_SatchelCharge10lb10sWeapon"
    HeadgearProbabilities(0)=0.2
    HeadgearProbabilities(1)=0.8
    GlovedHandTexture=Texture'Weapons1st_tex.Arms.hands_gergloves'
}
