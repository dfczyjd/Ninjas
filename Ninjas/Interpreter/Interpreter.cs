using System;
using System.Diagnostics;
using System.IO;
using System.Text;
using Antlr4.Runtime;
using Antlr4.Runtime.Misc;
using Antlr4.Runtime.Tree;

public class RealInterpreter
{
    NinjaParser parser;

    public void Init()
    {
        var input = File.ReadAllText("..\\..\\nnj.npr");
        var ms = new MemoryStream(Encoding.UTF8.GetBytes(input));
        var lexer = new NinjaLexer(new AntlrInputStream(ms));
        var tokens = new CommonTokenStream(lexer);
        parser = new NinjaParser(tokens);
        var tree = parser.program();
    }

    public void Run()
    {
        NinjaParser.metTable["main"].Eval();
    }
}