#pragma once
#define _USE_MATH_DEFINES
#include <cmath>
#include <utility>

using namespace std;

struct Character
{
	const int R = 10, SWORD = 25;

	pair<double, double> position;
	double direction, swordShift;
	HBRUSH mainBrush, blackBrush;
	HPEN mainPen, blackPen;
	bool isSwinging;

	Character(double x, double y, COLORREF color);

	void Draw(HDC hdc);

	void Turn(double angle);
	void Move(double distance);
	void Invalidate(HWND hWnd);
};