//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_17PounderGunCannonPawn extends DH_ATGunTwoCannonPawn;

var() float ScopeCenterScaleX;
var() float ScopeCenterScaleY;

simulated function DrawHUD(Canvas Canvas)
{
    local PlayerController PC;
    local float SavedOpacity;
    local float scale;
    local float XL, YL, MapX, MapY;
    local color SavedColor, WhiteColor;

    local float ScreenRatio, OverlayCenterTexStart, OverlayCenterTexSize;

    PC = PlayerController(Controller);
    if (PC == none)
    {
        super.RenderOverlays(Canvas);
        //Log("PanzerTurret PlayerController was none, returning");
        return;
    }
    else if (!PC.bBehindView)
    {
        // store old opacity and set to 1.0 for map overlay rendering
        SavedOpacity = Canvas.ColorModulate.W;
        Canvas.ColorModulate.W = 1.0;

        Canvas.DrawColor.A = 255;
        Canvas.Style = ERenderStyle.STY_Alpha;

        scale = Canvas.SizeY / 1200.0;

        if (DriverPositions[DriverPositionIndex].bDrawOverlays && !IsInState('ViewTransition'))
        {
             if (DriverPositionIndex == 0)
             {

                // Draw reticle
                ScreenRatio = float(Canvas.SizeY) / float(Canvas.SizeX);
                OverlayCenterScale = 0.955 / OverlayCenterSize; // 0.955 factor widens visible FOV to full screen width = OverlaySize 1.0
                OverlayCenterTexStart = (1 - OverlayCenterScale) * float(CannonScopeOverlay.USize) / 2;
                OverlayCenterTexSize =  float(CannonScopeOverlay.USize) * OverlayCenterScale;
                Canvas.SetPos(0, 0);
                Canvas.DrawTile(CannonScopeOverlay , Canvas.SizeX , Canvas.SizeY, OverlayCenterTexStart - OverlayCorrectionX, OverlayCenterTexStart - OverlayCorrectionY + (1 - ScreenRatio) * OverlayCenterTexSize / 2 , OverlayCenterTexSize, OverlayCenterTexSize * ScreenRatio);

                if (Gun != none && Gun.ProjectileClass != none)
                    Canvas.SetPos(0, Gun.ProjectileClass.static.GetYAdjustForRange(Gun.GetRange()) * Canvas.ClipY);
                    //Canvas.SetPos(ScopePositionX * Canvas.ClipY / ScreenRatio / OverlayCenterScale - (Canvas.ClipX / OverlayCenterScale - Canvas.ClipX) / 2, (Gun.ProjectileClass.static.GetYAdjustForRange(Gun.GetRange()) * Canvas.ClipY / ScreenRatio / OverlayCenterScale) - Canvas.ClipY * (1/ScreenRatio/OverlayCenterScale - 1) / 2);
                else
                    Canvas.SetPos(ScopePositionX * Canvas.ClipY / ScreenRatio / OverlayCenterScale - (Canvas.ClipX / OverlayCenterScale - Canvas.ClipX) / 2, ScopePositionY  * Canvas.ClipY / ScreenRatio / OverlayCenterScale - Canvas.ClipY * (1/ScreenRatio/OverlayCenterScale-1)/2);

                Canvas.DrawTile(CannonScopeCenter , Canvas.SizeX , Canvas.SizeY, OverlayCenterTexStart - OverlayCorrectionX, OverlayCenterTexStart - OverlayCorrectionY + (1 - ScreenRatio) * OverlayCenterTexSize / 2 , OverlayCenterTexSize, OverlayCenterTexSize * ScreenRatio);
                    //Canvas.DrawTileScaled(CannonScopeCenter, scale * ScopeCenterScaleX / ScreenRatio / OverlayCenterScale, scale * ScopeCenterScaleY / ScreenRatio / OverlayCenterScale);

                // Draw the range setting
                if (Gun != none)
                {
                    Canvas.Style = ERenderStyle.STY_Normal;

                    SavedColor = Canvas.DrawColor;
                    WhiteColor =  class'Canvas'.Static.MakeColor(255,255,255, 175);
                    Canvas.DrawColor = WhiteColor;
                    MapX = RangePositionX * Canvas.ClipX;
                    MapY = RangePositionY * Canvas.ClipY;
                    Canvas.SetPos(MapX,MapY);
                    Canvas.Font = class'ROHUD'.Static.GetSmallMenuFont(Canvas);
                    Canvas.StrLen(Gun.GetRange() @ RangeText, XL, YL);
                    Canvas.DrawTextJustified(Gun.GetRange() @ RangeText, 2, MapX, MapY, MapX + XL, MapY+YL);
                    Canvas.DrawColor = SavedColor;
                }
            }
            else
            {
                    DrawBinocsOverlay(Canvas);
            }
            }

            // reset HudOpacity to original value
        Canvas.ColorModulate.W = SavedOpacity;

             // Draw tank, turret, ammo count, passenger list
            if (ROHud(PC.myHUD) != none && VehicleBase != none)
                    ROHud(PC.myHUD).DrawVehicleIcon(Canvas, VehicleBase, self);
    }

        // Zap the lame crosshair - Ramm
    if (IsLocallyControlled() && Gun != none && Gun.bCorrectAim && Gun.bShowAimCrosshair)
    {
        Canvas.DrawColor = CrosshairColor;
        Canvas.DrawColor.A = 255;
        Canvas.Style = ERenderStyle.STY_Alpha;
        Canvas.SetPos(Canvas.SizeX*0.5-CrosshairX, Canvas.SizeY*0.5-CrosshairY);
        Canvas.DrawTile(CrosshairTexture, CrosshairX*2.0, CrosshairY*2.0, 0.0, 0.0, CrosshairTexture.USize, CrosshairTexture.VSize);
    }

    if (PC != none && !PC.bBehindView && HUDOverlay != none)
    {
                if (!Level.IsSoftwareRendering())
                {
 //             CameraRotation = PC.Rotation;
  //            SpecialCalcFirstPersonView(PC, ViewActor, CameraLocation, CameraRotation);
  //            HUDOverlay.SetLocation(CameraLocation + (HUDOverlayOffset >> CameraRotation));
  //            HUDOverlay.SetRotation(CameraRotation);
  //            Canvas.DrawActor(HUDOverlay, false, false, FClamp(HUDOverlayFOV * (PC.DesiredFOV / PC.DefaultFOV), 1, 170));
                }
    }
    else
            ActivateOverlay(false);
}

defaultproperties
{
    ScopeCenterScaleX=0.542
    ScopeCenterScaleY=0.542
    OverlayCenterSize=0.542
    CannonScopeOverlay=texture'DH_VehicleOptics_tex.Artillery.17Pdr_sight_background'
    CannonScopeCenter=texture'DH_VehicleOptics_tex.Artillery.17pdr_sight_mover'
    BinocsOverlay=texture'DH_VehicleOptics_tex.Allied.BINOC_overlay_7x50Allied'
    RangeText="Yards"
    BinocPositionIndex=2
    WeaponFov=24.0
    AmmoShellTexture=texture'InterfaceArt_tex.Tank_Hud.T3485shell'
    AmmoShellReloadTexture=texture'InterfaceArt_tex.Tank_Hud.T3485shell_reload'
    DriverPositions(0)=(ViewLocation=(X=40.0,Y=-17.0,Z=22.0),ViewFOV=24.0,PositionMesh=SkeletalMesh'DH_17PounderGun_anm.17Pounder_turret',TransitionUpAnim="com_open",DriverTransitionAnim="crouch_idlehold_bayo",ViewPitchUpLimit=3004,ViewPitchDownLimit=64444,ViewPositiveYawLimit=5460,ViewNegativeYawLimit=-5460,bDrawOverlays=true,bExposed=true)
    DriverPositions(1)=(ViewFOV=90.0,PositionMesh=SkeletalMesh'DH_17PounderGun_anm.17Pounder_turret',TransitionDownAnim="com_close",DriverTransitionAnim="stand_idlehip_binoc",ViewPitchUpLimit=5000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bExposed=true)
    DriverPositions(2)=(ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_17PounderGun_anm.17Pounder_turret',DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=5000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bDrawOverlays=true,bExposed=true)
    GunClass=class'DH_Guns.DH_17PounderGunCannon'
    CameraBone="gun01"
    bFPNoZFromCameraPitch=true
    DrivePos=(X=-12.0,Y=-12.0,Z=-49.0)
    DriveAnim="crouch_idlehold_bayo"
    ExitPositions(0)=(X=-150.0,Y=0.0,Z=0.0)
    ExitPositions(1)=(X=-100.0,Y=0.0,Z=0.0)
    ExitPositions(2)=(X=-100.0,Y=20.0,Z=0.0)
    ExitPositions(3)=(X=-100.0,Y=-20.0,Z=0.0)
    ExitPositions(4)=(Y=50.0,Z=0.0)
    ExitPositions(5)=(Y=-50.0,Z=0.0)
    ExitPositions(6)=(X=-50.0,Y=-50.0,Z=0.0)
    ExitPositions(7)=(X=-50.0,Y=50.0,Z=0.0)
    ExitPositions(8)=(X=-75.0,Y=75.0,Z=0.0)
    ExitPositions(9)=(X=-75.0,Y=-75.0,Z=0.0)
    ExitPositions(10)=(X=-40.0,Y=0.0,Z=5.0)
    ExitPositions(11)=(X=-60.0,Y=0.0,Z=5.0)
    ExitPositions(12)=(X=-60.0,Z=10.0)
    ExitPositions(13)=(X=-60.0,Z=15.0)
    ExitPositions(14)=(X=-60.0,Z=20.0)
    ExitPositions(15)=(Z=5.0)
    EntryRadius=200.0
    bKeepDriverAuxCollision=true
    SoundVolume=130
}
