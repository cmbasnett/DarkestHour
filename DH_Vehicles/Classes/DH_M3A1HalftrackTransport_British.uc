//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_M3A1HalftrackTransport_British extends DH_M3A1HalftrackTransport;

#exec OBJ LOAD FILE=..\Textures\DH_VehiclesUK_tex.utx

defaultproperties
{
    DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc.M3A1Halftrack.Brit_M3A1Halftrack_dest'
    Skins(0)=texture'DH_VehiclesUK_tex.ext_vehicles.Brit_M3A1Halftrack_body_ext'
}
