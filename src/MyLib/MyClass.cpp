#include "MyClass.h"

namespace MyNamespace
{
	MyClass::MyClass(QWidget *parent) : QWidget(parent)
	{
		qDebug("Ma draha Barboro, miluji te");
		this->show();
	}
	MyClass::~MyClass()
	{
		qDebug("MyClass closed");
	}
}