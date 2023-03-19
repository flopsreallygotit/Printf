extern "C" void _printf(const char *str, ...);

int main()
{
    // _printf("PERCENT: \t%%\nSYMBOL: \t%c\nSTRING: \t%s\nSTRING: \t%s\n", '!', "ABOBA", "BEBRA");

    _printf("%a");

    // _printf("PERCENT: \t%%\nSYMBOL: \t%c\nSTRING: \t%s\nNUMBER: \t%d\n", '!', "ABOBA", 1234);

    return 0;
}