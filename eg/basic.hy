(require lysergide.language)


(lysergide/fluidsynth
  "/home/tag/piano/Grand Piano.sf2"
  {"audio.driver" "pulseaudio"
   "synth.reverb.active" "yes"}
  (yield-from (asyncio.sleep 2))


  (join
    (in 0   seconds (play-chord (chord :D3 :Major7)))
    (in 2   seconds (play-chord (chord :A3 :Major)))
    (in 3   seconds (play-chord (chord :A3 :Major7)))
    (in 4.5 seconds (play-chord (chord :F2 :Major7)))))
