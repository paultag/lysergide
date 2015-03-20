(require lysergide.language)

(import asyncio
        [muse.tone [Tone]]
        [fluidsynth [AsyncSynth]])


(def *kit (AsyncSynth
             "/home/tag/drum/198-JB KiT.sf2"
             :config {"audio.driver" "pulseaudio"}))
(*kit.start)


(defmacro $ [instrument offset]
  `(go ((l/fn [] (yield-from (asyncio.sleep ~offset))
                 (yield-from (*kit.note 0 ~instrument 80 5))))))


(defmacro drum/seq [&rest vals]
  (let [[stream []]
        [instruments (list (map first vals))]
        [on  '▣]
        [off '□]]
    (for [(, instrument sequence) vals]
      (for [(, seq v) (enumerate sequence)]
        (if (= v on)
          (stream.append `(do ($ ~instrument ~(* seq 0.5)))))))

    `(do (import [muse.percussion [~@instruments]])
         (while true
            (print "start")
           (yield-from (asyncio.gather ~@stream))))))


(l/main

  (drum/seq
    [BASS_DRUM_1    [▣ ▣ ▣ ▣ □ □ □ □ ]]
    [SPLASH_CYMBAL  [▣ □ ▣ □ ▣ □ ▣ □ ]]
))



;;;;;;;;;;;;;;;;;;
(*kit.shutdown)
