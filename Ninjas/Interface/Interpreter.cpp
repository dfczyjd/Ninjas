#include "stdafx.h"
#include "Interpreter.h"
#include <queue>

Interpreter::Interpreter()
{

}

Command Interpreter::NextCommand()
{
	if (commands.empty())
		return Command();
	Command res = commands.front();
	commands.pop();
	return res;
}

void Interpreter::AddCommand(Command command)
{
	commands.push(command);
}
