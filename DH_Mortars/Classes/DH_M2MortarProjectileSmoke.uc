//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_M2MortarProjectileSmoke extends DH_MortarProjectileSmoke;

#exec OBJ LOAD FILE=..\StaticMeshes\DH_Mortars_stc.usx

defaultproperties
{
    BallisticCoefficient=1.0
    MaxSpeed=4800.0
    Tag="M302 WP"
}
