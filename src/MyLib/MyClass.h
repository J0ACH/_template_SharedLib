#ifndef MYCLASS_H
#define MYCLASS_H

#include <QWidget>
#include <QDebug>

namespace MyNamespace
{
	class MyClass : public QWidget
	{
		Q_OBJECT

	public:
		MyClass(QWidget *parent = 0);
		~MyClass();
	};
}

#endif // MYCLASS_H
