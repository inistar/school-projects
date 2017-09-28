package crux;

import java.util.ArrayList;
import java.util.List;
import java.util.Stack;

public class Parser {
    public static String studentName = "Iniyavan Sathiamurthi";
    public static String studentID = "26242138";
    public static String uciNetID = "ISATHIAM";
    
// SymbolTable Management ==========================
    private SymbolTable symbolTable;
    
    private void initSymbolTable()
    {
        symbolTable = new SymbolTable();
        
        symbolTable.insert("readInt");
        symbolTable.insert("readFloat");
        symbolTable.insert("printBool");
        symbolTable.insert("printInt");
        symbolTable.insert("printFloat");
        symbolTable.insert("println");
    }
    
    private void enterScope()
    {
        symbolTable = new SymbolTable(symbolTable);
    }
    
    private void exitScope()
    {
        symbolTable = symbolTable.popSymbolTable();
    }

    private Symbol tryResolveSymbol(Token ident)
    {
        assert(ident.is(Token.Kind.IDENTIFIER));
        String name = ident.lexeme();
        try {
            return symbolTable.lookup(name);
        } catch (SymbolNotFoundError e) {
            String message = reportResolveSymbolError(name, ident.lineNumber(), ident.charPosition());
            return new ErrorSymbol(message);
        }
    }

    private String reportResolveSymbolError(String name, int lineNum, int charPos)
    {
        String message = "ResolveSymbolError(" + lineNum + "," + charPos + ")[Could not find " + name + ".]";
        errorBuffer.append(message + "\n");
        errorBuffer.append(symbolTable.toString() + "\n");
        return message;
    }

    private Symbol tryDeclareSymbol(Token ident)
    {
        assert(ident.is(Token.Kind.IDENTIFIER));
        String name = ident.lexeme();
        try {
            return symbolTable.insert(name);
        } catch (RedeclarationError re) {
            String message = reportDeclareSymbolError(name, ident.lineNumber(), ident.charPosition());
            return new ErrorSymbol(message);
        }
    }

    private String reportDeclareSymbolError(String name, int lineNum, int charPos)
    {
        String message = "DeclareSymbolError(" + lineNum + "," + charPos + ")[" + name + " already exists.]";
        errorBuffer.append(message + "\n");
        errorBuffer.append(symbolTable.toString() + "\n");
        return message;
    }    

// Helper Methods ==========================================

    private Token expectRetrieve(Token.Kind kind)
    {
        Token tok = currentToken;
        if (accept(kind))
            return tok;
        String errorMessage = reportSyntaxError(kind);
        throw new QuitParseException(errorMessage);
        //return ErrorToken(errorMessage);
    }
        
    private Token expectRetrieve(NonTerminal nt)
    {
        Token tok = currentToken;
        if (accept(nt))
            return tok;
        String errorMessage = reportSyntaxError(nt);
        throw new QuitParseException(errorMessage);
        //return ErrorToken(errorMessage);
    }
              
// Parser ==========================================
    
    public void parse()
    {
        initSymbolTable();
        try {
            program();
        } catch (QuitParseException q) {
            errorBuffer.append("SyntaxError(" + lineNumber() + "," + charPosition() + ")");
            errorBuffer.append("[Could not complete parsing.]");
        }
    }

    /**
    public void program()
    {
        throw new RuntimeException("implement symbol table into grammar rules");
    }
    **/
 // Grammar Rule Reporting ==========================================
    private int parseTreeRecursionDepth = 0;
    private StringBuffer parseTreeBuffer = new StringBuffer();

    public void enterRule(NonTerminal nonTerminal) {
        String lineData = new String();
        for(int i = 0; i < parseTreeRecursionDepth; i++)
        {
            lineData += "  ";
        }
        lineData += nonTerminal.name();
        //System.out.println("descending " + lineData);
        parseTreeBuffer.append(lineData + "\n");
        parseTreeRecursionDepth++;
    }
    
    private void exitRule(NonTerminal nonTerminal)
    {
        parseTreeRecursionDepth--;
    }
    
    public String parseTreeReport()
    {
        return parseTreeBuffer.toString();
    }

// Error Reporting ==========================================
    private StringBuffer errorBuffer = new StringBuffer();
    
    private String reportSyntaxError(NonTerminal nt)
    {
        String message = "SyntaxError(" + lineNumber() + "," + charPosition() + ")[Expected a token from " + nt.name() + " but got " + currentToken.getKind() + ".]";
        errorBuffer.append(message + "\n");
        return message;
    }
     
    private String reportSyntaxError(Token.Kind kind)
    {
        String message = "SyntaxError(" + lineNumber() + "," + charPosition() + ")[Expected " + kind + " but got " + currentToken.getKind() + ".]";
        errorBuffer.append(message + "\n");
        return message;
    }
    
    public String errorReport()
    {
        return errorBuffer.toString();
    }
    
    public boolean hasError()
    {
        return errorBuffer.length() != 0;
    }
    
    private class QuitParseException extends RuntimeException
    {
        private static final long serialVersionUID = 1L;
        public QuitParseException(String errorMessage) {
            super(errorMessage);
        }
    }
    
    private int lineNumber()
    {
        return currentToken.lineNumber();
    }
    
    private int charPosition()
    {
        return currentToken.charPosition();
    }
          
// Parser ==========================================
    private Scanner scanner;
    private Token currentToken;
    
    public Parser(Scanner scanner)
    {
//        throw new RuntimeException("implement this");
    	this.scanner = scanner;
    	this.currentToken = scanner.next();
    }
    
    /**
    public void parse()
    {
        try {
            program();
        } catch (QuitParseException q) {
            errorBuffer.append("SyntaxError(" + lineNumber() + "," + charPosition() + ")");
            errorBuffer.append("[Could not complete parsing.]");
        }
    }
    **/
    
// Helper Methods ==========================================
    private boolean have(Token.Kind kind)
    {
        return currentToken.is(kind);
    }
    
    private boolean have(NonTerminal nt)
    {
        return nt.firstSet().contains(currentToken.getKind());
    }

    private boolean accept(Token.Kind kind)
    {
        if (have(kind)) {
            currentToken = scanner.next();
            return true;
        }
        return false;
    }    
    
    private boolean accept(NonTerminal nt)
    {
        if (have(nt)) {
            currentToken = scanner.next();
            return true;
        }
        return false;
    }
   
    private boolean expect(Token.Kind kind)
    {
        if (accept(kind))
            return true;
        String errorMessage = reportSyntaxError(kind);
        throw new QuitParseException(errorMessage);
        //return false;
    }
        
    private boolean expect(NonTerminal nt)
    {
        if (accept(nt))
            return true;
        String errorMessage = reportSyntaxError(nt);
        throw new QuitParseException(errorMessage);
        //return false;
    }
   
    private boolean containsOP0()
    {
    	if(have(Token.Kind.GREATER_EQUAL))
    		return true;
    	else if(have(Token.Kind.LESSER_EQUAL))
    		return true;
    	else if(have(Token.Kind.NOT_EQUAL))
    		return true;
    	else if(have(Token.Kind.EQUAL))
    		return true;
    	else if(have(Token.Kind.LESS_THAN))
    		return true;
    	else if(have(Token.Kind.GREATER_THAN))
    		return true;
    	return false;
    }
    
    private boolean containsOP1()
    {
    	if(have(Token.Kind.ADD))
    		return true;
    	else if(have(Token.Kind.SUB))
    		return true;
    	else if(have(Token.Kind.OR))
    		return true;
    	return false;
    }
    
    private boolean containsOP2()
    {
    	if(have(Token.Kind.MUL))
    		return true;
    	else if(have(Token.Kind.DIV))
    		return true;
    	else if(have(Token.Kind.AND))
    		return true;
    	return false;
    }
    
 // Grammar Rules =====================================================
    
    private void op0()
    {
    	enterRule(NonTerminal.OP0);
    	
    	if(accept(Token.Kind.GREATER_EQUAL))
    		;
    	else if(accept(Token.Kind.LESSER_EQUAL))
    		;
    	else if(accept(Token.Kind.NOT_EQUAL))
    		;
    	else if(accept(Token.Kind.EQUAL))
    		;
    	else if(accept(Token.Kind.GREATER_THAN))
    		;
    	else if(accept(Token.Kind.LESS_THAN))
    		;
    	
    	exitRule(NonTerminal.OP0);
    }
    
    private void op1()
    {
    	enterRule(NonTerminal.OP1);
    	
    	if(accept(Token.Kind.ADD))
    		;
    	else if(accept(Token.Kind.SUB))
    		;
    	else if(accept(Token.Kind.OR))
    		;
    	
    	exitRule(NonTerminal.OP1);
    }
    
    private void op2()
    {
    	enterRule(NonTerminal.OP2);
    	
    	if(accept(Token.Kind.MUL))
    		;
    	else if(accept(Token.Kind.DIV))
    		;
    	else if(accept(Token.Kind.AND))
    		;
    	    	
    	exitRule(NonTerminal.OP2);
    }
    
    // literal := INTEGER | FLOAT | TRUE | FALSE .
    public void literal()
    {
    	enterRule(NonTerminal.LITERAL);
    	
        if(accept(Token.Kind.INTEGER))
        	;
        else if(accept(Token.Kind.FLOAT))
        	;
        else if(accept(Token.Kind.TRUE))
        	;
        else if(accept(Token.Kind.FALSE))
        	;
        
        exitRule(NonTerminal.LITERAL);
    }
    
    // designator := IDENTIFIER { "[" expression0 "]" } .
    public void designator()
    {
        enterRule(NonTerminal.DESIGNATOR);

        tryResolveSymbol(this.currentToken);
        
        expect(Token.Kind.IDENTIFIER);
        while (accept(Token.Kind.OPEN_BRACKET)) {
            expression0();
            expect(Token.Kind.CLOSE_BRACKET);
        }
        
        exitRule(NonTerminal.DESIGNATOR);        
    }

    public void expression0() 
    {
    	enterRule(NonTerminal.EXPRESSION0);
    	
    	expression1();
 
    	if(containsOP0())
    	{
    		op0();
    		expression1();
    	}
    	
    	exitRule(NonTerminal.EXPRESSION0);
	}

    public void expression1()
    {
    	enterRule(NonTerminal.EXPRESSION1);
    	
    	expression2();
    	
    	while(containsOP1())
    	{
    		op1();
    		expression2();
    	}
    	
    	exitRule(NonTerminal.EXPRESSION1);
    }
    
    public void expression2()
    {
    	enterRule(NonTerminal.EXPRESSION2);
    	
    	expression3();
    	
    	while(containsOP2())
    	{
    		op2();
    		expression3();
    	}
    	
    	exitRule(NonTerminal.EXPRESSION2);
    }
    
    public void expression3()
    {
    	enterRule(NonTerminal.EXPRESSION3);
    	
    	if(accept(Token.Kind.NOT))
    		expression3();
    	else if(accept(Token.Kind.OPEN_PAREN))
    	{
    		expression0();
    		expect(Token.Kind.CLOSE_PAREN);
    	}
    	else if(have(Token.Kind.IDENTIFIER))
    	{
    		designator();
    	}
    	else if(have(Token.Kind.CALL))
    		call_expression();
    	else
    		literal();
    	
    	exitRule(NonTerminal.EXPRESSION3);
    }
    
    public void call_expression()
    {
    	enterRule(NonTerminal.CALL_EXPRESSION);
    	
    	expect(Token.Kind.CALL);
    	
    	tryResolveSymbol(this.currentToken);
    	
    	expect(Token.Kind.IDENTIFIER);
    	expect(Token.Kind.OPEN_PAREN);
    	expression_list();
    	expect(Token.Kind.CLOSE_PAREN);
    	
    	exitRule(NonTerminal.CALL_EXPRESSION);
    }
    
    public void call_statement()
    {
    	enterRule(NonTerminal.CALL_STATEMENT);
    	
    	call_expression();
    	expect(Token.Kind.SEMICOLON);
    	
    	exitRule(NonTerminal.CALL_STATEMENT);
    }
    
    public void if_statement()
    {
    	enterRule(NonTerminal.IF_STATEMENT);
    	
    	enterScope();
    	
    	expect(Token.Kind.IF);
    	expression0();
    	statement_block();
    	
    	exitScope();
    	enterScope();
    	
    	if(accept(Token.Kind.ELSE))
    		statement_block();
    	
    	exitScope();
    	
    	exitRule(NonTerminal.IF_STATEMENT);
    }
    
    public void while_statement()
    {
    	enterRule(NonTerminal.WHILE_STATEMENT);
    	
    	enterScope();
    	
    	expect(Token.Kind.WHILE);
    	expression0();
    	statement_block();
    	
    	exitScope();
    	
    	exitRule(NonTerminal.WHILE_STATEMENT);
    }
    
    public void return_statement()
    {
    	enterRule(NonTerminal.RETURN_STATEMENT);
    	
    	expect(Token.Kind.RETURN);
    	expression0();
    	expect(Token.Kind.SEMICOLON);
    	
    	exitRule(NonTerminal.RETURN_STATEMENT);
    }
    
    public void expression_list()
    {
    	enterRule(NonTerminal.EXPRESSION_LIST);
    	
    	if(have(Token.Kind.NOT) || have(Token.Kind.IDENTIFIER) ||
    			have(Token.Kind.CALL) || have(Token.Kind.INTEGER) ||
    			have(Token.Kind.FLOAT) || have(Token.Kind.TRUE) ||
    			have(Token.Kind.FALSE))
    		expression0();
    	
    	while(accept(Token.Kind.COMMA))
    		expression0();
    	
    	exitRule(NonTerminal.EXPRESSION_LIST);
    }
    
    public void declaration_list()
    {
    	enterRule(NonTerminal.DECLARATION_LIST);
    	
    	while(have(Token.Kind.VAR) || have(Token.Kind.ARRAY) || have(Token.Kind.FUNC))
    	{
    		
    		declaration();
    		
    	}
    	
    	
    	exitRule(NonTerminal.DECLARATION_LIST);
    }
    
    public void declaration()
    {
    	enterRule(NonTerminal.DECLARATION);
    	
    	if(have(Token.Kind.VAR))
    		variable_declaration();
    	else if(have(Token.Kind.ARRAY))
    		array_declaration();
    	else if(have(Token.Kind.FUNC))
    		function_definition();
    	
    	exitRule(NonTerminal.DECLARATION);
    }
    
    public void variable_declaration()
    {
    	enterRule(NonTerminal.VARIABLE_DECLARATION);
    	
    	expect(Token.Kind.VAR);
    	
    	tryDeclareSymbol(this.currentToken);
    	
    	expect(Token.Kind.IDENTIFIER);
    	expect(Token.Kind.COLON);
    	type();
    	expect(Token.Kind.SEMICOLON);
    	
    	exitRule(NonTerminal.VARIABLE_DECLARATION);
    }
    
    public void array_declaration()
    {
    	enterRule(NonTerminal.ARRAY_DECLARATION);
    	
    	expect(Token.Kind.ARRAY);
    	
    	tryDeclareSymbol(this.currentToken);
    	
    	expect(Token.Kind.IDENTIFIER);
    	expect(Token.Kind.COLON);
    	type();
    	expect(Token.Kind.OPEN_BRACKET);
    	expect(Token.Kind.INTEGER);
    	expect(Token.Kind.CLOSE_BRACKET);
    	
    	while(accept(Token.Kind.OPEN_BRACKET))
    	{
    		expect(Token.Kind.INTEGER);
    		expect(Token.Kind.CLOSE_BRACKET);
    	}
    	
    	expect(Token.Kind.SEMICOLON);
    	
    	exitRule(NonTerminal.ARRAY_DECLARATION);
    }
    
    public void function_definition()
    {
    	enterRule(NonTerminal.FUNCTION_DEFINITION);
    	
    	expect(Token.Kind.FUNC);
    	
    	tryDeclareSymbol(this.currentToken);
    	
    	expect(Token.Kind.IDENTIFIER);
    	
    	enterScope();
    	
    	expect(Token.Kind.OPEN_PAREN);
    	parameter_list();
    	expect(Token.Kind.CLOSE_PAREN);
    	expect(Token.Kind.COLON);
    	type();
    	statement_block();
    	
    	exitScope();
    	exitRule(NonTerminal.FUNCTION_DEFINITION);
    }
  
    public void parameter_list()
    {
    	enterRule(NonTerminal.PARAMETER_LIST);
    	
    	if(have(Token.Kind.IDENTIFIER))
    		parameter();
    	
    	while(accept(Token.Kind.COMMA))
    		parameter();
    
    	exitRule(NonTerminal.PARAMETER_LIST);
    }
    
    public void parameter()
    {
    	enterRule(NonTerminal.PARAMETER);
    	
    	tryDeclareSymbol(this.currentToken);
    	
    	expect(Token.Kind.IDENTIFIER);
    	expect(Token.Kind.COLON);
    	type();
    	exitRule(NonTerminal.PARAMETER);
    }
    
    public void type()
    {
    	enterRule(NonTerminal.TYPE);
    	exitRule(NonTerminal.TYPE);
    	expect(Token.Kind.IDENTIFIER);
    }
    
    public void statement_block()
    {
    	enterRule(NonTerminal.STATEMENT_BLOCK);
    	
    	expect(Token.Kind.OPEN_BRACE);
    	statement_list();
    	expect(Token.Kind.CLOSE_BRACE);
    	
    	exitRule(NonTerminal.STATEMENT_BLOCK);
    }
    
    public void statement_list()
    {
    	enterRule(NonTerminal.STATEMENT_LIST);
    	
    	while(have(Token.Kind.VAR) || have(Token.Kind.CALL) ||
    			have(Token.Kind.LET) || have(Token.Kind.IF) ||
    			have(Token.Kind.WHILE) || have(Token.Kind.RETURN))
    		statement();
    	
    	exitRule(NonTerminal.STATEMENT_LIST);    	
    }
    
    public void statement()
    {
    	enterRule(NonTerminal.STATEMENT);
    	
    	if(have(Token.Kind.VAR))
    		variable_declaration();
    	else if(have(Token.Kind.CALL))
    		call_statement();
    	else if(have(Token.Kind.LET))
    		assignment_statement();
    	else if(have(Token.Kind.IF))
    		if_statement();
    	else if(have(Token.Kind.WHILE))
    		while_statement();
    	else if(have(Token.Kind.RETURN))
    		return_statement();
    
    	exitRule(NonTerminal.STATEMENT);
    }
    
    public void assignment_statement()
    {
    	enterRule(NonTerminal.ASSIGNMENT_STATEMENT);
    	
    	expect(Token.Kind.LET);
    	designator();
    	expect(Token.Kind.ASSIGN);
    	expression0();
    	expect(Token.Kind.SEMICOLON);
    	
    	exitRule(NonTerminal.ASSIGNMENT_STATEMENT);
    }
    
    
	// program := declaration-list EOF .
    public void program()
    {
    	enterRule(NonTerminal.PROGRAM);
    	
    	while(have(Token.Kind.VAR) || have(Token.Kind.ARRAY) || have(Token.Kind.FUNC))
    		declaration_list();
    	expect(Token.Kind.EOF);
    	
    	exitRule(NonTerminal.PROGRAM);   	
    }
    
    
}
