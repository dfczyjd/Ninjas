using System;
using System.IO;
using System.Text;
using Antlr4.Runtime;
using Antlr4.Runtime.Tree;

namespace Interpreter
{
    public class Interpreter
    {
        private static bool initialized;

        public static string getNextCommand()
        {
            if (!initialized) Initialize();

            return "tt";
        }

        public static void Main(string[] args)
        {
            Console.WriteLine(getNextCommand());
            Console.ReadKey();
        }

        private static void Initialize()
        {
            var input = File.ReadAllText("..\\..\\..\\Interpreter\\code.txt");

            ICharStream stream = CharStreams.fromstring(input);
            ITokenSource lexer = new NinjaVarsLexer(stream);
            ITokenStream tokens = new CommonTokenStream(lexer);
            NinjaVarsParser parser = new NinjaVarsParser(tokens);
            parser.BuildParseTree = true;
            IParseTree tree = parser.program();
            var pastwk = new ParseTreeWalker();
            pastwk.Walk(new NinjaVarsAdvancedListener(), tree);


            initialized = true;
        }
    }
}