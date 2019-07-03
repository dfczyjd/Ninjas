#pragma once
#include <queue>

struct Command
{
	enum Type
	{
		Idle, Move, Turn, Swing, Shoot
	} type = Idle;

	double param = 0;
};

struct Interpreter
{
	std::queue<Command> commands;

	Command NextCommand();

	Interpreter();

	void AddCommand(Command command);
};

