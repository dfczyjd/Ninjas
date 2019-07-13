#pragma once
#define DLL_API __declspec(dllimport)
#include <queue>
#define _USE_MATH_DEFINES
#include <cmath>

struct Command
{
	enum Type
	{
		Idle, Move, Turn, Swing, Shoot
	};
	int type = 0;
	double param = 0;
};

typedef void(__cdecl *FuncVoid_Int)(int id);
typedef void(__cdecl *FuncVoid_IntStr)(int id, char *name);
typedef int(__cdecl *FuncInt_Int)(int id);
typedef char*(__cdecl *FuncStr_Int)(int id);
typedef char*(__cdecl *FuncStr_Void)();

struct Interpreter
{
	std::queue<Command> commands;
	int id;

	Command NextCommand();

	Interpreter(int id = -1);
	~Interpreter();

	void SetCode(WCHAR *codepath);
	void SendUpdate();
	void RunMeth(int id);
	void SetNames();
	void UpdateMessages();
};

