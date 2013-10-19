module column;
public alias ColumnName=dstring;
public alias Data=dstring;
struct Column
{
	dstring name;
	Data[uint] datas;
	uint count;
	public void addData(dstring data)
	{
		count++;
		this.datas[count]=data;
	}

	dstring toString()
	{
		dstring str;
		str~="COLUMN\n";
		str~="NAME \""~name~"\"\n";
		str~="DATAS ";
		uint i;
		foreach(data;datas)
		{
			if(i==datas.length-1)
				str~="\""d~data~"\""d;
			else
				str~="\""d~data~"\","d;
			i++;
		}
		str~="\nCOLUMNEND\n";
		return str;
	}
}
