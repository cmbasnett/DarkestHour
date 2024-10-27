//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHDeployMenu extends UT2K4GUIPage;

enum ELoadoutMode
{
    LM_Equipment,
    LM_Vehicle
};

enum EMapMode
{
    MODE_Map,
    MODE_Squads
};

enum ESquadPlayersMode
{
    MODE_Headquarters,
    MODE_Unassigned,
    MODE_ActiveSquads,
};


var bool bIsEditingName;

var automated   FloatingImage               i_Background;
var automated   ROGUIProportionalContainer  c_Teams;
var automated   GUIButton                       b_Axis;
var automated   GUIImage                        i_Axis;
var automated   GUILabel                        l_Axis;
var automated   GUIButton                       b_Allies;
var automated   GUIImage                        i_Allies;
var automated   GUILabel                        l_Allies;
var automated   GUIButton                       b_Spectate;
var automated   GUIImage                        i_Spectate;
var automated   GUIImage                    i_Reinforcements;
var automated   GUILabel                    l_Reinforcements;
var automated   GUIImage                    i_SizeAdvantage;
var automated   GUILabel                    l_SizeAdvantage;
var automated   GUIImage                    i_RoundTime;
var automated   GUILabel                    l_RoundTime;
var automated   GUILabel                    l_HqInfoTeamName;
var automated   GUILabel                    l_HqInfoFireSupport;
var automated   ROGUIProportionalContainer  c_Roles;
var automated   DHGUIListBox                    lb_Roles;
var             DHGUIList                       li_Roles;
var automated   ROGUIProportionalContainer  LoadoutTabContainer;
var automated   GUIButton                       b_EquipmentButton;
var automated   GUIImage                        i_EquipmentButton;
var automated   GUIButton                       b_VehicleButton;
var automated   GUIImage                        i_VehiclesButton;
var automated   ROGUIProportionalContainer  MapSquadsTabContainer;
var automated   ROGUIProportionalContainer  MapUnassignedActiveSquadsTabContainer;
var automated   GUIButton                   b_MapButton;
var automated   GUIImage                    i_MapButton;
var automated   GUIButton                   b_SquadsButton;
var automated   GUIImage                    i_SquadsButton;
var automated   GUIButton                   b_SquadHeadquartersButton;
var automated   GUIImage                    i_SquadHeadquartersButton;
var automated   GUIButton                   b_SquadUnassignedButton;
var automated   GUIImage                    i_SquadUnassignedButton;
var automated   GUIButton                   b_SquadsActiveButton;
var automated   GUIImage                    i_SquadsActiveButton;
var automated   GUILabel                    l_Loadout;
var automated   ROGUIProportionalContainer  c_Loadout;
var automated   ROGUIProportionalContainer      c_Equipment;
var automated   ROGUIProportionalContainer      c_HeadQuarters;
var automated   ROGUIProportionalContainer      c_Vehicle;
var automated   ROGUIProportionalContainer  c_MapRoot;
var automated   DHGUIMapContainer               c_Map;
var automated   ROGUIProportionalContainer      c_Squads;
var automated   DHGUISquadsComponent                p_Squads;
var automated   ROGUIProportionalContainer  c_Footer;
var automated   GUILabel                    l_Status;
var automated   GUILabel                    l_SquadName;
var automated   DHGUIEditBox                eb_SquadName;
var automated   GUIImage                    i_SquadType;
var automated   GUIImage                        i_PrimaryWeapon;
var automated   GUIImage                        i_SecondaryWeapon;
var automated   GUIImage                        i_Vehicle;
var automated   GUIGFXButton                    i_SpawnVehicle;
var automated   GUIGFXButton                    i_ArtilleryVehicle;
var automated   GUIGFXButton                    i_SupplyVehicle;
var automated   GUIGFXButton                    i_MaxVehicles;
var automated   GUILabel                        l_MaxVehicles;
var automated   DHmoComboBox                cb_PrimaryWeapon;
var automated   DHmoComboBox                cb_SecondaryWeapon;
var automated   GUIImage                    i_GivenItems[5];
var automated   DHGUIListBox                lb_Vehicles;
var             DHGUIList                   li_Vehicles;
var automated   DHGUIListBox                lb_PrimaryWeapons;
var             DHGUIList                   li_PrimaryWeapons;
var automated   GUIImage                    i_Arrows;

var automated   array<GUIButton>            b_MenuOptions;

var DHGameReplicationInfo                   GRI;
var DHSquadReplicationInfo                  SRI;
var DHPlayerReplicationInfo                 PRI;
var DHPlayer                                PC;

var localized   string                      NoneText,
                                            SelectRoleText,
                                            SelectSpawnPointText,
                                            DeployInTimeText,
                                            DeployNowText,
                                            ReservedString,
                                            ChangeTeamConfirmText,
                                            FreeChangeTeamConfirmText,
                                            CantChangeTeamYetText,
                                            LockText,
                                            UnlockText,
                                            VehicleUnavailableString,
                                            LockedText,
                                            BotsText,
                                            SquadOnlyText,
                                            SquadLeadershipOnlyText,
                                            SquadAslOnlyText,
                                            RecommendJoiningSquadText,
                                            UnassignedPlayersCaptionText,
                                            HeadQuartersCaptionText,
                                            NonSquadLeaderOnlyText,
                                            RoleLockedText,
                                            RoleSquadOnlyInfantry,
                                            RoleSquadOnlyArmored,
                                            RoleSquadOnlyHeadquarters,
                                            RoleLogiOnlyOneClass
                                            ;

// NOTE: The reason this variable is needed is because the PlayerController's
// GetTeamNum function is not reliable after receiving a successful team change
// signal from InternalOnMessage.
var             byte                        CurrentTeam;

var             ELoadoutMode                LoadoutMode;

var             int                         SpawnPointIndex;
var             byte                        SpawnVehicleIndex;

var             bool                        bButtonsEnabled;

var             Material                    VehicleNoneMaterial;

var             EMapMode                    MapMode;
// var             ESquadPlayersMode           SquadPlayerMode;

var Texture LockIcon;
var Texture UnlockIcon;

var localized string        SurrenderConfirmBaseText;
var localized string        SurrenderConfirmNominationText;
var localized string        SurrenderConfirmEndRoundText;
var localized string        SurrenderButtonText[2];
var localized array<string> SurrenderResponseMessages;
var int                     SurrenderButtonUnlockTime;
var int                     SurrenderButtonCooldownSeconds;
var int                     PlayerSquadIndex;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    local int i;
    local class<DHNation> AxisNationClass, AlliedNationClass;

    super.InitComponent(MyController, MyOwner);

    PC = DHPlayer(PlayerOwner());

    li_Roles = DHGUIList(lb_Roles.List);
    li_Vehicles = DHGUIList(lb_Vehicles.List);

    // Footer buttons
    for (i = 0; i < b_MenuOptions.Length; ++i)
    {
        b_MenuOptions[i].WinLeft = i * (1.0 / b_MenuOptions.Length);
        b_MenuOptions[i].WinWidth = 1.0 / b_MenuOptions.Length;

        c_Footer.ManageComponent(b_MenuOptions[i]);
    }

    c_Footer.ManageComponent(i_Arrows);

    // Team buttons
    c_Teams.ManageComponent(b_Allies);
    c_Teams.ManageComponent(i_Allies);
    c_Teams.ManageComponent(l_Allies);
    c_Teams.ManageComponent(b_Axis);
    c_Teams.ManageComponent(i_Axis);
    c_Teams.ManageComponent(l_Axis);
    c_Teams.ManageComponent(b_Spectate);
    c_Teams.ManageComponent(i_Spectate);

    // Team flags
    if (PC != none && PC.ClientLevelInfo != none)
    {
        AxisNationClass = PC.ClientLevelInfo.GetTeamNationClass(AXIS_TEAM_INDEX);
        AlliedNationClass = PC.ClientLevelInfo.GetTeamNationClass(ALLIES_TEAM_INDEX);

        i_Axis.Image = AxisNationClass.default.DeployMenuFlagTexture;
        i_Allies.Image = AlliedNationClass.default.DeployMenuFlagTexture;
    }

    c_Loadout.ManageComponent(c_Equipment);
    c_Loadout.ManageComponent(c_Vehicle);

    LoadoutTabContainer.ManageComponent(b_EquipmentButton);
    LoadoutTabContainer.ManageComponent(b_VehicleButton);
    LoadoutTabContainer.ManageComponent(i_EquipmentButton);
    LoadoutTabContainer.ManageComponent(i_VehiclesButton);

    MapSquadsTabContainer.ManageComponent(i_SquadType);
    MapSquadsTabContainer.ManageComponent(l_SquadName);
    MapSquadsTabContainer.ManageComponent(eb_SquadName);
    MapSquadsTabContainer.ManageComponent(b_MapButton);
    MapSquadsTabContainer.ManageComponent(b_SquadsButton);
    MapSquadsTabContainer.ManageComponent(i_MapButton);
    MapSquadsTabContainer.ManageComponent(i_SquadsButton);

    MapUnassignedActiveSquadsTabContainer.ManageComponent(b_SquadsActiveButton);
    MapUnassignedActiveSquadsTabContainer.ManageComponent(b_SquadUnassignedButton);
    MapUnassignedActiveSquadsTabContainer.ManageComponent(b_SquadHeadquartersButton);
    MapUnassignedActiveSquadsTabContainer.ManageComponent(i_SquadsActiveButton);
    MapUnassignedActiveSquadsTabContainer.ManageComponent(i_SquadUnassignedButton);
    MapUnassignedActiveSquadsTabContainer.ManageComponent(i_SquadHeadquartersButton);

    c_HeadQuarters.ManageComponent(l_HqInfoTeamName);
    c_HeadQuarters.ManageComponent(l_HqInfoFireSupport);

    c_MapRoot.ManageComponent(c_Map);
    c_Squads.ManageComponent(p_Squads);

    c_Equipment.ManageComponent(i_PrimaryWeapon);
    c_Equipment.ManageComponent(i_SecondaryWeapon);

    for (i = 0; i < arraycount(i_GivenItems); ++i)
    {
        if (i_GivenItems[i] != none)
        {
            c_Equipment.ManageComponent(i_GivenItems[i]);
        }
    }

    c_Equipment.ManageComponent(cb_PrimaryWeapon);
    c_Equipment.ManageComponent(cb_SecondaryWeapon);

    c_Vehicle.ManageComponent(i_Vehicle);
    c_Vehicle.ManageComponent(i_SpawnVehicle);
    c_Vehicle.ManageComponent(i_ArtilleryVehicle);
    c_Vehicle.ManageComponent(i_SupplyVehicle);
    c_Vehicle.ManageComponent(lb_Vehicles);
    c_Vehicle.ManageComponent(i_MaxVehicles);
    c_Vehicle.ManageComponent(l_MaxVehicles);

    c_Roles.ManageComponent(lb_Roles);

    if (PC != none)
    {
        SetMapMode(EMapMode(PC.DeployMenuStartMode));
    }
    else
    {
        SetMapMode(MODE_Map);
    }
}

function SetLoadoutMode(ELoadoutMode Mode)
{
    local int i;
    local bool IsVehicleMode, IsEquipmentMode;

    isVehicleMode = MapMode == MODE_Map && Mode == LM_Vehicle;
    IsEquipmentMode = MapMode == MODE_Map && Mode == LM_Equipment;
    LoadoutMode = Mode;

    // GUIComponent visibility is not properly hierarchical, so we
    // need to hide and show elements individually.
    i_Vehicle.SetVisibility(isVehicleMode);
    lb_Vehicles.SetVisibility(isVehicleMode);

    i_PrimaryWeapon.SetVisibility(IsEquipmentMode);
    i_SecondaryWeapon.SetVisibility(IsEquipmentMode);

    cb_PrimaryWeapon.SetVisibility(IsEquipmentMode && cb_PrimaryWeapon.ItemCount() > 1);
    cb_SecondaryWeapon.SetVisibility(IsEquipmentMode && cb_SecondaryWeapon.ItemCount() > 1);

    for (i = 0; i < arraycount(i_GivenItems); ++i)
    {
        if (i_GivenItems[i] != none)
        {
            i_GivenItems[i].SetVisibility(IsEquipmentMode);
        }
    }

    if (isVehicleMode || IsEquipmentMode)
    {
        switch (Mode)
        {
            case LM_Equipment:
                b_EquipmentButton.DisableMe();
                b_VehicleButton.EnableMe();
                i_SpawnVehicle.SetVisibility(false);
                i_ArtilleryVehicle.SetVisibility(false);
                i_SupplyVehicle.SetVisibility(false);
                i_MaxVehicles.SetVisibility(false);
                l_MaxVehicles.SetVisibility(false);
                break;

            case LM_Vehicle:
                b_EquipmentButton.EnableMe();
                b_VehicleButton.DisableMe();
                i_VehiclesButton.Image = Material'DH_GUI_Tex.DeployMenu.vehicles';
                UpdateVehicleImage();
                break;
        }
    }
    else
    {
        i_SpawnVehicle.SetVisibility(false);
        i_ArtilleryVehicle.SetVisibility(false);
        i_SupplyVehicle.SetVisibility(false);
        i_MaxVehicles.SetVisibility(false);
        l_MaxVehicles.SetVisibility(false);
        b_EquipmentButton.DisableMe();
        b_VehicleButton.DisableMe();
    }

    UpdateSpawnPoints();
    UpdateButtons();
}

function Timer()
{
    // The GRI might not be set when we first open the menu if the player
    // opens it very quickly. This timer will sit and wait until the GRI is
    // confirmed to be present before populating any lists or running any
    // regular timer logic.
    local int TeamIndex;
    local int SquadIndex;

    if (GRI == none)
    {
        GRI = DHGameReplicationInfo(PC.GameReplicationInfo);

        if (GRI != none)
        {
            // This bullshit is used by RO code to circumvent the
            // fact we can't send initialization parameters to the menu.
            // SHOCKING: we actually can, but they never used it!
            if (PC.ForcedTeamSelectOnRoleSelectPage != -5)
            {
                TeamIndex = PC.ForcedTeamSelectOnRoleSelectPage;
                PC.ForcedTeamSelectOnRoleSelectPage = -5;
            }
            else
            {
                TeamIndex = PC.GetTeamNum();
            }

            OnTeamChanged(TeamIndex);

            // Automatically select the player's spawn point.
            c_Map.p_Map.SelectSpawnPoint(PC.SpawnPointIndex);
        }
    }

    if (SRI == none)
    {
        SRI = PC.SquadReplicationInfo;
    }

    if (PRI == none)
    {
        PRI = DHPlayerReplicationInfo(PC.PlayerReplicationInfo);
    }

    if (GRI != none)
    {
        UpdateVehicles(true);
        UpdateRoundStatus();
        UpdateStatus();
        UpdateButtons();
        UpdateSpawnPoints();
    }

    if (SRI != none)
    {
        SquadIndex = PC.GetSquadIndex();
        if (SquadIndex != PlayerSquadIndex)
        {
            PlayerSquadIndex = SquadIndex;
            PopulateRoles();

            //Only squad leaders should care about seeing the squad tab
            //While privates will be moved to the equipment tab
            if (SquadIndex > -1 && !PC.IsSquadLeader())
            {
                SetMapMode(MODE_Map);
            }
        }
        UpdateSquads();
        UpdateRoles();
    }
}

function UpdateRoundStatus()
{
    if (GRI != none)
    {
        if (GRI.AttritionRate[CurrentTeam] > 0.0)
        {
            l_Reinforcements.TextColor = class'UColor'.default.Red;
            i_Reinforcements.ImageColor = class'UColor'.default.Red;
        }
        else
        {
            l_Reinforcements.TextColor = class'UColor'.default.White;
            i_Reinforcements.ImageColor = class'UColor'.default.White;
        }

        if (GRI.bIsInSetupPhase)
        {
            l_Reinforcements.Caption = "???";
            l_Reinforcements.TextColor = class'UColor'.default.White;
            i_Reinforcements.ImageColor = class'UColor'.default.White;
        }
        else if (GRI.SpawnsRemaining[CurrentTeam] == -1)
        {
            l_Reinforcements.Caption = GRI.ReinforcementsInfiniteText;
        }
        else
        {
            l_Reinforcements.Caption = string(GRI.SpawnsRemaining[CurrentTeam]);
        }

        if (GRI.CurrentAlliedToAxisRatio != 0.5)
        {
            l_SizeAdvantage.Caption = GRI.GetTeamScaleString(CurrentTeam);
            l_SizeAdvantage.Show();
            i_SizeAdvantage.Show();
        }
        else
        {
            l_SizeAdvantage.Hide();
            i_SizeAdvantage.Hide();
        }

        if (GRI.DHRoundDuration == 0 && GRI.bMatchHasBegun)
        {
            l_RoundTime.Caption = class'DHHud'.default.NoTimeLimitText;
        }
        else
        {
            l_RoundTime.Caption = class'TimeSpan'.static.ToString(GRI.GetRoundTimeRemaining());
        }
    }
}

function int GetSelectedVehiclePoolIndex()
{
    local UInteger Index;

    Index = UInteger(li_Vehicles.GetObject());

    if (Index != none)
    {
        return Index.Value;
    }

    return -1;
}

function UpdateSpawnPoints()
{
    local int RoleIndex;
    local byte TeamIndex;

    if (GRI != none)
    {
        RoleIndex = GRI.GetRoleIndexAndTeam(DHRoleInfo(li_Roles.GetObject()), TeamIndex);
    }
    else
    {
        RoleIndex = -1;
    }

    c_Map.p_Map.UpdateSpawnPoints(TeamIndex, RoleIndex, GetSelectedVehiclePoolIndex(), SpawnPointIndex);
}

function UpdateStatus()
{
    local int TeamSizes[2];
    local bool bSurrenderButtonEnabled;

    if (GRI == none || PC == none)
    {
        return;
    }

    GRI.GetTeamSizes(TeamSizes);

    l_Axis.Caption = string(TeamSizes[AXIS_TEAM_INDEX]);
    l_Allies.Caption = string(TeamSizes[ALLIES_TEAM_INDEX]);

    l_Status.Caption = GetStatusText();

    // Suicide
    SetEnabled(b_MenuOptions[1], PC.Pawn != none);

    // Surrender
    bSurrenderButtonEnabled = GRI.bIsSurrenderVoteEnabled;

    if (bSurrenderButtonEnabled)
    {
        b_MenuOptions[2].Caption = SurrenderButtonText[int(PC.bSurrendered)];

        if (!PC.bSurrendered && GRI.ElapsedTime < SurrenderButtonUnlockTime)
        {
            bSurrenderButtonEnabled = false;
            b_MenuOptions[2].Caption @= "(" $ class'TimeSpan'.static.ToString(SurrenderButtonUnlockTime - GRI.ElapsedTime) $ ")";
        }

        bSurrenderButtonEnabled = bSurrenderButtonEnabled &&
                                  (class'DH_LevelInfo'.static.DHDebugMode() || !GRI.bIsInSetupPhase) &&
                                  !GRI.IsSurrenderVoteInProgress(PC.GetTeamNum()) &&
                                  GRI.RoundWinnerTeamIndex > 1;
    }

    SetEnabled(b_MenuOptions[2], bSurrenderButtonEnabled);
}

function string GetStatusText()
{
    local DHRoleInfo RI;
    local int        SpawnTime;

    RI = DHRoleInfo(li_Roles.GetObject());

    if (RI == none)
    {
        return default.SelectRoleText;
    }

    if (SpawnPointIndex == -1)
    {
        return default.SelectSpawnPointText;
    }

    SpawnTime = Max(0, PC.GetNextSpawnTime(SpawnPointIndex, RI, GetSelectedVehiclePoolIndex()) - GRI.ElapsedTime);

    if (SpawnTime > 0)
    {
        return Repl(default.DeployInTimeText, "{0}", class'DHLib'.static.GetDurationString(SpawnTime, "m:ss"));
    }
    else
    {
        return default.DeployNowText;
    }
}

function PopulateVehicles()
{
    local int i;

    li_Vehicles.Clear();

    for (i = 0; i < arraycount(GRI.VehiclePoolVehicleClasses); ++i)
    {
        if (GRI.VehiclePoolVehicleClasses[i] != none &&
            GRI.VehiclePoolVehicleClasses[i].default.VehicleTeam == CurrentTeam)
        {
            li_Vehicles.Add(GRI.VehiclePoolVehicleClasses[i].default.VehicleNameString, class'UInteger'.static.Create(i));
        }
    }

    li_Vehicles.SortList();
    li_Vehicles.Insert(0, default.NoneText, none,, true);

    UpdateVehicles();
    AutoSelectVehicle();
}

function UpdateVehicles(optional bool bShowAlert)
{
    local class<ROVehicle> VehicleClass;
    local DHRoleInfo       RI;
    local GUIQuestionPage  ConfirmWindow;
    local bool             bDisabled;
    local float            RespawnTime;
    local int              i, j;
    local string           S;
    local DHGameReplicationInfo.EVehicleReservationError VRE;

    if (GRI == none)
    {
        return;
    }

    RI = DHRoleInfo(li_Roles.GetObject());

    for (i = 0; i < li_Vehicles.ItemCount; ++i)
    {
        if (UInteger(li_Vehicles.GetObjectAtIndex(i)) == none)
        {
            continue;
        }

        j = UInteger(li_Vehicles.GetObjectAtIndex(i)).Value;
        VehicleClass = GRI.VehiclePoolVehicleClasses[j];
        PC = DHPlayer(PlayerOwner());
        VRE = GRI.GetVehicleReservationError(PC, RI, CurrentTeam, j);

        // NOTE: Allow our user to select the vehicle if there's a way for us to
        // display the reason for the error (e.g. team hit the max active limit)
        bDisabled = PC.VehiclePoolIndex != j && (VRE != ERROR_None && VRE != ERROR_TeamMaxActive);

        if (VehicleClass != none)
        {
            S = VehicleClass.default.VehicleNameString;

            if (GRI.GetVehiclePoolSpawnsRemaining(j) != 255)
            {
                S @= "[" $ GRI.GetVehiclePoolSpawnsRemaining(j) $ "]";
            }

            if (GRI.VehiclePoolMaxActives[j] != 255)
            {
                S @= "{" $ GRI.VehiclePoolActiveCounts[j] $ "/" $ GRI.VehiclePoolMaxActives[j] $ "}";
            }

            RespawnTime = GRI.VehiclePoolNextAvailableTimes[j] - GRI.ElapsedTime;
            RespawnTime = Max(RespawnTime, PC.NextVehicleSpawnTime - GRI.ElapsedTime);

            if (GRI.VehiclePoolReservationCount[j] > 0)
            {
                S @= "<" $ GRI.VehiclePoolReservationCount[j] @ default.ReservedString $ ">";
            }

            if (RespawnTime > 0)
            {
                S @= "(" $ class'DHLib'.static.GetDurationString(RespawnTime, "m:ss") $ ")";
            }

            li_Vehicles.SetItemAtIndex(i, S);
        }

        li_Vehicles.SetDisabledAtIndex(i, bDisabled);

        // If selected vehicle pool becomes disabled, select the "None" option
        // and display a warning to the user, if specified.
        if (bDisabled && li_Vehicles.Index == i)
        {
            if (bShowAlert)
            {
                ConfirmWindow = Controller.ShowQuestionDialog(default.VehicleUnavailableString, QBTN_OK, QBTN_OK);
                ConfirmWindow.OnButtonClick = none;
            }

            li_Vehicles.SetIndex(0);
        }
    }
    
    // Update the max vehicles number as well.
    l_MaxVehicles.Caption = string(Max(0, GRI.GetReservableTankCount(CurrentTeam)));

    if (GRI.GetReservableTankCount(CurrentTeam) <= 0)
    {
        l_MaxVehicles.TextColor = class'UColor'.default.Red;
    }
    else
    {
        l_MaxVehicles.TextColor = class'UColor'.default.White;
    }
}

function OnOKButtonClick(byte Button)
{
    Controller.CloseMenu(true);
}

function UpdateRoles()
{
    local DHRoleInfo RI;
    local int        Count, BotCount, Limit, i;
    local string     S;
    local DHPlayer.ERoleEnabledResult RoleEnabledResult;
    
    local array<DHPlayerReplicationInfo> Members;
    local DHGUISquadComponent            C;
    local int TeamIndex, SquadIndex;

    if (PC == none)
    {
        return;
    }

    TeamIndex = PC.GetTeamNum();

    if (TeamIndex == 255)
    {
        return;
    }

    SquadIndex = PC.GetSquadIndex();

    if (SquadIndex < 0 || SquadIndex >= p_Squads.SquadComponents.Length)
    {
        SquadIndex = p_Squads.SquadComponents.Length - 1;
    }
    
    // SRI = PC.SquadReplicationInfo;
    // SRI.GetMembers(PC.GetTeamNum(), i, Members);


    C = p_Squads.SquadComponents[SquadIndex];

    for (i = 0; i < li_Roles.ItemCount; ++i)
    {
        RI = DHRoleInfo(li_Roles.GetObjectAtIndex(i));

        if (RI == none)
        {
            continue;
        }
        RoleEnabledResult = PC.GetRoleEnabledResult(RI);

        switch (RoleEnabledResult)
        {
            case RER_SquadOnly:
                S = "" $ SquadOnlyText $ "*";
                break;
            case RER_SquadLeaderOnly:
                S = "SL: ";
                break;
            case RER_SquadAslOnly:
                S = "ASL: ";
                break;
            case RER_NonSquadLeaderOnly:
                S = "";
                break;
            case RER_Locked:
                S = "Locked: ";
                break;
            case RER_SquadTypeOnlyInfantry:
                S = "" $ RoleSquadOnlyInfantry $ ":";
                break;
            case RER_SquadTypeOnlyArmored:
                S = "" $ RoleSquadOnlyArmored $ ":";
                break;
            case RER_SquadTypeOnlyHeadquarters:
                S = "" $ RoleSquadOnlyHeadquarters $ ":";
                break;
            default:
                S = "";
                break;
        }

        if (PC != none && PC.bUseNativeRoleNames)
        {
            S = RI.AltName;
        }
        else
        {
            S = RI.MyName;
        }


        GRI.GetSquadRoleCounts(RI, SquadIndex, Count, BotCount);
        // Limit = PC.GetRoleLimit(RI);

        if (SRI != none)
        {
            Limit = SRI.GetRoleLimit(RI, TeamIndex, SquadIndex);
        }
        else
        {
            Limit = -1;
        }

        if (Limit == 0)
        {
            S @= "[" $ LockedText $ "]";
        }
        else if (Limit == -1 || Limit == 255 || (Count > 0 && Limit == 1))
        {
            S @= "[" $ Count $ "]";
        }
        else if (Limit > 1)
        {
            S @= "[" $ Count $ "/" $ Limit $ "]";
        }

        if (BotCount > 0)
        {
            S @= "*" $ BotsText $ "*";
        }
        // if (Members.Length > i && Members[i] != None)
        // {
        //     S @= " " @ Members[i].PlayerName;
        // }

        // switch (RoleEnabledResult)
        // {
        //     case RER_SquadOnly:
        //         S @= "*" $ SquadOnlyText $ "*";
        //         break;
        //     case RER_SquadLeaderOnly:
        //         S @= "*" $ SquadLeadershipOnlyText $ "*";
        //         break;
        //     case RER_SquadAslOnly:
        //         S @= "*" $ SquadAslOnlyText $ "*";
        //         break;
        //     case RER_NonSquadLeaderOnly:
        //         S @= "*" $ NonSquadLeaderOnlyText $ "*";
        //         break;
        //     case RER_Locked:
        //         S @= "*" $ RoleLockedText $ "*";
        //         break;
        //     case RER_SquadTypeOnlyInfantry:
        //         S @= "*" $ RoleSquadOnlyInfantry $ "*";
        //         break;
        //     case RER_SquadTypeOnlyArmored:
        //         S @= "*" $ RoleSquadOnlyArmored $ "*";
        //         break;
        //     case RER_SquadTypeOnlyLogistics:
        //             S @= "*" $ RoleSquadOnlyLogistics $ "*";
        //         break;
        // }
        li_Roles.SetItemAtIndex(i, S);
        li_Roles.SetDisabledAtIndex(i, RoleEnabledResult != RER_Enabled);
    }

    // If we end up having a newly disabled element selected, deselect it.
    if (li_Roles.IsIndexDisabled(li_Roles.Index))
    {
        li_Roles.SetIndex(-1);
    }
}

function bool OnClick(GUIComponent Sender)
{
    local GUIQuestionPage ConfirmWindow;
    local string          ConfirmMessage;

    PC = DHPlayer(PlayerOwner());

    switch (Sender)
    {
        // Disconnect
        case b_MenuOptions[0]:
            PC.ConsoleCommand("DISCONNECT");
            CloseMenu();
            break;

        // Suicide
        case b_MenuOptions[1]:
            PlayerOwner().ConsoleCommand("SUICIDE");
            break;

        // Surrender
        case b_MenuOptions[2]:
            if (PC != none)
            {
                PC.ServerTeamSurrenderRequest(true);
            }
            break;

        // Map vote
        case b_MenuOptions[3]:
            Controller.OpenMenu(Controller.MapVotingMenu);
            break;

        // Server browser
        case b_MenuOptions[4]:
            Controller.OpenMenu("DH_Interface.DHServerBrowser");
            break;

        // Settings
        case b_MenuOptions[5]:
            Controller.OpenMenu("DH_Interface.DHSettingsPage");
            break;

        // Continue button
        case b_MenuOptions[6]:
            if (PC != none &&
                !PC.bHasReceivedSquadJoinRecommendationMessage &&
                PC.SquadReplicationInfo != none &&
                PC.SquadReplicationInfo.bAreRallyPointsEnabled &&
                !PC.IsInSquad() &&
                PC.SquadReplicationInfo.IsAnySquadJoinable(PC.GetTeamNum()))
            {
                PC.bHasReceivedSquadJoinRecommendationMessage = true;
                ConfirmWindow = Controller.ShowQuestionDialog(default.RecommendJoiningSquadText, QBTN_YesNo, QBTN_Yes);
                ConfirmWindow.OnButtonClick = OnRecommendJoiningSquadButtonClick;
            }
            else
            {
                Apply();
            }
            break;

        // Weapons/equipment
        case b_EquipmentButton:
            SetLoadoutMode(LM_Equipment);
            break;

        // Vehicle
        case b_VehicleButton:
            SetLoadoutMode(LM_Vehicle);
            break;

        // Map
        case b_MapButton:
            SetMapMode(MODE_Map);
            break;

        // Squads
        case b_SquadsButton:
            SetMapMode(MODE_Squads);
            break;

        case b_SquadHeadquartersButton:
            SetSquadPlayersMode(Mode_Headquarters);
            break;

        case b_SquadUnassignedButton:
            SetSquadPlayersMode(Mode_Unassigned);
            break;

        case b_SquadsActiveButton:
            SetSquadPlayersMode(MODE_ActiveSquads);
            break;


        // Changing team (most of this functionality is common, with only minor changes depending on team selected)
        case b_Axis:
        case b_Allies:
        case b_Spectate:
            if (!(Sender == b_Axis && CurrentTeam == AXIS_TEAM_INDEX) && !(Sender == b_Allies && CurrentTeam == ALLIES_TEAM_INDEX)) // make sure player is actually changing team
            {
                // Player is prevented from changing team as he switched recently
                if (PC.NextChangeTeamTime >= GRI.ElapsedTime)
                {
                    ConfirmMessage = Repl(default.CantChangeTeamYetText, "{s}", class'TimeSpan'.static.ToString(PC.NextChangeTeamTime - GRI.ElapsedTime));
                    Controller.ShowQuestionDialog(ConfirmMessage, QBTN_OK, QBTN_OK);
                }
                // Player can change team, but give him a screen prompt & ask him to confirm the change
                else
                {
                    // Player can switch freely in single player mode, or within the first ChangeTeamInterval seconds of the round
                    // So this is just a simple confirmation prompt, without any warning
                    if (PlayerOwner().Level.NetMode == NM_Standalone || GRI.ElapsedTime <= class'DarkestHourGame'.default.ChangeTeamInterval)
                    {
                        ConfirmMessage = FreeChangeTeamConfirmText;
                    }
                    // Otherwise warn the player that if he changes team, he'll have to wait a certain time before being allowed to switch again
                    else
                    {
                        ConfirmMessage = Repl(default.ChangeTeamConfirmText, "{s}", class'DarkestHourGame'.default.ChangeTeamInterval);
                    }

                    ConfirmWindow = Controller.ShowQuestionDialog(ConfirmMessage, QBTN_YesNo);

                    // Set the function to call when the player presses 'yes' or 'no'
                    if (Sender == b_Axis)
                    {
                        ConfirmWindow.NewOnButtonClick = ChangeToAxisChoice;
                    }
                    else if (Sender == b_Allies)
                    {
                        ConfirmWindow.NewOnButtonClick = ChangeToAlliesChoice;
                    }
                    else if (Sender == b_Spectate)
                    {
                        ConfirmWindow.bAllowedAsLast = true; // when the confirmation window gets closed, this stops it from defaulting to opening the main menu
                        ConfirmWindow.NewOnButtonClick = ChangeToSpectateChoice;
                    }
                }
            }

            break;

        default:
            break;
    }

    return false;
}

function OnSurrenderConfirmButtonClick(byte Button)
{
    if (Button == QBTN_YES && PC != none && GRI != none)
    {
        PC.ServerTeamSurrenderRequest();
        SurrenderButtonUnlockTime = GRI.ElapsedTime + SurrenderButtonCooldownSeconds;
    }
}

function OnRecommendJoiningSquadButtonClick(byte Button)
{
    switch (Button)
    {
        case QBTN_YES:
            if (PC != none && PC.SquadReplicationInfo != none && PC.SquadReplicationInfo.IsAnySquadJoinable(PC.GetTeamnum()))
            {
                // Automatically join a squad, deselect the current spawn point.
                // Ideally, this will show the user their new spawning options
                // if the squad has it's act together.
                PC.ServerSquadJoinAuto();
                c_Map.p_Map.SelectSpawnPoint(-1);
                SetMapMode(MODE_Map);
            }
            else
            {
                // No squads are joinable, just take them to the squad menu (rare case)
                SetMapMode(MODE_Squads);
            }
            break;
        case QBTN_NO:
            Apply();
            break;
        default:
            break;
    }
}

function bool ChangeToAxisChoice(byte Button)
{
    if (Button == 16) // player has clicked 'yes' to confirm change
    {
        ChangeTeam(AXIS_TEAM_INDEX);
    }

    return true;
}

function bool ChangeToAlliesChoice(byte Button)
{
    if (Button == 16) // player has clicked 'yes' to confirm change
    {
        ChangeTeam(ALLIES_TEAM_INDEX);
    }

    return true;
}

function bool ChangeToSpectateChoice(byte Button)
{
    if (Button == 16) // player has clicked 'yes' to confirm change
    {
        ChangeTeam(254); // to spectator
    }

    return true;
}

function Apply()
{
    local RORoleInfo RI;
    local int        RoleIndex;

    if (b_MenuOptions[6].MenuState == MSAT_Disabled)
    {
        return;
    }

    RI = RORoleInfo(li_Roles.GetObject());

    if (RI == none)
    {
        return;
    }

    RoleIndex = GRI.GetRoleIndexAndTeam(RI);

    if (RoleIndex == -1)
    {
        return;
    }

    if (li_Vehicles.Index == -1)
    {
        return;
    }

    SetButtonsEnabled(false);

    PC.ServerSetPlayerInfo(255,
                           RoleIndex,
                           int(cb_PrimaryWeapon.GetExtra()),
                           int(cb_SecondaryWeapon.GetExtra()),
                           SpawnPointIndex,
                           GetSelectedVehiclePoolIndex());
}

function SetButtonsEnabled(bool bEnable)
{
    bButtonsEnabled = bEnable;

    UpdateButtons();
}

function UpdateButtons()
{
    local bool bContinueEnabled;
    local int  SquadIndex;
    local byte Team;

    if (PRI != none)
    {
        SquadIndex = PRI.SquadIndex;
    }
    else
    {
        SquadIndex = -1;
    }

    if (bButtonsEnabled)
    {
        if (CurrentTeam != ALLIES_TEAM_INDEX)
        {
            b_Allies.EnableMe();
        }
        else
        {
            b_Allies.DisableMe();
        }

        if (CurrentTeam != AXIS_TEAM_INDEX)
        {
            b_Axis.EnableMe();
        }
        else
        {
            b_Axis.DisableMe();
        }

        b_Spectate.EnableMe();

        // Continue button should always be clickable if we're using the old
        // spawning system. If we're using the new spawning system, we have to
        // check that our pending parameters are valid.
        if (PC.ClientLevelInfo.SpawnMode == ESM_RedOrchestra ||
            (li_Vehicles.Index >= 0 && GRI.CanSpawnWithParameters(SpawnPointIndex,
                                                                 CurrentTeam,
                                                                 GRI.GetRoleIndexAndTeam(DHRoleInfo(li_Roles.GetObject()), Team),
                                                                 SquadIndex,
                                                                 GetSelectedVehiclePoolIndex(),
                                                                 true)))
        {
            bContinueEnabled = true;
        }
    }
    else
    {
        b_Allies.DisableMe();
        b_Axis.DisableMe();
        b_Spectate.DisableMe();
    }
    UpdateButtonImageVehicle();

    if (bContinueEnabled)
    {
        b_MenuOptions[6].EnableMe();
        i_Arrows.Image = Material'DH_GUI_Tex.DeployMenu.arrow_blurry';
    }
    else
    {
        b_MenuOptions[6].DisableMe();
        i_Arrows.Image = Material'DH_GUI_Tex.DeployMenu.arrow_disabled';
    }
}

function UpdateButtonImageVehicle()
{
    local class<Vehicle>   VehicleClass;
    local class<DHVehicle> DHVC;
    local int VehiclePoolIndex;

    if (li_Vehicles.GetObject() != none)
    {
        VehiclePoolIndex = GetSelectedVehiclePoolIndex();

        if (VehiclePoolIndex >= -1)
        {
            VehicleClass = GRI.VehiclePoolVehicleClasses[VehiclePoolIndex];
            i_VehiclesButton.Image = VehicleClass.default.SpawnOverlay[0];
            // i_VehiclesButton.Image = Material'DH_GUI_Tex.DeployMenu.vehicles_asterisk';
        }
        else
        {
            i_VehiclesButton.Image = Material'DH_GUI_Tex.DeployMenu.vehicles';
        }
    }
    else
    {
        i_VehiclesButton.Image = Material'DH_GUI_Tex.DeployMenu.vehicles';
    }
}

function PopulateRoles()
{
    local int    i;
    // local class<DHRoleInfo> Role;

    // for (i = 0; i < 6; i++) 
    // {
    //     Role = PC.GetSquadRole(i);
    //     if (Role != none)
    //     {
    //         if (PC != none && PC.bUseNativeRoleNames)
    //         {
    //             li_Roles.Add(Role.default.AltName, Role);
    //         }
    //         else
    //         {
    //             li_Roles.Add(Role.default.MyName, Role);
    //         }
    //     }
    // }

    li_Roles.Clear();

    //TODO: Add Global Roles
    if (PC == none)
    {
        warn("PC is none in PopulateRoles");
        return;
    }

    if (CurrentTeam == AXIS_TEAM_INDEX)
    {
        for (i = 0; i < arraycount(GRI.DHAxisRoles); ++i)
        {
            if (GRI.DHAxisRoles[i] != none && PC.GetRoleEnabledResult(GRI.DHAxisRoles[i]) < 7)
            {
                if (PC.bUseNativeRoleNames)
                {
                    li_Roles.Add(GRI.DHAxisRoles[i].default.AltName, GRI.DHAxisRoles[i]);
                }
                else
                {
                    li_Roles.Add(GRI.DHAxisRoles[i].default.MyName, GRI.DHAxisRoles[i]);
                }
            }
        }
    }
    else if (CurrentTeam == ALLIES_TEAM_INDEX)
    {
        for (i = 0; i < arraycount(GRI.DHAlliesRoles); ++i)
        {
            if (GRI.DHAlliesRoles[i] != none && PC.GetRoleEnabledResult(GRI.DHAlliesRoles[i]) < 7)
            {
                if (PC.bUseNativeRoleNames)
                {
                    li_Roles.Add(GRI.DHAlliesRoles[i].default.AltName, GRI.DHAlliesRoles[i]);
                }
                else
                {
                    li_Roles.Add(GRI.DHAlliesRoles[i].default.MyName, GRI.DHAlliesRoles[i]);
                }
            }
        }
    }

    li_Roles.SortList();
    UpdateRoles();

    if (li_Roles.IsIndexDisabled(li_Roles.Index))
    {
        li_Roles.SetIndex(-1);
    }

    AutoSelectRole();
}

// Automatically selects a role from the roles list. If the player is
// currently assigned to a role, that role will be selected. Otherwise, a role
// that has no limit will be selected. In the rare case that no role is
// limitless, no role will be selected.
function AutoSelectRole()
{
    local int i;
    local RORoleInfo RI;
    local int        RoleIndex;

    // Colin: PC.GetRoleInfo() can be invalid by the time it gets here. For
    // example, when switching teams, the client can (and likely will) get here
    // before PC.GetRoleInfo() is updated. Luckily, we can check the result of
    // SelectByObject and run the default behaviour (select an infinite role)
    // if it fails.
    if (li_Roles.ItemCount == 0 || PC.GetRoleInfo() != none &&
        li_Roles.SelectByObject(PC.GetRoleInfo()) != -1)
    {
        return;
    }


    RoleIndex = GRI.GetRoleIndexAndTeam(RI);

    li_Roles.SelectByObject(none);

    for (i = 0; i < li_Roles.ItemCount; ++i)
    {
        if (!li_Roles.IsIndexDisabled(i))
        {
            li_Roles.SetIndex(i);

            break;
        }
    }

        RI = RORoleInfo(li_Roles.GetObject());

        if (RI == none)
        {
            return;
        }

        RoleIndex = GRI.GetRoleIndexAndTeam(RI);

    //If the Player has spawned, they will have a role already, so we need to change that role for them so they respawn with a squad allowed role
}


// Automatically selects the players' currently selected vehicle to
// spawn. If no vehicle is selected to spawn, the "None" option will be
// selected, by default.
function AutoSelectVehicle()
{
    local UInteger Integer;
    local int      i;

    if (PC.VehiclePoolIndex < 0)
    {
        return;
    }

    for (i = 0; i < li_Vehicles.Elements.Length; ++i)
    {
        Integer = UInteger(li_Vehicles.Elements[i].ExtraData);

        if (Integer != none && Integer.Value == PC.VehiclePoolIndex)
        {
            li_Vehicles.SetIndex(i);
        }
    }
}

function InternalOnMessage(coerce string Msg, float MsgLife)
{
    local int Result;
    local string MessageText;
    local GUIQuestionPage ConfirmWindow;
    local int TeamSizes[2];
    local byte TeamIndex;

    Result = int(MsgLife);

    Log("DHDeployMenu - InternalOnMessage: " @ Msg @ ", result " @ Result);

    if (Msg ~= "NOTIFY_GUI_ROLE_SELECTION_PAGE")
    {
        switch (Result)
        {
            // Spectator
            case 96:
                CloseMenu();
                break;

            // Axis
            case 97:
                OnTeamChanged(AXIS_TEAM_INDEX);
                c_Map.p_Map.SelectSpawnPoint(-1);
                break;

            // Allies
            case 98:
                OnTeamChanged(ALLIES_TEAM_INDEX);
                c_Map.p_Map.SelectSpawnPoint(-1);
                break;

            // Success
            case 0:
                CloseMenu();
                break;

            default:
                MessageText = class'ROGUIRoleSelection'.static.GetErrorMessageForID(Result);
                Controller.ShowQuestionDialog(MessageText, QBTN_OK, QBTN_OK);
                break;
        }
    }
    else if (Msg ~= "NOTIFY_GUI_SURRENDER_RESULT")
    {
        if (Result == -1)
        {
            // Player can surrender; show the confirmation prompt

            if (PC != none && GRI != none)
            {
                GRI.GetTeamSizes(TeamSizes);
                TeamIndex = PC.GetTeamNum();

                MessageText = default.SurrenderConfirmBaseText;

                if (TeamIndex < arraycount(TeamSizes) && TeamSizes[TeamIndex] == 1)
                {
                    // The round will end immediately
                    MessageText @= default.SurrenderConfirmEndRoundText;
                }
                else
                {
                    // The vote will be nominated
                    MessageText @= Repl(default.SurrenderConfirmNominationText, "{0}", int(class'DHVoteInfo_TeamSurrender'.static.GetNominationsThresholdPercent() * 100));
                }

                ConfirmWindow = Controller.ShowQuestionDialog(MessageText, QBTN_YesNo, QBTN_Yes);
                ConfirmWindow.OnButtonClick = OnSurrenderConfirmButtonClick;
            }
        }
        else if (Result >= 0 && Result < SurrenderResponseMessages.Length)
        {
            // The request was denied by the server
            MessageText = SurrenderResponseMessages[Result];
            Controller.ShowQuestionDialog(MessageText, QBTN_OK, QBTN_OK);
        }
        else
        {
            Warn("Received invalid result code");
        }
    }
    else if (Msg ~= "SQUAD_MERGE_REQUEST_RESULT")
    {
        MessageText = class'DHSquadReplicationInfo'.static.GetSquadMergeRequestResultString(Result);
        Controller.ShowQuestionDialog(MessageText, QBTN_OK, QBTN_OK);
    }
    else if (Msg ~= "SQUAD_PROMOTION_REQUEST_RESULT")
    {
        MessageText = class'DHSquadReplicationInfo'.static.GetSquadPromotionRequestResultString(Result);
        Controller.ShowQuestionDialog(MessageText, QBTN_OK, QBTN_OK);
    }

    SetButtonsEnabled(true);
}

// Colin: When the menu is closed, the client tells the server that it is no
// longer in this menu and is therefore ready to be spawned.
function OnClose(optional bool bCancelled)
{
    super.OnClose(bCancelled);

    PC.ServerSetIsInSpawnMenu(false);
}

// Colin: When the menu is closed, the client tells the server that they are in
// the spawn menu and therefore not ready to be spawned.
function OnOpen()
{
    super.OnOpen();

    PC.ServerSetIsInSpawnMenu(true);
    Timer();
    SetTimer(1.0, true);
}

function CloseMenu()
{
    Log("DHDeployMenu close menu called!");
    if (Controller != none)
    {
        Controller.RemoveMenu(self);
    }
}

// Colin: This function centers the map inside of it's root container.
function bool MapContainerPreDraw(Canvas C)
{
    local float Offset;

    Offset = (c_MapRoot.ActualWidth() - c_MapRoot.ActualHeight()) / 2.0;
    Offset /= ActualWidth();

    c_Map.SetPosition(c_MapRoot.WinLeft + Offset,
                      c_MapRoot.WinTop,
                      c_MapRoot.ActualHeight(),
                      c_MapRoot.ActualHeight(),
                      true);

    // c_Squads.SetPosition(c_MapRoot.WinLeft + Offset,
    //                   c_MapRoot.WinTop,
    //                   c_MapRoot.ActualHeight(),
    //                   c_MapRoot.ActualHeight(),
    //                   true);

    return true;
}

function InternalOnChange(GUIComponent Sender)
{
    local class<Inventory> InventoryClass;
    local RORoleInfo       RI;
    local material         InventoryMaterial;
    local int              i, j;

    switch (Sender)
    {
        case li_Roles:
        case lb_Roles:
            i_PrimaryWeapon.Image = none;
            i_SecondaryWeapon.Image = none;

            for (i = 0; i < arraycount(i_GivenItems); ++i)
            {
                if (i_GivenItems[i] != none)
                {
                    i_GivenItems[i].Image = none;
                }
            }

            cb_PrimaryWeapon.Clear();
            cb_SecondaryWeapon.Clear();

            RI = RORoleInfo(li_Roles.GetObject());

            if (RI != none)
            {
                for (i = 0; i < arraycount(RI.PrimaryWeapons); ++i)
                {
                    if (RI.PrimaryWeapons[i].Item != none && cb_PrimaryWeapon.FindIndex(class'DHPlayer'.static.GetInventoryName(RI.PrimaryWeapons[i].Item)) == -1)
                    {
                        cb_PrimaryWeapon.AddItem(class'DHPlayer'.static.GetInventoryName(RI.PrimaryWeapons[i].Item), RI.PrimaryWeapons[i].Item, string(i));
                    }
                }

                for (i = 0; i < arraycount(RI.SecondaryWeapons); ++i)
                {
                    if (RI.SecondaryWeapons[i].Item != none && cb_SecondaryWeapon.FindIndex(class'DHPlayer'.static.GetInventoryName(RI.SecondaryWeapons[i].Item)) == -1)
                    {
                        cb_SecondaryWeapon.AddItem(class'DHPlayer'.static.GetInventoryName(RI.SecondaryWeapons[i].Item), RI.SecondaryWeapons[i].Item, string(i));
                    }
                }
            }

            cb_PrimaryWeapon.SetIndex(0);
            cb_SecondaryWeapon.SetIndex(0);

            if (PC.GetRoleInfo() == RI && RI != none)
            {
                if (PC.DHPrimaryWeapon >= 0)
                {
                    cb_PrimaryWeapon.SetIndex(class'xGUIList'.static.GetIndexOfObject(cb_PrimaryWeapon.MyComboBox.List, RI.PrimaryWeapons[PC.DHPrimaryWeapon].Item));
                }

                if (PC.DHSecondaryWeapon >= 0)
                {
                    cb_SecondaryWeapon.SetIndex(class'xGUIList'.static.GetIndexOfObject(cb_SecondaryWeapon.MyComboBox.List, RI.SecondaryWeapons[PC.DHSecondaryWeapon].Item));
                }
            }

            j = 1;

            if (RI != none)
            {
                for (i = 0; i < arraycount(RI.Grenades); ++i)
                {
                    InventoryClass = RI.Grenades[i].Item;

                    if (InventoryClass != none && class<ROWeaponAttachment>(InventoryClass.default.AttachmentClass) != none)
                    {
                        InventoryMaterial = class<ROWeaponAttachment>(InventoryClass.default.AttachmentClass).default.MenuImage;

                        if (InventoryMaterial != none)
                        {
                            i_GivenItems[j++].Image = InventoryMaterial;
                        }
                    }
                }

                for (i = 0; i < RI.GivenItems.Length; ++i)
                {
                    if (RI.GivenItems[i] != "")
                    {
                        InventoryClass = class<Inventory>(DynamicLoadObject(RI.GivenItems[i], class'class'));

                        if (InventoryClass != none && class<ROWeaponAttachment>(InventoryClass.default.AttachmentClass) != none)
                        {
                            InventoryMaterial = class<ROWeaponAttachment>(InventoryClass.default.AttachmentClass).default.MenuImage;

                            if (InventoryMaterial != none)
                            {
                                if (InventoryMaterial.MaterialUSize() > InventoryMaterial.MaterialVSize())
                                {
                                    //Weapon material is wider than it is high.
                                    //This means it's probably a rocket or some
                                    //other long thing that needs to be put in our
                                    //"wide" slot (0).
                                    i_GivenItems[0].Image = InventoryMaterial;
                                }
                                else
                                {
                                    if (j < arraycount(i_GivenItems))
                                    {
                                        i_GivenItems[j++].Image = InventoryMaterial;
                                    }
                                }
                            }
                        }
                    }
                }
            }

            if (RI != none && RI.bCanBeTankCrew)
            {
                SetLoadoutMode(LM_Vehicle);
            }
            else
            {
                SetLoadoutMode(LM_Equipment);
            }

            // Vehicle eligibility may have changed, update vehicles.
            UpdateVehicles();
            UpdateStatus();

            break;

        case cb_PrimaryWeapon:
            if (class<Inventory>(cb_PrimaryWeapon.GetObject()) != none && class<ROWeaponAttachment>(class<Inventory>(cb_PrimaryWeapon.GetObject()).default.AttachmentClass) != none)
            {
                i_PrimaryWeapon.Image = class<ROWeaponAttachment>(class<Inventory>(cb_PrimaryWeapon.GetObject()).default.AttachmentClass).default.MenuImage;
            }

            break;

        case cb_SecondaryWeapon:
            if (class<Inventory>(cb_SecondaryWeapon.GetObject()) != none && class<ROWeaponAttachment>(class<Inventory>(cb_SecondaryWeapon.GetObject()).default.AttachmentClass) != none)
            {
                i_SecondaryWeapon.Image = class<ROWeaponAttachment>(class<Inventory>(cb_SecondaryWeapon.GetObject()).default.AttachmentClass).default.MenuImage;
            }

            break;

        case li_Vehicles:
        case lb_Vehicles:
            UpdateVehicleImage();
            UpdateSpawnPoints();
            UpdateStatus();

            break;

        default:
            break;
    }
}

function UpdateVehicleImage()
{
    local class<Vehicle>   VehicleClass;
    local class<DHVehicle> DHVC;
    local int              VehiclePoolIndex;

    VehiclePoolIndex = GetSelectedVehiclePoolIndex();

    if (LoadoutMode == LM_Vehicle && VehiclePoolIndex >= 0)
    {
        VehicleClass = GRI.VehiclePoolVehicleClasses[VehiclePoolIndex];
        i_Vehicle.Image = VehicleClass.default.SpawnOverlay[0];

        if (GRI.VehiclePoolIsSpawnVehicles[VehiclePoolIndex] != 0)
        {
            i_SpawnVehicle.Show();
        }
        else
        {
            i_SpawnVehicle.Hide();
        }

        DHVC = class<DHVehicle>(VehicleClass);

        if (DHVC != none && DHVC.default.bIsArtilleryVehicle)
        {
            i_ArtilleryVehicle.Show();
        }
        else
        {
            i_ArtilleryVehicle.Hide();
        }

        if (DHVC != none && DHVC.default.SupplyAttachmentClass != none)
        {
            i_SupplyVehicle.Show();
        }
        else
        {
            i_SupplyVehicle.Hide();
        }

        if (GRI.IgnoresMaxTeamVehiclesFlags(VehiclePoolIndex))
        {
            i_MaxVehicles.Hide();
            l_MaxVehicles.Hide();
        }
        else
        {
            i_MaxVehicles.Show();
            l_MaxVehicles.Show();
        }
    }
    else
    {
        i_Vehicle.Image = default.VehicleNoneMaterial;
        i_SpawnVehicle.Hide();
        i_ArtilleryVehicle.Hide();
        i_SupplyVehicle.Hide();
        i_MaxVehicles.Hide();
        l_MaxVehicles.Hide();
    }
}

function ChangeTeam(int TeamIndex)
{
    if (TeamIndex != CurrentTeam) // confirm that we are actually changing teams
    {
        SetButtonsEnabled(false);
        PC.ServerSetPlayerInfo(TeamIndex, 255, 0, 0, -1, -1);
    }
}

function OnTeamChanged(int TeamIndex)
{
    PlayerSquadIndex = -1;
    CurrentTeam = TeamIndex;

    PopulateRoles();
    PopulateVehicles();

    UpdateSpawnPoints();
    UpdateStatus();
    UpdateButtons();
    UpdateRoundStatus();
    UpdateSquads();
}

function OnSpawnPointChanged(int SpawnPointIndex, optional bool bDoubleClick)
{
    self.SpawnPointIndex = SpawnPointIndex;

    UpdateStatus();
    UpdateButtons();

    if (bDoubleClick)
    {
        Apply();
    }
}

function bool InternalOnPreDraw(Canvas C)
{
    local float AttritionRate;

    if (GRI != none && PC != none)
    {
        AttritionRate = GRI.AttritionRate[CurrentTeam];

        if (!GRI.bIsInSetupPhase && AttritionRate > 0.0)
        {
            // TODO: convert to a material so we don't have to
            // make the alpha calculations ourself in script.
            i_Reinforcements.ImageColor.A = byte((Cos(2.0 * Pi * AttritionRate * PC.Level.TimeSeconds) * 128.0) + 128.0);
        }
        else
        {
            i_Reinforcements.ImageColor.A = 255;
        }
    }

    return super.OnPreDraw(C);
}

function ToggleMapMode()
{
    if (MapMode == MODE_Map)
    {
    }
    else if (MapMode == MODE_Squads)
    {
        SetMapMode(MODE_Map);
    }
}

function ToggleLoadOut()
{
    if (MapMode == MODE_Map)
    {
        if (LoadoutMode == LM_Equipment)
        {
            SetLoadoutMode(LM_Vehicle);
        }
        else if (LoadoutMode == LM_Vehicle)
        {
            SetLoadoutMode(LM_Equipment);
        }
    }
    else if (MapMode == MODE_Squads)
    {
        if (PC.DeployMenuSquadPlayerMode == Mode_Headquarters)
        {
            SetSquadPlayersMode(MODE_ActiveSquads);
        }
        else if (PC.DeployMenuSquadPlayerMode == MODE_ActiveSquads)
        {
            SetSquadPlayersMode(MODE_Unassigned);
        }
        else if (PC.DeployMenuSquadPlayerMode == MODE_Unassigned)
        {
            SetSquadPlayersMode(Mode_Headquarters);
        }
    }
}

function SetMapMode(EMapMode Mode)
{
    local RORoleInfo RI;

    MapMode = Mode;

    switch (MapMode)
    {
        case MODE_Map:
            b_MapButton.DisableMe();
            b_SquadsButton.EnableMe();
            c_Squads.SetVisibility(false);
            p_Squads.DisableMe();
            
            c_Roles.SetVisibility(true);
            c_Roles.EnableMe();
            c_HeadQuarters.SetVisibility(false);

            c_Loadout.SetVisibility(true);
            LoadoutTabContainer.SetVisibility(true);

            b_SquadsActiveButton.SetVisibility(false);
            b_SquadUnassignedButton.SetVisibility(false);
            b_SquadHeadquartersButton.SetVisibility(false);

            i_SquadsActiveButton.SetVisibility(false);
            i_SquadUnassignedButton.SetVisibility(false);
            i_SquadHeadquartersButton.SetVisibility(false);

            l_Status.SetVisibility(true);

            c_Equipment.SetVisibility(true);
            c_Equipment.EnableMe();

            c_Vehicle.SetVisibility(true);
            c_Vehicle.EnableMe();

            RI = RORoleInfo(li_Roles.GetObject());
            if (RI != none && RI.bCanBeTankCrew)
            {
                SetLoadoutMode(LM_Vehicle);
            }
            else
            {
                SetLoadoutMode(LM_Equipment);
            }

            UpdateSpawnPoints();
            break;

        case MODE_Squads:
            b_MapButton.EnableMe();
            b_SquadsButton.DisableMe();
            c_Loadout.SetVisibility(false);
            LoadoutTabContainer.SetVisibility(false);
          
            c_Squads.SetVisibility(true);
            
            c_Roles.SetVisibility(false);
            c_Roles.DisableMe();
            
            p_Squads.EnableMe();

            b_SquadsActiveButton.SetVisibility(true);
            b_SquadUnassignedButton.SetVisibility(true);
            b_SquadHeadquartersButton.SetVisibility(true);

            i_SquadsActiveButton.SetVisibility(true);
            i_SquadUnassignedButton.SetVisibility(true);
            i_SquadHeadquartersButton.SetVisibility(true);
            l_Status.SetVisibility(false);

            c_Equipment.SetVisibility(false);
            c_Equipment.DisableMe();

            c_Vehicle.DisableMe();
            c_Vehicle.SetVisibility(false);

            if (PRI != none && PRI.IsInSquad())
            {
                SetSquadPlayersMode(Mode_Unassigned);
            }
            else
            {
                SetSquadPlayersMode(MODE_ActiveSquads);
            }

            break;

        default:
            Warn("Unhandled map mode");
            break;
    }

    UpdateSquads();
}

function SetSquadPlayersMode(ESquadPlayersMode Mode)
{
    switch (Mode)
    {
        case Mode_Headquarters:
            b_SquadHeadquartersButton.DisableMe();
            b_SquadUnassignedButton.EnableMe();
            b_SquadsActiveButton.EnableMe();
            c_HeadQuarters.SetVisibility(true);
            PC.SetSquadPlayersMode(0);
            break;
        case Mode_UnAssigned:
            b_SquadHeadquartersButton.EnableMe();
            b_SquadUnassignedButton.DisableMe();
            b_SquadsActiveButton.EnableMe();
            c_HeadQuarters.SetVisibility(false);
            PC.SetSquadPlayersMode(1);

            break;
        case MODE_ActiveSquads:
            b_SquadHeadquartersButton.EnableMe();
            b_SquadUnassignedButton.EnableMe();
            b_SquadsActiveButton.DisableMe();
            c_HeadQuarters.SetVisibility(false);
            PC.SetSquadPlayersMode(2);
            break;
        default:
            Warn("Unhandled ESquadPlayersMode mode");
            break;
    }

    UpdateSquads();
}

function bool InternalOnKeyEvent(out byte Key, out byte State, float Delta)
{
    local Interactions.EInputKey    K;
    local Interactions.EInputAction A;

    K = EInputKey(Key);
    A = EInputAction(State);
    if (A == IST_Release)
    {
        switch (K)
        {
            case IK_F1:
                if (MapMode != Mode_Map)
                {
                    SetMapMode(Mode_Map);
                }
                return true;
            case IK_F2:
                if (MapMode != Mode_Squads)
                {
                    SetMapMode(Mode_Squads);
                }
                return true;
            case IK_F3:
                if (MapMode == Mode_Map)
                {
                    if (LoadoutMode != LM_Equipment)
                    {
                        SetLoadoutMode(LM_Equipment);
                    }
                }
                else if (MapMode == Mode_Squads && PC != none)
                {
                    if (PC.DeployMenuSquadPlayerMode != Mode_Headquarters)
                    {
                        SetSquadPlayersMode(Mode_Headquarters);
                    }
                }
                return true;
            case IK_F4:
                if (MapMode == Mode_Map)
                {
                    if (LoadoutMode != LM_Vehicle)
                    {
                        SetLoadoutMode(LM_Vehicle);
                    }
                }
                else if (MapMode == Mode_Squads && PC != none)
                {
                    if (PC.DeployMenuSquadPlayerMode != MODE_ActiveSquads)
                    {
                        SetSquadPlayersMode(MODE_ActiveSquads);
                    }
                }
                return true;
            case IK_F5:
                if (MapMode == Mode_Squads && PC != none)
                {
                    if (PC.DeployMenuSquadPlayerMode != MODE_Unassigned)
                    {
                        SetSquadPlayersMode(MODE_Unassigned);
                    }
                }
                return true;
        }
    }

    return super.OnKeyEvent(Key, State, Delta);
}

function OnSquadNameEditBoxActivate()
{
    eb_SquadName.TextStr = l_SquadName.Caption;
    eb_SquadName.InternalActivate();

    l_SquadName.SetVisibility(false);

    bIsEditingName = true;
}

function OnSquadNameEditBoxDeactivate()
{
    eb_SquadName.TextStr = "";
    eb_SquadName.InternalDeactivate();

    l_SquadName.SetVisibility(true);

    FocusFirst(none);

    bIsEditingName = false;
}

function OnSquadNameEditBoxEnter()
{
    local DHPlayer PCEditer;

    PCEditer = DHPlayer(PlayerOwner());

    if (PCEditer != none)
    {
        l_SquadName.Caption = eb_SquadName.TextStr;

        PCEditer.ServerSquadRename(eb_SquadName.TextStr);
    }

    OnSquadNameEditBoxDeactivate();
}

function UpdatePlayerSquadName(int TeamIndex, int PlayerSquadIndex, bool bIsInASquad)
{
    if (SRI != none && bIsInASquad)
    {
        l_SquadName.Caption = SRI.GetSquadName(TeamIndex, PlayerSquadIndex);
    }
    else
    {
        l_SquadName.Caption = "Unassigned";
    }
}

function HideSquads()
{
    local int i;
    local DHGUISquadComponent            C;

    // HACK: this GUI system is madness and requires me to do stupid things
    // like this in order for it to work.
    for (i = 0; i < p_Squads.SquadComponents.Length; ++i)
    {
        C = p_Squads.SquadComponents[i];
        SetVisible(C, false);
        // SetVisible(C.lb_Members, false);
        // SetVisible(C.li_Members, false);
        // SetVisible(C.b_CreateSquadInfantry, false);
        // // SetVisible(C.b_CreateSquadArmored, false);
        // // SetVisible(C.b_CreateSquadLogistics, false);
        // SetVisible(C.b_JoinSquad, false);
        // SetVisible(C.b_LeaveSquad, false);
        // SetVisible(C.b_LockSquad, false);
        // SetVisible(C.i_LockSquad, false);
        // SetVisible(C.i_NoRallyPoints, false);
    }
}

function UpdateSquadLeaderLockButton(DHGUISquadComponent C, bool bIsSquadLeader, bool bIsSquadLocked, bool bCanSquadBeLocked)
{
    if (!bIsSquadLeader)
    {
        C.b_LockSquad.SetVisibility(false);
        return;
    }

    if (bIsSquadLocked)
    {
        C.i_LockSquad.Image = LockIcon;
        C.b_LockSquad.SetHint(default.UnlockText);
    }
    else
    {
        C.i_LockSquad.Image = UnlockIcon;

        if (bCanSquadBeLocked)
        {
            C.i_LockSquad.ImageColor.A = 255;
            C.b_LockSquad.SetHint(default.LockText);
        }
        else
        {
            C.i_LockSquad.ImageColor.A = 64;
            C.b_LockSquad.SetHint("Squad can be locked only if it has " $ SRI.SquadLockMemberCountMin $ " or more members");
        }
    }
    SetVisible(C.i_LockSquad, true);
    C.b_LockSquad.SetVisibility(true);
}

function ShowPlayerSquad(int TeamIndex, int PlayerSquadIndex)
{
    local DHGUISquadComponent C;
    local array<DHPlayerReplicationInfo> Members;
    local DHPlayerReplicationInfo SavedPri;
    local bool bIsSquadLeader, bIsSquadLocked, bCanSquadBeLocked;
    local int k;

    C = p_Squads.SquadComponents[PlayerSquadIndex];
    C.WinTop = 0.0;
    C.WinHeight = 0.5;
    C.l_SquadName.Caption = "";

    SetVisible(C, true);
    SetVisible(C.l_SquadName, false);
    SetVisible(C.i_SquadType, false);

    SRI.GetMembers(TeamIndex, PlayerSquadIndex, Members);
    bIsSquadLeader = SRI.IsSquadLeader(PRI, TeamIndex, PlayerSquadIndex);
    bIsSquadLocked = SRI.IsSquadLocked(TeamIndex, PlayerSquadIndex);
    bCanSquadBeLocked = SRI.CanSquadBeLocked(TeamIndex, PlayerSquadIndex);

    C.b_LockSquad.SetVisibility(bIsSquadLeader);

    SetVisible(C.b_CreateSquadInfantry, false);
    SetVisible(C.b_JoinSquad, false);
    SetVisible(eb_SquadName, bIsSquadLeader);
    SetVisible(C.b_LockSquad, bIsSquadLeader);
    SetVisible(C.i_LockSquad, bIsSquadLocked || bIsSquadLeader);
    SetVisible(C.lb_Members, true);
    SetVisible(C.li_Members, true);
    SetVisible(C.b_LeaveSquad, true);
    SetVisible(C.i_NoRallyPoints, SRI.SquadHadNoRallyPointsInAwhile(TeamIndex, PlayerSquadIndex));

    // Log("Squad: " @ PlayerSquadIndex @ " - PC SquadIndex: " @ PC.GetSquadIndex() @ " is in squad: " @ SRI.IsInSquad(PRI, TeamIndex, PlayerSquadIndex));
    UpdateSquadLeaderLockButton(C, bIsSquadLeader, bIsSquadLocked, bCanSquadBeLocked);
    C.UpdateBackgroundColor(PRI);

    // Save the current PRI that is selected.
    SavedPRI = DHPlayerReplicationInfo(C.li_Members.GetObject());

    // Add or remove entries to match the member count.
    while (C.li_Members.ItemCount < Members.Length)
    {
        C.li_Members.Add("");
    }

    while (C.li_Members.ItemCount > Members.Length)
    {
        C.li_Members.Remove(0, 1);
    }

    // Update the text and associated object for each item.
    for (k = 0; k < Members.Length; ++k)
    {
        C.li_Members.SetItemAtIndex(k, Members[k].GetNamePrefix() $ "." @ Members[k].PlayerName);
        C.li_Members.SetObjectAtIndex(k, Members[k]);
    }

    // Re-select the previous selection.
    C.li_Members.SelectByObject(SavedPRI);
}

function UpdateSquadTypeImage(DHGUISquadComponent C, int TeamIndex, int SquadIndex)
{
    if (SquadIndex > -1)
    {
        C.i_SquadType.Image = SRI.GetSquadTypeIcon(TeamIndex, SquadIndex);
        C.i_SquadType.SetHint(SRI.GetSquadTypeHint(TeamIndex, SquadIndex));
    }
    else
    {
        C.i_SquadType.Image = none;
    }
}

function UpdateSquadTypeImageForPlayerSquad(int TeamIndex, int SquadIndex, bool bIsInASquad)
{
    if (bIsInASquad && SRI != none)
    {
        i_SquadUnassignedButton.Image = SRI.GetSquadTypeIcon(TeamIndex, SquadIndex);
        i_SquadUnassignedButton.SetHint(SRI.GetSquadTypeHint(TeamIndex, SquadIndex));
    }
    else
    {
        i_SquadUnassignedButton.Image = Texture'DH_GUI_Tex.DeployMenu.StopWatch';
    }
}

function ShowSquads(int TeamIndex, int PlayerSquadIndex, bool bIsInASquad)
{
    local DHGUISquadComponent C;
    local int i;
    local int HeadQuarterIndex;
    local int SquadIndexOffset;
    local bool bIsInSquad, bIsSquadActive;

    HeadQuarterIndex = GetHeadquartersIndex();
    SquadIndexOffset = 0;
    SetVisible(p_Squads.SquadComponents[HeadQuarterIndex], false);
    SetVisible(p_Squads.SquadComponents[GetUnassignedIndex()], false);

    for (i = 0; i < HeadQuarterIndex; ++i)
    {
        bIsInSquad = PlayerSquadIndex == i || SRI.IsInSquad(PRI, TeamIndex, i);

        // if (bIsInSquad)
        // {
        //     continue;
        // }

        C = p_Squads.SquadComponents[i];
        SetVisible(C, true);
        C.UpdateBackgroundColor(PRI);

        if (bIsInASquad)
        {
            C.WinTop = 0 + SquadIndexOffset * 0.1;
        }
        else
        {
            C.WinTop = 0 + SquadIndexOffset * 0.1;
        }

        SquadIndexOffset++;
        C.WinHeight = 0.1;
     
        bIsSquadActive = SRI.IsSquadActive(TeamIndex, i);

        if (bIsSquadActive)
        {
            UpdateActiveSquad(TeamIndex, i, C);
        }
        else
        {
            UpdateInactiveSquad(C, TeamIndex, i);
        }

        UpdateSquadTypeImage(C, TeamIndex, i);
        
        // Save the current PRI that is selected.
        // SavedPRI = DHPlayerReplicationInfo(C.li_Members.GetObject());

        // // Add or remove entries to match the member count.
        // while (C.li_Members.ItemCount < Members.Length)
        // {
        //     C.li_Members.Add("");
        // }

        // while (C.li_Members.ItemCount > Members.Length)
        // {
        //     C.li_Members.Remove(0, 1);
        // }

        // // Update the text and associated object for each item.
        // for (k = 0; k < Members.Length; ++k)
        // {
        //     C.li_Members.SetItemAtIndex(k, Members[k].GetNamePrefix() $ "." @ Members[k].PlayerName);
        //     C.li_Members.SetObjectAtIndex(k, Members[k]);
        // }

        // // Re-select the previous selection.
        // C.li_Members.SelectByObject(SavedPRI);
    }
}

function UpdateActiveSquad(int TeamIndex, int SquadIndex, DHGUISquadComponent C)
{
    local int k, l;
    local int SquadSize;
    local string SquadName;
    local bool bIsSquadFull, bIsSquadLocked, bCanSquadBeLocked;
    local DHPlayerReplicationInfo SavedPri;
    local array<DHPlayerReplicationInfo> Members;

    SetVisible(C.i_SquadType, true);
    SetVisible(C.l_SquadName, true);
    SetVisible(C.i_NoRallyPoints, false);
    SetVisible(C.b_CreateSquadInfantry, false);
    // SetVisible(C.b_CreateSquadArmored, false);
    // SetVisible(C.b_CreateSquadLogistics, false);
    SetVisible(C.lb_Members, false);
    SetVisible(C.li_Members, false);
    SetVisible(C.b_JoinSquad, true);
    SetVisible(C.b_LeaveSquad, false);
    SetVisible(C.i_NoRallyPoints, false);
    C.b_LockSquad.SetVisibility(false);

    SquadName = SRI.GetSquadName(TeamIndex, SquadIndex);
    if (SquadName == "")
    {
        SquadName = SRI.GetDefaultSquadName(TeamIndex, SquadIndex);
    }

    SquadSize = SRi.GetTeamSquadSize(TeamIndex, SquadIndex);
    SRI.GetMembers(TeamIndex, SquadIndex, Members);

    for (l = 0; l < SquadSize; l++)
    {
        if (Members.Length > l && Members[l] != none)
        {
            C.b_JoinSquad.ToolTip.Lines[l] = Members[l].GetNamePrefix() @ "." @ Members[l].PlayerName;
        }
        else
        {
            C.b_JoinSquad.ToolTip.Lines[l] = "";
        }
    }
    C.l_SquadName.Caption = ""; //SquadName @ " ["  @ Members.Length @ "/" @ SquadSize  @ "]";
    C.b_JoinSquad.Caption = SquadName @ " ["  @ Members.Length @ "/" @ SquadSize  @ "]";
    C.b_CreateSquadInfantry.bAcceptsInput = false;
    C.b_JoinSquad.bAcceptsInput = true;
    
    bIsSquadFull = SRI.IsSquadFull(TeamIndex, SquadIndex);
    bIsSquadLocked = SRI.IsSquadLocked(TeamIndex, SquadIndex);
    bCanSquadBeLocked = SRI.CanSquadBeLocked(TeamIndex, SquadIndex);

    if (bIsSquadLocked)
    {
        C.i_LockSquad.Image = LockIcon;
        C.i_LockSquad.ImageColor.A = 128;

        C.b_JoinSquad.DisableMe();
        SetVisible(C.i_LockSquad, true);
        SetVisible(C.b_JoinSquad, false);
    }
    else
    {
        SetVisible(C.i_LockSquad, false);
        SetVisible(C.b_JoinSquad, true);


        if (SRI.IsSquadJoinable(TeamIndex, SquadIndex))
        {
            C.b_JoinSquad.EnableMe();
        }
        else
        {
            // C.b_JoinSquad.DisableMe();
        }
    }

    SavedPRI = DHPlayerReplicationInfo(C.li_Members.GetObject());


    // Add or remove entries to match the member count.
    while (C.li_Members.ItemCount < Members.Length)
    {
        C.li_Members.Add("");
    }

    while (C.li_Members.ItemCount > Members.Length)
    {
        C.li_Members.Remove(0, 1);
    }

    // Update the text and associated object for each item.
    for (k = 0; k < Members.Length; ++k)
    {
        C.li_Members.SetItemAtIndex(k, Members[k].GetNamePrefix() $ "." @ Members[k].PlayerName);
        C.li_Members.SetObjectAtIndex(k, Members[k]);
    }
}

function UpdateInactiveSquad(DHGUISquadComponent C, int TeamIndex, int SquadIndex)
{
    C.l_SquadName.Caption = ""; //SRI.GetDefaultSquadName(TeamIndex, SquadIndex);
    C.b_CreateSquadInfantry.Caption = SRI.GetDefaultSquadName(TeamIndex, SquadIndex);

    SetVisible(C.i_SquadType, true);
    SetVisible(C.l_SquadName, true);
    SetVisible(C.i_NoRallyPoints, false);
    SetVisible(C.b_CreateSquadInfantry, true);
    SetVisible(C.b_JoinSquad, false);
    SetVisible(C.lb_Members, false);
    SetVisible(C.li_Members, false);
    SetVisible(C.b_LeaveSquad, false);
    SetVisible(C.i_NoRallyPoints, false);
    SetVisible(C.i_LockSquad, false);

    C.b_JoinSquad.EnableMe();
    C.b_LockSquad.SetVisibility(false);
    C.b_CreateSquadInfantry.bAcceptsInput = true;
    C.b_JoinSquad.bAcceptsInput = false;
}

function ShowUnassignedPlayers(int TeamIndex, int PlayerIndex)
{
    local DHPlayerReplicationInfo SavedPri;
    local array<DHPlayerReplicationInfo> Members;
    local DHGUISquadComponent C;
    local int i, k;

    //Hide the rest of the squads other than the player expanded one and the unassigned players squad.
    for (i = 0; i < GetUnassignedIndex(); ++i)
    {
        if (i != PlayerIndex)
        {
            SetVisible(p_Squads.SquadComponents[i], false);
        }
    }

    SRI.GetUnassignedPlayers(TeamIndex, Members);
    C = p_Squads.SquadComponents[GetUnassignedIndex()];

    if (Members.Length == 0)
    {
        SetVisible(C, false);
        return;
    }

    C.l_SquadName.Caption = default.UnassignedPlayersCaptionText;
    C.WinTop = 0.55;
    C.WinHeight = 0.5;

    SetVisible(C, true);
    SetVisible(C.lb_Members, true);
    SetVisible(C.li_Members, true);
    SetVisible(C.l_SquadName, false);
    SetVisible(C.b_CreateSquadInfantry, false);
    SetVisible(C.b_JoinSquad, false);
    SetVisible(C.b_LeaveSquad, false);
    SetVisible(C.b_LockSquad, false);
    SetVisible(C.i_LockSquad, false);
    SetVisible(C.i_NoRallyPoints, false);
    SetVisible(C.i_SquadType, false);
    C.UpdateBackgroundColor(PRI);
    // C.l_SquadName.VertAlign = TXTA_Left;

    SavedPRI = DHPlayerReplicationInfo(C.li_Members.GetObject());
    C.b_CreateSquadInfantry.bAcceptsInput = false;
    C.b_JoinSquad.bAcceptsInput = false;

    // Add or remove entries to match the member count.
    while (C.li_Members.ItemCount < Members.Length)
    {
        C.li_Members.Add("");
    }

    while (C.li_Members.ItemCount > Members.Length)
    {
        C.li_Members.Remove(0, 1);
    }

    // Update the text and associated object for each item.
    for (k = 0; k < Members.Length; ++k)
    {
        C.li_Members.SetItemAtIndex(k, Members[k].PlayerName);
        C.li_Members.SetObjectAtIndex(k, Members[k]);
    }

    // Re-select the previous selection.
    C.li_Members.SelectByObject(SavedPRI);
}

function int GetHeadquartersIndex()
{
    return p_Squads.SquadComponents.Length - 2;
}

function int GetUnassignedIndex()
{
    return p_Squads.SquadComponents.Length - 1;
}

function ShowHeadquarters(int TeamIndex, int PlayerIndex, bool bIsInASquad)
{
    local DHPlayerReplicationInfo SavedPri;
    local array<DHPlayerReplicationInfo> Members;
    local DHGUISquadComponent C;
    local int i, k;
    local int HeadquarterIndex;

    local int SquadIndexOffset;
    HeadquarterIndex = GetHeadquartersIndex();
    SetVisible(p_Squads.SquadComponents[GetUnassignedIndex()], false);


    //Hide the rest of the squads other than the player expanded one and the unassigned players squad.
    for (i = 0; i < HeadquarterIndex; ++i)
    {
        SetVisible(p_Squads.SquadComponents[i], false);
    }

    C = p_Squads.SquadComponents[HeadquarterIndex];

    if (PlayerSquadIndex == i || SRI.IsInSquad(PRI, TeamIndex, i))
    {
        ShowPlayerSquad(TeamIndex, PlayerSquadIndex);
    }
    else
    {
        C.WinTop = 0.0;
        C.WinHeight = 0.1;
        C.UpdateBackgroundColor(PRI);
        SetVisible(C, true);
       
        if (SRI.IsSquadActive(TeamIndex, i))
        {
            UpdateActiveSquad(TeamIndex, i, C);
        }
        else
        {
            UpdateInactiveSquad(C, TeamIndex, i);
        }
    }

    UpdateHeadquartersInfo(TeamIndex);
    UpdateSquadTypeImage(C, TeamIndex, i);
}

function UpdateHeadquartersInfo(int TeamIndex)
{
    if (GRI != none && TeamIndex > -1 && TeamIndex < 2)
    {
        l_HqInfoTeamName.Caption = GRI.UnitName[TeamIndex];
        l_HqInfoFireSupport.Caption = "Fire Support: " @ GRI.GetTeamFireSupportBarrage(TeamIndex);
    }
}

function UpdateSquads()
{
    local int TeamIndex, SquadLimit;
    local bool bIsInASquad;
    super.Timer();

    if (PC != none)
    {
        if (PRI == none)
        {
            PRI = DHPlayerReplicationInfo(PC.PlayerReplicationInfo);
        }

        if (PRI != none)
        {
            bIsInASquad = PRI.IsInSquad();
        }
        TeamIndex = PC.GetTeamNum();
        PlayerSquadIndex = PC.GetSquadIndex();
        UpdatePlayerSquadName(TeamIndex, PlayerSquadIndex, bIsInASquad);
        UpdateSquadTypeImageForPlayerSquad(TeamIndex, PlayerSquadIndex, bIsInASquad);
    }

    if (MapMode != MODE_Squads)
    {
        HideSquads();
        return;
    }

    if (PC == none || SRI == none)
    {
        return;
    }

    if (TeamIndex != AXIS_TEAM_INDEX && TeamIndex != ALLIES_TEAM_INDEX)
    {
        return;
    }

    switch (PC.DeployMenuSquadPlayerMode)
    {
        case Mode_Headquarters:
            b_SquadHeadquartersButton.DisableMe();
            b_SquadUnassignedButton.EnableMe();
            b_SquadsActiveButton.EnableMe();
            ShowHeadquarters(TeamIndex, PlayerSquadIndex, bIsInASquad);

            break;
        case MODE_Unassigned:
            b_SquadHeadquartersButton.EnableMe();
            b_SquadUnassignedButton.DisableMe();
            b_SquadsActiveButton.EnableMe();
            ShowUnassignedPlayers(TeamIndex, PlayerSquadIndex);

            if (PlayerSquadIndex != -1)
            {
                ShowPlayerSquad(TeamIndex, PlayerSquadIndex);
            }

            break;
        case MODE_ActiveSquads:
            b_SquadHeadquartersButton.EnableMe();
            b_SquadUnassignedButton.EnableMe();
            b_SquadsActiveButton.DisableMe();
            ShowSquads(TeamIndex, PlayerSquadIndex, bIsInASquad);

            break;
        default:
            Warn("Unhandled squad player mode");
            break;
    }


 

    // if (PRI == none)
    // {
    //     return;
    //     PRI = DHPlayerReplicationInfo(PC.PlayerReplicationInfo);
    // }
    //TODO: Do something with this
    SquadLimit = SRI.GetTeamSquadLimit(TeamIndex);


}

static function SetEnabled(GUIComponent C, bool bEnabled)
{
    if (C != none)
    {
        if (bEnabled)
        {
            C.EnableMe();
        }
        else
        {
            C.DisableMe();
        }
    }
}

static function SetVisible(GUIComponent C, bool bVisible)
{
    if (C != none)
    {
        C.SetVisibility(bVisible);
        SetEnabled(C, bVisible);
    }
}

defaultproperties
{
    SelectRoleText="Select a role"
    SelectSpawnPointText="Select a spawn point"
    DeployInTimeText="Press Continue to deploy ({0})"
    DeployNowText="Press Continue to deploy now!"
    ChangeTeamConfirmText="Are you sure you want to change teams? (you will not be able to change back for {s} seconds)"
    FreeChangeTeamConfirmText="Are you sure you want to change teams?"
    CantChangeTeamYetText="You must wait {s} before you can change teams"
    ReservedString="Reserved"
    VehicleUnavailableString="The vehicle you had selected is no longer available."
    LockText="Lock"
    UnlockText="Unlock"
    NoneText="None"
    LockedText="Locked"
    BotsText="BOTS"
    SquadOnlyText="Squad"
    SquadLeadershipOnlyText="SL"
    SquadASLOnlyText="ASL"
    NonSquadLeaderOnlyText="Privates"
    RoleLockedText="LOCKED"
    RoleLogiOnlyOneClass="--"
    RoleSquadOnlyInfantry="Infantry"
    RoleSquadOnlyArmored="Armored"
    RoleSquadOnlyHeadquarters="Headquarters"
    RecommendJoiningSquadText="It it HIGHLY RECOMMENDED that you JOIN A SQUAD before deploying! Joining a squad grants you additional deployment options and lets you get to the fight faster.||Do you want to automatically join a squad now?"
    UnassignedPlayersCaptionText="Unassigned"
    HeadQuartersCaptionText="Headquarters"

    SurrenderButtonCooldownSeconds=30
    SurrenderConfirmBaseText="Are you sure you want to surrender?"
    SurrenderConfirmNominationText="This action will nominate the team wide vote. The vote will begin after {0}% of the team has opted to retreat."
    SurrenderConfirmEndRoundText="This will immediately end the round in favor of the opposite team."

    SurrenderButtonText[0]="Retreat"
    SurrenderButtonText[1]="Keep fighting"

    SurrenderResponseMessages[0]="Fatal error!"
    SurrenderResponseMessages[1]="You haven't picked a team."
    SurrenderResponseMessages[2]="Round hasn't started yet."
    SurrenderResponseMessages[3]="Retreat vote is disabled."
    SurrenderResponseMessages[4]="Vote is already in progress."
    SurrenderResponseMessages[5]="You've already retreated."
    SurrenderResponseMessages[6]="Your team already had a vote to retreat earlier. Try again later."
    SurrenderResponseMessages[7]="You cannot retreat after the round is over."
    // SurrenderResponseMessages[8]="Your team has too many reinforcements to surrender."
    SurrenderResponseMessages[9]="You cannot retreat this early."
    SurrenderResponseMessages[10]="You cannot retreat during the setup phase."

    MapMode=MODE_Map
    // SquadPlayerMode=MODE_Squads
    bButtonsEnabled=true
    SpawnPointIndex=-1
    VehicleNoneMaterial=Material'DH_GUI_tex.DeployMenu.vehicle_none'

    OnMessage=InternalOnMessage
    OnPreDraw=InternalOnPreDraw
    OnKeyEvent=InternalOnKeyEvent
    bRenderWorld=false
    bAllowedAsLast=true
    WinTop=0.0
    WinHeight=1.0

    Begin Object Class=FloatingImage Name=FloatingBackground
        Image=Texture'DH_GUI_Tex.DeployMenu.Background'
        DropShadow=none
        ImageStyle=ISTY_Scaled
        WinTop=0.0
        WinLeft=0.0
        WinWidth=1.0
        WinHeight=1.0
    End Object
    i_Background=FloatingBackground

    Begin Object Class=ROGUIProportionalContainerNoSkinAlt Name=FooterContainerObject
        WinHeight=0.05
        WinWidth=1.0
        WinLeft=0.0
        WinTop=0.95
    End Object
    c_Footer=FooterContainerObject

    Begin Object Class=ROGUIProportionalContainerNoSkinAlt Name=TeamsContainerObject
        WinHeight=0.05
        WinWidth=0.26
        WinLeft=0.02
        WinTop=0.02
    End Object
    c_Teams=TeamsContainerObject

    Begin Object Class=DHGUIButton Name=AxisButtonObject
        StyleName="DHDeployTabButton"
        WinHeight=1.0
        WinWidth=0.4
        WinTop=0.0
        WinLeft=0.0
        OnClick=OnClick
        Hint="Join Axis"
    End Object
    b_Axis=AxisButtonObject

    Begin Object Class=GUIImage Name=AxisImageObject
        WinHeight=1.0
        WinWidth=0.2
        WinTop=0.0
        WinLeft=0.025
        Image=Material'DH_GUI_tex.DeployMenu.flag_germany'
        ImageStyle=ISTY_Justified
        ImageAlign=ISTY_Center
    End Object
    i_Axis=AxisImageObject

    Begin Object Class=GUILabel Name=AxisLabelObject
        WinHeight=1.0
        WinWidth=0.35
        WinTop=0.0
        WinLeft=0.05
        TextAlign=TXTA_Center
        TextColor=(R=255,G=255,B=255,A=255)
        TextFont="DHMenuFont"
    End Object
    l_Axis=AxisLabelObject

    Begin Object Class=DHGUIButton Name=AlliesButtonObject
        StyleName="DHDeployTabButton"
        WinHeight=1.0
        WinWidth=0.4
        WinTop=0.0
        WinLeft=0.4
        OnClick=OnClick
        Hint="Join Allies"
    End Object
    b_Allies=AlliesButtonObject

    Begin Object Class=GUIImage Name=AlliesImageObject
        WinHeight=1.0
        WinWidth=0.2
        WinTop=0.00
        WinLeft=0.425
        Image=Material'DH_GUI_tex.DeployMenu.flag_usa'
        ImageStyle=ISTY_Justified
        ImageAlign=ISTY_Center
    End Object
    i_Allies=AlliesImageObject

    Begin Object Class=GUILabel Name=AlliesLabelObject
        WinHeight=1.0
        WinWidth=0.35
        WinTop=0.0
        WinLeft=0.45
        TextAlign=TXTA_Center
        TextColor=(R=255,G=255,B=255,A=255)
        TextFont="DHMenuFont"
    End Object
    l_Allies=AlliesLabelObject

    Begin Object Class=DHGUIButton Name=SpectateButtonObject
        StyleName="DHDeployTabButton"
        WinHeight=1.0
        WinWidth=0.2
        WinTop=0.0
        WinLeft=0.8
        OnClick=OnClick
        Hint="Spectate"
    End Object
    b_Spectate=SpectateButtonObject

    Begin Object Class=GUIImage Name=SpectateImageObject
        WinHeight=1.0
        WinWidth=0.2
        WinTop=0.0
        WinLeft=0.85
        Image=Material'DH_GUI_tex.DeployMenu.spectate'
        ImageStyle=ISTY_Justified
        ImageAlign=ISTY_Center
    End Object
    i_Spectate=SpectateImageObject

    Begin Object Class=GUIImage Name=ReinforcementsImageObject
        WinWidth=0.035
        WinHeight=0.04
        WinLeft=0.02
        WinTop=0.075
        ImageStyle=ISTY_Justified
        ImageAlign=IMGA_Center
        Image=Texture'DH_GUI_Tex.DeployMenu.reinforcements'
    End Object
    i_Reinforcements=ReinforcementsImageObject

    Begin Object class=GUILabel Name=ReinforcementsLabelObject
        TextAlign=TXTA_Left
        VertAlign=TXTA_Center
        TextColor=(R=255,G=255,B=255,A=255)
        WinWidth=0.08
        WinHeight=0.05
        WinLeft=0.0575
        WinTop=0.07
        TextFont="DHMenuFont"
    End Object
    l_Reinforcements=ReinforcementsLabelObject

    Begin Object Class=GUIImage Name=SizeAdvantageImageObject
        WinWidth=0.03
        WinHeight=0.035
        WinLeft=0.09
        WinTop=0.075
        ImageStyle=ISTY_Justified
        ImageAlign=IMGA_Center
        Image=Texture'DH_GUI_Tex.DeployMenu.ForceScale'
    End Object
    i_SizeAdvantage=SizeAdvantageImageObject

    Begin Object class=GUILabel Name=SizeAdvantageLabelObject
        TextAlign=TXTA_Left
        VertAlign=TXTA_Center
        TextColor=(R=255,G=255,B=255,A=255)
        WinWidth=0.08
        WinHeight=0.05
        WinLeft=0.12
        WinTop=0.07
        TextFont="DHMenuFont"
    End Object
    l_SizeAdvantage=SizeAdvantageLabelObject

    Begin Object Class=GUIImage Name=RoundTimeImageObject
        WinWidth=0.035
        WinHeight=0.04
        WinLeft=0.17
        WinTop=0.075
        ImageStyle=ISTY_Justified
        ImageAlign=IMGA_Center
        Image=Texture'DH_GUI_Tex.DeployMenu.StopWatch'
    End Object
    i_RoundTime=RoundTimeImageObject

    Begin Object class=GUILabel Name=RoundTimeLabelObject
        TextAlign=TXTA_Left
        VertAlign=TXTA_Center
        TextColor=(R=255,G=255,B=255,A=255)
        WinWidth=0.08
        WinHeight=0.05
        WinLeft=0.2
        WinTop=0.07
        Hint="Time Remaining"
        TextFont="DHMenuFont"
    End Object
    l_RoundTime=RoundTimeLabelObject

    //Headquarters info
    Begin Object Class=GUILabel Name=HqInfoTeamName
        WinHeight=0.3
        WinWidth=0.35
        WinTop=0.4
        WinLeft=0.05
        VertAlign=TXTA_Left
        TextAlign=TXTA_Left
        TextColor=(R=255,G=255,B=255,A=255)
        TextFont="DHMenuFont"
        Caption="Name:"
    End Object
    l_HqInfoTeamName=HqInfoTeamName

    Begin Object Class=GUILabel Name=HqInfoFireSupport
        WinHeight=0.3
        WinWidth=0.35
        WinTop=0.5
        WinLeft=0.05
        VertAlign=TXTA_Left
        TextAlign=TXTA_Left
        TextColor=(R=255,G=255,B=255,A=255)
        TextFont="DHMenuFont"
        Caption="Fire Support:"
    End Object
    l_HqInfoFireSupport=HqInfoFireSupport

    Begin Object Class=ROGUIProportionalContainerNoSkinAlt Name=RolesContainerObject
        WinWidth=0.26
        WinHeight=0.22
        WinLeft=0.02
        WinTop=0.18
        LeftPadding=0.05
        RightPadding=0.05
        TopPadding=0.05
        BottomPadding=0.05
    End Object
    c_Roles=RolesContainerObject

    Begin Object Class=DHGUIListBox Name=RolesListBoxObject
        OutlineStyleName="ItemOutline"
        SectionStyleName="ListSection"
        SelectedStyleName="DHItemOutline"
        StyleName="DHSmallText"
        bVisibleWhenEmpty=true
        bSorted=true
        OnChange=InternalOnChange
        WinWidth=1.0
        WinHeight=1.0
        WinLeft=0.0
        WinTop=0.0
    End Object
    lb_Roles=RolesListBoxObject

    Begin Object Class=DHGUIListBox Name=VehiclesListBoxObject
        OutlineStyleName="ItemOutline"
        SectionStyleName="ListSection"
        SelectedStyleName="DHItemOutline"
        StyleName="DHSmallText"
        bVisibleWhenEmpty=true
        bSorted=true
        OnChange=InternalOnChange
        WinWidth=1.0
        WinHeight=0.5
        WinLeft=0.0
        WinTop=0.5
    End Object
    lb_Vehicles=VehiclesListBoxObject

    Begin Object Class=ROGUIProportionalContainerNoSkinAlt Name=LoadoutTabContainerObject
        WinWidth=0.26
        WinHeight=0.05
        WinLeft=0.02
        WinTop=0.40
    End Object
    LoadoutTabContainer=LoadoutTabContainerObject

    Begin Object Class=ROGUIProportionalContainerNoSkinAlt Name=MapSquadsTabContainerObject
        WinWidth=0.26
        WinHeight=0.05
        WinLeft=0.02
        WinTop=0.13
    End Object
    MapSquadsTabContainer=MapSquadsTabContainerObject

        Begin Object Class=ROGUIProportionalContainerNoSkinAlt Name=SquadsUnassignedActiveTabContainerObject
        WinWidth=0.26
        WinHeight=0.05
        WinLeft=0.02
        WinTop=0.88
    End Object
    MapUnassignedActiveSquadsTabContainer=SquadsUnassignedActiveTabContainerObject

    Begin Object Class=DHGUIButton Name=EquipmentButtonObject
        StyleName="DHDeployTabButton"
        WinWidth=0.5
        WinHeight=1.0
        WinTop=0.0
        WinLeft=0.0
        OnClick=OnClick
        Hint="Equipment"
    End Object
    b_EquipmentButton=EquipmentButtonObject

    Begin Object Class=GUIImage Name=EquipmentButtonImageObject
        WinWidth=0.5
        WinHeight=1.0
        WinLeft=0.0
        WinTop=0.0
        ImageStyle=ISTY_Justified
        ImageAlign=IMGA_Center
        Image=Texture'DH_GUI_Tex.DeployMenu.equipment'
    End Object
    i_EquipmentButton=EquipmentButtonImageObject

    Begin Object Class=DHGUIButton Name=VehicleButtonObject
        StyleName="DHDeployTabButton"
        WinWidth=0.5
        WinHeight=1.0
        WinTop=0.0
        WinLeft=0.5
        OnClick=OnClick
        Hint="Vehicles"
    End Object
    b_VehicleButton=VehicleButtonObject

    Begin Object Class=GUIImage Name=VehiclesButtonImageObject
        WinWidth=0.5
        WinHeight=1.0
        WinLeft=0.5
        WinTop=0.0
        ImageStyle=ISTY_Justified
        ImageAlign=IMGA_Center
        Image=Texture'DH_GUI_Tex.DeployMenu.vehicles'
    End Object
    i_VehiclesButton=VehiclesButtonImageObject

    //Squad Name
    Begin Object class=GUILabel Name=SquadNameLabelObject
        Caption="SquadName"
        TextAlign=TXTA_Left
        // VertAlign=TXTA_Center
        TextColor=(R=255,G=255,B=255,A=255)
        WinWidth=0.5
        WinHeight=1.0
        WinTop=0.0
        WinLeft=0.05
        TextFont="DHMenuFont"
    End Object
    l_SquadName=SquadNameLabelObject

    Begin Object Class=DHGUIEditBox Name=SquadNameEditBox
        Caption=""
        CaptionAlign=TXTA_Center
        StyleName="DHLargeEditBox"
        WinTop=0.0
        WinLeft=0.03
        WinHeight=1.0
        WinWidth=0.5
        TabOrder=0
        OnActivate=OnSquadNameEditBoxActivate
        OnDeactivate=OnSquadNameEditBoxDeactivate
        OnEnter=OnSquadNameEditBoxEnter
        MaxWidth=20
        bVisible=false
    End Object
    eb_SquadName=SquadNameEditBox

    //Map
    Begin Object Class=DHGUIButton Name=MapButtonObject
        StyleName="DHDeployTabButton"
        WinWidth=0.25
        WinHeight=1.0
        WinTop=0.0
        WinLeft=0.5
        OnClick=OnClick
        Hint="Loadout [F1]"
    End Object
    b_MapButton=MapButtonObject

    Begin Object Class=GUIImage Name=MapButtonImageObject
        WinWidth=0.25
        WinHeight=1.0
        WinLeft=0.5
        WinTop=0.0
        ImageStyle=ISTY_Justified
        ImageAlign=IMGA_Center
        Image=Texture'DH_GUI_Tex.DeployMenu.compass'
    End Object
    i_MapButton=MapButtonImageObject

    //Squads
    Begin Object Class=DHGUIButton Name=SquadsButtonObject
        StyleName="DHDeployTabButton"
        WinWidth=0.25
        WinHeight=1.0
        WinTop=0.0
        WinLeft=0.75
        OnClick=OnClick
        Hint="Squads [F1]"
    End Object
    b_SquadsButton=SquadsButtonObject

    Begin Object Class=GUIImage Name=SquadsButtonImageObject
        WinWidth=0.25
        WinHeight=1.0
        WinLeft=0.75
        WinTop=0.0
        ImageStyle=ISTY_Justified
        ImageAlign=IMGA_Center
        Image=Texture'DH_GUI_Tex.DeployMenu.squads'
    End Object
    i_SquadsButton=SquadsButtonImageObject

    //Headquarters
    Begin Object Class=DHGUIButton Name=SquadHeadquartersButtonObject
        StyleName="DHDeployTabButton"
        WinWidth=0.25
        WinHeight=1.0
        WinTop=0.0
        WinLeft=0.25
        OnClick=OnClick
        Hint="Headquarters"
    End Object
    b_SquadHeadquartersButton=SquadHeadquartersButtonObject

    Begin Object Class=GUIImage Name=SquadHeadquartersImageObject
        WinWidth=0.25
        WinHeight=1.0
        WinLeft=0.25
        WinTop=0.0
        ImageStyle=ISTY_Justified
        ImageAlign=IMGA_Center
        Image=Texture'DH_InterfaceArt2_tex.Icons.platoon_hq'
    End Object
    i_SquadHeadquartersButton=SquadHeadquartersImageObject

    //Unassigned squad
    Begin Object Class=DHGUIButton Name=SquadUnassignedButtonObject
        StyleName="DHDeployTabButton"
        WinWidth=0.25
        WinHeight=1.0
        WinTop=0.0
        WinLeft=0.75
        OnClick=OnClick
        Hint="My Squad"
    End Object
    b_SquadUnassignedButton=SquadUnassignedButtonObject

    Begin Object Class=GUIImage Name=SquadUnassignedImageObject
        WinWidth=0.25
        WinHeight=1.0
        WinLeft=0.75
        WinTop=0.0
        ImageStyle=ISTY_Justified
        ImageAlign=IMGA_Center
        Image=Texture'DH_GUI_Tex.DeployMenu.StopWatch'
    End Object
    i_SquadUnassignedButton=SquadUnassignedImageObject

    //Active Squads
    Begin Object Class=DHGUIButton Name=SquadsActiveButtonObject
        StyleName="DHDeployTabButton"
        WinWidth=0.25
        WinHeight=1.0
        WinTop=0.0
        WinLeft=0.50
        OnClick=OnClick
        Hint="List Squads"
    End Object
    b_SquadsActiveButton=SquadsActiveButtonObject

    Begin Object Class=GUIImage Name=SquadsActiveImageObject
        WinWidth=0.25
        WinHeight=1.0
        WinLeft=0.50
        WinTop=0.0
        ImageStyle=ISTY_Justified
        ImageAlign=IMGA_Center
        Image=Texture'DH_GUI_Tex.DeployMenu.DeployEnabled'
    End Object
    i_SquadsActiveButton=SquadsActiveImageObject

    Begin Object Class=ROGUIProportionalContainerNoSkinAlt Name=LoadoutContainerObject
        WinWidth=0.26
        WinHeight=0.43
        WinLeft=0.02
        WinTop=0.45
        LeftPadding=0.05
        RightPadding=0.05
        TopPadding=0.05
        BottomPadding=0.05
        OnClick=OnClick
    End Object
    c_Loadout=LoadoutContainerObject

    Begin Object Class=ROGUIProportionalContainerNoSkinAlt Name=EquipmentContainerObject
        WinWidth=1.0
        WinHeight=1.0
        WinLeft=0.0
        WinTop=0.0
    End Object
    c_Equipment=EquipmentContainerObject

    Begin Object Class=ROGUIProportionalContainerNoSkinAlt Name=VehicleContainerObject
        WinWidth=1.0
        WinHeight=1.0
        WinLeft=0.0
        WinTop=0.0
        bVisible=false
    End Object
    c_Vehicle=VehicleContainerObject

    Begin Object Class=ROGUIProportionalContainerNoSkinAlt Name=HeadquartersContainerObject
        WinWidth=0.26
        WinHeight=0.45
        WinLeft=0.1
        WinTop=0.35
        bVisible=false
    End Object
    c_HeadQuarters=HeadquartersContainerObject

    Begin Object Class=DHGUIButton Name=DisconnectButtonObject
        Caption="Disconnect"
        CaptionAlign=TXTA_Center
        StyleName="DHSmallTextButtonStyle"
        WinHeight=1.0
        WinTop=0.0
        OnClick=OnClick
    End Object
    b_MenuOptions(0)=DisconnectButtonObject

    Begin Object Class=DHGUIButton Name=SuicideButtonObject
        Caption="Suicide"
        CaptionAlign=TXTA_Center
        StyleName="DHSmallTextButtonStyle"
        WinHeight=1.0
        WinTop=0.0
        OnClick=DHDeployMenu.OnClick
    End Object
    b_MenuOptions(1)=SuicideButtonObject

    Begin Object Class=DHGUIButton Name=RetreatButtonObject
        Caption="Retreat"
        CaptionAlign=TXTA_Center
        StyleName="DHSmallTextButtonStyle"
        WinHeight=1.0
        WinTop=0.0
        OnClick=OnClick
    End Object
    b_MenuOptions(2)=RetreatButtonObject

    Begin Object Class=DHGUIButton Name=MapVoteButtonObject
        Caption="Map Vote"
        CaptionAlign=TXTA_Center
        StyleName="DHSmallTextButtonStyle"
        WinHeight=1.0
        WinTop=0.0
        OnClick=OnClick
    End Object
    b_MenuOptions(3)=MapVoteButtonObject

    Begin Object Class=DHGUIButton Name=ServersButtonObject
        Caption="Servers"
        CaptionAlign=TXTA_Center
        StyleName="DHSmallTextButtonStyle"
        WinHeight=1.0
        WinTop=0.0
        OnClick=OnClick
    End Object
    b_MenuOptions(4)=ServersButtonObject

    Begin Object Class=DHGUIButton Name=SettingsButtonObject
        Caption="Settings"
        CaptionAlign=TXTA_Center
        StyleName="DHSmallTextButtonStyle"
        WinHeight=1.0
        WinTop=0.0
        OnClick=OnClick
    End Object
    b_MenuOptions(5)=SettingsButtonObject

    Begin Object Class=DHGUIButton Name=ContinueButtonObject
        Caption="Continue"
        CaptionAlign=TXTA_Center
        StyleName="DHDeployContinueButtonStyle"
        WinHeight=1.0
        WinTop=0.0
        OnClick=OnClick
    End Object
    b_MenuOptions(6)=ContinueButtonObject

    Begin Object Class=GUIImage Name=ArrowImageObject
        Image=Material'DH_GUI_tex.DeployMenu.arrow_blurry'
        WinHeight=1.0
        WinLeft=0.875
        WinWidth=0.125
        ImageStyle=ISTY_Justified
        ImageAlign=ISTY_BottomLeft
    End Object
    i_Arrows=ArrowImageObject

    Begin Object Class=ROGUIProportionalContainerNoSkinAlt Name=MapRootContainerObject
        WinWidth=0.68
        WinHeight=0.91
        WinLeft=0.3
        WinTop=0.02
        OnPreDraw=MapContainerPreDraw
    End Object
    c_MapRoot=MapRootContainerObject

    Begin Object Class=DHGUIMapContainer Name=MapContainerObject
        WinWidth=1.0
        WinHeight=1.0
        WinLeft=0.0
        WinTop=0.0
        OnSpawnPointChanged=OnSpawnPointChanged
    End Object
    c_Map=MapContainerObject

    Begin Object Class=GUIImage Name=PrimaryWeaponImageObject
        WinWidth=1.0
        WinHeight=0.333334
        WinLeft=0.0
        WinTop=0.0
        ImageStyle=ISTY_Justified
        ImageAlign=IMGA_Center
    End Object
    i_PrimaryWeapon=PrimaryWeaponImageObject

    Begin Object Class=DHmoComboBox Name=PrimaryWeaponComboBoxObject
        bReadOnly=true
        CaptionWidth=0
        ComponentWidth=-1
        WinWidth=1.0
        WinLeft=0.0
        WinTop=0.0
        OnChange=InternalOnChange
    End Object
    cb_PrimaryWeapon=PrimaryWeaponComboBoxObject

    Begin Object Class=GUIImage Name=SecondaryWeaponImageObject
        WinWidth=0.333334
        WinHeight=0.333334
        WinLeft=0.0
        WinTop=0.333334
        ImageStyle=ISTY_Justified
        ImageAlign=IMGA_Center
    End Object
    i_SecondaryWeapon=SecondaryWeaponImageObject

    Begin Object Class=DHmoComboBox Name=SecondaryWeaponComboBoxObject
        bReadOnly=true
        CaptionWidth=0
        ComponentWidth=-1
        WinWidth=1.0
        WinLeft=0.0
        WinTop=0.333334
        OnChange=InternalOnChange
    End Object
    cb_SecondaryWeapon=SecondaryWeaponComboBoxObject

    Begin Object Class=GUIImage Name=GivenItemImageObject0
        WinWidth=0.666667
        WinHeight=0.333334
        WinLeft=0.333334
        WinTop=0.333334
        ImageStyle=ISTY_Justified
        ImageAlign=IMGA_Center
    End Object
    i_GivenItems(0)=GivenItemImageObject0

    Begin Object Class=GUIImage Name=GivenItemImageObject1
        WinWidth=0.25
        WinHeight=0.333334
        WinLeft=0.0
        WinTop=0.666667
        ImageStyle=ISTY_Justified
        ImageAlign=IMGA_Center
    End Object
    i_GivenItems(1)=GivenItemImageObject1

    Begin Object Class=GUIImage Name=GivenItemImageObject2
        WinWidth=0.25
        WinHeight=0.333334
        WinLeft=0.25
        WinTop=0.666667
        ImageStyle=ISTY_Justified
        ImageAlign=IMGA_Center
    End Object
    i_GivenItems(2)=GivenItemImageObject2

    Begin Object Class=GUIImage Name=GivenItemImageObject3
        WinWidth=0.25
        WinHeight=0.333334
        WinLeft=0.5
        WinTop=0.666667
        ImageStyle=ISTY_Justified
        ImageAlign=IMGA_Center
    End Object
    i_GivenItems(3)=GivenItemImageObject3

    Begin Object Class=GUIImage Name=GivenItemImageObject4
        WinWidth=0.25
        WinHeight=0.333334
        WinLeft=0.64
        WinTop=0.666667
        ImageStyle=ISTY_Justified
        ImageAlign=IMGA_Center
    End Object
    i_GivenItems(4)=GivenItemImageObject4

    Begin Object Class=GUIImage Name=VehicleImageObject
        WinWidth=1.0
        WinHeight=0.5
        WinLeft=0.0
        WinTop=0.0
        ImageStyle=ISTY_Justified
        ImageAlign=IMGA_Center
    End Object
    i_Vehicle=VehicleImageObject

    Begin Object Class=DHGUIGFXButton Name=SpawnVehicleImageObject
        WinWidth=0.25
        WinHeight=0.125
        WinLeft=0.75
        WinTop=0.0
        Position=ICP_Center
        Graphic=Material'DH_GUI_Tex.DeployMenu.DeployEnabled'
        Hint="Spawn Vehicle"
        bVisible=false
        StyleName="TextLabel"
    End Object
    i_SpawnVehicle=SpawnVehicleImageObject

    Begin Object Class=DHGUIGFXButton Name=ArtilleryVehicleImageObject
        WinWidth=0.25
        WinHeight=0.125
        WinLeft=0.75
        WinTop=0.0
        Position=ICP_Center
        Graphic=Material'DH_GUI_Tex.DeployMenu.artillery'
        bVisible=false
        Hint="Artillery Vehicle"
        StyleName="TextLabel"
    End Object
    i_ArtilleryVehicle=ArtilleryVehicleImageObject

    Begin Object Class=DHGUIGFXButton Name=MaxVehiclesImageObject
        WinWidth=0.125
        WinHeight=0.125
        WinLeft=0.0
        WinTop=0.0
        Position=ICP_Center
        Graphic=Material'DH_InterfaceArt2_tex.Icons.tank'
        bVisible=false
        Hint="Tanks Available"
        StyleName="TextLabel"
    End Object
    i_MaxVehicles=MaxVehiclesImageObject

    Begin Object Class=GUILabel Name=MaxVehiclesLabelObject
        WinHeight=0.125
        WinWidth=0.125
        WinTop=0.0
        WinLeft=0.125
        TextAlign=TXTA_Center
        TextColor=(R=255,G=255,B=255,A=255)
        TextFont="DHMenuFont"
    End Object
    l_MaxVehicles=MaxVehiclesLabelObject

    Begin Object Class=DHGUIGFXButton Name=SupplyVehicleImageObject
        WinWidth=0.25
        WinHeight=0.125
        WinLeft=0.5
        WinTop=0.0
        Position=ICP_Center
        Graphic=Material'DH_InterfaceArt2_tex.Icons.supply_cache'
        bVisible=false
        Hint="Construction Supply Vehicle"
        StyleName="TextLabel"
    End Object
    i_SupplyVehicle=SupplyVehicleImageObject

    Begin Object Class=GUILabel Name=StatusLabelObject
        WinWidth=0.26
        WinHeight=0.05
        WinLeft=0.02
        WinTop=0.88
        TextAlign=TXTA_Center
        VertAlign=TXTA_Center
        TextColor=(R=255,G=255,B=255,A=255)
        TextFont="DHMenuFont"
    End Object
    l_Status=StatusLabelObject

    Begin Object Class=ROGUIProportionalContainerNoSkinAlt Name=SquadsContainerObject
        WinWidth=0.28
        WinHeight=0.72
        WinLeft=0.01
        WinTop=0.15
        LeftPadding=0.05
        RightPadding=0.05
        TopPadding=0.05
        BottomPadding=0.05
        bVisible=false
    End Object
    c_Squads=SquadsContainerObject

    Begin Object Class=DHGUISquadsComponent Name=SquadsComponentObject
        WinWidth=1.0
        WinHeight=1.0
        WinLeft=0.0
        WinTop=0.0
        bNeverFocus=true
    End Object
    p_Squads=SquadsComponentObject


    LockIcon=Texture'DH_InterfaceArt2_tex.Icons.lock'
    UnlockIcon=Texture'DH_InterfaceArt2_tex.Icons.unlock'
}
