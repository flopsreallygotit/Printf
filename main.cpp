extern "C" void _printf(const char *str, ...);

int main()
{
    _printf("%s %b %d %o%%\n ABOBA_BEBRA \n", "Egorik", 0b1010, 1010, 8);
    _printf("%s %b %d %o%%\n ABOBA_BEBRA \n", "Egorik", 0b1010, 1010, 8);
    // TODO more than 5 args

    return 0;
}