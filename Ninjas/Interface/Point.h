#pragma once
#include <cmath>

struct Point
{
	double x, y;

	Point();
	Point(double x, double y);
	Point(double angle);

	double Dist(const Point &other);

	Point operator+(const Point &other) const;
	Point operator*(double k) const;
};

