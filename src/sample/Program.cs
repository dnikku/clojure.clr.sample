using System;
using clojure.lang;

namespace sample
{
    public class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Starting...");

            IFn load = clojure.clr.api.Clojure.var("clojure.core", "load");
            load.invoke("some.thing");
        }
    }
}
