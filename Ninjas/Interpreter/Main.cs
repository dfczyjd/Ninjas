using System;
using System.Diagnostics;
using System.IO;
using System.Collections.Generic;
using System.Text;
using Antlr4.Runtime;
using Antlr4.Runtime.Misc;
using Antlr4.Runtime.Tree;
using System.Runtime.InteropServices;

public class Command
{
    public int type;
    public double param;

    public Command(int t = 0, double p = 0)
    {
        type = t;
        param = p;
    }
}

public static class Main
{
    static RealInterpreter[] ints = new RealInterpreter[4];
    static StreamWriter sw = new StreamWriter("../log.txt");

    static Main()
    {
        for (int i = 0; i < 4; ++i)
        {
            ints[i] = new RealInterpreter();
        }
    }

    public static void Log(string value)
    {
        sw.WriteLine(value);
    }

    [DllExport]
    public static void Init(int id, string name)
    {
        try
        {
            ints[id].Init(name);
        }
        catch (Exception exc)
        {
            Log("Error in Init() of interpreter #" + id.ToString() + ":" + exc.Message);
        }
    }

    [DllExport]
    public static void Run(int id)
    {
        try
        {
            ints[id].Run();
            Log("Note from #: commands are\n");
            foreach (var elem in ints[id].commands)
                Log(Serialize(elem));
        }
        catch (Exception exc)
        {
            Log("Error in Run() of interpreter #" + id.ToString() + ":" + exc.Message);
        }
    }

    public static string Serialize(Command com)
    {
        return String.Format("{0} {1}", com.type, com.param);
    }

    [DllExport]
    public static string GetCommand(int id)
    {
        try
        {
            if (ints[id].commands.Count == 0)
                return Serialize(new Command());
            return Serialize(ints[id].commands.Dequeue());
        }
        catch (Exception exc)
        {
            Log("Error in Run() of interpreter #" + id.ToString() + ":" + exc.Message);
            return Serialize(new Command());
        }
    }
}

public class RealInterpreter
{
    NinjaParser parser;
    public Queue<Command> commands = new Queue<Command>();
    
    public void Init(string name)
    {
        var input = File.ReadAllText(name);
        var ms = new MemoryStream(Encoding.UTF8.GetBytes(input));
        var lexer = new NinjaLexer(new AntlrInputStream(ms));
        var tokens = new CommonTokenStream(lexer);
        parser = new NinjaParser(tokens);
        parser.owner = this;
        var tree = parser.program();
    }
    
    public void Run()
    {
        parser.metTable["main"].Eval();
    }
}