/**
   DeepHash is a tree data structure made up of nested hashes.  Items
   within the tree are located using a path, which is a list of keys.   
   DeepHash can compute values for non-leaf nodes based on their children.
 */
class DeepHash<K,V> extends Node<K,V>
{
    public var accum :V->V->V;                              // accumulator function
    public var cmp :K->K->Int;                              // sort function

    /**
       create a new tree
    */
    public function new()
    {
        super(this, null, null);                            // root doesn't have a parent or a key
        val = null;
        children = null;
        accum = function(a,b){ return a; }
        cmp = null;                                         // dont sort
    }

    /**
       set a value at the specified path. create nodes as needed
       path variable is modified!
    */
    override public function set(path :List<K>, newVal :V)
    {
        super.set(path, newVal);
    }

    /**
       pre-order traversal of paths, not lazy
    */
    public function getPathIterator()
    {
        var paths = new List<List<K>>();
        if( children != null )
            for( child in children )
                child.getPaths(paths);
        return paths.iterator();
    }

    /**
       pre-order traversal of values, not lazy
    */
    public function getValuesIterator()
    {
        var nodes = new List<V>();
        if( children != null )
            for( child in children )
                child.getValues(nodes);
        return nodes.iterator();
    }
}


private class Node<K,V>
{
    private var key :K;                                     // paths are made up of keys
    private var val :V;                                     // node value
    private var root :DeepHash<K,V>;                        // root of tree
    private var parent :Node<K,V>;                          // this nodes parent, null for root
    private var children :Array<Node<K,V>>;                 // list of child nodes, may be null

    /**
       create a new tree node
    */
    public function new(r, p, k)
    {
        root = r;
        parent = p;
        key = k;
        val = null;
        children = null;
    }

    /**
       set a value at the specified path. create nodes as needed
       path variable is modified!
    */
    public function set(path :List<K>, newVal :V)
    {
        if( path.isEmpty() )
        {
            val = newVal;
            return;
        }
        val = root.accum(val, newVal);

        if( children == null )
            children = new Array<Node<K,V>>();
        var key = path.pop();
        var child = first(children, function(ii) return ii.key==key);
        if( child == null )
        {
            child = new Node<K,V>(root, this, key);
            children.push(child);
        }
        child.set(path, newVal);
    }

    /**
       get the value at the specified path. return null if not found
       path variable is modified!
    */
    public function get(path :List<K>)
    {
        if( path.isEmpty() )
            return val;

        if( children == null )
            return null;

        var key = path.pop();
        var child = first(children, function(ii) return ii.key==key);
        return if( child==null )
            null;
        else
            child.get(path);
    }

    /**
       tell if the tree has a node at the given path
     */
    public function has(path :List<K>)
    {
        if( path.isEmpty() )
            return true;
        if( children == null )
            return false;
        
        var key = path.pop();
        var child = first(children, function(ii) return ii.key==key);
        return if( child==null )
            false;
        else
            child.has(path);
    }

    /**
       builds the path from a node
     */
    private function getPath(?path :List<K>)
    {
        if( path == null )
            path = new List<K>();
        path.push(key);
        if( parent != root )                                // ignore root
            parent.getPath(path);
        return path;
    }

    /**
       pre-order traversal of paths, not lazy
    */
    private function getPaths(paths :List<List<K>>)
    {
        paths.add(getPath());
        if( children != null )
        {
            if( root.cmp != null )
                children.sort( function(a,b) return root.cmp(a.key,b.key) );
            for( child in children )
                child.getPaths(paths);
        }
    }

    /**
       pre-order traversal of values, not lazy
    */
    private function getValues(?nodes)
    {
        nodes.add(val);
        if( children != null )
        {
            if( root.cmp != null )
                children.sort( function(a,b) return root.cmp(a.key,b.key) );
            for( child in children )
                child.getValues(nodes);
        }
    }

    /**
       utility to find the first item that matches in a list
    */
    private static function first<A>(it:Iterable<A>, f:A->Bool)
    {
        for( ii in it )
            if( f(ii) )
                return ii;
        return null;
    }
}
