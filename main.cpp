#include <crow.h>

int main(int argc, char **argv)
{
    crow::SimpleApp app;

    CROW_ROUTE(app, "/")([](){
        auto page = crow::mustache::load_text("index.html");
        return page;
    });

    CROW_ROUTE(app, "/hello")([](){
        return "Hello world";
    });

    app.port(18080).multithreaded().run();

    return 0;
}
