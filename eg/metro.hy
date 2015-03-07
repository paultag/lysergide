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

;;;;;;;;;;;;;;;;;;


(l/main
  (l/fn% [beat]
    (if (in beat [3])
      (yield-from
        (*piano.chord 0
          (map (fn [x] (x.to-midi))
               (.chord (Tone.from-string 'C3) DOMINANT_SEVENTH))
          80 5)))))

;;;;;;;;;;;;;;;;;;
(*piano.shutdown)
