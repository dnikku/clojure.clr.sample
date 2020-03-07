using System;
using System.Diagnostics;
using clojure.lang;
using clojure.clr.api;

namespace sample
{
    public class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine($"{DateTime.Now}: Starting...");

            IFn load = null;
            Time(() => load = Clojure.var("clojure.core", "load-file"), "load");

            try
            {
                Time(() => load.invoke("src/sample/hello-world.clj"), "hello-world.clj");
            }
            finally
            {
                Console.WriteLine($"{DateTime.Now}: done.");
            }
        }

        public static void Time(Action action, string actionName)
        {
            var stopwatch = Stopwatch.StartNew();
            try
            {
                action();
            }
            finally
            {
                stopwatch.Stop();
                Console.WriteLine($"{actionName} took:{stopwatch.Elapsed}");
            }
        }
    }
}