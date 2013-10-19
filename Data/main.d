module main;

import std.stdio;
import std.c.process:system;
import databaser;
import std.array:chomp;

void main(string[] argv)
{
	/+
	//createDb("mydb");
	Database db=new Database("mydb");
	Table tbl=db["table1"];
	tbl.getAssoc(1).writeln();
	/*
	tbl.addColumn("Adı");
	tbl.addColumn("Soyadı");
	tbl.addAssoc(["Adı":"Huseyin","Soyadı":"Akbaş"]);
	*/
	tbl.SaveIt();
	+/
	writeln("Bir Sorgu Girin:");
	string q=chomp(readln());
	Interpereter interp=new Interpereter(to!dstring(q));
	system("pause");
	
}
