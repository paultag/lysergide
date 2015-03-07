;;;
;;;
;;;

(import [muse.tone [Tone]]
        [muse.chords [MAJOR MAJOR_SEVENTH]])


(defmacro/g! l/let [sig &rest body]
  `(yield-from (with-decorator asyncio.coroutine (let [~@sig] ~@body))))


(defmacro/g! l/fn [sig &rest body]
  "Create a lysergide function"
  `(with-decorator asyncio.coroutine
      (defn ~g!self [~@sig]
        (setv *self* ~g!self)
        ~@body)))

(defmacro/g! l/defn [name sig &rest body]
  "Create a lysergide named function"
  `(with-decorator asyncio.coroutine
      (defn ~name [~@sig]
        (setv *self* ~name)
        ~@body)))


(defmacro/g! l/fn% [sig &rest body]
  `(do (metro*.register (l/fn [~@sig] ~@body))))


(defmacro/g! l/recurse [when &rest args]
  "temporally recurse in a lysergide function"
  `(.call_later loop* ~when (fn [] (asyncio.async (*self* ~@args)))))


(defmacro go [what] `(asyncio.async ~what))


(defmacro l/time [time order]
  (cond [(= order 'miliseconds) (* time 0.001)]
        [(= order 'miliseconds) (* time 0.001)]
        [(= order 'seconds)     (* time 1)]
        [(= order 'second)      (* time 1)]
        [(= order 'minutes)     (* time 60)]
        [(= order 'minute)      (* time 60)]
        [(= order 'hours)       (* time 3600)]
        [(= order 'hour)        (* time 3600)]))


(defmacro l/main [&rest body]
  `(do (import asyncio [lysergide.metro [Metronome]])
       (let [[loop* (.get-event-loop asyncio)]
             [metro* (Metronome 110 4)]]
         (asyncio.async ((l/fn [] ~@body)))
         (asyncio.async (metro*))
         (.run-forever loop*))))
