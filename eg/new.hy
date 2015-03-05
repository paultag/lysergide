(require lysergide.language)

(import [random [randint]]
        [muse.tone [Tone]]
        [fluidsynth [AsyncSynth]])


(def piano (AsyncSynth
             "/home/tag/piano/Grand Piano.sf2"
             :config {"audio.driver" "pulseaudio"
                      "synth.reverb.active" "yes"})) 
(piano.start)


(defn play [synth duration keys]
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


;;;;;;;;;;;;;;;;;;


(l/main
  (l/defn foo [beat seq]
    (go (play piano 2 [(first seq)]))
    (recurse/beat (shift seq)))
  (yield-from (foo 0 '[G2 G2 A3 B3])))


;;;;;;;;;;;;;;;;;;
(piano.shutdown)
