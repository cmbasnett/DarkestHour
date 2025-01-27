//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Zis3GunLateConstruction extends DHConstruction_Vehicle;

defaultproperties
{
    VehicleClasses(0)=(VehicleClass=class'DH_Guns.DH_Zis3GunLate')
    VehicleClasses(1)=(VehicleClass=class'DH_Guns.DH_Zis3GunLate_Snow',SeasonFilters=((Seasons=(SEASON_Winter))))
    SupplyCost=1130
    ProgressMax=14
}
