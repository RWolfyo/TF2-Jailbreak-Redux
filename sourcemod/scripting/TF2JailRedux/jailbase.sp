public char strCustomLR[64];	// Used for formatting the player custom lr say hook

/*int
	AmmoTable[2049],
	ClipTable[2049]
;*/

int EnumTNPS[4][eTextNodeParams];

StringMap hJailFields[PLYR];

methodmap JailFighter
{
	public JailFighter( const int ind, bool uid = false )
	{
		int player;
		if (uid && GetClientOfUserId(ind) > 0)
			player = ind;
		else if (IsClientValid(ind))
			player = GetClientUserId(ind);
		return view_as< JailFighter >(player);
	}

	property int userid
	{
		public get()				{ return view_as< int >(this); }
	}
	property int index
	{
		public get()				{ return GetClientOfUserId(view_as< int >(this)); }
	}

	property int iCustom
	{
		public get()
		{
			int i; hJailFields[this.index].GetValue("iCustom", i);
			return i;
		}
		public set( const int i )
		{
			hJailFields[this.index].SetValue("iCustom", i);
		}
	}
	property int iKillCount
	{
		public get()
		{
			int i; hJailFields[this.index].GetValue("iKillCount", i);
			return i;
		}
		public set( const int i )
		{
			hJailFields[this.index].SetValue("iKillCount", i);
		}
	}

	property bool bIsWarden
	{
		public get()
		{
			bool i; hJailFields[this.index].GetValue("bIsWarden", i);
			return i;
		}
		public set( const bool i )
		{
			hJailFields[this.index].SetValue("bIsWarden", i);
		}
	}
	property bool bIsMuted
	{
		public get()				
		{
			bool i; hJailFields[this.index].GetValue("bIsMuted", i);
			return i;
		}
		public set( const bool i )		
		{
			hJailFields[this.index].SetValue("bIsMuted", i);
		}
	}
	property bool bIsQueuedFreeday
	{
		public get()				
		{
			bool i; hJailFields[this.index].GetValue("bIsQueuedFreeday", i);
			return i;
		}
		public set( const bool i )		
		{
			hJailFields[this.index].SetValue("bIsQueuedFreeday", i);
		}
	}
	property bool bIsFreeday
	{
		public get()				
		{
			bool i; hJailFields[this.index].GetValue("bIsFreeday", i);
			return i;
		}
		public set( const bool i )		
		{
			hJailFields[this.index].SetValue("bIsFreeday", i);
		}
	}
	property bool bLockedFromWarden
	{
		public get()				
		{
			bool i; hJailFields[this.index].GetValue("bLockedFromWarden", i);
			return i;
		}
		public set( const bool i )		
		{
			hJailFields[this.index].SetValue("bLockedFromWarden", i);
		}
	}
	property bool bIsVIP
	{
		public get()				
		{
			bool i; hJailFields[this.index].GetValue("bIsVIP", i);
			return i;
		}
		public set( const bool i )
		{
			hJailFields[this.index].SetValue("bIsVIP", i);
		}
	}
	property bool bIsAdmin
	{
		public get()				
		{
			bool i; hJailFields[this.index].GetValue("bIsAdmin", i);
			return i;
		}
		public set( const bool i )
		{
			hJailFields[this.index].SetValue("bIsAdmin", i);
		}
	}
	property bool bIsHHH
	{
		public get()				
		{
			bool i; hJailFields[this.index].GetValue("bIsHHH", i);
			return i;
		}
		public set( const bool i )		
		{
			hJailFields[this.index].SetValue("bIsHHH", i);
		}
	}
	property bool bInJump
	{
		public get()				
		{
			bool i; hJailFields[this.index].GetValue("bInJump", i);
			return i;
		}
		public set( const bool i )
		{
			hJailFields[this.index].SetValue("bInJump", i);
		}
	}
#if defined _clientprefs_included
	property bool bNoMusic
	{
		public get()
		{
			if (!AreClientCookiesCached(this.index))
				return false;
			char strMusic[6];
			GetClientCookie(this.index, MusicCookie, strMusic, sizeof(strMusic));
			return (StringToInt(strMusic) == 1);
		}
		public set( const bool i )
		{
			if (!AreClientCookiesCached(this.index))
				return;
			int value = (i ? 1 : 0);
			char strMusic[6];
			IntToString(value, strMusic, sizeof(strMusic));
			SetClientCookie(this.index, MusicCookie, strMusic);
		}
	}
#endif
	property bool bUnableToTeleport
	{
		public get()				
		{
			bool i; hJailFields[this.index].GetValue("bUnableToTeleport", i);
			return i;
		}
		public set( const bool i )
		{
			hJailFields[this.index].SetValue("bUnableToTeleport", i);
		}
	}
	
	property float flSpeed
	{
		public get()
		{
			float i; hJailFields[this.index].GetValue("flSpeed", i);
			return i;
		}
		public set( const float i )
		{
			hJailFields[this.index].SetValue("flSpeed", i);
		}
	}
	property float flKillSpree
	{
		public get()
		{
			float i; hJailFields[this.index].GetValue("flKillSpree", i);
			return i;
		}
		public set( const float i )
		{
			hJailFields[this.index].SetValue("flKillSpree", i);
		}
	}
	/**
	 * Creates and spawns a weapon to a player
	 *
	 * @param name		entity name of the weapon, example: "tf_weapon_bat"
	 * @param index		the index of the desired weapon
	 * @param level		the level of the weapon
	 * @param qual		the weapon quality of the item
	 * @param att		the nested attribute string, example: "2 ; 2.0" - increases weapon damage by 100% aka 2x.
	 * @return			entity index of the newly created weapon
	 */
	public int SpawnWeapon( char[] name, int index, int level, int qual, char[] att )
	{
		Handle hWeapon = TF2Items_CreateItem(OVERRIDE_ALL|FORCE_GENERATION);
		if (hWeapon == null)
			return -1;

		TF2Items_SetClassname(hWeapon, name);
		TF2Items_SetItemIndex(hWeapon, index);
		TF2Items_SetLevel(hWeapon, level);
		TF2Items_SetQuality(hWeapon, qual);
		char atts[32][32];
		int count = ExplodeString(att, " ; ", atts, 32, 32);
		count &= ~1;
		if (count > 0) 
		{
			TF2Items_SetNumAttributes(hWeapon, count/2);
			int i2=0;
			for (int i=0 ; i<count ; i += 2) 
			{
				TF2Items_SetAttribute(hWeapon, i2, StringToInt(atts[i]), StringToFloat(atts[i+1]));
				i2++;
			}
		}
		else TF2Items_SetNumAttributes(hWeapon, 0);

		int entity = TF2Items_GiveNamedItem(this.index, hWeapon);
		delete (hWeapon);
		EquipPlayerWeapon(this.index, entity);
		return entity;
	}
	/**
	 * gets the max recorded ammo for a certain weapon index
	 *
	 * @param wepslot	the equipment slot of the player
	 * @return		the recorded max ammo of the weapon
	 */
	/*public int GetAmmotable(const int wepslot)
	{
		int weapon = GetPlayerWeaponSlot(this.index, wepslot);
		if (weapon > MaxClients && IsValidEntity(weapon))
			return AmmoTable[weapon];
		return -1;
	}*/
	
	/**
	 * sets the max recorded ammo for a certain weapon index
	 *
	 * @param wepslot	the equipment slot of the player
	 * @param val		how much the new max ammo should be
	 * @noreturn
	 */
	/*public void SetAmmotable(const int wepslot, const int val)
	{
		int weapon = GetPlayerWeaponSlot(this.index, wepslot);
		if (weapon > MaxClients && IsValidEntity(weapon))
			AmmoTable[weapon] = val;
	}*/
	/**
	 * gets the max recorded clipsize for a certain weapon index
	 *
	 * @param wepslot	the equipment slot of the player
	 * @return		the recorded clipsize ammo of the weapon
	 */
	/*public int GetCliptable(const int wepslot)
	{
		int weapon = GetPlayerWeaponSlot(this.index, wepslot);
		if (weapon > MaxClients && IsValidEntity(weapon))
			return ClipTable[weapon];
		return -1;
	}*/
	
	/**
	 * sets the max recorded clipsize for a certain weapon index
	 *
	 * @param wepslot	the equipment slot of the player
	 * @param val		how much the new max clipsize should be
	 * @noreturn
	 */
	/*public void SetCliptable(const int wepslot, const int val)
	{
		int weapon = GetPlayerWeaponSlot(this.index, wepslot);
		if (weapon > MaxClients && IsValidEntity(weapon))
			ClipTable[weapon] = val;
	}*/

	/**
	 *	Retrieve an item definition index of a player's weaponslot.
	 *
	 *	@param slot 		Slot to grab the item index from.
	 *
	 *	@return 			Index of the valid, equipped weapon.
	*/
	public int GetWeaponSlotIndex( const int slot )
	{
		int weapon = GetPlayerWeaponSlot(this.index, slot);
		return GetItemIndex(weapon);
	}
	/**
	 *	Set the alpha magnitude a player's weapons.
	 *
	 *	@param alpha 		Number from 0 to 255 to set on the weapon.
	 *
	 *	@noreturn
	*/
	public void SetWepInvis( const int alpha )
	{
		int transparent = alpha;
		int entity;
		for (int i = 0; i < 5; i++) 
		{
			entity = GetPlayerWeaponSlot(this.index, i); 
			if (IsValidEdict(entity) && IsValidEntity(entity))
			{
				if (transparent > 255)
					transparent = 255;
				if (transparent < 0)
					transparent = 0;
				SetEntityRenderMode(entity, RENDER_TRANSCOLOR); 
				SetEntityRenderColor(entity, 150, 150, 150, transparent); 
			}
		}
	}
	/*public void SetOverlay(const char[] strOverlay)
	{
		int iFlags = GetCommandFlags("r_screenoverlay") & (~FCVAR_CHEAT);
		SetCommandFlags("r_screenoverlay", iFlags);
		ClientCommand(this.index, "r_screenoverlay \"%s\"", strOverlay);
	}*/
	/**
	 *	Teleport a player to the appropriate spawn location.
	 *
	 *	@param team 		Team spawn to teleport the client to.
	 *
	 *	@noreturn
	*/
	public void TeleToSpawn( int team = 0 )
	{
		int iEnt = -1;
		float vPos[3], vAng[3];
		ArrayList hArray = new ArrayList();
		while ((iEnt = FindEntityByClassname(iEnt, "info_player_teamspawn")) != -1)
		{
			if (team <= 1)
				hArray.Push(iEnt);
			else 
			{
				if (GetEntProp(iEnt, Prop_Send, "m_iTeamNum") == team)
					hArray.Push(iEnt);
			}
		}
		iEnt = hArray.Get(GetRandomInt(0, hArray.Length-1));
		delete hArray;

		GetEntPropVector(iEnt, Prop_Send, "m_vecOrigin", vPos);
		GetEntPropVector(iEnt, Prop_Send, "m_angRotation", vAng);
		TeleportEntity(this.index, vPos, vAng, NULL_VECTOR);
	}
	/**
	 *	Spawn a small healthpack at the client's origin.
	 *
	 *	@param ownerteam 	Team to give the healthpack.
	 *
	 *	@noreturn
	*/
	public void SpawnSmallHealthPack( int ownerteam = 0 )
	{
		if (!IsPlayerAlive(this.index))
			return;

		int healthpack = CreateEntityByName("item_healthkit_small");
		if (IsValidEntity(healthpack))
		{
			float pos[3]; GetClientAbsOrigin(this.index, pos);
			pos[2] += 20.0;
			DispatchKeyValue(healthpack, "OnPlayerTouch", "!self,Kill,,0,-1");  //for safety, though it normally doesn't respawn
			DispatchSpawn(healthpack);
			SetEntProp(healthpack, Prop_Send, "m_iTeamNum", ownerteam, 4);
			SetEntityMoveType(healthpack, MOVETYPE_VPHYSICS);
			float vel[3];
			vel[0] = float(GetRandomInt(-10, 10)), vel[1] = float(GetRandomInt(-10, 10)), vel[2] = 50.0;
			TeleportEntity(healthpack, pos, NULL_VECTOR, vel);
		}
	}
	/**
	 *	Silently switch a player's team.
	 *
	 *	@param team 		Team to switch to.
	 *	@param spawn 		Determine whether or not to respawn the client.
	 *
	 *	@noreturn
	*/
	public void ForceTeamChange( const int team, bool spawn = true )
	{
		int client = this.index;
		if (TF2_GetPlayerClass(client) > TFClass_Unknown) 
		{
			SetEntProp(client, Prop_Send, "m_lifeState", 2);
			ChangeClientTeam(client, team);
			SetEntProp(client, Prop_Send, "m_lifeState", 0);
			if (spawn)
				TF2_RespawnPlayer(client);
		}
	}
	/**
	 *	Mute a client through the plugin.
	 *	@NOTE 				Players that are deemed as admins will never be muted.
	 *
	 *	@noreturn
	*/
	public void MutePlayer()
	{
		int client = this.index;
		if (!this.bIsMuted && !this.bIsAdmin && !AlreadyMuted(client))
		{
			SetClientListeningFlags(client, VOICE_MUTED);
			this.bIsMuted = true;
			PrintToConsole(client, "[TF2Jail] You are muted by the plugin.");
		}
	}
	/**
	 *	Initialize a player as a freeday.
	 *	@NOTE 				Does not teleport them to the freeday location.
	 *
	 *	@noreturn
	*/
	public void GiveFreeday()
	{
		ServerCommand("sm_evilbeam #%d", this.userid);
		int flags = GetEntityFlags(this.index) | FL_NOTARGET;
		SetEntityFlags(this.index, flags);

		if (this.bIsQueuedFreeday)
			this.bIsQueuedFreeday = false;
		this.bIsFreeday = true;

		Call_OnFreedayGiven(this);
	}
	/**
	 *	Terminate a player as a freeday.
	 *
	 *	@noreturn
	*/
	public void RemoveFreeday()
	{
		int client = this.index;
		int flags = GetEntityFlags(client) & ~FL_NOTARGET;
		SetEntityFlags(client, flags);
		ServerCommand("sm_evilbeam #%d", this.userid);
		this.bIsFreeday = false;
		//SetEntProp(client, Prop_Data, "m_takedamage", 2, 1);

		Call_OnFreedayRemoved(this);
	}
	/**
	 *	Remove all player weapons that are not their melee.
	 *
	 *	@noreturn
	*/
	public void StripToMelee()
	{
		int client = this.index;
		TF2_RemoveWeaponSlot(client, 0);
		TF2_RemoveWeaponSlot(client, 1);
		TF2_RemoveWeaponSlot(client, 3);
		TF2_RemoveWeaponSlot(client, 4);
		TF2_RemoveWeaponSlot(client, 5);
		//TF2_SwitchToSlot(client, TFWeaponSlot_Melee);

		char sClassName[64];
		int wep = GetPlayerWeaponSlot(client, TFWeaponSlot_Melee);
		if (wep > MaxClients && IsValidEdict(wep) && GetEdictClassname(wep, sClassName, sizeof(sClassName)))
			SetEntPropEnt(client, Prop_Send, "m_hActiveWeapon", wep);
	}
	/**
	 *	Strip a player of all of their ammo.
	 *
	 *	@noreturn
	*/
	public void EmptyWeaponSlots()
	{
		int client = this.index;
		if (!IsClientValid(client) || TF2_GetClientTeam(client) != TFTeam_Red)
			return;

		int offset = FindDataMapInfo(client, "m_hMyWeapons") - 4;
		int weapon;

		for (int i = 0; i < 2; i++)
		{
			offset += 4;
			weapon = GetEntDataEnt2(client, offset);

			if (!IsValidEntity(weapon) || i == TFWeaponSlot_Melee)
				continue;

			int clip = GetEntProp(weapon, Prop_Data, "m_iClip1");
			if (clip != -1)
				SetEntProp(weapon, Prop_Data, "m_iClip1", 0);

			clip = GetEntProp(weapon, Prop_Data, "m_iClip2");
			if (clip != -1)
				SetEntProp(weapon, Prop_Data, "m_iClip2", 0);

			SetWeaponAmmo(weapon, 0);
		}

		char sClassName[64];
		int wep = GetPlayerWeaponSlot(client, TFWeaponSlot_Melee);
		if (wep > MaxClients && IsValidEdict(wep) && GetEdictClassname(wep, sClassName, sizeof(sClassName)))
			SetEntPropEnt(client, Prop_Send, "m_hActiveWeapon", wep);

		//CPrintToChat(client, "{red}[TF2Jail]{tan} Your weapons and ammo have been stripped.");
	}
	/**
	 *	Unmute a player through the plugin.
	 *
	 *	@noreturn
	*/
	public void UnmutePlayer()
	{
		if (!this.bIsMuted)
			return;

		int client = this.index;
		SetClientListeningFlags(client, VOICE_NORMAL);
		this.bIsMuted = false;
		PrintToConsole(client, "[TF2Jail] You are unmuted by the plugin.");
	}
	/**
	 *	Initialize a player as the warden.
	 *	@NOTE 				This automatically gives the player the warden menu
	 *
	 *	@noreturn
	*/
	public void WardenSet()
	{
		this.bIsWarden = true;	
		this.UnmutePlayer();
		char strWarden[256];
		int client = this.index;
		Format(strWarden, sizeof(strWarden), "%N is the current Warden.", client);
		SetTextNode(hTextNodes[2], strWarden, EnumTNPS[2][fCoord_X], EnumTNPS[2][fCoord_Y], EnumTNPS[2][fHoldTime], EnumTNPS[2][iRed], EnumTNPS[2][iGreen], EnumTNPS[2][iBlue], EnumTNPS[2][iAlpha], EnumTNPS[2][iEffect], EnumTNPS[2][fFXTime], EnumTNPS[2][fFadeIn], EnumTNPS[2][fFadeOut]);
		CPrintToChatAll("{red}[TF2Jail]{default} %N{tan} is the new Warden", client);
		ManageWarden(this);
	}
	/**	Props to VoIDed
	 * Sets the custom model of this player.
	 *
	 * @param model		The model to set on this player.
	*/
	public void SetCustomModel( const char[] model )
	{
		SetVariantString(model);
		AcceptEntityInput(this.index, "SetCustomModel" );
	}
	/**
	 *	Terminate a player as the warden.
	 *
	 *	@noreturn
	*/
	public void WardenUnset()
	{
		if (!this.bIsWarden)
			return;

		if (hTextNodes[2] != null)
		{
			for (int i = MaxClients; i; --i)
				if (IsClientInGame(i))
					ClearSyncHud(i, hTextNodes[2]);
		}
		this.bIsWarden = false;
		this.SetCustomModel("");
	}
	/**
	 *	Remove all weapons, disguises, and wearables from a client.
	 *
	 *	@noreturn
	*/
	public void PreEquip()
	{
		int client = this.index;
		TF2_RemovePlayerDisguise(client);
		int ent = -1;
		while ((ent = FindEntityByClassname(ent, "tf_wearable_demoshield")) != -1)
		{
			if (GetOwner(ent) == client) {
				TF2_RemoveWearable(client, ent);
				AcceptEntityInput(ent, "Kill");
			}
		}
		ent = -1;
		while ((ent = FindEntityByClassname(ent, "tf_wearable")) != -1)
		{
			if (GetOwner(ent) == client) {
				TF2_RemoveWearable(client, ent);
				AcceptEntityInput(ent, "Kill");
			}
		}
		ent = -1;
		while ((ent = FindEntityByClassname(ent, "tf_powerup_bottle")) != -1)
		{
			if (GetOwner(ent) == client) {
				TF2_RemoveWearable(client, ent);
				AcceptEntityInput(ent, "Kill");
			}
		}
		ent = -1;
		while ((ent = FindEntityByClassname(ent, "tf_wearable_razorback")) != -1)
		{
			if (GetOwner(ent) == client) {
				TF2_RemoveWearable(client, ent);
				AcceptEntityInput(ent, "Kill");
			}
		}
		ent = -1;
		while ((ent = FindEntityByClassname(ent, "tf_wearable_campaign_item")) != -1)
		{
			if (GetOwner(ent) == client) {
				TF2_RemoveWearable(client, ent);
				AcceptEntityInput(ent, "Kill");
			}
		}
		TF2_RemoveAllWeapons(client);
	}
	/**
	 *	Convert a player into the Horseless Headless Horsemann.
	 *
	 *	@noreturn
	*/
	public void MakeHorsemann()
	{
		int client = this.index;

		int ragdoll = GetEntPropEnt(client, Prop_Send, "m_hRagdoll");
		if (ragdoll > MaxClients && IsValidEntity(ragdoll)) 
			AcceptEntityInput(ragdoll, "Kill");
		char weaponname[32];
		GetClientWeapon(client, weaponname, sizeof(weaponname));
		if (!strcmp(weaponname, "tf_weapon_minigun", false)) 
		{
			SetEntProp(GetPlayerWeaponSlot(client, 0), Prop_Send, "m_iWeaponState", 0);
			TF2_RemoveCondition(client, TFCond_Slowed);
		}
		//TF2_SwitchtoSlot(client, TFWeaponSlot_Melee);
		this.PreEquip();
		this.SpawnWeapon("tf_weapon_sword", 266, 100, 5, "264 ; 1.75 ; 263 ; 1.3 ; 15 ; 0 ; 2 ; 3.1 ; 107 ; 4.0 ; 109 ; 0.0 ; 68 ; -2 ; 53 ; 1.0 ; 27 ; 1.0");

		char sClassName[64];
		int wep = GetPlayerWeaponSlot(client, TFWeaponSlot_Melee);
		if (wep > MaxClients && IsValidEdict(wep) && GetEdictClassname(wep, sClassName, sizeof(sClassName)))
			SetEntPropEnt(client, Prop_Send, "m_hActiveWeapon", wep);

		this.SetCustomModel("models/bots/headless_hatman.mdl");
		SetEntProp(client, Prop_Send, "m_bUseClassAnimations", 1);
		SetEntPropFloat(client, Prop_Send, "m_flModelScale", 1.25);
		SetEntProp(wep, Prop_Send, "m_iWorldModelIndex", PrecacheModel("models/weapons/c_models/c_bigaxe/c_bigaxe.mdl"));
		SetEntProp(wep, Prop_Send, "m_nModelIndexOverrides", PrecacheModel("models/weapons/c_models/c_bigaxe/c_bigaxe.mdl"), _, 0);

		SetVariantInt(1);
		AcceptEntityInput(client, "SetForcedTauntCam");

		SetEntProp(client, Prop_Send, "m_iHealth", 1500);
		DoHorsemannParticles(client);
		this.bIsHHH = true;
	}
	/**
	 *	Terminate a player as the Horseless Headless Horsemann.
	 *
	 *	@noreturn
	*/
	public void UnHorsemann()
	{
		int client = this.index;

		SetVariantString("");
		AcceptEntityInput(client, "SetCustomModel");
		SetEntPropFloat(client, Prop_Data, "m_flModelScale", 1.0);
		SetVariantInt(0);
		AcceptEntityInput(client, "SetForcedTauntCam");
		ClearHorsemannParticles(client);

		if (IsPlayerAlive(client))
			ResetPlayer(client);
		this.bIsHHH = false;
	}
	/**
	 *	Teleport a player either to a freeday or warday location.
	 *	@NOTE 				If gamemode teleport properties are not true, player will be teleported to map's origin
	 *
	 *	@param location 	Location to teleport the client.
	 *
	 *	@noreturn
	*/
	public void TeleportToPosition( const int location )
	{
		switch (location)
		{
			case 1:TeleportEntity(this.index, flFreedayPosition, nullvec, nullvec);
			case 2:TeleportEntity(this.index, flWardayRed, nullvec, nullvec);
			case 3:TeleportEntity(this.index, flWardayBlu, nullvec, nullvec);
		}
	}
	/**
	 *	List the last request menu to the player.
	 *
	 *	@noreturn
	*/
	public void ListLRS()
	{
		if (IsVoteInProgress())
			return;

		Menu menu = new Menu(ListLRsMenu);
		menu.SetTitle("Select a Last Request");
		//menu.AddItem("-1", "Random LR");	// Moved to handler
		AddLRToMenu(menu);
		menu.ExitButton = true;
		menu.Display(this.index, 30);
	}
	/**
	 *	Give a player the warden menu.
	 *
	 *	@noreturn
	*/
	public void WardenMenu()
	{
		if (IsVoteInProgress())
			return;

		Menu wmenu = new Menu(WardenMenuHandler);
		wmenu.SetTitle("Warden Commands");
		ManageWardenMenu(wmenu);
		wmenu.ExitButton = true;
		wmenu.Display(this.index, MENU_TIME_FOREVER);
	}
	/**
	 *	Allow a player to climb walls upon hitting them.
	 *
	 *	@param weapon 		Weapon the client is using to attack.
	 *	@param upwardvel	Velocity to send the client (in hammer units).
	 *	@param health 		Health to take from the client.
	 *	@param attackdelay 	Length in seconds to delay the player in attacking again.
	 *
	 *	@noreturn
	*/
	public void ClimbWall( const int weapon, const float upwardvel, const float health, const bool attackdelay )
	//Credit to Mecha the Slag
	{
		if (GetClientHealth(this.index) <= health) 	// Have to baby players so they don't accidentally kill themselves trying to escape
			return;

		int client = this.index;
		char classname[64];
		float vecClientEyePos[3];
		float vecClientEyeAng[3];
		GetClientEyePosition(client, vecClientEyePos);   // Get the position of the player's eyes
		GetClientEyeAngles(client, vecClientEyeAng);	   // Get the angle the player is looking

		// Check for colliding entities
		TR_TraceRayFilter(vecClientEyePos, vecClientEyeAng, MASK_PLAYERSOLID, RayType_Infinite, TraceRayDontHitSelf, client);

		if (!TR_DidHit(null))
			return;

		int TRIndex = TR_GetEntityIndex(null);
		GetEdictClassname(TRIndex, classname, sizeof(classname));
		if (!StrEqual(classname, "worldspawn"))
			return;

		float fNormal[3];
		TR_GetPlaneNormal(null, fNormal);
		GetVectorAngles(fNormal, fNormal);

		if (fNormal[0] >= 30.0 && fNormal[0] <= 330.0)
			return;
		if (fNormal[0] <= -30.0)
			return;

		float pos[3]; TR_GetEndPosition(pos);
		float distance = GetVectorDistance(vecClientEyePos, pos);

		if (distance >= 100.0)
			return;

		float fVelocity[3];
		GetEntPropVector(client, Prop_Data, "m_vecVelocity", fVelocity);
		fVelocity[2] = upwardvel;

		TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, fVelocity);
		SDKHooks_TakeDamage(client, client, client, health, DMG_CLUB, GetPlayerWeaponSlot(client, TFWeaponSlot_Melee));

		if (attackdelay)
			SetPawnTimer(NoAttacking, 0.1, EntIndexToEntRef(weapon));
	}

	/***** [STRINGMAP METHODS] *****/

	/**
	 *	Set a value into this player's StringMap.
	 *
	 *	@param key 			Key string.
	 *	@param i 			Value to store at the key.
	 *	@param replace 		If false, operation will fail if the key is already set.
	 *
	 *	@return 			True on success, false on failure.
	*/
	public bool SetValue( const char[] key, const any i, bool replace = true )
	{
		return hJailFields[this.index].SetValue(key, i, replace);
	}

	/**
	 *	Set an array into this player's StringMap
	 *
	 *	@param key			Key string.
	 *	@param i			Array to store.
	 *	@param num_items	Number of items in the array.
	 *	@param replace		If false, operation will fail if the key is already set.
	 *
	 *	@return				True on success, false on failure.
	*/
	public bool SetArray( const char[] key, const any[] i, int num_items, bool replace = true )
	{
		return hJailFields[this.index].SetArray(key, i, num_items, replace);
	}

	/**
	 *	Sets a string value in this player's StringMap, either inserting a new entry or replacing an old one.
	 *
	 *	@param key			Key string.
	 *	@param i			String to store.
	 *	@param replace		If false, operation will fail if the key is already set.
	 *
	 *	@return				True on success, false on failure.
	*/
	public bool SetString( const char[] key, const char[] i, bool replace = true )
	{
		return hJailFields[this.index].SetString(key, i, replace);
	}

	/**
	 *	Get a value from this player's StringMap.
	 *
	 *	@param key 			Key string.
	 *	@param i			Variable to store value.
	 *
	 *	@return 			Value stored in the key.
	*/
	public bool GetValue( const char[] key, any &i )
	{
		return hJailFields[this.index].GetValue(key, i);
	}

	/**
	 *	Retrieves an array in this player's StringMap.
	 *
	 *	@param key			Key string.
	 *	@param i			Buffer to store array.
	 *	@param max_size		Maximum size of array buffer.
	 *	@param size			Optional parameter to store the number of elements written to the buffer.
	 *
	 *	@return				True on success.  False if the key is not set, or the key is set 
	 *						as a value or string (not an array).
	*/
	public bool GetArray( const char[] key, any[] i, int max_size, int &size = 0 )
	{
		return hJailFields[this.index].GetArray(key, i, max_size, size);
	}

	/**
	 *	Retrieves a string in this player's StringMap.
	 *
	 *	@param key			Key string.
	 *	@param i			Buffer to store value.
	 *	@param max_size		Maximum size of string buffer.
	 *	@param size			Optional parameter to store the number of bytes written to the buffer.
	 *
	 *	@return				True on success.  False if the key is not set, or the key is set 
	 *						as a value or array (not a string).
	*/
	public bool GetString( const char[] key, char[] i, int max_size, int &size = 0 )
	{
		return hJailFields[this.index].GetString(key, i, max_size, size);
	}

	/**
	 *	Removes a key entry from this player's StringMap.
	 *
	 *	@param key			Key string.
	 *
	 *	@return				True on success, false if the value was never set.
	*/
	public bool Remove( const char[] key )
	{
		return hJailFields[this.index].Remove(key);
	}

	/**
	 *	Clears all entries from this player's StringMap.
	 *
	 *	@noreturn
	*/
	public void Clear()
	{
		hJailFields[this.index].Clear();
	}

	/**
	 *	Create a snapshot of this player's StringMap's keys. See StringMapSnapshot.
	 *
	 *	@return 			Handle to key Snapshot.
	*/
	public StringMapSnapshot Snapshot()
	{
		return hJailFields[this.index].Snapshot();
	}

	/**
	 *	Retrieves the number of elements in this player's StringMap.
	*/
	property int Size
	{
		public get() 				{ return hJailFields[this.index].Size; }
	}
};
