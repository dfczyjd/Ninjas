#include "stdafx.h"
#include "resource.h"
#include "Interface.h"
#include "Interpreter.h"
#include <Shobjidl.h>
#include <Shlwapi.h>
#include <vector>

HWND mainWnd, infoWnd, chatWnd;
HINSTANCE hInst;
Character *players;
RECT updateRect;
int mapWidth, mapHeight;
bool abortLaunch = false;
vector<WCHAR *> chatMess;

LRESULT CALLBACK	WndProc(HWND, UINT, WPARAM, LPARAM);
LRESULT CALLBACK	InfoWndProc(HWND, UINT, WPARAM, LPARAM);
LRESULT CALLBACK	ChatWndProc(HWND, UINT, WPARAM, LPARAM);

void PrintMessage(const WCHAR *message, bool fromInterface)
{
	static WCHAR text[1024];
	int len;
	if (fromInterface)
		len = wsprintf(text, L"[System]: %s", message);
	else
		len = wsprintf(text, L"%s", message);
	chatMess.push_back(new WCHAR[139]);
	wcscpy(chatMess.back(), text);
}

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

	wcex.lpszClassName = L"ChatClass";
	wcex.lpfnWndProc = ChatWndProc;
	wcex.hbrBackground = (HBRUSH)(COLOR_WINDOW - 1);

	RegisterClassEx(&wcex);
	
	chatWnd = CreateWindow(L"ChatClass",
		L"",
		WS_CHILD,
		0, 400,
		GetSystemMetrics(SM_CXSCREEN) - 700, GetSystemMetrics(SM_CYSCREEN) - 400,
		infoWnd,
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

	if (chatWnd == 0)
	{
		MessageBox(NULL, L"Ошибка окна чата!", NULL, MB_OK);
		return 1;
	}

	ShowWindow(mainWnd, nCmdShow);
	UpdateWindow(mainWnd);

	ShowWindow(infoWnd, nCmdShow);
	UpdateWindow(infoWnd);

	ShowWindow(chatWnd, nCmdShow);
	UpdateWindow(chatWnd);

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
			players[i].TakeDamage(100, ind);
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
	int error = GetLastError();
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
	res = open->SetDefaultExtension(L"npr");
	if (FAILED(res))
	{
		MessageBox(hWnd, L"Ошибка загрузки!", NULL, MB_OK);
		return NULL;
	}
	error = GetLastError();
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
			WCHAR *codeFile = OpenFileDlg(mainWnd);
			if (codeFile == NULL)
				break;
			SetWindowText((HWND)lParam, codeFile);
			players[0].interpreter.SetCode(codeFile);
			players[0].isActive = true;
			players[0].hasProgram = true;
			break;
		}

		case IDC_BUTTON2:
		{
			WCHAR *codeFile = OpenFileDlg(mainWnd);
			if (codeFile == NULL)
				break;
			SetWindowText((HWND)lParam, codeFile);
			players[1].interpreter.SetCode(codeFile);
			players[1].isActive = true;
			players[1].hasProgram = true;
			break;
		}

		case IDC_BUTTON3:
		{
			WCHAR *codeFile = OpenFileDlg(mainWnd);
			if (codeFile == NULL)
				break;
			SetWindowText((HWND)lParam, codeFile);
			players[2].interpreter.SetCode(codeFile);
			players[2].isActive = true;
			players[2].hasProgram = true;
			break;
		}

		case IDC_BUTTON4:
		{
			WCHAR *codeFile = OpenFileDlg(mainWnd);
			if (codeFile == NULL)
				break;
			SetWindowText((HWND)lParam, codeFile);
			players[3].interpreter.SetCode(codeFile);
			players[3].isActive = true;
			players[3].hasProgram = true;
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
	static WCHAR name1[] = L"Красный",
				name2[] = L"Синий",
				name3[] = L"Зелёный",
				name4[] = L"Жёлтый";

	switch (message)
	{
	case WM_CREATE:
	{
		players = new Character[PLAYER_COUNT]{
			Character(name1, 0, 100, 100, RGB(255, 0, 0), M_PI_4),
			Character(name2, 1, 600, 100, RGB(0, 0, 255), 3 * M_PI_4),
			Character(name3, 2, 100, 600, RGB(0, 255, 0), 7 * M_PI_4),
			Character(name4, 3, 600, 600, RGB(255, 255, 0), 5 * M_PI_4)
		};
		players[0].interpreter.SetNames();
		RECT client;
		GetClientRect(hWnd, &client);
		mapWidth = 700;
		mapHeight = 700;
		WINDOWINFO info;
		GetWindowInfo(hWnd, &info);
		MoveWindow(infoWnd, 700, 0, client.right - 700, client.bottom, true);
		MoveWindow(chatWnd, 0, 400, client.right, client.bottom - 400, true);
		/*WCHAR name1[] = L"C:/LatinName/empty.npr",
			name2[] = L"C:/LatinName/Find1.npr";
		players[0].interpreter.SetCode(name2);
		players[1].interpreter.SetCode(name2);
		players[2].interpreter.SetCode(name2);
		players[3].interpreter.SetCode(name2);*/
		DialogBox(hInst, MAKEINTRESOURCE(IDD_FSDIALOG), hWnd, FileSelectProc);
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
						if (k == i || !players[k].isActive || !players[k].hasProgram)
							continue;
						if (players[k].position.Dist(shot.position) < Character::R)
						{
							players[k].TakeDamage(10, i);
							if  (!players[k].isActive || !players[k].hasProgram)
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
		players[0].interpreter.UpdateMessages();
		UpdateWindow(hWnd);
		break;

	case WM_PAINT:
	{
		hdc = BeginPaint(hWnd, &ps);
		for (int i = 0; i < PLAYER_COUNT; ++i)
		{
			if (players[i].isActive && players[i].hasProgram)
				players[i].Draw(hdc);
			for (int j = 0; j < players[i].shots.size(); ++j)
				players[i].shots[j].Draw(hdc);
		}
		EndPaint(hWnd, &ps);
		InvalidateRect(infoWnd, 0, true);
		UpdateWindow(infoWnd);
		break;
	}

	case WM_DESTROY:
		KillTimer(hWnd, COMMAND_TIMER);
		KillTimer(hWnd, SWING_TIMER);
		for (auto ptr : chatMess)
			delete ptr;
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
		int k = 0;
		for (int i = 0; i < PLAYER_COUNT; ++i)
		{
			if(players[i].hasProgram){
				int cnt = wsprintf(text, L"%s: %d/100", players[i].name, players[i].health);
				TextOut(hdc, 100, 50 * (k + 1), text, cnt);
				k++;
			}
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

LRESULT CALLBACK ChatWndProc(HWND hWnd,
	UINT message,
	WPARAM wParam,
	LPARAM lParam)
{
	PAINTSTRUCT ps;
	HDC hdc;

	static WCHAR text[1024];
	static int chatLength;

	switch (message)
	{
	case WM_CREATE:
	{
		RECT client;
		GetClientRect(hWnd, &client);
		chatLength = (client.bottom - 100) / 20;
		break;
	}

	case WM_PAINT:
	{
		hdc = BeginPaint(hWnd, &ps);
		SetBkMode(hdc, TRANSPARENT);
		int lastMess = min(chatLength, chatMess.size());
		for (int i = 0; i < lastMess; ++i)
		{
			int len = wsprintf(text, L"%s", chatMess[lastMess - i - 1]);
			TextOut(hdc, 20, (i + 1) * 20, text, len);
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