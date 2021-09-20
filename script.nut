/* SERVER SETTINGS */

const SERVER_NAME = "Vice City - Team Deathmatch";
const SERVER_GAMEMODE = "Team Deathmatch";
const SERVER_MAX_PLAYERS = 50;

/* COLOUR CODES */

local COLOUR_BLUE = RGB ( 0 , 0 , 255 );
local COLOUR_RED = RGB ( 255 , 0 , 0 );

/* SERVER DATA */

local TEAM_BLUE_SCORE = 0;
local TEAM_RED_SCORE = 0;

/* SERVER EVENTS */

function onScriptLoad()
{
	SetServerName ( SERVER_NAME );
	SetGameModeName ( SERVER_GAMEMODE );
	SetMaxPlayers ( SERVER_MAX_PLAYERS );
	SetSpawnPlayerPos ( Vector(-378.79, -535.107, 17.2824) );
	SetSpawnCameraPos ( Vector(-378.827, -528.443, 18.0154) );
	SetSpawnCameraLook ( Vector(-378.79, -535.107, 17.2824) );
	SetTimeRate( 1000 );

	/* TEAM RED */

	AddClass(1, COLOUR_RED, 11, Vector(-565.597, -563.318, 10.5938), 0, 17, 999, 21, 999, 26, 999 );
	AddClass(1, COLOUR_RED, 36, Vector(-565.597, -563.318, 10.5938), 0, 17, 999, 21, 999, 26, 999 );
	AddClass(1, COLOUR_RED, 47, Vector(-565.597, -563.318, 10.5938), 0, 17, 999, 21, 999, 26, 999 );

	/* TEAM BLUE */

	AddClass(2, COLOUR_BLUE, 5, Vector(-523.479, -303.716, 10.801), 0, 17, 999, 21, 999, 26, 999 );
	AddClass(2, COLOUR_BLUE, 13, Vector(-523.479, -303.716, 10.801), 0, 17, 999, 21, 999, 26, 999 );
	AddClass(2, COLOUR_BLUE, 29, Vector(-523.479, -303.716, 10.801), 0, 17, 999, 21, 999, 26, 999 );
}

function onPlayerJoin( player )
{
	for ( local i = 0; i <= 100; i++ )
		MessagePlayer("",player);

	MessagePlayer("[#ff8000]Welcome to Vice City - Team Deathmatch",player);
	MessagePlayer("[#ff8000]Choose your team and start playing now.",player);
	MessagePlayer("[#ff8000]Type [#ff3000]!score[#ff8000] to view teams score.",player);
}

function onPlayerKill( killer, player, reason, bodypart )
{
	killer.Score++;

	if ( killer.Team == 1 )
	{
		TEAM_RED_SCORE++;
	}
	else
	{
	    TEAM_BLUE_SCORE++;
	}
}

function onPlayerTeamKill( killer, player, reason, bodypart )
{
	killer.Score--;

	MessagePlayer ( "[#ffff00]Hey! Don't kill your team-mates." , killer );
}

function onPlayerRequestClass( player, classID, team, skin )
{
	player.Angle = 0.00546503;
	player.SetAnim ( 19 , 207 );

	if ( team == 1 )
	{
		Announce ( "~o~Team: RED" , player , 7 );
	}
	else 
		Announce ( "~b~Team: BLUE" , player , 7 );
}

function onPlayerChat(player, text)
{
	if ( text == "!score" || text == "!stats" )
	{
		MessagePlayer("[#ffffff]BLUE "+TEAM_BLUE_SCORE+":"+TEAM_RED_SCORE+" RED",player);
	}

	if ( !player.Spawned ) return MessagePlayer("[#ff8000]You must be spawned in order to talk.",player);

	return true;
}

function onPlayerRequestSpawn( player )
{
	local TEAM_BLUE_PLAYERS = 0;
	local TEAM_RED_PLAYERS = 0;
	
	for ( local i = 0; i <= SERVER_MAX_PLAYERS; i++ )
	{
		local plr = FindPlayer(i);
		if ( plr )
		{
			if ( plr.ID != player.ID )
			{
				if ( plr.Team == 1 ) TEAM_RED_PLAYERS++;
				else if ( plr.Team == 2 ) TEAM_BLUE_PLAYERS++;
			}
		}
	}

	if ( TEAM_BLUE_PLAYERS == TEAM_RED_PLAYERS ) { return 1; }

	if ( player.Team == 1 && TEAM_RED_PLAYERS > TEAM_BLUE_PLAYERS )
	{
		return MessagePlayer("[#ff8000]The red team is full, please join the blue team.",player);
	}

	if ( player.Team == 2 && TEAM_RED_PLAYERS < TEAM_BLUE_PLAYERS )
	{
		return MessagePlayer("[#ff8000]The blue team is full, please join the red team.",player);
	}

	return 1;
}