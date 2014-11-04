//=============================================================================
// DH_M1GarandMeleeFire
//=============================================================================

class DH_M1GarandMeleeFire extends DHMeleeFire;

defaultproperties
{
     DamageType=Class'DH_Weapons.DH_M1GarandBashDamType'
     BayonetDamageType=Class'DH_Weapons.DH_M1GarandBayonetDamType'
     TraceRange=75.000000
     BayonetTraceRange=125.000000
     BashBackAnim="bash_pullback"
     BashHoldAnim="bash_hold"
     BashAnim="bash_attack"
     BashFinishAnim="bash_return"
     BayoBackAnim="stab_pullback"
     BayoHoldAnim="stab_hold"
     BayoStabAnim="stab_attack"
     BayoFinishAnim="stab_return"
     BotRefireRate=0.250000
     aimerror=800.000000
}
