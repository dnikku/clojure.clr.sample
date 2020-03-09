(require '[clojure.core.server :as s])

(println "Starting server: localhost:8090 ...")

(try
;; 
  (s/start-server {:name "shell" :port 8090 :accept 'clojure.core.server/repl})

  (println "Press <CR> to stop server.")
  (read-line)

  (catch Exception ex
    (.printStackTrace ex)))