//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DHCommandMenu_FireSupport extends DHCommandMenu
    dependson(DHFireSupport);

// TODO: this should belong in the marker class, not here
var color DisabledColor;
var color EnabledColor;

var localized string UnavailableText;
var localized string InvalidTargetText;
var localized string AvailableText;

var struct SFireSupportState
{
    var DHFireSupport.EFireSupportError Error;
    var vector HitLocation;
} FireSupportState;

function OnSelect(int Index, vector Location)
{
    local DHPlayer PC;
    local DHPlayerReplicationInfo PRI;
    local DHGameReplicationInfo GRI;
    local vector MapLocation;

    PC = GetPlayerController();
    PRI = DHPlayerReplicationInfo(PC.PlayerReplicationInfo);
    GRI = DHGameReplicationInfo(PC.GameReplicationInfo);

    GRI.GetMapCoords(Location, MapLocation.X, MapLocation.Y);

    if (PC == none || Index < 0 || Index >= Options.Length)
    {
        return;
    }

    if (PC.IsArtilleryTargetValid(Location))
    {
        PC.AddFireSupportRequest(MapLocation, Location, class<DHMapMarker_FireSupport>(Options[Index].OptionalObject));
    }
    else
    {
        // "Not a Valid Artillery Target!"
        PC.ReceiveLocalizedMessage(class'ROArtilleryMsg', 5);
    }

    Interaction.Hide();
}

function OnPush()
{
    local DHPlayer PC;

    PC = GetPlayerController();

    if (PC == none)
    {
        return;
    }

    if (PC.SpottingMarker != none)
    {
        PC.SpottingMarker.Destroy();
    }

    PC.SpottingMarker = PC.Spawn(class'DHSpottingMarker', PC);
}

function OnPop()
{
    local DHPlayer PC;

    PC = GetPlayerController();

    if (PC != none && PC.SpottingMarker != none)
    {
        PC.SpottingMarker.Destroy();
    }
}

function class<DHMapMarker_FireSupport> GetSelectedMapMarkerClass()
{
    if (Interaction.SelectedIndex == -1)
    {
        return none;
    }

    return class<DHMapMarker_FireSupport>(Options[Interaction.SelectedIndex].OptionalObject);
}

function Tick()
{
    local DHPlayer                PC;
    local vector                  HitLocation, HitNormal;
    local Color                   C;
    local DHGameReplicationInfo   GRI;

    PC = GetPlayerController();

    if (PC == none || PC.SpottingMarker == none)
    {
        return;
    }

    GRI = DHGameReplicationInfo(PC.GameReplicationInfo);

    if (GRI == none)
    {
        return;
    }

    // Hide the interaction if the player somehow stops using the binoculars
    // (eg. proning, getting their weapon shot out of their hands etc.)
    if (PC.Pawn != none && PC.Pawn.Weapon != none && !PC.Pawn.Weapon.bUsingSights)
    {
        Interaction.Hide();
        return;
    }

    PC.GetEyeTraceLocation(HitLocation, HitNormal);

    FireSupportState.Error = PC.GetFireSupportErrorWithLocation(GetSelectedMapMarkerClass(), HitLocation);
    FireSupportState.HitLocation = HitLocation;

    if (FireSupportState.Error == FSE_None)
    {
        C = default.EnabledColor;
    }
    else
    {
        C = default.DisabledColor;
    }

    PC.SpottingMarker.SetColor(C);
    PC.SpottingMarker.SetLocation(HitLocation);
    PC.SpottingMarker.SetRotation(QuatToRotator(QuatFindBetween(HitNormal, vect(0, 0, 1))));
}

function GetOptionRenderInfo(int OptionIndex, out OptionRenderInfo ORI)
{
    local class<DHMapMarker_FireSupport>  FireSupportRequestClass;
    local DHSquadReplicationInfo          SRI;
    local DHPlayer                        PC;
    local int                             SquadMembersCount, AvailableCount;
    local DHGameReplicationInfo           GRI;

    FireSupportRequestClass = class<DHMapMarker_FireSupport>(Options[OptionIndex].OptionalObject);
    PC = GetPlayerController();
    GRI = DHGameReplicationInfo(PC.GameReplicationInfo);
    SRI = PC.SquadReplicationInfo;

    if (OptionIndex < 0 || OptionIndex >= Options.Length || SRI == none || PC == none || GRI == none || FireSupportRequestClass == none)
    {
        return;
    }

    ORI.OptionName = FireSupportRequestClass.default.MarkerName;

    switch (FireSupportState.Error)
    {
        case FSE_None:
            if (FireSupportRequestClass.default.ArtilleryRange == AR_OffMap)
            {
                ORI.InfoColor = class'UColor'.default.White;
                AvailableCount = GRI.ArtilleryTypeInfos[PC.GetTeamNum()].Limit - GRI.ArtilleryTypeInfos[PC.GetTeamNum()].UsedCount;
                ORI.InfoText = Repl(default.AvailableText, "{0}", AvailableCount);
            }
            else
            {
                ORI.InfoColor = class'UColor'.default.White;
                ORI.InfoText = Options[OptionIndex].SubjectText;
            }
            break;
        case FSE_NotEnoughSquadmates:
            SquadMembersCount = SRI.GetMemberCount(PC.GetTeamNum(), PC.GetSquadIndex());
            ORI.InfoColor = class'UColor'.default.Red;
            ORI.InfoIcon = Texture'DH_InterfaceArt2_tex.Icons.squad';
            ORI.InfoText = string(SquadMembersCount) @ "/" @ FireSupportRequestClass.default.RequiredSquadMembers;
            break;
        case FSE_InvalidLocation:
            ORI.InfoColor = class'UColor'.default.Red;
            ORI.InfoIcon = Texture'DH_GUI_tex.DeployMenu.spawn_point_disabled';
            ORI.InfoText = default.InvalidTargetText;
            break;
        case FSE_InsufficientPrivileges:
        case FSE_Disabled:
        case FSE_Fatal:
        default:
            ORI.InfoColor = class'UColor'.default.Red;
            ORI.InfoIcon = Texture'DH_GUI_tex.DeployMenu.spawn_point_disabled';
            ORI.InfoText = default.UnavailableText;
            break;
    }
}

function bool IsOptionDisabled(int OptionIndex)
{
    local class<DHMapMarker_FireSupport>  FireSupportRequestClass;
    local DHPlayer                        PC;

    if (OptionIndex < 0 || OptionIndex >= Options.Length || Options[OptionIndex].OptionalObject == none)
    {
        return true;
    }

    FireSupportRequestClass = class<DHMapMarker_FireSupport>(Options[OptionIndex].OptionalObject);
    PC = GetPlayerController();

    return PC == none || PC.GetFireSupportError(FireSupportRequestClass) != FSE_None;
}

defaultproperties
{
    Options(0)=(OptionalObject=class'DHMapMarker_FireSupport_ArtilleryBarrage',Material=Texture'DH_InterfaceArt2_tex.Icons.Artillery')
    Options(1)=(OptionalObject=class'DHMapMarker_FireSupport_Smoke',Material=Texture'DH_InterfaceArt2_tex.Icons.fire')
    Options(2)=(OptionalObject=class'DHMapMarker_FireSupport_HE',Material=Texture'DH_InterfaceArt2_tex.Icons.fire')

    UnavailableText="Unavailable"
    InvalidTargetText="Invalid target"
    AvailableText="{0} available"

    bShouldTick=true

    DisabledColor=(B=0,G=0,R=255,A=255)
    EnabledColor=(B=0,G=255,R=0,A=255)
}