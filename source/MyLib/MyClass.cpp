#include "MyClass.h"

namespace MyNamespace
{
	MyClass::MyClass(int width, int height) 
	{
		qDebug("Ma draha Barboro, miluji te");
		QWidget *frame = new QWidget(0);
		frame->setFixedSize(QSize(width, height));
		frame->show();
	}
	MyClass::~MyClass()
	{
		qDebug("MyClass closed");
	}
}