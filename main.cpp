#include <QGuiApplication>
#include <QQuickView>
#include <QUrl>

/**
 * @brief Entry point for the WifiWindow testing application
 *
 *  It will be used only for testing purposes.
 *  The real entry point for the WifiWindow will be different.
 */
int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQuickView view;
    view.setResizeMode(QQuickView::SizeRootObjectToView);
    view.setSource(QUrl(QStringLiteral("qrc:/qt/qml/WifiWindow/qml/WifiConfigScreen.qml")));
    view.show();

    return app.exec();
}
