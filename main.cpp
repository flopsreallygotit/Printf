extern "C" void _printf(const char *str, ...);

int main()
{
    _printf("%%Hello world%c\n%s\n", '!', "Test string");

    return 0;
}
