extern void _printf(const char *str, ...);

int main()
{
    _printf("HI, DED32!\n");
    _printf("I am %s!\n", "Printf32");

    _printf("%c %s %d is %b, %o and even %x, and I %s %x %d %% %c%b\n", 'I', "exactly know that", 3802, 3802, 3802, 3802, "love", 3802, 100, 33, 127);

    return 0;
}