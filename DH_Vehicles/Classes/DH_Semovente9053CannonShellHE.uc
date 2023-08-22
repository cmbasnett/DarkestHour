//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================
// [1] https://en.wikipedia.org/wiki/Cannone_da_90/53
// [1]https://tanks-encyclopedia.com/semovente-m41m-da-90-53/
//==============================================================================

class DH_Semovente9053CannonShellHE extends DHCannonShellHE;

defaultproperties
{
    Speed=50092.0               // 830m/s [1]
    MaxSpeed=50092.0            
    ShellDiameter=9.0           // 90mm [1]
    BallisticCoefficient=2.5    // TODO: Find real value

    //Damage
    ImpactDamage=1000
    
    Damage=473.0   // 1000 gramms TNT, citation needed, references show exactly 1000 but that seems off
    DamageRadius=1530.0
    MyDamageType=class'DHShellHE88mmDamageType' // with 2mm off there really isnt much of a difference
    HullFireChance=0.8
    EngineFireChance=0.8

    ShellImpactDamage=class'DH_Engine.DHShellHEGunImpactDamageType'

    //Effects
    bHasTracer=false
    bHasShellTrail=false
    bDebugInImperial=false

    //Penetration
    DHPenetrationTable(0)=5.2
    DHPenetrationTable(1)=4.9
    DHPenetrationTable(2)=4.3
    DHPenetrationTable(3)=4.0
    DHPenetrationTable(4)=3.8
    DHPenetrationTable(5)=3.2
    DHPenetrationTable(6)=3.0
    DHPenetrationTable(7)=2.7
    DHPenetrationTable(8)=2.3
    DHPenetrationTable(9)=1.9
    DHPenetrationTable(10)=1.5
    
    bOpticalAiming=true
    OpticalRanges(0)=(Range=100,RangeValue=0.0)
    OpticalRanges(1)=(Range=200,RangeValue=0.477)
    OpticalRanges(2)=(Range=300,RangeValue=0.468)
    OpticalRanges(3)=(Range=400,RangeValue=0.458)
    OpticalRanges(4)=(Range=500,RangeValue=0.446)
    OpticalRanges(5)=(Range=600,RangeValue=0.433)
    OpticalRanges(6)=(Range=700,RangeValue=0.420)
    OpticalRanges(7)=(Range=800,RangeValue=0.407)
    OpticalRanges(8)=(Range=900,RangeValue=0.393)
    OpticalRanges(9)=(Range=1000,RangeValue=0.378)
    OpticalRanges(10)=(Range=1100,RangeValue=0.365)
    OpticalRanges(11)=(Range=1200,RangeValue=0.348)
    OpticalRanges(12)=(Range=1300,RangeValue=0.333)
    OpticalRanges(13)=(Range=1400,RangeValue=0.317)
    OpticalRanges(14)=(Range=1500,RangeValue=0.298)
    OpticalRanges(15)=(Range=1600,RangeValue=0.283)
    OpticalRanges(16)=(Range=1700,RangeValue=0.265)
    OpticalRanges(17)=(Range=1800,RangeValue=0.248)
    OpticalRanges(18)=(Range=1900,RangeValue=0.228)
    OpticalRanges(19)=(Range=2000,RangeValue=0.200)
}
