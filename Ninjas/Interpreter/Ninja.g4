grammar Ninja;

options {
	language=CSharp ;
}

@parser::members 
{
	public enum ParamType
	{
		Receive, Pass
	};

	public enum CallType
	{
		BuiltIn, Custom
	};
	
	public enum VarType
    {
    	Int, Double, Bool
    };
    
    public enum ReturnType
    {
    	Int, Double, Bool, Void
    };

	public class ParamData
	{
		
        public string name;
        
        public dynamic value;
	
		public VarType type;	
		
		public ParamType paramType = ParamType.Receive;	
	
		public override string ToString()
        {
            return $"param {type} {name}";
        }
	}
	
	public class VarData
    {
        public string name;
        public VarType type;
        public dynamic value;
        
    }

    public class MethodData : Block
    {
        public string name;
		public bool isMeaningful;
        public ReturnType returnType;
        public ArrayList<NinjaParser.ParamData> paramList = new ArrayList<NinjaParser.ParamData>();
        
		public dynamic returnValue;
		
		public override void Eval()
        {
        	curBlock = this;
        	Debug($"===Entering fun {name} with params {ParamListToString(paramList)}");
            foreach(var sm in operations)
            {
            	sm.Eval();
            }
            
            Debug($"---Vars of block met {name} ----");	
            foreach (var elem in varTable)
            {
                Console.WriteLine("\t" + elem.Key + " is " + elem.Value.type + " with value " + elem.Value.value);
            }
            Debug($"---End Vars of block met {name} ----");
            Debug($"===Exiting fun {name}");	
        	
        }
        
        public override string ToString()
        {
        	return $"fun {returnType} {name}, params : {paramList} ";
        }
    }
 
 	public static Dictionary<string, VarData> varTable = new Dictionary<string, VarData>();
    public static Dictionary<string, MethodData> metTable = new Dictionary<string, MethodData>();
    int depth = 0;
    static string currentMet = "?";
    
    public static void Debug(string line)
    {
        Console.WriteLine(line);
    }
    
    public static void Error(string message)
    {
        ConsoleColor curr = Console.ForegroundColor;
        Console.ForegroundColor = ConsoleColor.Red;
        Console.WriteLine(message);
        Console.ForegroundColor = curr;
    }
    
    public static bool CheckType(Type t, VarType vt)
    {
    	if(t.ToString().ToLower().Contains("bool") && vt.ToString().ToLower().Contains("bool"))
    		return true;
    	if(t.ToString().ToLower().Contains("int") && vt.ToString().ToLower().Contains("int"))
            return true;
        if(t.ToString().ToLower().Contains("double") && vt.ToString().ToLower().Contains("double"))
            return true;
        return false;        	
    }
	
	public static bool CheckParams(NinjaParser.CallData call, NinjaParser.MethodData method)
    {
    	Console.WriteLine($"Checking params of {call.name}");
    	if (call.paramList.Count != method.paramList.Count)
    	{
    		Console.WriteLine($"Expected params {method.paramList.Count}, found {call.paramList.Count}");
    		return false;
    	}
    
    	for (int i = 0; i < call.paramList.Count; i++)
    	{
    		var r = call.paramList[i].value;//.Eval();		
    		//if (call.paramList[i].type == method.paramList[i].type)
    		if (CheckType(r.GetType(), method.paramList[i].type))
    		{
    			method.paramList[i].value = r;
    			method.varTable[method.paramList[i].name].value = r;
    			Console.WriteLine($"Param \"{method.paramList[i].name}\" of type {method.paramList[i].type} with val {call.paramList[i].value}");
    		}
    		else
    		{
    			Console.WriteLine($"Type mismatch: expected {method.paramList[i].type}, found {call.paramList[i].type} with value {call.paramList[i].value}");
    			return false;
    		}
    	}
    
    	return true;
    }
            		
	static ArrayList<byte> _bytes = new ArrayList<byte>();
	
	static string ParamListToString(ArrayList<NinjaParser.ParamData> list)
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
	
	public class Block
	{
		public List<OperationClass> operations = new List<OperationClass>();
		public Dictionary<string, VarData> varTable = new Dictionary<string, VarData>();
		
		public Block Parent;
		
		public virtual void Eval()
		{
			for (int i = 0; i < operations.Count; ++i)
				operations[i].Eval();
		}
		
		public OperationClass createOperationClass()
		{
			operations.Add(new OperationClass());
			return operations[operations.Count - 1];
		}
		
		public ExprClass ToExpr()
		{
			int lastInd = operations.Count - 1;
			var res = new ExprClass(operations[lastInd]);
			operations[lastInd] = res;
			return res;
		}
	}
	
	public class CallData : OperationClass
	{
		public string name;
			
		public dynamic value;
			
		public CallType callType;
		
		public ReturnType returnType;
		
		public Block parent;
			
		public ArrayList<NinjaParser.ParamData> paramList = new ArrayList<NinjaParser.ParamData>();
		
		public override dynamic Eval()
		{
			if (callType == NinjaParser.CallType.Custom)
			{
				if (NinjaParser.metTable.ContainsKey(name) && CheckParams(this, NinjaParser.metTable[name]))
				{
					
					NinjaParser.metTable[name].Eval();
					var ret = NinjaParser.metTable[name].returnValue.Eval();
					curBlock = parent;
					return ret;
					
				}
			}
			else
			{
				Console.WriteLine($"Calling builtin method {name} with params {ParamListToString(paramList)}");
				//					Console.WriteLine(call.name);
				switch (name)
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
						Console.WriteLine($"no byte for this op {name}");
						break;
				}
			}
			return null;
		}
	}
	
	public static Block curBlock = new Block();
	
	public class OperationClass
	{
		public OperationClass()
		{
			
		}
		
		public OperationClass(OperationClass op)
		{
			
		}
		
		public virtual dynamic Eval()
		{
			throw new NotImplementedException("OperationClass class is abstract");
		}
	}
    
	public enum ObjType
	{
		Number, Logic, Var, Operation, Function
	}

	public class ExprStackObject
	{
		public ObjType type;
		public dynamic value;
		
		public ExprStackObject(): this(0) { }
		
		public ExprStackObject(double value)
		{
			type = ObjType.Number;
			this.value = value;
		}

		public ExprStackObject(int value)
		{
			type = ObjType.Number;
			this.value = value;
		}
		
		public ExprStackObject(bool value)
		{
			type = ObjType.Number;
			this.value = value;
		}
		
		public dynamic Calc()
		{
			if (type == ObjType.Number)
				return value;
			if (type == ObjType.Var)
				return curBlock.varTable[value].value;
			Error("\"" + value + "\" is an operation");
			return null;
		}
	}
	
	public class ExprClass : OperationClass
	{
		public List<ExprStackObject> exprStack;
		
		public ExprClass(OperationClass parent) : base(parent)
		{
			exprStack = new List<ExprStackObject>();
			//curBlock.operations.Add(this);
		}
		
		public void Push(ExprStackObject value)
		{
			exprStack.Add(value);
		}
		
		public ExprStackObject Pop(List<ExprStackObject> vals)
		{
			var res = vals[vals.Count - 1];
			vals.RemoveAt(vals.Count - 1);
			return res;
		}
		
		public dynamic value;
		
		public override dynamic Eval()
		{
			string s = "";
			foreach(var v in exprStack)
			{
				s += v.value;
			}
			Debug($"Evaluating {s}");
			List<ExprStackObject> stack = new List<ExprStackObject>();
			foreach (var elem in exprStack)
			{
				if (elem.type == ObjType.Number || elem.type == ObjType.Var)
					stack.Add(elem);
				else if (elem.type == ObjType.Function)
				{
					ArrayList<ParamData> pars = elem.value.paramList;
					for (int i = 0; i < pars.Count; ++i)
					{
						dynamic val = Pop(stack);
						val.Calc();
						pars[i].value = val.value;
					}
					var result = elem.value.Eval();
					stack.Add(new ExprStackObject(result));
				}
				else
				{
					ExprStackObject left, right;
					switch (elem.value)
					{
						case "&&":
							right = Pop(stack);
							left = Pop(stack);
							stack.Add(new ExprStackObject(left.Calc() && right.Calc()));
							break;
						
						case "||":
							right = Pop(stack);
							left = Pop(stack);
							stack.Add(new ExprStackObject(left.Calc() || right.Calc()));
							break;
						
						case "!":
							right = Pop(stack);
							stack.Add(new ExprStackObject(!right.Calc()));
							break;
							
						case "<":
							right = Pop(stack);
							left = Pop(stack);
							stack.Add(new ExprStackObject(left.Calc() < right.Calc()));
							break;
						
						case ">":
							right = Pop(stack);
							left = Pop(stack);
							stack.Add(new ExprStackObject(left.Calc() > right.Calc()));
							break;
						
						case "==":
							right = Pop(stack);
							left = Pop(stack);
							stack.Add(new ExprStackObject(left.Calc() == right.Calc()));
							break;
						
						case "!=":
							right = Pop(stack);
							left = Pop(stack);
							stack.Add(new ExprStackObject(left.Calc() != right.Calc()));
							break;
						
						case "<=":
							right = Pop(stack);
							left = Pop(stack);
							stack.Add(new ExprStackObject(left.Calc() <= right.Calc()));
							break;
						
						case ">=":
							right = Pop(stack);
							left = Pop(stack);
							stack.Add(new ExprStackObject(left.Calc() >= right.Calc()));
							break;
					
						case "+":
							right = Pop(stack);
							left = Pop(stack);
							stack.Add(new ExprStackObject(left.Calc() + right.Calc()));
							break;
						
						case "-":
							right = Pop(stack);
							left = Pop(stack);
							stack.Add(new ExprStackObject(left.Calc() - right.Calc()));
							break;
						
						case "*":
							right = Pop(stack);
							left = Pop(stack);
							stack.Add(new ExprStackObject(left.Calc() * right.Calc()));
							break;
						
						case "/":
							right = Pop(stack);
							left = Pop(stack);
							stack.Add(new ExprStackObject(left.Calc() / right.Calc()));
							break;
						
						case "++pre":
							right = Pop(stack);
							++curBlock.varTable[right.value].value;
							stack.Add(new ExprStackObject(right.Calc()));
							break;
							
						case "++post":
							right = Pop(stack);
							stack.Add(new ExprStackObject(right.Calc()));
							++curBlock.varTable[right.value].value;
							break;
							
						case "--pre":
							right = Pop(stack);
							--curBlock.varTable[right.value].value;
							stack.Add(new ExprStackObject(right.Calc()));
							break;
							
						case "--post":
							right = Pop(stack);
							stack.Add(new ExprStackObject(right.Calc()));
							--curBlock.varTable[right.value].value;
							break;
							
						case "=":
							right = Pop(stack);
							left = Pop(stack);
							try
							{
								dynamic rightval = right.Calc();
								VarData data = curBlock.varTable[left.value];
								if (data.value.GetType() == rightval.GetType())
									data.value = rightval;
								else if (data.type == VarType.Double)
									data.value = (double)rightval;
								else
									Error("Can't convert \"" + rightval + "\" to " + data.type);
								Debug($"var \"{left.value}\" of type {curBlock.varTable[left.value].type} = {data.value}");	
								stack.Add(new ExprStackObject(data.value));
							}
							catch (KeyNotFoundException)
							{
								Error("Variable " + left.value + " does not exist in current context1");
							}
							break;
						
						case "+=":
							right = Pop(stack);
							left = Pop(stack);
							try
							{
								dynamic rightval = right.Calc();
								VarData data = curBlock.varTable[left.value];
								if (data.value.GetType() == rightval.GetType())
									data.value += rightval;
								else if (data.type == VarType.Double)
									data.value += (double)rightval;
								else
									Error("Can't convert \"" + rightval + "\" to " + data.type);
								stack.Add(new ExprStackObject(data.value));
							}
							catch (KeyNotFoundException)
							{
								Error("Variable " + left.value + " does not exist in current context2");
							}
							break;
						
						case "-=":
							right = Pop(stack);
							left = Pop(stack);
							try
							{
								dynamic rightval = right.Calc();
								VarData data = curBlock.varTable[left.value];
								if (data.value.GetType() == rightval.GetType())
									data.value -= rightval;
								else if (data.type == VarType.Double)
									data.value -= (double)rightval;
								else
									Error("Can't convert \"" + rightval + "\" to " + data.type);
								stack.Add(new ExprStackObject(data.value));
							}
							catch (KeyNotFoundException)
							{
								Error("Variable " + left.value + " does not exist in current context3");
							}
							break;
						
						case "*=":
							right = Pop(stack);
							left = Pop(stack);
							try
							{
								dynamic rightval = right.Calc();
								VarData data = curBlock.varTable[left.value];
								if (data.value.GetType() == rightval.GetType())
									data.value *= rightval;
								else if (data.type == VarType.Double)
									data.value *= (double)rightval;
								else
									Error("Can't convert \"" + rightval + "\" to " + data.type);
								stack.Add(new ExprStackObject(data.value));
							}
							catch (KeyNotFoundException)
							{
								Error("Variable " + left.value + " does not exist in current context4");
							}
							break;
						
						case "/=":
							right = Pop(stack);
							left = Pop(stack);
							try
							{
								dynamic rightval = right.Calc();
								VarData data = curBlock.varTable[left.value];
								if (data.value.GetType() == rightval.GetType())
									data.value /= rightval;
								else if (data.type == VarType.Double)
									data.value /= (double)rightval;
								else
									Error("Can't convert \"" + rightval + "\" to " + data.type);
								stack.Add(new ExprStackObject(data.value));
							}
							catch (KeyNotFoundException)
							{
								Error("Variable " + left.value + " does not exist in current context5");
							}
							break;
							
						case "sin":
							right = Pop(stack);
							stack.Add(new ExprStackObject(Math.Sin(right.Calc())));
							break;
						
						case "cos":
							right = Pop(stack);
							stack.Add(new ExprStackObject(Math.Cos(right.Calc())));
							break;
						
						case "tan":
							right = Pop(stack);
							stack.Add(new ExprStackObject(Math.Tan(right.Calc())));
							break;
						
						case "asin":
							right = Pop(stack);
							stack.Add(new ExprStackObject(Math.Asin(right.Calc())));
							break;
						
						case "acos":
							right = Pop(stack);
							stack.Add(new ExprStackObject(Math.Acos(right.Calc())));
							break;
						
						case "atan":
							right = Pop(stack);
							stack.Add(new ExprStackObject(Math.Atan(right.Calc())));
							break;
						
						case "atan2":
							right = Pop(stack);
							left = Pop(stack);
							stack.Add(new ExprStackObject(Math.Atan2(left.Calc(), right.Calc())));
							break;
					}
					
				}
			}
			if (stack.Count > 0)
            {
            	var res = stack[0];
            	res.Calc();
            	if (res.value is string ss && curBlock.varTable.ContainsKey(ss))
				{
            		Debug($"Result is {curBlock.varTable[ss].value}");
            		value = curBlock.varTable[ss].value;
            		return curBlock.varTable[ss].value;
            	}
            	Debug($"Result is {res.value}");
            	value = res.value;
            	return res.value;	
            }
            Error("Nothing in stack left");
            return null;
		}
	}
}

program : function* main function* {

/*if (NinjaParser.metTable.ContainsKey("main"))
                	{
                		++depth;
                		//GoThroughCalls(NinjaParser.metTable[call.name]);
                		foreach(var sm in NinjaParser.metTable["main"].operations)
                		{
                			sm.Eval();
                		}
                	}*/
				metTable["main"].Eval();
};

main : main_signature OBRACE main_code CBRACE
{
	
};

main_signature : FUN_KEYWORD VOID MAIN LPAREN RPAREN {
	MethodData newMet = new MethodData
	{
		name = "main",
		returnType = ReturnType.Void
	};
	metTable.Add("main", newMet);
	currentMet = "main";
	curBlock = newMet;
};

function : v_function | m_function ;

v_function: v_fun_signature OBRACE code CBRACE;

v_fun_signature returns [string funName]: FUN_KEYWORD VOID ID 
{
	string methodName = $ID.text;
	$funName = methodName;
	if (methodName == "main" || metTable.ContainsKey(methodName))
		throw new NotImplementedException("!!!Method overloading is not supported yet!!!");

	MethodData newMet = new MethodData
	{
		name = methodName,
		returnType = ReturnType.Void
	};
	
	metTable.Add(newMet.name, newMet);
	currentMet = methodName;
	curBlock = newMet;
} LPAREN params[$ID.text] RPAREN;

m_function : m_fun_signature OBRACE code method_return[curBlock.createOperationClass()] CBRACE {

	string methodName = $m_fun_signature.funName;
	
	ReturnType actualReturn;
	
	/*switch($method_return.type)
    {
        case "int":
        	actualReturn = ReturnType.Int;
        	break;
        case "double":
            actualReturn = ReturnType.Double;
            break;
        case "bool":
            actualReturn = ReturnType.Bool;
            break;		
        default:
    		throw new NotImplementedException();     
    }
	
	

	if (actualReturn != metTable[methodName].returnType){
		throw new Exception($"Actual return is {actualReturn}, expected declared return type {metTable[methodName].returnType}");
	}*/
	
	if ($method_return.value == null)
	{
		Error($"null return foeee {methodName}");
	}

	metTable[methodName].returnValue = $method_return.value;

};

m_fun_signature returns [string funName]: FUN_KEYWORD meaningfulType ID {
	
	string methodName = $ID.text;
	$funName = methodName;
	if (methodName == "main" || metTable.ContainsKey(methodName))
		throw new NotImplementedException("!!!Method overloading is not supported yet!!!");

	MethodData newMet = new MethodData
	{
		name = methodName,
		isMeaningful = true
	};
	
	switch($meaningfulType.text)
    {
    	case "int":
    		newMet.returnType = ReturnType.Int;
    		break;
    	case "double":
            newMet.returnType = ReturnType.Double;
           	break;
        case "bool":
            newMet.returnType = ReturnType.Bool;
            break;		
    }

	metTable.Add(newMet.name, newMet);
	currentMet = methodName;
	curBlock = newMet;
} LPAREN params[$ID.text] RPAREN;

code : (operation[curBlock.createOperationClass()])*;

main_code : (operation[curBlock.createOperationClass()])*;

operation[OperationClass oper] : call[curBlock.ToExpr()] | custom_call[curBlock.ToExpr()] | declare[curBlock.ToExpr()] | ariphExprEx[curBlock.ToExpr()] | boolExprEx[curBlock.ToExpr()]
			| myif|myif_short|mywhile|mydo_while|myfor;

method_return[OperationClass oper] returns [string type, dynamic value]: RETURN_KEYWORD val_or_id[curBlock.ToExpr()] {
	Debug($"val_or_id3 is {$val_or_id.text}");
	$type = $val_or_id.type;
	$value = $val_or_id.value;
};

params[string funName] : (var_signature[funName] (COMMA var_signature[funName])*)? ;

var_signature[string funName]: meaningfulType ID
				{
					VarData newVar = new VarData();
					newVar.name = $ID.text;
					switch ($meaningfulType.text)
					{
						case "int":
							newVar.type = VarType.Int;
							newVar.value = 0;
							break;
							
						case "double":
							newVar.type = VarType.Double;
							newVar.value = 0.0;
							break;
							
						case "bool":
							newVar.type = VarType.Bool;
							newVar.value = false;
							break;
					}
					ParamData pData = new ParamData();
					pData.name = $ID.text;
					pData.type = newVar.type;
					metTable[funName].paramList.Add(pData);
					metTable[funName].varTable[$ID.text] = newVar;
				};

builtin_func_p : 'move'|'turn' ;

builtin_func_e : 'hit'|'shoot' ;  

call[OperationClass oper] : parameterized_call {

	CallData data = new CallData(){
		callType = CallType.BuiltIn, 
		name = $parameterized_call.text.Substring(0, $parameterized_call.text.IndexOf("(")),
		returnType = ReturnType.Void,
		parent = curBlock
	};
	
	ParamData d = new ParamData()
	{
		type = VarType.Double, 
		value = _localctx._parameterized_call.ariphExprEx().GetText()
	};
	
	//if($parameterized_call.res.isEvaluated)
	//	d.value = $parameterized_call.res.value;
	//else	
		d.value = $parameterized_call.res;
    d.paramType = ParamType.Pass;				
    data.paramList.Add(d);
	
	string methodName = currentMet;
	if(methodName != "?"){
		metTable[methodName].operations.Add(data);
	}

} | simple_call {

	CallData data = new CallData(){
		callType = CallType.BuiltIn, 
		name = $simple_call.text.Substring(0, $simple_call.text.IndexOf("(")),
		returnType = ReturnType.Void,
        parent = curBlock
	};

	string methodName = currentMet;
	if(methodName != "?"){
		metTable[methodName].operations.Add(data);
	}
};

parameterized_call returns [ExprClass res]: builtin_func_p LPAREN ariphExprEx[new ExprClass(curBlock.createOperationClass())] RPAREN {

	$res = $ariphExprEx.res;
};

simple_call : builtin_func_e LPAREN RPAREN;

custom_call[ExprClass oper] returns [string funName, CallData callData]: ID LPAREN call_params[$oper] RPAREN {

	string callName = $ID.text;
	$funName = callName;
	CallData data = new CallData(){
		callType = CallType.Custom, 
		name = callName,
        parent = curBlock
	};

	foreach (var par in _localctx.call_params().val_or_id())
	{
	
		ParamData d = new ParamData();
		d.paramType = ParamType.Pass;
		switch (par.type)
        {
        	case "int":
        		d.type = VarType.Int;		
        		break;
        	case "double":
        		d.type = VarType.Double;
        		break;
        	case "bool":
        		d.type = VarType.Bool;
        		break;
        	//case "other":
        	//	break;
        						
        	default:
        		Error($"Unknown type {par.type}");
        		//throw new NotImplementedException();
        		break;
        }
        d.value = par.value;
		data.paramList.Add(d);    			
	}
	
	string methodName = currentMet;
    /*if(methodName != "?" && CheckParams(data, metTable[callName])){
    	metTable[methodName].operations.Add(data);
    }*/
	$callData = data;

};

call_params[ExprClass oper] : (val_or_id[$oper] {Debug($"val_or_id1 is {$val_or_id.text}");} (COMMA val_or_id[$oper] {Debug($"val_or_id2 is {$val_or_id.text}");})*)?;

val_or_id[ExprClass oper] returns [string type, dynamic value]: 
			ariphExprEx[$oper]
			{
				
				//if($ariphExprEx.res.isEvaluated)
                //		$value = $ariphExprEx.res.value;
                //	else	
                		$value = $ariphExprEx.res;
				
				if ($value.GetType() == typeof(int)) //ariphExprEx.value.GetType() == typeof(int)")
					$type = "int";
				else if ($value.GetType() == typeof(double))
					$type = "double";
				else if ($value.GetType() == typeof(bool))
                    $type = "bool";
                Debug($"param value1 is {$value} of type {$type}");    
			}
		  | boolExprEx[$oper]
			{
				$value = $boolExprEx.res;
                Debug($"param value2 is {$value}");
				$type = "bool";
			};


//Code related to variables
ariphOperand[ExprClass oper]:
               INT
               {
                   $oper.Push(new ExprStackObject(int.Parse($INT.text)));
               }
             | DOUBLE
               {
					double value;
               		try 
               		{
                   		value = double.Parse($DOUBLE.text);
                   	} 
                   	catch
                   	{
                   		value = double.Parse($DOUBLE.text.Replace('.', ','));
                   	}
					$oper.Push(new ExprStackObject(value));
               }
             | custom_call[$oper]
             	{
             		$oper.Push(new ExprStackObject()
					{
						type = ObjType.Function,
						value = $custom_call.callData
					});
             	}
             | ariphID[$oper]
               {
                   Console.WriteLine($"founy idd {$ariphID.text} val undefined");
               }
			 | trig[$oper] | trig2[$oper]
			 | incdec=(INC|DEC) ariphID[$oper]
			   {
					$oper.Push(new ExprStackObject()
					{
						type = ObjType.Operation,
						value = $incdec.text + "pre"
					});
			   }
			 | ariphID[$oper] incdec=(INC|DEC)
			   {
					$oper.Push(new ExprStackObject()
					{
						type = ObjType.Operation,
						value = $incdec.text + "post"
					});
			   }
             | LPAREN ariphExprEx[$oper] RPAREN;
ariphTerm[ExprClass oper]:
            ariphOperand[$oper]
            {
                Debug("\t terarpy1 operand\"" + $ariphOperand.text + "\"");
            }
           (muldiv=(MUL|DIV) ariphOperand[$oper])*
            {
				if ($muldiv.text != null)
				{
					$oper.Push(new ExprStackObject()
					 {
						type = ObjType.Operation,
						value = $muldiv.text
					 });
					Debug("\t terarpy2 operand\"" + $ariphOperand.text + "\"");
				}
            };
ariphExpr[ExprClass oper]:
            ariphTerm[$oper]
            {
                Debug("\t rarpy1 term\"" + $ariphTerm.text + "\"");
            }
			(addsub=(ADD|SUB) ariphTerm[$oper])*
            {
				if ($addsub.text != null)
				{
					$oper.Push(new ExprStackObject()
					 {
						type = ObjType.Operation,
						value = $addsub.text
					 });
					 Debug("\t rarpy2 term\"" + $ariphTerm.text + "\"");
				}
            };
ariphExprEx[ExprClass oper] returns [ExprClass res]:
            ariphExpr[$oper]
            {
                Debug("\t arpy1 expr\"" + $ariphExpr.text + "\"");
                $res = $oper;
            }
          | ariphID[$oper] assigns=(ASSIGN|ADDASSIGN|SUBASSIGN|MULASSIGN|DIVASSIGN) ariphExprEx[$oper]
            {
                $oper.Push(new ExprStackObject()
					 {
						type = ObjType.Operation,
						value = $assigns.text
					 });
				$res = $oper;
				Debug("\t arpy2 expr\"" + $ariphExprEx.text + "\"");
            };

boolOperand[ExprClass oper]:
              BOOL
              {
				  Debug("Const " + $BOOL.text);
                  $oper.Push(new ExprStackObject(bool.Parse($BOOL.text)));
              }
            | ariphID[$oper]
			  {
				Debug("Var " + $ariphID.text);
			  }
            | ariphExprEx[$oper] comp=(LESS|GREATER|EQUAL|NOTEQUAL|LESSEQUAL|GREQUAL) ariphExprEx[$oper]
              {
				$oper.Push(new ExprStackObject()
				{
					type = ObjType.Operation,
					value = $comp.text
				}); 
			  }
			| NOT boolOperand[$oper]
			{
				Debug("\tNOT " + $boolOperand.text);
				$oper.Push(new ExprStackObject()
				{
					type = ObjType.Operation,
					value = $NOT.text
				});
			}
            /*| boolExprEx[$oper] EQUAL boolExprEx[$oper]
              {
                  
              }
            | boolExprEx[$oper] NOTEQUAL boolExprEx[$oper]
              {
                  
              }*/
            | LPAREN boolExprEx[$oper] RPAREN;
boolExpr[ExprClass oper]:
           boolOperand[$oper]
         | left=boolOperand[$oper] andor=(AND|OR) right=boolExpr[$oper]
           {
				Debug("\t" + $left.text + " AND/OR " + $right.text);
				$oper.Push(new ExprStackObject()
				{
					type = ObjType.Operation,
					value = $andor.text
				});
           };
boolExprEx[ExprClass oper] returns [ExprClass res]:
           boolExpr[$oper]
		   {
				$res = $oper;
		   }
         | left=ariphID[$oper] ASSIGN right=boolExprEx[$oper]
           {
				Debug("\t" + $left.text + " ASSIGN " + $right.text);
				$oper.Push(new ExprStackObject()
				{
					type = ObjType.Operation,
					value = "="
				});
				$res = $oper;
           };

//declaration
declare[ExprClass oper]: INTKEY ariphID[$oper]
          {
           VarData newVar = new VarData
           {
                type = VarType.Int,
                value = 0
           };
           curBlock.varTable.Add($ariphID.text, newVar);
           Debug("Create var " + $ariphID.text);
          }
          (ASSIGN ariphExprEx[$oper])?
          {
           if ($ariphExprEx.text != null)
           {
				Debug("\tAssigning it value of " + $ariphExprEx.text);
				$oper.Push(new ExprStackObject()
					 {
						type = ObjType.Operation,
						value = "="
					 });
           }
          }
          
        | DOUBLEKEY ariphID[$oper]
          {
           VarData newVar = new VarData
           {
                type = VarType.Double,
                value = 0.0
           };
           curBlock.varTable.Add($ariphID.text, newVar);
           Debug("Create var " + $ariphID.text);
          }
          (ASSIGN ariphExprEx[$oper])?
          {
           if ($ariphExprEx.text != null)
           {
                Debug("\tAssigning it value of " + $ariphExprEx.text);
                $oper.Push(new ExprStackObject()
					 {
						type = ObjType.Operation,
						value = "="
					 });
           }
          }
        | BOOLKEY ariphID[$oper]
          {
           VarData newVar = new VarData
           {
                type = VarType.Bool,
                value = false
           };
           curBlock.varTable.Add($ariphID.text, newVar);
           Debug("Create var " + $ariphID.text);
          }
          (ASSIGN boolExprEx[$oper])?
          {
           if ($boolExprEx.text != null)
           {
                Debug("\tAssigning3 it value of " + $boolExprEx.text);
                $oper.Push(new ExprStackObject()
				{
					type = ObjType.Operation,
					value = "="
				});
           }
          };

ariphID[ExprClass oper] : ID
		{
			$oper.Push(new ExprStackObject()
					 {
						type = ObjType.Var,
						value = $ID.text
					 });
			Debug($"arrriph id {$ID.text}");
			
			//$oper.Push(new ExprStackObject()
            //					 {
            //						type = ObjType.Var,
            //						value = $ID.text
            //					 });
            //			Debug($"boooooool id {$ID.text}");
			
		};

//trigonometry
trig[ExprClass oper]:
		trfun=(SIN|COS|TAN|ASIN|ACOS|ATAN) LPAREN ariphExprEx[$oper] RPAREN
		{
			$oper.Push(new ExprStackObject()
					 {
						type = ObjType.Operation,
						value = $trfun.text
					 });
		};
trig2[ExprClass oper]:
		ATAN2 LPAREN ariphExprEx[$oper] COMMA ariphExprEx[$oper] RPAREN
		{
			$oper.Push(new ExprStackObject()
					 {
						type = ObjType.Operation,
						value = "atan2"
					 });
		};
		

//code related to cycles
myif: IF LPAREN boolExprEx[null] RPAREN // вместо INT  нужен BOOL
     OBRACE 
    (operation[null])+
    CBRACE
     ELSE 
      OBRACE  
    (operation[null])+
    CBRACE
   ;
myif_short: IF LPAREN boolExprEx[null]  RPAREN // вместо INT  нужен BOOL
    OBRACE
    (operation[null])+
    CBRACE
   ;
mywhile: WHILE LPAREN boolExprEx[null] RPAREN // вместо INT  нужен BOOL
     OBRACE
     (operation[null])+
     CBRACE 
       ;
mydo_while: DO 
          OBRACE
            (operation[null])+
          CBRACE
          WHILE LPAREN boolExprEx[null] RPAREN // вместо INT  нужен BOOL
          ;
myfor:  FOR LPAREN ~SEMICOLON+ SEMICOLON boolExprEx[null] SEMICOLON ~SEMICOLON+ RPAREN // ~SEMICOLON+ заменяется на INT BOOL оператор
        OBRACE
        (operation[null])+
        CBRACE
     ;


//Lexer rules
//OPSEP   : '\n' ;
SEMICOLON: ';';

//keywords
INTKEY      : 'int' ;
DOUBLEKEY   : 'double' ;
BOOLKEY     : 'bool' ;
WHILE		: 'while' ;
FOR			: 'for' ;
DO			: 'do' ;
IF			: 'if' ;
ELSE		: 'else' ;
SIN			: 'sin' ;
COS			: 'cos' ;
TAN			: 'tan' ;
ASIN		: 'asin' ;
ACOS		: 'acos' ;
ATAN		: 'atan' ;
ATAN2		: 'atan2' ;

//operators
ADD     : '+' ;
SUB     : '-' ;
MUL     : '*' ;
DIV     : '/' ;
INC		: '++' ;
DEC		: '--' ;
ASSIGN		: '=' ;
ADDASSIGN   : '+=' ;
SUBASSIGN   : '-=' ;
MULASSIGN   : '*=' ;
DIVASSIGN   : '/=' ;
AND       : '&&' ;
OR        : '||' ;
NOT		  : '!' ;
LESS      : '<' ;
GREATER   : '>' ;
EQUAL     : '==' ;
NOTEQUAL  : '!=' ;
LESSEQUAL : '<=' ;
GREQUAL   : '>=' ;

//Whitespace symbols
WS : [ \t\r\n]+ -> skip ;

//literals
BOOL    : ('true'|'false') ;
DOUBLE  : [+-]?DIGIT*[,.]DIGIT+ ;
INT     : [+-]?DIGIT+ ;

RETURN_KEYWORD : 'return';
PASS : 'pass' ;

MAIN : 'main' ;

FUN_KEYWORD : 'fun' ;

meaningfulType : ('int'|'double'|'bool') ;

VOID : 'void' ;

COMMA : ',' ;

OBRACE : '{' ;
CBRACE : '}' ;

LPAREN : '(' ;
RPAREN : ')' ;

COMMENT : '//'.*?[\n] -> skip ;

STRING : '"'[a-zA-Z]*'"' ;
ID  : LETTER (LETTER | DIGIT)* ;

//lexer rule fragments
fragment LETTER : [a-zA-Z_] ;
fragment DIGIT : [0-9] ;