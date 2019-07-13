using System;
using System.IO;
using Antlr4.Runtime;
using Antlr4.Runtime.Misc;
using Antlr4.Runtime.Tree;

namespace Interpreter
{
	public class NinjaAdvancedListener : INinjaListener
	{
		ArrayList<byte> _bytes = new ArrayList<byte>();

		string ParamListToString(ArrayList<NinjaParser.ParamData> list)
		{
			string s = "{";
			foreach (var data in list)
			{
				if (data.paramType == NinjaParser.ParamType.Pass)
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
//			if (isCode)
//			{
//
//				switch (node.Symbol.Text.Substring(0, node.Symbol.Text.IndexOf("(")))
//				{
//					case "move":
//						Console.WriteLine($"move byte");
//						_bytes.Add(1);		
//						break;
//					case "turn" :
//						Console.WriteLine($"turn byte");
//						_bytes.Add(2);		
//						break;
//					default:
//						Console.WriteLine($"no byte for this op {node.Symbol.Text}");
//						break;
//				}
//				
//				
//			}
//			
//			Console.WriteLine("terminal node");
//			Console.WriteLine(node.Symbol);
		}

		public void VisitErrorNode(IErrorNode node)
		{
			Console.WriteLine("error node==================");
			Console.WriteLine(node.Symbol);
		}

		public void EnterEveryRule(ParserRuleContext ctx)
		{
//			Console.WriteLine("enter rule");
//			Console.WriteLine(ctx.ToString());
		}

		public void ExitEveryRule(ParserRuleContext ctx)
		{
//			Console.WriteLine("exit rule");
//			Console.WriteLine(ctx.ToString());
		}

		public void EnterProgram(NinjaParser.ProgramContext context)
		{
			Console.WriteLine("---------------------------------------------------Start");
//			Console.WriteLine("ent pr");
//			Console.WriteLine(context.ToString());
		}

		public bool CheckParams(NinjaParser.CallData call, NinjaParser.MethodData method)
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

		public void ExitProgram(NinjaParser.ProgramContext context)
		{
			Console.WriteLine("---------------------------------------------------End");

			//GoThroughCalls(NinjaParser.metTable["main"]);
			File.Delete("cmds.txt");
			var stream = File.Create("cmds.txt");
			stream.WriteByte((byte) _bytes.Count);
			foreach (var b in _bytes)
			{
				stream.WriteByte(b);
			}

			stream.Close();

//            Console.WriteLine("Variables of the program:");
//            foreach (var elem in NinjaParser.metTable["main"].varTable)
//            {
//                Console.WriteLine("\t" + elem.Key + " is " + elem.Value.type + " with value " + elem.Value.value);
//            }
        }

		public void EnterMain(NinjaParser.MainContext context)
		{
			Console.WriteLine("ent main");
			Console.WriteLine(context.ToString());
		}
		
		public void ExitMain(NinjaParser.MainContext context)
		{
			Console.WriteLine("ext main");
			Console.WriteLine(context.ToString());
		}

		public void EnterMain_signature(NinjaParser.Main_signatureContext context)
		{
//			Console.WriteLine("ent main_sig");
//			Console.WriteLine(context.ToString());
		}

		public void ExitMain_signature(NinjaParser.Main_signatureContext context)
		{
//			Console.WriteLine("ext main_sig");
//			Console.WriteLine(context.ToString());
		}

		public void EnterFunction(NinjaParser.FunctionContext context)
		{
//			Console.WriteLine("ent fun");
//			Console.WriteLine(context.ToString());
		}

		public void ExitFunction(NinjaParser.FunctionContext context)
		{
//			Console.WriteLine("ext fun");
//			Console.WriteLine(context.ToString());
		}

		public void EnterV_function(NinjaParser.V_functionContext context)
		{
//			Console.WriteLine("ent v_fun");
//			Console.WriteLine(context.ToString());
		}

		public void ExitV_function(NinjaParser.V_functionContext context)
		{
//			Console.WriteLine("ext v_fun");
//			Console.WriteLine(context.ToString());
		}

		public void EnterV_fun_signature(NinjaParser.V_fun_signatureContext context)
		{
//			Console.WriteLine("ent v_fun_sig");
//			Console.WriteLine(data.ToString());
		}

		public void ExitV_fun_signature(NinjaParser.V_fun_signatureContext context)
		{
//			Console.WriteLine("ext v_fun_sig");
//			Console.WriteLine(context.ToString());
		}

		public void EnterM_function(NinjaParser.M_functionContext context)
		{
//			Console.WriteLine("ent m_fun");
//			Console.WriteLine(context.ToString());
		}

		public void ExitM_function(NinjaParser.M_functionContext context)
		{
//			Console.WriteLine("ext m_fun");
//			Console.WriteLine(context.ToString());
		}

		public void EnterM_fun_signature(NinjaParser.M_fun_signatureContext context)
		{
//			Console.WriteLine("ent m_fun_sig");
//			Console.WriteLine(context.ToString());
		}

		public void ExitM_fun_signature(NinjaParser.M_fun_signatureContext context)
		{
//			Console.WriteLine("ext m_fun_sig");
//			Console.WriteLine(context.ToString());
		}

		public void EnterCode(NinjaParser.CodeContext context)
		{
//			Console.WriteLine("ent code");
//			Console.WriteLine(context.ToString());
		}

        public void ExitCode([NotNull] NinjaParser.CodeContext context)
        {
            
        }

        public void EnterMain_code([NotNull] NinjaParser.Main_codeContext context)
        {
            
        }

        public void ExitMain_code([NotNull] NinjaParser.Main_codeContext context)
        {
            
        }

        public void EnterOperation([NotNull] NinjaParser.OperationContext context)
        {
            
        }

        public void ExitOperation([NotNull] NinjaParser.OperationContext context)
        {
            
        }

        public void EnterMethod_return([NotNull] NinjaParser.Method_returnContext context)
        {
            
        }

        public void ExitMethod_return([NotNull] NinjaParser.Method_returnContext context)
        {
            
        }

        public void EnterParams([NotNull] NinjaParser.ParamsContext context)
        {
            
        }

        public void ExitParams([NotNull] NinjaParser.ParamsContext context)
        {
            
        }

        public void EnterVar_signature([NotNull] NinjaParser.Var_signatureContext context)
        {
            
        }

        public void ExitVar_signature([NotNull] NinjaParser.Var_signatureContext context)
        {
            
        }

        public void EnterBuiltin_func_state(NinjaParser.Builtin_func_stateContext context)
        {
	        
        }

        public void ExitBuiltin_func_state(NinjaParser.Builtin_func_stateContext context)
        {
	        
        }

        public void EnterBuiltin_func_p([NotNull] NinjaParser.Builtin_func_pContext context)
        {
            
        }

        public void ExitBuiltin_func_p([NotNull] NinjaParser.Builtin_func_pContext context)
        {
            
        }

        public void EnterBuiltin_func_e([NotNull] NinjaParser.Builtin_func_eContext context)
        {
            
        }

        public void ExitBuiltin_func_e([NotNull] NinjaParser.Builtin_func_eContext context)
        {
            
        }

        public void EnterCall([NotNull] NinjaParser.CallContext context)
        {
            
        }

        public void ExitCall([NotNull] NinjaParser.CallContext context)
        {
            
        }

        public void EnterParameterized_call([NotNull] NinjaParser.Parameterized_callContext context)
        {
            
        }

        public void ExitParameterized_call([NotNull] NinjaParser.Parameterized_callContext context)
        {
            
        }

        public void EnterSimple_call([NotNull] NinjaParser.Simple_callContext context)
        {
            
        }

        public void ExitSimple_call([NotNull] NinjaParser.Simple_callContext context)
        {
            
        }

        public void EnterCustom_call([NotNull] NinjaParser.Custom_callContext context)
        {
            
        }

        public void ExitCustom_call([NotNull] NinjaParser.Custom_callContext context)
        {
            
        }

        public void EnterCall_params([NotNull] NinjaParser.Call_paramsContext context)
        {
            
        }

        public void ExitCall_params([NotNull] NinjaParser.Call_paramsContext context)
        {
            
        }

        public void EnterVal_or_id([NotNull] NinjaParser.Val_or_idContext context)
        {
            
        }

        public void ExitVal_or_id([NotNull] NinjaParser.Val_or_idContext context)
        {
            
        }

        public void EnterAriphOperand([NotNull] NinjaParser.AriphOperandContext context)
        {
            
        }

        public void ExitAriphOperand([NotNull] NinjaParser.AriphOperandContext context)
        {
            
        }

        public void EnterAriphTerm([NotNull] NinjaParser.AriphTermContext context)
        {
            
        }

        public void ExitAriphTerm([NotNull] NinjaParser.AriphTermContext context)
        {
            
        }

        public void EnterAriphExpr([NotNull] NinjaParser.AriphExprContext context)
        {
            
        }

        public void ExitAriphExpr([NotNull] NinjaParser.AriphExprContext context)
        {
            
        }

        public void EnterAriphExprEx([NotNull] NinjaParser.AriphExprExContext context)
        {
            
        }

        public void ExitAriphExprEx([NotNull] NinjaParser.AriphExprExContext context)
        {
            
        }

        public void EnterBoolOperand([NotNull] NinjaParser.BoolOperandContext context)
        {
            
        }

        public void ExitBoolOperand([NotNull] NinjaParser.BoolOperandContext context)
        {
            
        }

        public void EnterBoolExpr([NotNull] NinjaParser.BoolExprContext context)
        {
            
        }

        public void ExitBoolExpr([NotNull] NinjaParser.BoolExprContext context)
        {
            
        }

        public void EnterBoolExprEx([NotNull] NinjaParser.BoolExprExContext context)
        {
            
        }

        public void ExitBoolExprEx([NotNull] NinjaParser.BoolExprExContext context)
        {
            
        }

        public void EnterDeclare([NotNull] NinjaParser.DeclareContext context)
        {
            
        }

        public void ExitDeclare([NotNull] NinjaParser.DeclareContext context)
        {
            
        }

        public void EnterAriphID([NotNull] NinjaParser.AriphIDContext context)
        {
            
        }

        public void ExitAriphID([NotNull] NinjaParser.AriphIDContext context)
        {
            
        }
        
        public void EnterMyif([NotNull] NinjaParser.MyifContext context)
        {
            
        }

        public void ExitMyif([NotNull] NinjaParser.MyifContext context)
        {
            
        }

        public void EnterMyif_short([NotNull] NinjaParser.Myif_shortContext context)
        {
            
        }

        public void ExitMyif_short([NotNull] NinjaParser.Myif_shortContext context)
        {
            
        }

        public void EnterMywhile([NotNull] NinjaParser.MywhileContext context)
        {
            
        }

        public void ExitMywhile([NotNull] NinjaParser.MywhileContext context)
        {
            
        }

        public void EnterMydo_while([NotNull] NinjaParser.Mydo_whileContext context)
        {
            
        }

        public void ExitMydo_while([NotNull] NinjaParser.Mydo_whileContext context)
        {
            
        }

        public void EnterMyfor([NotNull] NinjaParser.MyforContext context)
        {
            
        }

        public void ExitMyfor([NotNull] NinjaParser.MyforContext context)
        {
            
        }

        public void EnterMeaningfulType([NotNull] NinjaParser.MeaningfulTypeContext context)
        {
            
        }

        public void ExitMeaningfulType([NotNull] NinjaParser.MeaningfulTypeContext context)
        {
            
        }

        public void EnterTrig([NotNull] NinjaParser.TrigContext context)
        {
            
        }

        public void ExitTrig([NotNull] NinjaParser.TrigContext context)
        {
            
        }

        public void EnterTrig2([NotNull] NinjaParser.Trig2Context context)
        {
            
        }

        public void ExitTrig2([NotNull] NinjaParser.Trig2Context context)
        {
            
        }
    }
}