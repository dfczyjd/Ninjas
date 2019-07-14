#include "stdafx.h"
#include "Interface.h"
#include "Interpreter.h"
#include "Character.h"
#include <fstream>

Character::Character(WCHAR *name, int id, double x, double y, COLORREF color, double dir) : color(color), name(name)
{
	direction = dir;
	health = 100;
	swordShift = M_PI_4;
	isSwinging = false;
	isActive = false;
	hasProgram = false;
	
	interpreter = Interpreter(id);
	position = Point(x, y);
	mainBrush = CreateSolidBrush(color);
	mainPen = CreatePen(PS_SOLID, 1, color);
	blackBrush = CreateSolidBrush(RGB(0, 0, 0));
	blackPen = CreatePen(PS_SOLID, 1, RGB(0, 0, 0));
}

Character::~Character()
{
	DeleteBrush(mainBrush);
	DeleteBrush(blackBrush);
	DeletePen(mainPen);
	DeletePen(blackPen);
}

Character Character::operator=(const Character & other)
{
	position = other.position;
	direction = other.direction;
	mainBrush = other.mainBrush;
	mainPen = other.mainPen;
	blackBrush = other.blackBrush;
	blackPen = other.blackPen;
	isSwinging = other.isSwinging;
	return other;
}

void Character::Draw(HDC hdc)
{
	mainBrush = SelectBrush(hdc, mainBrush);
	mainPen = SelectPen(hdc, mainPen);
	Ellipse(hdc, position.x - R, position.y - R, position.x + R, position.y + R);
	MoveToEx(hdc, position.x + SWORD * cos(direction + swordShift),
				position.y + SWORD * sin(direction + swordShift), NULL);
	LineTo(hdc, position.x, position.y);
	mainBrush = SelectBrush(hdc, mainBrush);
	mainPen = SelectPen(hdc, mainPen);
	blackBrush = SelectBrush(hdc, blackBrush);
	blackPen = SelectPen(hdc, blackPen);
	Rectangle(hdc, position.x + R / 2 * cos(direction - M_PI / 6),
					position.y + R / 2 * sin(direction - M_PI / 6),
					position.x + R / 2 * cos(direction - M_PI / 6) + 2,
					position.y + R / 2 * sin(direction - M_PI / 6) + 2);
	Rectangle(hdc, position.x + R / 2 * cos(direction + M_PI / 6),
					position.y + R / 2 * sin(direction + M_PI / 6),
					position.x + R / 2 * cos(direction + M_PI / 6) + 2,
					position.y + R / 2 * sin(direction + M_PI / 6) + 2);
	blackBrush = SelectBrush(hdc, blackBrush);
	blackPen = SelectPen(hdc, blackPen);
}

void Character::Turn(double angle)
{
	direction += angle;
}

void Character::Move(double distance)
{
	position = position + Point(direction) * distance;
	if (position.x < R)
		position.x = R;
	if (position.x > mapWidth - R)
		position.x = mapWidth - R;
	if (position.y < R)
		position.y = R;
	if (position.y > mapHeight - R)
		position.y = mapHeight - R;
}

void Character::TakeDamage(int damage)
{
	if (isActive)
		health -= damage;
	if (health <= 0)
	{
		isActive = false;
		WCHAR text[1024];
		wsprintf(text, L"%s был убит", name);
		PrintMessage(text);
		int k = 0;
		int id = 0;
		for (int i = 0; i < PLAYER_COUNT; ++i){
			if(players[i].health > 0){
        		k++;
        		id = i;
        	}	
        }
        if(k == 1){
        	wsprintf(text, L"В живых остался лишь %s! Бой завершён", players[id].name);
        	PrintMessage(text);
        }
	}
}

Point Character::GetSwordEnd()
{
	return position + Point(direction + swordShift) * SWORD;
}

double Character::MaxMovement(const Point &other, double maxDist)
{
	double dist = position.Dist(other);
	double norm = dist * sin(direction - atan2(other.y - position.y, other.x - position.x));
	if (norm > 2 * R)
		return maxDist;
	double sub = max(sqrt(4 * R * R - norm * norm), 0);
	double mxMove = sqrt(dist * dist - norm * norm) - sub;
	if ((position + Point(direction) * (mxMove + 1e-5)).Dist(other) < 2 * R)
		return min(maxDist, mxMove);
	return maxDist;
}

void Character::Invalidate(HWND hWnd)
{
	RECT updateRect;
	updateRect.left = position.x - 2 * SWORD;
	updateRect.top = position.y - 2 * SWORD;
	updateRect.right = position.x + 2 * SWORD;
	updateRect.bottom = position.y + 2 * SWORD;
	InvalidateRect(hWnd, &updateRect, true);
}
