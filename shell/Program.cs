using System;
using System.Diagnostics;
using clojure.lang;
using clojure.clr.api;

namespace shell_repl
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
            Log($" clojure.core/load-file found.");

            IFn printEx = Clojure.var("clojure.stacktrace", "print-cause-trace");
            Log($" clojure.stacktrace/print-stack-trace found.");

            var script = args[0];
            Log($" (load-file '{script}') starting...");
            try
            {
                load.invoke(script);
                Log($" (load-file '{script}') done.");
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                printEx.invoke(ex);
            }

            Log("done.");
        }

        static void Main(string[] args)
        {
            new Program().Run(args);
        }
    }
}