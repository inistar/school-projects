package crux;

import java.util.LinkedHashMap;
import java.util.Map;

public class SymbolTable {
    
	private int depth;
	private  LinkedHashMap<String, Symbol> scope;
	private SymbolTable parent = null;
	
    public SymbolTable()
    {
    	this.depth = 0;
    	this.scope = new LinkedHashMap();
    }
    
    public SymbolTable(SymbolTable push)
    {
    	this.depth = push.depth + 1;
    	this.parent = push;
    	this.scope = new LinkedHashMap();
    }
    
    public SymbolTable popSymbolTable()
    {
    	return this.parent;
    }
    
    public Symbol lookup(String name) throws SymbolNotFoundError
    {
    	for (String s : scope.keySet())
    		if(name.equals(s))
    			return scope.get(s);
    			
        if(parent != null)
        	return parent.lookup(name);  
        
        throw new SymbolNotFoundError(name);
    }
       
    public Symbol insert(String name) throws RedeclarationError
    {
    	Symbol temp = new Symbol(name);
    	if(!scope.containsKey(name))
    		scope.put(name, temp);
    	else
    		throw new RedeclarationError(temp);
        return temp;
    }
    
    public String toString()
    {
        StringBuffer sb = new StringBuffer();
        
        if (parent != null)
            sb.append(parent.toString());
        
        String indent = new String();
        for (int i = 0; i < depth; i++) {
            indent += "  ";
        }
        
        for (String s : scope.keySet())
            sb.append(indent + scope.get(s).toString() + "\n");
        
      
        return sb.toString();
    }
}

class SymbolNotFoundError extends Error
{
    private static final long serialVersionUID = 1L;
    private String name;
    
    SymbolNotFoundError(String name)
    {
        this.name = name;
    }
    
    public String name()
    {
        return name;
    }
}

class RedeclarationError extends Error
{
    private static final long serialVersionUID = 1L;

    public RedeclarationError(Symbol sym)
    {
        super("Symbol " + sym + " being redeclared.");
    }
}
