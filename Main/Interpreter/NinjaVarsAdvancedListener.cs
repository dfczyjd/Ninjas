using System;
using System.Collections.Generic;
using Antlr4.Runtime;
using Antlr4.Runtime.Misc;
using Antlr4.Runtime.Tree;
using System.IO;

public class NinjaVarsAdvancedListener : INinjaVarsListener
{
    ArrayList<byte> _bytes = new ArrayList<byte>();

    string ParamListToString(ArrayList<NinjaVarsParser.ParamData> list)
    {
        string s = "{";
        foreach (var data in list)
        {
            if (data.paramType == NinjaVarsParser.ParamType.Pass)
            {
                s += $" {data.type} {data.value},";
            }
            else
            {
                s += $" {data.type} {data.name} = {data.value},";
            }
        }

        s = (s.Length > 1 ? s.Substring(0, s.Length - 1) : s) + " }";
        return s;
    }

    public void VisitTerminal(ITerminalNode node)
    {
        
    }

    public void VisitErrorNode(IErrorNode node)
    {
        Console.WriteLine("error node==================");
        Console.WriteLine(node.Symbol);
    }

    public void EnterEveryRule(ParserRuleContext ctx)
    {
        
    }

    public void ExitEveryRule(ParserRuleContext ctx)
    {
        
    }

    public void EnterProgram([NotNull] NinjaVarsParser.ProgramContext context)
    {
        
    }

    public void GoThroughCalls(NinjaVarsParser.MethodData methodData)
    {
        string formatter = new string('\t', depth);
        Console.WriteLine($"{formatter}--Entering method {methodData.name}, params {ParamListToString(methodData.paramList)}:");
        foreach (var call in methodData.callList)
        {
            if (call.callType == NinjaVarsParser.CallType.Custom)
            {
                if (NinjaVarsParser.metTable.ContainsKey(call.name) && CheckParams(call, NinjaVarsParser.metTable[call.name]))
                {
                    ++depth;
                    GoThroughCalls(NinjaVarsParser.metTable[call.name]);
                }
            }
            else
            {
                Console.WriteLine($"{formatter}Calling builtin method {call.name} with params {ParamListToString(call.paramList)}");
                //					Console.WriteLine(call.name);
                switch (call.name)
                {
                    case "move":
                        //							Console.WriteLine($"move byte");
                        _bytes.Add(1);
                        break;
                    case "turn":
                        //							Console.WriteLine("turn byte");
                        _bytes.Add(2);
                        break;
                    case "hit":
                        //							Console.WriteLine($"hit byte");
                        _bytes.Add(3);
                        break;
                    case "shoot":
                        //							Console.WriteLine($"shoot byte");
                        _bytes.Add(4);
                        break;
                    default:
                        Console.WriteLine($"no byte for this op {call.name}");
                        break;
                }
            }
        }

        if (methodData.isMeaningful)
        {
            Console.WriteLine($"{formatter}Returning {methodData.returnValue} of type {methodData.returnType}");
        }
        --depth;
        Console.WriteLine($"{formatter}--Exiting method {methodData.name}");
    }

    public bool CheckParams(NinjaVarsParser.CallData call, NinjaVarsParser.MethodData method)
    {
        if (call.paramList.Count != method.paramList.Count)
        {
            return false;
        }

        for (int i = 0; i < call.paramList.Count; i++)
        {

            if (call.paramList[i].type == method.paramList[i].type)
            {
                method.paramList[i].value = call.paramList[i].value;
            }
            else
            {
                Console.WriteLine($"Type mismatch: expected {method.paramList[i].type}, found {call.paramList[i].type} with value {call.paramList[i].value}");
                return false;
            }
        }

        return true;
    }

    private int depth = 0;

    public void ExitProgram([NotNull] NinjaVarsParser.ProgramContext context)
    {
        Console.WriteLine("---------------------------------------------------End");

        GoThroughCalls(NinjaVarsParser.metTable["main"]);
        File.Delete("cmds.txt");
        var stream = File.Create("cmds.txt");
        stream.WriteByte((byte)_bytes.Count);
        foreach (var b in _bytes)
        {
            stream.WriteByte(b);
        }

        stream.Close();
        Console.WriteLine("Variables of the program:");
        foreach (var elem in NinjaVarsParser.varTable)
        {
            Console.WriteLine("\t" + elem.Key + " is " + elem.Value.type + " with value " + elem.Value.value);
        }
    }

    public void EnterMain([NotNull] NinjaVarsParser.MainContext context)
    {
        
    }

    public void ExitMain([NotNull] NinjaVarsParser.MainContext context)
    {
        
    }

    public void EnterMain_signature([NotNull] NinjaVarsParser.Main_signatureContext context)
    {
        
    }

    public void ExitMain_signature([NotNull] NinjaVarsParser.Main_signatureContext context)
    {
        
    }

    public void EnterFunction([NotNull] NinjaVarsParser.FunctionContext context)
    {
        
    }

    public void ExitFunction([NotNull] NinjaVarsParser.FunctionContext context)
    {
        
    }

    public void EnterV_function([NotNull] NinjaVarsParser.V_functionContext context)
    {
        
    }

    public void ExitV_function([NotNull] NinjaVarsParser.V_functionContext context)
    {
        
    }

    public void EnterV_fun_signature([NotNull] NinjaVarsParser.V_fun_signatureContext context)
    {
        
    }

    public void ExitV_fun_signature([NotNull] NinjaVarsParser.V_fun_signatureContext context)
    {
        
    }

    public void EnterM_function([NotNull] NinjaVarsParser.M_functionContext context)
    {
        
    }

    public void ExitM_function([NotNull] NinjaVarsParser.M_functionContext context)
    {
        
    }

    public void EnterM_fun_signature([NotNull] NinjaVarsParser.M_fun_signatureContext context)
    {
        
    }

    public void ExitM_fun_signature([NotNull] NinjaVarsParser.M_fun_signatureContext context)
    {
        
    }

    public void EnterCode([NotNull] NinjaVarsParser.CodeContext context)
    {
        
    }

    public void ExitCode([NotNull] NinjaVarsParser.CodeContext context)
    {
        
    }

    public void EnterMain_code([NotNull] NinjaVarsParser.Main_codeContext context)
    {
        
    }

    public void ExitMain_code([NotNull] NinjaVarsParser.Main_codeContext context)
    {
        
    }

    public void EnterMethod_return([NotNull] NinjaVarsParser.Method_returnContext context)
    {
        
    }

    public void ExitMethod_return([NotNull] NinjaVarsParser.Method_returnContext context)
    {
        
    }

    public void EnterParams([NotNull] NinjaVarsParser.ParamsContext context)
    {
        
    }

    public void ExitParams([NotNull] NinjaVarsParser.ParamsContext context)
    {
        
    }

    public void EnterVar_signature([NotNull] NinjaVarsParser.Var_signatureContext context)
    {
        
    }

    public void ExitVar_signature([NotNull] NinjaVarsParser.Var_signatureContext context)
    {
        
    }

    public void EnterBuiltin_func_p([NotNull] NinjaVarsParser.Builtin_func_pContext context)
    {
        
    }

    public void ExitBuiltin_func_p([NotNull] NinjaVarsParser.Builtin_func_pContext context)
    {
        
    }

    public void EnterBuiltin_func_e([NotNull] NinjaVarsParser.Builtin_func_eContext context)
    {
        
    }

    public void ExitBuiltin_func_e([NotNull] NinjaVarsParser.Builtin_func_eContext context)
    {
        
    }

    public void EnterCall([NotNull] NinjaVarsParser.CallContext context)
    {
        
    }

    public void ExitCall([NotNull] NinjaVarsParser.CallContext context)
    {
        
    }

    public void EnterParameterized_call([NotNull] NinjaVarsParser.Parameterized_callContext context)
    {
        
    }

    public void ExitParameterized_call([NotNull] NinjaVarsParser.Parameterized_callContext context)
    {
        
    }

    public void EnterSimple_call([NotNull] NinjaVarsParser.Simple_callContext context)
    {
        
    }

    public void ExitSimple_call([NotNull] NinjaVarsParser.Simple_callContext context)
    {
        
    }

    public void EnterCustom_call([NotNull] NinjaVarsParser.Custom_callContext context)
    {
        
    }

    public void ExitCustom_call([NotNull] NinjaVarsParser.Custom_callContext context)
    {
        
    }

    public void EnterCall_params([NotNull] NinjaVarsParser.Call_paramsContext context)
    {
        
    }

    public void ExitCall_params([NotNull] NinjaVarsParser.Call_paramsContext context)
    {
        
    }

    public void EnterVal_or_id([NotNull] NinjaVarsParser.Val_or_idContext context)
    {
        
    }

    public void ExitVal_or_id([NotNull] NinjaVarsParser.Val_or_idContext context)
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

    public void EnterMeaningfulType([NotNull] NinjaVarsParser.MeaningfulTypeContext context)
    {
        
    }

    public void ExitMeaningfulType([NotNull] NinjaVarsParser.MeaningfulTypeContext context)
    {
        
    }

    public void EnterOperation([NotNull] NinjaVarsParser.OperationContext context)
    {
        
    }

    public void ExitOperation([NotNull] NinjaVarsParser.OperationContext context)
    {
        
    }

    public void EnterMyif([NotNull] NinjaVarsParser.MyifContext context)
    {
        
    }

    public void ExitMyif([NotNull] NinjaVarsParser.MyifContext context)
    {
        
    }

    public void EnterMyif_short([NotNull] NinjaVarsParser.Myif_shortContext context)
    {
        
    }

    public void ExitMyif_short([NotNull] NinjaVarsParser.Myif_shortContext context)
    {
        
    }

    public void EnterMywhile([NotNull] NinjaVarsParser.MywhileContext context)
    {
        
    }

    public void ExitMywhile([NotNull] NinjaVarsParser.MywhileContext context)
    {
        
    }

    public void EnterMydo_while([NotNull] NinjaVarsParser.Mydo_whileContext context)
    {
        
    }

    public void ExitMydo_while([NotNull] NinjaVarsParser.Mydo_whileContext context)
    {
        
    }

    public void EnterMyfor([NotNull] NinjaVarsParser.MyforContext context)
    {
        
    }

    public void ExitMyfor([NotNull] NinjaVarsParser.MyforContext context)
    {
        
    }

    public void EnterSin([NotNull] NinjaVarsParser.SinContext context)
    {
        
    }

    public void ExitSin([NotNull] NinjaVarsParser.SinContext context)
    {
        
    }

    public void EnterCos([NotNull] NinjaVarsParser.CosContext context)
    {
        
    }

    public void ExitCos([NotNull] NinjaVarsParser.CosContext context)
    {
        
    }

    public void EnterTan([NotNull] NinjaVarsParser.TanContext context)
    {
        
    }

    public void ExitTan([NotNull] NinjaVarsParser.TanContext context)
    {
        
    }

    public void EnterAsin([NotNull] NinjaVarsParser.AsinContext context)
    {
        
    }

    public void ExitAsin([NotNull] NinjaVarsParser.AsinContext context)
    {
        
    }

    public void EnterAcos([NotNull] NinjaVarsParser.AcosContext context)
    {
        
    }

    public void ExitAcos([NotNull] NinjaVarsParser.AcosContext context)
    {
        
    }

    public void EnterAtan([NotNull] NinjaVarsParser.AtanContext context)
    {
        
    }

    public void ExitAtan([NotNull] NinjaVarsParser.AtanContext context)
    {
        
    }

    public void EnterAtan2([NotNull] NinjaVarsParser.Atan2Context context)
    {
        
    }

    public void ExitAtan2([NotNull] NinjaVarsParser.Atan2Context context)
    {
        
    }
}