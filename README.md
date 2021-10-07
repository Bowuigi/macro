# Macro

Preprocessing for any file!

Its main use is to add macros to Lua, which is the only thing it lacks, but it can add macros to any file, including macro itself!

If you don't like the macro syntax, just make a macro for it that replaces it with the syntax you want!

# Usage

`macro [command you want to run on the preprocessed file] (file to preprocess)`

The commands are not required, you can just run it without those and it will print the file after preprocessing to standard input, which you can then save to a file easily, or just do more processing in it

On the file you want macros, do this:

```
%start
%macro GREETING hello! how are you?
%macro f function
%end

... your file contents ...
```

You can place the macros in any place on the file, including the end or right on the middle (why?)

It is shebang compatible, for example

```lua
#!/usr/bin/macro lua

%start
%macro f function
%end

-- Anonymous functions made easier to write
(f() print("hi") end)()

-- You don't have to escape every %f, but only the ones that are not next to alphanumeric characters, for example, "for" and "function" should not be escaped, but %f() or %f should
```

Will pass the output of the preprocessor to `lua`

As mentioned in the example, macros can be escaped by adding a *%* before them, but here are all the conditions that must be met for the macro to expand

- It must not be escaped
- The previous character must not be an alphanumeric character
- The next character must not be an alphanumeric character

For example, if you have a macro named "my_macro" then

**my_macro** would expand

**my_macro2** wouldn't expand

**pmy_macroi** wouldn't expand either

**%my_macro** wouldn't expand
