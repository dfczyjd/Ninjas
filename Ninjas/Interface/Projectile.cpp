#include "stdafx.h"
#include "Projectile.h"
#include "Interface.h"

Projectile::Projectile(double x, double y, double dir, COLORREF color) : direction(dir)
{
	position = Point(x, y);
	mainBrush = CreateSolidBrush(color);
	mainPen = CreatePen(PS_SOLID, 1, color);
	isActive = true;
}

Projectile::~Projectile()
{

}

void Projectile::Draw(HDC hdc)
{
	if (!isActive)
		return;
	mainBrush = SelectBrush(hdc, mainBrush);
	mainPen = SelectPen(hdc, mainPen);
	Rectangle(hdc, position.x, position.y, position.x + 2, position.y + 2);
	mainBrush = SelectBrush(hdc, mainBrush);
	mainPen = SelectPen(hdc, mainPen);
}

void Projectile::Move()
{
	if (!isActive)
		return;
	position = position + Point(direction) * SPEED;
	if (position.x < 0)
		isActive = false;
	if (position.x > mapWidth)
		isActive = false;
	if (position.y < 0)
		isActive = false;
	if (position.y > mapHeight)
		isActive = false;
}

void Projectile::Invalidate(HWND hWnd)
{
	RECT updateRect;
	updateRect.left = position.x;
	updateRect.top = position.y;
	updateRect.right = position.x + 2;
	updateRect.bottom = position.y + 2;
	InvalidateRect(hWnd, &updateRect, true);
}