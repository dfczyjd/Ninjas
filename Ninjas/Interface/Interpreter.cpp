#include "stdafx.h"
#include "Interpreter.h"
#include <queue>

HMODULE hLib;
FuncVoid_Int Run;
FuncStr_Int Next;
FuncVoid_IntStr Init;

Interpreter::Interpreter(int id): id(id)
{
	if (hLib == 0)
	{
		hLib = LoadLibrary(L"Interpreter.dll");
		Init = (FuncVoid_IntStr)GetProcAddress(hLib, "Init");
		Run = (FuncVoid_Int)GetProcAddress(hLib, "Run");
		Next = (FuncStr_Int)GetProcAddress(hLib, "GetCommand");
	}
}

Interpreter::~Interpreter()
{
	
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
	Init(id, codepath2);
	delete codepath2;
	Run(id);
}
