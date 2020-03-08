using System;
using System.Diagnostics;
using clojure.lang;
using clojure.clr.api;

namespace sample
{
    class Program
    {
        private readonly Stopwatch start = Stopwatch.StartNew();

        void Log(string message) =>
            Console.WriteLine($"{start.ElapsedMilliseconds,5:N0}: {message}");


        void Run(string[] args)
        {
            Log($"starting...");
            Log($" CLOJURE_LOAD_PATH={Environment.GetEnvironmentVariable("CLOJURE_LOAD_PATH")}");

            IFn load = Clojure.var("clojure.core", "load-file");
            Log($" clojure.load done.");

            load.invoke("./hello-world.clj");
            Log($" ./hello-world.clj done.");

            Log("done.");
        }

        static void Main(string[] args)
        {
            new Program().Run(args);
        }
    }
}