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

    public void EnterIntOperand([NotNull] NinjaVarsParser.IntOperandContext context)
    {
        
    }

    public void ExitIntOperand([NotNull] NinjaVarsParser.IntOperandContext context)
    {
        
    }

    public void EnterIntTerm([NotNull] NinjaVarsParser.IntTermContext context)
    {
        
    }

    public void ExitIntTerm([NotNull] NinjaVarsParser.IntTermContext context)
    {
        
    }

    public void EnterIntExpr([NotNull] NinjaVarsParser.IntExprContext context)
    {
        
    }

    public void ExitIntExpr([NotNull] NinjaVarsParser.IntExprContext context)
    {
        
    }

    public void EnterIntExprEx([NotNull] NinjaVarsParser.IntExprExContext context)
    {
        
    }

    public void ExitIntExprEx([NotNull] NinjaVarsParser.IntExprExContext context)
    {
        
    }

    public void EnterOperation([NotNull] NinjaVarsParser.OperationContext context)
    {
        
    }

    public void ExitOperation([NotNull] NinjaVarsParser.OperationContext context)
    {
        
    }

    public void EnterDoubleOperand([NotNull] NinjaVarsParser.DoubleOperandContext context)
    {
        
    }

    public void ExitDoubleOperand([NotNull] NinjaVarsParser.DoubleOperandContext context)
    {
        
    }

    public void EnterDoubleTerm([NotNull] NinjaVarsParser.DoubleTermContext context)
    {
        
    }

    public void ExitDoubleTerm([NotNull] NinjaVarsParser.DoubleTermContext context)
    {
        
    }

    public void EnterDoubleExpr([NotNull] NinjaVarsParser.DoubleExprContext context)
    {
        
    }

    public void ExitDoubleExpr([NotNull] NinjaVarsParser.DoubleExprContext context)
    {
        
    }

    public void EnterDoubleExprEx([NotNull] NinjaVarsParser.DoubleExprExContext context)
    {
        
    }

    public void ExitDoubleExprEx([NotNull] NinjaVarsParser.DoubleExprExContext context)
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
}