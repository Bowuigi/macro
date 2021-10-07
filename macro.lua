#!/usr/bin/luajit

-- Print the usage information to stderr
function Usage()
	io.stderr:write(tostring(arg[0])..
[[ [command to run on processed file] [filename]

It can also run on a shebang (for example, "#!/usr/bin/macro lua" at the top of the file will preprocess the file and then pass it to the program specified)

Syntax:

On any file you want, you type this (without the starting and ending dashes)

---------
%start
%macro MACRO_NAME macro definition
%macro func function
%macro f function
%macro elif elseif
%end
---------

And now you can use the macros declared before on any place of the document, no matter (mostly) what format it has

Remember that those macros are not context aware (since that is language specific) and will expand on strings, to prevent this, just add a percent sign (%) before the macro name (not the declaration), like this %my_macro

They will expand as long as:
- They are not escaped (%my_macro)
- The previous character is not alphanumeric (1my_macro)
- The next character is not alphanumeric (my_macro1)
]])
end

-- Read a file and extract its macros
function ReadFile(filename)
	-- Initialize
	local f = io.open(filename)
	local str = ""
	local macros = {}
	local started = false
	local i = 1

	-- For every line on the file, check for preprocessor instructions (in macro format)
	for line in f:lines() do
		-- %start and %end
		if (line=="%start")   then started=true
		elseif (line=="%end") then started=false break

		-- %macro
		elseif (line:sub(1,1)=="%") then
			local found, _, macro, def = line:find("^%%macro%s+(%w+)%s+(.+)")

			if (found and started) then
				macros[#macros+1] = {macro,def}
			end
		else
			-- Otherwise, just add the line to the result string
			if (i==1) then
				str=str..line
			else
				str=str.."\n"..line
			end
			i=i+1
		end
	end

	-- Finish
	f:close()
	return str, macros
end

-- Expand the given macros on the given string
function ApplyMacros(str, macros)
	local s = str

	-- Look for macros
	for i=1, #macros do
		s = s:gsub("(.)("..macros[i][1]..")(.)", (function(prefix,macro)
			-- If it is not surrounded by a letter or a number, then run normally
			if (string.find("%A", prefix) or string.find("%A",postfix)) then
				return prefix..macro..postfix
			end

			-- If it is escaped with a %, then just return the name of the macro unescaped
			if (prefix=="%") then
				return macro..postfix
			else
				-- Otherwise, expand the macro
				return prefix..macros[i][2]..postfix
			end
		end))
	end

	return s
end

-- If the arguments are not 1 or 2, then print the usage
if (#arg > 2 or #arg < 1) then Usage() os.exit(1) end

local contents, macros, final, command

-- If there is a second argument, read the file from it and the command from the first argument
if (arg[2]) then
	contents, macros = ReadFile(arg[2])
	final = ApplyMacros(contents, macros)

	-- Make a temporal file to pass to the command and write the string
	local f_name = os.tmpname()
	do
		local f = assert(io.open(f_name,"w"))
		f:write(final.."\n")
		f:close()
	end

	-- Run the command on arg[1] with the filename in quotes just in case
	os.execute(arg[1]..' "'..f_name..'"')
	-- Clean up
	os.remove(f_name)
else
	-- Otherwise, just read, preprocess and print
	contents, macros = ReadFile(arg[1])
	print(ApplyMacros(contents, macros))
end
