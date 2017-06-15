#include "MyClass.h"

namespace MyNamespace
{
	MyClass::MyClass(QWidget *parent) : QWidget(parent)
	{
		qDebug("MyClass new object");
		this->show();
	}
	MyClass::~MyClass()
	{
		qDebug("MyClass closed");
	}
}