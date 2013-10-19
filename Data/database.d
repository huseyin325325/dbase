module database;
import std.file;

import std.stdio;
import std.conv:to;
import std.uni:isAlpha,isSymbol;

public import table;
import helper;

class Database
{
	dstring name;
	dstring[] tables;
	Table nulltable;

	this(string dbname)
	{
		openDB(dbname);
	}

	private void openDB(string dbname)
	{
		if(!exists(getDb(dbname)))
			throw new Exception("Hata: Veritabanı Bulunamadı");
		scope File file;
		try
			file=File(getDb(dbname)~".conf","r+");
		catch(Exception ex)
		{
			throw ex;
		}
		while(!file.eof())
		{
			interp(tokenizer(to!(dchar[])(file.readln())));
		}
	}

	public Table getTable(dstring tbname)
	{
		dstring[] toks;
		scope File file;
		foreach(table;tables)
			if(table==tbname)
			{
				try
					file=File(getTableInfo(to!string(this.name),"datable."~to!string(tbname)),"r+");
				catch(Exception ex)
					throw ex;
				uint i;
				while(!file.eof())
				{
					toks~=tokenizer(to!(dchar[])(file.readln()));
				}
				return tblinterp(toks);
			}

		return nulltable;

	}

	private void interp(dstring[] tokens)
	{
		uint j;

		while(j<tokens.length)
		{
			if(tokens[j]=="DATABASE")
			{
				j++;
				this.name=tokens[j];
			}
			if(tokens[j]=="TABLES")
			{
				j++;
				do{
					this.tables~=tokens[j];
					j++;
				}while(j<tokens.length && tokens[j]!=",");
			}
			j++;
		}
	}

	private Table tblinterp(dstring[] tokens)
	{
		Table tbl;
		uint i;
		while(i<tokens.length)
		{
			if(tokens[i]=="TBLNAME")
			{
				i++;
				tbl.name=tokens[i];
			}
			if(tokens[i]=="COLUMN")
			{
				i++;
				Column cln;
				while(i<tokens.length && tokens[i]!="COLUMNEND")
				{
					if(tokens[i]=="NAME")
					{
						i++;
						cln.name=tokens[i];
					}

					if(tokens[i]=="DATAS")
					{
						i++;

						do{
							if(tokens[i]=="\n")break;
							{
								cln.count++;
								cln.datas[cln.count]=tokens[i];

							}
							i++;
						}while(i<tokens.length && tokens[i]!=",");

					}

					i++;
				}
				tbl.columns~=cln;
			}
			i++;
		}
		tbl.dbname=this.name;
		return tbl;
	}

	Table opIndex(dstring tbname)
	{
		return getTable(tbname);
	}

	public void createTable(dstring tbname)
	{
		string tb=getTableInfo(to!string(name),"datable."~to!string(tbname));
		if(exists(tb))
		{
			throw new Exception("Hata: Bu tablo zaten mevcut");
		}
		else
		{

			File fl=File(tb,"w+");
			fl.writeln("TBLNAME \""~tbname~"\"");
			this.tables~=tbname;
			SaveMe();
		}
	}

	public void deleteTable(dstring tbname)
	{
		if(exists(getTableInfo(to!string(name),"datable."~to!string(tbname))))
		{
			remove(getTableInfo(to!string(name),"datable."~to!string(tbname)));
			dstring[] tbls;
			foreach(tbl;tables)
			{
				if(tbl==tbname)continue;
				else tbls~=tbl;
			}
			tables=tbls;
			SaveMe();
		}
		else
		{
			throw new Exception("Hata: Böyle bir tablo bulunamadı.");
		}
	}

	public void SaveMe()
	{
		File file=File(getDb(to!string(name))~".conf","w+");
		file.writeln("DATABASE \""~name~"\"");
		dstring datass="TABLES ";
		for(uint i=0;i<tables.length;i++)
		{
			if(i==tables.length-1)
				datass~="\""~tables[i]~"\"";
			else
				datass~="\""~tables[i]~"\",";
		}
		file.write(datass);
	}


}


public void createDb(string dabname)
{
	if(exists(getDb(dabname)))
	{
		throw new Exception("Hata: Bu Veritabanı Zaten Sistemde Mevcuttur.");
	}
	else
	{
		string dbpath=getDbPath()~dabname;
		mkdir(dbpath);
		mkdir(getTablePath(dabname));
		File conf=File(getDb(dabname)~".conf","w+");
		conf.writeln("DATABASE \""~dabname~"\"");
	}
}

public void deleteDb(string dbname)
{
	if(!exists(getDb(dbname)))
	{
		throw new Exception("Hata: Veritabanı Bulunamadı.");
	}
	else
	{
		rmdirRecurse(getDb(dbname));
	}
}
