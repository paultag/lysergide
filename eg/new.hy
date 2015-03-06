(require lysergide.language)

(import asyncio
        [random [randint choice]]
        [muse.tone [Tone]]
        [fluidsynth [AsyncSynth]])


(def piano (AsyncSynth
             "/home/tag/piano/Grand Piano.sf2"
             :config {"audio.driver" "pulseaudio"
                      "synth.reverb.active" "yes"})) 
(piano.start)


(defn play [synth duration keys align]
    (yield-from (asyncio.sleep (* align (l/time 0.5 seconds))))
    (yield-from
      (piano.chord 0
        (map (fn [x] (.to-midi x)) (map (fn [x] (Tone.from-string x)) keys))
        (randint 75 95) 2)))

(defmacro recurse/beat [&rest args]
  `(l/recurse (l/time 0.5 seconds) (+ beat 1) ~@args))

(defn shift [l]
  (let [[x (slice l)]
        [f (x.pop 0)]
        [_ (x.append f)]]
    x))


(defn pick/next [els current]
  (choice (list (filter
    (fn [x] (!= x current))
    els))))



;;;;;;;;;;;;;;;;;;

(l/main
  (def *root* ['E2])

  (l/defn foo [beat seq]
    (go (play piano 2 [(first seq)] 0))
    (go (play piano 2 *root* 0.5))

    (if (= (% beat 8) 0)
      (setv (get *root* 0)
        (pick/next '[E2 D2 C2] (get *root* 0))))

    (recurse/beat (shift seq)))
  (yield-from (foo 0 '[G2 G2 A3 B3])))

;;;;;;;;;;;;;;;;;;
(piano.shutdown)
