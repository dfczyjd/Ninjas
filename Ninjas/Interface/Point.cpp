#include "stdafx.h"
#include "Point.h"

Point::Point()
{
	x = y = 0;
}

Point::Point(double x, double y): x(x), y(y)
{

}

Point::Point(double angle)
{
	x = cos(angle);
	y = sin(angle);
}

double Point::Dist(const Point &other)
{
	double dx = x - other.x, dy = y - other.y;
	return sqrt(dx * dx + dy * dy);
}

Point Point::operator+(const Point &other) const
{
	return Point(x + other.x, y + other.y);
}

Point Point::operator*(double k) const
{
	return Point(x * k, y * k);
}
