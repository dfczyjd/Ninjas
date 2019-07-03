#include "stdafx.h"
#include "Character.h"

Character::Character(double x, double y, COLORREF color) : direction(0), isSwinging(false), swordShift(M_PI_4)
{
	position = make_pair(x, y);
	mainBrush = CreateSolidBrush(color);
	mainPen = CreatePen(0, 1, color);
	blackBrush = CreateSolidBrush(RGB(0, 0, 0));
	blackPen = CreatePen(0, 1, RGB(0, 0, 0));
}

void Character::Draw(HDC hdc)
{
	mainBrush = SelectBrush(hdc, mainBrush);
	mainPen = SelectPen(hdc, mainPen);
	Ellipse(hdc, position.first - R, position.second - R, position.first + R, position.second + R);
	MoveToEx(hdc, position.first + SWORD * cos(direction + swordShift),
				position.second + SWORD * sin(direction + swordShift), NULL);
	LineTo(hdc, position.first, position.second);
	mainBrush = SelectBrush(hdc, mainBrush);
	mainPen = SelectPen(hdc, mainPen);
	blackBrush = SelectBrush(hdc, blackBrush);
	blackPen = SelectPen(hdc, blackPen);
	Rectangle(hdc, position.first + R / 2 * cos(direction - M_PI / 6),
					position.second + R / 2 * sin(direction - M_PI / 6),
					position.first + R / 2 * cos(direction - M_PI / 6) + 2,
					position.second + R / 2 * sin(direction - M_PI / 6) + 2);
	Rectangle(hdc, position.first + R / 2 * cos(direction + M_PI / 6),
					position.second + R / 2 * sin(direction + M_PI / 6),
					position.first + R / 2 * cos(direction + M_PI / 6) + 2,
					position.second + R / 2 * sin(direction + M_PI / 6) + 2);
	blackBrush = SelectBrush(hdc, blackBrush);
	blackPen = SelectPen(hdc, blackPen);
}

void Character::Turn(double angle)
{
	direction += angle;
}

void Character::Move(double distance)
{
	position.first += distance * cos(direction);
	position.second += distance * sin(direction);
}

void Character::Invalidate(HWND hWnd)
{
	RECT updateRect;
	updateRect.left = position.first - 2 * SWORD;
	updateRect.top = position.second - 2 * SWORD;
	updateRect.right = position.first + 2 * SWORD;
	updateRect.bottom = position.second + 2 * SWORD;
	InvalidateRect(hWnd, &updateRect, true);
}