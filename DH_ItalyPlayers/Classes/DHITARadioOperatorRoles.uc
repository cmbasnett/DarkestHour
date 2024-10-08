//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DHITARadioOperatorRoles extends DHAxisRadioOperatorRoles
    abstract;

defaultproperties
{
    AltName="Radiotelegrafista"

    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_CarcanoM91Weapon',AssociatedAttachment=class'DH_Weapons.DH_CarcanoM91AmmoPouch')
    Grenades(0)=(Item=class'DH_Weapons.DH_SRCMMod35GrenadeWeapon')  // TODO: replace with italian grenade

    VoiceType="DH_ItalyPlayers.DHItalyVoice"
    AltVoiceType="DH_ItalyPlayers.DHItalyVoice"
    BareHandTexture=Texture'DHItalianCharactersTex.Hands.Italian_hands'
    SleeveTexture=Texture'DHItalianCharactersTex.Sleeves.Livorno_sleeves'
    GlovedHandTexture=Texture'DHSovietCharactersTex.soviet_gear.hands_sovgloves' // TODO: replace

    Headgear(0)=class'DH_ItalyPlayers.DH_ItalianHelmet'
    Headgear(1)=class'DH_ItalyPlayers.DH_ItalianHelmet_Livorno'
    Headgear(2)=class'DH_ItalyPlayers.DH_ItalianHelmet_Adrian'
    Headgear(3)=class'DH_ItalyPlayers.DH_ItalianHelmet_AdrianTwo'

    HeadgearProbabilities(0)=0.4
    HeadgearProbabilities(1)=0.5
    HeadgearProbabilities(2)=0.05
    HeadgearProbabilities(3)=0.05

    GivenItems(0)="DH_Equipment.DH_ItalianRadioItem"
    
    Backpack(0)=(BackpackClass=class'DH_ItalyPlayers.DH_StazioneRF1Backpack')

    DetachedArmClass=class'DH_ItalyPlayers.DHSeveredArm_ItalianLivorno'
    DetachedLegClass=class'DH_ItalyPlayers.DHSeveredLeg_ItalianLivorno'
}
