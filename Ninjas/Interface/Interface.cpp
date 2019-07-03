#include "stdafx.h"
#include "Interface.h"
#include "Interpreter.h"

HWND hWnd;
HINSTANCE hInst;
//Character test(100, 100, RGB(0, 0, 255));
Character *players;
//Interpreter interpreter;
//vector<Projectile> projs;
RECT updateRect;
int mapWidth, mapHeight;

LRESULT CALLBACK	WndProc(HWND, UINT, WPARAM, LPARAM);

int APIENTRY _tWinMain(HINSTANCE hInstance,
	HINSTANCE hPrevInstance,
	LPTSTR    lpCmdLine,
	int       nCmdShow)
{
	UNREFERENCED_PARAMETER(hPrevInstance);
	UNREFERENCED_PARAMETER(lpCmdLine);

	MSG msg;
	WNDCLASSEX wcex;

	hInst = hInstance;

	wcex.cbSize = sizeof(WNDCLASSEX);
	wcex.style = 0;
	wcex.lpfnWndProc = WndProc;
	wcex.cbClsExtra = 0;
	wcex.cbWndExtra = 0;
	wcex.hInstance = hInstance;
	wcex.hIcon = LoadIcon(hInst, MAKEINTRESOURCE(IDI_SMALL));
	wcex.hCursor = LoadCursor(NULL, IDC_ARROW);
	wcex.hbrBackground = (HBRUSH)(COLOR_WINDOW + 1);
	wcex.lpszMenuName = NULL;
	wcex.lpszClassName = L"MainClass";
	wcex.hIconSm = LoadIcon(hInst, MAKEINTRESOURCE(IDI_SMALL));

	RegisterClassEx(&wcex);

	hWnd = CreateWindow(L"MainClass",
		L"Ninjas",
		WS_OVERLAPPEDWINDOW,
		0, 0,
		GetSystemMetrics(SM_CXSCREEN), GetSystemMetrics(SM_CYSCREEN),
		NULL,
		NULL,
		hInstance,
		NULL);

	if (hWnd == 0)
	{
		MessageBox(NULL, L"Ошибка главного окна!", NULL, MB_OK);
		return 1;
	}

	ShowWindow(hWnd, nCmdShow);
	UpdateWindow(hWnd);

	while (GetMessage(&msg, NULL, 0, 0))
	{
		TranslateMessage(&msg);
		DispatchMessage(&msg);
	}

	return (int)msg.wParam;
}

void CALLBACK OnSwing(HWND hWnd, UINT arg1, UINT arg2, DWORD dw)
{
	int ind = arg2 - SWING_TIMER;
	if (!players[ind].isActive)
		KillTimer(hWnd, arg2);
	players[ind].swordShift -= M_PI_2 / 10;
	Point swordEnd = players[ind].GetSwordEnd();
	for (int i = 0; i < PLAYER_COUNT; ++i)
	{
		if (i == ind || !players[ind].isActive)
			continue;
		if (players[i].position.Dist(swordEnd) < Character::R)
		{
			players[i].TakeDamage(100);
			if (!players[i].isActive)
				players[i].Invalidate(hWnd);
			break;
		}
	}
	if (players[ind].swordShift < -M_PI_4)
	{
		players[ind].swordShift = M_PI_4;
		players[ind].isSwinging = false;
		KillTimer(hWnd, arg2);
	}
}

LRESULT CALLBACK WndProc(HWND hWnd,
	UINT message,
	WPARAM wParam,
	LPARAM lParam)
{
	PAINTSTRUCT ps;
	HDC hdc;

	switch (message)
	{
	case WM_CREATE:
	{
		players = new Character[PLAYER_COUNT]{
			Character(100, 100, RGB(255, 0, 0)),
			Character(600, 100, RGB(0, 0, 255)),
			Character(100, 600, RGB(0, 255, 0)),
			Character(600, 600, RGB(255, 255, 0))
		};
		SetTimer(hWnd, COMMAND_TIMER, 50, NULL);
		RECT client;
		GetClientRect(hWnd, &client);
		mapWidth = client.right;
		mapHeight = client.bottom;
		break;
	}

	case WM_TIMER:
		switch (wParam)
		{
		case COMMAND_TIMER:
		{
			for (int i = 0; i < PLAYER_COUNT; ++i)
			{
				if (!players[i].isActive)
					continue;
				Command next = players[i].interpreter.NextCommand();
				switch (next.type)
				{
				case Command::Move:
				{
					double res = next.param;
					for (int j = 0; j < PLAYER_COUNT; ++j)
					{
						if (i == j)
							continue;
						double maxMove = players[i].MaxMovement(players[j].position, res);
						res = min(maxMove, res);
					}
					players[i].Move(res);
					break;
				}

				case Command::Turn:
					players[i].Turn(next.param);
					break;

				case Command::Swing:
					players[i].isSwinging = true;
					SetTimer(hWnd, SWING_TIMER + i, 10, (TIMERPROC)OnSwing);
					break;

				case Command::Shoot:
					players[i].shots.push_back(Projectile(players[i].position.x, players[i].position.y,
														players[i].direction, players[i].color));
					break;
				}
				players[i].Invalidate(hWnd);
				for (int j = 0; j < players[i].shots.size(); ++j)
				{
					Projectile &shot = players[i].shots[j];
					if (!shot.isActive)
						continue;
					shot.Invalidate(hWnd);
					shot.Move();
					for (int k = 0; k < PLAYER_COUNT; ++k)
					{
						if (k == i || !players[k].isActive)
							continue;
						if (players[k].position.Dist(shot.position) < Character::R)
						{
							players[k].TakeDamage(10);
							if (!players[k].isActive)
								players[k].Invalidate(hWnd);
							shot.isActive = false;
							break;
						}
					}
					shot.Invalidate(hWnd);
				}
			}
			break;
		}
		}
		UpdateWindow(hWnd);
		break;

	case WM_PAINT:
	{
		hdc = BeginPaint(hWnd, &ps);
		for (int i = 0; i < PLAYER_COUNT; ++i)
		{
			if (players[i].isActive)
				players[i].Draw(hdc);
			for (int j = 0; j < players[i].shots.size(); ++j)
				players[i].shots[j].Draw(hdc);
		}
		EndPaint(hWnd, &ps);
		break;
	}

	case WM_KEYDOWN:
	{
		Command com;
		switch (wParam)
		{
		case 0x41:
			com.type = Command::Turn;
			com.param = -0.1;
			players[0].interpreter.AddCommand(com);
			break;

		case 0x44:
			com.type = Command::Turn;
			com.param = 0.1;
			players[0].interpreter.AddCommand(com);
			break;

		case 0x57:
			com.type = Command::Move;
			com.param = 5;
			players[0].interpreter.AddCommand(com);
			break;

		case 0x52:
			if (!players[0].isSwinging)
			{
				com.type = Command::Swing;
				players[0].interpreter.AddCommand(com);
			}
			break;

		case 0x46:
			com.type = Command::Shoot;
			players[0].interpreter.AddCommand(com);
			break;

		case 0x4a:
			com.type = Command::Turn;
			com.param = -0.1;
			players[1].interpreter.AddCommand(com);
			break;

		case 0x4c:
			com.type = Command::Turn;
			com.param = 0.1;
			players[1].interpreter.AddCommand(com);
			break;

		case 0x49:
			com.type = Command::Move;
			com.param = 5;
			players[1].interpreter.AddCommand(com);
			break;

		case 0x55:
			if (!players[1].isSwinging)
			{
				com.type = Command::Swing;
				players[1].interpreter.AddCommand(com);
			}
			break;

		case 0x48:
			com.type = Command::Shoot;
			players[1].interpreter.AddCommand(com);
			break;
		}
		
		break;
	}

	case WM_DESTROY:
		KillTimer(hWnd, COMMAND_TIMER);
		KillTimer(hWnd, SWING_TIMER);
		PostQuitMessage(0);
		break;

	default:
		return DefWindowProc(hWnd, message, wParam, lParam);
	}
	return 0;
}
