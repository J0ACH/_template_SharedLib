#include "MyClass.h"

namespace MyNamespace
{
	MyClass::MyClass(QWidget *parent) : QWidget(parent)
	{
		qDebug("MyClass new object");
	}
	MyClass::~MyClass()
	{
		qDebug("MyClass closed");
	}
}