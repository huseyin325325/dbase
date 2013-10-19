module helper;
import std.uni;
import std.conv:to;
import std.file;
import std.stdio;
dstring[] tokenizer(dchar[] str)
{
	uint i;
	dstring[] tokens;
	while(i<str.length)
	{
		if(isAlpha(str[i]))
		{
			dstring tmp;
			while(i<str.length && isAlpha(str[i]))
			{
				tmp~=str[i];
				i++;
			}
			tokens~=tmp;
		}
		if(str[i]=='"')
		{
			i++;
			dstring tmp;
			while(i<str.length && str[i]!='"')
			{
				tmp~=str[i];
				i++;
			}
			tokens~=tmp;
		}
		if(isSymbol(str[i]))
		{
			tokens~=to!dstring(str[i]);
		}
		if(str[i]=='\n')tokens~="\n";
		i++;
	}
	return tokens;
}

public string getTableInfo(string dbname,string tbname)
{
	version(Windows)
		return "Databases\\"~dbname~"\\tables\\"~tbname;
	version(Linux)
		return "Databases/"~dbname~"/tables/"~tbname;
}

public string getTablePath(string dbname)
{
	version(Windows)
		return "Databases\\"~dbname~"\\tables\\";
	version(Linux)
		return "Databases/"~dbname~"/tables/";
}

public string getDb(string dbname)
{
	version(Windows)
		return "Databases\\"~dbname~"\\";
	version(Linux)
		return "Databases/"~dbname~"/";
}

public string getDbPath()
{
	version(Windows)
		return "Databases\\";
	version(Linux)
		return "Databases/";
}
