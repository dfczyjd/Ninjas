#include "stdafx.h"
#include "Interface.h"
#include "Character.h"
#include "Projectile.h"
#include "Interpreter.h"

HWND hWnd;
HINSTANCE hInst;
Character test(100, 100, RGB(0, 0, 255));
Interpreter interpreter;
vector<Projectile> projs;
RECT updateRect;

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
		SetTimer(hWnd, COMMAND_TIMER, 32, NULL);
		break;
	}

	case WM_TIMER:
		switch (wParam)
		{
		case COMMAND_TIMER:
		{
			Command next = interpreter.NextCommand();
			switch (next.type)
			{
			case Command::Move:
				test.Move(next.param);
				break;

			case Command::Turn:
				test.Turn(next.param);
				break;

			case Command::Swing:
				test.isSwinging = true;
				SetTimer(hWnd, SWING_TIMER, 10, NULL);
				break;

			case Command::Shoot:
				projs.push_back(Projectile(test.position.first, test.position.second, test.direction, RGB(0, 0, 255)));
				break;
			}
			test.Invalidate(hWnd);
			for (int i = 0; i < projs.size(); ++i)
			{
				projs[i].Invalidate(hWnd);
				projs[i].Move();
				projs[i].Invalidate(hWnd);
			}
			break;
		}

		case SWING_TIMER:
			test.swordShift -= M_PI_2 / 10;
			if (test.swordShift < -M_PI_4)
			{
				test.swordShift = M_PI_4;
				test.isSwinging = false;
				KillTimer(hWnd, SWING_TIMER);
			}
			break;
		}
		UpdateWindow(hWnd);
		break;

	case WM_PAINT:
	{
		hdc = BeginPaint(hWnd, &ps);
		test.Draw(hdc);
		for (auto elem : projs)
			elem.Draw(hdc);
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
			break;

		case 0x44:
			com.type = Command::Turn;
			com.param = 0.1;
			break;

		case 0x57:
			com.type = Command::Move;
			com.param = 5;
			break;
		}
		interpreter.AddCommand(com);
		break;
	}

	case WM_LBUTTONDOWN:
		if (!test.isSwinging)
		{
			Command com;
			com.type = Command::Swing;
			interpreter.AddCommand(com);
		}
		break;

	case WM_RBUTTONDOWN:
	{
		Command com;
		com.type = Command::Shoot;
		interpreter.AddCommand(com);
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
