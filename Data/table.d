module table;
import std.stdio;
import helper;
public import column;
struct Table
{
	dstring dbname;
	dstring name;
	Column[] columns;
	private Column nullcol;

	public ref  Column getColumn(dstring colname)
	{
		foreach(ref col;columns)
		{
			if(col.name==colname){
				return col;break;
			}
		}
		return nullcol;
	}

	public void addColumn(dstring colname)
	{
		Column col;
		col.name=colname;
		this.columns~=col;
	}

	public void delColumn(dstring colname)
	{
		Column[] cols;
		foreach(col;columns)
		{
			if(col.name==colname)continue;
			else cols~=col;
		}
		this.columns=cols;
	}

	public dstring[dstring] getAssoc(uint row)
	{
		dstring[dstring] ret;
		foreach(ref col;columns)
		{
			if(row>col.datas.length)break;
			else ret[col.name]=col.datas[row];
		}
		return ret;
	}

	public uint getLength()
	{	
		return columns[0].datas.length;
	}


	ref Column opIndex(dstring colname)
	{
		return getColumn(colname);
	}

	public void addAssoc(dstring[dstring] assoc)
	{
		foreach(colname,val;assoc)
		{
			foreach(ref col;columns)
			{
				if(col.name==colname)
				{
					col.addData(val);
				}
			}
		}
	}

	public void SaveIt()
	{
		File file;
		try
			file=File(getTableInfo(to!string(this.dbname),"datable."~to!string(this.name)),"w+");
		catch(Exception ex)
			throw ex;
		file.writeln("TBLNAME \"",this.name,"\"");
		foreach(col;columns)
		{

			file.writeln(col);
		}
	}

	public void delRow(uint row)
	{
		foreach(ref col;columns)
		{
			col.datas.remove(row);
		}
	}
}
