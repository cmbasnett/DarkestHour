//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================
// This is a 105mm shell with the "base" charge, which has a significantly lower
// muzzle velocity than a fully charged round. This allows the Priest to be used
// to deliver rounds with a higher angle-of-incidence.
//==============================================================================

class DH_M7PriestCannonShellHE extends DH_ShermanM4A3105CannonShellHE;

simulated function Explode(vector HitLocation, vector HitNormal)
{
    local DHVolumeTest VT;
    local DHPlayer PC;
    local vector MapLocation;
    local DHGameReplicationInfo GRI;
    local DHMarker_ArtilleryHit_HE Marker;
    
    GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);
    
    // get info about the shooter
    PC =  DHPlayer(Instigator.Controller);
    
    GRI.GetMapCoords(Location, MapLocation.X, MapLocation.Y);
    // Marker = new class'DHArtilleryMarker_Hit_HE';
    // Marker.LocationX = MapLocation.X;
    // Marker.LocationY = MapLocation.Y;
    // Marker.ExpiryTime = GRI.ElapsedTime + Marker.LifetimeSeconds;
    // Marker.ClosestFireRequestIndex = 0; // FindClosestRequest(HitLocation, GRI.AlliesArtilleryRequests_HE);
    // Log("Marker.ClosestFireRequestIndex: " $ Marker.ClosestFireRequestIndex);
    //PC.ArtilleryHit_HE = Marker;

    super.Explode(HitLocation, HitNormal);
}

defaultproperties
{
    Speed=8962.5         // 198m/s x 75%
    MaxSpeed=8962.5
    LifeSpan=20.0
    SpeedFudgeScale=1.0
}

