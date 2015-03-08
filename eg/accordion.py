import sys
import urwid
import asyncio

from muse.tone import Tone
from muse.chords import MAJOR, MINOR
from muse.intervals import MAJOR_THIRD, PERFECT_FIFTH, PERFECT_FOURTH

from fluidsynth import AsyncSynth


piano = AsyncSynth("/home/tag/piano/Grand Piano.sf2", config={
    "audio.driver": "pulseaudio",
    "synth.reverb.active": "yes",
})
piano.start()


def generate_tones(tone):
    tones = {}
    rows = ["1234567890-=",  # Third
            "qwertyuiop[]",  # Root
            "asdfghjkl;'?",   # Major
            "zxcvbnm,./??",]   # Minor

    fifths = [
        PERFECT_FIFTH,
        -PERFECT_FOURTH,
        PERFECT_FIFTH,
        -PERFECT_FOURTH,
        PERFECT_FIFTH,
        -PERFECT_FOURTH,
        -PERFECT_FOURTH,
        PERFECT_FIFTH,
        -PERFECT_FOURTH,
        PERFECT_FIFTH,
        -PERFECT_FIFTH,
        -PERFECT_FIFTH,
    ]

    for ni, third, root, major, minor in zip(fifths, *rows):
        tones[third] = [tone.relative_tone(MAJOR_THIRD)]
        tones[root] = [tone]
        tones[major] = tone.chord(MAJOR)[1:]
        tones[minor] = tone.chord(MINOR)[1:]

        tone = tone.relative_tone(ni)

    return {x: [z.to_midi() for z in v] for x, v in tones.items()}


TONES = generate_tones(Tone.from_string("A2"))


def handle(key):
    if key in ('q', 'Q'):
        raise urwid.ExitMainLoop()

    @asyncio.coroutine
    def play(chord):
        yield from piano.chord(0, chord, 80, 0.75)

    if key in TONES:
        asyncio.async(play(TONES[key]))


txt = urwid.Text(u"Hello World")
fill = urwid.Filler(txt, 'top')
evl = urwid.AsyncioEventLoop(loop=asyncio.get_event_loop())
loop = urwid.MainLoop(fill, event_loop=evl, unhandled_input=handle)

loop.run()
piano.shutdown()
