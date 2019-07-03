#pragma once

#include "resource.h"
#define _USE_MATH_DEFINES
#include <vector>
#include <cmath>
#include "Projectile.h"
#include "Character.h"

#define COMMAND_TIMER 1
#define SWING_TIMER 2

#define PLAYER_COUNT 4

extern int mapWidth, mapHeight;
extern Character* players;