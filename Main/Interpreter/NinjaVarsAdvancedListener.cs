using System;
using System.Collections.Generic;
using Antlr4.Runtime;
using Antlr4.Runtime.Misc;
using Antlr4.Runtime.Tree;

public class NinjaVarsAdvancedListener : INinjaVarsListener
{
    public void VisitTerminal(ITerminalNode node)
    {
        Console.WriteLine("terminal node");
        Console.WriteLine(node.Symbol);
    }

    public void VisitErrorNode(IErrorNode node)
    {
        Console.WriteLine("error node");
        Console.WriteLine(node.Symbol);
    }

    public void EnterEveryRule(ParserRuleContext ctx)
    {
        Console.WriteLine("enter rule");
        Console.WriteLine(ctx.ToString());
    }

    public void ExitEveryRule(ParserRuleContext ctx)
    {
        Console.WriteLine("exit rule");
        Console.WriteLine(ctx.ToString());
    }

    public void EnterProgram([NotNull] NinjaVarsParser.ProgramContext context)
    {
        
    }

    public void ExitProgram([NotNull] NinjaVarsParser.ProgramContext context)
    {
        Console.WriteLine("Variables of the program:");
        foreach (var elem in NinjaVarsParser.varTable)
        {
            Console.WriteLine("\t" + elem.Key + " is " + elem.Value.type + " with value " + elem.Value.value);
        }
    }

    public void EnterOperation([NotNull] NinjaVarsParser.OperationContext context)
    {
        
    }

    public void ExitOperation([NotNull] NinjaVarsParser.OperationContext context)
    {
        
    }

    public void EnterBoolOperand([NotNull] NinjaVarsParser.BoolOperandContext context)
    {
        
    }

    public void ExitBoolOperand([NotNull] NinjaVarsParser.BoolOperandContext context)
    {
        
    }

    public void EnterBoolExpr([NotNull] NinjaVarsParser.BoolExprContext context)
    {
        
    }

    public void ExitBoolExpr([NotNull] NinjaVarsParser.BoolExprContext context)
    {
        
    }

    public void EnterBoolExprEx([NotNull] NinjaVarsParser.BoolExprExContext context)
    {
        
    }

    public void ExitBoolExprEx([NotNull] NinjaVarsParser.BoolExprExContext context)
    {
        
    }

    public void EnterDeclare([NotNull] NinjaVarsParser.DeclareContext context)
    {
        
    }

    public void ExitDeclare([NotNull] NinjaVarsParser.DeclareContext context)
    {
        
    }

    public void EnterAriphOperand([NotNull] NinjaVarsParser.AriphOperandContext context)
    {
        
    }

    public void ExitAriphOperand([NotNull] NinjaVarsParser.AriphOperandContext context)
    {
        
    }

    public void EnterAriphTerm([NotNull] NinjaVarsParser.AriphTermContext context)
    {
        
    }

    public void ExitAriphTerm([NotNull] NinjaVarsParser.AriphTermContext context)
    {
        
    }

    public void EnterAriphExpr([NotNull] NinjaVarsParser.AriphExprContext context)
    {
        
    }

    public void ExitAriphExpr([NotNull] NinjaVarsParser.AriphExprContext context)
    {
        
    }

    public void EnterAriphExprEx([NotNull] NinjaVarsParser.AriphExprExContext context)
    {
        
    }

    public void ExitAriphExprEx([NotNull] NinjaVarsParser.AriphExprExContext context)
    {
        
    }
}