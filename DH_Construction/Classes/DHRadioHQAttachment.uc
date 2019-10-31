//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DHRadioHQAttachment extends Actor;

var byte           TeamIndex;
var StaticMesh     TeamStaticMeshes[2];

var DHRadio        Radio;
var class<DHRadio> RadioClass;
var vector         RadioOffset;

function Setup()
{
    if (Radio == none)
    {
        Radio = Spawn(RadioClass, self);
    }

    if (Radio != none)
    {
        Radio.TeamIndex = TeamIndex;
        Radio.SetBase(self);
        Radio.SetRelativeLocation(RadioOffset);
        Radio.bShouldShowOnSituationMap = false;

        SetStaticMesh(TeamStaticMeshes[TeamIndex]);
    }
    else
    {
        Warn("Failed to spawn a radio!");
    }
}

simulated function Destroyed()
{
    if (Radio != none)
    {
        Radio.Destroy();
    }
}

defaultproperties
{
    DrawType=DT_StaticMesh
    RemoteRole=ROLE_DumbProxy

    NetUpdateFrequency=10.0
    bAlwaysRelevant=true
    bOnlyDirtyReplication=true

    bUseCylinderCollision=false
    bCollideActors=true
    bCollideWorld=false
    bBlockActors=true
    bBlockKarma=true

    bBlockZeroExtentTraces=true
    bBlockNonZeroExtentTraces=true
    bBlockProjectiles=true
    bProjTarget=true
    bPathColliding=true
    bWorldGeometry=true

    TeamStaticMeshes(0)=StaticMesh'DH_Construction_stc.Artillery.GER_Artillery_Radio'
    TeamStaticMeshes(1)=StaticMesh'DH_Construction_stc.Artillery.USA_Artillery_Radio'

    RadioClass=Class'DH_Engine.DHRadio'
    RadioOffset=(Y=-10,Z=64)
}
