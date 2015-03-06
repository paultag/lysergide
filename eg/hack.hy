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

(defn piano [keys align]
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
    (print "Playing" (. root -tone-name) "IIm7-V7-Imaj7")

    (l/let [[(, II V I) (.notes (MajorScale root) [2 5 1])]
            [IIm7  (II.chord MINOR_SEVENTH)]
            [V7    (V.chord DOMINANT_SEVENTH)]
            [Imaj7 (I.chord  MAJOR_SEVENTH)]]

      (go (piano IIm7 0))
      (go (piano IIm7 1))
      (go (piano IIm7 1.5))

      (go (piano V7 4))
      (go (piano V7 5))
      (go (piano V7 5.5))

      (go (piano Imaj7 8))
      (go (piano Imaj7 9))
      (go (piano Imaj7 9.5))))
  
  (l/defn get-jazzy [beat iter]
    (go (groove (next iter)))
    (recurse/beats 12 iter))

  (yield-from (get-jazzy 0 (.acending (MajorScale (Tone.from-string 'C2))))))

;;;;;;;;;;;;;;;;;;
(*piano.shutdown)
