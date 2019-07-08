//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     ANTLR Version: 4.7.2
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

// Generated from NinjaVars.g4 by ANTLR 4.7.2

// Unreachable code detected
#pragma warning disable 0162
// The variable '...' is assigned but its value is never used
#pragma warning disable 0219
// Missing XML comment for publicly visible type or member '...'
#pragma warning disable 1591
// Ambiguous reference in cref attribute
#pragma warning disable 419


    


using Antlr4.Runtime.Misc;
using IErrorNode = Antlr4.Runtime.Tree.IErrorNode;
using ITerminalNode = Antlr4.Runtime.Tree.ITerminalNode;
using IToken = Antlr4.Runtime.IToken;
using ParserRuleContext = Antlr4.Runtime.ParserRuleContext;

/// <summary>
/// This class provides an empty implementation of <see cref="INinjaVarsListener"/>,
/// which can be extended to create a listener which only needs to handle a subset
/// of the available methods.
/// </summary>
[System.CodeDom.Compiler.GeneratedCode("ANTLR", "4.7.2")]
[System.CLSCompliant(false)]
public partial class NinjaVarsBaseListener : INinjaVarsListener {
	/// <summary>
	/// Enter a parse tree produced by <see cref="NinjaVarsParser.program"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void EnterProgram([NotNull] NinjaVarsParser.ProgramContext context) { }
	/// <summary>
	/// Exit a parse tree produced by <see cref="NinjaVarsParser.program"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void ExitProgram([NotNull] NinjaVarsParser.ProgramContext context) { }
	/// <summary>
	/// Enter a parse tree produced by <see cref="NinjaVarsParser.operation"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void EnterOperation([NotNull] NinjaVarsParser.OperationContext context) { }
	/// <summary>
	/// Exit a parse tree produced by <see cref="NinjaVarsParser.operation"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void ExitOperation([NotNull] NinjaVarsParser.OperationContext context) { }
	/// <summary>
	/// Enter a parse tree produced by <see cref="NinjaVarsParser.ariphOperand"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void EnterAriphOperand([NotNull] NinjaVarsParser.AriphOperandContext context) { }
	/// <summary>
	/// Exit a parse tree produced by <see cref="NinjaVarsParser.ariphOperand"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void ExitAriphOperand([NotNull] NinjaVarsParser.AriphOperandContext context) { }
	/// <summary>
	/// Enter a parse tree produced by <see cref="NinjaVarsParser.ariphTerm"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void EnterAriphTerm([NotNull] NinjaVarsParser.AriphTermContext context) { }
	/// <summary>
	/// Exit a parse tree produced by <see cref="NinjaVarsParser.ariphTerm"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void ExitAriphTerm([NotNull] NinjaVarsParser.AriphTermContext context) { }
	/// <summary>
	/// Enter a parse tree produced by <see cref="NinjaVarsParser.ariphExpr"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void EnterAriphExpr([NotNull] NinjaVarsParser.AriphExprContext context) { }
	/// <summary>
	/// Exit a parse tree produced by <see cref="NinjaVarsParser.ariphExpr"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void ExitAriphExpr([NotNull] NinjaVarsParser.AriphExprContext context) { }
	/// <summary>
	/// Enter a parse tree produced by <see cref="NinjaVarsParser.ariphExprEx"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void EnterAriphExprEx([NotNull] NinjaVarsParser.AriphExprExContext context) { }
	/// <summary>
	/// Exit a parse tree produced by <see cref="NinjaVarsParser.ariphExprEx"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void ExitAriphExprEx([NotNull] NinjaVarsParser.AriphExprExContext context) { }
	/// <summary>
	/// Enter a parse tree produced by <see cref="NinjaVarsParser.boolOperand"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void EnterBoolOperand([NotNull] NinjaVarsParser.BoolOperandContext context) { }
	/// <summary>
	/// Exit a parse tree produced by <see cref="NinjaVarsParser.boolOperand"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void ExitBoolOperand([NotNull] NinjaVarsParser.BoolOperandContext context) { }
	/// <summary>
	/// Enter a parse tree produced by <see cref="NinjaVarsParser.boolExpr"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void EnterBoolExpr([NotNull] NinjaVarsParser.BoolExprContext context) { }
	/// <summary>
	/// Exit a parse tree produced by <see cref="NinjaVarsParser.boolExpr"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void ExitBoolExpr([NotNull] NinjaVarsParser.BoolExprContext context) { }
	/// <summary>
	/// Enter a parse tree produced by <see cref="NinjaVarsParser.boolExprEx"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void EnterBoolExprEx([NotNull] NinjaVarsParser.BoolExprExContext context) { }
	/// <summary>
	/// Exit a parse tree produced by <see cref="NinjaVarsParser.boolExprEx"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void ExitBoolExprEx([NotNull] NinjaVarsParser.BoolExprExContext context) { }
	/// <summary>
	/// Enter a parse tree produced by <see cref="NinjaVarsParser.declare"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void EnterDeclare([NotNull] NinjaVarsParser.DeclareContext context) { }
	/// <summary>
	/// Exit a parse tree produced by <see cref="NinjaVarsParser.declare"/>.
	/// <para>The default implementation does nothing.</para>
	/// </summary>
	/// <param name="context">The parse tree.</param>
	public virtual void ExitDeclare([NotNull] NinjaVarsParser.DeclareContext context) { }

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
