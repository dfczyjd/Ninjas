//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     ANTLR Version: 4.7.2
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

// Generated from Ninja.g4 by ANTLR 4.7.2

// Unreachable code detected
#pragma warning disable 0162
// The variable '...' is assigned but its value is never used
#pragma warning disable 0219
// Missing XML comment for publicly visible type or member '...'
#pragma warning disable 1591
// Ambiguous reference in cref attribute
#pragma warning disable 419


	#if NOGUI
    	using Interpreter;
    #endif


using Antlr4.Runtime.Misc;
using IErrorNode = Antlr4.Runtime.Tree.IErrorNode;
using ITerminalNode = Antlr4.Runtime.Tree.ITerminalNode;
using IToken = Antlr4.Runtime.IToken;
using ParserRuleContext = Antlr4.Runtime.ParserRuleContext;

/// <summary>
/// This class provides an empty implementation of <see cref="INinjaListener"/>,
/// which can be extended to create a listener which only needs to handle a subset
/// of the available methods.
/// </summary>
[System.CodeDom.Compiler.GeneratedCode("ANTLR", "4.7.2")]
[System.CLSCompliant(false)]
public partial class NinjaBaseListener : INinjaListener {
	/// <summary>
	/// Enter a parse tree produced by <see cref="NinjaParser.program"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void EnterProgram([NotNull] NinjaParser.ProgramContext context) { }
	/// <summary>
	/// Exit a parse tree produced by <see cref="NinjaParser.program"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void ExitProgram([NotNull] NinjaParser.ProgramContext context) { }
	/// <summary>
	/// Enter a parse tree produced by <see cref="NinjaParser.main"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void EnterMain([NotNull] NinjaParser.MainContext context) { }
	/// <summary>
	/// Exit a parse tree produced by <see cref="NinjaParser.main"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void ExitMain([NotNull] NinjaParser.MainContext context) { }
	/// <summary>
	/// Enter a parse tree produced by <see cref="NinjaParser.main_signature"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void EnterMain_signature([NotNull] NinjaParser.Main_signatureContext context) { }
	/// <summary>
	/// Exit a parse tree produced by <see cref="NinjaParser.main_signature"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void ExitMain_signature([NotNull] NinjaParser.Main_signatureContext context) { }
	/// <summary>
	/// Enter a parse tree produced by <see cref="NinjaParser.function"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void EnterFunction([NotNull] NinjaParser.FunctionContext context) { }
	/// <summary>
	/// Exit a parse tree produced by <see cref="NinjaParser.function"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void ExitFunction([NotNull] NinjaParser.FunctionContext context) { }
	/// <summary>
	/// Enter a parse tree produced by <see cref="NinjaParser.v_function"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void EnterV_function([NotNull] NinjaParser.V_functionContext context) { }
	/// <summary>
	/// Exit a parse tree produced by <see cref="NinjaParser.v_function"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void ExitV_function([NotNull] NinjaParser.V_functionContext context) { }
	/// <summary>
	/// Enter a parse tree produced by <see cref="NinjaParser.v_fun_signature"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void EnterV_fun_signature([NotNull] NinjaParser.V_fun_signatureContext context) { }
	/// <summary>
	/// Exit a parse tree produced by <see cref="NinjaParser.v_fun_signature"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void ExitV_fun_signature([NotNull] NinjaParser.V_fun_signatureContext context) { }
	/// <summary>
	/// Enter a parse tree produced by <see cref="NinjaParser.m_function"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void EnterM_function([NotNull] NinjaParser.M_functionContext context) { }
	/// <summary>
	/// Exit a parse tree produced by <see cref="NinjaParser.m_function"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void ExitM_function([NotNull] NinjaParser.M_functionContext context) { }
	/// <summary>
	/// Enter a parse tree produced by <see cref="NinjaParser.m_fun_signature"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void EnterM_fun_signature([NotNull] NinjaParser.M_fun_signatureContext context) { }
	/// <summary>
	/// Exit a parse tree produced by <see cref="NinjaParser.m_fun_signature"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void ExitM_fun_signature([NotNull] NinjaParser.M_fun_signatureContext context) { }
	/// <summary>
	/// Enter a parse tree produced by <see cref="NinjaParser.code"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void EnterCode([NotNull] NinjaParser.CodeContext context) { }
	/// <summary>
	/// Exit a parse tree produced by <see cref="NinjaParser.code"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void ExitCode([NotNull] NinjaParser.CodeContext context) { }
	/// <summary>
	/// Enter a parse tree produced by <see cref="NinjaParser.main_code"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void EnterMain_code([NotNull] NinjaParser.Main_codeContext context) { }
	/// <summary>
	/// Exit a parse tree produced by <see cref="NinjaParser.main_code"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void ExitMain_code([NotNull] NinjaParser.Main_codeContext context) { }
	/// <summary>
	/// Enter a parse tree produced by <see cref="NinjaParser.operation"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void EnterOperation([NotNull] NinjaParser.OperationContext context) { }
	/// <summary>
	/// Exit a parse tree produced by <see cref="NinjaParser.operation"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void ExitOperation([NotNull] NinjaParser.OperationContext context) { }
	/// <summary>
	/// Enter a parse tree produced by <see cref="NinjaParser.method_return"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void EnterMethod_return([NotNull] NinjaParser.Method_returnContext context) { }
	/// <summary>
	/// Exit a parse tree produced by <see cref="NinjaParser.method_return"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void ExitMethod_return([NotNull] NinjaParser.Method_returnContext context) { }
	/// <summary>
	/// Enter a parse tree produced by <see cref="NinjaParser.params"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void EnterParams([NotNull] NinjaParser.ParamsContext context) { }
	/// <summary>
	/// Exit a parse tree produced by <see cref="NinjaParser.params"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void ExitParams([NotNull] NinjaParser.ParamsContext context) { }
	/// <summary>
	/// Enter a parse tree produced by <see cref="NinjaParser.var_signature"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void EnterVar_signature([NotNull] NinjaParser.Var_signatureContext context) { }
	/// <summary>
	/// Exit a parse tree produced by <see cref="NinjaParser.var_signature"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void ExitVar_signature([NotNull] NinjaParser.Var_signatureContext context) { }
	/// <summary>
	/// Enter a parse tree produced by <see cref="NinjaParser.builtin_func_state"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void EnterBuiltin_func_state([NotNull] NinjaParser.Builtin_func_stateContext context) { }
	/// <summary>
	/// Exit a parse tree produced by <see cref="NinjaParser.builtin_func_state"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void ExitBuiltin_func_state([NotNull] NinjaParser.Builtin_func_stateContext context) { }
	/// <summary>
	/// Enter a parse tree produced by <see cref="NinjaParser.builtin_func_p"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void EnterBuiltin_func_p([NotNull] NinjaParser.Builtin_func_pContext context) { }
	/// <summary>
	/// Exit a parse tree produced by <see cref="NinjaParser.builtin_func_p"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void ExitBuiltin_func_p([NotNull] NinjaParser.Builtin_func_pContext context) { }
	/// <summary>
	/// Enter a parse tree produced by <see cref="NinjaParser.builtin_func_e"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void EnterBuiltin_func_e([NotNull] NinjaParser.Builtin_func_eContext context) { }
	/// <summary>
	/// Exit a parse tree produced by <see cref="NinjaParser.builtin_func_e"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void ExitBuiltin_func_e([NotNull] NinjaParser.Builtin_func_eContext context) { }
	/// <summary>
	/// Enter a parse tree produced by <see cref="NinjaParser.call"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void EnterCall([NotNull] NinjaParser.CallContext context) { }
	/// <summary>
	/// Exit a parse tree produced by <see cref="NinjaParser.call"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void ExitCall([NotNull] NinjaParser.CallContext context) { }
	/// <summary>
	/// Enter a parse tree produced by <see cref="NinjaParser.parameterized_call"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void EnterParameterized_call([NotNull] NinjaParser.Parameterized_callContext context) { }
	/// <summary>
	/// Exit a parse tree produced by <see cref="NinjaParser.parameterized_call"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void ExitParameterized_call([NotNull] NinjaParser.Parameterized_callContext context) { }
	/// <summary>
	/// Enter a parse tree produced by <see cref="NinjaParser.simple_call"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void EnterSimple_call([NotNull] NinjaParser.Simple_callContext context) { }
	/// <summary>
	/// Exit a parse tree produced by <see cref="NinjaParser.simple_call"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void ExitSimple_call([NotNull] NinjaParser.Simple_callContext context) { }
	/// <summary>
	/// Enter a parse tree produced by <see cref="NinjaParser.custom_call"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void EnterCustom_call([NotNull] NinjaParser.Custom_callContext context) { }
	/// <summary>
	/// Exit a parse tree produced by <see cref="NinjaParser.custom_call"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void ExitCustom_call([NotNull] NinjaParser.Custom_callContext context) { }
	/// <summary>
	/// Enter a parse tree produced by <see cref="NinjaParser.call_params"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void EnterCall_params([NotNull] NinjaParser.Call_paramsContext context) { }
	/// <summary>
	/// Exit a parse tree produced by <see cref="NinjaParser.call_params"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void ExitCall_params([NotNull] NinjaParser.Call_paramsContext context) { }
	/// <summary>
	/// Enter a parse tree produced by <see cref="NinjaParser.val_or_id"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void EnterVal_or_id([NotNull] NinjaParser.Val_or_idContext context) { }
	/// <summary>
	/// Exit a parse tree produced by <see cref="NinjaParser.val_or_id"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void ExitVal_or_id([NotNull] NinjaParser.Val_or_idContext context) { }
	/// <summary>
	/// Enter a parse tree produced by <see cref="NinjaParser.myif"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void EnterMyif([NotNull] NinjaParser.MyifContext context) { }
	/// <summary>
	/// Exit a parse tree produced by <see cref="NinjaParser.myif"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void ExitMyif([NotNull] NinjaParser.MyifContext context) { }
	/// <summary>
	/// Enter a parse tree produced by <see cref="NinjaParser.myif_short"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void EnterMyif_short([NotNull] NinjaParser.Myif_shortContext context) { }
	/// <summary>
	/// Exit a parse tree produced by <see cref="NinjaParser.myif_short"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void ExitMyif_short([NotNull] NinjaParser.Myif_shortContext context) { }
	/// <summary>
	/// Enter a parse tree produced by <see cref="NinjaParser.mywhile"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void EnterMywhile([NotNull] NinjaParser.MywhileContext context) { }
	/// <summary>
	/// Exit a parse tree produced by <see cref="NinjaParser.mywhile"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void ExitMywhile([NotNull] NinjaParser.MywhileContext context) { }
	/// <summary>
	/// Enter a parse tree produced by <see cref="NinjaParser.mydo_while"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void EnterMydo_while([NotNull] NinjaParser.Mydo_whileContext context) { }
	/// <summary>
	/// Exit a parse tree produced by <see cref="NinjaParser.mydo_while"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void ExitMydo_while([NotNull] NinjaParser.Mydo_whileContext context) { }
	/// <summary>
	/// Enter a parse tree produced by <see cref="NinjaParser.myfor"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void EnterMyfor([NotNull] NinjaParser.MyforContext context) { }
	/// <summary>
	/// Exit a parse tree produced by <see cref="NinjaParser.myfor"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void ExitMyfor([NotNull] NinjaParser.MyforContext context) { }
	/// <summary>
	/// Enter a parse tree produced by <see cref="NinjaParser.ariphOperand"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void EnterAriphOperand([NotNull] NinjaParser.AriphOperandContext context) { }
	/// <summary>
	/// Exit a parse tree produced by <see cref="NinjaParser.ariphOperand"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void ExitAriphOperand([NotNull] NinjaParser.AriphOperandContext context) { }
	/// <summary>
	/// Enter a parse tree produced by <see cref="NinjaParser.ariphTerm"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void EnterAriphTerm([NotNull] NinjaParser.AriphTermContext context) { }
	/// <summary>
	/// Exit a parse tree produced by <see cref="NinjaParser.ariphTerm"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void ExitAriphTerm([NotNull] NinjaParser.AriphTermContext context) { }
	/// <summary>
	/// Enter a parse tree produced by <see cref="NinjaParser.ariphExpr"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void EnterAriphExpr([NotNull] NinjaParser.AriphExprContext context) { }
	/// <summary>
	/// Exit a parse tree produced by <see cref="NinjaParser.ariphExpr"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void ExitAriphExpr([NotNull] NinjaParser.AriphExprContext context) { }
	/// <summary>
	/// Enter a parse tree produced by <see cref="NinjaParser.ariphExprEx"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void EnterAriphExprEx([NotNull] NinjaParser.AriphExprExContext context) { }
	/// <summary>
	/// Exit a parse tree produced by <see cref="NinjaParser.ariphExprEx"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void ExitAriphExprEx([NotNull] NinjaParser.AriphExprExContext context) { }
	/// <summary>
	/// Enter a parse tree produced by <see cref="NinjaParser.boolOperand"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void EnterBoolOperand([NotNull] NinjaParser.BoolOperandContext context) { }
	/// <summary>
	/// Exit a parse tree produced by <see cref="NinjaParser.boolOperand"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void ExitBoolOperand([NotNull] NinjaParser.BoolOperandContext context) { }
	/// <summary>
	/// Enter a parse tree produced by <see cref="NinjaParser.boolExpr"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void EnterBoolExpr([NotNull] NinjaParser.BoolExprContext context) { }
	/// <summary>
	/// Exit a parse tree produced by <see cref="NinjaParser.boolExpr"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void ExitBoolExpr([NotNull] NinjaParser.BoolExprContext context) { }
	/// <summary>
	/// Enter a parse tree produced by <see cref="NinjaParser.boolExprEx"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void EnterBoolExprEx([NotNull] NinjaParser.BoolExprExContext context) { }
	/// <summary>
	/// Exit a parse tree produced by <see cref="NinjaParser.boolExprEx"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void ExitBoolExprEx([NotNull] NinjaParser.BoolExprExContext context) { }
	/// <summary>
	/// Enter a parse tree produced by <see cref="NinjaParser.declare"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void EnterDeclare([NotNull] NinjaParser.DeclareContext context) { }
	/// <summary>
	/// Exit a parse tree produced by <see cref="NinjaParser.declare"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void ExitDeclare([NotNull] NinjaParser.DeclareContext context) { }
	/// <summary>
	/// Enter a parse tree produced by <see cref="NinjaParser.ariphID"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void EnterAriphID([NotNull] NinjaParser.AriphIDContext context) { }
	/// <summary>
	/// Exit a parse tree produced by <see cref="NinjaParser.ariphID"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void ExitAriphID([NotNull] NinjaParser.AriphIDContext context) { }
	/// <summary>
	/// Enter a parse tree produced by <see cref="NinjaParser.trig"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void EnterTrig([NotNull] NinjaParser.TrigContext context) { }
	/// <summary>
	/// Exit a parse tree produced by <see cref="NinjaParser.trig"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void ExitTrig([NotNull] NinjaParser.TrigContext context) { }
	/// <summary>
	/// Enter a parse tree produced by <see cref="NinjaParser.trig2"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void EnterTrig2([NotNull] NinjaParser.Trig2Context context) { }
	/// <summary>
	/// Exit a parse tree produced by <see cref="NinjaParser.trig2"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void ExitTrig2([NotNull] NinjaParser.Trig2Context context) { }
	/// <summary>
	/// Enter a parse tree produced by <see cref="NinjaParser.meaningfulType"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void EnterMeaningfulType([NotNull] NinjaParser.MeaningfulTypeContext context) { }
	/// <summary>
	/// Exit a parse tree produced by <see cref="NinjaParser.meaningfulType"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void ExitMeaningfulType([NotNull] NinjaParser.MeaningfulTypeContext context) { }

	/// <inheritdoc/>
	/// <remarks>The default implementation does nothing.</remarks>
	public virtual void EnterEveryRule([NotNull] ParserRuleContext context) { }
	/// <inheritdoc/>
	/// <remarks>The default implementation does nothing.</remarks>
	public virtual void ExitEveryRule([NotNull] ParserRuleContext context) { }
	/// <inheritdoc/>
	/// <remarks>The default implementation does nothing.</remarks>
	public virtual void VisitTerminal([NotNull] ITerminalNode node) { }
	/// <inheritdoc/>
	/// <remarks>The default implementation does nothing.</remarks>
	public virtual void VisitErrorNode([NotNull] IErrorNode node) { }
}
