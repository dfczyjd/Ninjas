#include "stdafx.h"
#include "Projectile.h"

Projectile::Projectile(double x, double y, double dir, COLORREF color) : direction(dir)
{
	position = make_pair(x, y);
	mainBrush = CreateSolidBrush(color);
	mainPen = CreatePen(0, 1, color);
}

void Projectile::Draw(HDC hdc)
{
	mainBrush = SelectBrush(hdc, mainBrush);
	mainPen = SelectPen(hdc, mainPen);
	Rectangle(hdc, position.first, position.second, position.first + 2, position.second + 2);
	mainBrush = SelectBrush(hdc, mainBrush);
	mainPen = SelectPen(hdc, mainPen);
}

void Projectile::Move()
{
	position.first += SPEED * cos(direction);
	position.second += SPEED * sin(direction);
}

void Projectile::Invalidate(HWND hWnd)
{
	RECT updateRect;
	updateRect.left = position.first;
	updateRect.top = position.second;
	updateRect.right = position.first + 2;
	updateRect.bottom = position.second + 2;
	InvalidateRect(hWnd, &updateRect, true);
}