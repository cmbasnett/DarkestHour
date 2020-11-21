//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHMapMarker_FireSupport extends DHMapMarker
    abstract;

var string TypeName;
var float HitVisibilityRadius;      // the maximum distance a shell can land from the artillery request for the hit to be visible on the map

// Any squad leader can call artillery support.
static function bool CanPlaceMarker(DHPlayerReplicationInfo PRI)
{
    local DHPlayer PC;

    if (PRI == none)
    {
        return false;
    }

    PC = DHPlayer(PRI.Owner);

    return PC != none && PC.IsSL();
}

// An artillery support request can be removed only by the SL of the squad that called artillery request.
static function bool CanRemoveMarker(DHPlayerReplicationInfo PRI, DHGameReplicationInfo.MapMarker Marker)
{
    local DHPlayer PC;

    if (PRI == none)
    {
        return false;
    }

    PC = DHPlayer(PRI.Owner);

    return PC != none && PC.IsSL() && PRI.SquadIndex == Marker.SquadIndex;
}

// Only allow artillery roles and the SL who made the mark to see artillery requests.
static function bool CanSeeMarker(DHPlayerReplicationInfo PRI, DHGameReplicationInfo.MapMarker Marker)
{
    local DHPlayer PC;

    if (PRI == none)
    {
        return false;
    }

    PC = DHPlayer(PRI.Owner);

    return PC != none && (PC.IsArtilleryRole() || PC.IsSL() && PRI.SquadIndex == Marker.SquadIndex);
}

static function string GetCaptionString(DHPlayer PC, DHGameReplicationInfo.MapMarker Marker)
{
    local int Distance;
    local vector PlayerLocation, WorldLocation;

    if (PC == none || PC.Pawn == none)
    {
        return "";
    }

    WorldLocation = Marker.WorldLocation;
    WorldLocation.Z = 0.0;

    PlayerLocation = PC.Pawn.Location;
    PlayerLocation.Z = 0.0;

    Distance = int(class'DHUnits'.static.UnrealToMeters(VSize(WorldLocation - PlayerLocation)));

    return "" $ (Distance / 5) * 5 $ "m" ;
}

defaultproperties
{
    MarkerName="Fire Support"
    IconMaterial=Texture'DH_InterfaceArt2_tex.Icons.developer'
    IconColor=(R=204,G=,B=255,A=255)
    IconCoords=(X1=0,Y1=0,X2=31,Y2=31)
    GroupIndex=5
    bShouldShowOnCompass=false
    OverwritingRule=UNIQUE_PER_GROUP
    Scope=SQUAD
    LifetimeSeconds=-1            // artillery requests never expire
    HitVisibilityRadius=12070.4   // 200 meters
}