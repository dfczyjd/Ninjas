#include "stdafx.h"
#include "resource.h"
#include "Interface.h"
#include "Interpreter.h"
#include <Shobjidl.h>
#include <Shlwapi.h>

HWND mainWnd, infoWnd;
HINSTANCE hInst;
Character *players;
RECT updateRect;
int mapWidth, mapHeight;
bool abortLaunch = false;

LRESULT CALLBACK	WndProc(HWND, UINT, WPARAM, LPARAM);
LRESULT CALLBACK	InfoWndProc(HWND, UINT, WPARAM, LPARAM);

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

	wcex.lpszClassName = L"InfoClass";
	wcex.lpfnWndProc = InfoWndProc;
	wcex.hbrBackground = (HBRUSH)(COLOR_WINDOW);

	RegisterClassEx(&wcex);

	infoWnd = CreateWindow(L"InfoClass",
		L"",
		WS_CHILD,
		700, 0,
		GetSystemMetrics(SM_CXSCREEN) - 700, GetSystemMetrics(SM_CYSCREEN),
		mainWnd,
		NULL,
		hInstance,
		NULL);

	if (mainWnd == 0)
	{
		MessageBox(NULL, L"Ошибка окна с полем!", NULL, MB_OK);
		return 1;
	}

	if (infoWnd == 0)
	{
		MessageBox(NULL, L"Ошибка окна с информацией!", NULL, MB_OK);
		return 1;
	}

	ShowWindow(mainWnd, nCmdShow);
	UpdateWindow(mainWnd);

	ShowWindow(infoWnd, nCmdShow);
	UpdateWindow(infoWnd);

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
		if (i == ind || !players[i].isActive)
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
		switch (wParam)
		{
		case 1:
			EndDialog(hDlg, 0);
			return (INT_PTR)TRUE;

		case IDC_BUTTON1:
		{
			WCHAR *codeFile = OpenFileDlg(hDlg);
			if (codeFile == NULL)
				break;
			SetWindowText((HWND)lParam, codeFile);
			players[0].interpreter.SetCode(codeFile);
			break;
		}

		case IDC_BUTTON2:
		{
			WCHAR *codeFile = OpenFileDlg(hDlg);
			if (codeFile == NULL)
				break;
			SetWindowText((HWND)lParam, codeFile);
			players[1].interpreter.SetCode(codeFile);
			break;
		}

		case IDC_BUTTON3:
		{
			WCHAR *codeFile = OpenFileDlg(hDlg);
			if (codeFile == NULL)
				break;
			SetWindowText((HWND)lParam, codeFile);
			players[2].interpreter.SetCode(codeFile);
			break;
		}

		case IDC_BUTTON4:
		{
			WCHAR *codeFile = OpenFileDlg(hDlg);
			if (codeFile == NULL)
				break;
			SetWindowText((HWND)lParam, codeFile);
			players[3].interpreter.SetCode(codeFile);
			break;
		}
		}
		break;

	case WM_CLOSE:
		EndDialog(hDlg, 0);
		abortLaunch = true;
		return (INT_PTR)TRUE;
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
			Character(0, 100, 100, RGB(255, 0, 0), M_PI_4),
			Character(1, 600, 100, RGB(0, 0, 255), 3 * M_PI_4),
			Character(2, 100, 600, RGB(0, 255, 0), 7 * M_PI_4),
			Character(3, 600, 600, RGB(255, 255, 0), 5 * M_PI_4)
		};
		RECT client;
		GetClientRect(hWnd, &client);
		mapWidth = 700;
		mapHeight = 700;
		WINDOWINFO info;
		GetWindowInfo(hWnd, &info);
		MoveWindow(infoWnd, 700, 0, client.right - 700, client.bottom, true);
		/* for testing without selecting code file*/
		WCHAR name1[] = L"C:/LatinName/nnj.npr",
			name2[] = L"C:/LatinName/nnj_void.npr";
		players[0].interpreter.SetCode(name1);
		players[1].interpreter.SetCode(name1);
		players[2].interpreter.SetCode(name1);
		players[3].interpreter.SetCode(name1);
		//DialogBox(hInst, MAKEINTRESOURCE(IDD_FSDIALOG), hWnd, FileSelectProc);
		if (abortLaunch)
		{
			SendMessage(hWnd, WM_CLOSE, NULL, NULL);
			return 0;
		}
		SetTimer(hWnd, COMMAND_TIMER, 100, NULL);
		players[0].interpreter.SendUpdate();
		for (int i = 0; i < PLAYER_COUNT; ++i)
			players[i].interpreter.RunMeth(i);
		InvalidateRect(hWnd, 0, true);
		UpdateWindow(hWnd);
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
				players[i].interpreter.SendUpdate();
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
		InvalidateRect(infoWnd, 0, true);
		UpdateWindow(infoWnd);
		break;
	}

	/*case WM_KEYDOWN:
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
	}*/

	case WM_DESTROY:
		KillTimer(hWnd, COMMAND_TIMER);
		KillTimer(hWnd, SWING_TIMER);
		//FreeLibrary(hLib);
		PostQuitMessage(0);
		break;

	default:
		return DefWindowProc(hWnd, message, wParam, lParam);
	}
	return 0;
}

LRESULT CALLBACK InfoWndProc(HWND hWnd,
	UINT message,
	WPARAM wParam,
	LPARAM lParam)
{
	PAINTSTRUCT ps;
	HDC hdc;

	static WCHAR text[1024];

	switch (message)
	{
	case WM_CREATE:
	{
		
		break;
	}

	case WM_PAINT:
	{
		hdc = BeginPaint(hWnd, &ps);
		SetBkMode(hdc, TRANSPARENT);
		for (int i = 0; i < PLAYER_COUNT; ++i)
		{
			int cnt = wsprintf(text, L"Игрок №%d: %d/100", i, players[i].health);
			TextOut(hdc, 100, 50 * (i + 1), text, cnt);
		}
		EndPaint(hWnd, &ps);
		break;
	}

	case WM_DESTROY:
		
		PostQuitMessage(0);
		break;

	default:
		return DefWindowProc(hWnd, message, wParam, lParam);
	}
	return 0;
}