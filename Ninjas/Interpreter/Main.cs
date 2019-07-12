using System;
using System.Diagnostics;
using System.IO;
using System.Collections.Generic;
using System.Text;
using System.Threading;
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

    public static Thread[] t = new Thread[4];
    public static ManualResetEvent[] mre = new ManualResetEvent[4];

    static Main()
    {
        for (int i = 0; i < 4; ++i)
        {
            ints[i] = new RealInterpreter();
            mre[i] = new ManualResetEvent(true);
        }
    }

    public static void Log(string value)
    {
        sw.WriteLine(value);
        sw.Flush();
    }

    [DllExport]
    public static void Init(int id, string name)
    {
        try
        {
            ints[id].Init(id, name);
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
            t[id] = new Thread(ints[id].Run);
            mre[id].Set();
            t[id].Start();
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
            if (ints[id].commands.Count == 1)
                mre[id].Set();
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
    
    public void Init(int id, string name)
    {
        var input = File.ReadAllText(name);
        var ms = new MemoryStream(Encoding.UTF8.GetBytes(input));
        var lexer = new NinjaLexer(new AntlrInputStream(ms));
        var tokens = new CommonTokenStream(lexer);
        parser = new NinjaParser(tokens);
        parser.owner = this;
        parser.id = id;
        var tree = parser.program();
    }
    
    public void Run()
    {
        parser.metTable["main"].Eval();
    }
}