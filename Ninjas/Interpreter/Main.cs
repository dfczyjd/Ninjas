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
    static StreamWriter sw = new StreamWriter("log.txt");

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
        sw.WriteLine("[" + DateTime.Now + "] " + value);
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

    public static void Deserialize(string s, ref int[] health, ref double[] xPos, ref double[] yPos, ref double[] dirs)
    {
        string[] vals = s.Replace('.', ',').Split(' ');
        for (int i = 0; i < 4; ++i)
        {
            health[i] = int.Parse(vals[i * 4]);
            xPos[i] = double.Parse(vals[i * 4 + 1]);
            yPos[i] = double.Parse(vals[i * 4 + 2]);
            dirs[i] = double.Parse(vals[i * 4 + 3]);
        }
    }

    [DllExport]
    public static string GetCommand(int id)
    {
        try
        {
            if (ints[id].commands.Count == 0)
                mre[id].Set();
            if (ints[id].commands.Count == 0)
            {
                if (id == 0)
                    Log("interpreter #" + id + " executing " + Serialize(new Command()));
                return Serialize(new Command());
            }
            if (id == 0)
                Log("interpreter #" + id + " executing " + Serialize(ints[id].commands.Peek()));
            return Serialize(ints[id].commands.Dequeue());
        }
        catch (Exception exc)
        {
            Log("Error in Run() of interpreter #" + id.ToString() + ":" + exc.Message);
            return Serialize(new Command());
        }
    }

    [DllExport]
    public static void UpdateInfo(int id, string data)
    {
        try
        {
            for (int i = 0; i < 4; ++i)
                ints[i].UpdateInfo(data);
        }
        catch (Exception exc)
        {
            Log("Error in UpdateInfo() of interpreter #" + id.ToString() + ":" + exc.Message);
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
        if (parser != null)
            parser.metTable["main"].Eval();
    }

    public void UpdateInfo(string s)
    {
        if (parser != null)
            Main.Deserialize(s, ref parser.health, ref parser.xPos, ref parser.yPos, ref parser.dirs);
    }
}