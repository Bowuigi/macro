# Macro

Preprocessing for any file!

Its main use is to add macros to Lua, which is the only thing it lacks, but it can add macros to any file, including macro itself!

If you don't like the macro syntax, just make a macro for it that replaces it with the syntax you want!

# Usage

`macro [command you want to run on the preprocessed file] (file to preprocess)`

The commands are not required, you can just run it without those and it will print the file after preprocessing to standard input, which you can then save to a file easily, or just do more processing in it

On the file you want macros, do this:

```
%sub "find pattern" "replace with"

... your file contents ...
```

You can place the macros in any place on the file, including the end or right on the middle (why?)

It is shebang compatible, for example

```lua
#!/usr/bin/macro lua

%sub "%((.-)%)%s*->%s*{(.-)}" "function(%1) %2 end"

-- Cooler functions
sayHi = () -> {
	print("hi!")
}
```

Will pass the output of the preprocessor to `lua`
