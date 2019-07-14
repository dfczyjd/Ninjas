grammar Ninja;

options {
	language=CSharp ;
}

@parser::header
{
	#if NOGUI
    	using Interpreter;
    #endif
}

@parser::members 
{

	public RealInterpreter owner;
    public int id;
    public int[] health = new int[4];
    public double[] xPos = new double[4];
    public double[] yPos = new double[4];
    public double[] dirs = new double[4];

    public void Sleep()
    {
        int tmp = 0;
        Main.Log("#" + id + " entered pause");
        Main.mre[id].Reset();
        Main.mre[id].WaitOne();
        Main.Log("#" + id + " left pause");
    }


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
        
        
        public dynamic value
        {
        	get 
        	{
        		if (isAssigned)
        			return rval;
        		throw new Exception($"Cannot get value, Variable \"{name}\" is not initialized!");	
        	}
        	
        	set
        	{
        		isAssigned = true;
        		rval = value;
        	}
        }
        
        private dynamic rval;
        public bool isAssigned {get; private set;}
    }

    public class MethodData : Block
    {
		public bool isMeaningful;
        public ReturnType returnType = ReturnType.Void;
        public ArrayList<NinjaParser.ParamData> paramList = new ArrayList<NinjaParser.ParamData>();
        
		public dynamic returnValue;
		
		public MethodData(NinjaParser parser) : base(parser)
        	        {
        	        }
		
		public override void Eval()
        {
        	parser.curBlock = this;
        	Debug($"===Entering fun {name} with params {ParamListToString(paramList)}");
            foreach(var sm in operations)
            {
            	if(sm.GetType().IsSubclassOf(typeof(OperationClass)))
            		sm.Eval();
            }
            
            Debug($"---Vars of block met {name} ----");	
            foreach (var elem in varTable)
            {
            	if (elem.Value.isAssigned)
                	Debug("\t" + elem.Key + " is " + elem.Value.type + " with value " + elem.Value.value);
                else
                	Debug("\t" + elem.Key + " is " + elem.Value.type + ", value not assigned");
            }
            Debug($"---End Vars of block met {name} ----");
            Debug($"===Exiting fun {name}");	
        	
        }
        
        public override string ToString()
        {
        	return $"fun {returnType} {name}, params : {paramList} ";
        }
    }
 
    public Dictionary<string, MethodData> metTable = new Dictionary<string, MethodData>();
    int depth = 0;
    string currentMet = "?";
    
    static StreamWriter fstream = new StreamWriter("execlog.log");
   	    
   	public static void Debug(string line)
   	{
   		Console.WriteLine(line);
   		fstream.WriteLine(line);
   	    fstream.Flush();
   	}
   	    
   	public static void Error(string message)
   	{
   	    ConsoleColor curr = Console.ForegroundColor;
   	    Console.ForegroundColor = ConsoleColor.Red;
   	    Console.WriteLine(message);
   	    fstream.WriteLine("ERROR: " + message);
   	    fstream.Flush();
   	    Console.ForegroundColor = curr;
   	}
    
    public static bool CheckType(Type t, VarType vt)
    {
    	string actualTypeName = t.ToString().ToLower();
        string expectedTypeName = vt.ToString().ToLower();
        
    	if(actualTypeName.Contains("bool") && expectedTypeName.Contains("bool"))
        	return true;
        if(actualTypeName.Contains("int") && (expectedTypeName.Contains("int") || expectedTypeName.Contains("double")))
            return true;
        if(actualTypeName.Contains("double") && expectedTypeName.Contains("double"))
            return true;
        return false;        	
    }
    
    public static bool CheckType(Type t, ReturnType vt)
        {
        	string actualTypeName = t.ToString().ToLower();
        	string expectedTypeName = vt.ToString().ToLower();
        
        	if(actualTypeName.Contains("bool") && expectedTypeName.Contains("bool"))
        		return true;
        	if(actualTypeName.Contains("int") && (expectedTypeName.Contains("int") || expectedTypeName.Contains("double")))
                return true;
            if(actualTypeName.Contains("double") && expectedTypeName.Contains("double"))
                return true;
            return false;        	
        }
	
	public bool CheckParams(NinjaParser.CallData call, NinjaParser.MethodData method)
    {
    	if (call.paramList.Count != method.paramList.Count)
    	{
    		Error($"Expected params {method.paramList.Count}, found {call.paramList.Count}");
    		return false;
    	}
    
    	for (int i = 0; i < call.paramList.Count; i++)
    	{
    		var r = call.paramList[call.paramList.Count - i - 1].value;//.Eval();		
    		//if (call.paramList[i].type == method.paramList[i].type)
    		if (r is string varId){
    			if (FindVar(varId) != null)
    				r = FindVar(varId).value;
    			else
    			{
    				Error($"Type mismatch ({i+1}/{call.paramList.Count}) in {call.name}: expected {method.paramList[i].type}, found {r.GetType()} with value {call.paramList[call.paramList.Count - i - 1].value}");
                    return false;
    			}
    		}
    		if (r is ExprClass)
			{
				if (r.value != null)
				{
					r = r.value;
					call.paramList[call.paramList.Count - i - 1].value = r;
                }
                else
				{
					//second call
					Error("Evaluating param (fuck, second evaluation)");
					call.paramList[call.paramList.Count - i - 1].value = r.Eval();
					r = call.paramList[call.paramList.Count - i - 1].value;	
				}
            }
    				
    		if (CheckType(r.GetType(), method.paramList[i].type))
    		{
    			method.paramList[i].value = r;
				if (FindVar(method.paramList[i].name, method) == null)
	            {
	                VarData varData = new VarData()
	                {
	                	name = method.paramList[i].name,
						type = method.paramList[i].type
	               	};
	           		method.varTable.Add(varData.name, varData);
	           	}
	    		FindVar(method.paramList[i].name, method).value = r;
    		}
    		else
    		{
    			Error($"Type mismatch ({i+1}/{call.paramList.Count}) in {call.name}: expected {method.paramList[i].type}, found {r.GetType()} with value {call.paramList[call.paramList.Count - i - 1].value}");
    			return false;
    		}
    	}
    
    	return true;
    }
            		
	ArrayList<byte> _bytes = new ArrayList<byte>();
	
	static string ParamListToString(ArrayList<NinjaParser.ParamData> list)
    {
    	string s = "{";
    	foreach (var data in list)
    	{
    	
    		if(data.value.GetType() == typeof(ExprClass))
    			s += $" {data.type} {data.value.Eval()},";
    		else
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
    	}
    
    	s = (s.Length > 1 ? s.Substring(0, s.Length - 1) : s) + " }";
    	return s;
    }
	
	public class Block
	{
	
		public string name;
	
		public NinjaParser parser;
		
		public Block(NinjaParser parser)
		{
			this.parser = parser;
		}
		
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
			res.parser = parser;
			operations[lastInd] = res;
			return res;
		}
		
		public ExprClass createExpressionClass(){
			operations.Add(new OperationClass());
			int lastInd = operations.Count - 1;
        	var res = new ExprClass(operations[lastInd]);
			res.parser = parser;
			operations[lastInd] = res;
			return res;
		}
	}
	
	public class CallData : OperationClass
	{
		public string name;
			
		public dynamic value;
			
		public CallType callType;
		
		public ReturnType returnType = ReturnType.Void;
		
		public Block parent;
			
		public ArrayList<NinjaParser.ParamData> paramList = new ArrayList<NinjaParser.ParamData>();
		
		public override dynamic Eval()
		{
			if (callType == NinjaParser.CallType.Custom)
			{
				
				if (parser.metTable.ContainsKey(name) && parser.CheckParams(this, parser.metTable[name]))
				{		
					Debug($"Calling custom method {name} with params {ParamListToString(paramList)}");
					parser.metTable[name].Eval();
					if (returnType != ReturnType.Void && parser.metTable[name].returnType != ReturnType.Void)
					{
						var ret = parser.metTable[name].returnValue.Eval();
						if (!CheckType(ret.GetType(), parser.metTable[name].returnType)){
							throw new Exception($"Actual return is {ret.GetType()}, expected declared return type {parser.metTable[name].returnType}");
						}
						parser.curBlock = parent;
						Debug($"===fun {name} returned {ret}");
						return ret;	
					}
					if (returnType != parser.metTable[name].returnType)
						Error("Method declaration and call have different return types");
					parser.curBlock = parent;
					return null;
				}
			}
			else
			{
				if (parser.metTable.ContainsKey(name))
				{
					if (parser.CheckParams(this, parser.metTable[name]))
					{
#if !NOGUI
						parser.Sleep();
#endif
						dynamic ret = 0;
						int reqid = -1;
						if (name != "getSelfId")
						{
							dynamic param = paramList[0].value;
							if (param.GetType() == typeof(string))
							{
								reqid = parser.FindVar(param).value;
							}
							else
							{
								reqid = param;
							}
						}
						switch (name)
						{
							case "getSelfId":
								ret = parser.id;
								break;

							case "getHealth":
								ret = parser.health[reqid];
								break;

							case "getPositionX":
								ret = parser.xPos[reqid];
								break;

							case "getPositionY":
								ret = parser.yPos[reqid];
								break;

							case "getDirection":
								ret = parser.dirs[reqid];
								break;
						}
						Debug($"Calling builtin method {name} with params {ParamListToString(paramList)}, ret {ret} + of type " + ret.GetType());
						Main.Log("Func " + name + " for player #" + reqid + " returning " + ret);
						return parser.metTable[name].returnValue = ret;
					}
				}
				else
				{
					Debug($"Calling builtin method {name} with params {ParamListToString(paramList)}");
					Command nw;
					switch (name)
					{
						case "move":
							nw = new Command(1, paramList[0].value.Eval());
							break;
						case "turn":
							nw = new Command(2, paramList[0].value.Eval());
							break;
						case "hit":
							nw = new Command(3);
							break;
						case "shoot":
							nw = new Command(4);
							break;
						default:
							Error($"Unknown builtin method {name}");
							return null;
					}
					#if !NOGUI
					parser.owner.commands.Enqueue(nw);
					if (parser.owner.commands.Count > 100)
						parser.Sleep();
					#endif
				}
			}
			return null;
		}
	}
	
	private Block rBlock;
	
	public Block curBlock
	{
		get{
			return rBlock;
		}
		set{
			rBlock = value;
		}
	}
	
	public class OperationClass
	{
		public NinjaParser parser;
		
		public OperationClass()
		{
			
		}
		
		public OperationClass(OperationClass op)
		{
			
		}
		
		public OperationClass(NinjaParser p)
        			{
        				parser = p;
        			}
		
		public virtual dynamic Eval()
		{
			Error("OperationClass class is abstract");
			return null;
		}
	}
    
	public enum ObjType
	{
		Number, Logic, Var, Operation, Function
	}

	public class ExprStackObject
	{
		public NinjaParser parser;
		public ObjType type;
		public dynamic value;
		
		public ExprStackObject(): this(0, null) { }
		
		public ExprStackObject(double value, NinjaParser parser)
		{
			type = ObjType.Number;
			this.value = value;
			this.parser = parser;
		}

		public ExprStackObject(int value, NinjaParser parser)
		{
			type = ObjType.Number;
			this.value = value;
			this.parser = parser;
		}
		
		public ExprStackObject(bool value, NinjaParser parser)
		{
			type = ObjType.Number;
			this.value = value;
			this.parser = parser;
		}
		
		public dynamic Calc()
		{
			if (type == ObjType.Number)
				return value;
			if (type == ObjType.Var)
			{
				return parser.FindVar(value).value;
			}

			Error("\"" + value + "\" is an operation");
			return null;
		}
		
		public new Type GetType()
		{
			VarType type = parser.FindVar(value).type;
        	switch (type)
        	{
        		case VarType.Int:
	        		return typeof(int);	
        		case VarType.Double:
        			return typeof(double);		
        		case VarType.Bool:
        			return typeof(bool);
			}
			Error("Variable " + value + " has an unknown type");
        	return null;
        }
	}
	
	public class ExprClass : OperationClass
	{
		public List<ExprStackObject> exprStack;
		
		public ExprClass(OperationClass parent) : base(parent)
		{
			exprStack = new List<ExprStackObject>();
			//parser.curBlock.operations.Add(this);
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
		
		public bool isCompatible(dynamic value1, dynamic value2, bool isLeftVar = false)
		{
			if (value1.GetType() == value1.GetType())
				return true;
			else if (value1.GetType() == typeof(double) && value2.GetType() == typeof(int))
				return true;
			else if (!isLeftVar && value1.GetType == typeof(int) && value2.GetType() == typeof(double))
				return true;
			return false;
		}		
		
		public ReturnType expectedReturnType;
		public dynamic value;
		
		public override dynamic Eval()
		{
			string s = "";
			foreach(var v in exprStack)
			{
				s += v.value + " ";
			}
			//Debug($"Evaluating {s} from block {parser.curBlock.name}");
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
					dynamic result;
					if (elem.value == null)
					{
						result = -1;
					}
					else
					{
						if (elem.value.GetType() == typeof(int))
							result = elem.value;
						else if (elem.value.GetType() == typeof(double))
							result = elem.value;
						else if (elem.value.GetType() == typeof(bool))
							result = elem.value;
						else 
							result = elem.value.Eval();
					}
					stack.Add(new ExprStackObject(result, parser));
				}
				else
				{
					ExprStackObject left, right;
					dynamic leftVal, rightVal;
                    					switch (elem.value)
                    					{
                    						case "&&":
                    							right = Pop(stack);
                    							left = Pop(stack);
                    							leftVal = left.Calc();
                    							rightVal = right.Calc();
                    							if (!isCompatible(leftVal, rightVal))
                    								Error("Incompatible types of values " + leftVal + " and " + rightVal);
                    							stack.Add(new ExprStackObject(leftVal && rightVal, parser));
                    							break;
                    						
                    						case "||":
                    							right = Pop(stack);
                    							left = Pop(stack);
                    							leftVal = left.Calc();
                    							rightVal = right.Calc();
                    							if (!isCompatible(leftVal, rightVal))
                    								Error("Incompatible types of values " + leftVal + " and " + rightVal);
                    							stack.Add(new ExprStackObject(leftVal || rightVal, parser));
                    							break;
                    						
                    						case "!":
                    							right = Pop(stack);
                    							rightVal = right.Calc();
                    							if (rightVal.GetType() != typeof(bool))
                    								Error("Bool is required instead of " + rightVal);
                    							stack.Add(new ExprStackObject(!rightVal, parser));
                    							break;
                    							
                    						case "<":
                    							right = Pop(stack);
                    							left = Pop(stack);
                    							leftVal = left.Calc();
                    							rightVal = right.Calc();
                    							if (!isCompatible(leftVal, rightVal))
                    								Error("Incompatible types of values " + leftVal + " and " + rightVal);
                    							stack.Add(new ExprStackObject(leftVal < rightVal, parser));
                    							break;
                    						
                    						case ">":
                    							right = Pop(stack);
                    							left = Pop(stack);
                    							leftVal = left.Calc();
                    							rightVal = right.Calc();
                    							if (!isCompatible(leftVal, rightVal))
                    								Error("Incompatible types of values " + leftVal + " and " + rightVal);
                    							stack.Add(new ExprStackObject(leftVal > rightVal, parser));
                    							break;
                    						
                    						case "==":
                    							right = Pop(stack);
                    							left = Pop(stack);
                    							leftVal = left.Calc();
                    							rightVal = right.Calc();
                    							if (!isCompatible(leftVal, rightVal))
                    								Error("Incompatible types of values " + leftVal + " and " + rightVal);
                    							stack.Add(new ExprStackObject(leftVal == rightVal, parser));
                    							break;
                    						
                    						case "!=":
                    							right = Pop(stack);
                    							left = Pop(stack);
                    							leftVal = left.Calc();
                    							rightVal = right.Calc();
                    							if (!isCompatible(leftVal, rightVal))
                    								Error("Incompatible types of values " + leftVal + " and " + rightVal);
                    							stack.Add(new ExprStackObject(leftVal != rightVal, parser));
                    							break;
                    						
                    						case "<=":
                    							right = Pop(stack);
                    							left = Pop(stack);
                    							leftVal = left.Calc();
                    							rightVal = right.Calc();
                    							if (!isCompatible(leftVal, rightVal))
                    								Error("Incompatible types of values " + leftVal + " and " + rightVal);
                    							stack.Add(new ExprStackObject(leftVal <= rightVal, parser));
                    							break;
                    						
                    						case ">=":
                    							right = Pop(stack);
                    							left = Pop(stack);
                    							leftVal = left.Calc();
                    							rightVal = right.Calc();
                    							if (!isCompatible(leftVal, rightVal))
                    								Error("Incompatible types of values " + leftVal + " and " + rightVal);
                    							stack.Add(new ExprStackObject(leftVal >= rightVal, parser));
                    							break;
                    					
                    						case "+":
                    							right = Pop(stack);
                    							left = Pop(stack);
                    							leftVal = left.Calc();
                    							rightVal = right.Calc();
                    							if (!isCompatible(leftVal, rightVal))
                    								Error("Incompatible types of values " + leftVal + " and " + rightVal);
                    							stack.Add(new ExprStackObject(leftVal + rightVal, parser));
                    							break;
                    						
                    						case "-":
                    							right = Pop(stack);
                    							left = Pop(stack);
                    							leftVal = left.Calc();
                    							rightVal = right.Calc();
                    							if (!isCompatible(leftVal, rightVal))
                    								Error("Incompatible types of values " + leftVal + " and " + rightVal);
                    							stack.Add(new ExprStackObject(leftVal - rightVal, parser));
                    							break;
                    						
                    						case "*":
                    							right = Pop(stack);
                    							left = Pop(stack);
                    							leftVal = left.Calc();
                    							rightVal = right.Calc();
                    							if (!isCompatible(leftVal, rightVal))
                    								Error("Incompatible types of values " + leftVal + " and " + rightVal);
                    							stack.Add(new ExprStackObject(leftVal * rightVal, parser));
                    							break;
                    						
                    						case "/":
                    							right = Pop(stack);
                    							left = Pop(stack);
                    							leftVal = left.Calc();
                    							rightVal = right.Calc();
                    							if (!isCompatible(leftVal, rightVal))
                    								Error("Incompatible types of values " + leftVal + " and " + rightVal);
                    							stack.Add(new ExprStackObject(leftVal / rightVal, parser));
                    							break;
                    						
											case "%":
                    							right = Pop(stack);
                    							left = Pop(stack);
                    							leftVal = left.Calc();
                    							rightVal = right.Calc();
                    							if (!isCompatible(leftVal, rightVal))
                    								Error("Incompatible types of values " + leftVal + " and " + rightVal);
                    							stack.Add(new ExprStackObject(leftVal % rightVal, parser));
                    							break;
                    							
											case "**":
                    							right = Pop(stack);
                    							left = Pop(stack);
                    							leftVal = left.Calc();
                    							rightVal = right.Calc();
                    							if (!isCompatible(leftVal, rightVal))
                    								Error("Incompatible types of values " + leftVal + " and " + rightVal);
                    							stack.Add(new ExprStackObject(Math.Pow(leftVal, rightVal), parser));
                    							break;	
                    						
                    						case "++pre":
                    							right = Pop(stack);
                    							rightVal = right.Calc();
                    							if (!isCompatible(0, rightVal))
                    								Error(rightVal + " can't be incremented");
                    							rightVal = ++parser.FindVar(right.value).value;
                    							stack.Add(new ExprStackObject(rightVal, parser));
                    							break;
                    							
                    						case "++post":
                    							right = Pop(stack);
                    							rightVal = right.Calc();
                    							if (!isCompatible(0, rightVal))
                    								Error(rightVal + " can't be incremented");
                    							stack.Add(new ExprStackObject(rightVal, parser));
                    							++parser.FindVar(right.value).value;
                    							break;
                    							
                    						case "--pre":
                    							right = Pop(stack);
                    							rightVal = right.Calc();
                    							if (!isCompatible(0, rightVal))
                    								Error(rightVal + " can't be decremented");
                    							rightVal = --parser.FindVar(right.value).value;
                    							stack.Add(new ExprStackObject(rightVal, parser));
                    							break;
                    							
                    						case "--post":
                    							right = Pop(stack);
                    							rightVal = right.Calc();
                    							if (!isCompatible(0, rightVal))
                    								Error(rightVal + " can't be decremented");
                    							stack.Add(new ExprStackObject(rightVal, parser));
                    							--parser.FindVar(right.value).value;
                    							break;
												
											case "-un":
                    							right = Pop(stack);
                    							rightVal = right.Calc();
                    							if (!isCompatible(0.0, rightVal))
                    								Error(rightVal + " is not a number");
                    							stack.Add(new ExprStackObject(-rightVal, parser));
                    							break;
                    							
                    						case "=":
                    							right = Pop(stack);
                    							left = Pop(stack);
                    							try
                    							{
                    								rightVal = right.Calc();
                    								if (!isCompatible(left, rightVal, true))
                    									Error("Can't assign " + rightVal + " to " + left.value);
                    								dynamic rightval = rightVal;
                    								string su = (string) left.value;
                    								VarData data = parser.FindVar(su);
                    								if (CheckType(rightval.GetType(), data.type))
                    									data.value = rightval;
                    								else if (data.type == VarType.Double)
                    									data.value = (double)rightval;
                    								else
                    									Error("Can't convert \"" + rightval + "\" to " + data.type);	
													//Debug("Assigned " + rightVal + " of type " + rightVal.GetType() + " to " + left.value + " of type " + data.type);
                    								stack.Add(new ExprStackObject(data.value, parser));
                    							}
                    							catch (KeyNotFoundException e)
                    							{					
                    								Error("Variable " + left.value + " does not exist in current context1\n" + e.StackTrace);
                    							}
                    							break;
                    						
                    						case "+=":
                    							right = Pop(stack);
                    							left = Pop(stack);
                    							try
                    							{
                    								rightVal = right.Calc();
                    								if (!isCompatible(left, rightVal, true))
                    									Error("Can't assign " + rightVal + " to " + left.value);
                    								dynamic rightval = rightVal;
                    								VarData data = parser.FindVar(left.value);
                    								if (data.value.GetType() == rightval.GetType())
                    									data.value += rightval;
                    								else if (data.type == VarType.Double)
                    									data.value += (double)rightval;
                    								else
                    									Error("Can't convert \"" + rightval + "\" to " + data.type);
                    								stack.Add(new ExprStackObject(data.value, parser));
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
                    								rightVal = right.Calc();
                    								if (!isCompatible(left, rightVal, true))
                    									Error("Can't assign " + rightVal + " to " + left.value);
                    								dynamic rightval = rightVal;
                    								VarData data = parser.FindVar(left.value);
                    								if (data.value.GetType() == rightval.GetType())
                    									data.value -= rightval;
                    								else if (data.type == VarType.Double)
                    									data.value -= (double)rightval;
                    								else
                    									Error("Can't convert \"" + rightval + "\" to " + data.type);
                    								stack.Add(new ExprStackObject(data.value, parser));
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
                    								rightVal = right.Calc();
                    								if (!isCompatible(left, rightVal, true))
                    									Error("Can't assign " + rightVal + " to " + left.value);
                    								dynamic rightval = rightVal;
                    								VarData data = parser.FindVar(left.value);
                    								if (data.value.GetType() == rightval.GetType())
                    									data.value *= rightval;
                    								else if (data.type == VarType.Double)
                    									data.value *= (double)rightval;
                    								else
                    									Error("Can't convert \"" + rightval + "\" to " + data.type);
                    								stack.Add(new ExprStackObject(data.value, parser));
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
                    								rightVal = right.Calc();
                    								if (!isCompatible(left, rightVal, true))
                    									Error("Can't assign " + rightVal + " to " + left.value);
                    								dynamic rightval = rightVal;
                    								VarData data = parser.FindVar(left.value);
                    								if (data.value.GetType() == rightval.GetType())
                    									data.value /= rightval;
                    								else if (data.type == VarType.Double)
                    									data.value /= (double)rightval;
                    								else
                    									Error("Can't convert \"" + rightval + "\" to " + data.type);
                    								stack.Add(new ExprStackObject(data.value, parser));
                    							}
                    							catch (KeyNotFoundException)
                    							{
                    								Error("Variable " + left.value + " does not exist in current context5");
                    							}
                    							break;
                    						
											case "%=":
                    							right = Pop(stack);
                    							left = Pop(stack);
                    							try
                    							{
                    								rightVal = right.Calc();
                    								if (!isCompatible(left, rightVal, true))
                    									Error("Can't assign " + rightVal + " to " + left.value);
                    								dynamic rightval = rightVal;
                    								VarData data = parser.FindVar(left.value);
                    								if (data.value.GetType() == rightval.GetType())
                    									data.value %= rightval;
                    								else if (data.type == VarType.Double)
                    									data.value %= (double)rightval;
                    								else
                    									Error("Can't convert \"" + rightval + "\" to " + data.type);
                    								stack.Add(new ExprStackObject(data.value, parser));
                    							}
                    							catch (KeyNotFoundException)
                    							{
                    								Error("Variable " + left.value + " does not exist in current context5");
                    							}
                    							break;

											case "**=":
                    							right = Pop(stack);
                    							left = Pop(stack);
                    							try
                    							{
                    								rightVal = right.Calc();
                    								if (!isCompatible(left, rightVal, true))
                    									Error("Can't assign " + rightVal + " to " + left.value);
                    								dynamic rightval = rightVal;
                    								VarData data = parser.FindVar(left.value);
                    								if (data.value.GetType() == rightval.GetType())
                    									data.value = Math.Pow(data.value, rightval);
                    								else if (data.type == VarType.Double)
                    									data.value = Math.Pow(data.value, rightval);
                    								else
                    									Error("Can't convert \"" + rightval + "\" to " + data.type);
                    								stack.Add(new ExprStackObject(data.value, parser));
                    							}
                    							catch (KeyNotFoundException)
                    							{
                    								Error("Variable " + left.value + " does not exist in current context5");
                    							}
                    							break;
											
											case "&&=":
                    							right = Pop(stack);
                    							left = Pop(stack);
                    							try
                    							{
                    								rightVal = right.Calc();
                    								if (!isCompatible(left, rightVal, true))
                    									Error("Can't assign " + rightVal + " to " + left.value);
                    								dynamic rightval = rightVal;
                    								VarData data = parser.FindVar(left.value);
                    								if (data.value.GetType() == rightval.GetType())
                    									data.value = data.value && rightval;
                    								else
                    									Error("Can't convert \"" + rightval + "\" to " + data.type);
                    								stack.Add(new ExprStackObject(data.value, parser));
                    							}
                    							catch (KeyNotFoundException)
                    							{
                    								Error("Variable " + left.value + " does not exist in current context5");
                    							}
                    							break;
											
											case "||=":
                    							right = Pop(stack);
                    							left = Pop(stack);
                    							try
                    							{
                    								rightVal = right.Calc();
                    								if (!isCompatible(left, rightVal, true))
                    									Error("Can't assign " + rightVal + " to " + left.value);
                    								dynamic rightval = rightVal;
                    								VarData data = parser.FindVar(left.value);
                    								if (data.value.GetType() == rightval.GetType())
                    									data.value = data.value || rightval;
                    								else
                    									Error("Can't convert \"" + rightval + "\" to " + data.type);
                    								stack.Add(new ExprStackObject(data.value, parser));
                    							}
                    							catch (KeyNotFoundException)
                    							{
                    								Error("Variable " + left.value + " does not exist in current context5");
                    							}
                    							break;
                    							
                    						case "sin":
                    							right = Pop(stack);
                    							rightVal = right.Calc();
                    							if (!isCompatible(0.0, rightVal))
                    								Error("Can't convert " + rightVal + " to double");
                    							stack.Add(new ExprStackObject(Math.Sin(rightVal), parser));
                    							break;
                    						
                    						case "cos":
                    							right = Pop(stack);
                    							rightVal = right.Calc();
                    							if (!isCompatible(0.0, rightVal))
                    								Error("Can't convert " + rightVal + " to double");
                    							stack.Add(new ExprStackObject(Math.Cos(rightVal), parser));
                    							break;
                    						
                    						case "tan":
                    							right = Pop(stack);
                    							rightVal = right.Calc();
                    							if (!isCompatible(0.0, rightVal))
                    								Error("Can't convert " + rightVal + " to double");
                    							stack.Add(new ExprStackObject(Math.Tan(rightVal), parser));
                    							break;
                    						
                    						case "asin":
                    							right = Pop(stack);
                    							rightVal = right.Calc();
                    							if (!isCompatible(0.0, rightVal))
                    								Error("Can't convert " + rightVal + " to double");
                    							stack.Add(new ExprStackObject(Math.Asin(rightVal), parser));
                    							break;
                    						
                    						case "acos":
                    							right = Pop(stack);
                    							rightVal = right.Calc();
                    							if (!isCompatible(0.0, rightVal))
                    								Error("Can't convert " + rightVal + " to double");
                    							stack.Add(new ExprStackObject(Math.Acos(rightVal), parser));
                    							break;
                    						
                    						case "atan":
                    							right = Pop(stack);
                    							rightVal = right.Calc();
                    							if (!isCompatible(0.0, rightVal))
                    								Error("Can't convert " + rightVal + " to double");
                    							stack.Add(new ExprStackObject(Math.Atan(rightVal), parser));
                    							break;
                    						
                    						case "atan2":
                    							right = Pop(stack);
                    							left = Pop(stack);
                    							rightVal = right.Calc();
                    							leftVal = left.Calc();
                    							if (!isCompatible(0.0, rightVal))
                    								Error("Can't convert " + rightVal + " to double");
                    							if (!isCompatible(0.0, leftVal))
                    								Error("Can't convert " + leftVal + " to double");
                    							stack.Add(new ExprStackObject(Math.Atan2(leftVal, rightVal), parser));
                    							break;
                    							
                    					}
					
				}
			}
			if (stack.Count > 0)
            {
            	var res = stack[0];
            	try
				{
					res.Calc();
				}
				catch (Exception e)
				{
					return null;
				}
            	if (res.value is string ss && parser.FindVar(ss) != null)
				{
            		value = parser.FindVar(ss).value;
            		return value;
            	}
            	value = res.value;
            	return value;	
            }
            return null;
		}
	}
	
	public VarData FindVar(string name)
	{
		Block par = curBlock;
		while (!par.varTable.ContainsKey(name) && !isParam(par, name))
		{
			//Debug($"sSearching {name} in {par.name}");
			par = par.Parent;
			if (par == null)
			{
				break;
			}
		}                                
		if (par == null)
		{
			Error($"Variable {name} doesn\'t exist in current context!");
		}
		return par?.varTable[name];
	}

	public static bool isParam(Block data, string name)
	{
		if (data is MethodData method)
		{
			foreach (var paramData in method.paramList)
			{
				if (paramData.name == name)
				{
					if (!method.varTable.ContainsKey(name))
					{
						VarData varData = new VarData()
						{
							name = paramData.name,
							type =  paramData.type,
							value = paramData.value
						};
						method.varTable.Add(name, varData);
					}
					return true;
				}
			}	
		}
		return false;
	}

	public VarData FindVar(string name, Block block)
	{
		Block par = block;
		while (!par.varTable.ContainsKey(name) && !isParam(par, name))
		{
			Debug($"Searching {name} in {par.name}");
			par = par.Parent;
			if (par == null)
			{
				break;
			}
		}                                
		if (par == null)
		{
			Error($"Variable {name} doesn\'t exist in block {block.name} context!");
		}
		return par?.varTable[name];
	} 
	
	public class Cycles: OperationClass
    {
        public Block cycleBlock;
        
        	        public Cycles(NinjaParser parser)
        	        {
        		        cycleBlock = new Block(parser);
        	        }
        	        
		public ExprClass cond;
	}
    
	public class While:Cycles
	{
		public override dynamic Eval()
        {
        	parser.curBlock = cycleBlock;
        	Debug("---Entering whilecycle");
        	int i = 0;
        	while(cond.Eval())
			{
				cycleBlock.Eval();
            }
            Debug("---Exiting whilecycle");
            parser.curBlock = cycleBlock.Parent;
    		return null;
        }
        
        public While(NinjaParser parser) : base(parser)
		{
		}
    }
    
    public class Do_while:Cycles
    {
		public override dynamic Eval()
        {
        	Debug("===Entering do_while");
			do
			{
				parser.curBlock = cycleBlock;
				cycleBlock.Eval();
			}
			while(cond.Eval());
			Debug("===Exiting do_while");
			parser.curBlock = parser.curBlock.Parent;
			return null;
		}
		
		public Do_while(NinjaParser parser) : base(parser)
		{
		}
	}
    
    public class For:Cycles
    {
		public ExprClass first;
    	public ExprClass last;
    	
    	public Block oneTimeBlock;
    	
        public override dynamic Eval()
        {
        	parser.curBlock = oneTimeBlock;
        	Debug("===Entering for");
        	first?.Eval();
        	int t = 0;
        	parser.curBlock = cycleBlock;
            while(cond.Eval())
            {
            	parser.curBlock = cycleBlock;
            	cycleBlock.Eval();
            	parser.curBlock = cycleBlock;
            	last?.Eval();
            	parser.curBlock = cycleBlock; 
            }
            Debug("===Exiting for");
            parser.curBlock = oneTimeBlock.Parent;
    		return null;
        }
        
        public For(NinjaParser parser) : base(parser)
		{
			oneTimeBlock = new Block(parser);
			oneTimeBlock.name = "otbl";
			cycleBlock.name = "cbl";
		}
    }    
    
    public class Condition:Cycles 
    {
    	public Block elseIfBlock;
    	private bool full;
        
        	        public Condition(NinjaParser parser, bool f) : base(parser)
        	        {
        		        elseIfBlock = new Block(parser);
        		        full = f;
        	        }
        	        
        public override dynamic Eval()
        {
        	if(cond.Eval())
            {
            	parser.curBlock = cycleBlock;
            	cycleBlock.Eval();
            }
            else if (full)
            {
            	parser.curBlock = elseIfBlock;
				elseIfBlock.Eval();
            }
            parser.curBlock = cycleBlock.Parent;
    		return null;
        }
   	}
}

program : function* main function* {
				curBlock.parser = this;
/*if (parser.metTable.ContainsKey("main"))
                	{
                		++depth;
                		//GoThroughCalls(parser.metTable[call.name]);
                		foreach(var sm in parser.metTable["main"].operations)
                		{
                			sm.Eval();
                		}
                	}*/
                MethodData getSelfId = new MethodData(this){
                	name = "getSelfId",
                    returnType = ReturnType.Int,
					parser = this
                };	
                MethodData getHealth = new MethodData(this){
                    name = "getHealth",
                    returnType = ReturnType.Int,
					parser = this
                };
                ParamData ghp = new ParamData();
                ghp.name = "id";
				ghp.paramType = ParamType.Receive;
				ghp.type = VarType.Int;
				getHealth.paramList.Add(ghp);
                MethodData getPositionX = new MethodData(this){
					name = "getPositionX",
					returnType = ReturnType.Double,
					parser = this
				};
				ParamData gpxp = new ParamData();
				gpxp.name = "id";
                gpxp.paramType = ParamType.Receive;
                gpxp.type = VarType.Int;
               	getPositionX.paramList.Add(gpxp);
                MethodData getPositionY = new MethodData(this){
                    name = "getPositionY",
					returnType = ReturnType.Double,
					parser = this
				};
				ParamData gpyp = new ParamData();
				gpyp.name = "id";
				gpyp.paramType = ParamType.Receive;
				gpyp.type = VarType.Int;
                getPositionY.paramList.Add(gpyp);
				MethodData getDirection = new MethodData(this){
					name = "getDirection",
					returnType = ReturnType.Double,
					parser = this
				};
                ParamData gdp = new ParamData();
                gdp.name = "id";
				gdp.paramType = ParamType.Receive;
				gdp.type = VarType.Int;
				getDirection.paramList.Add(gdp);
				
				
				getSelfId.returnValue = 0;
				getHealth.returnValue = 10;
				getPositionX.returnValue = 0.0;
				getPositionY.returnValue = 0.0;
                getDirection.returnValue = 90.0;
                
                               	
                metTable.Add("getSelfId", getSelfId);
                metTable.Add("getHealth", getHealth);
                metTable.Add("getPositionX", getPositionX);
                metTable.Add("getPositionY", getPositionY);
                metTable.Add("getDirection", getDirection);
                #if NOGUI
					metTable["main"].Eval();
				#endif
};

main : main_signature OBRACE main_code CBRACE
{
	
};

main_signature : FUN_KEYWORD VOID MAIN LPAREN RPAREN {
	MethodData newMet = new MethodData(this)
	{
		name = "main",
		returnType = ReturnType.Void,
		parser = this
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

	MethodData newMet = new MethodData(this)
	{
		name = methodName,
		returnType = ReturnType.Void,
		parser = this
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
    		throw new Exception($"Actual return is {$method_return.type}, expected declared return type {metTable[methodName].returnType}");    
    }
	
	

	if (actualReturn != metTable[methodName].returnType){
		throw new Exception($"Actual return is {actualReturn}, expected declared return type {metTable[methodName].returnType}");
	} */
	
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

	MethodData newMet = new MethodData(this)
	{
		name = methodName,
		isMeaningful = true,
		parser = this
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

code : (operation)*;

main_code : (operation)*;

operation : call[curBlock.createExpressionClass(), true] | custom_call[curBlock.createExpressionClass(), true] | declare[curBlock.createExpressionClass()] | ariphExprEx[curBlock.createExpressionClass()] | boolExprEx[curBlock.createExpressionClass()]
			| myif[null]|myif_short[null]|mywhile[null]|mydo_while[null]|myfor[null];

method_return[OperationClass oper] returns [string type, dynamic value]: RETURN_KEYWORD val_or_id[curBlock.ToExpr()] {
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
							
							break;
							
						case "double":
							newVar.type = VarType.Double;
							
							break;
							
						case "bool":
							newVar.type = VarType.Bool;
							
							break;
					}
					ParamData pData = new ParamData();
					pData.name = $ID.text;
					pData.type = newVar.type;
					metTable[funName].paramList.Add(pData);
					metTable[funName].varTable[$ID.text] = newVar;
				};

builtin_func_state returns [ReturnType returnType] : 	'getSelfId' {$returnType = ReturnType.Int;}|
														'getPositionX' {$returnType = ReturnType.Double;}|
														'getPositionY' {$returnType = ReturnType.Double;}|
														'getDirection' {$returnType = ReturnType.Double;}|
														'getHealth' {$returnType = ReturnType.Int;};

builtin_func_p : 'move'|'turn' ;

builtin_func_e : 'hit'|'shoot' ;  

call[ExprClass oper, bool independent] returns [CallData callData] : parameterized_call[$oper] {

	CallData data = new CallData(){
		callType = CallType.BuiltIn, 
		name = $parameterized_call.text.Substring(0, $parameterized_call.text.IndexOf("(")),
		returnType = $parameterized_call.type,
		parent = curBlock,
		parser = this
	};
	
	string methodName = currentMet;
	if(methodName != "?" && independent){
		curBlock.operations.Add(data);
	}
	
	foreach (var par in _localctx._parameterized_call.call_params().val_or_id())
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
            		//Error($"Unknown type {par.type}");
            		//throw new NotImplementedException();
            		break;
            }
            d.value = par.value;
    		data.paramList.Insert(0, d);		
    	}
		$callData = data;

} | simple_call {

	CallData data = new CallData(){
		callType = CallType.BuiltIn, 
		name = $simple_call.text.Substring(0, $simple_call.text.IndexOf("(")),
		returnType = ReturnType.Void,
        parent = curBlock,
		parser = this
	};
	$callData = data;
	string methodName = currentMet;
	if(methodName != "?" && independent){
		curBlock.operations.Add(data);
	}
};

parameterized_call[ExprClass oper] returns [ExprClass res, ReturnType type]: builtin_func_p LPAREN call_params[$oper] RPAREN {
	$type = ReturnType.Void;
	$res = $oper;
} | builtin_func_state LPAREN call_params[$oper] RPAREN {
    $type = $builtin_func_state.returnType;
    $res = $oper;
};

simple_call : builtin_func_e LPAREN RPAREN;

custom_call[ExprClass oper, bool independent] returns [string funName, CallData callData]: ID LPAREN call_params[$oper] RPAREN {

	string callName = $ID.text;
	$funName = callName;
	CallData data = new CallData(){
		callType = CallType.Custom, 
		name = callName,
        parent = curBlock,
		parser = this
	};
	
	if (metTable.ContainsKey(callName))
		data.returnType = metTable[callName].returnType;

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
        		//Error($"Unknown type {par.type}");
        		//throw new NotImplementedException();
        		break;
        }
        d.value = par.value;
		data.paramList.Insert(0, d);    			
	}
	
	string methodName = currentMet;
	if (independent)
    	curBlock.operations.Add(data);
	$callData = data;
};

call_params[ExprClass oper] : (val_or_id[$oper] (COMMA val_or_id[$oper])*)?;

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
                else if ($value.GetType() == typeof(ExprClass))
                	$type = $value.GetType().ToString();
			}
		  | boolExprEx[$oper]
			{
				$value = $boolExprEx.res;
				$type = "bool";
			};

//cyclemetka
myif[ExprClass oper]:
{
	ExprClass bExpr = new ExprClass(new OperationClass(this));
	bExpr.parser = this;
	
	Condition ifer = new Condition(this, false)
	{
		
		parser = this
	};
	curBlock.operations.Add(ifer);
	ifer.cycleBlock.Parent = curBlock;
	curBlock = ifer.cycleBlock;

} IF LPAREN boolExprEx[bExpr] RPAREN 
     OBRACE 
     {
     	ifer.cond=$boolExprEx.res;
     }
    (operation)* 
    CBRACE
     ELSE 
      OBRACE
      {
      	ifer.elseIfBlock.Parent = curBlock.Parent;
      	curBlock = ifer.elseIfBlock;
      } 
    (operation)*
    CBRACE
    {
        curBlock = curBlock.Parent;
     }
   ;
myif_short[ExprClass oper]: {

	ExprClass bExpr = new ExprClass(new OperationClass(this));
	bExpr.parser = this;
	
	Condition ifer = new Condition(this, false)
	{
		
		parser = this
	};
	curBlock.operations.Add(ifer);
	ifer.cycleBlock.Parent = curBlock;
	curBlock = ifer.cycleBlock;

} IF LPAREN boolExprEx[bExpr] RPAREN 
    OBRACE 
    {
    		ifer.cond=$boolExprEx.res;
         	
         	
    }
    (operation)* 
    CBRACE
    {
        curBlock = curBlock.Parent;
    }
   ;
mywhile[ExprClass oper]: {
ExprClass bExpr = new ExprClass(new OperationClass(this));
bExpr.parser = this;

While whiler = new While(this)
     	{
     		
			parser = this
     	};
     	curBlock.operations.Add(whiler);
     	whiler.cycleBlock.Parent = curBlock;
     	curBlock = whiler.cycleBlock;

} WHILE LPAREN boolExprEx[bExpr] RPAREN 
     OBRACE 
     {
     	whiler.cond=$boolExprEx.res;
     }
     (operation)*
     CBRACE 
     {
        curBlock = curBlock.Parent;
      }
       ;
mydo_while[ExprClass oper]: DO 
          OBRACE 
          {
          		ExprClass bExpr = new ExprClass(new OperationClass(this));
                bExpr.parser = this;
          		Do_while doer = new Do_while(this);
				doer.parser = this;
               	curBlock.operations.Add(doer);
               	doer.cycleBlock.Parent = curBlock;
               	curBlock = doer.cycleBlock;
          }
            (operation)* 
          CBRACE
          WHILE LPAREN boolExprEx[bExpr] RPAREN 
          {
            	doer.cond=$boolExprEx.res;
            	curBlock = curBlock.Parent;
           }
          ;
myfor[ExprClass oper]: {

	
}  FOR LPAREN {

		For forer = new For(this);
		forer.parser = this;
		
		forer.oneTimeBlock.Parent = curBlock;
		forer.cycleBlock.Parent = forer.oneTimeBlock;
            	curBlock = forer.oneTimeBlock;
		
		ExprClass fExpr = new ExprClass(new OperationClass(this));
        fExpr.parser = this;    	
						
} (declare[fExpr]
{
	fExpr = $declare.res;
}


|ariphExprEx[fExpr]
{
	fExpr = $ariphExprEx.res;
})?




                 SEMICOLON
                  
                  {
                  		
                      	ExprClass cExpr = new ExprClass(new OperationClass(this));
                      	cExpr.parser = this;
                  
                  }
                  
                  boolExprEx[cExpr]?
                 SEMICOLON {
                 
					ExprClass lExpr = new ExprClass(new OperationClass(this));
                 lExpr.parser = this;
                 }l=ariphExprEx[lExpr]? RPAREN
        OBRACE
        {

				try {
					forer.cond = $boolExprEx.res;
				} catch {
					 cExpr.Push(new ExprStackObject(true, this));
					 forer.cond = cExpr;
				}
			  	forer.first = fExpr;
			  	forer.last = (_localctx.l == null) ? null : $l.res;
				curBlock = forer.cycleBlock;       	
        }
        (operation)*
        CBRACE
        { 
        	curBlock = forer.oneTimeBlock.Parent;
        	curBlock.operations.Add(forer);    
        }
     ;

//Code related to variables
ariphOperand[ExprClass oper]:
               INT
               {
                   $oper.Push(new ExprStackObject(int.Parse($INT.text), this));
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
					$oper.Push(new ExprStackObject(value, this));
               }
             | custom_call[$oper, false]
             	{
             		$oper.Push(new ExprStackObject()
					{
						type = ObjType.Function,
						value = $custom_call.callData,
						parser = this
					});
             	}
             | call[$oper, false]
             	{
                    $oper.Push(new ExprStackObject()
             		{
             			type = ObjType.Function,
             			value = $call.callData,
						parser = this
             		});
                }
			 | SUB ariphOperand[$oper]
				{
					$oper.Push(new ExprStackObject()
             		{
             			type = ObjType.Operation,
             			value = "-un",
						parser = this
             		});
				}
             | ariphID[$oper]
               {

               }
			 | trig[$oper] | trig2[$oper]
			 | incdec=(INC|DEC) ariphID[$oper]
			   {
					$oper.Push(new ExprStackObject()
					{
						type = ObjType.Operation,
						value = $incdec.text + "pre",
						parser = this
					});
			   }
			 | ariphID[$oper] incdec=(INC|DEC)
			   {
			   
					$oper.Push(new ExprStackObject()
					{
						type = ObjType.Operation,
						value = $incdec.text + "post",
						parser = this
					});
			   }
             | LPAREN ariphExprEx[$oper] RPAREN;
ariphTerm[ExprClass oper]:
            ariphOperand[$oper]
            
           (muldiv=(POW|MUL|DIV|MOD) ariphOperand[$oper]
            {
				if ($muldiv.text != null)
				{
					$oper.Push(new ExprStackObject()
					 {
						type = ObjType.Operation,
						value = $muldiv.text,
						parser = this
					 });
				}
            })*;
ariphExpr[ExprClass oper]:
            ariphTerm[$oper]
            {
                
            }
			(addsub=(ADD|SUB) ariphTerm[$oper]
            {
				if ($addsub.text != null)
				{
					$oper.Push(new ExprStackObject()
					 {
						type = ObjType.Operation,
						value = $addsub.text,
						parser = this
					 });
					 
				}
            })*;
ariphExprEx[ExprClass oper] returns [ExprClass res]:
            ariphExpr[$oper]
            {
                $res = $oper;
            }
          | ariphID[$oper] assigns=(ASSIGN|ADDASSIGN|SUBASSIGN|POWASSIGN|MULASSIGN|DIVASSIGN|MODASSIGN) ariphExprEx[$oper]
            {
                $oper.Push(new ExprStackObject()
					 {
						type = ObjType.Operation,
						value = $assigns.text,
						parser = this
					 });
				$res = $oper;
            };

boolOperand[ExprClass oper]:
              BOOL
              {
                  $oper.Push(new ExprStackObject(bool.Parse($BOOL.text), this));
              }
            | custom_call[$oper, false]
                          	{
                          		$oper.Push(new ExprStackObject()
             					{
             						type = ObjType.Function,
             						value = $custom_call.callData,
									parser = this
             					});
                          	} 
            | ariphID[$oper]
			  {
			  }
            | ariphExprEx[$oper] comp=(LESS|GREATER|EQUAL|NOTEQUAL|LESSEQUAL|GREQUAL) ariphExprEx[$oper]
              {
				$oper.Push(new ExprStackObject()
				{
					type = ObjType.Operation,
					value = $comp.text,
						parser = this
				}); 
			  }
			| NOT boolOperand[$oper]
			{
				$oper.Push(new ExprStackObject()
				{
					type = ObjType.Operation,
					value = $NOT.text,
						parser = this
				});
			}
            | LPAREN boolExprEx[$oper] RPAREN;
boolExpr[ExprClass oper]:
           boolOperand[$oper]
         | left=boolOperand[$oper] andor=(AND|OR) right=boolExpr[$oper]
           {
				$oper.Push(new ExprStackObject()
				{
					type = ObjType.Operation,
					value = $andor.text,
						parser = this
				});
           };
boolExprEx[ExprClass oper] returns [ExprClass res]:
           boolExpr[$oper]
		   {
				$res = $oper;
		   }
         | left=ariphID[$oper] assigns=(ASSIGN|ORASSIGN|ANDASSIGN) right=boolExprEx[$oper]
           {
				$oper.Push(new ExprStackObject()
				{
					type = ObjType.Operation,
					value = $assigns.text,
						parser = this
				});
				$res = $oper;
           };

//declaration
declare[ExprClass oper] returns [ExprClass res]: INTKEY ariphID[$oper]
          {
           VarData newVar = new VarData
           {
           		name = $ariphID.text,
                type = VarType.Int
           };
           curBlock.varTable.Add($ariphID.text, newVar);
          }
          (ASSIGN ariphExprEx[$oper])?
          {
           if ($ariphExprEx.text != null)
           {
				$oper.Push(new ExprStackObject()
					 {
						type = ObjType.Operation,
						value = "=",
						parser = this
					 });
           }
           $res = $oper;
          }
          
        | DOUBLEKEY ariphID[$oper]
          {
           VarData newVar = new VarData
           {	
           		name = $ariphID.text,
                type = VarType.Double
           };
           curBlock.varTable.Add($ariphID.text, newVar);
          }
          (ASSIGN ariphExprEx[$oper])?
          {
           if ($ariphExprEx.text != null)
           {
                $oper.Push(new ExprStackObject()
					 {
						type = ObjType.Operation,
						value = "=",
						parser = this
					 });
           }
           $res = $oper;
          }
        | BOOLKEY ariphID[$oper]
          {
           VarData newVar = new VarData
           {
           		name = $ariphID.text,
                type = VarType.Bool
           };
           curBlock.varTable.Add($ariphID.text, newVar);
          }
          (ASSIGN boolExprEx[$oper])?
          {
           if ($boolExprEx.text != null)
           {
                $oper.Push(new ExprStackObject()
				{
					type = ObjType.Operation,
					value = "=",
						parser = this
				});
           }
           $res = $oper;
          };

ariphID[ExprClass oper] : ID
		{
			$oper.Push(new ExprStackObject()
					 {
						type = ObjType.Var,
						value = $ID.text,
						parser = this
					 });
		};

//trigonometry

trig[ExprClass oper]:
		trfun=(SIN|COS|TAN|ASIN|ACOS|ATAN) LPAREN ariphExprEx[$oper] RPAREN
              		{
              			$oper.Push(new ExprStackObject()
              					 {
              						type = ObjType.Operation,
              						value = $trfun.text,
              						parser = this
              					 });
              		};
trig2[ExprClass oper]:
		ATAN2 LPAREN ariphExprEx[$oper] COMMA ariphExprEx[$oper] RPAREN
		{
			$oper.Push(new ExprStackObject()
					 {
						type = ObjType.Operation,
						value = "atan2",
						parser = this
					 });
		};
		

//code related to cycles



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
MOD     : '%' ;
POW     : '**' ;
INC		: '++' ;
DEC		: '--' ;
ASSIGN		: '=' ;
ADDASSIGN   : '+=' ;
SUBASSIGN   : '-=' ;
MULASSIGN   : '*=' ;
DIVASSIGN   : '/=' ;
MODASSIGN   : '%=' ;
POWASSIGN   : '**=' ;
AND       : '&&' ;
OR        : '||' ;
ANDASSIGN : '&&=' ;
ORASSIGN  : '||=' ;
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
DOUBLE  : [+-]?DIGIT*[.]DIGIT+ ;
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