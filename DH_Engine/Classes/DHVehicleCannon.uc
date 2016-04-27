//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHVehicleCannon extends DHVehicleWeapon
    abstract;

#exec OBJ LOAD FILE=..\Sounds\DH_Vehicle_Reloads.uax

var     DHVehicleCannonPawn CannonPawn; // just a reference to the DH cannon pawn actor, for convenience & to avoid lots of casts

// Armor penetration
var     float               FrontArmorFactor, RightArmorFactor, LeftArmorFactor, RearArmorFactor;
var     float               FrontArmorSlope, RightArmorSlope, LeftArmorSlope, RearArmorSlope;
var     float               FrontLeftAngle, FrontRightAngle, RearRightAngle, RearLeftAngle;
var     float               GunMantletArmorFactor;  // used for mantlet hits for casemate-style vehicles without a turret
var     float               GunMantletSlope;
var     bool                bHasAddedSideArmor;     // has side skirts that will make a hit by a HEAT projectile ineffective

// Ammo (with variables for up to three cannon ammo types, including shot dispersion customized by round type)
var     byte                MainAmmoChargeExtra[3];  // current quantity of each round type (using byte for more efficient replication)
var     class<Projectile>   TertiaryProjectileClass; // new option for a 3rd type of cannon ammo
var     class<Projectile>   PendingProjectileClass;  // the round type we will switch to after firing currently loaded round
var localized array<string> ProjectileDescriptions;  // text for each round type to display on HUD
var     int                 InitialTertiaryAmmo;     // starting load of tertiary round type
var     float               SecondarySpread;         // spread for secondary ammo type
var     float               TertiarySpread;
var     byte                NumPrimaryMags;          // number of mags for an autocannon's primary ammo type // TODO: move autocannon functionality into a subclass
var     byte                NumSecondaryMags;
var     byte                NumTertiaryMags;

// Firing & reloading
var     array<int>          RangeSettings;           // for cannons with range adjustment
var     int                 AddedPitch;              // option for global adjustment to cannon's pitch aim
var     float               AltFireSpawnOffsetX;     // optional extra forward offset when spawning coaxial MG bullets, allowing them to clear potential collision with driver's head
var     sound               AltReloadSound;          // reload sound for cannon's coaxial MG
var     bool                bCanisterIsFiring;       // canister is spawning separate projectiles - until done it stops firing effects playing or switch to different round type

// Firing effects
var     sound               CannonFireSound[3];      // sound of the cannon firing (selected randomly)
var     name                ShootLoweredAnim;        // firing animation if player is in a lowered or closed animation position, i.e. buttoned up or crouching
var     name                ShootIntermediateAnim;   // firing animation if player is in an intermediate animation position, i.e. between lowered/closed & raised/open positions
var     name                ShootRaisedAnim;         // firing animation if player is in a raised or open animation position, i.e. unbuttoned or standing
var     class<Emitter>      CannonDustEmitterClass;  // emitter class for dust kicked up by the cannon firing
var     Emitter             CannonDustEmitter;

// Turret & movement
var     bool                bHasTurret;                // this cannon is in a fully rotating turret
var     float               ManualRotationsPerSecond;  // turret/cannon rotation speed when turned by hand
var     float               PoweredRotationsPerSecond; // faster rotation speed with powered assistance (engine must be running)

// Debugging & calibration
var     bool                bDrawPenetration;
var     bool                bPenetrationText;
var     bool                bLogPenetration;
var     config bool         bGunsightSettingMode;

replication
{
    // Variables the server will replicate to the client that owns this actor
    reliable if (bNetOwner && bNetDirty && Role == ROLE_Authority)
        MainAmmoChargeExtra, PendingProjectileClass, NumPrimaryMags, NumSecondaryMags, NumTertiaryMags;

    // Functions a client can call on the server
    reliable if (Role < ROLE_Authority)
        ServerManualReload;

    // Functions the server can call on the client that owns this actor
    reliable if (Role == ROLE_Authority)
        ClientAltReload;
}

///////////////////////////////////////////////////////////////////////////////////////
//  *********** ACTOR INITIALISATION & DESTRUCTION & KEY ENGINE EVENTS  ***********  //
///////////////////////////////////////////////////////////////////////////////////////

// Modified to fix minor bug where 1st key press to switch round type key didn't do anything
simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    if (Role == ROLE_Authority && bMultipleRoundTypes)
    {
        PendingProjectileClass = PrimaryProjectileClass;
    }
}

// Heavily modified (from ROTankCannon) to simplify & optimise, & to use an active pause/resume system instead of a constantly repeating timer until reload can start/resume
simulated function Timer()
{
    // If already reached final reload stage, always complete reload, regardless of circumstances
    if (ReloadState == ReloadStages.Length)
    {
        ReloadState = RL_ReadyToFire;
        bReloadPaused = false;
    }
    else if (ReloadState < ReloadStages.Length)
    {
        // For earlier reload stages, we only proceed if we have a player in a position where he can reload
        if (!bReloadPaused && CannonPawn != none && CannonPawn.Occupied())
        {
            // Play reloading sound for this stage (don't broadcast to owning client as it will play locally anyway)
            if (ReloadStages[ReloadState].Sound != none)
            {
                PlayOwnedSound(ReloadStages[ReloadState].Sound, SLOT_Misc, FireSoundVolume / 255.0,, 150.0,, false);
            }

            // Set next timer based on duration of current reload sound (use reload duration if specified, otherwise try & get the sound duration)
            if (ReloadStages[ReloadState].Duration > 0.0)
            {
                SetTimer(ReloadStages[ReloadState].Duration, false);
            }
            else
            {
                SetTimer(FMax(0.1, GetSoundDuration(ReloadStages[ReloadState].Sound)), false); // FMax is just a fail-safe in case GetSoundDuration somehow returns zero
            }

            // Move to next reload state
            ReloadState = EReloadState(ReloadState + 1);
        }
        // Otherwise pause the reload
        else
        {
            bReloadPaused = true;
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////
//  *********************************** FIRING ************************************  //
///////////////////////////////////////////////////////////////////////////////////////

state ProjectileFireMode
{
    // Modified to handle canister shot
    function Fire(Controller C)
    {
        local vector  WeaponFireVector;
        local int     ProjectilesToFire, i;

        // Special handling for canister shot
        if (class<DHCannonShellCanister>(ProjectileClass) != none)
        {
            bCanisterIsFiring = true;
            ProjectilesToFire = class<DHCannonShellCanister>(ProjectileClass).default.NumberOfProjectilesPerShot;
            WeaponFireVector = vector(WeaponFireRotation);

            for (i = 1; i <= ProjectilesToFire; ++i)
            {
                WeaponFireRotation = rotator(WeaponFireVector + (VRand() * (FRand() * TertiarySpread)));

                if (i >= ProjectilesToFire)
                {
                    bCanisterIsFiring = false;
                }

                SpawnProjectile(ProjectileClass, false);
            }
        }
        else
        {
            super.Fire(C);
        }
    }
}

// Modified (from ROTankCannon) to handle autocannons & canister shot, & to remove switching to pending ammo (now always handled in AttemptReload)
// Stripped down a little by removing all the unused/deprecated bDoOffsetTrace, bInheritVelocity, bCannonShellDebugging & some firing sound stuff
function Projectile SpawnProjectile(class<Projectile> ProjClass, bool bAltFire)
{
    local Projectile P;
    local rotator    FireRot;

    // Calculate projectile's direction & then spawn the projectile
    FireRot = WeaponFireRotation;

    if (CannonPawn != none && CannonPawn.IsHumanControlled())
    {
        FireRot.Pitch += AddedPitch; // used only for human players - lets cannons with non-centered aim points have a different aiming location
    }

    if (!bAltFire && RangeSettings.Length > 0)
    {
        FireRot.Pitch += ProjClass.static.GetPitchForRange(RangeSettings[CurrentRangeIndex]);
    }

    P = Spawn(ProjClass, none,, WeaponFireLocation, FireRot);

    // Play firing effects (unless it's canister shot still spawning separate projectiles, in which case we only play firing effects once, at the end)
    if (!bCanisterIsFiring && P != none)
    {
        FlashMuzzleFlash(bAltFire);

        if (bAltFire) // bAmbientAltFireSound is now assumed
        {
            AmbientSound = AltFireSoundClass;
            SoundVolume = AltFireSoundVolume;
            SoundRadius = AltFireSoundRadius;
            AmbientSoundScaling = AltFireSoundScaling;
        }
        else
        {
            PlayOwnedSound(GetFireSound(), SLOT_None, FireSoundVolume / 255.0,, FireSoundRadius,, false); // !bAmbientFireSound is now assumed
        }
    }

    return P;
}

// Modified (from ROTankCannon) to remove call to UpdateTracer (now we spawn either normal bullet OR tracer - see ProjectileFireMode), & also to expand & improve cannon firing anims
// Now check against RaisedPositionIndex instead of bExposed (allows lowered commander in open turret to be exposed), to play relevant firing animation
// Also adds new option for 'intermediate' position with its own firing animation, e.g. some AT guns have open sight position, between optics (lowered) & raised head position
// And we avoid playing shoot animations altogether on a server, as they serve no purpose there
simulated function FlashMuzzleFlash(bool bWasAltFire)
{
    if (Role == ROLE_Authority)
    {
        FiringMode = byte(bWasAltFire);
        ++FlashCount;
        NetUpdateTime = Level.TimeSeconds - 1.0; // force quick net update as changed value of FlashCount triggers this function for all non-owning net clients (native code)
    }
    else
    {
        CalcWeaponFire(bWasAltFire);
    }

    if (Level.NetMode != NM_DedicatedServer && !bWasAltFire)
    {
        if (FlashEmitter != none)
        {
            FlashEmitter.Trigger(self, Instigator);
        }

        if (EffectIsRelevant(Location, false))
        {
            if (EffectEmitterClass != none)
            {
                EffectEmitter = Spawn(EffectEmitterClass, self,, WeaponFireLocation, WeaponFireRotation);
            }

            if (CannonDustEmitterClass != none)
            {
                CannonDustEmitter = Spawn(CannonDustEmitterClass, self,, Base.Location, Base.Rotation);
            }
        }

        if (CannonPawn != none && CannonPawn.DriverPositionIndex >= CannonPawn.RaisedPositionIndex) // check against RaisedPositionIndex instead of whether position is bExposed
        {
            if (HasAnim(ShootRaisedAnim))
            {
                PlayAnim(ShootRaisedAnim);
            }
        }
        else if (CannonPawn != none && CannonPawn.DriverPositionIndex == CannonPawn.IntermediatePositionIndex)
        {
            if (HasAnim(ShootIntermediateAnim))
            {
                PlayAnim(ShootIntermediateAnim);
            }
        }
        else if (HasAnim(ShootLoweredAnim))
        {
            PlayAnim(ShootLoweredAnim);
        }
    }
}

// Modified to only spawn AmbientEffectEmitter if cannon has a coaxial MG (as we now specify a generic AmbientEffectEmitterClass, so no longer sufficient to check that)
simulated function InitEffects()
{
    if (Level.NetMode != NM_DedicatedServer && WeaponFireAttachmentBone != '') // WeaponFireAttachmentBone is now required
    {
        if (FlashEmitterClass != none && FlashEmitter == none)
        {
            FlashEmitter = Spawn(FlashEmitterClass);

            if (FlashEmitter != none)
            {
                FlashEmitter.SetDrawScale(DrawScale);
                AttachToBone(FlashEmitter, WeaponFireAttachmentBone);
                FlashEmitter.SetRelativeLocation(WeaponFireOffset * vect(1.0, 0.0, 0.0));
            }
        }

        if (AltFireProjectileClass != none && AmbientEffectEmitterClass != none && AmbientEffectEmitter == none)
        {
            AmbientEffectEmitter = Spawn(AmbientEffectEmitterClass, self,, WeaponFireLocation, WeaponFireRotation);

            if (AmbientEffectEmitter != none)
            {
                AttachToBone(AmbientEffectEmitter, WeaponFireAttachmentBone);
                AmbientEffectEmitter.SetRelativeLocation(AltFireOffset);
            }
        }
    }
}

// Modified to remove shake from coaxial MGs
simulated function ShakeView(bool bWasAltFire)
{
    if (!bWasAltFire)
    {
        super.ShakeView(false);
    }
}

// Modified to use random cannon fire sounds
simulated function sound GetFireSound()
{
    return CannonFireSound[Rand(3)];
}

///////////////////////////////////////////////////////////////////////////////////////
//  ******************************* RANGE SETTING  ********************************  //
///////////////////////////////////////////////////////////////////////////////////////

// Modified (from ROTankCannon) to network optimise by clientside check before replicating function call to server, & also playing click clientside, not replicating it back
// These functions now get called on both client & server, but only progress to server if it's a valid action (see modified LeanLeft & LeanRight execs in DHPlayer)
// Also adds debug option for easy tuning of gunsights in development mode
simulated function IncrementRange()
{
    // If bGunsightSettingMode is enabled & gun not loaded, then the range control buttons change sight adjustment up and down
    if (bGunsightSettingMode && ReloadState != RL_ReadyToFire && (Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode()))
    {
        if (Role == ROLE_Authority) // the server action from when this was a server only function
        {
            IncreaseAddedPitch();
            GiveInitialAmmo();
        }
        else if (Instigator != none && ROPlayer(Instigator.Controller) != none) // net client just calls the server function
        {
            ROPlayer(Instigator.Controller).ServerLeanRight(true);
        }
    }
    // Normal range adjustment - 1st make sure it's a valid action
    else if (CurrentRangeIndex < RangeSettings.Length - 1)
    {
        if (Role == ROLE_Authority) // the server action from when this was a server only function
        {
            CurrentRangeIndex++;
        }

        if (Instigator != none && ROPlayer(Instigator.Controller) != none)
        {
            if (Role < ROLE_Authority) // net client calls the server function
            {
                ROPlayer(Instigator.Controller).ServerLeanRight(true);
            }

            if (Instigator.IsLocallyControlled()) // play click sound only locally
            {
                ROPlayer(Instigator.Controller).ClientPlaySound(sound'ROMenuSounds.msfxMouseClick', false,, SLOT_Interface);
            }
        }
    }
}

simulated function DecrementRange()
{
    if (bGunsightSettingMode && ReloadState != RL_ReadyToFire && (Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode()))
    {
        if (Role == ROLE_Authority)
        {
            DecreaseAddedPitch();
            GiveInitialAmmo();
        }
        else if (Instigator != none && ROPlayer(Instigator.Controller) != none)
        {
            ROPlayer(Instigator.Controller).ServerLeanLeft(true);
        }
    }
    else if (CurrentRangeIndex > 0)
    {
        if (Role == ROLE_Authority)
        {
            CurrentRangeIndex--;
        }

        if (Instigator != none && ROPlayer(Instigator.Controller) != none)
        {
            if (Role < ROLE_Authority)
            {
                ROPlayer(Instigator.Controller).ServerLeanLeft(true);
            }

            if (Instigator.IsLocallyControlled())
            {
                ROPlayer(Instigator.Controller).ClientPlaySound(sound'ROMenuSounds.msfxMouseClick', false,, SLOT_Interface);
            }
        }
    }
}

// New debug functions to adjust AddedPitch (gunsight aim correction), with screen display
function IncreaseAddedPitch()
{
    local int MechanicalRangesValue, Correction;

    AddedPitch += 1;

    if (RangeSettings.Length > 0)
    {
        MechanicalRangesValue = ProjectileClass.static.GetPitchForRange(RangeSettings[CurrentRangeIndex]);
    }

    Correction = AddedPitch - default.AddedPitch;

    if (Instigator != none)
    {
        Instigator.ClientMessage("Sight old value =" @ MechanicalRangesValue @ "       new value =" @ MechanicalRangesValue + Correction @ "       correction =" @ Correction);
    }
}

function DecreaseAddedPitch()
{
    local int MechanicalRangesValue, Correction;

    AddedPitch -= 1;

    if (RangeSettings.Length > 0)
    {
        MechanicalRangesValue = ProjectileClass.static.GetPitchForRange(RangeSettings[CurrentRangeIndex]);
    }

    Correction = AddedPitch - default.AddedPitch;

    if (Instigator != none)
    {
        Instigator.ClientMessage("Sight old value =" @ MechanicalRangesValue @ "       new value =" @ MechanicalRangesValue + Correction @ "       correction =" @ Correction);
    }
}

// Modified to return zero if there are no RangeSettings, e.g. for American cannons without adjustable sights
simulated function int GetRange()
{
    if (CurrentRangeIndex < RangeSettings.Length)
    {
        return RangeSettings[CurrentRangeIndex];
    }

    return 0;
}

///////////////////////////////////////////////////////////////////////////////////////
//  ****************************** AMMO & RELOADING *******************************  //
///////////////////////////////////////////////////////////////////////////////////////

// Modified to use extended ammo types
function bool GiveInitialAmmo()
{
    if (MainAmmoChargeExtra[0] != InitialPrimaryAmmo || MainAmmoChargeExtra[1] != InitialSecondaryAmmo || MainAmmoChargeExtra[2] != InitialTertiaryAmmo
        || AltAmmoCharge != InitialAltAmmo || NumMGMags != default.NumMGMags
        || (bUsesMags && (NumPrimaryMags != default.NumPrimaryMags || NumSecondaryMags != default.NumSecondaryMags || NumTertiaryMags != default.NumTertiaryMags)))
    {
        MainAmmoChargeExtra[0] = InitialPrimaryAmmo;
        MainAmmoChargeExtra[1] = InitialSecondaryAmmo;
        MainAmmoChargeExtra[2] = InitialTertiaryAmmo;
        AltAmmoCharge = InitialAltAmmo;
        NumMGMags = default.NumMGMags;

        if (bUsesMags)
        {
            NumPrimaryMags = default.NumPrimaryMags;
            NumSecondaryMags = default.NumSecondaryMags;
            NumTertiaryMags = default.NumTertiaryMags;
        }

        return true;
    }

    return false;
}

// New function (in VehicleWeapon class) to use DH's new incremental resupply system (only resupplies rounds; doesn't reload the cannon)
function bool ResupplyAmmo()
{
    local bool bDidResupply;

    if (bUsesMags)
    {
        if (NumPrimaryMags < default.NumPrimaryMags)
        {
            ++NumPrimaryMags;
            bDidResupply = true;
        }

        if (NumSecondaryMags < default.NumSecondaryMags)
        {
            ++NumSecondaryMags;
            bDidResupply = true;
        }

        if (NumTertiaryMags < default.NumTertiaryMags)
        {
            ++NumTertiaryMags;
            bDidResupply = true;
        }
    }
    else
    {
        if (MainAmmoChargeExtra[0] < InitialPrimaryAmmo)
        {
            ++MainAmmoChargeExtra[0];
            bDidResupply = true;
        }

        if (MainAmmoChargeExtra[1] < InitialSecondaryAmmo)
        {
            ++MainAmmoChargeExtra[1];
            bDidResupply = true;
        }

        if (MainAmmoChargeExtra[2] < InitialTertiaryAmmo)
        {
            ++MainAmmoChargeExtra[2];
            bDidResupply = true;
        }
    }

    // If cannon is waiting to reload, but doesn't use manual reloading (so must be out of ammo), & we just resupplied & have a player, try to start a reload
    if (ReloadState == RL_Waiting && !PlayerUsesManualReloading() && bDidResupply && CannonPawn != none && CannonPawn.Occupied())
    {
        AttemptReload();
    }

    if (NumMGMags < default.NumMGMags)
    {
        ++NumMGMags;
        bDidResupply = true;

        // If coaxial MG is out of ammo, start an MG reload if we have a player
        // Note we don't need to consider cannon reload, as an empty cannon will already be on a repeating reload timer (or waiting for key press if player uses manual reloading)
        if (!HasAmmo(ALT_FIREMODE_INDEX) && CannonPawn != none && CannonPawn.Occupied())
        {
            AttemptAltReload();
        }
    }

    return bDidResupply;
}

// Modified to use extended ammo types
simulated function bool ConsumeAmmo(int FireMode)
{
    if (FireMode < 0 || FireMode > ALT_FIREMODE_INDEX || !HasAmmo(FireMode))
    {
        return false;
    }

    if (FireMode == ALT_FIREMODE_INDEX)
    {
         AltAmmoCharge--;
    }
    else
    {
        MainAmmoChargeExtra[FireMode]--;
    }

    return true;
}

// Modified to use extended ammo types
simulated function bool HasAmmo(int FireMode)
{
    if (FireMode == ALT_FIREMODE_INDEX)
    {
         return AltAmmoCharge > 0;
    }

    return FireMode >= 0 && FireMode < arraycount(MainAmmoChargeExtra) && MainAmmoChargeExtra[FireMode] > 0;
}

// New function to check whether we can start a reload for a specified ammo type, accommodating either normal cannon shells or mags
simulated function bool HasAmmoToReload(byte FireMode)
{
    if (bUsesMags) // autocannon
    {
        switch (FireMode)
        {
            case 0:
                return NumPrimaryMags > 0;
            case 1:
                return NumSecondaryMags > 0;
            case 2:
                return NumTertiaryMags > 0;
        }
    }

    return HasAmmo(FireMode); // normal cannon
}

// Modified to use extended ammo types
simulated function int PrimaryAmmoCount()
{
    local byte FireMode;

    FireMode = GetFireMode();

    if (FireMode < arraycount(MainAmmoChargeExtra))
    {
        if (bUsesMags)
        {
            switch (FireMode)
            {
                case 0:
                    return NumPrimaryMags;
                case 1:
                    return NumSecondaryMags;
                case 2:
                    return NumTertiaryMags;
            }
        }
        else
        {
            return MainAmmoChargeExtra[FireMode];
        }
    }

    return 0;
}

// Modified to use extended ammo types (if Super returns an error, we check against the additional tertiary ammo)
simulated function byte GetFireMode(optional bool bAltFire, optional class<Projectile> ProjClass)
{
    local byte FireMode;

    FireMode = super.GetFireMode(bAltFire, ProjClass);

    if (FireMode == 255 && (ProjectileClass == TertiaryProjectileClass || (ProjClass == TertiaryProjectileClass && ProjClass != none)))
    {
        FireMode = 2;
    }

    return FireMode;
}

// Modified (from ROTankCannon) to use extended ammo types
function ToggleRoundType(optional bool bForcedSwitch)
{
    if (PendingProjectileClass == PrimaryProjectileClass)
    {
        if (HasAmmoToReload(1))
        {
            PendingProjectileClass = SecondaryProjectileClass;
        }
        else if (HasAmmoToReload(2))
        {
            PendingProjectileClass = TertiaryProjectileClass;
        }
    }
    else if (PendingProjectileClass == SecondaryProjectileClass)
    {
        // bForcedSwitch option is passed if we have run out of ammo, meaning if it was secondary ammo then we try to switch back to primary instead of tertiary
        if ((bForcedSwitch || !HasAmmoToReload(2)) && HasAmmoToReload(0))
        {
            PendingProjectileClass = PrimaryProjectileClass;
        }
        else if (HasAmmoToReload(2))
        {
            PendingProjectileClass = TertiaryProjectileClass;
        }
    }
    else if (PendingProjectileClass == TertiaryProjectileClass)
    {
        if (HasAmmoToReload(0))
        {
            PendingProjectileClass = PrimaryProjectileClass;
        }
        else if (HasAmmoToReload(1))
        {
            PendingProjectileClass = SecondaryProjectileClass;
        }
    }
    else
    {
        if (HasAmmoToReload(0))
        {
            PendingProjectileClass = PrimaryProjectileClass;
        }
        else if (HasAmmoToReload(1))
        {
            PendingProjectileClass = SecondaryProjectileClass;
        }
        else if (HasAmmoToReload(2))
        {
            PendingProjectileClass = TertiaryProjectileClass;
        }
    }
}

// Modified to use extended ammo types
function float GetSpread(bool bAltFire)
{
    if (bAltFire)
    {
        return AltFireSpread;
    }
    else if (ProjectileClass == SecondaryProjectileClass)
    {
        if (SecondarySpread > 0.0)
        {
            return SecondarySpread;
        }
    }
    else if (ProjectileClass == TertiaryProjectileClass && TertiarySpread > 0.0)
    {
        return TertiarySpread;
    }

    return Spread;
}

// Modified so bots use the cannon against vehicle targets & the coaxial MG against infantry targets (from ROTankCannon)
function byte BestMode()
{
    if (Instigator != none && Instigator.Controller != none && Vehicle(Instigator.Controller.Target) != none)
    {
        return 0;
    }

    return 2;
}

// New client-to-server replicated function allowing player to trigger a manual cannon reload
// Far simpler than version that was in ROTankCannon, as AttemptReload() is a generic function that handles what this function used to do
function ServerManualReload()
{
    if (ReloadState == RL_Waiting && PlayerUsesManualReloading())
    {
        AttemptReload();
    }
}

// Modified to start a reload or resume a previously paused cannon reload
simulated function AttemptReload()
{
    local EReloadState OldReloadState;
    local bool         bNoAmmoToReload;

    // Need to start a new reload (authority role only)
    if (ReloadState >= RL_ReadyToFire)
    {
        if (Role == ROLE_Authority)
        {
            OldReloadState = ReloadState;

            // If we don't have any ammo of the pending type, try to switch to another ammo type (unless player reloads & switches manually)
            // The 'true' for ToggleRoundType signifies forced switch, not manual choice, making it try to switch to primary ammo, rather than strictly cycle ammo choice
            if (!HasAmmoToReload(GetFireMode(false, PendingProjectileClass)) && !PlayerUsesManualReloading())
            {
                ToggleRoundType(true);
            }

            // Switch to pending ammo type, if it's different
            if (ProjectileClass != PendingProjectileClass && PendingProjectileClass != none)
            {
                ProjectileClass = PendingProjectileClass;
            }

            // If we still don't have any ammo, we must be completely out of all cannon ammo, so wait for reload
            if (PrimaryAmmoCount() < 1)
            {
                bNoAmmoToReload = true;
            }
            // Otherwise, if starting an autocannon reload, we remove 1 spare mag & also 're-charge' the cannon
            // Charging it seems premature, but it's easier to do it here & cannon won't be able to fire anyway until reload completes
            else if (bUsesMags)
            {
                if (ProjectileClass == PrimaryProjectileClass)
                {
                    NumPrimaryMags--;
                    MainAmmoChargeExtra[0] = InitialPrimaryAmmo;
                }
                else if (ProjectileClass == SecondaryProjectileClass)
                {
                    NumSecondaryMags--;
                    MainAmmoChargeExtra[1] = InitialSecondaryAmmo;
                }
                else if (ProjectileClass == TertiaryProjectileClass)
                {
                    NumTertiaryMags--;
                    MainAmmoChargeExtra[2] = InitialTertiaryAmmo;
                }
            }
        }

        // If we have no ammo to start a reload, set loading state to waiting (for a resupply)
        if (bNoAmmoToReload)
        {
            ReloadState = RL_Waiting;
        }
        // Otherwise start a reload timer
        else
        {
            ReloadState = RL_Empty;
            bReloadPaused = false;
            SetTimer(0.01, false);
        }

        // If flagged replicate reload state to net client
        if (Role == ROLE_Authority && ReloadState != OldReloadState)
        {
            ClientSetReloadState(ReloadState);
        }
    }
    // Resume a paused reload (note owning net client gets this independently from server)
    else if (bReloadPaused)
    {
        bReloadPaused = false;
        SetTimer(0.01, false);
    }
}

// Implemented to start a reload for coaxial MG (based on original HandleReload function from ROTankCannon, but not broadcasting reload sound to owning client to save replication)
simulated function AttemptAltReload()
{
    if (Role == ROLE_Authority && NumMGMags > 0)
    {
        FireCountdown = GetSoundDuration(AltReloadSound);
        NumMGMags--;
        AltAmmoCharge = InitialAltAmmo;
        ClientAltReload();
        PlayOwnedSound(AltReloadSound, SLOT_None, 1.5,, 25.0, , true);
    }
}

// New function to set the fire countdown clientside (based on ClientDoReload from ROTankCannon, but playing reload sound locally to save replication)
simulated function ClientAltReload()
{
    if (Role < ROLE_Authority)
    {
        FireCountdown = GetSoundDuration(AltReloadSound);
        PlaySound(AltReloadSound, SLOT_None, 1.5,, 25.0, , true);

        // Necessary because using FireCountdown to stop fire during coax reload stops OwnerEffects() from being called, which would normally handle the cease fire
        if (WeaponPawn != none)
        {
            ClientOnlyVehicleCeaseFire(true);
        }
    }
}

// Implemented to handle cannon's manual reloading option
simulated function bool PlayerUsesManualReloading()
{
    return Instigator != none && ROPlayer(Instigator.Controller) != none && ROPlayer(Instigator.Controller).bManualTankShellReloading;
}

///////////////////////////////////////////////////////////////////////////////////////
//  ********************  HIT DETECTION, PENETRATION & DAMAGE  ********************  //
///////////////////////////////////////////////////////////////////////////////////////

// New generic function to handle penetration calcs for any shell type
simulated function bool ShouldPenetrate(DHAntiVehicleProjectile P, vector HitLocation, vector HitRotation, float PenetrationNumber)
{
    local float  WeaponRotationDegrees, HitAngleDegrees, Side, InAngle, InAngleDegrees;
    local vector LocDir, HitDir, X, Y, Z;

    if (!bHasTurret)
    {
        // Checking that PenetrationNumber > ArmorFactor 1st is a quick pre-check that it's worth doing more complex calculations in CheckPenetration()
        return PenetrationNumber > GunMantletArmorFactor && CheckPenetration(P, GunMantletArmorFactor, GunMantletSlope, PenetrationNumber);
    }

    // Figure out which side we hit
    LocDir = vector(Rotation);
    LocDir.Z = 0.0;
    HitDir = HitLocation - Location;
    HitDir.Z = 0.0;
    HitAngleDegrees = class'UUnits'.static.RadiansToDegrees(Acos(Normal(LocDir) dot Normal(HitDir)));
    GetAxes(Rotation, X, Y, Z);
    Side = Y dot HitDir;

    if (Side < 0.0)
    {
        HitAngleDegrees = 360.0 - HitAngleDegrees;
    }

    WeaponRotationDegrees = (CurrentAim.Yaw / 65536.0 * 360.0);
    HitAngleDegrees -= WeaponRotationDegrees;

    if (HitAngleDegrees < 0.0)
    {
        HitAngleDegrees += 360.0;
        X = X >> CurrentAim;
        Y = Y >> CurrentAim;
    }

    if (bPenetrationText && Role == ROLE_Authority)
    {
        Level.Game.Broadcast(self, "Turret hit angle =" @ HitAngleDegrees @ "degrees");
    }

    // Frontal hit
    if (HitAngleDegrees >= FrontLeftAngle || HitAngleDegrees < FrontRightAngle)
    {
        // Debugging
        if (bDrawPenetration)
        {
            ClearStayingDebugLines();
            DrawStayingDebugLine(HitLocation, HitLocation + 2000.0 * Normal(X), 0, 255, 0);
            DrawStayingDebugLine(HitLocation, HitLocation + 2000.0 * Normal(-HitRotation), 255, 255, 0);
            Spawn(class'DHDebugTracer', self,, HitLocation, rotator(HitRotation));
        }

        if (bLogPenetration)
        {
            Log("Front turret hit: HitAngleDegrees =" @ HitAngleDegrees @ " Side =" @ Side @ " Weapon WeaponRotationDegrees =" @ WeaponRotationDegrees);
        }

        // Calculate the direction the shot came from, so we can check for possible 'hit detection bug' (opposite side collision detection error)
        InAngle = Acos(Normal(-HitRotation) dot Normal(X));
        InAngleDegrees = class'UUnits'.static.RadiansToDegrees(InAngle);

        // InAngle over 90 degrees is impossible, so it's a hit detection bug & we need to switch to opposite side
        if (InAngleDegrees > 90.0)
        {
            if (bPenetrationText && Role == ROLE_Authority)
            {
                Level.Game.Broadcast(self, "Hit bug - switching from front to REAR turret hit: base armor =" @ RearArmorFactor * 10.0 $ "mm, slope =" @ RearArmorSlope);
            }

            // Checking that PenetrationNumber > ArmorFactor 1st is a quick pre-check that it's worth doing more complex calculations in CheckPenetration()
            return PenetrationNumber > RearArmorFactor && CheckPenetration(P, RearArmorFactor, GetCompoundAngle(InAngle, RearArmorSlope), PenetrationNumber);
        }

        if (bPenetrationText && Role == ROLE_Authority)
        {
            Level.Game.Broadcast(self, "Front turret hit: base armor =" @ FrontArmorFactor * 10.0 $ "mm, slope =" @ FrontArmorSlope);
        }

        return PenetrationNumber > FrontArmorFactor && CheckPenetration(P, FrontArmorFactor, GetCompoundAngle(InAngle, FrontArmorSlope), PenetrationNumber);

    }

    // Right side hit
    else if (HitAngleDegrees >= FrontRightAngle && HitAngleDegrees < RearRightAngle)
    {
        // Debugging
        if (bDrawPenetration)
        {
            ClearStayingDebugLines();
            DrawStayingDebugLine(HitLocation, HitLocation + 2000.0 * Normal(-Y), 0, 255, 0);
            DrawStayingDebugLine(HitLocation, HitLocation + 2000.0 * Normal(-HitRotation), 255, 255, 0);
            Spawn(class'DHDebugTracer', self,, HitLocation, rotator(HitRotation));
        }

        if (bLogPenetration)
        {
            Log("Right side turret hit: HitAngleDegrees =" @ HitAngleDegrees @ " Side =" @ Side @ " Weapon WeaponRotationDegrees =" @ WeaponRotationDegrees);
        }

        // Don't penetrate with HEAT if there is added side armor
        if (bHasAddedSideArmor && P.RoundType == RT_HEAT) // using RoundType instead of P.ShellImpactDamage.default.bArmorStops
        {
            return false;
        }

        InAngle = Acos(Normal(-HitRotation) dot Normal(Y));
        InAngleDegrees = class'UUnits'.static.RadiansToDegrees(InAngle);

        // Fix hit detection bug
        if (InAngleDegrees > 90.0)
        {
            if (bPenetrationText && Role == ROLE_Authority)
            {
                Level.Game.Broadcast(self, "Hit bug: switching from right to LEFT turret hit: base armor =" @ LeftArmorFactor * 10.0 $ "mm, slope =" @ LeftArmorSlope);
            }

            return PenetrationNumber > LeftArmorFactor && CheckPenetration(P, LeftArmorFactor, GetCompoundAngle(InAngle, LeftArmorSlope), PenetrationNumber);
        }

        if (bPenetrationText && Role == ROLE_Authority)
        {
            Level.Game.Broadcast(self, "Right turret hit: base armor =" @ RightArmorFactor * 10.0 $ "mm, slope =" @ RightArmorSlope);
        }

        return PenetrationNumber > RightArmorFactor && CheckPenetration(P, RightArmorFactor, GetCompoundAngle(InAngle, RightArmorSlope), PenetrationNumber);
    }

    // Rear hit
    else if (HitAngleDegrees >= RearRightAngle && HitAngleDegrees < RearLeftAngle)
    {
        // Debugging
        if (bDrawPenetration)
        {
            ClearStayingDebugLines();
            DrawStayingDebugLine(HitLocation, HitLocation + 2000.0 * Normal(-X), 0, 255, 0);
            DrawStayingDebugLine(HitLocation, HitLocation + 2000.0 * Normal(-HitRotation), 255, 255, 0);
            Spawn(class'DHDebugTracer', self,, HitLocation, rotator(HitRotation));
        }

        if (bLogPenetration)
        {
            Log("Rear turret hit: HitAngleDegrees =" @ HitAngleDegrees @ " Side =" @ Side @ " Weapon WeaponRotationDegrees =" @ WeaponRotationDegrees);
        }

        InAngle = Acos(Normal(-HitRotation) dot Normal(-X));
        InAngleDegrees = class'UUnits'.static.RadiansToDegrees(InAngle);

        // Fix hit detection bug
        if (InAngleDegrees > 90.0)
        {
            if (bPenetrationText && Role == ROLE_Authority)
            {
                Level.Game.Broadcast(self, "Hit bug - switching from rear to FRONT turret hit: base armor =" @ FrontArmorFactor * 10.0 $ "mm, slope =" @ FrontArmorSlope);
            }

            return PenetrationNumber > FrontArmorFactor && CheckPenetration(P, FrontArmorFactor, GetCompoundAngle(InAngle, FrontArmorSlope), PenetrationNumber);
        }

        if (bPenetrationText && Role == ROLE_Authority)
        {
            Level.Game.Broadcast(self, "Rear turret hit: base armor =" @ RearArmorFactor * 10.0 $ "mm, slope =" @ RearArmorSlope);
        }

        return PenetrationNumber > RearArmorFactor && CheckPenetration(P, RearArmorFactor, GetCompoundAngle(InAngle, RearArmorSlope), PenetrationNumber);
    }

    // Left side hit
    else if (HitAngleDegrees >= RearLeftAngle && HitAngleDegrees < FrontLeftAngle)
    {
        // Debugging
        if (bDrawPenetration)
        {
            ClearStayingDebugLines();
            DrawStayingDebugLine(HitLocation, HitLocation + 2000.0 * Normal(Y), 0, 255, 0);
            DrawStayingDebugLine(HitLocation, HitLocation + 2000.0 * Normal(-HitRotation), 255, 255, 0);
            Spawn(class'DHDebugTracer', self,, HitLocation, rotator(HitRotation));
        }

        if (bLogPenetration)
        {
            Log("Left side turret hit: HitAngleDegrees =" @ HitAngleDegrees @ " Side =" @ Side @ " Weapon WeaponRotationDegrees =" @ WeaponRotationDegrees);
        }

        // Don't penetrate with HEAT if there is added side armor
        if (bHasAddedSideArmor && P.RoundType == RT_HEAT) // using RoundType instead of P.ShellImpactDamage.default.bArmorStops
        {
            return false;
        }

        InAngle = Acos(Normal(-HitRotation) dot Normal(-Y));
        InAngleDegrees = class'UUnits'.static.RadiansToDegrees(InAngle);

        // Fix hit detection bug
        if (InAngleDegrees > 90.0)
        {
            if (bPenetrationText && Role == ROLE_Authority)
            {
                Level.Game.Broadcast(self, "Hit bug - switching from left to RIGHT turret hit: base armor =" @ RightArmorFactor * 10.0 $ "mm, slope =" @ RightArmorSlope);
            }

            return PenetrationNumber > RightArmorFactor && CheckPenetration(P, RightArmorFactor, GetCompoundAngle(InAngle, RightArmorSlope), PenetrationNumber);
        }

        if (bPenetrationText && Role == ROLE_Authority)
        {
            Level.Game.Broadcast(self, "Left turret hit: base armor =" @ LeftArmorFactor * 10.0 $ "mm, slope =" @ LeftArmorSlope);
        }

        return PenetrationNumber > LeftArmorFactor && CheckPenetration(P, LeftArmorFactor, GetCompoundAngle(InAngle, LeftArmorSlope), PenetrationNumber);
    }

    // Should never happen !
    else
    {
       Log ("?!? We shoulda hit something !!!!");
       Level.Game.Broadcast(self, "?!? We shoulda hit something !!!!");

       return false;
    }
}

// Matt: new generic function to handle penetration calcs for any shell type
// Replaces PenetrationAPC, PenetrationAPDS, PenetrationHVAP, PenetrationHVAPLarge & PenetrationHEAT (also Darkest Orchestra's PenetrationAP & PenetrationAPBC)
simulated function bool CheckPenetration(DHAntiVehicleProjectile P, float ArmorFactor, float CompoundAngle, float PenetrationNumber)
{
    local DHArmoredVehicle AV;
    local float CompoundAngleDegrees, OverMatchFactor, SlopeMultiplier, EffectiveArmor, PenetrationRatio;
    local bool  bProjectilePenetrated;

    // Convert angle back to degrees
    CompoundAngleDegrees = class'UUnits'.static.RadiansToDegrees(CompoundAngle);

    if (CompoundAngleDegrees > 90.0)
    {
        CompoundAngleDegrees = 180.0 - CompoundAngleDegrees;
    }

    // Calculate the SlopeMultiplier & EffectiveArmor, to give us the PenetrationRatio
    OverMatchFactor = ArmorFactor / P.ShellDiameter;
    SlopeMultiplier = GetArmorSlopeMultiplier(P, CompoundAngleDegrees, OverMatchFactor);
    EffectiveArmor = ArmorFactor * SlopeMultiplier;
    PenetrationRatio = PenetrationNumber / EffectiveArmor;

    // Penetration debugging
    if (bPenetrationText && Role == ROLE_Authority)
    {
        Level.Game.Broadcast(self, "Effective armor:" @ EffectiveArmor * 10.0 $ "mm" @ " Shot penetration:" @ PenetrationNumber * 10.0 $ "mm");
        Level.Game.Broadcast(self, "Compound angle:" @ CompoundAngleDegrees @ " Slope multiplier:" @ SlopeMultiplier);
    }

    // Check if round shattered on armor
    P.bRoundShattered = P.bShatterProne && PenetrationRatio >= 1.0 && CheckIfShatters(P, PenetrationRatio, OverMatchFactor);

    // Check if round penetrated the vehicle
    bProjectilePenetrated = PenetrationRatio >= 1.0 && !P.bRoundShattered;

    // Set TakeDamage-related variables on the vehicle itself
    AV = DHArmoredVehicle(Base);

    if (AV != none)
    {
        AV.bProjectilePenetrated = bProjectilePenetrated;
        AV.bTurretPenetration = bProjectilePenetrated;
        AV.bRearHullPenetration = false;
        AV.bHEATPenetration = P.RoundType == RT_HEAT && bProjectilePenetrated;
    }

    return bProjectilePenetrated;
}

// Returns the compound hit angle (now we pass AOI to this function in radians, to save unnecessary processing to & from degrees)
simulated function float GetCompoundAngle(float AOI, float ArmorSlopeDegrees)
{
    return Acos(Cos(class'UUnits'.static.DegreesToRadians(Abs(ArmorSlopeDegrees))) * Cos(AOI));
}

// New generic function to work with generic ShouldPenetrate & CheckPenetration functions
simulated function float GetArmorSlopeMultiplier(DHAntiVehicleProjectile P, float CompoundAngleDegrees, optional float OverMatchFactor)
{
    local float CompoundExp, RoundedDownAngleDegrees, ExtraAngleDegrees, BaseSlopeMultiplier, NextSlopeMultiplier, SlopeMultiplierGap;

    if (P.RoundType == RT_HVAP)
    {
        if (P.ShellDiameter > 8.5) // HVAP rounds bigger than 85mm shell diameter (instead of using separate RoundType RT_HVAPLarge)
        {
            if (CompoundAngleDegrees <= 30.0)
            {
               CompoundExp = CompoundAngleDegrees ** 1.75;

               return 2.71828 ** (CompoundExp * 0.000662);
            }
            else
            {
               CompoundExp = CompoundAngleDegrees ** 2.2;

               return 0.9043 * (2.71828 ** (CompoundExp * 0.0001987));
            }
        }
        else // smaller HVAP rounds
        {
            if (CompoundAngleDegrees <= 25.0)
            {
               CompoundExp = CompoundAngleDegrees ** 2.2;

               return 2.71828 ** (CompoundExp * 0.0001727);
            }
            else
            {
               CompoundExp = CompoundAngleDegrees ** 1.5;

               return 0.7277 * (2.71828 ** (CompoundExp * 0.003787));
            }
        }
    }
    else if (P.RoundType == RT_APDS)
    {
        CompoundExp = CompoundAngleDegrees ** 2.6;

        return 2.71828 ** (CompoundExp * 0.00003011);
    }
    else if (P.RoundType == RT_HEAT)
    {
        return 1.0 / Cos(class'UUnits'.static.DegreesToRadians(Abs(CompoundAngleDegrees)));
    }
    else // should mean RoundType is RT_APC, RT_HE or RT_Smoke, but treating this as a catch-all default (will also handle DO's AP & APBC shells)
    {
        if (CompoundAngleDegrees < 10.0)
        {
            return CompoundAngleDegrees / 10.0 * ArmorSlopeTable(P, 10.0, OverMatchFactor);
        }
        else
        {
            RoundedDownAngleDegrees = float(int(CompoundAngleDegrees / 5.0)) * 5.0; // to nearest 5 degrees, rounded down
            ExtraAngleDegrees = CompoundAngleDegrees - RoundedDownAngleDegrees;
            BaseSlopeMultiplier = ArmorSlopeTable(P, RoundedDownAngleDegrees, OverMatchFactor);
            NextSlopeMultiplier = ArmorSlopeTable(P, RoundedDownAngleDegrees + 5.0, OverMatchFactor);
            SlopeMultiplierGap = NextSlopeMultiplier - BaseSlopeMultiplier;

            return BaseSlopeMultiplier + (ExtraAngleDegrees / 5.0 * SlopeMultiplierGap);
        }
    }

    return 1.0; // fail-safe neutral return value
}

// New generic function to work with new GetArmorSlopeMultiplier for APC shells (also handles Darkest Orchestra's AP & APBC shells)
simulated function float ArmorSlopeTable(DHAntiVehicleProjectile P, float CompoundAngleDegrees, float OverMatchFactor)
{
    // after Bird & Livingston:
    if (P.RoundType == RT_AP) // from Darkest Orchestra
    {
        if      (CompoundAngleDegrees <= 10.0)  return 0.98  * (OverMatchFactor ** 0.06370); // at 10 degrees
        else if (CompoundAngleDegrees <= 15.0)  return 1.00  * (OverMatchFactor ** 0.09690);
        else if (CompoundAngleDegrees <= 20.0)  return 1.04  * (OverMatchFactor ** 0.13561);
        else if (CompoundAngleDegrees <= 25.0)  return 1.11  * (OverMatchFactor ** 0.16164);
        else if (CompoundAngleDegrees <= 30.0)  return 1.22  * (OverMatchFactor ** 0.19702);
        else if (CompoundAngleDegrees <= 35.0)  return 1.38  * (OverMatchFactor ** 0.22546);
        else if (CompoundAngleDegrees <= 40.0)  return 1.63  * (OverMatchFactor ** 0.26313);
        else if (CompoundAngleDegrees <= 45.0)  return 2.00  * (OverMatchFactor ** 0.34717);
        else if (CompoundAngleDegrees <= 50.0)  return 2.64  * (OverMatchFactor ** 0.57353);
        else if (CompoundAngleDegrees <= 55.0)  return 3.23  * (OverMatchFactor ** 0.69075);
        else if (CompoundAngleDegrees <= 60.0)  return 4.07  * (OverMatchFactor ** 0.81826);
        else if (CompoundAngleDegrees <= 65.0)  return 6.27  * (OverMatchFactor ** 0.91920);
        else if (CompoundAngleDegrees <= 70.0)  return 8.65  * (OverMatchFactor ** 1.00539);
        else if (CompoundAngleDegrees <= 75.0)  return 13.75 * (OverMatchFactor ** 1.07400);
        else if (CompoundAngleDegrees <= 80.0)  return 21.87 * (OverMatchFactor ** 1.17973);
        else                                    return 34.49 * (OverMatchFactor ** 1.28631); // at 85 degrees
    }
    else if (P.RoundType == RT_APBC) // from Darkest Orchestra
    {
        if      (CompoundAngleDegrees <= 10.0)  return 1.04  * (OverMatchFactor ** 0.01555); // at 10 degrees
        else if (CompoundAngleDegrees <= 15.0)  return 1.06  * (OverMatchFactor ** 0.02315);
        else if (CompoundAngleDegrees <= 20.0)  return 1.08  * (OverMatchFactor ** 0.03448);
        else if (CompoundAngleDegrees <= 25.0)  return 1.11  * (OverMatchFactor ** 0.05134);
        else if (CompoundAngleDegrees <= 30.0)  return 1.16  * (OverMatchFactor ** 0.07710);
        else if (CompoundAngleDegrees <= 35.0)  return 1.22  * (OverMatchFactor ** 0.11384);
        else if (CompoundAngleDegrees <= 40.0)  return 1.31  * (OverMatchFactor ** 0.16952);
        else if (CompoundAngleDegrees <= 45.0)  return 1.44  * (OverMatchFactor ** 0.24604);
        else if (CompoundAngleDegrees <= 50.0)  return 1.68  * (OverMatchFactor ** 0.37910);
        else if (CompoundAngleDegrees <= 55.0)  return 2.11  * (OverMatchFactor ** 0.56444);
        else if (CompoundAngleDegrees <= 60.0)  return 3.50  * (OverMatchFactor ** 1.07411);
        else if (CompoundAngleDegrees <= 65.0)  return 5.34  * (OverMatchFactor ** 1.46188);
        else if (CompoundAngleDegrees <= 70.0)  return 9.48  * (OverMatchFactor ** 1.81520);
        else if (CompoundAngleDegrees <= 75.0)  return 20.22 * (OverMatchFactor ** 2.19155);
        else if (CompoundAngleDegrees <= 80.0)  return 56.20 * (OverMatchFactor ** 2.56210);
        else                                    return 221.3 * (OverMatchFactor ** 2.93265); // at 85 degrees
    }
    else // should mean RoundType is RT_APC (also covers APCBC) or RT_HE, but treating this as a catch-all default
    {
        if      (CompoundAngleDegrees <= 10.0)  return 1.01  * (OverMatchFactor ** 0.0225); // at 10 degrees
        else if (CompoundAngleDegrees <= 15.0)  return 1.03  * (OverMatchFactor ** 0.0327);
        else if (CompoundAngleDegrees <= 20.0)  return 1.10  * (OverMatchFactor ** 0.0454);
        else if (CompoundAngleDegrees <= 25.0)  return 1.17  * (OverMatchFactor ** 0.0549);
        else if (CompoundAngleDegrees <= 30.0)  return 1.27  * (OverMatchFactor ** 0.0655);
        else if (CompoundAngleDegrees <= 35.0)  return 1.39  * (OverMatchFactor ** 0.0993);
        else if (CompoundAngleDegrees <= 40.0)  return 1.54  * (OverMatchFactor ** 0.1388);
        else if (CompoundAngleDegrees <= 45.0)  return 1.72  * (OverMatchFactor ** 0.1655);
        else if (CompoundAngleDegrees <= 50.0)  return 1.94  * (OverMatchFactor ** 0.2035);
        else if (CompoundAngleDegrees <= 55.0)  return 2.12  * (OverMatchFactor ** 0.2427);
        else if (CompoundAngleDegrees <= 60.0)  return 2.56  * (OverMatchFactor ** 0.2450);
        else if (CompoundAngleDegrees <= 65.0)  return 3.20  * (OverMatchFactor ** 0.3354);
        else if (CompoundAngleDegrees <= 70.0)  return 3.98  * (OverMatchFactor ** 0.3478);
        else if (CompoundAngleDegrees <= 75.0)  return 5.17  * (OverMatchFactor ** 0.3831);
        else if (CompoundAngleDegrees <= 80.0)  return 8.09  * (OverMatchFactor ** 0.4131);
        else                                    return 11.32 * (OverMatchFactor ** 0.4550); // at 85 degrees
    }

    return 1.0; // fail-safe neutral return value
}

// New generic function to work with new CheckPenetration function - checks if the round should shatter, based on the 'shatter gap' for different round types
simulated function bool CheckIfShatters(DHAntiVehicleProjectile P, float PenetrationRatio, optional float OverMatchFactor)
{
    if (P.RoundType == RT_HVAP)
    {
        if (P.ShellDiameter >= 9.0) // HVAP rounds of at least 90mm shell diameter, e.g. Jackson's 90mm cannon (instead of using separate RoundType RT_HVAPLarge)
        {
            if (PenetrationRatio >= 1.1 && PenetrationRatio <= 1.27)
            {
                return true;
            }
        }
        else // smaller HVAP rounds
        {
            if (PenetrationRatio >= 1.1 && PenetrationRatio <= 1.34)
            {
                return true;
            }
        }
    }
    else if (P.RoundType == RT_APDS)
    {
        if (PenetrationRatio >= 1.06 && PenetrationRatio <= 1.2)
        {
            return true;
        }
    }
    else if (P.RoundType == RT_HEAT) // no chance of shatter for HEAT round
    {
    }
    else // should mean RoundType is RT_APC, RT_HE or RT_Smoke, but treating this as a catch-all default (will also handle DO's AP & APBC shells)
    {
        if (OverMatchFactor > 0.8 && PenetrationRatio >= 1.06 && PenetrationRatio <= 1.19)
        {
            return true;
        }
    }

    return false;
}

// Modified as shell's ProcessTouch() now calls TakeDamage() on VehicleWeapon instead of directly on vehicle itself
// But for a cannon it's counted as a vehicle hit, so we call TD() on the vehicle (can also be subclassed for any custom handling of cannon hits)
function TakeDamage(int Damage, Pawn InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional int HitIndex)
{
    if (Base != none)
    {
        if (DamageType.default.bDelayedDamage && InstigatedBy != none)
        {
            Base.SetDelayedDamageInstigatorController(InstigatedBy.Controller);
        }

        Base.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType);
    }
}

///////////////////////////////////////////////////////////////////////////////////////
//  *************************  SETUP, UPDATE, CLEAN UP  ***************************  //
///////////////////////////////////////////////////////////////////////////////////////

// Modified to add TertiaryProjectileClass
simulated function UpdatePrecacheStaticMeshes()
{
    super.UpdatePrecacheStaticMeshes();

    if (TertiaryProjectileClass != none)
    {
        Level.AddPrecacheStaticMesh(TertiaryProjectileClass.default.StaticMesh);
    }
}

// Modified to set a convenient CannonPawn reference
simulated function InitializeWeaponPawn(ROVehicleWeaponPawn WeaponPwn)
{
    CannonPawn = DHVehicleCannonPawn(WeaponPwn);

    if (CannonPawn == none)
    {
        Warn("ERROR:" @ Tag @ "somehow spawned without an owning DHVehicleCannonPawn, so lots of things are not going to work!");
    }

    super.InitializeWeaponPawn(WeaponPwn);
}

// Modified to add option to skin cannon mesh using CannonSkins array in Vehicle class (avoiding need for separate cannon pawn & cannon classes just for camo variants)
// Also to give Vehicle a 'Cannon' reference to this actor
simulated function InitializeVehicleBase()
{
    local DHVehicle V;
    local int       i;

    V = DHVehicle(Base);

    if (V != none)
    {
        V.Cannon = self;

        if (Level.NetMode != NM_DedicatedServer)
        {
            for (i = 0; i < V.CannonSkins.Length; ++i)
            {
                if (V.CannonSkins[i] != none)
                {
                    Skins[i] = V.CannonSkins[i];
                }
            }
        }
    }

    super.InitializeVehicleBase();
}

// Modified to use optional AltFireSpawnOffsetX for coaxial MG fire, instead of irrelevant WeaponFireOffset for cannon
// Also removes redundant dual fire stuff
simulated function CalcWeaponFire(bool bWasAltFire)
{
    local coords WeaponBoneCoords;
    local vector CurrentFireOffset;

    // Calculate fire position offset
    if (bWasAltFire)
    {
        CurrentFireOffset = AltFireOffset + (AltFireSpawnOffsetX * vect(1.0, 0.0, 0.0));
    }
    else
    {
        CurrentFireOffset = WeaponFireOffset * vect(1.0, 0.0, 0.0);
    }

    // Calculate the rotation of the cannon's aim, & the location to spawn a projectile
    WeaponBoneCoords = GetBoneCoords(WeaponFireAttachmentBone);
    WeaponFireRotation = rotator(vector(CurrentAim) >> Rotation);
    WeaponFireLocation = WeaponBoneCoords.Origin + (CurrentFireOffset >> WeaponFireRotation);
}

// Modified to add CannonDustEmitter (from ROTankCannon)
simulated function DestroyEffects()
{
    super.DestroyEffects();

    if (CannonDustEmitter != none)
    {
        CannonDustEmitter.Destroy();
    }
}

defaultproperties
{
    // General
    bForceSkelUpdate=true // Matt: necessary for new player hit detection system, as makes server update cannon mesh skeleton (wouldn't otherwise as server doesn't draw mesh)
    bHasTurret=true
    FireAttachBone="com_player"

    // Collision
    bCollideActors=true
    bBlockActors=true
    bProjTarget=true
    bBlockNonZeroExtentTraces=true
    bBlockZeroExtentTraces=true

    // Turret/cannon movement & animation
    bUseTankTurretRotation=true
    YawBone="Turret"
    PitchBone="Gun"
    BeginningIdleAnim="com_idle_close"
    GunnerAttachmentBone="com_attachment"
    ShootLoweredAnim="shoot_close"
    ShootRaisedAnim="shoot_open"

    // Ammo
    bMultipleRoundTypes=true
    ProjectileDescriptions(0)="APCBC"
    ProjectileDescriptions(1)="HE"
    AltFireInterval=0.12 // just a fallback default
    AltFireSpread=0.002
    bUsesTracers=true
    bAltFireTracersOnly=true
    HudAltAmmoIcon=texture'InterfaceArt_tex.HUD.mg42_ammo'

    // Weapon fire
    ReloadState=RL_Waiting
    bPrimaryIgnoreFireCountdown=true
    WeaponFireAttachmentBone="Barrel"
    EffectEmitterClass=class'ROEffects.TankCannonFireEffect'
    CannonDustEmitterClass=class'ROEffects.TankCannonDust'
    FireForce="Explosion05"
    AmbientEffectEmitterClass=class'ROVehicles.TankMGEmitter'
    bAmbientEmitterAltFireOnly=true // assumed for a cannon & hard coded into functionality
    AIInfo(0)=(AimError=0.0,RefireRate=0.5)
    AIInfo(1)=(bLeadTarget=true,AimError=750.0,RefireRate=0.99,WarnTargetPct=0.9)

    // Sounds
    AltFireSoundScaling=3.0
    AltReloadSound=sound'Vehicle_reloads.Reloads.MG34_ReloadHidden'
    SoundVolume=130
    FireSoundVolume=512.0
    SoundRadius=200.0
    FireSoundRadius=4000.0
    bRotateSoundFromPawn=true
    RotateSoundThreshold=750.0

    // Screen shake
    ShakeRotMag=(X=0.0,Y=0.0,Z=50.0)
    ShakeRotRate=(X=0.0,Y=0.0,Z=1000.0)
    ShakeRotTime=4.0
    ShakeOffsetMag=(X=0.0,Y=0.0,Z=1.0)
    ShakeOffsetRate=(X=0.0,Y=0.0,Z=100.0)
    ShakeOffsetTime=10.0
    AltShakeRotMag=(X=1.0,Y=1.0,Z=1.0)
    AltShakeRotRate=(X=10000.0,Y=10000.0,Z=10000.0)
    AltShakeRotTime=2.0
    AltShakeOffsetMag=(X=0.01,Y=0.01,Z=0.01)
    AltShakeOffsetRate=(X=1000.0,Y=1000.0,Z=1000.0)
    AltShakeOffsetTime=2.0

    // These variables are effectively deprecated & should not be used - they are either ignored or values below are assumed & hard coded into functionality:
    bDoOffsetTrace=false
    bInheritVelocity=false
    bAmbientAltFireSound=true
}
