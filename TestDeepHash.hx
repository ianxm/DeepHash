using Lambda;

class TestDeepHash extends haxe.unit.TestCase
{
    public function testSetRoot()
    {
        var tree = new DeepHash<Int, String>();
        tree.set([].list(), "root");
        assertEquals("root", tree.get([].list()));
    }

    public function testSetChild()
    {
        var tree = new DeepHash<Int, String>();
        tree.set([1].list(), "one");
        assertEquals("one", tree.get([1].list()));
    }

    public function testSetChildTwice()
    {
        var tree = new DeepHash<Int, String>();
        tree.set([1].list(), "one");
        tree.set([2].list(), "two");
        assertEquals("one", tree.get([1].list()));
        assertEquals("two", tree.get([2].list()));
    }

    public function testSetTwoDeep()
    {
        var tree = new DeepHash<Int, String>();
        tree.set([1,2].list(), "one.two");
        assertEquals("one.two", tree.get([1,2].list()));
    }

    public function testSiblings()
    {
        var tree = new DeepHash<Int, String>();
        tree.set([1].list(), "one");
        tree.set([2].list(), "two");
        assertEquals("one", tree.get([1].list()));
        assertEquals("two", tree.get([2].list()));
    }

    public function testSetTwoDeepExistingPath()
    {
        var tree = new DeepHash<Int, String>();
        tree.set([1].list(), "one");
        tree.set([1,2].list(), "one.two");
        assertEquals("one", tree.get([1].list()));
        assertEquals("one.two", tree.get([1,2].list()));
    }

    public function testSetOtherTypes()
    {
        var tree = new DeepHash<String, Float>();
        tree.set(["one"].list(), 1.1);
        tree.set(["one","two"].list(), 1.2);
        assertEquals(1.1, tree.get(["one"].list()));
        assertEquals(1.2, tree.get(["one","two"].list()));
    }

    public function testAccum()
    {
        var tree = new DeepHash<String, Float>();
        tree.accum = function(a,b){ return (a==null) ? b : a+b; }
        tree.set(["one"].list(), 1.1);
        tree.set(["one","two"].list(), 1.2);
        assertEquals(2.3, tree.get(["one"].list()));
        assertEquals(1.2, tree.get(["one","two"].list()));
    }

    public function testIteratePaths()
    {
        var tree = new DeepHash<String, Float>();
        tree.set(["one"].list(), 1.1);
        tree.set(["one","two"].list(), 1.2);
        var iter = tree.getPathIterator();
        assertEquals('{one}', iter.next().toString());
        assertEquals('{one, two}', iter.next().toString());
        assertFalse(iter.hasNext());
    }

    public function testIterateValues()
    {
        var tree = new DeepHash<Int, Float>();
        tree.set([1].list(), 1.1);
        tree.set([1,2].list(), 1.2);
        tree.set([1,3].list(), 1.3);
        var iter = tree.getValuesIterator();
        assertEquals(1.1, iter.next());
        assertEquals(1.3, iter.next());
        assertEquals(1.2, iter.next());
        assertFalse(iter.hasNext());
    }

    public function testIterateValuesEmptyParent()
    {
        var tree = new DeepHash<Int, Float>();
        tree.set([1,2].list(), 1.2);
        tree.set([1,3].list(), 1.3);
        var iter = tree.getValuesIterator();
        assertEquals(null, iter.next());
        assertEquals(1.3, iter.next());
        assertEquals(1.2, iter.next());
        assertFalse(iter.hasNext());
    }

    public function testIteratorValuesAccum()
    {
        var tree = new DeepHash<String, Float>();
        tree.accum = function(a,b){ return (a==null) ? b : a+b; }
        tree.set(["one"].list(), 1.1);
        tree.set(["one","two"].list(), 1.2);
        var iter = tree.getValuesIterator();
        assertEquals(2.3, iter.next());
        assertEquals(1.2, iter.next());
        assertFalse(iter.hasNext());
    }

    public function testIteratorValuesAccumEmptyParent()
    {
        var tree = new DeepHash<String, Float>();
        tree.accum = function(a,b){ return (a==null) ? b : a+b; }
        tree.set(["one","two"].list(), 1.2);
        var iter = tree.getValuesIterator();
        assertEquals(1.2, iter.next());
        assertEquals(1.2, iter.next());
        assertFalse(iter.hasNext());
    }
}
