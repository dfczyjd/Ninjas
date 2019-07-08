grammar NinjaVars;

options
{
    language=CSharp;
}

@parser::header
{
    
}

@parser::members 
{
    public class VarData
    {
        public enum VarType
        {
            Int, Double, Bool
        };

        public VarType type;
        public dynamic value;
    }
 
    public static Dictionary<string, VarData> varTable = new Dictionary<string, VarData>();
    
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
}

program : (operation OPSEP)*;

operation : ariphExprEx | boolExprEx
          | declare ;

ariphOperand returns [dynamic value]:
               INT
               {
                   $value = int.Parse($INT.text);
               }
             | DOUBLE
               {
                   $value = double.Parse($DOUBLE.text);
               }
             | ID
               {
                   try
                   {
                     $value = varTable[$ID.text].value;
                   }
                   catch (KeyNotFoundException)
                   {
                     Error("Variable " + $ID.text + " does not exist");
                   }
               }
             | LPAREN ariphExprEx RPAREN
               {
                   $value = $ariphExprEx.value;
               };
ariphTerm returns [dynamic value]:
            ariphOperand
            {
                $value = $ariphOperand.value;
            }
          | left=ariphTerm MUL right=ariphOperand
            {
                $value = $left.value * $right.value;
            }
          | left=ariphTerm DIV right=ariphOperand
            {
                $value = $left.value / $right.value;
            };
ariphExpr returns [dynamic value]:
            ariphTerm
            {
                $value = $ariphTerm.value;
            }
          | left=ariphExpr ADD right=ariphTerm
            {
                $value = $left.value + $right.value;
            }
          | left=ariphExpr SUB right=ariphTerm
            {
                $value = $left.value - $right.value;
            };
ariphExprEx returns [dynamic value]:
            ariphExpr
            {
                $value = $ariphExpr.value;
            }
          | ID ASSIGN ariphExprEx
            {
                try
                {
                    VarData data = varTable[$ID.text];
                    if (data.value.GetType() == $ariphExprEx.value.GetType())
                        data.value = $ariphExprEx.value;
                    else if (data.type == VarData.VarType.Double)
                        data.value = (double)$ariphExprEx.value;
                    else
                        Error("Can't convert \"" + $ariphExprEx.text + "\" to Int");
                }
                catch (KeyNotFoundException)
                {
                  Error("Variable " + $ID.text + " does not exist");
                }
            }
          | ID ADDASSIGN ariphExprEx
            {
                try
                {
                    VarData data = varTable[$ID.text];
                    if (data.value.GetType() == $ariphExprEx.value.GetType())
                        data.value += $ariphExprEx.value;
                    else if (data.type == VarData.VarType.Double)
                        data.value += (double)$ariphExprEx.value;
                    else
                        Error("Can't convert \"" + $ariphExprEx.text + "\" to Int");
                }
                catch (KeyNotFoundException)
                {
                  Error("Variable " + $ID.text + " does not exist");
                }
            }
          | ID SUBASSIGN ariphExprEx
            {
                try
                {
                    VarData data = varTable[$ID.text];
                    if (data.value.GetType() == $ariphExprEx.value.GetType())
                        data.value -= $ariphExprEx.value;
                    else if (data.type == VarData.VarType.Double)
                        data.value -= (double)$ariphExprEx.value;
                    else
                        Error("Can't convert \"" + $ariphExprEx.text + "\" to Int");
                }
                catch (KeyNotFoundException)
                {
                  Error("Variable " + $ID.text + " does not exist");
                }
            }
          | ID MULASSIGN ariphExprEx
            {
                try
                {
                    VarData data = varTable[$ID.text];
                    if (data.value.GetType() == $ariphExprEx.value.GetType())
                        data.value *= $ariphExprEx.value;
                    else if (data.type == VarData.VarType.Double)
                        data.value *= (double)$ariphExprEx.value;
                    else
                        Error("Can't convert \"" + $ariphExprEx.text + "\" to Int");
                }
                catch (KeyNotFoundException)
                {
                  Error("Variable " + $ID.text + " does not exist");
                }
            }
          | ID DIVASSIGN ariphExprEx
            {
                try
                {
                    VarData data = varTable[$ID.text];
                    if (data.value.GetType() == $ariphExprEx.value.GetType())
                        data.value /= $ariphExprEx.value;
                    else if (data.type == VarData.VarType.Double)
                        data.value /= (double)$ariphExprEx.value;
                    else
                        Error("Can't convert \"" + $ariphExprEx.text + "\" to Int");
                }
                catch (KeyNotFoundException)
                {
                  Error("Variable " + $ID.text + " does not exist");
                }
            };

boolOperand returns [bool value]:
              BOOL
              {
                  $value = bool.Parse($BOOL.text);
              }
            | ID
              {
                  try
                  {
                      $value = varTable[$ID.text].value;
                  }
                  catch (KeyNotFoundException)
                  {
                    Error("Variable " + $ID.text + " does not exist");
                  }
              }
            | left=ariphExprEx LESS right=ariphExprEx
              {
                  $value = $left.value < $right.value;
              }
            | left=ariphExprEx GREATER right=ariphExprEx
              {
                  $value = $left.value > $right.value;
              }
            | left=ariphExprEx EQUAL right=ariphExprEx
              {
                  $value = $left.value == $right.value;
              }
            | left=ariphExprEx NOTEQUAL right=ariphExprEx
              {
                  $value = $left.value != $right.value;
              }
            | left=ariphExprEx LESSEQUAL right=ariphExprEx
              {
                  $value = $left.value <= $right.value;
              }
            | left=ariphExprEx GREQUAL right=ariphExprEx
              {
                  $value = $left.value >= $right.value;
              }
            /*| leftBool=boolExprEx EQUAL rightBool=boolExprEx
              {
                  $value = $leftBool.value == $rightBool.value;
              }
            | leftBool=boolExprEx NOTEQUAL rightBool=boolExprEx
              {
                  $value = $leftBool.value != $rightBool.value;
              }
            | LPAREN boolExprEx RPAREN
              {
                  $value = $boolExprEx.value;
              }*/;
boolExpr returns [bool value]:
           boolOperand
           {
               $value = $boolOperand.value;
           }
         | left=boolOperand OR right=boolExpr
           {
               $value = $left.value || $right.value;
           }
         | left=boolOperand AND right=boolExpr
           {
               $value = $left.value && $right.value;
           };
boolExprEx returns [bool value]:
           boolExpr
           {
              $value = $boolExpr.value;
           }
         | ID ASSIGN boolExprEx
           {
              try
              {
                VarData data = varTable[$ID.text];
              }
              catch (KeyNotFoundException)
              {
                Error("Variable " + $ID.text + " does not exist");
              }
              if (data.type != VarData.VarType.Bool)
              {
                  Error("Can't convert " + data.type + " to Bool");
              }
              $value = data.value = $boolExprEx.value;
           };

//declaration
declare : INTKEY ID
          {
           VarData newVar = new VarData
           {
                type = VarData.VarType.Int,
                value = 0
           };
           varTable.Add($ID.text, newVar);
           Debug("Create var " + $ID.text);
          }
          (ASSIGN ariphExprEx)?
          {
           if ($ariphExprEx.text != null)
           {
                Debug("\tAssigning it value of " + $ariphExprEx.text);
                try
                {
                  VarData data = varTable[$ID.text];
                  if (data.value.GetType() == $ariphExprEx.value.GetType())
                    data.value = $ariphExprEx.value;
                  else
                    Error("Can't convert \"" + $ariphExprEx.text + "\" to Int");
                }
                catch (KeyNotFoundException)
                {
                  Error("Variable " + $ID.text + " does not exist");
                }
           }
          }
          
        | DOUBLEKEY ID
          {
           VarData newVar = new VarData
           {
                type = VarData.VarType.Double,
                value = 0.0
           };
           varTable.Add($ID.text, newVar);
           Debug("Create var " + $ID.text);
          }
          (ASSIGN ariphExprEx)?
          {
           if ($ariphExprEx.text != null)
           {
                Debug("\tAssigning it value of " + $ariphExprEx.text);
                try
                {
                  VarData data = varTable[$ID.text];
                  if (data.value.GetType() == $ariphExprEx.value.GetType())
                    data.value = $ariphExprEx.value;
                  else if (data.type == VarData.VarType.Double)
                    data.value = (double)$ariphExprEx.value;
                }
                catch (KeyNotFoundException)
                {
                  Error("Variable " + $ID.text + " does not exist");
                }
           }
          }
        | BOOLKEY ID
          {
           VarData newVar = new VarData
           {
                type = VarData.VarType.Bool,
                value = false
           };
           varTable.Add($ID.text, newVar);
           Debug("Create var " + $ID.text);
          }
          (ASSIGN boolExprEx)?
          {
           if ($boolExprEx.text != null)
           {
                Debug("\tAssigning it value of " + $boolExprEx.text);
                try
                {
                  varTable[$ID.text].value = $boolExprEx.value;
                }
                catch (KeyNotFoundException)
                {
                  Error("Variable " + $ID.text + " does not exist");
                }
           }
          };

OPSEP   : '\n' ;

//keywords
INTKEY      : 'int' ;
DOUBLEKEY   : 'double' ;
BOOLKEY     : 'bool' ;

//operators
ASSIGN  : '=' ;
ADD     : '+' ;
SUB     : '-' ;
MUL     : '*' ;
DIV     : '/' ;
ADDASSIGN   : '+=' ;
SUBASSIGN   : '-=' ;
MULASSIGN   : '*=' ;
DIVASSIGN   : '/=' ;
AND       : '&&' ;
OR        : '||' ;
LESS      : '<' ;
GREATER   : '>' ;
EQUAL     : '==' ;
NOTEQUAL  : '!=' ;
LESSEQUAL : '<=' ;
GREQUAL   : '>=' ;
LPAREN  : '(' ;
RPAREN  : ')' ;

//Whitespace symbols
WS : [ \t\r]+ -> skip ;

//literals
BOOL    : ('true'|'false') ;
DOUBLE  : [+-]?DIGIT*[,]DIGIT+ ;
INT     : [+-]?DIGIT+ ;

ID  : LETTER (LETTER | DIGIT)* ;

//lexer rule fragments
fragment LETTER : [a-zA-Z_] ;
fragment DIGIT : [0-9] ;