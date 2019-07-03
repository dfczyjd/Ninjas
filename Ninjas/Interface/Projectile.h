#pragma once
#include <utility>

using namespace std;

struct Projectile
{
	const int SPEED = 5;

	pair<double, double> position;
	double direction;
	HBRUSH mainBrush;
	HPEN mainPen;

	Projectile(double x, double y, double dir, COLORREF color);

	void Draw(HDC hdc);
	void Move();
	void Invalidate(HWND hWnd);
};