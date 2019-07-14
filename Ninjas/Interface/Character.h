#pragma once
#define _USE_MATH_DEFINES
#include <cmath>
#include <utility>
#include <vector>
#include "Interpreter.h"
#include "Point.h"



using namespace std;

struct Character
{
	static const int R = 10, SWORD = 25;

	Point position;
	double direction, swordShift;
	HBRUSH mainBrush, blackBrush;
	HPEN mainPen, blackPen;
	COLORREF color;
	bool isSwinging, isActive, hasProgram;
	Interpreter interpreter;
	int health;
	vector<Projectile> shots;
	WCHAR *name;

	Character(WCHAR *name, int id = 0, double x = 0, double y = 0, COLORREF color = RGB(0, 0, 0), double dir = 0);
	~Character();

	Character operator=(const Character &other);

	void Draw(HDC hdc);
	void Invalidate(HWND hWnd);

	void Turn(double angle);
	void Move(double distance);
	void TakeDamage(int damage, int byId);
	Point GetSwordEnd();
	double MaxMovement(const Point &other, double maxDist);
};