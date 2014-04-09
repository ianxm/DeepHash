import TestDeepHash;

class TestSuite
{
    static function main()
    {
        var r = new haxe.unit.TestRunner();
        r.add(new TestDeepHash());
        r.run();
    }
}
