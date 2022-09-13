//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_LWP_GreatcoatSniper_Winter extends DHPOLSniperRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_SovietPlayers.DH_LWPGreatcoatBrownBagPawn_Winter',Weight=1.0)
    RolePawns(1)=(PawnClass=class'DH_SovietPlayers.DH_LWPGreatcoatGreyBagPawn_Winter',Weight=3.0)
    SleeveTexture=Texture'DHSovietCharactersTex.RussianSleeves.DH_LWPCoatSleeves'
    Headgear(0)=class'DH_SovietPlayers.DH_LWPcap'
    HandType=Hand_Gloved
}
