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
}

program : (operation OPSEP)*;

operation : intExprEx | doubleExprEx | boolExprEx
          | declare ;

intOperand returns [int value]:
             INT
            {
            $value = 1;
            }
           | ID
             {
              $value = varTable[$ID.text].value;
             }
           | LPAREN intExprEx RPAREN
             {
              $value = $intExprEx.value;
             };
intTerm returns [int value]:
          intOperand
          {
           $value = $intOperand.value;
          }
        | intTerm MUL intOperand
          {
           $value = 1 * $intOperand.value;
          }
        | intTerm DIV intOperand
          {
           $value = 1 / $intOperand.value;
          };
intExpr returns [int value]:
          intTerm
          {
           $value = $intTerm.value;
          }
        | intExpr ADD intTerm
          {
           $value = 1 + $intTerm.value;
          }
        | intExpr SUB intTerm
          {
           $value = 1 - $intTerm.value;
          };
intExprEx returns [int value]:
            intExpr
            {
             $value = $intExpr.value;
            }
          | ID ASSIGN intExprEx
            {
             VarData data = varTable[$ID.text];
             if (data.type != VarData.VarType.Int)
                Console.WriteLine("Int expected, " + data.type + " given");
             $value = data.value = $intExprEx.value;
            }
          | ID ADDASSIGN intExprEx
            {
             VarData data = varTable[$ID.text];
             if (data.type != VarData.VarType.Int)
                Console.WriteLine("Int expected, " + data.type + " given");
             $value = data.value += $intExprEx.value;
            }
          | ID SUBASSIGN intExprEx
            {
             VarData data = varTable[$ID.text];
             if (data.type != VarData.VarType.Int)
                Console.WriteLine("Int expected, " + data.type + " given");
             $value = data.value -= $intExprEx.value;
            }
          | ID MULASSIGN intExprEx
            {
             VarData data = varTable[$ID.text];
             if (data.type != VarData.VarType.Int)
                Console.WriteLine("Int expected, " + data.type + " given");
             $value = data.value *= $intExprEx.value;
            }
          | ID DIVASSIGN intExprEx
            {
             VarData data = varTable[$ID.text];
             if (data.type != VarData.VarType.Int)
                Console.WriteLine("Int expected, " + data.type + " given");
             $value = data.value /= $intExprEx.value;
            };

doubleOperand : DOUBLE | ID
              | LPAREN doubleExprEx RPAREN ;
doubleTerm : doubleOperand
        | doubleTerm MUL doubleOperand
        | doubleTerm DIV doubleOperand ;
doubleExpr : doubleTerm
        | doubleExpr ADD doubleTerm
        | doubleExpr SUB doubleTerm ;
doubleExprEx : doubleExpr
          | ID ASSIGN doubleExprEx
          | ID ADDASSIGN doubleExprEx
          | ID SUBASSIGN doubleExprEx
          | ID MULASSIGN doubleExprEx
          | ID DIVASSIGN doubleExprEx ;

boolOperand : BOOL | ID
            | LPAREN boolExprEx RPAREN ;
boolExpr : boolOperand
         | boolOperand OR boolExpr
         | boolOperand AND boolExpr
         | boolOperand XOR boolExpr ;
boolExprEx : boolExpr
         | ID ASSIGN boolExprEx
         | ID ANDASSIGN boolExprEx
         | ID ORASSIGN boolExprEx
         | ID XORASSIGN boolExprEx ;

//declaration
declare : INTKEY ID
          {
           VarData newVar = new VarData
           {
                type = VarData.VarType.Int,
                value = 0
           };
           varTable.Add($ID.text, newVar);
           Console.WriteLine("Create var " + $ID.text);
          }
          (ASSIGN intExprEx)?
          {
           if ($intExprEx.text != null)
           {
                varTable[$ID.text].value = $intExprEx.value;
                Console.WriteLine("\tAssigning it value of " + $intExprEx.text);                
           }
           }
          
        | DOUBLEKEY ID
          {
           VarData newVar = new VarData
           {
                type = VarData.VarType.Double,
                value = 0
           };
           varTable.Add($ID.text, newVar);
           Console.WriteLine("Create var " + $ID.text);
          }
          (ASSIGN doubleExprEx)?
        | BOOLKEY ID (ASSIGN boolExprEx)? ;

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
AND     : '&&';
OR      : '||';
XOR     : '^';
ANDASSIGN   : '&&=' ;
ORASSIGN    : '||=' ;
XORASSIGN   : '^=' ;
LPAREN  : '(' ;
RPAREN  : ')' ;

//Whitespace symbols
WS : [ \t\r]+ -> skip ;

//literals
BOOL    : ('true'|'false') ;
DOUBLE  : [+-]?DIGIT*[.]DIGIT+ ;
INT     : [+-]?DIGIT+ ;

ID  : LETTER (LETTER | DIGIT)* ;

//lexer rule fragments
fragment LETTER : [a-zA-Z_] ;
fragment DIGIT : [0-9] ;