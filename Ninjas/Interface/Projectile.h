#pragma once
#include <utility>
#include "Point.h"

using namespace std;

struct Projectile
{
	const int SPEED = 7;

	Point position;
	double direction;
	HBRUSH mainBrush;
	HPEN mainPen;
	COLORREF color;
	bool isActive;

	Projectile(double x, double y, double dir, COLORREF color);
	~Projectile();

	void Draw(HDC hdc);
	void Move();
	void Invalidate(HWND hWnd);
};