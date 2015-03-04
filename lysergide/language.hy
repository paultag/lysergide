;;;
;;;
;;;

(import [muse.tone [Tone]]
        [muse.chords [MAJOR MAJOR_SEVENTH]])

(defmacro fn/coroutine [sig &rest body]
  `(with-decorator asyncio.coroutine (fn [~@sig] ~@body)))

(defmacro lysergide/time [time order]
  "compute the time defined by the time/order"

  (cond [(= order 'miliseconds) (* time 0.001)]
        [(= order 'miliseconds) (* time 0.001)]
        [(= order 'seconds)     (* time 1)]
        [(= order 'second)      (* time 1)]
        [(= order 'minutes)     (* time 60)]
        [(= order 'minute)      (* time 60)]
        [(= order 'hours)       (* time 3600)]
        [(= order 'hour)        (* time 3600)]))


(defmacro in [time order &rest body]
  `(asyncio.async ((fn/coroutine []
    (yield-from (asyncio.sleep (lysergide/time ~time ~order)))
    ~@body))))


(defmacro join [&rest body]
  `(yield-from (asyncio.gather ~@body)))


(defn play-chord* [synth chord]
  (yield-from (.chord synth 0 (map (fn [x] (.to-midi x)) chord) 80 5.0)))

(defmacro play-chord [&rest body]
  `(yield-from (play-chord* synth* ~@body)))

(def *chord-mapping* {:Major MAJOR
                      :Major7 MAJOR_SEVENTH})

(defmacro chord [note intervals] `(chord* [~note ~intervals]))
(defn chord* [els]
  (let [[(, note interval) els]
        [note (slice note 2)]
        [intervals (get *chord-mapping* interval)]]
    (.chord (.from-string Tone note) intervals)))


(def *exports* '[play-chord* chord*])

(defmacro lysergide/fluidsynth [sfont config &rest body]
  `(do (import asyncio
               [lysergide.language [~@*exports*]]
               [fluidsynth.aio [AsyncSynth]])
       (let [[synth* (AsyncSynth ~sfont :config ~config)]
             [loop* (.get-event-loop asyncio)]]
         (.start synth*)
         (.run-until-complete loop* ((fn/coroutine [] ~@body)))
         (.shutdown synth*))))
