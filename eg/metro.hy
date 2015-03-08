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

(import [muse.scales.major [MajorScale]]
        [muse.chords [MAJOR_SEVENTH DOMINANT_SEVENTH MINOR_SEVENTH]])

(defmacro play-chord [what notes velocity duration]
  `(yield-from (.chord ~what 0 ~notes ~velocity ~duration)))


;;;;;;;;;;;;;;;;;;


(l/main
  (l/let [[x (list (map (fn [x] (x.to-midi))
      (.chord (Tone.from-string 'D3) DOMINANT_SEVENTH)))]]
    (l/on [0 1 2 3] (play-chord *piano x 80 5))))

;;;;;;;;;;;;;;;;;;
(*piano.shutdown)
