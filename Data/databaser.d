module databaser;
public import database;
import std.uni;
import std.stdio:writeln;
import std.array:split;
class Interpereter{

	private
	{
		dstring[] tokens;
		dstring method;
		dstring[] percols;
		dstring tblname;
		dstring dbname;
		dstring c_op;
		dstring c_val;
		dstring c_col;
		bool all=false;
	}
	void tokengen(dstring chars)
	{
		uint i;
		while(i<chars.length)
		{
			if(isSymbol(chars[i]) || isPunctuation(chars[i]))
				tokens~=to!dstring(chars[i]);
			if(isAlpha(chars[i]))
			{
				dstring tmp;
				while(i<chars.length && (isAlpha(chars[i]) || isNumber(chars[i])))
				{
					tmp~=chars[i];
					i++;
				}
				tokens~=tmp;
			}

			i++;
		}
	}
	//GET ALL IN TABLENAME FROM DBNAME
	dstring[][dstring] perform()
	{
		uint i;
		while(i<tokens.length)
		{
			if(tokens[i]=="GET")
			{
				method="GET";
				i++;
				if(tokens[i]!="ALL")
				{
					do
					{
						if(tokens[i]=="IN")break;
						percols~=tokens[i];
						i++;
					}while(i<tokens.length && tokens[i]!=",");
				}
				else
					all=true;
			}
			if(tokens[i]=="FROM")
			{
				i++;
				dbname=tokens[i];
			}

			if(tokens[i]=="IN")
			{
				i++;
				tblname=tokens[i];
			}
			if(tokens[i]=="COND")
			{
				i++;
			}
			i++;
		}
		//writeln(method," ",tblname," ",percols," ",dbname);
		return ender();
	}

	dstring[][dstring] ender()
	{
		dstring[][dstring] ret;
		if(method=="" || tblname=="" || dbname== "")throw new Exception("Error ###");
		Database db=new Database(to!string(dbname));
		Table tbl=db[tblname];
		if(method=="GET")
		{
			if(all==false)
			{
				
				foreach(col;percols)
				{
					auto icol=tbl.getColumn(col);
					foreach(dat;icol.datas)
					{
						ret[icol.name]~=dat;
					}
				}
			}
		}
		return ret;
	}
	this(dstring query)
	{
		tokengen(query);
		auto a=perform();
		foreach(abc;a)
			writeln(abc);
	}
}

