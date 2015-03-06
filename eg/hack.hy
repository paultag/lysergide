(require lysergide.language)

(import asyncio
        [random [randint]]
        [muse.tone [Tone]]
        [fluidsynth [AsyncSynth]])


(def *piano (AsyncSynth
             "/home/tag/piano/Grand Piano.sf2"
             :config {"audio.driver" "pulseaudio"
                      "synth.reverb.active" "yes"})) 
(*piano.start)


; IIm7 V7 Imaj7

(defn piano [duration keys align]
    (yield-from (asyncio.sleep (* align (l/time 0.5 seconds))))
    (yield-from
      (*piano.chord 0
        (map (fn [x] (.to-midi x)) keys)
        (randint 75 95) 2)))

(defmacro recurse/beats [beats &rest args]
  `(l/recurse (* ~beats (l/time 0.5 seconds)) (* ~beats (+ beat 1)) ~@args))



(import [muse.scales.major [MajorScale]]
        [muse.chords [MAJOR_SEVENTH DOMINANT_SEVENTH MINOR_SEVENTH]])

;;;;;;;;;;;;;;;;;;

(l/main
  (l/defn groove [root]
    (l/let [[scale (list (.acending (MajorScale root)))]
            [IIm7  (.chord (get scale 1) MINOR_SEVENTH)]
            [V7    (.chord (get scale 4) DOMINANT_SEVENTH)]
            [Imaj7 (.chord (get scale 0) MAJOR_SEVENTH)]]
      (go (piano 5 IIm7 0))
      (go (piano 5 V7 1))
      (go (piano 5 Imaj7 2))))
  
  (l/defn get-jazzy [beat iter]
    (go (groove (next iter)))
    (recurse/beats 4 iter))

  (yield-from (get-jazzy 0 (.acending (MajorScale (Tone.from-string 'C2))))))

;;;;;;;;;;;;;;;;;;
(*piano.shutdown)
