//==============================================================================
// This file was automatically generated by the localization tool.
// Do not edit this file directly.
// To regenerate this file, run ./tools/localization/generate_fonts.bat
//==============================================================================

class DHButtonFontDS extends GUIFont;

event Font GetFont(int ResX)
{
    local int ResYGuess;
    ResYGuess = ResX * (9.0 / 16.0);

    return class'DHFonts'.static.GetDHButtonFontDSByResolution(ResYGuess);
}

defaultproperties
{
    KeyName="DHButtonFontDS"
}
