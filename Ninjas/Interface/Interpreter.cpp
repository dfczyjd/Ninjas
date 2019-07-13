#include "stdafx.h"
#include "Interpreter.h"
#include "Interface.h"
#include <queue>

HMODULE hLib;
FuncVoid_Int Run;
FuncStr_Int Next;
FuncVoid_IntStr Init, Update, SetName;
FuncStr_Void GetMess;

Interpreter::Interpreter(int id): id(id)
{
	if (hLib == 0)
	{
		hLib = LoadLibrary(L"Interpreter.dll");
		Init = (FuncVoid_IntStr)GetProcAddress(hLib, "Init");
		Run = (FuncVoid_Int)GetProcAddress(hLib, "Run");
		Next = (FuncStr_Int)GetProcAddress(hLib, "GetCommand");
		Update = (FuncVoid_IntStr)GetProcAddress(hLib, "UpdateInfo");
		SetName = (FuncVoid_IntStr)GetProcAddress(hLib, "SetName");
		GetMess = (FuncStr_Void)GetProcAddress(hLib, "GetLastMessage");
	}
}

Interpreter::~Interpreter()
{
	
}

void Serialize(char **res)
{
	*res = new char[1024];
	sprintf(*res, "%d %lf %lf %lf %d %lf %lf %lf %d %lf %lf %lf %d %lf %lf %lf",
		players[0].health, players[0].position.x, players[0].position.y, players[0].direction,
		players[1].health, players[1].position.x, players[1].position.y, players[1].direction, 
		players[2].health, players[2].position.x, players[2].position.y, players[2].direction, 
		players[3].health, players[3].position.x, players[3].position.y, players[3].direction);
}

Command Deserialize(char *s)
{
	Command res;
	for (int i = 0; s[i] != '\0'; ++i)
	{
		if (s[i] == ',')
		{
			s[i] = '.';
			break;
		}
	}
	sscanf_s(s, "%d %lf", &res.type, &res.param);
	return res;
}

Command Interpreter::NextCommand()
{
	char *nxtStr = Next(id);
	Command nxt = Deserialize(nxtStr);
	if (nxt.type == 1)
	{
		if (nxt.param > 10)
			nxt.param = 10;
		else if (nxt.param < -5)
			nxt.param = -5;
	}
	else if (nxt.type == 2)
	{
		if (nxt.param > 1.58)
			nxt.param = 1.58;
		else if (nxt.param < -1.58)
			nxt.param = -1.58;
	}
	return nxt;
}

void Interpreter::SetCode(WCHAR *codepath)
{
	int length = wcslen(codepath);
	char *codepath2 = new char[length + 1];
	for (int i = 0; i <= length; ++i)
		codepath2[i] = (char)codepath[i];
	Init(id,  codepath2);
	delete codepath2;
}

void Interpreter::SendUpdate()
{
	char *s;
	Serialize(&s);
	Update(0, s);
}

void Interpreter::RunMeth(int id)
{
	Run(id);
}

void Interpreter::SetNames()
{
	char name1[] = "Red",
		name2[] = "Blue",
		name3[] = "Green",
		name4[] = "Yellow";
	SetName(0, name1);
	SetName(1, name2);
	SetName(2, name3);
	SetName(3, name4);
}

void Interpreter::UpdateMessages()
{
	while (true)
	{
		char *mess = GetMess();
		int length = strlen(mess);
		if (length == 0)
			break;
		WCHAR res[1024];
		for (int i = 0; i <= length; ++i)
			res[i] = mess[i];
		PrintMessage(res, false);
	}
}
