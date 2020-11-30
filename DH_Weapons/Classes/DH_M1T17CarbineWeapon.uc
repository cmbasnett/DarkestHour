//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2020
//==============================================================================

class DH_M1T17CarbineWeapon extends DHAutoWeapon;

defaultproperties
{
    ItemName="M1/T17 Carbine"
    SwayModifyFactor=0.55 // -0.35  because it was a very light carbine
    FireModeClass(0)=class'DH_Weapons.DH_M1T17CarbineFire'
    FireModeClass(1)=class'DH_Weapons.DH_M1T17CarbineMeleeFire'
    AttachmentClass=class'DH_Weapons.DH_M1T17CarbineAttachment'
    PickupClass=class'DH_Weapons.DH_M1T17CarbinePickup'

    Mesh=SkeletalMesh'DH_M1Carbine_1st.M1Carbine_mesh'
    Skins(2)=Texture'DH_Weapon_tex.AlliedSmallArms.M1Carbine'
    Skins(3)=Texture'DH_Weapon_tex.AlliedSmallArms.M1CarbineExtra'

    bUseHighDetailOverlayIndex=false

    IronSightDisplayFOV=45.0
    DisplayFOV=90.0
    FreeAimRotationSpeed=7.0

    MaxNumPrimaryMags=12
    InitialNumPrimaryMags=12

    PutDownAnim="put_away"
    MagEmptyReloadAnim="reload_empty"
    MagPartialReloadAnim="reload_half"

    MuzzleBone="MuzzleNew"

    bHasSelectFire=true
    SelectFireAnim="select_fire"
    SelectFireIronAnim="Iron_select_fire"
}

