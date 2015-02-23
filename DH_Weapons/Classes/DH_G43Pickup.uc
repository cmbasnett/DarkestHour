//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_G43Pickup extends DHWeaponPickup
   notplaceable;

static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.Weapons.g43');
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.pouches.g43pouch');
    L.AddPrecacheMaterial(Material'Weapons3rd_tex.German.g43_world');
    L.AddPrecacheMaterial(Material'Weapons1st_tex.Rifles.G43_S');
    L.AddPrecacheMaterial(Material'InterfaceArt_tex.HUD.G43_ammo');
}

defaultproperties
{
    InventoryType=class'DH_Weapons.DH_G43Weapon'
    StaticMesh=StaticMesh'WeaponPickupSM.Weapons.g43'
    PrePivot=(Z=3.0)
    CollisionRadius=25.0
    CollisionHeight=3.0
}
