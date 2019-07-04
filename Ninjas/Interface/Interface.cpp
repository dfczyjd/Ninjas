#include "stdafx.h"
#include "resource.h"
#include "Interface.h"
#include "Interpreter.h"
#include <Shobjidl.h>
#include <Shlwapi.h>

HWND mainWnd;
HINSTANCE hInst;
Character *players;
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
	wcex.hIcon = LoadIcon(hInst, MAKEINTRESOURCE(IDI_INTERFACE));
	wcex.hCursor = LoadCursor(NULL, IDC_ARROW);
	wcex.hbrBackground = (HBRUSH)(COLOR_WINDOW + 1);
	wcex.lpszMenuName = NULL;
	wcex.lpszClassName = L"MainClass";
	wcex.hIconSm = LoadIcon(hInst, MAKEINTRESOURCE(IDI_SMALL));

	RegisterClassEx(&wcex);

	mainWnd = CreateWindow(L"MainClass",
		L"Ninjas",
		WS_OVERLAPPEDWINDOW,
		0, 0,
		GetSystemMetrics(SM_CXSCREEN), GetSystemMetrics(SM_CYSCREEN),
		NULL,
		NULL,
		hInstance,
		NULL);

	if (mainWnd == 0)
	{
		MessageBox(NULL, L"Ошибка окна с полем!", NULL, MB_OK);
		return 1;
	}

	ShowWindow(mainWnd, nCmdShow);
	UpdateWindow(mainWnd);

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

WCHAR *OpenFileDlg(HWND hWnd)
{
	const COMDLG_FILTERSPEC fileTypes[] = {
	{
		L"Все файлы", L"*.*" }
	};

	WCHAR *filename = NULL;
	IFileDialog *open = NULL;
	HRESULT res = CoCreateInstance(CLSID_FileOpenDialog, NULL, CLSCTX_INPROC_SERVER, IID_PPV_ARGS(&open));
	if (FAILED(res))
	{
		MessageBox(hWnd, L"Ошибка загрузки!", NULL, MB_OK);
		return NULL;
	}
	DWORD flags;
	res = open->GetOptions(&flags);
	if (FAILED(res))
	{
		MessageBox(hWnd, L"Ошибка загрузки!", NULL, MB_OK);
		return NULL;
	}
	res = open->SetOptions(flags | FOS_FORCEFILESYSTEM);
	if (FAILED(res))
	{
		MessageBox(hWnd, L"Ошибка загрузки!", NULL, MB_OK);
		return NULL;
	}
	res = open->SetFileTypes(ARRAYSIZE(fileTypes), fileTypes);
	if (FAILED(res))
	{
		MessageBox(hWnd, L"Ошибка загрузки!", NULL, MB_OK);
		return NULL;
	}
	res = open->SetFileTypeIndex(1);
	if (FAILED(res))
	{
		MessageBox(hWnd, L"Ошибка загрузки!", NULL, MB_OK);
		return NULL;
	}
	res = open->SetDefaultExtension(L"pmap");
	if (FAILED(res))
	{
		MessageBox(hWnd, L"Ошибка загрузки!", NULL, MB_OK);
		return NULL;
	}
	res = open->Show(hWnd);
	if (FAILED(res))
		return NULL;
	IShellItem *psiRes;
	res = open->GetResult(&psiRes);
	if (FAILED(res))
	{
		MessageBox(hWnd, L"Ошибка загрузки!", NULL, MB_OK);
		return NULL;
	}
	res = psiRes->GetDisplayName(SIGDN_FILESYSPATH, &filename);
	if (FAILED(res))
	{
		MessageBox(hWnd, L"Ошибка загрузки!", NULL, MB_OK);
		return NULL;
	}
	psiRes->Release();
	open->Release();
	return filename;
}

INT_PTR CALLBACK FileSelectProc(HWND hDlg,
	UINT message,
	WPARAM wParam,
	LPARAM lParam)
{
	switch (message)
	{
	case WM_INITDIALOG:
		
		break;

	case WM_COMMAND:
		switch(wParam)
		{
		case 1:
			EndDialog(hDlg, 0);
			return (INT_PTR)TRUE;

		case IDC_BUTTON1:
		{
			WCHAR *codeFile = OpenFileDlg(hDlg);
			SetWindowText((HWND)lParam, codeFile);
			players[0].SetCode(codeFile);
			break;
		}

		case IDC_BUTTON2:
			WCHAR *codeFile = OpenFileDlg(hDlg);
			SetWindowText((HWND)lParam, codeFile);
			players[1].SetCode(codeFile);
			break;
		}
		break;

	case WM_CLOSE:
		MessageBox(hDlg, L"Выберите программы для управления и нажмите ОК.", NULL, MB_OK);
		EndDialog(hDlg, 0);
		return (INT_PTR)TRUE;
		break;
	}
	return (INT_PTR)FALSE;
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
		RECT client;
		GetClientRect(hWnd, &client);
		mapWidth = client.right;
		mapHeight = client.bottom;
		DialogBox(hInst, MAKEINTRESOURCE(IDD_FSDIALOG), hWnd, FileSelectProc);
		SetTimer(hWnd, COMMAND_TIMER, 50, NULL);
		break;
	}

	case WM_TIMER:
		switch (wParam)
		{
		case COMMAND_TIMER:
		{
			for (int i = 0; i < PLAYER_COUNT; ++i)
			{
				if (players[i].isActive)
				{
					Command next = players[i].interpreter.NextCommand();
					switch (next.type)
					{
					case Command::Move:
					{
						double res = next.param;
						for (int j = 0; j < PLAYER_COUNT; ++j)
						{
							if (i == j || !players[j].isActive)
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
				}
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
			if (players[0].interpreter.isLooped)
				break;
			com.type = Command::Turn;
			com.param = -0.1;
			players[0].interpreter.AddCommand(com);
			break;

		case 0x44:
			if (players[0].interpreter.isLooped)
				break;
			com.type = Command::Turn;
			com.param = 0.1;
			players[0].interpreter.AddCommand(com);
			break;

		case 0x57:
			if (players[0].interpreter.isLooped)
				break;
			com.type = Command::Move;
			com.param = 5;
			players[0].interpreter.AddCommand(com);
			break;

		case 0x52:
			if (players[0].interpreter.isLooped)
				break;
			if (!players[0].isSwinging)
			{
				com.type = Command::Swing;
				players[0].interpreter.AddCommand(com);
			}
			break;

		case 0x46:
			if (players[0].interpreter.isLooped)
				break;
			com.type = Command::Shoot;
			players[0].interpreter.AddCommand(com);
			break;

		case 0x4a:
			if (players[1].interpreter.isLooped)
				break;
			com.type = Command::Turn;
			com.param = -0.1;
			players[1].interpreter.AddCommand(com);
			break;

		case 0x4c:
			if (players[1].interpreter.isLooped)
				break;
			com.type = Command::Turn;
			com.param = 0.1;
			players[1].interpreter.AddCommand(com);
			break;

		case 0x49:
			if (players[1].interpreter.isLooped)
				break;
			com.type = Command::Move;
			com.param = 5;
			players[1].interpreter.AddCommand(com);
			break;

		case 0x55:
			if (players[1].interpreter.isLooped)
				break;
			if (!players[1].isSwinging)
			{
				com.type = Command::Swing;
				players[1].interpreter.AddCommand(com);
			}
			break;

		case 0x48:
			if (players[1].interpreter.isLooped)
				break;
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
