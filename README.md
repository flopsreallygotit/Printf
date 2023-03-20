# General information

**_printf** is my attempt to develop a function that would be similar to `printf`.

It supports following format specifiers:

---------------------------------
| Specifier | Data type         |
|-----------|-------------------|
| %d,       | int (decimal)     |
| %x,       | int (hexadecimal) |
| %o        | int (octal)       |
| %b        | int (binary)      |
| %c        | char              |
| %s        | array of chars    |
| %%        | percent character |
---------------------------------

# How to build

If you are a newbie in asm, install NASM:
```
$ sudo apt install nasm
```

To build and run project:
```
$ make
$ ./main
```

If you want to delete all objective files and executable:
```
$ make clear
```

If you want to clean all objective files, logs, e.t.c:
```
$ make fclear
```

# Example of code

``` C
extern void _printf(const char *str, ...);

int main()
{
    _printf("HI, DED32!\n");
    _printf("I am %s!\n", "Printf32");

    _printf("%c %s %d is %b, %o and even %x, and I %s %x %d %% %c%b\n", 'I', "exactly know that", 3802, 3802, 3802, 3802, "love", 3802, 100, 33, 127);

    return 0;
}
```

No jokes at the end of README???
